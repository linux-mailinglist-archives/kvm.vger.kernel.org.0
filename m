Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B91391D15
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 18:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbhEZQfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 12:35:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234665AbhEZQfT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 12:35:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622046826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XVqT1swsX27I0j5hE9T0VhOfylfMr7I1wTfKCDuG8vY=;
        b=AHUQ+zGwwHmODkq60Y0WposShXXR4W5ZQl7yfZ3p1snbqbvIW/4z8AEaGjntRWt/1tLMrC
        vG4Ikb7S5sTfGgAYwYhLyPP7LBYOAVS0bg0LPwwKeph9FN4WeIz9xudlNeI24CoxGtP0A6
        7R2q0xodwIcgWRpjRszjKv6yeYzG//U=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-WAGt0rSZNU6G177R4SbM8w-1; Wed, 26 May 2021 12:33:45 -0400
X-MC-Unique: WAGt0rSZNU6G177R4SbM8w-1
Received: by mail-ej1-f69.google.com with SMTP id i23-20020a17090685d7b02903d089ab83fcso604054ejy.19
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 09:33:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XVqT1swsX27I0j5hE9T0VhOfylfMr7I1wTfKCDuG8vY=;
        b=s6iTl3zWo42hTyZ/Ji2lQxzCDuvlZvXGiuJFHVl79ccJRw1ZHBxwH4p/uLEjvlPfbN
         m2YJ+tqljziVNBNfGzbjr7MKwY7eMIwlTPALfAzTwWIYsS+DKqjD9CbPY79d/ce7BqoT
         r6vixKfvsOw3YxEFhsbMY3OKz4oHnV8oEinHrEJez3DWpcaciC/Kr7v7daIr8MJ3VaHt
         hQmNnWVSie661gWyYaOpa6pQjw/I19RnpnzLv2Bmd28lAizBsx//AoJVxurld9oMMWu5
         gLeftpRBZ32mcop5AkovLWgM+oFw5epxPaaaBKKG4/qTJRU4IyjgaOlC6DuIwjGKXcV2
         08mw==
X-Gm-Message-State: AOAM5321li9D6Nwo/aaj8Ly8Ht/mpKF+sBwctsroK1wUgWHCtDYAupZr
        xavPxucyezqovtTx1oK3+z2GCpEni0X7FsvadGQTsNuflloSm1Vva9esfTo+kqpwAs6LvPMg8XK
        P60KlF8NVuEw+
X-Received: by 2002:a05:6402:1d18:: with SMTP id dg24mr38325807edb.369.1622046822963;
        Wed, 26 May 2021 09:33:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwA9vMTjHhMUlf8GRrLD1umE9XiUdNeeF6QGlgK/FIicWbivIH+K1niCaR6uYncMTljDKHfKg==
X-Received: by 2002:a05:6402:1d18:: with SMTP id dg24mr38325789edb.369.1622046822758;
        Wed, 26 May 2021 09:33:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b9sm12882306edt.71.2021.05.26.09.33.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 09:33:42 -0700 (PDT)
Subject: Re: [kvm-unit-tests GIT PULL 0/9] s390x update 2021-26-05
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
References: <20210526145539.52008-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <605341e9-d6e8-b02e-eed3-f6756517d2a4@redhat.com>
Date:   Wed, 26 May 2021 18:33:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210526145539.52008-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/05/21 16:55, Janosch Frank wrote:
> Dear Paolo,
> 
> please merge or pull the following changes:
> * SCLP feature probing
> * SCLP cpu model check
> * UV host tests
> 
> MERGE:
> https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/9
> 
> PIPELINE:
> https://gitlab.com/frankja/kvm-unit-tests/-/pipelines/309936640
> 
> PULL:
> The following changes since commit 74ff0e9675ec6d9477f5e98ec7d5d50878fa7ebc:
> 
>    Merge branch 'arm/queue' into 'master' (2021-05-18 11:07:08 +0000)
> 
> are available in the Git repository at:
> 
>    https://gitlab.com/frankja/kvm-unit-tests.git s390x-pull-2021-26-05
> 
> for you to fetch changes up to 21f5f67675830e1c088539656cdc0f63bc18e4e0:
> 
>    s390x: cpumodel: FMT2 and FMT4 SCLP test (2021-05-26 14:27:09 +0000)
> 
> 
> Janosch Frank (9):
>    s390x: uv-guest: Add invalid share location test
>    s390x: Add more Ultravisor command structure definitions
>    s390x: uv: Add UV lib
>    s390x: Test for share/unshare call support before using them
>    s390x: uv-guest: Test invalid commands
>    s390x: Add UV host test
>    s390x: sclp: Only fetch read info byte 134 if cpu entries are above it
>    lib: s390x: sclp: Extend feature probing
>    s390x: cpumodel: FMT2 and FMT4 SCLP test
> 
>   lib/s390x/asm/uv.h    | 152 ++++++++++++-
>   lib/s390x/io.c        |   2 +
>   lib/s390x/malloc_io.c |   5 +-
>   lib/s390x/sclp.c      |  23 +-
>   lib/s390x/sclp.h      |  39 +++-
>   lib/s390x/uv.c        |  45 ++++
>   lib/s390x/uv.h        |  10 +
>   s390x/Makefile        |   2 +
>   s390x/cpumodel.c      |  71 ++++++-
>   s390x/uv-guest.c      |  60 +++++-
>   s390x/uv-host.c       | 480 ++++++++++++++++++++++++++++++++++++++++++
>   11 files changed, 871 insertions(+), 18 deletions(-)
>   create mode 100644 lib/s390x/uv.c
>   create mode 100644 lib/s390x/uv.h
>   create mode 100644 s390x/uv-host.c
> 

Pulled, thanks!

Paolo

