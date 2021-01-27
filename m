Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC983062CA
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 18:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343922AbhA0R5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 12:57:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232813AbhA0R5P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 12:57:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611770142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oa6nOZmQZG0+dBvwBMf8HGHhXEGlB2LPuxfZONvSPNw=;
        b=EN8BEhLa1VpK3sR+RvHIitn3wYiuqtBN6W1yZbImiP6azf9z4oOqzAR2aZbf2QI/c4mv35
        SHz1Cvh4qFBBafqKRjB1MbzYxRCuny62LgVM6oa0oHAkyzpmq+1wR/ls3fMgJxNyi4PIjx
        kszz+eCcyiBdxi+o2WYF+DNrfN8LbRs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-k6gqr9jvPd2LM7vCS7PRlQ-1; Wed, 27 Jan 2021 12:55:40 -0500
X-MC-Unique: k6gqr9jvPd2LM7vCS7PRlQ-1
Received: by mail-ed1-f69.google.com with SMTP id u26so838000edv.18
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 09:55:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=oa6nOZmQZG0+dBvwBMf8HGHhXEGlB2LPuxfZONvSPNw=;
        b=cjAqKhB6dn3AYB1JnIG+VU8njcARGYhULqYUq0ScDS7gEwTnG1jzDnAD1XnLoxYVEF
         2/u1MTjBcWwXhtg/AI/djfF9XFdgNlAuAe70nU4usf3IVT045rrbS/2l02KWN0mQMFN7
         9zZqoSBuWLlXM/yTCOZHUJgHADMPrl0WAHsbOxsU4uXDhLX6lha3xzJNL2F7KFL7+sHq
         Dj29ZpYM1W9iR2FUKH286erSwDnSeoxjg/vk4YNApIO9E0e//zayJY3yV17PoJVeybF0
         1xctXuG1tJWZWXktI85jYjVNe1h0l6pf116tz4NLCbf8QL+LHigKkQOdi7OvPjvSyJ5B
         J1mQ==
X-Gm-Message-State: AOAM530ZUoBslYpobnLAQrtDxPZp+BuAPDIyd3bWz7/qc4dbG8Uy3bOu
        7k8hacRsAH4lZmwUMsZSvbMTsh/eUKEXLi+p8adf41UX8P+fpzcunV0WLmi3G7QYxsr0aIu8mLR
        eHog2p5wkLERJ
X-Received: by 2002:aa7:c7d8:: with SMTP id o24mr10358197eds.328.1611770139414;
        Wed, 27 Jan 2021 09:55:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGiG7cOa5PmC/w0qpUK6w4AsiarRmJ0LxHZaZeP/Cn0KI1aIMnkHsrit0BshfWNlcrczkP0A==
X-Received: by 2002:aa7:c7d8:: with SMTP id o24mr10358183eds.328.1611770139269;
        Wed, 27 Jan 2021 09:55:39 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x25sm1670338edv.65.2021.01.27.09.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 09:55:38 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC 0/4] KVM: x86: Drastically raise KVM_USER_MEM_SLOTS
 limit
In-Reply-To: <40efcfa8-c625-80b5-7ac9-da7839ed6011@oracle.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
 <40efcfa8-c625-80b5-7ac9-da7839ed6011@oracle.com>
Date:   Wed, 27 Jan 2021 18:55:38 +0100
Message-ID: <87czxq2rj9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com> writes:

> On 15.01.2021 14:18, Vitaly Kuznetsov wrote:
>> TL;DR: any particular reason why KVM_USER_MEM_SLOTS is so low?
>> 
>> Longer version:
>> 
>> Current KVM_USER_MEM_SLOTS limit (509) can be a limiting factor for some
>> configurations. In particular, when QEMU tries to start a Windows guest
>> with Hyper-V SynIC enabled and e.g. 256 vCPUs the limit is hit as SynIC
>> requires two pages per vCPU and the guest is free to pick any GFN for
>> each of them, this fragments memslots as QEMU wants to have a separate
>> memslot for each of these pages (which are supposed to act as 'overlay'
>> pages).
>> 
>> Memory slots are allocated dynamically in KVM when added so the only real
>> limitation is 'id_to_index' array which is 'short'. We don't have any
>> KVM_MEM_SLOTS_NUM/KVM_USER_MEM_SLOTS-sized statically defined arrays.
>> 
>> We could've just raised the limit to e.g. '1021' (we have 3 private
>> memslots on x86) and this should be enough for now as KVM_MAX_VCPUS is
>> '288' but AFAIK there are plans to raise this limit as well.
>> 
>
> I have a patch series that reworks the whole memslot thing, bringing
> performance improvements across the board.
> Will post it in few days, together with a new mini benchmark set.

I'm about to send a successor of this series. It will be implmenting
Sean's idea to make the maximum number of memslots a per-VM thing (and
also raise the default). Hope it won't interfere with your work!

-- 
Vitaly

