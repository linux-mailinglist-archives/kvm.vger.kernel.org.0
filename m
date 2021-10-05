Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4FDE422CA3
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 17:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbhJEPjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 11:39:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233975AbhJEPjc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 11:39:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633448261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g8VaQsv47xGVpNOlqz6W/3BMiLvJlFlGBCWNXnGhzpc=;
        b=OSnc3tGHmU1Y94wT5+2Fd0B0erDNm+MfhVbuwHzAm2bd8lo1uGiT9eOfJ5BR356ltipo78
        aiP62tKWnf80OeFP/E/CK1gCSWXaNH9Ugf7I7KRff1zrkb4CC4EO9aNKWm3Nwn/dUFhODd
        dHcP90st3ozWoGAP6LXlW1Y/mgUASCY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-yuQa-uVAPoqAq9eHJCaBuQ-1; Tue, 05 Oct 2021 11:37:38 -0400
X-MC-Unique: yuQa-uVAPoqAq9eHJCaBuQ-1
Received: by mail-wm1-f70.google.com with SMTP id 3-20020a05600c22c300b0030d6a6a28f8so1196038wmg.5
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 08:37:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g8VaQsv47xGVpNOlqz6W/3BMiLvJlFlGBCWNXnGhzpc=;
        b=qgG8P1P1NTIkL0HuF/X7tFvzfmfdlq90G9Byd6BVdgbpiSUgJi5/JlxpKR/GlJ8CTJ
         IHFHTaP0rM7SjQMQysWIVrzWV+SCp+fMua/oabstJDL5Jzafs1EcUlxpLgja71SZkPI+
         g8+3KmJp78JQj5ZvoJhfWst8XV5TTmTeEFU0cpew4zKPtwMNchlTItIq03pRNCmH1lDf
         aWkMrtht57FJeuQB5wIOzxfM9aPpGtXmKdMF3tdS6AL72mq+Gc0xLPPLksSbVjsvZK6s
         Sxu/8xIY+YAa3t5rj8BiZuFJrohyj/ixMcQbGM9kR42WjEC+JWSr4UpzQJyEff2jimdP
         5UFQ==
X-Gm-Message-State: AOAM531kw58ZnypvuyJP0qC5Ju2jl1n6MNeovJpiyh5WgzC/nlJJGdZc
        XhHl9pvCuihFcJovCp4KDlgaL1hrwQjRiI3bPU2+aG1+uZZtyKNfLBnya06SBQXGMB2pnKLKYq6
        DyGI13+T+WTQE
X-Received: by 2002:a05:600c:288:: with SMTP id 8mr4208680wmk.172.1633448257674;
        Tue, 05 Oct 2021 08:37:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGIBdCendc78IIq3oVK8zaOmi7VNd1+Th3HZcWbj0tcqdqRU7djnn+V2pkLvsYwDZTZmSOXw==
X-Received: by 2002:a05:600c:288:: with SMTP id 8mr4208665wmk.172.1633448257534;
        Tue, 05 Oct 2021 08:37:37 -0700 (PDT)
Received: from thuth.remote.csb (p549bb2bd.dip0.t-ipconnect.de. [84.155.178.189])
        by smtp.gmail.com with ESMTPSA id l21sm2237622wmh.31.2021.10.05.08.37.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 08:37:37 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 4/5] Use report_fail(...) instead of
 report(0/false, ...)
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org
References: <20211005090921.1816373-1-scgl@linux.ibm.com>
 <20211005090921.1816373-5-scgl@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <f8bbb6e4-da89-59a3-1826-d87979177f1c@redhat.com>
Date:   Tue, 5 Oct 2021 17:37:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211005090921.1816373-5-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/10/2021 11.09, Janis Schoetterl-Glausch wrote:
> Whitespace is kept consistent with the rest of the file.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>   lib/s390x/css_lib.c |  30 ++++----
>   x86/vmx.h           |  25 ++++---
>   arm/psci.c          |   2 +-
>   arm/timer.c         |   2 +-
>   s390x/css.c         |  18 ++---
>   s390x/spec_ex.c     |   7 +-
>   x86/asyncpf.c       |   4 +-
>   x86/hyperv_stimer.c |   6 +-
>   x86/hyperv_synic.c  |   2 +-
>   x86/svm_tests.c     | 163 ++++++++++++++++++++++----------------------
>   x86/vmx.c           |  17 +++--
>   x86/vmx_tests.c     | 136 ++++++++++++++++++------------------
>   12 files changed, 200 insertions(+), 212 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

