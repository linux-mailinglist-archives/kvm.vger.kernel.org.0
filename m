Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D573071FF
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 09:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhA1Isz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 03:48:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232357AbhA1Irq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 03:47:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611823665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QwJu5pdTBVKl4VUIZ7eGZZ/8BCW9Z0m9E6Yq/oYbsYI=;
        b=KV9k6Gk/Lvrz3PgH8hWErYWwsboxYTowkGrJmNiC9FNVrgxzg/fwJV+oWAA9RbWaImb5Up
        eQpGbDL9Dxs1Eea3kFaj2QVJ9MZqaNo/NKTXJM5PlAA6vWQDjX3uGlTV2gxbDj1JZNaVgc
        tQ2AGi1C91dMQT3fOU1SDPvBVx4oUU8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-GLOcHlZHO8OAoZ7_R2TNQA-1; Thu, 28 Jan 2021 03:47:41 -0500
X-MC-Unique: GLOcHlZHO8OAoZ7_R2TNQA-1
Received: by mail-ej1-f70.google.com with SMTP id h4so1882311eja.12
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 00:47:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QwJu5pdTBVKl4VUIZ7eGZZ/8BCW9Z0m9E6Yq/oYbsYI=;
        b=UlNN2R9gIymWfeW6V84Lwwt/kETJJaXViuhrRoLipKuTYbetdOcBnecl87zsuQbAPt
         t9tNwMvAdfScUlVJgdTGzTZo+GzZOJ2aQZXpmLZWeRhoUFdp1rJdRi7Eyk0qtUrFjJPa
         YHIdqCmaDsmGDocpf3QQ/65NnSJDwfudJJ9q/QGF99qVRvezYXLgAg3eabmwXkIkOTAK
         TtiFT5mixH7ug2DwaxrOMQBRBqtfFjBXeSROXaUj//RrTXspTB2zXMCuW6rWmOIhbGcs
         CUleg/qbIfmhVuNtVRYh++m5bH7balxbXR2HG5WCyDJIKqr0D/AFBYLuXDsIZl/pRexH
         ZN8w==
X-Gm-Message-State: AOAM532F/Um6Xg1SH8uzezHU20lMeBPmHDHkFEkhdr9ta0MuxUc6DpMm
        KnSxgPY0fo9i49Q5IBh2fSEcLKFqk9TzmjWeDFOMu4cVE22ox2WDFLbnHccWmMjwL4I0RfN2hSf
        wIuoi9i7B2YK1
X-Received: by 2002:a05:6402:614:: with SMTP id n20mr12935191edv.358.1611823660178;
        Thu, 28 Jan 2021 00:47:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQj5jzBMXxkh2xivDMzJvqXQ4Yl0nqHp8c4jOV1dRITK3QWMoMNghGJQEXeqr+lHBYEZSg7A==
X-Received: by 2002:a05:6402:614:: with SMTP id n20mr12935187edv.358.1611823660043;
        Thu, 28 Jan 2021 00:47:40 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y21sm305170edl.61.2021.01.28.00.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 00:47:39 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC 0/4] KVM: x86: Drastically raise KVM_USER_MEM_SLOTS
 limit
In-Reply-To: <117b94cc-d1e0-1575-e127-dd5785cf17cd@oracle.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
 <40efcfa8-c625-80b5-7ac9-da7839ed6011@oracle.com>
 <87czxq2rj9.fsf@vitty.brq.redhat.com>
 <117b94cc-d1e0-1575-e127-dd5785cf17cd@oracle.com>
Date:   Thu, 28 Jan 2021 09:47:38 +0100
Message-ID: <874kj130t1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com> writes:

> Hi Vitaly,
>
> On 27.01.2021 18:55, Vitaly Kuznetsov wrote:
>> "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com> writes:
>> 
>>> On 15.01.2021 14:18, Vitaly Kuznetsov wrote:
>>>> TL;DR: any particular reason why KVM_USER_MEM_SLOTS is so low?
>>>>
>>>> Longer version:
>>>>
>>>> Current KVM_USER_MEM_SLOTS limit (509) can be a limiting factor for some
>>>> configurations. In particular, when QEMU tries to start a Windows guest
>>>> with Hyper-V SynIC enabled and e.g. 256 vCPUs the limit is hit as SynIC
>>>> requires two pages per vCPU and the guest is free to pick any GFN for
>>>> each of them, this fragments memslots as QEMU wants to have a separate
>>>> memslot for each of these pages (which are supposed to act as 'overlay'
>>>> pages).
>>>>
>>>> Memory slots are allocated dynamically in KVM when added so the only real
>>>> limitation is 'id_to_index' array which is 'short'. We don't have any
>>>> KVM_MEM_SLOTS_NUM/KVM_USER_MEM_SLOTS-sized statically defined arrays.
>>>>
>>>> We could've just raised the limit to e.g. '1021' (we have 3 private
>>>> memslots on x86) and this should be enough for now as KVM_MAX_VCPUS is
>>>> '288' but AFAIK there are plans to raise this limit as well.
>>>>
>>>
>>> I have a patch series that reworks the whole memslot thing, bringing
>>> performance improvements across the board.
>>> Will post it in few days, together with a new mini benchmark set.
>> 
>> I'm about to send a successor of this series. It will be implmenting
>> Sean's idea to make the maximum number of memslots a per-VM thing (and
>> also raise the default). Hope it won't interfere with your work!
>
> Thanks for your series and CC'ing me on it.
>
> It looks like there should be no design conflicts, I will merely need to
> rebase on top of it.
>
> By the way I had to change a bit the KVM selftest framework memslot
> handling for my stuff, too, since otherwise just adding 32k memslots
> for a test would take almost forever.
>

Yea, that's why PATCH5 of the new series increases the default timeout
from 45 seconds to 120.

-- 
Vitaly

