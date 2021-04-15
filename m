Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2EB360FDC
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 18:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbhDOQIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 12:08:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233734AbhDOQIq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 12:08:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618502903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GPWTOZkuVV9uKxyAib9OOYGzA4pl+7XPQzG6f3iPsNE=;
        b=abVonQcPrxDisjdxwUYeAQDaCMr/XYWKS7C/qmCAhElSgsF9nwd+6RSJ2u2hqEMn9bmMEe
        8mFkh12bllMM1SEIrPdVXAk2fTMyFTWRNujufDhobtQ1xWQpfngBtx0++NsQw2o6g+v6N9
        9t6bMlL6ay4+iMw+FNg17vbbuP0HnIs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-w8asGFmeMdyEiGdE-PWAWQ-1; Thu, 15 Apr 2021 12:08:20 -0400
X-MC-Unique: w8asGFmeMdyEiGdE-PWAWQ-1
Received: by mail-ed1-f69.google.com with SMTP id m2-20020aa7c4820000b0290382b0bad9e7so5447734edq.9
        for <kvm@vger.kernel.org>; Thu, 15 Apr 2021 09:08:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GPWTOZkuVV9uKxyAib9OOYGzA4pl+7XPQzG6f3iPsNE=;
        b=AuDhQ0Ng5Sa89JME89S2UOfWLtv+GtKSYuDczknkWXC5R9XWobpLowPmfcs/Yc/MJq
         XntODoQlJ8nLmIfzMhuUQWy0hrcPgUOg10EYjOESl/q0m0XWv0h/+AygP7zCeR8F+zZH
         yalJUcBkAGXYm90C5P3kPbnFA7pF3u0o4kZsn3vsbvewEDTCqICfstoz5yFGWuImob8Y
         HBz+jw2WzDOLEMgFLdiks2IBxcxDmMrKNXMlPDY7T0Bkl6Qw0mvNFCaoViTKM19OjUuo
         ElzgRbImH7aUVAz945kmQQ8QjO8oA96SQ3xqzCTWXsBKvSX93vT9LVQf5y4GGlKDvWrP
         kwbQ==
X-Gm-Message-State: AOAM530g/q7HDrW+hpsmKjnTtlbMMfM9et3bdCKmgJOiNwedpBZwpGdr
        aisZBI/yRDJwLYfD46SMy/WijWjIE2PC+jtfRfCQpIRGDYAJY6IJCMxqzTcWzg7vo1UIKNEvehD
        WfoFJQSa8lZHc
X-Received: by 2002:a17:906:7f01:: with SMTP id d1mr4338509ejr.136.1618502898583;
        Thu, 15 Apr 2021 09:08:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7WrvK1l6FVJlJKF6M6McOJ8gnW3B/2pPeOqGw+FE6kSlfaUMAJeNxJh1gTw4wVr2vncSDmA==
X-Received: by 2002:a17:906:7f01:: with SMTP id d1mr4338497ejr.136.1618502898384;
        Thu, 15 Apr 2021 09:08:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id la24sm2393268ejb.71.2021.04.15.09.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 09:08:17 -0700 (PDT)
Subject: Re: [PATCH v3 5/8] docs: vcpu-requests.rst: fix reference for atomic
 ops
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1617972339.git.mchehab+huawei@kernel.org>
 <fc194806772325d60b7406368ba726f07990b968.1617972339.git.mchehab+huawei@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e72a06e6-d027-74f6-14da-31666187b893@redhat.com>
Date:   Thu, 15 Apr 2021 18:08:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <fc194806772325d60b7406368ba726f07990b968.1617972339.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/21 14:47, Mauro Carvalho Chehab wrote:
> Changeset f0400a77ebdc ("atomic: Delete obsolete documentation")
> got rid of atomic_ops.rst, pointing that this was superseded by
> Documentation/atomic_*.txt.
> 
> Update its reference accordingly.
> 
> Fixes: f0400a77ebdc ("atomic: Delete obsolete documentation")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>   Documentation/virt/kvm/vcpu-requests.rst | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/vcpu-requests.rst b/Documentation/virt/kvm/vcpu-requests.rst
> index 5feb3706a7ae..5f8798e7fdf8 100644
> --- a/Documentation/virt/kvm/vcpu-requests.rst
> +++ b/Documentation/virt/kvm/vcpu-requests.rst
> @@ -302,6 +302,6 @@ VCPU returns from the call.
>   References
>   ==========
>   
> -.. [atomic-ops] Documentation/core-api/atomic_ops.rst
> +.. [atomic-ops] Documentation/atomic_bitops.txt and Documentation/atomic_t.txt
>   .. [memory-barriers] Documentation/memory-barriers.txt
>   .. [lwn-mb] https://lwn.net/Articles/573436/
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

