Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2DF278224
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 10:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgIYIA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 04:00:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42637 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727068AbgIYIA6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 04:00:58 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601020857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dTyMt1KiVBW/2RXSZtCgwcyF9tW3hiDouyudmPh1IWo=;
        b=LZpmsK5dTM77dwcbfuYLKftLvFm/1HY4Qrffg2w3nJIrpECpch48OqRdYRpI9cO79c8ARb
        5kzQvhOnhfwa0hD3fv/NCdFHa63Rcz98S+mM59vK8FtFPuB1k55/hVkBvUcVtte7jZ8CPD
        cQdfLPbChf6NjmciUOABWc5gCG6ptCo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-ipBS_oO4NFOjxX_OMQoQIg-1; Fri, 25 Sep 2020 04:00:55 -0400
X-MC-Unique: ipBS_oO4NFOjxX_OMQoQIg-1
Received: by mail-wr1-f71.google.com with SMTP id b7so763730wrn.6
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 01:00:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dTyMt1KiVBW/2RXSZtCgwcyF9tW3hiDouyudmPh1IWo=;
        b=NVlaeFMkmzgYqmnKQviuv6Mxap712l6JJpvTR0N6PqOai6GfoJNJIE9OCTiqGh5a/p
         GCgOdnkn7EgBLxrm3i/NKVg9y+YU0onLfeDUYT2QoD2Hn7GzhgwKi9wPdcP0IxuUiB9y
         wS211i6D+p6Y0NueH3j657tm9PC62/1VP/L1ck5dSYd8Jh26gEG10hw+rkcHxi/4yUU7
         tVFdsME+q9yA9q6Fn6usCi62Ecu8RSZs/bk7fELsPnOp6g/J2ni4P+48mn9CWO0e/rbm
         QHvVjLzUUvA4lNvxAXWBnwWqtFpTOwD/Sn12tPWUzvWGUJBlNdl132g80cKkknyzpjq+
         M0Pw==
X-Gm-Message-State: AOAM530DAN/U1h91hN9G0/YnFdQEZewvJQfYc9d73YV+qeJ/FFSkbtIm
        pkXTs3epRBkgee/GcIdhiKpMfELDkszYNuxznWwFurXVu+MGkJEKKf2uycIclCR6P1F6KYT5auC
        OfCGXED10xwUb
X-Received: by 2002:a1c:e3c3:: with SMTP id a186mr1817282wmh.189.1601020853944;
        Fri, 25 Sep 2020 01:00:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFHccYBQtSBOeF38Mr9++2uTaZ0v1qCom3IpFP8l8WXGRvEVVUiSEkCH9IW1Dz8daHju58Jw==
X-Received: by 2002:a1c:e3c3:: with SMTP id a186mr1817262wmh.189.1601020853734;
        Fri, 25 Sep 2020 01:00:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id l8sm1920263wrx.22.2020.09.25.01.00.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 01:00:53 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] travis.yml: Use TRAVIS_BUILD_DIR to refer
 to the top directory
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
References: <20200925071147.149406-1-thuth@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5b64f283-b177-0309-cdac-b8e53b20ad30@redhat.com>
Date:   Fri, 25 Sep 2020 10:00:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925071147.149406-1-thuth@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 09:11, Thomas Huth wrote:
> Travis already has an environment variable that points to the top of
> the checked-out source code, TRAVIS_BUILD_DIR. We can use it to avoid
> the guessing of the right location of the configure script.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  .travis.yml | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/.travis.yml b/.travis.yml
> index 3bc05ce..e9c18e4 100644
> --- a/.travis.yml
> +++ b/.travis.yml
> @@ -175,8 +175,7 @@ before_script:
>        sudo chmod g+s /usr/bin/qemu-system-* ;
>      fi
>    - mkdir -p $BUILD_DIR && cd $BUILD_DIR
> -  - if [ -e ./configure ]; then ./configure $CONFIG ; fi
> -  - if [ -e ../configure ]; then ../configure $CONFIG ; fi
> +  - $TRAVIS_BUILD_DIR/configure $CONFIG
>  script:
>    - make -j3
>    - ACCEL="${ACCEL:-tcg}" ./run_tests.sh -v $TESTS | tee results.txt
> 

Applied, thanks.

Paolo

