Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487B142ED5C
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 11:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236917AbhJOJSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 05:18:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231273AbhJOJSD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 05:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634289356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JPdfqYpVJTpSV3zcaKTmg6HAS+Qkr1yg2VBtw7dThqY=;
        b=f2eNxyot4WlW0/ADq2bNdxil3//ygnj5JKTDtS4qq1cXLOqRhuKFO1r3fTzcHuOClwl4EQ
        RSNyb/BpfugwKDJr3DROkcwIgd1JdSkU8XNKEYwWTEn2sBANdJyGQrpxUkCOHZWXNsJhh5
        i6z2gcBeHNQRaZfoffqaqw6qG7XIDV8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-G_PjPewuMe-1KnuEI6-tpA-1; Fri, 15 Oct 2021 05:15:54 -0400
X-MC-Unique: G_PjPewuMe-1KnuEI6-tpA-1
Received: by mail-ed1-f69.google.com with SMTP id d3-20020a056402516300b003db863a248eso7640218ede.16
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 02:15:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JPdfqYpVJTpSV3zcaKTmg6HAS+Qkr1yg2VBtw7dThqY=;
        b=qvpiU2zkmnt43zJY+g4b514O+pfsgouOvDC+A23s5Vvt/9o+j5QhjrFP5P/qIGf7qq
         kMt4ZeHo1GWIPUNQaAGaXAyMyPbY+jgXhdK99+kb/MjDm8gAol2zGTW+hAdJ7qA8V+4V
         o5BXwrc1Lx2N8S2fX4BwGDaeVR19coLHjGjnVBEHj3c3XKfcC4aHdTK2LX30n0vzp/bf
         7eXQHcfJI5nvibCSjAe5S9LES0iCYuMi4HJ1MY8AtHWuh7xF5tQT2/bSwKlh4e0717nG
         OYxZoGgHhOoKoqoJlhLpkpIjlE1GgGzkycdZxQjVQ/35qidHBG0fWeG+YwGwJtXlATwy
         EcmQ==
X-Gm-Message-State: AOAM5315mO2avSaJ1cw4kXYrVSGj1DhI8v+HdL6sTqWFyEdJccTaXMB2
        zXJ5sGaXPLRvXcPI8exx94FuY6K2AgsBBt11crVSpn41u+GYF9t9WaMvtg5yqoqECkdC/CxugQD
        4Gf0zTreVEVNy
X-Received: by 2002:a17:906:1d41:: with SMTP id o1mr5569554ejh.232.1634289353319;
        Fri, 15 Oct 2021 02:15:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWyhfyUXYkyfnfUQLbXJPqle1FQunwcWC6vB+gCzlyjQO16OoHAs+zTih1U0abnsVaCdlfyg==
X-Received: by 2002:a17:906:1d41:: with SMTP id o1mr5569531ejh.232.1634289353134;
        Fri, 15 Oct 2021 02:15:53 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l13sm4092543eds.92.2021.10.15.02.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 02:15:52 -0700 (PDT)
Message-ID: <18309f23-9257-94f1-77d9-96c098ffa460@redhat.com>
Date:   Fri, 15 Oct 2021 11:15:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH kvm-unit-tests 0/2] Introduce strtoll/strtoull
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, ahmeddan@amazon.com
References: <20211013164259.88281-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211013164259.88281-1-drjones@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/21 18:42, Andrew Jones wrote:
> A recent posting by Daniele Ahmed inspired me to write a patch adding
> strtoll/strtoull. While doing that I noticed check_mul_overflow wasn't
> working and found copy+paste errors with it and check_sub_overflow.
> 
> Andrew Jones (2):
>    compiler.h: Fix typos in mul and sub overflow checks
>    lib: Introduce strtoll/strtoull
> 
>   lib/linux/compiler.h |  4 ++--
>   lib/stdlib.h         |  2 ++
>   lib/string.c         | 51 ++++++++++++++++++++++++++++++++------------
>   3 files changed, 41 insertions(+), 16 deletions(-)
> 

Queued, thanks.

Paolo

