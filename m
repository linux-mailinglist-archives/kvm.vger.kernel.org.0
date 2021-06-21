Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1508A3AE42A
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 09:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhFUH1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 03:27:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230393AbhFUH1s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 03:27:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624260334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y91dYcMgXLfHCLyVYB59BpoFbsjdnxGwPE3tJAk3G9E=;
        b=ijREfezNfySFETQ6KGzBus6nYQ0OlXJ4zndQ3dXCj5LRfOzw/1eXoJ6B14I6aCcWWaUnBp
        e6LOS4n3Hz/pcw3p4qQaa0Rl3aKvahv2HUNZgy8W5p5aTBec5KcCRRf745RLD7/J7ko0y6
        tSzVPI/V0R2E206nYw+WqonlYHGHkLQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-RVWeyvspMIyjERPo9vRPhw-1; Mon, 21 Jun 2021 03:25:29 -0400
X-MC-Unique: RVWeyvspMIyjERPo9vRPhw-1
Received: by mail-wm1-f71.google.com with SMTP id v2-20020a7bcb420000b0290146b609814dso6666539wmj.0
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 00:25:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y91dYcMgXLfHCLyVYB59BpoFbsjdnxGwPE3tJAk3G9E=;
        b=XT+xpZEeRz9n5dhfTid3Qa8iA13RtQ3su1E9d/eRhFJRyTv/T0LK8qX4iBrNPRY2id
         buGWvoBrJ1LHoQjXRVSGxuZ1KrhQ05ImKHAzxKZ509YmYPTQREgdR8Jkj3gLdsqB1uXl
         DqZ4dj0anOqJVGZLZ0SK1ODd/ks3upUTaPx1wuESs7PZPDOFyItJdR+otyLeROrk2xqG
         wXyAmqjL1mEARGLhS7MX7yxseydP1wa2jC3HQXTgwLUqQ+CGYc2+skEgjLJ9DH6x2sJR
         NiTbsmsWINmp0B/6kRQfEqRtK9Fw2p1OYkWVRePJrw0hQAV506mwL8KfGQoX0TOX6s8D
         AdEg==
X-Gm-Message-State: AOAM530Yi2dOG+/j6oNLtHdWZamGSOthgkGdH/+OffCsCuyOxtYqoEte
        qWsvbva5BCdmL0zH2TXq7YQcSFm/rSvMrD4W7OZwu/inKl+LT1NK26Pq1xkCNUgkCiLHXYwZKKt
        3K2ZRgnaSE1wwEg+BtSiXxeUT5dCk8bOnVyo0XBd5ZGbHxaEAI6d+MuVVPoWP
X-Received: by 2002:a5d:4b8d:: with SMTP id b13mr9209307wrt.147.1624260328477;
        Mon, 21 Jun 2021 00:25:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHVU6j+LzdrJcmaQeig17pW1uGhnpdStHIRjy++aHV83rTrNrXZmfslT877E/9tuHYIgTMtw==
X-Received: by 2002:a5d:4b8d:: with SMTP id b13mr9209272wrt.147.1624260328101;
        Mon, 21 Jun 2021 00:25:28 -0700 (PDT)
Received: from thuth.remote.csb (pd9575fcd.dip0.t-ipconnect.de. [217.87.95.205])
        by smtp.gmail.com with ESMTPSA id h15sm16494162wrq.88.2021.06.21.00.25.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 00:25:27 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] README.md: remove duplicate "to adhere"
To:     Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20210614100151.123622-1-cohuck@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <a3184421-5548-a7d3-dca1-78c922015a6f@redhat.com>
Date:   Mon, 21 Jun 2021 09:25:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210614100151.123622-1-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/06/2021 12.01, Cornelia Huck wrote:
> Fixes: 844669a9631d ("README.md: add guideline for header guards format")
> Reported-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   README.md | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/README.md b/README.md
> index 687ff50d0af1..b498aafd1a77 100644
> --- a/README.md
> +++ b/README.md
> @@ -158,7 +158,7 @@ Exceptions:
>   
>   Header guards:
>   
> -Please try to adhere to adhere to the following patterns when adding
> +Please try to adhere to the following patterns when adding
>   "#ifndef <...> #define <...>" header guards:
>       ./lib:             _HEADER_H_
>       ./lib/<ARCH>:      _ARCH_HEADER_H_
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

