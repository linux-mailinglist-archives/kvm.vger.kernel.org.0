Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9021B3641DC
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 14:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239144AbhDSMmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 08:42:16 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:53993 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233112AbhDSMmP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 08:42:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id AD52A1940DEE;
        Mon, 19 Apr 2021 08:41:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 19 Apr 2021 08:41:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0jAWxN
        QBqoFLqOtPNvMpSzPTkphK++QymqeX+Nel/UI=; b=B8G/CwVz995F9jE5jfIHBN
        b9MCQ/6cHAYJuQvXec2sgzY8YgIPL283vO3MYxE+BA6Wdv7AF5cNK8GjrDp8o1UN
        S84x7gRWIKutPo0Im3xGbeJmmM6RwRpf2MmzbTpInwqvIoGqOuiG35Mz21qH/+kl
        16d82WZPoDzgTtlzf/OEWLyuHprfBV5OauChkzg9mIvlQ2BNWjikV4lEFdbquMNk
        E08YFNhv8Uff3vKeutBVgeSIZRvdM/OuzS3JgmPDW21r/k79hoGnM2qciQVXxTYS
        W3ItIJL0an874tTBh+wmrgh2z09uxLmcMDy9foSa4Adv5+fmfySifBIb/qLHlNTw
        ==
X-ME-Sender: <xms:iXp9YOYpcF-dM8zMvmHJ1iK6MzZVd7lQVmaYZVWrFyHlwETMt_ZKzA>
    <xme:iXp9YBaXZMSqk_sh0QptSZPRp0pJgsFQurydihpzfCUIXpsx-rsapmXeiOwtvWWMp
    yFmDwtUbr34kdzRyQo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddtgedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvffujghfhfffkfggtgesthdtredttddttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegumhgvsegumhgvrdhorhhgqeenucggtffrrghtthgvrhhnpe
    fhkeeguedtvdegffffteehjedvjeeitefgfefgffdugeffffegudehgeetgeelkeenucfk
    phepkedurddukeejrddviedrvdefkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegumhgvsegumhgvrdhorhhg
X-ME-Proxy: <xmx:iXp9YI9wOlLochoQCssecnroMOw7VxXS6G5g-6hErcsIGcnbaXlR3w>
    <xmx:iXp9YArTuY6tSao6v1l0yelK0p1TgyVOSFh3FUKJE2RuD9r3_kEPTQ>
    <xmx:iXp9YJqbNS7i2QFUiLIA_lvWZ29l_zkyM-YYEfphIVGARdpRo-wIJQ>
    <xmx:iXp9YAVXNyUCO9vSBGapSQsitpQpYCkA5dHaGu8uzCKRWAf8xy_VRQ>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA id CC73624005C;
        Mon, 19 Apr 2021 08:41:44 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 76b3293b;
        Mon, 19 Apr 2021 12:41:43 +0000 (UTC)
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     jmattson@google.com, seanjc@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH 1/2] kvm: x86: Allow userspace to handle emulation errors
In-Reply-To: <20210416131820.2566571-1-aaronlewis@google.com>
References: <20210416131820.2566571-1-aaronlewis@google.com>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
X-Now-Playing: Floating Points - Elaenia: Elaenia
Date:   Mon, 19 Apr 2021 13:41:43 +0100
Message-ID: <cunblaaqwe0.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for sending the patches.

On Friday, 2021-04-16 at 06:18:19 -07, Aaron Lewis wrote:

> Add a fallback mechanism to the in-kernel instruction emulator that
> allows userspace the opportunity to process an instruction the emulator
> was unable to.  When the in-kernel instruction emulator fails to process
> an instruction it will either inject a #UD into the guest or exit to
> userspace with exit reason KVM_INTERNAL_ERROR.  This is because it does
> not know how to proceed in an appropriate manner.  This feature lets
> userspace get involved to see if it can figure out a better path
> forward.

Given that you are intending to try and handle the instruction in
user-space, it seems a little odd to overload the
KVM_EXIT_INTERNAL_ERROR/KVM_INTERNAL_ERROR_EMULATION exit reason/sub
error.

Why not add a new exit reason, particularly given that the caller has to
enable the capability to get the relevant data? (It would also remove
the need for the flag field and any mechanism for packing multiple bits
of detail into the structure.)

>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Change-Id: If9876bc73d26f6c3ff9a8bce177c2fc6f160e629
> ---
>  Documentation/virt/kvm/api.rst  | 16 ++++++++++++++++
>  arch/x86/include/asm/kvm_host.h |  6 ++++++
>  arch/x86/kvm/x86.c              | 33 +++++++++++++++++++++++++++++----
>  include/uapi/linux/kvm.h        | 20 ++++++++++++++++++++
>  tools/include/uapi/linux/kvm.h  | 20 ++++++++++++++++++++
>  5 files changed, 91 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 307f2fcf1b02..f8278e893fbe 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6233,6 +6233,22 @@ KVM_RUN_BUS_LOCK flag is used to distinguish between them.
>  This capability can be used to check / enable 2nd DAWR feature provided
>  by POWER10 processor.
>  
> +7.24 KVM_CAP_EXIT_ON_EMULATION_FAILURE
> +--------------------------------------
> +
> +:Architectures: x86
> +:Parameters: args[0] whether the feature should be enabled or not
> +
> +With this capability enabled, the in-kernel instruction emulator packs the exit
> +struct of KVM_INTERNAL_ERROR with the instruction length and instruction bytes
> +when an error occurs while emulating an instruction.  This allows userspace to
> +then take a look at the instruction and see if it is able to handle it more
> +gracefully than the in-kernel emulator.
> +
> +When this capability is enabled use the emulation_failure struct instead of the
> +internal struct for the exit struct.  They have the same layout, but the
> +emulation_failure struct matches the content better.
> +
>  8. Other capabilities.
>  ======================
>  
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3768819693e5..07235d08e976 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1049,6 +1049,12 @@ struct kvm_arch {
>  	bool exception_payload_enabled;
>  
>  	bool bus_lock_detection_enabled;
> +	/*
> +	 * If exit_on_emulation_error is set, and the in-kernel instruction
> +	 * emulator fails to emulate an instruction, allow userspace
> +	 * the opportunity to look at it.
> +	 */
> +	bool exit_on_emulation_error;
>  
>  	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
>  	u32 user_space_msr_mask;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eca63625aee4..f9a207f815fb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3771,6 +3771,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_X86_USER_SPACE_MSR:
>  	case KVM_CAP_X86_MSR_FILTER:
>  	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
> +	case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
>  		r = 1;
>  		break;
>  #ifdef CONFIG_KVM_XEN
> @@ -5357,6 +5358,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			kvm->arch.bus_lock_detection_enabled = true;
>  		r = 0;
>  		break;
> +	case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
> +		kvm->arch.exit_on_emulation_error = cap->args[0];
> +		r = 0;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -7119,8 +7124,29 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
>  }
>  EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
>  
> +static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
> +{
> +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> +	u64 insn_size = ctxt->fetch.end - ctxt->fetch.data;
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +	vcpu->run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
> +	vcpu->run->emulation_failure.ndata = 0;
> +	if (kvm->arch.exit_on_emulation_error && insn_size > 0) {
> +		vcpu->run->emulation_failure.ndata = 3;
> +		vcpu->run->emulation_failure.flags =
> +			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
> +		vcpu->run->emulation_failure.insn_size = insn_size;
> +		memcpy(vcpu->run->emulation_failure.insn_bytes,
> +		       ctxt->fetch.data, sizeof(ctxt->fetch.data));
> +	}
> +}
> +
>  static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>  {
> +	struct kvm *kvm = vcpu->kvm;
> +
>  	++vcpu->stat.insn_emulation_fail;
>  	trace_kvm_emulate_insn_failed(vcpu);
>  
> @@ -7129,10 +7155,9 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>  		return 1;
>  	}
>  
> -	if (emulation_type & EMULTYPE_SKIP) {
> -		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> -		vcpu->run->internal.ndata = 0;
> +	if (kvm->arch.exit_on_emulation_error ||
> +	    (emulation_type & EMULTYPE_SKIP)) {
> +		prepare_emulation_failure_exit(vcpu);
>  		return 0;
>  	}
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f6afee209620..7c77099235b2 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -279,6 +279,17 @@ struct kvm_xen_exit {
>  /* Encounter unexpected vm-exit reason */
>  #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
>  
> +/*
> + * When using the suberror KVM_INTERNAL_ERROR_EMULATION, these flags are used
> + * to describe what is contained in the exit struct.  The flags are used to
> + * describe it's contents, and the contents should be in ascending numerical
> + * order of the flag values.  For example, if the flag
> + * KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is set, the instruction
> + * length and instruction bytes would be expected to show up first because this
> + * flag has the lowest numerical value (1) of all the other flags.
> + */
> +#define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
> +
>  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>  struct kvm_run {
>  	/* in */
> @@ -382,6 +393,14 @@ struct kvm_run {
>  			__u32 ndata;
>  			__u64 data[16];
>  		} internal;
> +		/* KVM_EXIT_INTERNAL_ERROR, too (not 2) */
> +		struct {
> +			__u32 suberror;
> +			__u32 ndata;
> +			__u64 flags;
> +			__u8  insn_size;
> +			__u8  insn_bytes[15];
> +		} emulation_failure;
>  		/* KVM_EXIT_OSI */
>  		struct {
>  			__u64 gprs[32];
> @@ -1078,6 +1097,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_DIRTY_LOG_RING 192
>  #define KVM_CAP_X86_BUS_LOCK_EXIT 193
>  #define KVM_CAP_PPC_DAWR1 194
> +#define KVM_CAP_EXIT_ON_EMULATION_FAILURE 195
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index f6afee209620..7c77099235b2 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -279,6 +279,17 @@ struct kvm_xen_exit {
>  /* Encounter unexpected vm-exit reason */
>  #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
>  
> +/*
> + * When using the suberror KVM_INTERNAL_ERROR_EMULATION, these flags are used
> + * to describe what is contained in the exit struct.  The flags are used to
> + * describe it's contents, and the contents should be in ascending numerical
> + * order of the flag values.  For example, if the flag
> + * KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is set, the instruction
> + * length and instruction bytes would be expected to show up first because this
> + * flag has the lowest numerical value (1) of all the other flags.

When adding a new flag, do I steal bytes from insn_bytes[] for my
associated payload? If so, how many do I have to leave?

> + */
> +#define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
> +
>  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>  struct kvm_run {
>  	/* in */
> @@ -382,6 +393,14 @@ struct kvm_run {
>  			__u32 ndata;
>  			__u64 data[16];
>  		} internal;
> +		/* KVM_EXIT_INTERNAL_ERROR, too (not 2) */
> +		struct {
> +			__u32 suberror;
> +			__u32 ndata;
> +			__u64 flags;
> +			__u8  insn_size;
> +			__u8  insn_bytes[15];
> +		} emulation_failure;
>  		/* KVM_EXIT_OSI */
>  		struct {
>  			__u64 gprs[32];
> @@ -1078,6 +1097,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_DIRTY_LOG_RING 192
>  #define KVM_CAP_X86_BUS_LOCK_EXIT 193
>  #define KVM_CAP_PPC_DAWR1 194
> +#define KVM_CAP_EXIT_ON_EMULATION_FAILURE 195
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.31.1.368.gbe11c130af-goog

dme.
-- 
Walking upside down in the sky, between the satellites passing by, I'm looking.
