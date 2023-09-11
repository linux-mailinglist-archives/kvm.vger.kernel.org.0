Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD02179B8A6
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbjIKUri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236725AbjIKLPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 07:15:55 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B52CE5
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 04:15:51 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id 006d021491bc7-573449a364fso2826900eaf.1
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 04:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694430950; x=1695035750; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdc5E14LhEXwfEKTYcmcAb8UaBAI6Gd6db9kqJWLZf8=;
        b=IP62h/c8Lf+PyM3+1sTaznOCuYYzi5VT2BPOZaf+p5VeEOzYCwxEHT65LPBsEfZogY
         BAkUaCm0CSzwhCXdjQrh5dnbnu/DlKqq22Yn9MwYgk+OK8mTyJRZ94EviPguiBBqzRJf
         LCvDLiM5Pw3O5j4/YGPNVvHWH7PLXY8kS+Ir2TS4R8IAmNtpz/WaU3sRO1NJjei5v1ww
         1MsVJV8pbF2BzEJEa4ooFuRStk6JIQQ181W3DadVAl9rdLjo1hjuJedYMfOKkhf7qXJq
         5VMzSXEGk1FM3pxLEiQ4ZI2sWS9ET0n9dFffM5sxLSP5wKNANRXhVjrXAZb0AJUCVKMA
         iM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694430950; x=1695035750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kdc5E14LhEXwfEKTYcmcAb8UaBAI6Gd6db9kqJWLZf8=;
        b=rarp/d77dLuu4vpTGfIU0bIqEuA2/SzPhznTUe+qduwku1x9HR0miU6AKVE6DoxCtU
         Udsoasai0twVgHwKuiOzz1ey/pkR9hArqdB5utfODxbE6ErZ7AARoTmTSN/IouVvxDBj
         deZAySWNSsoaT6fnqU0KS9aYAyILwYg+tn5+n4STy8vgkJZSD6aPuCjG3PAGYrj0uyAz
         Vc7uUPOAT1Qzo1ZYCgEmdXFkTqaTtV8rZxQAImNGU9KJnmHt+reUvoWRUK35fGCnptvG
         WJ5rWKxOOmlEcq1QT7HRj9fve4yIcGHPyBcQzQbPPiAPPiOVYgYJIsm4cyCu0h9Qscj/
         04kg==
X-Gm-Message-State: AOJu0YzwVqOUUgg41X8/z2LwwJdZMGFzOr2ivXDRlPc4yYXo05uM+G8C
        mumFjNpeyTc/gWHmc54YcdM0NJimEVXcQc+0I8Y=
X-Google-Smtp-Source: AGHT+IG5fn2r+CZXTQswNTv5o7+j06b8HcxylfS5GopnmziRRoq5CFLnhStHdBfjOU0thzFJ80D+0yHOWkBr0RKaP/Y=
X-Received: by 2002:a4a:3906:0:b0:56d:2229:5f94 with SMTP id
 m6-20020a4a3906000000b0056d22295f94mr9256893ooa.6.1694430950243; Mon, 11 Sep
 2023 04:15:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230911103832.23596-1-philmd@linaro.org>
In-Reply-To: <20230911103832.23596-1-philmd@linaro.org>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Mon, 11 Sep 2023 07:15:38 -0400
Message-ID: <CAJSP0QWDcNhso5nNBMNziLSXZczcrGp=6FgGNOXvYEQ6=Giiug@mail.gmail.com>
Subject: Re: [PATCH] target/i386: Re-introduce few KVM stubs for Clang debug builds
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc:     qemu-devel@nongnu.org,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Sept 2023 at 06:39, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.o=
rg> wrote:
>
> Since commits 3adce820cf..ef1cf6890f, When building on
> a x86 host configured as:
>
>   $ ./configure --cc=3Dclang \
>     --target-list=3Dx86_64-linux-user,x86_64-softmmu \
>     --enable-debug
>
> we get:
>
>   [71/71] Linking target qemu-x86_64
>   FAILED: qemu-x86_64
>   /usr/bin/ld: libqemu-x86_64-linux-user.fa.p/target_i386_cpu.c.o: in fun=
ction `cpu_x86_cpuid':
>   cpu.c:(.text+0x1374): undefined reference to `kvm_arch_get_supported_cp=
uid'
>   /usr/bin/ld: libqemu-x86_64-linux-user.fa.p/target_i386_cpu.c.o: in fun=
ction `x86_cpu_filter_features':
>   cpu.c:(.text+0x81c2): undefined reference to `kvm_arch_get_supported_cp=
uid'
>   /usr/bin/ld: cpu.c:(.text+0x81da): undefined reference to `kvm_arch_get=
_supported_cpuid'
>   /usr/bin/ld: cpu.c:(.text+0x81f2): undefined reference to `kvm_arch_get=
_supported_cpuid'
>   /usr/bin/ld: cpu.c:(.text+0x820a): undefined reference to `kvm_arch_get=
_supported_cpuid'
>   /usr/bin/ld: libqemu-x86_64-linux-user.fa.p/target_i386_cpu.c.o:cpu.c:(=
.text+0x8225): more undefined references to `kvm_arch_get_supported_cpuid' =
follow
>   clang: error: linker command failed with exit code 1 (use -v to see inv=
ocation)
>   ninja: build stopped: subcommand failed.
>
> '--enable-debug' disables optimizations (CFLAGS=3D-O0).
>
> While at this (un)optimization level GCC eliminate the
> following dead code:
>
>   if (0 && foo()) {
>       ...
>   }
>
> Clang does not. Therefore restore a pair of stubs for
> unoptimized Clang builds.
>
> Reported-by: Kevin Wolf <kwolf@redhat.com>
> Fixes: 3adce820cf ("target/i386: Remove unused KVM stubs")
> Fixes: ef1cf6890f ("target/i386: Allow elision of kvm_hv_vpindex_settable=
()")
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
>  target/i386/kvm/kvm_i386.h | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
> index 55d4e68c34..0b62ac628f 100644
> --- a/target/i386/kvm/kvm_i386.h
> +++ b/target/i386/kvm/kvm_i386.h
> @@ -32,7 +32,6 @@
>
>  bool kvm_has_smm(void);
>  bool kvm_enable_x2apic(void);
> -bool kvm_hv_vpindex_settable(void);
>  bool kvm_has_pit_state2(void);
>
>  bool kvm_enable_sgx_provisioning(KVMState *s);
> @@ -41,8 +40,6 @@ bool kvm_hyperv_expand_features(X86CPU *cpu, Error **er=
rp);
>  void kvm_arch_reset_vcpu(X86CPU *cs);
>  void kvm_arch_after_reset_vcpu(X86CPU *cpu);
>  void kvm_arch_do_init_vcpu(X86CPU *cs);
> -uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
> -                                      uint32_t index, int reg);
>  uint64_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index)=
;
>
>  void kvm_set_max_apic_id(uint32_t max_apic_id);
> @@ -60,6 +57,10 @@ void kvm_put_apicbase(X86CPU *cpu, uint64_t value);
>
>  bool kvm_has_x2apic_api(void);
>  bool kvm_has_waitpkg(void);
> +bool kvm_hv_vpindex_settable(void);
> +
> +uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
> +                                      uint32_t index, int reg);
>
>  uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address);
>  void kvm_update_msi_routes_all(void *private, bool global,
> @@ -76,6 +77,20 @@ typedef struct kvm_msr_handlers {
>  bool kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
>                      QEMUWRMSRHandler *wrmsr);
>
> +#elif defined(__clang__) && !defined(__OPTIMIZE__)

Another approach is a static library with a .o file containing the
stubs so the linker only includes it in the executable if the compiler
emitted the symbols. That way there is no need for defined(__clang__)
&& !defined(__OPTIMIZE__) and it will work with other
compilers/optimization levels. It's more work to set up though.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
