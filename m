Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775224673C4
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 10:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351350AbhLCJSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 04:18:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231144AbhLCJSb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 04:18:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638522907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3nc4Ey+X4kWRDPDWq5nVY1VbND+pTe+vz1ZtHVDIYUk=;
        b=CyJRuRe5v1Zg//Yl5dKILq9U2yDthbC2C5FYR6TzVFVTq9KWUdS1PyOSDkVZrKR4gRajaI
        ErtoR/BULbUlTMp2hKJxLbsirr7EDR0PbUUg7lHXSG6HxH79Sdb2msP5vMFtDHLM4T2857
        Jej/G+wZc67cuRoNr19lPYN5mfx1Yk8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-6yzfY3zeMcqdpjM6gcuuNA-1; Fri, 03 Dec 2021 04:15:06 -0500
X-MC-Unique: 6yzfY3zeMcqdpjM6gcuuNA-1
Received: by mail-wr1-f69.google.com with SMTP id y4-20020adfd084000000b00186b16950f3so446919wrh.14
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 01:15:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3nc4Ey+X4kWRDPDWq5nVY1VbND+pTe+vz1ZtHVDIYUk=;
        b=YdznSv24SSlSTab6meGOPm90kJygEjoiWb1u1CciDMFTYk9oxUnIqZ2ST76I6DgunM
         /DkcH41e7n+ReE8M0Kb0MV4638uJxJKJObAgApwhbGiWYl+IXWxmNxvBM4vuoSDcQvNV
         /GMocaaRMNixOr4LjsbysL48A6FXl77p+LKdFiBQk+5aO8Wjn3n2m/Z3Aaf4xt4Jdtls
         KdkCLMh1YIOLk4SbwHIWEdxR2OdGcM+6w3vrGcrA305Vo8NMEvDfHHLiuFYEVcBDqcsA
         51U5JiqL8fhpsGbwRDvok5h8qOt7xo3OoYxV6e6zUZCEtSuZFv3DLljtUmfEHUGy7L7Z
         UORQ==
X-Gm-Message-State: AOAM530LTwK59OmTXVYn2T9Ucv+8eltSgZZZeF4BihCe6qASsXjzkpa/
        hmW+AMc1o9hl7g0fmjtqvTQeJqYiXkKp9pMwjrhrdrK5ciNAfMR+PYY4F21ijAO4wTGwtgbDxI3
        UesKAljtYlxDQ
X-Received: by 2002:a05:600c:3b28:: with SMTP id m40mr13509606wms.100.1638522905643;
        Fri, 03 Dec 2021 01:15:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfK/HWbnbruqENFZNdyq5gKB9JqpDKvAJoRTk3unj3UQDU5eHOa7vfR1K5LYIz9ARMuFkAfA==
X-Received: by 2002:a05:600c:3b28:: with SMTP id m40mr13509581wms.100.1638522905487;
        Fri, 03 Dec 2021 01:15:05 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id i17sm2157588wmq.48.2021.12.03.01.15.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 01:15:05 -0800 (PST)
Message-ID: <2163c5df-0068-b66d-18d1-3b3cf72aa805@redhat.com>
Date:   Fri, 3 Dec 2021 10:15:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v9 4/9] lib: add isaac prng library from
 CCAN
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        pbonzini@redhat.com, drjones@redhat.com
Cc:     kvm@vger.kernel.org, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        "Timothy B . Terriberry" <tterribe@xiph.org>
References: <20211202115352.951548-1-alex.bennee@linaro.org>
 <20211202115352.951548-5-alex.bennee@linaro.org>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20211202115352.951548-5-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/2021 12.53, Alex Bennée wrote:
> It's often useful to introduce some sort of random variation when
> testing several racing CPU conditions. Instead of each test implementing
> some half-arsed PRNG bring in a a decent one which has good statistical
> randomness. Obviously it is deterministic for a given seed value which
> is likely the behaviour you want.
> 
> I've pulled in the ISAAC library from CCAN:
> 
>      http://ccodearchive.net/info/isaac.html
> 
> I shaved off the float related stuff which is less useful for unit
> testing and re-indented to fit the style. The original license was
> CC0 (Public Domain) which is compatible with the LGPL v2 of
> kvm-unit-tests.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> CC: Timothy B. Terriberry <tterribe@xiph.org>
> Acked-by: Andrew Jones <drjones@redhat.com>
> Message-Id: <20211118184650.661575-6-alex.bennee@linaro.org>
> ---
>   arm/Makefile.common |   1 +
>   lib/prng.h          |  82 ++++++++++++++++++++++
>   lib/prng.c          | 162 ++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 245 insertions(+)
>   create mode 100644 lib/prng.h
>   create mode 100644 lib/prng.c
Acked-by: Thomas Huth <thuth@redhat.com>

