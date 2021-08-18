Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAB83F007E
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 11:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhHRJbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 05:31:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233145AbhHRJbZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 05:31:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629279051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i5co6SUgFv+sYfd3AIqoYyrmZWFs0jZYGZn1SyDwPzA=;
        b=IX5d1q/4wT5zGGjsx1zHPBedYcRh16zbbd6zxMpusoq5B+SJ/lTJ5lDt0zjwg/MpJloWXU
        gzksN1eX7jiQAjrCr+epzGmlxjc8FZ4YzSGp9ThTE6MfUY+T4Y3AIDs68Z4z8kpNFuPngt
        ZeiMEPwQJtb/dU2fUWne1M/vscG58kQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-xtzv6DpIPhaFjvTgYlDXYw-1; Wed, 18 Aug 2021 05:30:49 -0400
X-MC-Unique: xtzv6DpIPhaFjvTgYlDXYw-1
Received: by mail-ej1-f72.google.com with SMTP id j10-20020a17090686cab02905b86933b59dso642961ejy.18
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 02:30:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i5co6SUgFv+sYfd3AIqoYyrmZWFs0jZYGZn1SyDwPzA=;
        b=jlnk7lIW/qYIkcAuTf1OPjDh9enlHfGCzmAo1J5avcZVQ2uyWcgZMuvyfcLLHEqbOI
         eyZfzfNCMFvcuDZjwOsijCS5NBG7u3zyB2W3y3YbyP2Sz1Ku6Ud+PCp0QcC1tsbrAaT9
         zcYyMwC3V0tUWFeHLKdBGssMiBsis4MYT1IenBXuULL2JVaJubdbX1oCACqpnGim4kBA
         N1ogS2nvIuASoHyDDyNyxor8eD2ZVBMp4D0JabO8CQ0Piozx//gF0vVcX2eXTd+YT9Ou
         coBuHIjrLbWP4d4z8J3Qg53/1UiN92xR2puTLip70W6JAVOgts0Qsya8kbb6i49CTunk
         2BVw==
X-Gm-Message-State: AOAM532QLKkqTcXG6kNTxQvthmzIQLPhjcF4MWqO1780h5vwh4ZwQSBJ
        ZTosjtaJHG932TpwPVNAYtKmQf0S6FbFQh2rAR87myYsTGjae3x2LRRVdjOV16Fb9OBqxnu9SJ7
        Y1XBJdQaU/qLs
X-Received: by 2002:a05:6402:4412:: with SMTP id y18mr9191914eda.364.1629279048887;
        Wed, 18 Aug 2021 02:30:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWeeuBo6KB/pXYwy7SoP5LoIwsAbzuEL2C9i4LEj2h7EFL43n1ykmf5K/Dmz15yNBIghj6jg==
X-Received: by 2002:a05:6402:4412:: with SMTP id y18mr9191905eda.364.1629279048755;
        Wed, 18 Aug 2021 02:30:48 -0700 (PDT)
Received: from thuth.remote.csb (pd9e83070.dip0.t-ipconnect.de. [217.232.48.112])
        by smtp.gmail.com with ESMTPSA id c9sm2262703ede.40.2021.08.18.02.30.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 02:30:48 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 8/8] lib: s390x: uv: Add rc 0x100 query
 error handling
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210813073615.32837-1-frankja@linux.ibm.com>
 <20210813073615.32837-9-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <182d9128-89a4-7ae0-1e2b-ba1df17cc706@redhat.com>
Date:   Wed, 18 Aug 2021 11:30:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210813073615.32837-9-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/2021 09.36, Janosch Frank wrote:
> Let's not get bitten by an extension of the query struct and handle
> the rc 0x100 error properly which does indicate that the UV has more
> data for us.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/uv.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
> index fd9de944..c5c69c47 100644
> --- a/lib/s390x/uv.c
> +++ b/lib/s390x/uv.c
> @@ -49,6 +49,8 @@ int uv_setup(void)
>   	if (!test_facility(158))
>   		return 0;
>   
> -	assert(!uv_call(0, (u64)&uvcb_qui));
> +	uv_call(0, (u64)&uvcb_qui);
> +
> +	assert(uvcb_qui.header.rc == 1 || uvcb_qui.header.rc == 0x100);

Don't you want to continue to check the return code of the uv_call() function?

  Thomas

