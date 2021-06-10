Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A313A319A
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 18:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhFJRAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 13:00:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35106 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230077AbhFJRAx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 13:00:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623344337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MGLLXoxukvyzp3gbfv9QvDGaUMM2YmpCAYOqGEHGpEA=;
        b=aKC6J2i+Mx+r3+hWivP81i8rywQg/McryutftoOoXsqrgH4gHf3B9I9qvyqtrUuh3my2Yx
        ObQrE8JZDvqrTjDjc3GjaXzBDVR2NVyVVDiZMToo8v0oGWWexPhqgfch2p6hm+Oca9c/aV
        FR3VAxMXap1dg9VP842G2GPx60XZ5oQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-RXaX7kySOIqdhfvpvZIdVA-1; Thu, 10 Jun 2021 12:58:55 -0400
X-MC-Unique: RXaX7kySOIqdhfvpvZIdVA-1
Received: by mail-wr1-f71.google.com with SMTP id m27-20020a056000025bb0290114d19822edso1236217wrz.21
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 09:58:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MGLLXoxukvyzp3gbfv9QvDGaUMM2YmpCAYOqGEHGpEA=;
        b=p+i4MiqIyW266qhiR8tfSQutRq0WlzZ0gEUITbW3SGmPI0M2dpmZbnFGfXzoclnRav
         0Hlzn5GJ7jKAbHaVCNzS9pPjLFyb4VghoJKFb7OMibOsMxasGZgVyD5aBF6C2lAUZUwc
         BFZLGojPmtPmPx7CU/7oizAV3Esw+ob9w8Q23YWqN/0FIDvoIfHl6jP5VpZiA7/VxsEI
         h/GKAr+/dqiAYL2AM3BWIh2FLwmR7/gb/DDecJvJ20xselSBO78D7/BVmBNktvVPsgpk
         xq7yLveiPEbC4/VUBMrTwzPpYr3H7eKSQwPLvvjaZNCPJg9I6vf1ab7QMYbzEAF+nrSC
         P/Uw==
X-Gm-Message-State: AOAM530KEExsBgBxBHGRREG5re94XqfTh/wMIYsyDjZe8i0PgyiwDzHM
        4pmTZi+nNVmaLXn5auaTLC9Iu7SkK2TV6eKFKByAwO9nSaFEs7FFNB4EVr9lieL7cCAl2hw3R0X
        8W5CWHRkX3b7P
X-Received: by 2002:a5d:58c1:: with SMTP id o1mr6495507wrf.420.1623344334285;
        Thu, 10 Jun 2021 09:58:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPZqCYrnhPzUvs2ByrfgnosPU+PiLTTOb2CAYVvimHV8Xw4Vyqt+7eiDHdPH8wiuhCOpw/Rg==
X-Received: by 2002:a5d:58c1:: with SMTP id o1mr6495486wrf.420.1623344334072;
        Thu, 10 Jun 2021 09:58:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id f184sm2592904wmf.38.2021.06.10.09.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 09:58:53 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 0/2] header guards: further cleanup
To:     Cornelia Huck <cohuck@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>
References: <20210610135937.94375-1-cohuck@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7d79954d-0aeb-f69f-35a5-5e2dffefaaec@redhat.com>
Date:   Thu, 10 Jun 2021 18:58:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210610135937.94375-1-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/21 15:59, Cornelia Huck wrote:
> Laurent had notices some further issues in my header guards series,
> so I
> - fixed some header guards I missed initially
> - added header guards to some headers that actually define something
>    (and don't just include another header)
> 
> I did not actually remove any header guards that might be unneeded.
> 
> Cornelia Huck (2):
>    header guards: clean up some stragglers
>    add header guards for non-trivial headers
> 
>   configure             | 4 ++--
>   lib/argv.h            | 5 +++++
>   lib/arm/asm/mmu-api.h | 4 ++--
>   lib/arm/asm/mmu.h     | 6 +++---
>   lib/arm/io.h          | 5 +++++
>   lib/arm64/asm/mmu.h   | 6 +++---
>   lib/pci.h             | 6 +++---
>   lib/powerpc/io.h      | 5 +++++
>   8 files changed, 28 insertions(+), 13 deletions(-)
> 

Queued, thanks.

Paolo

