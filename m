Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F74D401B22
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 14:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242208AbhIFMZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 08:25:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241829AbhIFMZV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 08:25:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630931057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5T3jMeGN4kX5wlrRjGBWKj+SsZVCRR2xQTk1YdLtOs4=;
        b=S2Ll9jT0xlWSYhgif9UJid51o7iLciOZyd26tkxVmAc1imc4t799S/cqSjzSix0kncmY85
        p4z0EibleGJP348VvQHFz8I8K3+OvzP4J24ZVeMw4Q0g1Gs28e6jcqZK++0o5j4TMAS06z
        q9YR7BQXvW0n8SSLegmd2fFyBAmFOzk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-XpBp1sueP6aZIrhmBtQ4pA-1; Mon, 06 Sep 2021 08:24:16 -0400
X-MC-Unique: XpBp1sueP6aZIrhmBtQ4pA-1
Received: by mail-ej1-f70.google.com with SMTP id bx10-20020a170906a1ca00b005c341820edeso2261952ejb.10
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 05:24:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5T3jMeGN4kX5wlrRjGBWKj+SsZVCRR2xQTk1YdLtOs4=;
        b=c0R26WVRcrwJ09W/OHawWCd0nCdq4m1hNROfLkj68DIWHfIbszq5aZBStvXCO9vVde
         UpG07onp+Ixw8sG6XBu55LObLsZoEPQhBAu8vEJvza3AFVsnI/yJR/KppbE73aY5WCwm
         5PtUg0zIU4UW2J81vZuwf0kEC6v53UwgnYlme6ANr76vXCS+POolsFokEgpbo22xkZZd
         CcKrUIFiQFNlbOxet316kHZ7QesRfpfm1qQo4r2iB+9B6Ohm6O9T3Y6AkizTQzFYnZmk
         8DfWm/NPCpuV3gV/750wQdSXDb+G5Oj04OyRkX8xj37NWL4QPKicHTzlKzX5WKu+TNpA
         v96w==
X-Gm-Message-State: AOAM530QPBq2c3uw7J/mF8J228cisceuc1soq2ij3EhU9m9Cp3pCqQei
        8f+TofD/eO00/Nn/qfjOVXX3sScMAP+XR+kRgWkvEov/bSAniGXbWdj0fG26tPAslk6SUfLSAF9
        56hf/eVML90At
X-Received: by 2002:a05:6402:b7c:: with SMTP id cb28mr12962444edb.152.1630931054922;
        Mon, 06 Sep 2021 05:24:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpxMI6NExBPU/SlkCnU4bFtlsTovlMfLu3JG5Ts6X/yfcGcvonJPvRojtNx12kOY5m7Vxgdw==
X-Received: by 2002:a05:6402:b7c:: with SMTP id cb28mr12962417edb.152.1630931054670;
        Mon, 06 Sep 2021 05:24:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q9sm3864150ejf.70.2021.09.06.05.24.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 05:24:14 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: Drop unused kvm_dirty_gfn_invalid()
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>
References: <20210901230904.15164-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <786bbcc9-50dd-51c9-61e1-fe04204ca3f6@redhat.com>
Date:   Mon, 6 Sep 2021 14:24:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210901230904.15164-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/09/21 01:09, Peter Xu wrote:
> Drop the unused function as reported by test bot.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> --
> v2:
> - Fix the subject that points to the right function; the copy-paste failed.
> ---
>   virt/kvm/dirty_ring.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 7aafefc50aa7..88f4683198ea 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -91,11 +91,6 @@ static inline void kvm_dirty_gfn_set_dirtied(struct kvm_dirty_gfn *gfn)
>   	gfn->flags = KVM_DIRTY_GFN_F_DIRTY;
>   }
>   
> -static inline bool kvm_dirty_gfn_invalid(struct kvm_dirty_gfn *gfn)
> -{
> -	return gfn->flags == 0;
> -}
> -
>   static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
>   {
>   	return gfn->flags & KVM_DIRTY_GFN_F_RESET;
> 

Queued, thanks.

Paolo

