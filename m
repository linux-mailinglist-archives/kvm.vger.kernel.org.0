Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC7738E7FF
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 15:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhEXNse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 09:48:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49118 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232462AbhEXNsd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 09:48:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621864025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DxU+njrfd2D8qBEaduFVn30kIAJat301vBKHi1Hg3wU=;
        b=XYi38SvA2BtV6C4wViSzn25SB8jI/lnjSIKv5NDust3EJaw262SRtIpmRr/sXzm4bkXyap
        Ok8jI6LGblzbssLK9HnW/rC5pCFbxoGDyXsP1dgRk1hfcuoG8rM8ATLsTb5LjOofkcO1zW
        UWH+cYGSMYVk73rNfvkBc0ztbmJF/Ek=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-kKaoMWkDOHCcoco6-lDTBQ-1; Mon, 24 May 2021 09:47:02 -0400
X-MC-Unique: kKaoMWkDOHCcoco6-lDTBQ-1
Received: by mail-ej1-f70.google.com with SMTP id z6-20020a17090665c6b02903700252d1ccso7548209ejn.10
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 06:47:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DxU+njrfd2D8qBEaduFVn30kIAJat301vBKHi1Hg3wU=;
        b=d4X5OWpSL0xDRQ0ZqqZtscIDl46S5QidZhcqTbUUpWKgzpgaOLHjD6KNWl25f3xphF
         ppnqaHg7kUImjYhU1/snRKrOcTAUTYmpxul4uPT8bCVRUZOWfWh+mksrG5WZrq7nzHlW
         qs5LZWWeQzAmRRFCPk9g3pbnMnXKoUIeHa6hWulvX1e7FIAZRXVK1z/gj015IZjlg7Yy
         52xsQWKWsUaHIRvfCCCFmcq87oXjLJIiFBagRyQxhuRue5qQmuJBcndrQGPz5KbLWzKG
         fp+MQAWaGYrNrITRYK+KYfnM15NvVQAi4nOPL0ijWoHNLJcw1WHeAOgcDIeBEGtKsz9S
         Ju1w==
X-Gm-Message-State: AOAM532cmqWFtPpKmrvy+AE24VLxsFLsy+EHnvAQi+JIzPttibCzz1QE
        +7xg9Pruc4gzrN4XPG9sZ6gGPUMHnZuoWzpoCoXbgC56e1CthucjEgMX/ni47gxIFOApyHHr4bB
        JAICjLMv1ufX/XASRvCVN1Wzzvmgfsf/+0x97zfglT0xGNKhg/LI75S2ckntg4LG9
X-Received: by 2002:aa7:ca10:: with SMTP id y16mr25259116eds.280.1621864021091;
        Mon, 24 May 2021 06:47:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPkTP9wiMKTq+0E68+V5BGTrf6jaRLIXu0UfbVg9k7qiRvaWhBL7TNmlhZMT8iUV6Oqk7Xaw==
X-Received: by 2002:aa7:ca10:: with SMTP id y16mr25259085eds.280.1621864020793;
        Mon, 24 May 2021 06:47:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v12sm9830210edb.81.2021.05.24.06.46.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 06:47:00 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Convert vmx_tests.c comments to ASCII
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20210511220949.1019978-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a649abac-ceb4-9c99-4245-2f97ab5251dd@redhat.com>
Date:   Mon, 24 May 2021 15:46:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210511220949.1019978-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/05/21 00:09, Jim Mattson wrote:
> Some strange characters snuck into this file. Convert them to ASCII
> for better readability.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   x86/vmx_tests.c | 44 ++++++++++++++++++++++----------------------
>   1 file changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 2eb5962..179a55b 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -4049,13 +4049,13 @@ static void test_pi_desc_addr(u64 addr, bool ctrl)
>   }
>   
>   /*
> - * If the â€œprocess posted interruptsâ€ VM-execution control is 1, the
> + * If the "process posted interrupts" VM-execution control is 1, the
>    * following must be true:
>    *
> - *	- The â€œvirtual-interrupt deliveryâ€ VM-execution control is 1.
> - *	- The â€œacknowledge interrupt on exitâ€ VM-exit control is 1.
> + *	- The "virtual-interrupt delivery" VM-execution control is 1.
> + *	- The "acknowledge interrupt on exit" VM-exit control is 1.
>    *	- The posted-interrupt notification vector has a value in the
> - *	- range 0â€“255 (bits 15:8 are all 0).
> + *	- range 0 - 255 (bits 15:8 are all 0).
>    *	- Bits 5:0 of the posted-interrupt descriptor address are all 0.
>    *	- The posted-interrupt descriptor address does not set any bits
>    *	  beyond the processor's physical-address width.
> @@ -4179,7 +4179,7 @@ static void test_apic_ctls(void)
>   }
>   
>   /*
> - * If the â€œenable VPIDâ€ VM-execution control is 1, the value of the
> + * If the "enable VPID" VM-execution control is 1, the value of the
>    * of the VPID VM-execution control field must not be 0000H.
>    * [Intel SDM]
>    */
> @@ -4263,7 +4263,7 @@ static void test_invalid_event_injection(void)
>   	vmcs_write(ENT_INTR_ERROR, 0x00000000);
>   	vmcs_write(ENT_INST_LEN, 0x00000001);
>   
> -	/* The field’s interruption type is not set to a reserved value. */
> +	/* The field's interruption type is not set to a reserved value. */
>   	ent_intr_info = ent_intr_info_base | INTR_TYPE_RESERVED | DE_VECTOR;
>   	report_prefix_pushf("%s, VM-entry intr info=0x%x",
>   			    "RESERVED interruption type invalid [-]",
> @@ -4480,7 +4480,7 @@ skip_unrestricted_guest:
>   	/*
>   	 * If the interruption type is software interrupt, software exception,
>   	 * or privileged software exception, the VM-entry instruction-length
> -	 * field is in the range 0–15.
> +	 * field is in the range 0 - 15.
>   	 */
>   
>   	for (cnt = 0; cnt < 3; cnt++) {
> @@ -4686,8 +4686,8 @@ out:
>    *  VM-execution control must be 0.
>    *  [Intel SDM]
>    *
> - *  If the “virtual NMIs” VM-execution control is 0, the “NMI-window
> - *  exiting” VM-execution control must be 0.
> + *  If the "virtual NMIs" VM-execution control is 0, the "NMI-window
> + *  exiting" VM-execution control must be 0.
>    *  [Intel SDM]
>    */
>   static void test_nmi_ctrls(void)
> @@ -5448,14 +5448,14 @@ static void test_vm_execution_ctls(void)
>     * the VM-entry MSR-load count field is non-zero:
>     *
>     *    - The lower 4 bits of the VM-entry MSR-load address must be 0.
> -  *      The address should not set any bits beyond the processorâ€™s
> +  *      The address should not set any bits beyond the processor's
>     *      physical-address width.
>     *
>     *    - The address of the last byte in the VM-entry MSR-load area
> -  *      should not set any bits beyond the processorâ€™s physical-address
> +  *      should not set any bits beyond the processor's physical-address
>     *      width. The address of this last byte is VM-entry MSR-load address
>     *      + (MSR count * 16) - 1. (The arithmetic used for the computation
> -  *      uses more bits than the processorâ€™s physical-address width.)
> +  *      uses more bits than the processor's physical-address width.)
>     *
>     *
>     *  [Intel SDM]
> @@ -5574,14 +5574,14 @@ static void test_vm_entry_ctls(void)
>    * the VM-exit MSR-store count field is non-zero:
>    *
>    *    - The lower 4 bits of the VM-exit MSR-store address must be 0.
> - *      The address should not set any bits beyond the processor’s
> + *      The address should not set any bits beyond the processor's
>    *      physical-address width.
>    *
>    *    - The address of the last byte in the VM-exit MSR-store area
> - *      should not set any bits beyond the processor’s physical-address
> + *      should not set any bits beyond the processor's physical-address
>    *      width. The address of this last byte is VM-exit MSR-store address
>    *      + (MSR count * 16) - 1. (The arithmetic used for the computation
> - *      uses more bits than the processor’s physical-address width.)
> + *      uses more bits than the processor's physical-address width.)
>    *
>    * If IA32_VMX_BASIC[48] is read as 1, neither address should set any bits
>    * in the range 63:32.
> @@ -7172,7 +7172,7 @@ static void test_ctl_reg(const char *cr_name, u64 cr, u64 fixed0, u64 fixed1)
>    *    operation.
>    * 3. On processors that support Intel 64 architecture, the CR3 field must
>    *    be such that bits 63:52 and bits in the range 51:32 beyond the
> - *    processorâ€™s physical-address width must be 0.
> + *    processor's physical-address width must be 0.
>    *
>    *  [Intel SDM]
>    */
> @@ -7940,11 +7940,11 @@ static void test_load_guest_pat(void)
>   #define MSR_IA32_BNDCFGS_RSVD_MASK	0x00000ffc
>   
>   /*
> - * If the â€œload IA32_BNDCFGSâ€ VM-entry control is 1, the following
> + * If the "load IA32_BNDCFGS" VM-entry control is 1, the following
>    * checks are performed on the field for the IA32_BNDCFGS MSR:
>    *
> - *   â€”  Bits reserved in the IA32_BNDCFGS MSR must be 0.
> - *   â€”  The linear address in bits 63:12 must be canonical.
> + *   - Bits reserved in the IA32_BNDCFGS MSR must be 0.
> + *   - The linear address in bits 63:12 must be canonical.
>    *
>    *  [Intel SDM]
>    */
> @@ -8000,9 +8000,9 @@ do {									\
>   /*
>    * The following checks are done on the Selector field of the Guest Segment
>    * Registers:
> - *    — TR. The TI flag (bit 2) must be 0.
> - *    — LDTR. If LDTR is usable, the TI flag (bit 2) must be 0.
> - *    — SS. If the guest will not be virtual-8086 and the "unrestricted
> + *    - TR. The TI flag (bit 2) must be 0.
> + *    - LDTR. If LDTR is usable, the TI flag (bit 2) must be 0.
> + *    - SS. If the guest will not be virtual-8086 and the "unrestricted
>    *	guest" VM-execution control is 0, the RPL (bits 1:0) must equal
>    *	the RPL of the selector field for CS.
>    *
> 

Queued, thanks.

Paolo

