Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63983E41FF
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 11:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbhHIJDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 05:03:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27206 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234085AbhHIJDr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Aug 2021 05:03:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628499806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YD6YtXFfV0ZdxzY2okiuEvUgqKdEvMrxSjlrPcu8jO8=;
        b=TGE45nIfVc1g+um7sq5N50r/cK2TNC7qwop/SEytKaV0vV7dWqlnJ1BYczWE92V0tW40WA
        3vDjhQxFr1QpikhE2VLcachu9BTsh0/uneRIX0l4ptgsyF00hIY3j3s6pACErozSmRtQnH
        ZZY+7DVw8v5c6PVbjMBiJPJ50gw9L/U=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-ijjq_CesOhav8ufQAXPTeA-1; Mon, 09 Aug 2021 05:03:25 -0400
X-MC-Unique: ijjq_CesOhav8ufQAXPTeA-1
Received: by mail-ej1-f69.google.com with SMTP id nb40-20020a1709071ca8b02905992266c319so4270975ejc.21
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 02:03:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YD6YtXFfV0ZdxzY2okiuEvUgqKdEvMrxSjlrPcu8jO8=;
        b=EtfygDm/UWu1yt+XhDtupV+a8K88xJwAcWMnNQjQy/3KknBU8T6nlUACuaSKBit8vh
         xa7pgYqWsPVDOWEf3BrLoHM7+uEoPhuOyqzZJzNDQZGQBVEF2UBX8aTAr8hNfBtIAVpj
         tMcM75664Ya5FQQG1qPieUVPFiqGgxZYZddoRxRAAhumb1t6FZQXcqCns7LMzQqSR+Vi
         PuZ6Tt4I2qHBwT3U1b2SfplGMhtvKgBqUhS7pn/8I4gNeUXBoPu+MmbLn309nqNnS/kv
         0fmLSUakfEtwQioxNCpsF7yVd+TFPUm5t6DOP38ejfG58YaHZZ9CcVELdn7I9ex78iKz
         hIhw==
X-Gm-Message-State: AOAM532ayaE9oloaq+1YNkijZRfObTvNYOQBTz5/JS2/kJ5DxHmmuvHR
        A2f45QM3RStRCmwbOX3uixp5mhfhfT2uM42DLFn96784u5BgEmWuPh7/zi8tUYv/h4o1ApngbUF
        70DOqx5gIzXdp494sd+cLOMTiRvB4vW1fqW2mHs/7Mvjtae94H3DCpZVBP6iy/3s1
X-Received: by 2002:a50:eb95:: with SMTP id y21mr1598525edr.5.1628499804253;
        Mon, 09 Aug 2021 02:03:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzhaL+Jl3EZwRBsYOO8E4+FcpPlNxyP5w/mtjGoLfLcpqqoyNTzhHHD6cjGczoFBtkRapYOw==
X-Received: by 2002:a50:eb95:: with SMTP id y21mr1598496edr.5.1628499804014;
        Mon, 09 Aug 2021 02:03:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id b1sm5732062ejz.24.2021.08.09.02.03.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 02:03:23 -0700 (PDT)
Subject: Re: [PATCH] selftests: KVM: avoid failures due to reserved
 HyperTransport region
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210805105423.412878-1-pbonzini@redhat.com>
 <4b530fb6-81cc-be36-aa68-92ec01c65775@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5f3c13be-f65d-1793-bd91-7491d3e149b0@redhat.com>
Date:   Mon, 9 Aug 2021 11:03:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <4b530fb6-81cc-be36-aa68-92ec01c65775@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/08/21 12:57, Joao Martins wrote:
>   Base Address   Top Address   Use
> 
>    FD_0000_0000h FD_F7FF_FFFFh Reserved interrupt address space
>    FD_F800_0000h FD_F8FF_FFFFh Interrupt/EOI IntCtl
>    FD_F900_0000h FD_F90F_FFFFh Legacy PIC IACK
>    FD_F910_0000h FD_F91F_FFFFh System Management
>    FD_F920_0000h FD_FAFF_FFFFh Reserved Page Tables
>    FD_FB00_0000h FD_FBFF_FFFFh Address Translation
>    FD_FC00_0000h FD_FDFF_FFFFh I/O Space
>    FD_FE00_0000h FD_FFFF_FFFFh Configuration
>    FE_0000_0000h FE_1FFF_FFFFh Extended Configuration/Device Messages
>    FE_2000_0000h FF_FFFF_FFFFh Reserved

The problems we're seeing are with FFFD_0000_0000h.  How does the IOMMU 
interpret bits 40-47 of the address?

Paolo

