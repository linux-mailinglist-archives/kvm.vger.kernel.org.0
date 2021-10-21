Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF08B43698F
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 19:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhJURrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 13:47:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232306AbhJURpw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 13:45:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634838216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yFYGUqJyf8v0Sn/9vFF7sfYJZCakTnG5YIZAKXgaBZ4=;
        b=UV5B6OW5KArJRqrsVevE8+q5nN/R1GvMPsv0SRCN5vq0rj2rUDIj8x2JyQVHm2uvfUxLvS
        1z3P3G3r4DmtKWFSYx/4EW4DPh/CyCA/7sFXu1ufeTXrx6nqQFPjj3yF1630xMvY+6qX9c
        PQVp6FPVJ3bBOmEUAr5hvN8TUupteKI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-AN8FyuN9OFSGseKX6N7OqA-1; Thu, 21 Oct 2021 13:43:35 -0400
X-MC-Unique: AN8FyuN9OFSGseKX6N7OqA-1
Received: by mail-ed1-f70.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so1118594edi.12
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:43:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yFYGUqJyf8v0Sn/9vFF7sfYJZCakTnG5YIZAKXgaBZ4=;
        b=lUdxqEhEc6r4I0qGCGPhlVT6MH6KJrAWfdIAERse5Hz9CvnCIlCGuF96dpZQaDQ58f
         URKVwVYCmYcHz8vQW6VhGcFj1xKS9F/ikBt72WAVqZNuraJhX9hvpTJ4/gYrqjoDKmMi
         zTMfimNuJc5tNujXFUSNhS2kT19rDy2VX0S9NDWvPae8L+tsizZZNmzyYMxHoFhopjD/
         k52V7kdFJNMd8QKqqMpMx/ADyprfJxaMQa8QLX0M31VD7Ykry1qMX+U6Kg988UEAcHw4
         /mNxCJkk1dT5ijY5WF5ZO/EqHRVKEHlMAuNxe/awb9if9QhtLKSPUxx4VNsRK7jzhAkr
         BAgg==
X-Gm-Message-State: AOAM531Aumt6RWRTo2fXu5pZX8FGwZJHwEBBsJyR31eSpylxdZDyyYhk
        PssDs56FbmLpassLuSJuetmIrl+SqjM0/NuhKaqUUlEIJRmb0ewRM8JiaXrYj7gKu5XMeEoJ3p3
        oZiTC2I4Ro6Br
X-Received: by 2002:a17:906:b816:: with SMTP id dv22mr8905969ejb.461.1634838213880;
        Thu, 21 Oct 2021 10:43:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnRBpwcPyrvVGQyZg9zzC9trOZQbbFQNNiAe1MsANZkdq1KvUWui9AjBxK0J3OuJN5JRDbqg==
X-Received: by 2002:a17:906:b816:: with SMTP id dv22mr8905932ejb.461.1634838213639;
        Thu, 21 Oct 2021 10:43:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id w1sm2835756edd.17.2021.10.21.10.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 10:43:33 -0700 (PDT)
Message-ID: <593cdae9-c49d-6977-24d5-191f723188d7@redhat.com>
Date:   Thu, 21 Oct 2021 19:43:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 2/4] KVM: X86: Cache CR3 in prev_roots when PCID is
 disabled
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211019110154.4091-1-jiangshanlai@gmail.com>
 <20211019110154.4091-3-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211019110154.4091-3-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/21 13:01, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> The commit 21823fbda5522 ("KVM: x86: Invalidate all PGDs for the
> current PCID on MOV CR3 w/ flush") invalidates all PGDs for the specific
> PCID and in the case of PCID is disabled, it includes all PGDs in the
> prev_roots and the commit made prev_roots totally unused in this case.
> 
> Not using prev_roots fixes a problem when CR4.PCIDE is changed 0 -> 1
> before the said commit:
> 	(CR4.PCIDE=0, CR3=cr3_a, the page for the guest
> 	 kernel is global, cr3_b is cached in prev_roots)
> 
> 	modify the user part of cr3_b
> 		the shadow root of cr3_b is unsync in kvm
> 	INVPCID single context
> 		the guest expects the TLB is clean for PCID=0
> 	change CR4.PCIDE 0 -> 1
> 	switch to cr3_b with PCID=0,NOFLUSH=1
> 		No sync in kvm, cr3_b is still unsync in kvm
> 	return to the user part (of cr3_b)
> 		the user accesses to wrong page
> 
> It is a very unlikely case, but it shows that virtualizing guest TLB in
> prev_roots is not safe in this case and the said commit did fix the
> problem.
> 
> But the said commit also disabled caching CR3 in prev_roots when PCID
> is disabled and NOT all CPUs have PCID, especially the PCID support
> for AMD CPUs is kind of recent.  To restore the original optimization,
> we have to enable caching CR3 without re-introducing problems.
> 
> Actually, in short, the said commit just ensures prev_roots not part of
> the virtualized TLB.  So this change caches CR3 in prev_roots, and
> ensures prev_roots not part of the virtualized TLB by always flushing
> the virtualized TLB when CR3 is switched from prev_roots to current
> (it is already the current behavior) and by freeing prev_roots when
> CR4.PCIDE is changed 0 -> 1.
> 
> Anyway:
> PCID enabled: vTLB includes root_hpa, prev_roots and hardware TLB.
> PCID disabled: vTLB includes root_hpa and hardware TLB, no prev_roots.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   arch/x86/kvm/x86.c | 32 ++++++++++++++++++++++++++++++--
>   1 file changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 06169ed08db0..13df3ca88e09 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1022,10 +1022,29 @@ EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
>   
>   void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
>   {
> +	/*
> +	 * If any role bit is changed, the MMU needs to be reset.
> +	 *
> +	 * If CR4.PCIDE is changed 0 -> 1, there is no need to flush the guest
> +	 * TLB per SDM, but the virtualized TLB doesn't include prev_roots when
> +	 * CR4.PCIDE is 0, so the prev_roots has to be freed to avoid later
> +	 * resuing without explicit flushing.
> +	 * If CR4.PCIDE is changed 1 -> 0, there is required to flush the guest
> +	 * TLB and KVM_REQ_MMU_RELOAD is fit for the both cases.  Although
> +	 * KVM_REQ_MMU_RELOAD is slow, changing CR4.PCIDE is a rare case.

          * If CR4.PCIDE is changed 1 -> 0, the guest TLB must be flushed.
          * If CR4.PCIDE is changed 0 -> 1, there is no need to flush the TLB
          * according to the SDM; however, stale prev_roots could be reused
          * reused incorrectly by MOV to CR3 with NOFLUSH=1, so we free them
          * all.  KVM_REQ_MMU_RELOAD is fit for the both cases; it
          * is slow, but changing CR4.PCIDE is a rare case.

> +	 * If CR4.PGE is changed, there is required to just flush the guest TLB.
> +	 *
> +	 * Note: reseting MMU covers KVM_REQ_MMU_RELOAD and KVM_REQ_MMU_RELOAD
> +	 * covers KVM_REQ_TLB_FLUSH_GUEST, so "else if" is used here and the
> +	 * check for later cases are skipped if the check for the preceding
> +	 * case is matched.

          * Note: resetting MMU is a superset of KVM_REQ_MMU_RELOAD and
          * KVM_REQ_MMU_RELOAD is a superset of KVM_REQ_TLB_FLUSH_GUEST, hence
          * the usage of "else if".

> +	 */
>   	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
>   		kvm_mmu_reset_context(vcpu);
> -	else if (((cr4 ^ old_cr4) & X86_CR4_PGE) ||
> -		 (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
> +	else if ((cr4 ^ old_cr4) & X86_CR4_PCIDE)
> +		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
> +	else if ((cr4 ^ old_cr4) & X86_CR4_PGE)
>   		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
>   }
>   EXPORT_SYMBOL_GPL(kvm_post_set_cr4);
> @@ -1093,6 +1112,15 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
>   		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>   	}
>   
> +	/*
> +	 * If PCID is disabled, there is no need to free prev_roots even the
> +	 * PCIDs for them are also 0.  The prev_roots are just not included
> +	 * in the "clean" virtualized TLB and a resync will happen anyway
> +	 * before switching to any other CR3.
> +	 */

         /*
          * If PCID is disabled, there is no need to free prev_roots even if the
          * PCIDs for them are also 0, because all moves to CR3 flush the TLB
          * with PCID=0.
          */

> +	if (!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
> +		return;
> +
>   	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
>   		if (kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd) == pcid)
>   			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
> 


Can you confirm the above comments are accurate?

Paolo

