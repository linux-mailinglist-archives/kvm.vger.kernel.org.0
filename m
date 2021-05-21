Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80B938C8CC
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 15:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbhEUN6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 09:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbhEUN6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 09:58:35 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4FAC061763
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 06:57:11 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id a7so2329289plh.3
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 06:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=NjZUtJdczOjy5Jk/YfX+sUejZ8aBg91t6cbdQAgaNT8=;
        b=Vu/kWArDrPmt8so+bx+BKBHOFW1lbai2ILgILyasgTUyxFxt9NFX6hg3estEAM9ZoX
         3URjM+X+VerVBypxh5nWY1bl6KIJyDBLsI7XgLF6Qdd8C8Xp7tgzXrrQ3+rw2WPLeVSS
         AwvhhZlSvvW36X6QqNr3q3N+P5AqtoWZCb3P16+jCHeCLl+oCseT8jyXS8mLHE3lxRlE
         eE1WlEGwKFVVoC0jmG7IZspZdYiKbNn5zijyk7+VQtooEIFWqYdbyy79vvLQplM6CjdZ
         IBK8HZnumxaJKIvlZzgxYSNvBdQQgazlqVOBoN/FnHWUOXBOE+3c6+PgPKAAx+POWvpk
         5hVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=NjZUtJdczOjy5Jk/YfX+sUejZ8aBg91t6cbdQAgaNT8=;
        b=itjUYZoM5KMuhfixVheUnZnazn/IGO+phEtwj8Z8ZC6N0lyvfwee3O9aXVxMhXDy4L
         xoxp/1UnDDDzSPVh9/ofAuvCT26BuVkFh2FG5/gVrGLjevqpG7yTr0GnVHWNpGmCGyWI
         o4ULZvN0Y5+2bO48Fx934TfRTGRprsYzgdXj2jt7NkyTrN1lfKGqRYnuUSFOVrIGm4FH
         nmoKBXKwT6cA+K+zA2l6fvGbm2XzoXb5/MpQS3rpwPG6+SBdzEhHGWbiCxK0bmZnKgS/
         57Bgx5t8r1bPOVEppU23GO5zDFzwwhk0sLAhQkM7A/DwUs4RnguSTrdG1rlstZ3djt3B
         LaRw==
X-Gm-Message-State: AOAM530GPlKc1iVZzX4PGghX2t8EzEgkcRMCDOSHIGT8Mb+wopo2SlX3
        pLcNOM9uRL8rqRQ6p90u+LVaRQ==
X-Google-Smtp-Source: ABdhPJw5OP7WEatFU4imZ4YvthY7mSPYHS7F9yiFVt+Nbl7Tj9XdT5e8sfHbK1BFIFqJRPtg4m/PPQ==
X-Received: by 2002:a17:90a:a78d:: with SMTP id f13mr10719177pjq.161.1621605431267;
        Fri, 21 May 2021 06:57:11 -0700 (PDT)
Received: from [10.70.0.90] ([45.135.186.36])
        by smtp.gmail.com with ESMTPSA id s14sm4437432pjp.16.2021.05.21.06.56.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 06:57:10 -0700 (PDT)
Subject: Re: [PATCH v2 4/7] uacce: Use _BITUL() macro in UAPI headers
To:     Joe Richey <joerichey94@gmail.com>, trivial@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Joe Richey <joerichey@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Peter Xu <peterx@redhat.com>,
        Lei Cao <lei.cao@stratus.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-accelerators@lists.ozlabs.org
References: <20210520104343.317119-1-joerichey94@gmail.com>
 <20210521085849.37676-1-joerichey94@gmail.com>
 <20210521085849.37676-5-joerichey94@gmail.com>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <75945578-ce30-8ce2-fcea-2e080e619af4@linaro.org>
Date:   Fri, 21 May 2021 21:56:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210521085849.37676-5-joerichey94@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/5/21 下午4:58, Joe Richey wrote:
> From: Joe Richey <joerichey@google.com>
>
> Replace BIT() in uacce's UPAI header with _BITUL(). BIT() is not defined
> in the UAPI headers and its usage may cause userspace build errors.
>
> Fixes: 015d239ac014 ("uacce: add uacce driver")
> Signed-off-by: Joe Richey <joerichey@google.com>
Thanks Joe

Acked-by: Zhangfei Gao <zhangfei.gao@linaro.org>

> ---
>   include/uapi/misc/uacce/uacce.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/misc/uacce/uacce.h b/include/uapi/misc/uacce/uacce.h
> index cc7185678f47..e0b4c8a2d29c 100644
> --- a/include/uapi/misc/uacce/uacce.h
> +++ b/include/uapi/misc/uacce/uacce.h
> @@ -2,6 +2,7 @@
>   #ifndef _UAPIUUACCE_H
>   #define _UAPIUUACCE_H
>   
> +#include <linux/const.h>
>   #include <linux/types.h>
>   #include <linux/ioctl.h>
>   
> @@ -23,7 +24,7 @@
>    *		  Support PASID
>    *		  Support device page faults (PCI PRI or SMMU Stall)
>    */
> -#define UACCE_DEV_SVA		BIT(0)
> +#define UACCE_DEV_SVA		_BITUL(0)
>   
>   /**
>    * enum uacce_qfrt: queue file region type

