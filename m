Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2793325E9E
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 09:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhBZIFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 03:05:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47126 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230125AbhBZIFI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Feb 2021 03:05:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614326621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HV5MSlda6N597b7xTJHRQ+L2lFOzy5bnowVO9E3RZ1I=;
        b=Dagp2sIF2GfVCzQ2ZOQbK37DTrdflH2V0/a/j9u30EEyZOcB6v6SurYLFRiWnhuvi/YjrF
        eN0rQjvA9o4CbMFix5UZbmBo2EWiPGHpJ49uALbcLO7y2l92wzZGgglwRcR8sL+67MeZCN
        V5db0ed9sm6VhYVjmOsTuvp+/eFJSoM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-wZ44h42tN5uSpGZqLyVUJg-1; Fri, 26 Feb 2021 03:03:39 -0500
X-MC-Unique: wZ44h42tN5uSpGZqLyVUJg-1
Received: by mail-ed1-f70.google.com with SMTP id p12so4091555edw.9
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 00:03:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HV5MSlda6N597b7xTJHRQ+L2lFOzy5bnowVO9E3RZ1I=;
        b=qLFbAFUDA5NaSM8d+/dbqptnVWh8rcbOB+ypy2t3zVHpyE+wR1GhVeKa32+IDfAIax
         ZWWoc1an+uo6WN9AprkIloJkFy7o7WYYm70yi0xoC3bjRPmadwnAO/VvtkYrcOHXyxAE
         khZa8XkNOZgI6kPVpHS4gWL3Za6LhDD5yXROS4gUNl3Bk911dT8KYko963JK91/0bi/J
         oQ5HxIPOQKo573yV1u4kZ7mrM7EZIlccR9Qyu8Y6+u+SRYNXH/LsSekhgvjfLYvdQxiQ
         rnAsqOdmKbhwZxLPmbeVISKs4wyKu2u48wpwFV5A0U2lfXYpNoWGXLTJyPqXk5aCKqr/
         6/XA==
X-Gm-Message-State: AOAM533lD0NMgufQLIbn3xu16FmmFfRXyadZMJufJ7XFq4j1z1nXpZ5D
        K1236n8323QKz0A9rMoy5U+xlychd2OJCznofKRY27mKEsHV0fm4YDDNwT4tncPdAWQK6ZR4rHG
        zJQXuwfkU63qQ
X-Received: by 2002:a05:6402:229a:: with SMTP id cw26mr1907104edb.224.1614326618118;
        Fri, 26 Feb 2021 00:03:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyfJ/56anmdqRgmUDCVI/eXzg0ztaoCYcPKcBOmWVb3dRcYNUvgm0Qxijvi78GBg1a1ORFB1Q==
X-Received: by 2002:a05:6402:229a:: with SMTP id cw26mr1907083edb.224.1614326617991;
        Fri, 26 Feb 2021 00:03:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l7sm5058597edv.50.2021.02.26.00.03.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 00:03:37 -0800 (PST)
Subject: Re: [PATCH v2 1/1] KVM: x86: remove misplaced comment on
 active_mmu_pages
To:     Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org,
        x86@kernel.org
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
References: <20210226061945.1222-1-dongli.zhang@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <78662af6-be71-4a81-8999-5b7011682728@redhat.com>
Date:   Fri, 26 Feb 2021 09:03:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210226061945.1222-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/02/21 07:19, Dongli Zhang wrote:
> The 'mmu_page_hash' is used as hash table while 'active_mmu_pages' is a
> list. Remove the misplaced comment as it's mostly stating the obvious
> anyways.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---
> Changed since v1:
>    - change 'incorrect' to 'misplaced'
> 
>   arch/x86/include/asm/kvm_host.h | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 84499aad01a4..318242512407 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -937,9 +937,6 @@ struct kvm_arch {
>   	unsigned int indirect_shadow_pages;
>   	u8 mmu_valid_gen;
>   	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
> -	/*
> -	 * Hash table of struct kvm_mmu_page.
> -	 */
>   	struct list_head active_mmu_pages;
>   	struct list_head zapped_obsolete_pages;
>   	struct list_head lpage_disallowed_mmu_pages;
> 

Queued, thanks.

Paolo

