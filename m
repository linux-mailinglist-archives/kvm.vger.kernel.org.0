Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0017AEDB5
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 16:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388310AbfIJOuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 10:50:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14486 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbfIJOub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 10:50:31 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 66DECC08EC17
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 14:50:31 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id m9so863734wrs.13
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 07:50:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MoGY/Df12iBG2KQwm2nU8Su4Txh8+DskZO6VJHzV8rs=;
        b=bzdhf4Ty9jw6XY7A3i8uVpcM1YZ9/vIr98yPrED95waLM8Bm6UlZrN5wOIo0ZUoj78
         P6PSda98x6hpLzBeaaJrQWBJnQ4KR1VeQal9JPr7SbatBssxHVmEoBlYdkv4QhjLUWJd
         O1y9BI7CoGzqQCcdHxPB0d4KTjW7fHZ2J1/26M5/Yc2GXzlqYedToLVy2UYY4bV4hbNc
         GBjUr3VB3PCpgP5TBGIYHN6krP7K/TkZxZtL7K12FjiKUh56al/UQb226LGnKf0r/m7/
         1cyYej/KdOJn5vjp6rjTQ7m/IL3/OG+Wtt7O7jDrAzSKSiD0adDDeRq8qhbGFJvxn8Ud
         8b7A==
X-Gm-Message-State: APjAAAUn9+2M278jqcwP7DLGK5WAVVhYpe3IUPUzAKbsCPisPfvZDKo/
        tqUBd3JQnWn/FSHMztgESb1Nk+WIQrTENV26bCDso6wnuGsXhEHrsYLLIdETWj2yld4dF0Zza2m
        cnGcJaeURBnmt
X-Received: by 2002:adf:c58b:: with SMTP id m11mr4918761wrg.252.1568127029954;
        Tue, 10 Sep 2019 07:50:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwc2+S1L0tnPvf/WPew8tmrt7xfcEUdU+NWJyfQUl1CpACey7jRMZ3gEkYeD1N/EWJIng0NpQ==
X-Received: by 2002:adf:c58b:: with SMTP id m11mr4918728wrg.252.1568127029713;
        Tue, 10 Sep 2019 07:50:29 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id s12sm25229307wra.82.2019.09.10.07.50.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2019 07:50:29 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] Update travis.yml to use bionic instead of
 trusty
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Drew Jones <drjones@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>
References: <20190829062650.19325-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <191ddc6e-e3b7-5cac-54f8-6844deb68d73@redhat.com>
Date:   Tue, 10 Sep 2019 16:50:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829062650.19325-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/08/19 08:26, Thomas Huth wrote:
> Ubuntu "trusty" is out of service, and at least for me, the Travis
> jobs for kvm-unit-tests are failing because they can not find the
> repositories anymore. Thus use a newer version of Ubuntu to do the
> CI testing.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  .travis.yml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/.travis.yml b/.travis.yml
> index b06c33c..a4a165d 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -1,5 +1,5 @@
>  sudo: false
> -dist: trusty
> +dist: bionic
>  language: c
>  compiler:
>    - gcc
> 

Queued, thanks.

Paolo
