Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9FA3DBAF7
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 16:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239177AbhG3Op7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 10:45:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20674 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239032AbhG3Op6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 10:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627656353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eAvHmd59q5tqasusWWApD5RRDo6ed+dgXJVRWVN+feo=;
        b=G3RcM1c0PYbLiWug3N2cSwi/UW4030kwj/l1GMS8KWhWE/apxfZ9XLBZGeBsFFjXgqoeuX
        2kBFjmIHH9uj9hu69sM1syfzRCb+ryN5TlNqbf2WwKlETt5UQX3oq5lPgF7pvmONoWITqm
        DS+7NSyAgYfwNULrHHQyodCPkbjp7Xs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-gzIwcarbN8KuTo7zfPBMPQ-1; Fri, 30 Jul 2021 10:45:51 -0400
X-MC-Unique: gzIwcarbN8KuTo7zfPBMPQ-1
Received: by mail-wr1-f69.google.com with SMTP id d14-20020adfe2ce0000b029013a357d7bdcso3291034wrj.18
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 07:45:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eAvHmd59q5tqasusWWApD5RRDo6ed+dgXJVRWVN+feo=;
        b=SGo4p3Jna1BBAD1rWpW/pMQxTnJn9cnAzUgiYTKDL7/1qlnAfLJOSek2ZMZP0dQTQl
         gzsA/xUpfJz/SSpKum7egbrVoqnEwrdOQ62pvuZOdRmZ6wpm8Pjb9czFMfMN1fW8wThN
         8tIYuAPiAVgQ2LQfPG48YoVAH/klxpjWixf3irVeEdu/sYKceUPVaXYXcqojcBduXf0q
         6khkTNorYIDye1mPunzuqe/QwJMTng0Vq38OvcWOgxntH69fFiwAQkmdppxxeZDabNNX
         Aq1sUyG6VzJ7MiNERVS+R0LARn8UxABUGOkR1ohzp+5Ce2JdgCSeBy8NpV3/7xtE0liU
         n4/A==
X-Gm-Message-State: AOAM530wDEUOExVtrveQVfWNB3kKQDWcVWj8nTR8y4BJ21Z6wsWotxbx
        K8d6XrBqlqp/5O0D5a63j+eS9r0iHo6eCRubWHDmFPN1lg7sq6bsl1hw7MLLX47XwKQfi95kT9W
        AtIMMaTOPLqYX
X-Received: by 2002:a05:600c:3509:: with SMTP id h9mr3229384wmq.81.1627656350465;
        Fri, 30 Jul 2021 07:45:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNNWT46urepAmYb0lxUGFcJKp2dR5HbCtV1vHjqW5ctbAXI8G+9pLFqZNIyWuAG6bbngQKsg==
X-Received: by 2002:a05:600c:3509:: with SMTP id h9mr3229371wmq.81.1627656350291;
        Fri, 30 Jul 2021 07:45:50 -0700 (PDT)
Received: from thuth.remote.csb (p5791d280.dip0.t-ipconnect.de. [87.145.210.128])
        by smtp.gmail.com with ESMTPSA id w13sm2330294wru.72.2021.07.30.07.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 07:45:49 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/4] s390x: sie: Add sie lib validity
 handling
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210729134803.183358-1-frankja@linux.ibm.com>
 <20210729134803.183358-2-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e4b7d844-a602-78be-2cdb-3f87bb22a04e@redhat.com>
Date:   Fri, 30 Jul 2021 16:45:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729134803.183358-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/2021 15.48, Janosch Frank wrote:
> Let's start off the SIE lib with validity handling code since that has
> the least amount of dependencies to other files.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/sie.c  | 41 +++++++++++++++++++++++++++++++++++++++++
>   lib/s390x/sie.h  |  3 +++
>   s390x/Makefile   |  1 +
>   s390x/mvpg-sie.c |  2 +-
>   s390x/sie.c      |  7 +------
>   5 files changed, 47 insertions(+), 7 deletions(-)
>   create mode 100644 lib/s390x/sie.c
> 
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> new file mode 100644
> index 00000000..9107519f
> --- /dev/null
> +++ b/lib/s390x/sie.c
> @@ -0,0 +1,41 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Virtualization library that speeds up managing guests.

"speeds up managing guests" ... so this means that guests can be scheduled 
faster? ;-)

> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
> +
> +#include <asm/barrier.h>
> +#include <libcflat.h>
> +#include <sie.h>
> +
> +static bool validity_expected;
> +static uint16_t vir;

What does "vir" stand for? A short comment would be nice.

  Thomas

