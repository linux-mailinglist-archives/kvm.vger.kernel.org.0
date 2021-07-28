Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3CC3D8BE2
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 12:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235920AbhG1Kdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 06:33:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34561 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234186AbhG1Kdm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 06:33:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627468420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3H7VdrLA/CYVTJX3HgGL5wweGGgg7N9azTfzgCR+ivA=;
        b=VtDBJ/G4erQUtvM0b2Gn/IFsJkTxvMm4TR5iMZqnntAvVfwOi2D7KLiTLnoiQgfHHtx5Ty
        x4IE8ax8B8oMGFyMO7SiQCYR+aJqTDf1OA67P3QsKCZHU3MTuKzp0doWIoVgG5Ng6CmMM8
        ZzgFlSN3Zq0+QDqjMo6M5z876BWoeOc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-zE2Trze8M3Sz9L5m1L0sGw-1; Wed, 28 Jul 2021 06:33:39 -0400
X-MC-Unique: zE2Trze8M3Sz9L5m1L0sGw-1
Received: by mail-wm1-f70.google.com with SMTP id r125-20020a1c2b830000b0290197a4be97b7so761607wmr.9
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 03:33:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3H7VdrLA/CYVTJX3HgGL5wweGGgg7N9azTfzgCR+ivA=;
        b=PQ+GUWuAsK/rwTe/uxnSfyIfIA/xxJ+yw50p84GKEbS+/n0KuAs1mRE46/exStMhe1
         gK9Q5NpYykMcQE/DIIFAvv3M01MUY4EqCP/YUxuu+S9qqMzLm35pkHazsRG+okFQMwiB
         9B1X1fAxsDielxf3SDfnMgsoqtGP5k0qKoO89njUT30lsj7fJXy8cCXjLY0X9h8qH0DB
         3OBQ7iR4H3ITQmIt7uYIFD31l9Ah9a7xlusApRSWCuA4f0PZvLzz6CvHIrT7HEHkzbFg
         3sZWXrfG8Kk7fqt6yOjctIfsdDxHDSwlTT8WHrhmi+zUisi0QVjaWL6FhWGoQqy10Vtm
         D6WA==
X-Gm-Message-State: AOAM530LkNvFVleuk+N92zLkEZtkIIbUESf0Zi03/z9V8mXAkCVCgixU
        CKgiPI1ApDQCfGy9zf1xouvEQwaXV9iupv8geHQsu3QTeX+sFvRo26HGXD6GUB5LRe4UtMG6Lpd
        y8Vtqvla5HNoY
X-Received: by 2002:a5d:6891:: with SMTP id h17mr14638008wru.324.1627468418074;
        Wed, 28 Jul 2021 03:33:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHBEtfgAVa9u4YzKDq2rAkt19MZ6n4L8GkURVIrzPj+XQ0U8HePAVK6D4pR3TNrlkcik/rsQ==
X-Received: by 2002:a5d:6891:: with SMTP id h17mr14637991wru.324.1627468417889;
        Wed, 28 Jul 2021 03:33:37 -0700 (PDT)
Received: from thuth.remote.csb (p5791d475.dip0.t-ipconnect.de. [87.145.212.117])
        by smtp.gmail.com with ESMTPSA id x16sm6431492wru.40.2021.07.28.03.33.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 03:33:37 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: Add SPDX and header comments
 for the snippets folder
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210728101328.51646-1-frankja@linux.ibm.com>
 <20210728101328.51646-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <72511217-a0ec-6a6c-dea7-20484e255ac8@redhat.com>
Date:   Wed, 28 Jul 2021 12:33:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210728101328.51646-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/07/2021 12.13, Janosch Frank wrote:
> Seems like I missed adding them.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/snippets/c/cstart.S       | 9 +++++++++
>   s390x/snippets/c/mvpg-snippet.c | 9 +++++++++
>   2 files changed, 18 insertions(+)
> 
> diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
> index 242568d6..a1754808 100644
> --- a/s390x/snippets/c/cstart.S
> +++ b/s390x/snippets/c/cstart.S
> @@ -1,3 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Start assembly for snippets
> + *
> + * Copyright (c) 2021 IBM Corp.
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
>   #include <asm/sigp.h>
>   
>   .section .init
> diff --git a/s390x/snippets/c/mvpg-snippet.c b/s390x/snippets/c/mvpg-snippet.c
> index c1eb5d77..e55caab4 100644
> --- a/s390x/snippets/c/mvpg-snippet.c
> +++ b/s390x/snippets/c/mvpg-snippet.c
> @@ -1,3 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Snippet used by the mvpg-sie.c test to check SIE PEI intercepts.
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
>   #include <libcflat.h>
>   
>   static inline void force_exit(void)
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

