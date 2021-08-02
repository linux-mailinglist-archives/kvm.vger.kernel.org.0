Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABD23DD764
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 15:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbhHBNkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 09:40:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41714 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233916AbhHBNkX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 09:40:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627911613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WKwQt8hS8BrVUXgi476JAPrD0widSfYwWzVDlE+fv9w=;
        b=SN/powEelJP4C9d/6KHkkeRZBjt9siO20hZLvxqcK2pfFAv51cu/XK0eT/KzbJCqn86UW4
        AhZ4i4ISxX0/dD6e1Yr3Hh1PO7r/7RfYV08AXQEHL0SrAOh65MnV9LgCcVo+tcZEdEaPY4
        yVqEpzwbL4ueyxSvaupl0FhBQ+518Oc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-nr6HDYI6Ma-pgo8lLAgeTg-1; Mon, 02 Aug 2021 09:40:12 -0400
X-MC-Unique: nr6HDYI6Ma-pgo8lLAgeTg-1
Received: by mail-ej1-f72.google.com with SMTP id a19-20020a1709063e93b0290551ea218ea2so4692312ejj.5
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 06:40:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WKwQt8hS8BrVUXgi476JAPrD0widSfYwWzVDlE+fv9w=;
        b=k6u+puvnlNVh+fqEBivAIgMhhrtZTtQlrqRagGNlWHvGb3M493E3/OC+GyFzEmmrD0
         nTh8vSM4/pI8JocM92Vk8j8AnD5ftiFppzKG42ON8yMG+6GP2rOmQYp8xs2fkqXMlJcp
         2TZn6zn55/6gIqyKBX80dXEbOhoyB18PdlMLot21/RpDv55RItZprEM162lgrFxxOanr
         5LBmRDHGedGaM59DNSfw8uYceF/f4nXMMvQoizB2QUPvFhQGMn2UEgw7Uzu7kPtq7fz2
         JXbNuE+qwFKp0OKdR9nzdZPVz1iLJO27G6DiTTJiFAQDZSRpoaOjmWNEA6iZ3dbWRbvc
         kM6g==
X-Gm-Message-State: AOAM5317DsZvFdxSnTSa9SJntd5IGz+juqGT0tMXGwGpmQeS584sY3vO
        qf9EpYqXTyEuVwYaEwLeK8VD6nA/hEz+ITiqLW9ZeQXfvnpbd8hh/QWUSLHsAijrWdYjs9WzHwE
        JThL6ikUMGE/Fxj/xZdE4GYd0QXozWfqzqKyF8gOaD6654M9ttfBp9F3l13IIn99i
X-Received: by 2002:a05:6402:1a3a:: with SMTP id be26mr19172067edb.232.1627911611303;
        Mon, 02 Aug 2021 06:40:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUWEzOJJD/hxS92H0wTVDl/3c+XTETCnw/2v3cRopIXxvPQkBYzXV1oByaHJLt1XJdso7X1Q==
X-Received: by 2002:a05:6402:1a3a:: with SMTP id be26mr19172028edb.232.1627911611022;
        Mon, 02 Aug 2021 06:40:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x42sm6170929edy.86.2021.08.02.06.40.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 06:40:10 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: const-ify all relevant uses of struct
 kvm_memory_slot
To:     Hamza Mahfooz <someguy@effective-light.com>,
        linux-kernel@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <20210730222704.61672-1-someguy@effective-light.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fcab24b9-0573-9165-20e9-683586e86bdf@redhat.com>
Date:   Mon, 2 Aug 2021 15:40:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210730222704.61672-1-someguy@effective-light.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/21 00:27, Hamza Mahfooz wrote:
> @@ -1440,7 +1440,7 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>   
>   struct slot_rmap_walk_iterator {
>   	/* input fields. */
> -	struct kvm_memory_slot *slot;
> +	const struct kvm_memory_slot *slot;
>   	gfn_t start_gfn;
>   	gfn_t end_gfn;
>   	int start_level;
> @@ -1467,16 +1467,20 @@ rmap_walk_init_level(struct slot_rmap_walk_iterator *iterator, int level)
>   
>   static void
>   slot_rmap_walk_init(struct slot_rmap_walk_iterator *iterator,
> -		    struct kvm_memory_slot *slot, int start_level,
> +		    const struct kvm_memory_slot *slot, int start_level,
>   		    int end_level, gfn_t start_gfn, gfn_t end_gfn)
>   {
> -	iterator->slot = slot;
> -	iterator->start_level = start_level;
> -	iterator->end_level = end_level;
> -	iterator->start_gfn = start_gfn;
> -	iterator->end_gfn = end_gfn;
> +	struct slot_rmap_walk_iterator iter = {
> +		.slot = slot,
> +		.start_gfn = start_gfn,
> +		.end_gfn = end_gfn,
> +		.start_level = start_level,
> +		.end_level = end_level
> +	};
> +
> +	rmap_walk_init_level(&iter, start_level);
>   
> -	rmap_walk_init_level(iterator, iterator->start_level);
> +	memcpy(iterator, &iter, sizeof(struct slot_rmap_walk_iterator));
>   }
>   
>   static bool slot_rmap_walk_okay(struct slot_rmap_walk_iterator *iterator)

I don't understand, just changing the argument works.  There is no need 
to change the body of the function.

Paolo

