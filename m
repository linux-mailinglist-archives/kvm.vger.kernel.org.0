Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3576C744DBE
	for <lists+kvm@lfdr.de>; Sun,  2 Jul 2023 15:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjGBNl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jul 2023 09:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjGBNl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jul 2023 09:41:28 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B3C126
        for <kvm@vger.kernel.org>; Sun,  2 Jul 2023 06:41:27 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id a1e0cc1a2514c-78701841ccbso1168524241.2
        for <kvm@vger.kernel.org>; Sun, 02 Jul 2023 06:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688305286; x=1690897286;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=78FXPSarnd2pESmjIqrSJcd1rGIEbAVnpv1Vnp3C/F0=;
        b=c5bbX+FEbaf8Nqnqzf3lB0vNBYEvcL9gf0vajs0XFUILMBKn09T8FWCBHKlS4ITOgE
         TWykzvSMa2EwJ8CcQGPSFbwuv1enS8cAQPrnyOO+BDunLWDLb47QRJ5RIEjWj4aPusI7
         mN5xdMV0fHkopJ8j3LfootdF6c7LmedM9D9xOuXXgtPErubSUPv5EAbcOvNN6ShYMSwP
         C5ozgb+CWKT4n/omvzhP6lO0BPAQD7v0UTvJLCik2RWQX+iv2U/hLrsBuPDNVuSMsWqx
         kWpc2kNkcA6MQN/tyN9mAXIMFF5kgrCDAsQxXRMlaFexpG8nHGOTKlmc7RlDQepc1dZz
         zDBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688305286; x=1690897286;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=78FXPSarnd2pESmjIqrSJcd1rGIEbAVnpv1Vnp3C/F0=;
        b=YQYTKWK/FqTZF4g+njfyyj0FMDF94wYHwqr/g3s8QIA61MrjB351+c611Sf4Ng9DeE
         X+jRA47gtkZOPGxcKkFqm/nS9E4DVf2vMf7BJaKJFWLP1uegE5l0dDouqXaGxRbtUDR7
         p4zrIHISxVEtkYXeFxNOgIKcD/hIc1CZ9E5xlEhhrA6JYahoSjdEL6jbXflTf8oL/tV0
         pwDZ9zwuf5bMNMICWrSN5EuSFTG0NIRzkIL7fHbag3l0NMaXO01uAIQsL16nGFWMsBjx
         jn2KGKPt5E/Vpjb99WWbNthCKvELrJANLSJT3gHNTN9I47qwcd08UKTGLx5VRFdLEFEO
         eBgg==
X-Gm-Message-State: ABy/qLbxLV2kCI/p+bfhx8xaEqhjmyeFj11pzulevOgK01/5Xd2XviJs
        tioE5NfrCe7oQJFZeGYY7YiHnIh4GjYbPEcooAjlpTHpQbwj8AQL
X-Google-Smtp-Source: APBJJlHGCF5UwOW2ylzBJNB/aM7wg06pCtPyPBri2J7xsgo3zfOQQKrVKhww5Kr+4VWcXV0RtMKnpm/tGRyEzQdcz88=
X-Received: by 2002:a05:6102:50d:b0:437:e5ce:7e8f with SMTP id
 l13-20020a056102050d00b00437e5ce7e8fmr4023260vsa.4.1688305286281; Sun, 02 Jul
 2023 06:41:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230621013821.6874-1-dongli.zhang@oracle.com> <20230621013821.6874-2-dongli.zhang@oracle.com>
In-Reply-To: <20230621013821.6874-2-dongli.zhang@oracle.com>
From:   Like Xu <like.xu.linux@gmail.com>
Date:   Sun, 2 Jul 2023 21:41:09 +0800
Message-ID: <CAA3+yLdbMwfBQ-3Ckk4zwLdbwNOQ8M28d2CqLP0+AKkDwC7Ynw@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 1/2] target/i386/kvm: introduce
 'pmu-cap-disabled' to set KVM_PMU_CAP_DISABLE
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, joe.jin@oracle.com, zhenyuw@linux.intel.com,
        groug@kaod.org, lyan@digitalocean.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 21, 2023 at 9:39=E2=80=AFAM Dongli Zhang <dongli.zhang@oracle.c=
om> wrote:
>
> The "perf stat" at the VM side still works even we set "-cpu host,-pmu" i=
n
> the QEMU command line. That is, neither "-cpu host,-pmu" nor "-cpu EPYC"
> could disable the pmu virtualization in an AMD environment.
>
> We still see below at VM kernel side ...
>
> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
>
> ... although we expect something like below.
>
> [    0.596381] Performance Events: PMU not available due to virtualizatio=
n, using software events only.
> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
>
> This is because the AMD pmu (v1) does not rely on cpuid to decide if the
> pmu virtualization is supported.
>
> We introduce a new property 'pmu-cap-disabled' for KVM accel to set
> KVM_PMU_CAP_DISABLE if KVM_CAP_PMU_CAPABILITY is supported. Only x86 host
> is supported because currently KVM uses KVM_CAP_PMU_CAPABILITY only for
> x86.

We may check cpu->enable_pmu when creating the first CPU or a BSP one
(before it gets running) and then choose whether to disable guest pmu using
vm ioctl KVM_CAP_PMU_CAPABILITY. Introducing a new property is not too
acceptable if there are other options.

>
> Cc: Joe Jin <joe.jin@oracle.com>
> Cc: Like Xu <likexu@tencent.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
> - In version 1 we did not introduce the new property. We ioctl
>   KVM_PMU_CAP_DISABLE only before the creation of the 1st vcpu. We had
>   introduced a helpfer function to do this job before creating the 1st
>   KVM vcpu in v1.
>
>  accel/kvm/kvm-all.c      |  1 +
>  include/sysemu/kvm_int.h |  1 +
>  qemu-options.hx          |  7 ++++++
>  target/i386/kvm/kvm.c    | 46 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 55 insertions(+)
>
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 7679f397ae..238098e991 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -3763,6 +3763,7 @@ static void kvm_accel_instance_init(Object *obj)
>      s->xen_version =3D 0;
>      s->xen_gnttab_max_frames =3D 64;
>      s->xen_evtchn_max_pirq =3D 256;
> +    s->pmu_cap_disabled =3D false;
>  }
>
>  /**
> diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
> index 511b42bde5..cbbe08ec54 100644
> --- a/include/sysemu/kvm_int.h
> +++ b/include/sysemu/kvm_int.h
> @@ -123,6 +123,7 @@ struct KVMState
>      uint32_t xen_caps;
>      uint16_t xen_gnttab_max_frames;
>      uint16_t xen_evtchn_max_pirq;
> +    bool pmu_cap_disabled;
>  };
>
>  void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
> diff --git a/qemu-options.hx b/qemu-options.hx
> index b57489d7ca..1976c0ca3e 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -187,6 +187,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
>      "                tb-size=3Dn (TCG translation block cache size)\n"
>      "                dirty-ring-size=3Dn (KVM dirty ring GFN count, defa=
ult 0)\n"
>      "                notify-vmexit=3Drun|internal-error|disable,notify-w=
indow=3Dn (enable notify VM exit and set notify window, x86 only)\n"
> +    "                pmu-cap-disabled=3Dtrue|false (disable KVM_CAP_PMU_=
CAPABILITY, x86 only, default false)\n"
>      "                thread=3Dsingle|multi (enable multi-threaded TCG)\n=
", QEMU_ARCH_ALL)
>  SRST
>  ``-accel name[,prop=3Dvalue[,...]]``
> @@ -254,6 +255,12 @@ SRST
>          open up for a specified of time (i.e. notify-window).
>          Default: notify-vmexit=3Drun,notify-window=3D0.
>
> +    ``pmu-cap-disabled=3Dtrue|false``
> +        When the KVM accelerator is used, it controls whether to disable=
 the
> +        KVM_CAP_PMU_CAPABILITY via KVM_PMU_CAP_DISABLE. When disabled, t=
he
> +        PMU virtualization is disabled at the KVM module side. This is f=
or
> +        x86 host only.
> +
>  ERST
>
>  DEF("smp", HAS_ARG, QEMU_OPTION_smp,
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index de531842f6..bf4136fa1b 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -129,6 +129,7 @@ static bool has_msr_ucode_rev;
>  static bool has_msr_vmx_procbased_ctls2;
>  static bool has_msr_perf_capabs;
>  static bool has_msr_pkrs;
> +static bool has_pmu_cap;
>
>  static uint32_t has_architectural_pmu_version;
>  static uint32_t num_architectural_pmu_gp_counters;
> @@ -2767,6 +2768,23 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>          }
>      }
>
> +    has_pmu_cap =3D kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
> +
> +    if (s->pmu_cap_disabled) {
> +        if (has_pmu_cap) {
> +            ret =3D kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
> +                                    KVM_PMU_CAP_DISABLE);
> +            if (ret < 0) {
> +                s->pmu_cap_disabled =3D false;
> +                error_report("kvm: Failed to disable pmu cap: %s",
> +                             strerror(-ret));
> +            }
> +        } else {
> +            s->pmu_cap_disabled =3D false;
> +            error_report("kvm: KVM_CAP_PMU_CAPABILITY is not supported")=
;
> +        }
> +    }
> +
>      return 0;
>  }
>
> @@ -5951,6 +5969,28 @@ static void kvm_arch_set_xen_evtchn_max_pirq(Objec=
t *obj, Visitor *v,
>      s->xen_evtchn_max_pirq =3D value;
>  }
>
> +static void kvm_set_pmu_cap_disabled(Object *obj, Visitor *v,
> +                                     const char *name, void *opaque,
> +                                     Error **errp)
> +{
> +    KVMState *s =3D KVM_STATE(obj);
> +    bool pmu_cap_disabled;
> +    Error *error =3D NULL;
> +
> +    if (s->fd !=3D -1) {
> +        error_setg(errp, "Cannot set properties after the accelerator ha=
s been initialized");
> +        return;
> +    }
> +
> +    visit_type_bool(v, name, &pmu_cap_disabled, &error);
> +    if (error) {
> +        error_propagate(errp, error);
> +        return;
> +    }
> +
> +    s->pmu_cap_disabled =3D pmu_cap_disabled;
> +}
> +
>  void kvm_arch_accel_class_init(ObjectClass *oc)
>  {
>      object_class_property_add_enum(oc, "notify-vmexit", "NotifyVMexitOpt=
ion",
> @@ -5990,6 +6030,12 @@ void kvm_arch_accel_class_init(ObjectClass *oc)
>                                NULL, NULL);
>      object_class_property_set_description(oc, "xen-evtchn-max-pirq",
>                                            "Maximum number of Xen PIRQs")=
;
> +
> +    object_class_property_add(oc, "pmu-cap-disabled", "bool",
> +                              NULL, kvm_set_pmu_cap_disabled,
> +                              NULL, NULL);
> +    object_class_property_set_description(oc, "pmu-cap-disabled",
> +                                          "Disable KVM_CAP_PMU_CAPABILIT=
Y");
>  }
>
>  void kvm_set_max_apic_id(uint32_t max_apic_id)
> --
> 2.34.1
>
