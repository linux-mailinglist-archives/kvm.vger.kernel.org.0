Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2382F3288
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 15:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387837AbhALODM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 09:03:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24102 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387659AbhALODM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 09:03:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610460105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g5hRSkHHWOdbmUsMs75Gf2Bt4kYflDDkT2OYvb6EzB8=;
        b=Oz5PHOu81IcShzIE0fScjaEBtsxf0d3kU0qEvAqKHZcyMMBIbxN1tLBxS+QJuTnv2VWseJ
        tGHKLJUDliu8/0ngvQCew7JTAK+zSS0+njvijTrn1/qSrSMCCCPWwiQ5kuw0BonkUm8T7k
        /VzSpLk5Jzu9We2Jz8XRL1uMeuD7Vqo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-UFVVUj0INgiJzdG31aCYJw-1; Tue, 12 Jan 2021 09:01:43 -0500
X-MC-Unique: UFVVUj0INgiJzdG31aCYJw-1
Received: by mail-ed1-f71.google.com with SMTP id l33so1038959ede.1
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 06:01:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g5hRSkHHWOdbmUsMs75Gf2Bt4kYflDDkT2OYvb6EzB8=;
        b=oGRzmp8LJDDJL4XXDvAUifvffEs/mjRSvjxZAIS0Ti45XJwTtisOFzZiKYHoX2D9fe
         2Os/UUoel3pLb3VdYhpu4YP8M2p1p06NzkpPagI0IxwSLS19oueF8TgoQcpdV+a7YbKX
         4qk+LQiWBy/zdUGncE0ATO9N1HqEZrHATbLFPBcYzefGsXVNylb4ljsh/xndpHis+gzs
         nAPPbFRl/S+h/0mqUec/708zRI0wQQBDB5Wzsn86HF6skPV1FWKDBy+Tuce9TYjjLrg+
         WNeJ8aTfcRYEmjcLPRJgxtMkrvNkERzis7EW7h9YoCCeuZkbBDjr/EwzgYKOvWYuFWqa
         aabQ==
X-Gm-Message-State: AOAM533Jt1DKQmm8aPkjWsULbklb9wBL3+GjnIKLTR+IlcDqUhWNhhDo
        eVkpC11g/gCex5faAZ6swqCag2wvBVBVxB4XoWaAdENBE5tInvvWv88FIgpwoLEETUkA/7jKm5l
        QoudJfYqE5d2i
X-Received: by 2002:a50:fe0e:: with SMTP id f14mr3606945edt.159.1610460102383;
        Tue, 12 Jan 2021 06:01:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxap/eHgcmvgWYqAcOrKRYNkiV+MI52ktIVcm0XqSPw9F27Ri+yoLTHdHtjOHHLYJvKzknNVA==
X-Received: by 2002:a50:fe0e:: with SMTP id f14mr3606930edt.159.1610460102224;
        Tue, 12 Jan 2021 06:01:42 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dd12sm1497632edb.6.2021.01.12.06.01.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 06:01:41 -0800 (PST)
To:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        seanjc@google.com, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, mlevitsk@redhat.com
References: <20210112063703.539893-1-wei.huang2@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by
 VM instructions
Message-ID: <090232a9-7a87-beb9-1402-726bb7cab7e6@redhat.com>
Date:   Tue, 12 Jan 2021 15:01:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210112063703.539893-1-wei.huang2@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/21 07:37, Wei Huang wrote:
>   static int gp_interception(struct vcpu_svm *svm)
>   {
>   	struct kvm_vcpu *vcpu = &svm->vcpu;
>   	u32 error_code = svm->vmcb->control.exit_info_1;
> -
> -	WARN_ON_ONCE(!enable_vmware_backdoor);
> +	int rc;
>   
>   	/*
> -	 * VMware backdoor emulation on #GP interception only handles IN{S},
> -	 * OUT{S}, and RDPMC, none of which generate a non-zero error code.
> +	 * Only VMware backdoor and SVM VME errata are handled. Neither of
> +	 * them has non-zero error codes.
>   	 */
>   	if (error_code) {
>   		kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
>   		return 1;
>   	}
> -	return kvm_emulate_instruction(vcpu, EMULTYPE_VMWARE_GP);
> +
> +	rc = kvm_emulate_instruction(vcpu, EMULTYPE_PARAVIRT_GP);
> +	if (rc > 1)
> +		rc = svm_emulate_vm_instr(vcpu, rc);
> +	return rc;
>   }
>   

Passing back the third byte is quick hacky.  Instead of this change to 
kvm_emulate_instruction, I'd rather check the instruction bytes in 
gp_interception before calling kvm_emulate_instruction.  That would be 
something like:

- move "kvm_clear_exception_queue(vcpu);" inside the "if 
(!(emulation_type & EMULTYPE_NO_DECODE))".  It doesn't apply when you 
are coming back from userspace.

- extract the "if (!(emulation_type & EMULTYPE_NO_DECODE))" body to a 
new function x86_emulate_decoded_instruction.  Call it from 
gp_interception, we know this is not a pagefault and therefore 
vcpu->arch.write_fault_to_shadow_pgtable must be false.

- check ctxt->insn_bytes for an SVM instruction

- if not an SVM instruction, call kvm_emulate_instruction(vcpu, 
EMULTYPE_VMWARE_GP|EMULTYPE_NO_DECODE).

Thanks,

Paolo

