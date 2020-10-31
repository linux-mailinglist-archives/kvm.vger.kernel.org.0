Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93542A1832
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 15:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbgJaOdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Oct 2020 10:33:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35249 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726115AbgJaOds (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 31 Oct 2020 10:33:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604154827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bXqFmbfOPVOhXOdRVT0vixM4uQXKFnbFGiYk1nyPnzU=;
        b=XOKSq01A2a89ovN6vnYsZ0As4GBj9ohZjrthGl+aHcjtxg5gzcfhH4uB7r72FtVVLaUy7S
        JEkkdzkwGFlo9+MMSuMUvqaqIk+NnBnMJh50ik9eB1CC5fdME/vOtCnGzjPCg3sgaLU5ov
        FyrVjGEbzvL6BMxVnRouImQyQRS5pPw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-lk5lfJG_P_WknKdv2oahFg-1; Sat, 31 Oct 2020 10:33:45 -0400
X-MC-Unique: lk5lfJG_P_WknKdv2oahFg-1
Received: by mail-wr1-f70.google.com with SMTP id t17so4078126wrm.13
        for <kvm@vger.kernel.org>; Sat, 31 Oct 2020 07:33:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bXqFmbfOPVOhXOdRVT0vixM4uQXKFnbFGiYk1nyPnzU=;
        b=JjN9wGyNwfL0RqXzpMhZgw7qm9zdPKgZhL5NIcI3ewugBsO0f9KP3/BVQxLS8YwnAL
         eTjsmI0OMyCLLwiglBH71S545llgYMbz5DU740wSkz5d/57b92oX+bfRH0zcH/sbqMAR
         xtm6TX+NB6/EzMeslsUSPOMddwWpEJ0E/KX8N3htgzI3rlxrsm32t3dQ4pVGyT8sUR6p
         AmrwoWy9hQUyOPO1No+QJ78h7omu8pOTMB8mCS86hicWY9WF4y1Cc1Q3OD7yUMelItMH
         iT2TSrfaMHWUQZPD3MOuRVXZ4VonmVaqqvmlVPFujqLtN5d3I51CrxZ0w4KLxV6XbrA3
         2Lug==
X-Gm-Message-State: AOAM530JASWRzKhh09o1YsySYiRAebDoKCl4BZua0fTJ992ifCnmxh/c
        cF5Ie7kyHK4ZS8mUw/m2DS8/9c1pZkXb+XVNNydRvb3Js3xOj4mh9cCqQ8XY91CVQaEzzVcszU5
        dRPQiXq0wuvWW
X-Received: by 2002:a1c:81c9:: with SMTP id c192mr8100003wmd.1.1604154824409;
        Sat, 31 Oct 2020 07:33:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyme+NWs4UW32x5CxU+CKUsQiDfm4fJH13wsvs1vAgDnki2KciLze4eNQ0ezzt0tpSg1MLidA==
X-Received: by 2002:a1c:81c9:: with SMTP id c192mr8099991wmd.1.1604154824251;
        Sat, 31 Oct 2020 07:33:44 -0700 (PDT)
Received: from [192.168.178.64] ([151.20.250.56])
        by smtp.gmail.com with ESMTPSA id b7sm14070395wrp.16.2020.10.31.07.33.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 07:33:43 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: Introduce ioeventfd read support
To:     Amey Narkhede <ameynarkhede03@gmail.com>, qemu-devel@nongnu.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20201020170056.433528-1-ameynarkhede03@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8014bc56-78fd-47f5-e62c-b8f6444f45bc@redhat.com>
Date:   Sat, 31 Oct 2020 15:33:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201020170056.433528-1-ameynarkhede03@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/20 19:00, Amey Narkhede wrote:
> The first patch updates linux headers to
> add ioeventfd read support while the
> second patch can be used to test the
> ioeventfd read feature with kvm-unit-test
> which reads from specified guest addres.
> Make sure the address provided in
> kvm_set_ioeventfd_read matches with address
> in x86/ioeventfd_read test in kvm-unit-tests.
> 
> Amey Narkhede (2):
>   linux-headers: Add support for reads in ioeventfd
>   kvm: Add ioeventfd read test code
> 
>  accel/kvm/kvm-all.c       | 55 +++++++++++++++++++++++++++++++++++++++
>  linux-headers/linux/kvm.h |  5 +++-
>  2 files changed, 59 insertions(+), 1 deletion(-)
> 

Hi,

in what occasions is this useful?

Paolo

