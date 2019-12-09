Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2DB117058
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 16:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfLIP0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 10:26:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32777 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726197AbfLIP0A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 10:26:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575905158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HG0F2juZ36JfdXhTGYpL+xnjYJicEBnT0mtVQz3eXXk=;
        b=VueNnRZLcxAjnF4Xn43UgVXgVIny1NETUWAnQewCjt4HF6xcl3QQ4ejYpDpCTM/1lKTX+d
        wvFDlBW8slDuA5hw3/wtz42+o6PYLnjbYgs0jL80rAMRGl+QYNEcOyMQda2PAmiMfB/2+x
        Yd1Bw+JrjQzsuxdFxbUa0B6KhIm0lM4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-BxfnDRkmMd66uCmmWr71AQ-1; Mon, 09 Dec 2019 10:25:56 -0500
Received: by mail-wr1-f71.google.com with SMTP id 90so7598253wrq.6
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2019 07:25:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HG0F2juZ36JfdXhTGYpL+xnjYJicEBnT0mtVQz3eXXk=;
        b=E1MlLURupkJ6M5rl5TyLaUDRGfTYZ+phAkuyJv0DXAozo+rb3sIwa1L8B4dGTwDuJ2
         YSum3yOehoG1P7lSK/8563EP1unCdZzUFDzcG/xnjKrgaf+B0q/NeFUrRAnksRdEVtcw
         DQHv5+Bk+4ZGQvyUF8cuGUbQUQYdUx7k4K6txzJ1kFMofNg3sJlk7vPZKDR2yOoyo78h
         GuGQ23gHdZPC1T548kymrAxKlKFu5XCHdo5RdfQEkjh9M3MgNELnkuJmVf0czxI+A7pL
         IvXCBgXSunlKorPMKHReBcTdhx2nxix81Nm40B26tABrKYBjFHbniWGjshuSTOrknTTt
         wgQA==
X-Gm-Message-State: APjAAAXweOTOcwtbgnArzxjgziuncNuGkaI914y6cGWA2446a0LCRBty
        FSlOfPEnKY9CEp81qwtWPIdwJ8nH6jiNB4PtIU4pKGFo94Tdcco/BJjm7Cp1bSaU6k90Km44s3E
        50HOZBCnaKyoS
X-Received: by 2002:adf:f70b:: with SMTP id r11mr2963061wrp.388.1575905155224;
        Mon, 09 Dec 2019 07:25:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqzhG97fssrcBK2f8brLRzZIKABACUSRiEiNmiXmQ2IIp6Xnn2ZAuO70x3BUwmkXW8OZzgsCfA==
X-Received: by 2002:adf:f70b:: with SMTP id r11mr2963021wrp.388.1575905154855;
        Mon, 09 Dec 2019 07:25:54 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id m7sm71336wma.39.2019.12.09.07.25.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 07:25:54 -0800 (PST)
Subject: Re: [PATCH v3 3/3] kvm: nVMX: Aesthetic cleanup of handle_vmread and
 handle_vmwrite
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jon Cargille <jcargill@google.com>
References: <20191206234637.237698-1-jmattson@google.com>
 <20191206234637.237698-3-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3de38099-e94b-58d5-4bf4-56d2fd0d0956@redhat.com>
Date:   Mon, 9 Dec 2019 16:25:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191206234637.237698-3-jmattson@google.com>
Content-Language: en-US
X-MC-Unique: BxfnDRkmMd66uCmmWr71AQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/12/19 00:46, Jim Mattson wrote:
> Apply reverse fir tree declaration order, shorten some variable names
> to avoid line wrap, reformat a block comment, delete an extra blank
> line, and use BIT(10) instead of (1u << 10).
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Jon Cargille <jcargill@google.com>
> ---
> v1 -> v2:
>  * New commit in v2.
> v2 -> v3:
>  * Shortened some variable names instead of wrapping long lines.
>  * Changed BIT_ULL to BIT.
> 
>  arch/x86/kvm/vmx/nested.c | 70 +++++++++++++++++++--------------------
>  1 file changed, 34 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 94ec089d6d1a..336fe366a25f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4751,17 +4751,17 @@ static int handle_vmresume(struct kvm_vcpu *vcpu)
>  
>  static int handle_vmread(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long field;
> -	u64 field_value;
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
> -	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
> -	int len;
> -	gva_t gva = 0;
>  	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
>  						    : get_vmcs12(vcpu);
> +	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
> +	u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	struct x86_exception e;
> +	unsigned long field;
> +	u64 value;
> +	gva_t gva = 0;
>  	short offset;
> +	int len;
>  
>  	if (!nested_vmx_check_permission(vcpu))
>  		return 1;
> @@ -4776,7 +4776,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>  		return nested_vmx_failInvalid(vcpu);
>  
>  	/* Decode instruction info and find the field to read */
> -	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
> +	field = kvm_register_readl(vcpu, (((instr_info) >> 28) & 0xf));
>  
>  	offset = vmcs_field_to_offset(field);
>  	if (offset < 0)
> @@ -4786,24 +4786,23 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>  	if (!is_guest_mode(vcpu) && is_vmcs12_ext_field(field))
>  		copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
>  
> -	/* Read the field, zero-extended to a u64 field_value */
> -	field_value = vmcs12_read_any(vmcs12, field, offset);
> +	/* Read the field, zero-extended to a u64 value */
> +	value = vmcs12_read_any(vmcs12, field, offset);
>  
>  	/*
>  	 * Now copy part of this value to register or memory, as requested.
>  	 * Note that the number of bits actually copied is 32 or 64 depending
>  	 * on the guest's mode (32 or 64 bit), not on the given field's length.
>  	 */
> -	if (vmx_instruction_info & (1u << 10)) {
> -		kvm_register_writel(vcpu, (((vmx_instruction_info) >> 3) & 0xf),
> -			field_value);
> +	if (instr_info & BIT(10)) {
> +		kvm_register_writel(vcpu, (((instr_info) >> 3) & 0xf), value);
>  	} else {
>  		len = is_64_bit_mode(vcpu) ? 8 : 4;
>  		if (get_vmx_mem_address(vcpu, exit_qualification,
> -				vmx_instruction_info, true, len, &gva))
> +					instr_info, true, len, &gva))
>  			return 1;
>  		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
> -		if (kvm_write_guest_virt_system(vcpu, gva, &field_value, len, &e))
> +		if (kvm_write_guest_virt_system(vcpu, gva, &value, len, &e))
>  			kvm_inject_page_fault(vcpu, &e);
>  	}
>  
> @@ -4836,24 +4835,25 @@ static bool is_shadow_field_ro(unsigned long field)
>  
>  static int handle_vmwrite(struct kvm_vcpu *vcpu)
>  {
> +	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
> +						    : get_vmcs12(vcpu);
> +	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
> +	u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	struct x86_exception e;
>  	unsigned long field;
> -	int len;
> +	short offset;
>  	gva_t gva;
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
> -	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
> +	int len;
>  
> -	/* The value to write might be 32 or 64 bits, depending on L1's long
> +	/*
> +	 * The value to write might be 32 or 64 bits, depending on L1's long
>  	 * mode, and eventually we need to write that into a field of several
>  	 * possible lengths. The code below first zero-extends the value to 64
> -	 * bit (field_value), and then copies only the appropriate number of
> +	 * bit (value), and then copies only the appropriate number of
>  	 * bits into the vmcs12 field.
>  	 */
> -	u64 field_value = 0;
> -	struct x86_exception e;
> -	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
> -						    : get_vmcs12(vcpu);
> -	short offset;
> +	u64 value = 0;
>  
>  	if (!nested_vmx_check_permission(vcpu))
>  		return 1;
> @@ -4867,22 +4867,20 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
>  	     get_vmcs12(vcpu)->vmcs_link_pointer == -1ull))
>  		return nested_vmx_failInvalid(vcpu);
>  
> -	if (vmx_instruction_info & (1u << 10))
> -		field_value = kvm_register_readl(vcpu,
> -			(((vmx_instruction_info) >> 3) & 0xf));
> +	if (instr_info & BIT(10))
> +		value = kvm_register_readl(vcpu, (((instr_info) >> 3) & 0xf));
>  	else {
>  		len = is_64_bit_mode(vcpu) ? 8 : 4;
>  		if (get_vmx_mem_address(vcpu, exit_qualification,
> -				vmx_instruction_info, false, len, &gva))
> +					instr_info, false, len, &gva))
>  			return 1;
> -		if (kvm_read_guest_virt(vcpu, gva, &field_value, len, &e)) {
> +		if (kvm_read_guest_virt(vcpu, gva, &value, len, &e)) {
>  			kvm_inject_page_fault(vcpu, &e);
>  			return 1;
>  		}
>  	}
>  
> -
> -	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
> +	field = kvm_register_readl(vcpu, (((instr_info) >> 28) & 0xf));
>  
>  	offset = vmcs_field_to_offset(field);
>  	if (offset < 0)
> @@ -4914,9 +4912,9 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
>  	 * the stripped down value, L2 sees the full value as stored by KVM).
>  	 */
>  	if (field >= GUEST_ES_AR_BYTES && field <= GUEST_TR_AR_BYTES)
> -		field_value &= 0x1f0ff;
> +		value &= 0x1f0ff;
>  
> -	vmcs12_write_any(vmcs12, field, offset, field_value);
> +	vmcs12_write_any(vmcs12, field, offset, value);
>  
>  	/*
>  	 * Do not track vmcs12 dirty-state if in guest-mode as we actually
> @@ -4933,7 +4931,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
>  			preempt_disable();
>  			vmcs_load(vmx->vmcs01.shadow_vmcs);
>  
> -			__vmcs_writel(field, field_value);
> +			__vmcs_writel(field, value);
>  
>  			vmcs_clear(vmx->vmcs01.shadow_vmcs);
>  			vmcs_load(vmx->loaded_vmcs->vmcs);
> 

Queued, thanks.

Paolo

