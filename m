Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C98C1EB397
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 05:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgFBDE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 23:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgFBDE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 23:04:58 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770A5C061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 20:04:57 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id m1so4428990pgk.1
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 20:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sK8y7xhDEF0wbhrDmJJQQ5pcbRsUuAZjohJXLjpoMlo=;
        b=wWMf2Zx/lRqctG6jKRqZGwPyvsLNqZFLUCnRgXJF+8L/5sIMdjjeX7HPp9rlfsaIrJ
         IQ2LirI/fc9uQXbngWjpPJWk2SkVCm0pvfXvLqrYw+wY/droh4jdsg6A+eqEI6QOH7/v
         /31hf9RvP6qu9Ki1QFKUdbIAwtBJ81I7VFHxNm6KnRSZE8WiPwWH4dr8sSOQGNoH34j7
         YMBmiN3wSDp9MbFMLlJcpncYFFeHyq1o81Pa00eFY2p8jQtwqt4JiUWzRjHifiHc7Eov
         eEIWxX/nRFsqxmz+mASgwrmaR+OK0dMGyvVItPAkHQ7/12JARlwENFNi23qkOFRmhOd/
         Cosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sK8y7xhDEF0wbhrDmJJQQ5pcbRsUuAZjohJXLjpoMlo=;
        b=SlE/Xm+GnX7SrlJxfaGLZMs6sLM317VOmTrkG/7Z2Zw9p1X9rLM50XlW6CiBttNXWS
         uYBc6MMWWeTdIhOHdINJt1RboVKvLA4s+1klmYacJGpCOyVEqIxwJbZ8eRrr+p1fc8JZ
         MdDY5z2HEo6VIppm0HnWUEik2vR4zR+bb6lY6Xuu7hI2ZTxJxFrG1X7alca0+PfdTsdh
         yn1bczjy8VGHiL0HXoxC/XpwAV1hVzklB8VZ8Cai9n04H2lC2XYzGOsu3gy3c9m9OpDC
         vr2nwN3aGzqt/FfM2wrzBNFcLUVCA5bvCEM91Op4VzVUEO/N22epG07XqnB56b9AmzI8
         3Cag==
X-Gm-Message-State: AOAM530nSDaGR3bUy312wM7ozCtigF/CHn8wyU0r4w4IU4Pfd3Jgm6gr
        Wdxo4ryzcu3y4xUGowJe5TDr2w==
X-Google-Smtp-Source: ABdhPJwYD8LkCJGDEZJ5YOh2yTBuJbwriG3lG7KEKU9o9y+kC0wdxFzaQT+QxSdlTJC4Ls3qqlVlNQ==
X-Received: by 2002:a62:884b:: with SMTP id l72mr8413251pfd.242.1591067096763;
        Mon, 01 Jun 2020 20:04:56 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id x1sm676531pfn.76.2020.06.01.20.04.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 20:04:56 -0700 (PDT)
Subject: Re: [RFC v2 01/18] target/i386: sev: Remove unused QSevGuestInfoClass
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-2-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <66291c37-7804-cfad-4c96-56a0852f09b3@linaro.org>
Date:   Mon, 1 Jun 2020 20:04:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-2-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/20 8:42 PM, David Gibson wrote:
> This structure is nothing but an empty wrapper around the parent class,
> which by QOM conventions means we don't need it at all.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  target/i386/sev.c      | 1 -
>  target/i386/sev_i386.h | 5 -----
>  2 files changed, 6 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
