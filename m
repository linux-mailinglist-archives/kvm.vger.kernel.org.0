Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD4A2ED5B8
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 18:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbhAGRe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 12:34:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726406AbhAGReZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 12:34:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610040779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NWnOL4WW0a/zTNNmDoc+8E5RK1NTv6x+0aetcVGVDMk=;
        b=D0GF20tKXX+z/0P4hDvUiBn3Pn0kGcLg/Ex2WIP8woG+G6og/ZP0YAUJCfVimsjtFEy7AT
        b0Qb7+bGNoSGtoDRDXajrQgEId/+71UYQXSyChd6OvYvl13w/iKHvvWQDIUHY5uk7YOwvy
        7OEdNy/WrAYKblzGjfl24MJcfUfiv9A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-P3p6Yo9iNXiHJcvM-0__RQ-1; Thu, 07 Jan 2021 12:32:56 -0500
X-MC-Unique: P3p6Yo9iNXiHJcvM-0__RQ-1
Received: by mail-wr1-f71.google.com with SMTP id g17so2928040wrr.11
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 09:32:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NWnOL4WW0a/zTNNmDoc+8E5RK1NTv6x+0aetcVGVDMk=;
        b=gWGa9nfpH7ZBm+wDURHyUwwOeLCybsQk2/fyb51wUMAA0RID+oQrZRa8+Tgf0YymFl
         JeIsKznMYmC0P9WrilMkOyawZu0xvggaxRU3dAB6yexPITdM7lPK6vMpDKfhsk2jcLI5
         us2Iwxuz6nV4MwtuiCzId0NYZhM510n2SOUnpJzCe438Noy8MPu/eIA0HgPwBjCifAKb
         gZC4AtdIAzzcTG1iJKyw8XwO7SzQA3/Ur7sTWDQO4pBwIiEmPazxiv8+C9NHQqeJddB3
         wwJjxxFUOkFI+y1MogJqiD6OPJdCbdHj3lBKT2isBkgIjlo9mvtNRcKorrSgwOrVFwTm
         Ii9Q==
X-Gm-Message-State: AOAM5312m+UKQK7gOXalz4htvOjN8jJpHU8kiZPCnHkeoBkFyH3Dp6MO
        1YixVR59VM0iYLuCb3kldTCYRYC0EmQIzhmFLtzUbw39fGlmnnlWm+xDPYY3NOeCrikFebO+NYl
        E8J2pMQ1t6oL5
X-Received: by 2002:adf:9e47:: with SMTP id v7mr9842388wre.185.1610040775460;
        Thu, 07 Jan 2021 09:32:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyzj6ERrKiiz6nNF/uGUGOK1Po7cuE8q0EYgZ+0gIBiGZ0O8mAcqYSykk7g7I+hTptjodXSOw==
X-Received: by 2002:adf:9e47:: with SMTP id v7mr9842375wre.185.1610040775315;
        Thu, 07 Jan 2021 09:32:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t188sm8326807wmf.9.2021.01.07.09.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 09:32:54 -0800 (PST)
Subject: Re: [PATCH v3 2/2] KVM: x86/mmu: Clarify TDP MMU page list invariants
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Leo Hou <leohou1402@gmail.com>
References: <20210107001935.3732070-1-bgardon@google.com>
 <20210107001935.3732070-2-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <12a3a6fd-557f-ae6f-4687-c4c4b2a79587@redhat.com>
Date:   Thu, 7 Jan 2021 18:32:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210107001935.3732070-2-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/01/21 01:19, Ben Gardon wrote:
>   
> -	/* List of struct tdp_mmu_pages being used as roots */
> +	/*
> +	 * List of struct tdp_mmu_pages being used as roots.
                           ^^^

s/tdp/kvm/

Queued with this change, thanks.

Paolo

> +	 * All struct kvm_mmu_pages in the list should have
> +	 * tdp_mmu_page set.
> +	 * All struct kvm_mmu_pages in the list should have a positive
> +	 * root_count except when a thread holds the MMU lock and is removing
> +	 * an entry from the list.
> +	 */
>   	struct list_head tdp_mmu_roots;
> -	/* List of struct tdp_mmu_pages not being used as roots */
> +
> +	/*
> +	 * List of struct tdp_mmu_pages not being used as roots.
> +	 * All struct kvm_mmu_pages in the list should have
> +	 * tdp_mmu_page set and a root_count of 0.
> +	 */

