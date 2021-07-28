Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136C83D90C0
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 16:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbhG1Ofq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 10:35:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52239 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235420AbhG1Ofo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 10:35:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627482941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ns4+hvb10pCv09UW5xpgn10rDpJ/aUkX8DQEOdyq8JY=;
        b=IfaZdKaXnSgLTo5YAIGQ+ZNt1lreaUakh64ESLzCW7jKwnPPF1mVFqmV++JhUaSY160Mxd
        AuuBIi0ZhQo3+waaoowvqsyBZ/rR5x6JjDR4adJ6TAoco0A5xD2YT73Z9nX76fd7alg8p3
        26ZXVKgm6jtyl8V/J7IZH0NI0kcU7EE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-GcexpFPnMkCcL5SrrGEA4w-1; Wed, 28 Jul 2021 10:35:39 -0400
X-MC-Unique: GcexpFPnMkCcL5SrrGEA4w-1
Received: by mail-wm1-f71.google.com with SMTP id 25-20020a05600c0219b029024ebb12928cso1016331wmi.3
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 07:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ns4+hvb10pCv09UW5xpgn10rDpJ/aUkX8DQEOdyq8JY=;
        b=U0iU5eItx/nCFpKxqzA53fmobuh+BMZsPHHjXM1v+D7I3Oux2GUZqkb0TOAN/2Fzqo
         IkB8eA62W7DGkH0cZozpcnSCaEwdGO3SueI32FZTdx33N6IE6wxtRM7nERTnY5EwAy0R
         4zeeduwYa+8WWJO9+B4r+RuqPu7Z9zqwcSq3YQJCxSlqn6+Yg0MXBKOLg+ch/hrtsQ1f
         bGulbHZrRQ0E1tHaV+IVfK4dIabmMRNJdsWOxZRZXPoVeFMa9IN9EstA+7ZBZe5EmWnq
         /rDgtUKCbKAoXn55DW+q9yXStzNfBwf15cWsl3k+6+jtnedEyBEA++OGl1hi9Nk3vdCd
         nJvQ==
X-Gm-Message-State: AOAM530vhGIVJC4gWQVvipWviG7OXG6qnhY3fiSl2mEHrWv2nqHKv/YF
        vq//6KDU+6EJ/aAfPntoruOPo1pO3iEC7wP7GXuZgy7GqXvdTs4eUF9zHLxCn1PEQc8O2uAV7/2
        sk/ZN49z/GW/I
X-Received: by 2002:a05:600c:206:: with SMTP id 6mr9915966wmi.137.1627482938622;
        Wed, 28 Jul 2021 07:35:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhTb5ddWwmkLn/CH3sMlITeGS1cEIPUQGu9uQ0XfoNZUun5nGZqs9ljS4qYZVOiACLgBqPBg==
X-Received: by 2002:a05:600c:206:: with SMTP id 6mr9915951wmi.137.1627482938459;
        Wed, 28 Jul 2021 07:35:38 -0700 (PDT)
Received: from thuth.remote.csb (p5791d475.dip0.t-ipconnect.de. [87.145.212.117])
        by smtp.gmail.com with ESMTPSA id y19sm6033618wma.21.2021.07.28.07.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 07:35:37 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2] s390x: Add SPDX and header comments for
 s390x/* and lib/s390x/*
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210728101328.51646-2-frankja@linux.ibm.com>
 <20210728125643.80840-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <23050302-247b-11f6-249b-d9ead3a9bea3@redhat.com>
Date:   Wed, 28 Jul 2021 16:35:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210728125643.80840-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/07/2021 14.56, Janosch Frank wrote:
> Seems like I missed adding them.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
> 
> Dropped the sieve.c change.
> 
> ---
>   lib/s390x/uv.c   |  9 +++++++++
>   s390x/mvpg-sie.c |  9 +++++++++
>   s390x/sie.c      | 10 ++++++++++
>   3 files changed, 28 insertions(+)

Reviewed-by: Thomas Huth <thuth@redhat.com>

