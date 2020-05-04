Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A651C3B15
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 15:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgEDNTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 09:19:33 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45523 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726404AbgEDNTc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 09:19:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588598370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y5YC7u0uAUwZps5v9qeTVARlcP53sa4chmEqYPiy2DU=;
        b=J796cI8BN60YGrVT9Y4FTGIH0FCgrGpqbCZLjigF6zwnZx61texL6iY5qsjW+N7nzTcV99
        isI0+2yvLleyxUEakEx4NzsbgDPifONz7oNdQSXwcTtWyKoPkt86tMwXKkQUrnN/4ncClg
        cxAF+cx6JO9TJVWy32ZV3K9iTd98dhY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-kTIvzoxzNdSvxSHFpu6tig-1; Mon, 04 May 2020 09:19:29 -0400
X-MC-Unique: kTIvzoxzNdSvxSHFpu6tig-1
Received: by mail-wr1-f70.google.com with SMTP id q13so1859165wrn.14
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 06:19:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y5YC7u0uAUwZps5v9qeTVARlcP53sa4chmEqYPiy2DU=;
        b=kWqyiN4CYjhR4vgTOb4lWSbvcvzXP48xjhRmUko67oHHFxJawKPCgKIk6ny1f59xkv
         d0DTau6inr9aNvLpfaqqOY0izoNShCuffqwL+U0OMFu5Qg1+ZJB4/8WjtanHqNP//uMQ
         sIbJ+Q4+V1WjoYQrIEElj1oRaFoRc0exrF48EaIjDbgKVhK7RAM5vH/hL7FBiRoUVFtR
         EaI6l0ozKEmnmmdajtud4Sks6tpx6kC1/oaeewPvww5H1HuSJWwFMVHL8qwCnw9dAjoY
         8AxE1V3LrWMARmZpFrYLt22DpESNsyDCcFVloJAPGKKAImUlKIPSw66URnwlly8faEOG
         JYNA==
X-Gm-Message-State: AGi0PuZmM6785pIzfC1q7r1HuaQXbpseFTzNg22T8CdveVqcR34xNGIp
        8B5kVqOi4iEDn24Ox4JAM7RS8utEDOUVuMGh90ruy3hq4CcqVIaxEAYxn6Zk3HdauxIb4mnpMcA
        Y1toAZH5np+pN
X-Received: by 2002:a7b:ca47:: with SMTP id m7mr15727718wml.55.1588598367562;
        Mon, 04 May 2020 06:19:27 -0700 (PDT)
X-Google-Smtp-Source: APiQypJSJ5WclevXzlwrOAyFhNpJ7zwzP5hPdJR6klqa4Z145sCzWMrN0JZJiVKhgd5TWeppuq6yFQ==
X-Received: by 2002:a7b:ca47:: with SMTP id m7mr15727692wml.55.1588598367274;
        Mon, 04 May 2020 06:19:27 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id v10sm19428804wrq.45.2020.05.04.06.19.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 06:19:26 -0700 (PDT)
Subject: Re: [PATCH 03/10] KVM: x86: Make kvm_x86_ops' {g,s}et_dr6() hooks
 optional
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200502043234.12481-1-sean.j.christopherson@intel.com>
 <20200502043234.12481-4-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <37a30f26-2561-aada-9bdc-7bc9cddf0d7f@redhat.com>
Date:   Mon, 4 May 2020 15:19:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200502043234.12481-4-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/05/20 06:32, Sean Christopherson wrote:
> Make get_dr6() and set_dr6() optional and drop the VMX implementations,
> which are for all intents and purposes nops.  This avoids a retpoline on
> VMX when reading/writing DR6, at minimal cost (~1 uop) to SVM.

Can't get_dr6 be killed off completely here, since vcpu->arch.dr6 is the
only value that is ever passed to set_dr6?  OTOH no complaint about
adding the if for vmx_set_dr6, since that will also be covered nicely by
DEFINE_STATIC_COND_CALL.

Paolo

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 11 -----------
>  arch/x86/kvm/x86.c     |  6 ++++--
>  2 files changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index de18cd386bb1..e157bdc218ea 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5008,15 +5008,6 @@ static int handle_dr(struct kvm_vcpu *vcpu)
>  	return kvm_skip_emulated_instruction(vcpu);
>  }
>  
> -static u64 vmx_get_dr6(struct kvm_vcpu *vcpu)
> -{
> -	return vcpu->arch.dr6;
> -}
> -
> -static void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val)
> -{
> -}
> -
>  static void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
>  {
>  	get_debugreg(vcpu->arch.db[0], 0);
> @@ -7799,8 +7790,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.set_idt = vmx_set_idt,
>  	.get_gdt = vmx_get_gdt,
>  	.set_gdt = vmx_set_gdt,
> -	.get_dr6 = vmx_get_dr6,
> -	.set_dr6 = vmx_set_dr6,
>  	.set_dr7 = vmx_set_dr7,
>  	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
>  	.cache_reg = vmx_cache_reg,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8ec356ac1e6e..eccbfcb6a4e5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1069,7 +1069,8 @@ static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
>  
>  static void kvm_update_dr6(struct kvm_vcpu *vcpu)
>  {
> -	if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
> +	if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
> +	    kvm_x86_ops.set_dr6)
>  		kvm_x86_ops.set_dr6(vcpu, vcpu->arch.dr6);
>  }
>  
> @@ -1148,7 +1149,8 @@ int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
>  	case 4:
>  		/* fall through */
>  	case 6:
> -		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
> +		if ((vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) ||
> +		    !kvm_x86_ops.get_dr6)
>  			*val = vcpu->arch.dr6;
>  		else
>  			*val = kvm_x86_ops.get_dr6(vcpu);
> 

