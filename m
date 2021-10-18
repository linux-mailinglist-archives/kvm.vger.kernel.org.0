Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFF34322E1
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 17:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhJRPdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 11:33:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232536AbhJRPdg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 11:33:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634571084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ne8DI/NRxXDYaAM8+GTuj10+3BGyAct9HYev71SXL4k=;
        b=E+If0KOZdIoLzrhzTybd+vXX7nkDOCKG7k+flwxaOjOocqtLOprZhZN3m39IpPh5QGbNX0
        VqlIYgaed+G3ooPzgpW7XDJ4qI7J4oQzya8+yDZtMLKZS/B1Ej/ibzJP5Njo0O0nmGi/k9
        VI6NdrytH+6O+hveO12VcN67Qn5dtd4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-lUO9WOYDNCGkVQJITjZyDg-1; Mon, 18 Oct 2021 11:31:22 -0400
X-MC-Unique: lUO9WOYDNCGkVQJITjZyDg-1
Received: by mail-ed1-f70.google.com with SMTP id r11-20020aa7cfcb000000b003d4fbd652b9so14702070edy.14
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 08:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ne8DI/NRxXDYaAM8+GTuj10+3BGyAct9HYev71SXL4k=;
        b=xdLgt/2pDBhPlz1pVSn5I75UY58oWcG0dw1/y23NeXFo8ndNppUaSPkXjSnL6qJr/m
         VPt8ruAwP8IVZaf5nBg8y1209itYj9gOR6B0lRNOXRLuuKua+hGcZaEJcNK+mvv28obK
         Q0J73so2ucZExIJk/2KyE9e/2PXrZQ2ibmqtdY9T5rhoVPJo2LKGGfVqluHbXLHbkWWJ
         1wi2d8UH4+fu/yYO8NTfzaE/O3TDbMEnglLzxlspSne/QuVKnzr6aWbeVvQQubFG/7b5
         D68yFulzljt+NbxeSJSoh8k0Im7xOM7lPuIA2866+D4hgzFXaJuzqQKA5kC2EijcXGVc
         xBQw==
X-Gm-Message-State: AOAM5316HUU6qc+2KpxKXjez5tob0c3TFpN8MVQuvTgiogkBPqCoJjtn
        SObdeAdLZtllBbbE0IWn8CgYtKkBcUv42jom+Kv7p5SOlH4ZLoUe6kQBUi3KrWwryAQfa7PWsdK
        leHItuuEOtpbM
X-Received: by 2002:aa7:d915:: with SMTP id a21mr45430233edr.218.1634571081243;
        Mon, 18 Oct 2021 08:31:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyI0LnIJekMPtl2hYdLY4mO/L9Z/KNQKpKWoXba6yA7fHIjy2LF65EhSw9ySFwG+0YVwU1Qfw==
X-Received: by 2002:aa7:d915:: with SMTP id a21mr45430206edr.218.1634571081044;
        Mon, 18 Oct 2021 08:31:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b2sm9889278edv.73.2021.10.18.08.31.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 08:31:20 -0700 (PDT)
Message-ID: <b6e339d6-009c-5523-5376-576eeeef3121@redhat.com>
Date:   Mon, 18 Oct 2021 17:31:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests GIT PULL 00/17] s390x update 2021-10-18
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
References: <20211018122635.53614-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/21 14:26, Janosch Frank wrote:
> Dear Paolo,
> 
> please merge or pull the following changes:
>         * Skey addressing exception test (David)
>         * sthyi reg 2 + 1 check (Janosch)
>         * General cleanup (Thomas, Janosch & Janis)
>         * Snippet cleanup (Thomas & Janosch)
> 
> MERGE:
> https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/18
> 
> PIPELINE:
> https://gitlab.com/frankja/kvm-unit-tests/-/pipelines/390243055
> 
> The pipeline fails because the new SKEY checks fail without a QEMU fix
> which is not yet in the CI's QEMU version. I've already contacted
> Thomas about this.
> 
> PULL:
> The following changes since commit b4667f4ca26aea926a2ddecfcb5669e0e4e7cbf4:
> 
>    arm64: gic-v3: Avoid NULL dereferences (2021-10-12 09:33:49 +0200)
> 
> are available in the Git repository at:
> 
>    https://gitlab.com/frankja/kvm-unit-tests.git s390x-pull-2021-10-18
> 
> for you to fetch changes up to a2b44f223e7655155ff926eea60eb40e0b4d14f5:
> 
>    lib: s390x: Fix copyright message (2021-10-18 09:31:39 +0000)
> 
> ----------------------------------------------------------------
> 
> David Hildenbrand (1):
>    s390x: skey: Test for ADDRESSING exceptions
> 
> Janis Schoetterl-Glausch (1):
>    lib: s390x: Add access key argument to tprot
> 
> Janosch Frank (13):
>    s390x: uv-host: Explain why we set up the home space and remove the
>      space change
>    lib: s390x: Control register constant cleanup
>    lib: s390x: Print addressing related exception information
>    s390x: uv: Tolerate 0x100 query return code
>    s390x: uv-host: Fence a destroy cpu test on z15
>    lib: s390x: uv: Fix share return value and print
>    lib: s390x: uv: Add UVC_ERR_DEBUG switch
>    lib: s390x: Print PGM code as hex
>    s390x: Add sthyi cc==0 r2+1 verification
>    s390x: snippets: Set stackptr and stacktop in cstart.S
>    lib: s390x: Fix PSW constant
>    lib: s390x: snippet.h: Add a few constants that will make our life
>      easier
>    lib: s390x: Fix copyright message
> 
> Thomas Huth (2):
>    s390x: mvpg-sie: Remove unused variable
>    s390x: snippets: Define all things that are needed to link the libc
> 
>   lib/s390x/asm/arch_def.h  | 55 +++++++++++++++++-----------
>   lib/s390x/asm/mem.h       | 12 +++++++
>   lib/s390x/asm/uv.h        | 21 ++++++-----
>   lib/s390x/css.h           |  2 +-
>   lib/s390x/fault.c         | 76 +++++++++++++++++++++++++++++++++++++++
>   lib/s390x/fault.h         | 44 +++++++++++++++++++++++
>   lib/s390x/interrupt.c     | 29 +++++++++++++--
>   lib/s390x/sclp.c          |  2 +-
>   lib/s390x/sclp.h          |  2 +-
>   lib/s390x/smp.c           |  3 +-
>   lib/s390x/snippet.h       | 34 ++++++++++++++++++
>   s390x/Makefile            |  3 +-
>   s390x/mvpg-sie.c          | 16 ++++-----
>   s390x/skey.c              | 28 +++++++++++++++
>   s390x/skrf.c              |  6 ++--
>   s390x/snippets/c/cstart.S | 13 ++++++-
>   s390x/snippets/c/flat.lds |  2 ++
>   s390x/sthyi.c             | 21 ++++++-----
>   s390x/uv-guest.c          |  4 ++-
>   s390x/uv-host.c           | 30 ++++++++++------
>   20 files changed, 333 insertions(+), 70 deletions(-)
>   create mode 100644 lib/s390x/fault.c
>   create mode 100644 lib/s390x/fault.h
>   create mode 100644 lib/s390x/snippet.h
> 

Merged, thanks.

Paolo

