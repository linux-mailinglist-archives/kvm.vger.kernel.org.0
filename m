Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D973E139F3F
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 02:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbgANB7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 20:59:12 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34739 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728838AbgANB7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 20:59:12 -0500
Received: by mail-lf1-f65.google.com with SMTP id l18so8488394lfc.1
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2020 17:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G2QO+CSZjAl2honZM+PyUNevyOI6yY7VpogO/MBbalQ=;
        b=usT/kVCSExlmyNayfhnZNh7UGeTN5yPzMauPArjgNBy8lEn5OCcgmURhvQHpa3z2Lw
         PYZs4+CNpGKRRYg3XyiBLZfpmmQhhRl5zlfAvs2zqhOLQQXq+9BIeqbPIrvmUitT+Oo0
         XJSvvFmKvnuiHhZjCMzh9VrZ/zPxJGwjwmbIC/62TZveVFJAH1ChQyJy3T6QZVswdRaZ
         2SkJGTf9Z3AHXUj80Huqke95TdoD6FXSHoX8ILFX8WpOtMk8Y20rBiH7qJgxDchGe7Ky
         hjmdW8Uztw5PMjOnW5yLaxvgClrt5Hd37DqV+xuFDKeX7SLUJsw7IfQGO8t99d0/42J1
         xISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G2QO+CSZjAl2honZM+PyUNevyOI6yY7VpogO/MBbalQ=;
        b=AddwhCSWE5iGVJ7rt9gE1kQ2c6HO7hQUP22yXNNbMk4SzatdM43ybXw7/EmiIhVUI3
         f8YhdeYWo93+vMamWfkpqg9uQhFsvnBVj4mLPp8fc8JYb01o186icROB2aUe1LmUpHlj
         AX3qIyJsoZ4GGXh07qGxcrnL/+3t7QcNtMh1TaYshZVNEPy4gF9g7A+Doztj0l/EdoTt
         +Xxy5I2celBxxYX3j1aL09VP3JzlnavFOaKCJFfGKMBM5W1YJCD/vehhoOFOta6tNhJM
         XDprCE4AMHW/PXYjs5n71H872tN/Ix/G6EyLBmwQ029DS129mcQfyfGWNX3XcC537wMo
         CC7w==
X-Gm-Message-State: APjAAAVFuRafzaQ+/eaXuCU1svTLjfKgoelbK4sMiJGTqeyp+DxsiwkU
        0aPcwoTcAP8qgB8r6Qp+Z3SsRNCe7g51SQZpQPk=
X-Google-Smtp-Source: APXvYqyMolQ56ECk030qpcJ/Xxdzh/HLaowZNX6TD9VxXE+Er2v4KavgYxo6zpWl1cEbUIC1zNZmMfu1nMvoWuL8tsU=
X-Received: by 2002:a19:e30b:: with SMTP id a11mr243834lfh.48.1578967150070;
 Mon, 13 Jan 2020 17:59:10 -0800 (PST)
MIME-Version: 1.0
References: <20200109152133.23649-1-philmd@redhat.com> <20200109152133.23649-14-philmd@redhat.com>
In-Reply-To: <20200109152133.23649-14-philmd@redhat.com>
From:   Alistair Francis <alistair23@gmail.com>
Date:   Tue, 14 Jan 2020 11:58:43 +1000
Message-ID: <CAKmqyKNQbbuxz9jnwa5A8FiXofU9jSwMSHp1LpXmrrAQyM_ddA@mail.gmail.com>
Subject: Re: [PATCH 13/15] accel: Replace current_machine->accelerator by
 current_accel() method
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "open list:Overall" <kvm@vger.kernel.org>,
        Juan Quintela <quintela@redhat.com>,
        "open list:New World" <qemu-ppc@nongnu.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-arm <qemu-arm@nongnu.org>,
        Alistair Francis <alistair.francis@wdc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 10, 2020 at 1:38 AM Philippe Mathieu-Daud=C3=A9
<philmd@redhat.com> wrote:
>
> As we want to remove the global current_machine,
> replace 'current_machine->accelerator' by current_accel().
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>

Reviewed-by: Alistair Francis <alistair.francis@wdc.com>

Alistair

> ---
>  accel/kvm/kvm-all.c | 4 ++--
>  accel/tcg/tcg-all.c | 2 +-
>  memory.c            | 2 +-
>  target/arm/kvm64.c  | 4 ++--
>  target/i386/kvm.c   | 2 +-
>  target/ppc/kvm.c    | 2 +-
>  vl.c                | 2 +-
>  7 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index b2f1a5bcb5..be1980f250 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -164,7 +164,7 @@ static NotifierList kvm_irqchip_change_notifiers =3D
>
>  int kvm_get_max_memslots(void)
>  {
> -    KVMState *s =3D KVM_STATE(current_machine->accelerator);
> +    KVMState *s =3D KVM_STATE(current_accel());
>
>      return s->nr_slots;
>  }
> @@ -1847,7 +1847,7 @@ static int kvm_max_vcpu_id(KVMState *s)
>
>  bool kvm_vcpu_id_is_valid(int vcpu_id)
>  {
> -    KVMState *s =3D KVM_STATE(current_machine->accelerator);
> +    KVMState *s =3D KVM_STATE(current_accel());
>      return vcpu_id >=3D 0 && vcpu_id < kvm_max_vcpu_id(s);
>  }
>
> diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
> index 1dc384c8d2..1802ce02f6 100644
> --- a/accel/tcg/tcg-all.c
> +++ b/accel/tcg/tcg-all.c
> @@ -124,7 +124,7 @@ static void tcg_accel_instance_init(Object *obj)
>
>  static int tcg_init(MachineState *ms)
>  {
> -    TCGState *s =3D TCG_STATE(current_machine->accelerator);
> +    TCGState *s =3D TCG_STATE(current_accel());
>
>      tcg_exec_init(s->tb_size * 1024 * 1024);
>      cpu_interrupt_handler =3D tcg_handle_interrupt;
> diff --git a/memory.c b/memory.c
> index 57e38b1f50..60e8993499 100644
> --- a/memory.c
> +++ b/memory.c
> @@ -3106,7 +3106,7 @@ void mtree_info(bool flatview, bool dispatch_tree, =
bool owner)
>          };
>          GArray *fv_address_spaces;
>          GHashTable *views =3D g_hash_table_new(g_direct_hash, g_direct_e=
qual);
> -        AccelClass *ac =3D ACCEL_GET_CLASS(current_machine->accelerator)=
;
> +        AccelClass *ac =3D ACCEL_GET_CLASS(current_accel());
>
>          if (ac->has_memory) {
>              fvi.ac =3D ac;
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index 876184b8fe..f677877a1e 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -613,14 +613,14 @@ bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatur=
es *ahcf)
>
>  bool kvm_arm_aarch32_supported(CPUState *cpu)
>  {
> -    KVMState *s =3D KVM_STATE(current_machine->accelerator);
> +    KVMState *s =3D KVM_STATE(current_accel());
>
>      return kvm_check_extension(s, KVM_CAP_ARM_EL1_32BIT);
>  }
>
>  bool kvm_arm_sve_supported(CPUState *cpu)
>  {
> -    KVMState *s =3D KVM_STATE(current_machine->accelerator);
> +    KVMState *s =3D KVM_STATE(current_accel());
>
>      return kvm_check_extension(s, KVM_CAP_ARM_SVE);
>  }
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 0b511906e3..2ed15814dc 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -147,7 +147,7 @@ bool kvm_allows_irq0_override(void)
>
>  static bool kvm_x2apic_api_set_flags(uint64_t flags)
>  {
> -    KVMState *s =3D KVM_STATE(current_machine->accelerator);
> +    KVMState *s =3D KVM_STATE(current_accel());
>
>      return !kvm_vm_enable_cap(s, KVM_CAP_X2APIC_API, 0, flags);
>  }
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index d1c334f0e3..2d011308e0 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -258,7 +258,7 @@ static void kvm_get_smmu_info(struct kvm_ppc_smmu_inf=
o *info, Error **errp)
>
>  struct ppc_radix_page_info *kvm_get_radix_page_info(void)
>  {
> -    KVMState *s =3D KVM_STATE(current_machine->accelerator);
> +    KVMState *s =3D KVM_STATE(current_accel());
>      struct ppc_radix_page_info *radix_page_info;
>      struct kvm_ppc_rmmu_info rmmu_info;
>      int i;
> diff --git a/vl.c b/vl.c
> index 86474a55c9..3ff3548183 100644
> --- a/vl.c
> +++ b/vl.c
> @@ -2804,7 +2804,7 @@ static void configure_accelerators(const char *prog=
name)
>      }
>
>      if (init_failed) {
> -        AccelClass *ac =3D ACCEL_GET_CLASS(current_machine->accelerator)=
;
> +        AccelClass *ac =3D ACCEL_GET_CLASS(current_accel());
>          error_report("falling back to %s", ac->name);
>      }
>
> --
> 2.21.1
>
>
