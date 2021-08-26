Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8B73F81EF
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 07:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbhHZFIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 01:08:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43277 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238028AbhHZFIt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 01:08:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629954481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sn/WZSwDqIVTDMJKJC/8Vl38JOzR7UmiIlMQzq19EYM=;
        b=KP33lKtPvQdb0MWvqMuUVqnB5oV5mdxCbL+S4XYwnb9vVmpR7Z0Frct7d9zLRKVvedbt1d
        IrsYvUFeYqHOoIct8Prmhu/2fYAYTzXapYHdhQ0Z2mo2xwCXrQIuJPzuRdwDsaBxBHs6J9
        rNUkMCaf2JmVrFCCdoykBVPRwtuUceo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-voHNK3wUP2yKRQ114qaPmQ-1; Thu, 26 Aug 2021 01:08:00 -0400
X-MC-Unique: voHNK3wUP2yKRQ114qaPmQ-1
Received: by mail-wm1-f71.google.com with SMTP id h1-20020a05600c350100b002e751bf6733so531155wmq.8
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 22:07:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sn/WZSwDqIVTDMJKJC/8Vl38JOzR7UmiIlMQzq19EYM=;
        b=HKZy48kmmFX8dPVyvCd+RWAega4AUhIvVTDqHRoq+qQZmL3EOs4BDexnp3MZoDjaff
         iKpTEpeKJdpJ1+uHPX6SVubAJup3B7ihJwkRn+c5G0Scqj301tshqfAkuSHrBExB5uRv
         NPrtxc1EEP5t9uAD3XxQCEWy1IsZ1K+y0o3+pv7RIuHqrguPob7E2l2Q70Ww5m/Vb2ef
         0fnl9IGPfrPoTh14RPaiLsQPa5L2aG/dgZIrn+nqg5fMLgjhIGJT5iPGoh1GaRSNB1Ax
         kwQh+x8vtig5X8Vffdnmty8VHxf7OCxcY/9BWafp3EMSXuymnQNgoYhon7uEOrog1IyA
         UHfA==
X-Gm-Message-State: AOAM533lTOFFB8voSXOAJvxiqy1snwB7i/3f67OFwFt48C4zfur1VbzV
        wQSY69u0Hce8u86GLmD4pExlZDxhlXxMkPtHAQFSJ58cvQp/Cuhtih9yPQygm6KTA91fbqP0+px
        YsiDjs09eHJ1t
X-Received: by 2002:a05:600c:a0b:: with SMTP id z11mr12273516wmp.147.1629954479019;
        Wed, 25 Aug 2021 22:07:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQzHopExG2NxGPkgUujxx6i6CKL/cdBxN2J1TO2s7XJA89XtbJMjp59REf/RApYdja6068MQ==
X-Received: by 2002:a05:600c:a0b:: with SMTP id z11mr12273505wmp.147.1629954478873;
        Wed, 25 Aug 2021 22:07:58 -0700 (PDT)
Received: from thuth.remote.csb (p5791d7bc.dip0.t-ipconnect.de. [87.145.215.188])
        by smtp.gmail.com with ESMTPSA id s12sm1877660wru.41.2021.08.25.22.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 22:07:58 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/2] Makefile: Fix cscope
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, Paolo Bonzini <pbonzini@redhat.com>
References: <1629908421-8543-1-git-send-email-pmorel@linux.ibm.com>
 <1629908421-8543-2-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <1dd4c64e-3866-98c9-8178-dbff90dca55f@redhat.com>
Date:   Thu, 26 Aug 2021 07:07:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1629908421-8543-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/08/2021 18.20, Pierre Morel wrote:
> In Linux, cscope uses a wrong directory.
> Simply search from the directory where the make is started.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index f7b9f28c..c8b0d74f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -119,7 +119,7 @@ cscope: cscope_dirs = lib lib/libfdt lib/linux $(TEST_DIR) $(ARCH_LIBDIRS) lib/a
>   cscope:
>   	$(RM) ./cscope.*
>   	find -L $(cscope_dirs) -maxdepth 1 \
> -		-name '*.[chsS]' -exec realpath --relative-base=$(PWD) {} \; | sort -u > ./cscope.files
> +		-name '*.[chsS]' -exec realpath --relative-base=. {} \; | sort -u > ./cscope.files

Why is $PWD not pointing to the same location as "." ? Are you doing in-tree 
or out-of-tree builds?

  Thomas

