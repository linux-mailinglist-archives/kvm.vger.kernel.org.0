Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A05091533E4
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 16:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgBEPaj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 10:30:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41844 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726359AbgBEPaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 10:30:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580916637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=moBbJsc64Ii3lhPLqwdyLSBVDQd6xMAbYyJ+BA5TEEA=;
        b=bza7Hx70TCJV3G4DwnhUgT4LKkuQsuCWzSioWGsZKSqzXEq0FfLrjqa+SqbdleqxNfEm8m
        oVjLXRK2bPDGjc9/e3agJALMcl1hNKXO8ANZubULkU6BmvxBrgXHXebW51yuRfSuRS0Lzz
        Ls1+98GmtglQyvJVr/qGtbM48EdNY5k=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-_1sG5MV4PhyeaazB1nD6jg-1; Wed, 05 Feb 2020 10:30:35 -0500
X-MC-Unique: _1sG5MV4PhyeaazB1nD6jg-1
Received: by mail-wr1-f71.google.com with SMTP id t3so1333183wrm.23
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 07:30:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=moBbJsc64Ii3lhPLqwdyLSBVDQd6xMAbYyJ+BA5TEEA=;
        b=HGERlcJXnxWIBfgdhzqgAISG7E899QnBo+5i0f1RRcXMcBP5U+WqE52n3oyxLTqveL
         xlUgH25423cnGQw444RdE5ARqQDFRMlQytuEMJO93M4GNiO4KQfv4dH0Gb53Sq2hzogQ
         9IFOsWm1DVDXIUXc7dZ0CkeET6C4Xk5A/j98GBMMgcDm/SQiKYmiEAgEPzHQcTzRlnBB
         LnWs7+UoedpVolLvblHy2hxm4DCMtvPKLgA7QllDo3K2YYXB+7Dx/68IxsqpQe995WTJ
         V4yCqGRecnxokMSQbaHXNkTufnAQb8J/+QEu9M7fo5XO+KiMfIymLrNzPZ0QZYiVtXEz
         0Zug==
X-Gm-Message-State: APjAAAVpoasuVMWlVoNibaHb6mE2EwMFCEFRMLzdYQSreQJWRSevGJVT
        LSmLMbKpWoU2ijGdsbC+FcNk2BEmXrthze5JK7iJxWdKDqlHnHmsPpb61/H4xOcVFIkKF1v8i4R
        EZIppXDsK4xgf
X-Received: by 2002:a5d:4f8b:: with SMTP id d11mr27607535wru.87.1580916634272;
        Wed, 05 Feb 2020 07:30:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqzmVLL0VB9sQknIvinhqAh+AOK25JOU/h1W4GA++8d5Em1eRF5fiPuuCQpd8gHgCiyL1qmfSw==
X-Received: by 2002:a5d:4f8b:: with SMTP id d11mr27607517wru.87.1580916633970;
        Wed, 05 Feb 2020 07:30:33 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id f1sm169304wro.85.2020.02.05.07.30.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 07:30:33 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Mark CR4.UMIP as reserved based on associated
 CPUID bit
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200128235344.29581-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fc55c156-e689-0a3d-ae22-93c813630aa8@redhat.com>
Date:   Wed, 5 Feb 2020 16:30:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200128235344.29581-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/01/20 00:53, Sean Christopherson wrote:
> Re-add code to mark CR4.UMIP as reserved if UMIP is not supported by the
> host.  The UMIP handling was unintentionally dropped during a recent
> refactoring.
> 
> Not flagging CR4.UMIP allows the guest to set its CR4.UMIP regardless of
> host support or userspace desires.  On CPUs with UMIP support, including
> emulated UMIP, this allows the guest to enable UMIP against the wishes
> of the userspace VMM.  On CPUs without any form of UMIP, this results in
> a failed VM-Enter due to invalid guest state.
> 
> Fixes: 345599f9a2928 ("KVM: x86: Add macro to ensure reserved cr4 bits checks stay in sync")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7e3f1d937224..e70d1215638a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -898,6 +898,8 @@ EXPORT_SYMBOL_GPL(kvm_set_xcr);
>  		__reserved_bits |= X86_CR4_PKE;		\
>  	if (!__cpu_has(__c, X86_FEATURE_LA57))		\
>  		__reserved_bits |= X86_CR4_LA57;	\
> +	if (!__cpu_has(__c, X86_FEATURE_UMIP))		\
> +		__reserved_bits |= X86_CR4_UMIP;	\
>  	__reserved_bits;				\
>  })
>  
> 

Queued, thanks.

Paolo

