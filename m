Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F411000D
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 21:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfD3TDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 15:03:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46918 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfD3TDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 15:03:40 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD03A3001244;
        Tue, 30 Apr 2019 19:03:39 +0000 (UTC)
Received: from [10.36.112.20] (ovpn-112-20.ams2.redhat.com [10.36.112.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 579F37EB66;
        Tue, 30 Apr 2019 19:03:35 +0000 (UTC)
Subject: Re: [PATCH v2] KVM: x86: Whitelist port 0x7e for pre-incrementing
 %rip
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Simon Becherer <simon@becherer.de>,
        Iakov Karpov <srid@rkmail.ru>,
        Gabriele Balducci <balducci@units.it>,
        Antti Antinoja <reader@fennosys.fi>,
        Takashi Iwai <tiwai@suse.com>, Jiri Slaby <jslaby@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20190429140415.4234-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=pbonzini@redhat.com; prefer-encrypt=mutual; keydata=
 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
 uUHgL9dKIfvpm+rNXRn9wAwGjk0X/A==
Message-ID: <22f2ca62-0c7c-b1d7-610d-d626a8b3f8d9@redhat.com>
Date:   Tue, 30 Apr 2019 21:03:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190429140415.4234-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 30 Apr 2019 19:03:40 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/19 16:04, Sean Christopherson wrote:
> KVM's recent bug fix to update %rip after emulating I/O broke userspace
> that relied on the previous behavior of incrementing %rip prior to
> exiting to userspace.  When running a Windows XP guest on AMD hardware,
> Qemu may patch "OUT 0x7E" instructions in reaction to the OUT itself.
> Because KVM's old behavior was to increment %rip before exiting to
> userspace to handle the I/O, Qemu manually adjusted %rip to account for
> the OUT instruction.
> 
> Arguably this is a userspace bug as KVM requires userspace to re-enter
> the kernel to complete instruction emulation before taking any other
> actions.  That being said, this is a bit of a grey area and breaking
> userspace that has worked for many years is bad.
> 
> Pre-increment %rip on OUT to port 0x7e before exiting to userspace to
> hack around the issue.
> 
> Fixes: 45def77ebf79e ("KVM: x86: update %rip after emulating IO")
> Reported-by: Simon Becherer <simon@becherer.de>
> Reported-and-tested-by: Iakov Karpov <srid@rkmail.ru>
> Reported-by: Gabriele Balducci <balducci@units.it>
> Reported-by: Antti Antinoja <reader@fennosys.fi>
> Cc: stable@vger.kernel.org
> Cc: Takashi Iwai <tiwai@suse.com>
> Cc: Jiri Slaby <jslaby@suse.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> v2: Add a quirk so that userspace can disable the hack. [Paolo]
> 
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/x86.c              | 21 +++++++++++++++++++--
>  2 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index dabfcf7c3941..7a0e64ccd6ff 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -381,6 +381,7 @@ struct kvm_sync_regs {
>  #define KVM_X86_QUIRK_LINT0_REENABLED	(1 << 0)
>  #define KVM_X86_QUIRK_CD_NW_CLEARED	(1 << 1)
>  #define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	(1 << 2)
> +#define KVM_X86_QUIRK_OUT_7E_INC_RIP	(1 << 3)
>  
>  #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
>  #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9482cb36b92a..57621313dead 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6539,6 +6539,12 @@ int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_instruction_from_buffer);
>  
> +static int complete_fast_pio_out_port_0x7e(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.pio.count = 0;
> +	return 1;
> +}
> +
>  static int complete_fast_pio_out(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->arch.pio.count = 0;
> @@ -6555,12 +6561,23 @@ static int kvm_fast_pio_out(struct kvm_vcpu *vcpu, int size,
>  	unsigned long val = kvm_register_read(vcpu, VCPU_REGS_RAX);
>  	int ret = emulator_pio_out_emulated(&vcpu->arch.emulate_ctxt,
>  					    size, port, &val, 1);
> +	if (ret)
> +		return ret;
>  
> -	if (!ret) {
> +	/*
> +	 * Workaround userspace that relies on old KVM behavior of %rip being
> +	 * incremented prior to exiting to userspace to handle "OUT 0x7e".
> +	 */
> +	if (port == 0x7e &&
> +	    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_OUT_7E_INC_RIP)) {
> +		vcpu->arch.complete_userspace_io =
> +			complete_fast_pio_out_port_0x7e;
> +		kvm_skip_emulated_instruction(vcpu);
> +	} else {
>  		vcpu->arch.pio.linear_rip = kvm_get_linear_rip(vcpu);
>  		vcpu->arch.complete_userspace_io = complete_fast_pio_out;
>  	}
> -	return ret;
> +	return 0;
>  }
>  
>  static int complete_fast_pio_in(struct kvm_vcpu *vcpu)
> 

Queued, thanks (it's identical to mine except for the comment).

Paolo
