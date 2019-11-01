Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB5DEC87C
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 19:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfKAS3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 14:29:35 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34804 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbfKAS3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 14:29:34 -0400
Received: by mail-io1-f66.google.com with SMTP id q1so11913088ion.1
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 11:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9TFUU0VzHDXJnyCpiU6F6S+f4IqiuMpQ1VoUi3wfR0c=;
        b=MaxHt/+mx78gQBGBk76n6MGcKzQD/d2Q//mL/eFBppnw/fSrPNexufzC/trzGpMows
         +NxstIC6SvnZoYWezP6XxWiIkGMuzmdIvVxi7TurEd4laj8KpnvVjYhM6kWx+CwVbiQg
         nb6VUf/cgygiG7jtOV8zbWD8D64Md/6xPzEOYve7x8YaiHo7cgpuHhP5PXo5Qh1DFpzn
         zvmPxvv9GtfDIk4zkyaw6iilTXIdBdeRf1WH4KTQKalfPuoUVikvDYCkId6S0hs9D2JN
         1B5FCy+WJMm8ipl19rAxxRjJ/eZLBerMOSr9G2r7TOkTdY0QpG83DZeieQ7bb1N66DKF
         nNmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9TFUU0VzHDXJnyCpiU6F6S+f4IqiuMpQ1VoUi3wfR0c=;
        b=Gg/7UhIIVgHdphM5yprA6Y4RiXbonThYiCSBur/oYeNIPqhvw7beEanpBvbtK4f/BB
         8FK6aK4pxwgqHu7aOGX/M5lg4lBDOwNEuQyXdYFnH0lfbXepAkXdHKwy16IuCoGmgeWT
         Nzdch9MaJ+49yWAsJmeQOOhLUhIkWF2MhB1Xa8aiVh091Tzxv2zHv9OoAdDVVrklNaZt
         g/Cp6eJ694xp57rNht0LvIopYvAJ+fGMvUXj/114Dr/opwVqflN8voz2WTyshFhXyPOD
         art7fhOOmdsttpZ71InZ09ltvv+8Umlhai3FZIES7FOE7cof/ZhSWHFavRVM2zcaoxZD
         wHcw==
X-Gm-Message-State: APjAAAUNkoVjQqDrRyfXt0bH1ttRWP+CEy6hvXnPHMfrmQ6ZwDoZEQpZ
        evZ4s9p/fBikZpP+IKGlAsG3RzEioV1Y/SEwLSu3PQ==
X-Google-Smtp-Source: APXvYqzyPELcJRJA3nMkmapdmScZGN/ssHdPP+UN3xZEGE0xW/JvB+kQlDAhixvAMBGT15CYnNzHe3AmR2jC03wcJUs=
X-Received: by 2002:a5d:8d8f:: with SMTP id b15mr11847661ioj.296.1572632973507;
 Fri, 01 Nov 2019 11:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <157262960837.2838.17520432516398899751.stgit@naples-babu.amd.com> <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
In-Reply-To: <157262962352.2838.15656190309312238595.stgit@naples-babu.amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 1 Nov 2019 11:29:22 -0700
Message-ID: <CALMp9eQT=a99YhraQZ+awMKOWK=3tg=m9NppZnsvK0Q1PWxbAw@mail.gmail.com>
Subject: Re: [PATCH 2/4] kvm: svm: Enable UMIP feature on AMD
To:     "Moger, Babu" <Babu.Moger@amd.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "nayna@linux.ibm.com" <nayna@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 1, 2019 at 10:33 AM Moger, Babu <Babu.Moger@amd.com> wrote:
>
> AMD 2nd generation EPYC processors support UMIP (User-Mode Instruction
> Prevention) feature. The UMIP feature prevents the execution of certain
> instructions if the Current Privilege Level (CPL) is greater than 0.
> If any of these instructions are executed with CPL > 0 and UMIP
> is enabled, then kernel reports a #GP exception.
>
> The idea is taken from articles:
> https://lwn.net/Articles/738209/
> https://lwn.net/Articles/694385/
>
> Enable the feature if supported on bare metal and emulate instructions
> to return dummy values for certain cases.
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  arch/x86/kvm/svm.c |   21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 4153ca8cddb7..79abbdeca148 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2533,6 +2533,11 @@ static void svm_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
>  {
>  }
>
> +static bool svm_umip_emulated(void)
> +{
> +       return boot_cpu_has(X86_FEATURE_UMIP);
> +}

This makes no sense to me. If the hardware actually supports UMIP,
then it doesn't have to be emulated.

To the extent that kvm emulates UMIP on Intel CPUs without hardware
UMIP (i.e. smsw is still allowed at CPL>0), we can always do the same
emulation on AMD, because SVM has always offered intercepts of sgdt,
sidt, sldt, and str. So, if you really want to offer this emulation on
pre-EPYC 2 CPUs, this function should just return true. But, I have to
ask, "why?"

*Virtualization* of UMIP on EPYC 2 already works without any of these changes.

>  static void update_cr0_intercept(struct vcpu_svm *svm)
>  {
>         ulong gcr0 = svm->vcpu.arch.cr0;
> @@ -4438,6 +4443,13 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
>         return 1;
>  }
>
> +static int umip_interception(struct vcpu_svm *svm)
> +{
> +       struct kvm_vcpu *vcpu = &svm->vcpu;
> +
> +       return kvm_emulate_instruction(vcpu, 0);
> +}
> +
>  static int pause_interception(struct vcpu_svm *svm)
>  {
>         struct kvm_vcpu *vcpu = &svm->vcpu;
> @@ -4775,6 +4787,10 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
>         [SVM_EXIT_SMI]                          = nop_on_interception,
>         [SVM_EXIT_INIT]                         = nop_on_interception,
>         [SVM_EXIT_VINTR]                        = interrupt_window_interception,
> +       [SVM_EXIT_IDTR_READ]                    = umip_interception,
> +       [SVM_EXIT_GDTR_READ]                    = umip_interception,
> +       [SVM_EXIT_LDTR_READ]                    = umip_interception,
> +       [SVM_EXIT_TR_READ]                      = umip_interception,
>         [SVM_EXIT_RDPMC]                        = rdpmc_interception,
>         [SVM_EXIT_CPUID]                        = cpuid_interception,
>         [SVM_EXIT_IRET]                         = iret_interception,
> @@ -5976,11 +5992,6 @@ static bool svm_xsaves_supported(void)
>         return boot_cpu_has(X86_FEATURE_XSAVES);
>  }
>
> -static bool svm_umip_emulated(void)
> -{
> -       return false;
> -}
> -
>  static bool svm_pt_supported(void)
>  {
>         return false;
>
