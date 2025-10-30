# Random Users - Teste Técnico

Aplicação Flutter desenvolvida como teste técnico, demonstrando habilidades em arquitetura limpa, gerenciamento de estado e boas práticas de desenvolvimento. O app consome a API [Random User Generator](https://randomuser.me/) para exibir usuários aleatórios em tempo real, permitindo visualizar detalhes e salvar favoritos localmente.

## 📱 Funcionalidades

- **Lista Dinâmica**: Carregamento automático de novos usuários a cada 5 segundos
- **Detalhes do Usuário**: Visualização completa de informações pessoais, localização e login
- **Persistência Local**: Salvamento de usuários favoritos com SQLite
- **Animações Fluidas**: Transições suaves e experiência visual refinada
- **Tratamento de Erros**: Estados visuais para loading, erro e lista vazia

## 🛠️ Tecnologias

### Core
- **Flutter 3.9.2** - Framework
- **Dart** - Linguagem

### Arquitetura & Estado
- **flutter_bloc 8.1.6** - Gerenciamento de estado com Cubit
- **get_it 8.2.0** - Injeção de dependências
- **equatable 2.0.5** - Comparação de objetos imutáveis

### Rede & Persistência
- **dio 5.9.0** - Cliente HTTP
- **sqflite_common_ffi 2.3.0** - Banco de dados local SQLite
- **pretty_dio_logger 1.4.0** - Logs de requisições

### UI & UX
- **cached_network_image 3.4.1** - Cache de imagens
- **flutter_animate 4.5.2** - Sistema de animações
- **ticker 0.3.1** - Gerenciamento de atualizações periódicas

### Testes
- **flutter_test** - Framework de testes
- **bloc_test 9.1.7** - Testes de Cubits/Blocs
- **mocktail 1.0.4** - Mocking para testes

## 🏗️ Arquitetura

Este projeto segue a arquitetura recomendada pelo Flutter em seu [caso de estudo](https://docs.flutter.dev/app-architecture/case-study), organizando as camadas de forma modular e escalável. A estrutura está dividida em:

```
lib
|____ui
| |____core
| | |____ui
| | | |____<shared widgets>
| | |____themes
| |____<FEATURE NAME>
| | |____view_model
| | | |_____<view_model class>.dart
| | |____widgets
| | | |____<feature name>_screen.dart
| | | |____<other widgets>
|____domain
| |____models
| | |____<model name>.dart
|____data
| |____repositories
| | |____<repository class>.dart
| |____services
| | |____<service class>.dart
| |____model
| | |____<api model class>.dart
|____config
|____utils
|____routing
|____main_staging.dart
|____main_development.dart
|____main.dart

// The test folder contains unit and widget tests
test
|____data
|____domain
|____ui
|____utils
```
A separação em **Camada de Dados (```data```)**, **Domínio (```domain```)** e **Apresentação (```ui```)** permite maior flexibilidade, testabilidade e escalabilidade do projeto.

## 🔄 Gerenciamento de Estado com Cubit

O projeto utiliza **Flutter BLoC** (especificamente Cubit) como padrão para controle de estado, garantindo um fluxo de dados previsível e reativo.

### 📌 Exemplo de Cubit para Usuários

**Estados do HomeCubit:**

```dart
class HomeState extends Equatable {
  final AppStatus status;
  final String errorMessage;
  final List<UserEntity> users;
  
  const HomeState({
    required this.status, 
    required this.users, 
    required this.errorMessage
  });

  factory HomeState.initial() => HomeState(
    status: AppStatus.initial, 
    users: [], 
    errorMessage: ''
  );

  bool get isEmpty => status == AppStatus.success && users.isEmpty;
  bool get isLoading => status == AppStatus.loading;

  @override
  List<Object?> get props => [status, users, errorMessage];

  HomeState copyWith({
    AppStatus? status, 
    List<UserEntity>? users, 
    String? errorMessage
  }) {
    return HomeState(
      errorMessage: errorMessage ?? this.errorMessage,
      users: users ?? this.users,
      status: status ?? this.status,
    );
  }
}
```

**Estados Possíveis (AppStatus):**
```dart
enum AppStatus { initial, success, error, loading }
```

### Lógica de Negócio e Busca de Dados

```dart
class HomeCubit extends Cubit<HomeState> {
  final UserRepositoryProtocol _userRepository;
  final TickerManagerProtocol _tickerManager;

  HomeCubit({
    required UserRepositoryProtocol userRepository, 
    required TickerManagerProtocol tickerManager
  }) : _tickerManager = tickerManager,
       _userRepository = userRepository,
       super(HomeState.initial());

  void startUserFetching(TickerProvider vsync) {
    _tickerManager.onTick = fetchUsers;
    _tickerManager.start(vsync);
  }

  Future<void> fetchUsers() async {
    emit(state.copyWith(status: AppStatus.loading));
    
    _userRepository.getUser(
      success: (user) {
        emit(state.copyWith(
          status: AppStatus.success, 
          users: [...state.users, user]
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: AppStatus.error, 
          errorMessage: 'Erro ao carregar usuários: ${error.toString()}'
        ));
      },
    );
  }

  void clearUsers() {
    emit(state.copyWith(status: AppStatus.initial, users: []));
  }
}
```


## 🧪 Testes

Cobertura abrangente com testes unitários e de widgets:

### Testes Unitários
- **Cubits**: Verificação de estados e lógica de negócio
- **Repositories**: Fluxo de dados entre camadas
- **Services**: Integração com API e banco de dados
- **Core**: TickerManager para atualizações periódicas

### Testes de Widget
- **Componentes UI**: AppBar, EmptyState, ErrorState, UserItem
- **Animações**: Fade e Slide transitions

```bash
# Executar todos os testes
flutter test

# Testes com cobertura
flutter test --coverage
```

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK 3.9.2 ou superior
- Dart SDK

### Instalação

```bash
# Clone o repositório
git clone <repository-url>

# Instale as dependências
flutter pub get

# Execute o app
flutter run
```

🚀 Agora é só testar e expandir a aplicação!

