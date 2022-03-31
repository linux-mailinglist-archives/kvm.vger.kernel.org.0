Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E0A4ED261
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 06:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbiCaE2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 00:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiCaE1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 00:27:48 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF47C3C4A4
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 21:20:40 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-dacc470e03so24160205fac.5
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 21:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fxUSqbZD4bDqt2IZurpQGdngn4HLC8ZiFYEQSVjJIMM=;
        b=Wrc/CDlv1xLHF11irs3LuLGPcdN12f7S9hTFSYL0mm0TClvdIkGQUGeWfOBWMngZhc
         DLeUdFVOWjJE8st10arRBMWqGd9iqFfHxY5fEDw2Z6hAuz1yUBYu0Q1Z6VA81p1O/mqn
         KgUEWW0qfa6Ku2loqsm1vPjoRQ/iHThc35XVjoYgPPMGfgnjUA91oBLTJZd2WYpjSXmw
         kKIsHmveeZDz54hhi6YtDUJqYQArV+PPSZgEuukeWbjkgHCxhBPK0N6GTiT3ShqMBrku
         wDTWAkE+FTTfgMzc8ov5byUSg+o3c/ohp6IBRx8G0YdFR5ePwLbiWTaBvXGTTGuxnply
         O5Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fxUSqbZD4bDqt2IZurpQGdngn4HLC8ZiFYEQSVjJIMM=;
        b=VUUBETHu9ZZx5jxO/FTKdDkyLpKLWL7z6NBXurvHkchpBokrm7f6KXPMhFbbI+NRAZ
         xJg5ERMdQQafE8PrM3IRCcRHix575ItqIvUar8RRjb8srKXc9wX/C6pt5xsjuQuw1drn
         vXMbexUJrBg2HAMC0vTF16evO0vKssp5DMpg0HwmXwbo/1hIXqrqCdUkuTB2ZJk9/ppW
         t/q1EHsza5oL+1KPCkJEvEl+8bOfyLSzXEdiMTkPheSPMm/YAApJGiCubdA4raXM3j/l
         9fZKaks2Ii5dvIg6m72w091xqRpDdMUXuKcJzLikzcmPyJ58RGfxIrubrIBDPXuDp8G6
         QYKw==
X-Gm-Message-State: AOAM531yBdl3aSKLQhsESiRbd1lrGQfQLImgK/0koDOpHbXe6/CxX9cM
        TFLpEt+d0bdpnbWvX1r1I+EBPBnjeSzkjAvnRY+bKcnn0vc=
X-Google-Smtp-Source: ABdhPJw0HPnJ57wtqnmJ1iVW/Ie8ViWz8oHQJhrqY6BVMYRB6DAaKp35CULargXXFrYJVE401JUXhxeJ5DXym+aHY0E=
X-Received: by 2002:a05:6870:e611:b0:dd:f6e5:7871 with SMTP id
 q17-20020a056870e61100b000ddf6e57871mr1818955oag.218.1648700439748; Wed, 30
 Mar 2022 21:20:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220330182821.2633150-1-pgonda@google.com>
In-Reply-To: <20220330182821.2633150-1-pgonda@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 30 Mar 2022 21:20:28 -0700
Message-ID: <CAA03e5FKznbcaLc8Ov4BDgD8QMfd-GPBE-oMUaX=2s+9cRPS1Q@mail.gmail.com>
Subject: Re: [PATCH v3] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 30, 2022 at 11:44 AM Peter Gonda <pgonda@google.com> wrote:
>
> SEV-ES guests can request termination using the GHCB's MSR protocol. See
> AMD's GHCB spec section '4.1.13 Termination Request'. Currently when a
> guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL)
> return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY to kvm_run
> struct the userspace VMM can clearly see the guest has requested a SEV-ES
> termination including the termination reason code set and reason code.
>
> Signed-off-by: Peter Gonda <pgonda@google.com>
>
> ---
> V3
>  * Add Documentation/ update.
>  * Updated other KVM_EXIT_SHUTDOWN exits to clear ndata and set reason
>    to KVM_SHUTDOWN_REQ.
>
> V2
>  * Add KVM_CAP_EXIT_SHUTDOWN_REASON check for KVM_CHECK_EXTENSION.
>
> Tested by making an SEV-ES guest call sev_es_terminate() with hardcoded
> reason code set and reason code and then observing the codes from the
> userspace VMM in the kvm_run.shutdown.data fields.
>
> Change-Id: I55dcdf0f42bfd70d0e59829ae70c2fb067b60809
> ---
>  Documentation/virt/kvm/api.rst | 12 ++++++++++++
>  arch/x86/kvm/svm/sev.c         |  9 +++++++--
>  arch/x86/kvm/svm/svm.c         |  2 ++
>  arch/x86/kvm/vmx/vmx.c         |  2 ++
>  arch/x86/kvm/x86.c             |  2 ++
>  include/uapi/linux/kvm.h       | 13 +++++++++++++
>  virt/kvm/kvm_main.c            |  1 +
>  7 files changed, 39 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 2aebb89576d1..d53a66a3760e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7834,3 +7834,15 @@ only be invoked on a VM prior to the creation of VCPUs.
>  At this time, KVM_PMU_CAP_DISABLE is the only capability.  Setting
>  this capability will disable PMU virtualization for that VM.  Usermode
>  should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
> +
> +8.36 KVM_CAP_EXIT_SHUTDOWN_REASON
> +---------------------------
> +
> +:Capability KVM_CAP_EXIT_SHUTDOWN_REASON
> +:Architectures: x86
> +:Type: vm
> +
> +This capability means shutdown metadata may be included in
> +kvm_run.shutdown when a vCPU exits with KVM_EXIT_SHUTDOWN. This
> +may help userspace determine the guest's reason for termination and
> +if the guest should be restarted or an error caused the shutdown.
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75fa6dd268f0..5f9d37dd3f6f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2735,8 +2735,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>                 pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
>                         reason_set, reason_code);
>
> -               ret = -EINVAL;
> -               break;
> +               vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
> +               vcpu->run->shutdown.reason = KVM_SHUTDOWN_SEV_TERM;
> +               vcpu->run->shutdown.ndata = 2;
> +               vcpu->run->shutdown.data[0] = reason_set;
> +               vcpu->run->shutdown.data[1] = reason_code;
> +
> +               return 0;
>         }
>         default:
>                 /* Error, keep GHCB MSR value as-is */
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6535adee3e9c..c2cc10776517 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1953,6 +1953,8 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
>         kvm_vcpu_reset(vcpu, true);
>
>         kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
> +       vcpu->run->shutdown.reason = KVM_SHUTDOWN_REQ;
> +       vcpu->run->shutdown.ndata = 0;
>         return 0;
>  }
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 84a7500cd80c..85b21fc490e4 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4988,6 +4988,8 @@ static __always_inline int handle_external_interrupt(struct kvm_vcpu *vcpu)
>  static int handle_triple_fault(struct kvm_vcpu *vcpu)
>  {
>         vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
> +       vcpu->run->shutdown.reason = KVM_SHUTDOWN_REQ;
> +       vcpu->run->shutdown.ndata = 0;
>         vcpu->mmio_needed = 0;
>         return 0;
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d3a9ce07a565..f7cd224a4c32 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9999,6 +9999,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>                                 kvm_x86_ops.nested_ops->triple_fault(vcpu);
>                         } else {
>                                 vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
> +                               vcpu->run->shutdown.reason = KVM_SHUTDOWN_REQ;
> +                               vcpu->run->shutdown.ndata = 0;
>                                 vcpu->mmio_needed = 0;
>                                 r = 0;
>                                 goto out;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 8616af85dc5d..017c03421c48 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -271,6 +271,12 @@ struct kvm_xen_exit {
>  #define KVM_EXIT_XEN              34
>  #define KVM_EXIT_RISCV_SBI        35
>
> +/* For KVM_EXIT_SHUTDOWN */
> +/* Standard VM shutdown request. No additional metadata provided. */
> +#define KVM_SHUTDOWN_REQ       0
> +/* SEV-ES termination request */
> +#define KVM_SHUTDOWN_SEV_TERM  1
> +
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
>  #define KVM_INTERNAL_ERROR_EMULATION   1
> @@ -311,6 +317,12 @@ struct kvm_run {
>                 struct {
>                         __u64 hardware_exit_reason;
>                 } hw;
> +               /* KVM_EXIT_SHUTDOWN */
> +               struct {
> +                       __u64 reason;
> +                       __u32 ndata;
> +                       __u64 data[16];
> +               } shutdown;
>                 /* KVM_EXIT_FAIL_ENTRY */
>                 struct {
>                         __u64 hardware_entry_failure_reason;
> @@ -1145,6 +1157,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PMU_CAPABILITY 212
>  #define KVM_CAP_DISABLE_QUIRKS2 213
>  #define KVM_CAP_VM_TSC_CONTROL 214
> +#define KVM_CAP_EXIT_SHUTDOWN_REASON 215
>
>  #ifdef KVM_CAP_IRQ_ROUTING
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70e05af5ebea..03b6e472f32c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4299,6 +4299,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>         case KVM_CAP_CHECK_EXTENSION_VM:
>         case KVM_CAP_ENABLE_CAP_VM:
>         case KVM_CAP_HALT_POLL:
> +       case KVM_CAP_EXIT_SHUTDOWN_REASON:
>                 return 1;
>  #ifdef CONFIG_KVM_MMIO
>         case KVM_CAP_COALESCED_MMIO:
> --
> 2.35.1.1094.g7c7d902a7c-goog
>

Reviewed-by: Marc Orr <marcorr@google.com>
