Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF8B3EA86C
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 18:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhHLQS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 12:18:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35390 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229518AbhHLQS4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 12:18:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628785110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l49ZP/CsUxF11xSB6DgTSnYaUMf01RXS/9UvetQKxg4=;
        b=G8PUc1tCZEWbzWlOkurp0p2NO1aJPdxvjhm4RoG/eF8IYl9tgz9m6spwKbUdkc3xI8JbeM
        DEOJ8yrNcpiQ6Xqby8Zjmm6q4b3bi1v/D7NT0YyETaziLqTOHij1Cx0+JE2/emvx2DVbY2
        N2KXfHy4Kut5qxRe6ucHbfZeJ60i//0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-a1zkgmc0Ok6rqUck6Zr8eA-1; Thu, 12 Aug 2021 12:18:29 -0400
X-MC-Unique: a1zkgmc0Ok6rqUck6Zr8eA-1
Received: by mail-ej1-f72.google.com with SMTP id h17-20020a1709070b11b02905b5ced62193so2026497ejl.1
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 09:18:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l49ZP/CsUxF11xSB6DgTSnYaUMf01RXS/9UvetQKxg4=;
        b=DHsELoN2tviu7zc9ndBkFUYD5g/+ft/tkbh2a+v2ISHPn/MyQFGfifdj18rXaV1s4I
         bcCtW5Krmef3Wv2F9nSrb6iNNB9bPQAHTCrsUKEDG9kuAlL27Yoy4Dj6hMKmnPRnz1mW
         zWYbVpl40IxHJLHwMQbz03EwmWDpd5t/NtaSYGyCSeBGHuhJOx97hlsbKA2zA/u0N++J
         XHI7GL9s0iXNKuZpgtif5sHTt4by4XONMQ5jdHaF5ukdbFZ1TUazEnR6Dqwgr4Mj0HFI
         bLxKcHhr5gq6I5dHuXRFHjfWk/SjJ+iDqTVBIrfHFKEMcQwJLgA6cDE82RwGcwPbxTzg
         7Oqw==
X-Gm-Message-State: AOAM5308EUsnBbQIIBIYCnO/fmTwbFnPLYFKUfX7nUf/yc8X8ULynHNq
        lhigFsqUfUIrsEsnflo9/bshRP/XiFNxBaU9kCiIDWb5g1kRtdrpdrb2ZtJ85ZbXh1nOMqz/Cvl
        N3gHqtsk+dnRS
X-Received: by 2002:a17:906:b6c5:: with SMTP id ec5mr2729574ejb.184.1628785108005;
        Thu, 12 Aug 2021 09:18:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZ5IRiu874shKctSmYBLbNlnNCwD57470Ge9zmvsGefcq7pmdbi64K9Fsgc5Y3sAUpb6vVNQ==
X-Received: by 2002:a17:906:b6c5:: with SMTP id ec5mr2729554ejb.184.1628785107852;
        Thu, 12 Aug 2021 09:18:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gu2sm993259ejb.96.2021.08.12.09.18.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 09:18:25 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
References: <20210812050717.3176478-1-seanjc@google.com>
 <20210812050717.3176478-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Don't skip non-leaf SPTEs when zapping
 all SPTEs
Message-ID: <01b22936-49b0-638e-baf8-269ba93facd8@redhat.com>
Date:   Thu, 12 Aug 2021 18:18:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210812050717.3176478-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/08/21 07:07, Sean Christopherson wrote:
> @@ -739,8 +749,16 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>   			  gfn_t start, gfn_t end, bool can_yield, bool flush,
>   			  bool shared)
>   {
> +	bool zap_all = (end == ZAP_ALL_END);
>   	struct tdp_iter iter;
>   
> +	/*
> +	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
> +	 * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
> +	 * and so KVM will never install a SPTE for such addresses.
> +	 */
> +	end = min(end, 1ULL << (shadow_phys_bits - PAGE_SHIFT));

Then zap_all need not have any magic value.  You can use 0/-1ull, it's 
readable enough.  ZAP_ALL_END is also unnecessary here if you do:

	gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
	bool zap_all = (start == 0 && end >= max_gfn_host);

	end = min(end, max_gfn_host);

And as a small commit message nit, I would say "don't leak" instead of 
"don't skip", since that's really the effect.

Paolo


>   	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
>   
>   	rcu_read_lock();
> @@ -759,9 +777,10 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>   		/*
>   		 * If this is a non-last-level SPTE that covers a larger range
>   		 * than should be zapped, continue, and zap the mappings at a
> -		 * lower level.
> +		 * lower level, except when zapping all SPTEs.
>   		 */
> -		if ((iter.gfn < start ||
> +		if (!zap_all &&
> +		    (iter.gfn < start ||
>   		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end) &&

