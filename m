Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852613D0E72
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 14:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238980AbhGULWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 07:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238612AbhGULRQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 07:17:16 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B08C0613F0;
        Wed, 21 Jul 2021 04:57:15 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id r21so1604708pgv.13;
        Wed, 21 Jul 2021 04:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1aayxhP7LR5pbpYNWPExB3m6iym6gHf5XQMlRKlxp94=;
        b=Gb3sYMtxc/kWDCMnCmYUN5o70Tvt9W/hvjABaQVw6GepiW6AF7jJcANbzNBRV1gq0H
         KVgsqId2MY+RXzDpDGY6dPw0M9zOWZUAQNGPy7PM2rys/HzrGgdYJ1JWxUE1QI9btZVV
         O6Nge5AQbsqTmzXcQomJIje10kgbOVDLOw6CAEgavNSXA2gO45gvZInn+kY7JYMZv+qO
         7oKYPWFeZHS6IplBXQIb7MGoEHkzU7p7v5SEAUS6Qb0XpyY5ciKG5wbqqw5mBV2thXmN
         kc5wkdciG83RddYCL0ig7AXvXY6vLlAn6fNTtakKWWWjb2B/kLBoNRRLEWJHhmSw7M5h
         laRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1aayxhP7LR5pbpYNWPExB3m6iym6gHf5XQMlRKlxp94=;
        b=uJEdn8tjxHhJCruSReDaV0ZOgAvLnu9yr9M4loyMMjVorvNRI0CYggM0nItHGV/y4v
         fieSuGoLFpwDT/XXuS+gM64Sjj0W6AT5HzwrX5Ph0y7uv3PDcgLT7PLn6tZJVll5MGVN
         yFpU9xFiWxc5uFdr6rDxXqPFTVigl6yPKDvLp+s84o2uk6AYbXAsy45gr3OG6doqqLu0
         DrpvWLutgCnYfW50E/71xlc5Jj+GljbnAHdkxKsPZ924ifcjGuJ+IjRAfwGqCS+dElAA
         B+Sp4menyDj3PuG6tPvkbLsTyvNjXT9vq5CBuKjC883hThd2b6/yTQ8dxca48gHY6Ifh
         LV3Q==
X-Gm-Message-State: AOAM532FYp72Pa9LPt1LJFVv3hWiXCVJRtTJ2D8LnsQ3tTnqiaOlNSnA
        MN8mlY8IECGg3QQjRsIPyyQ=
X-Google-Smtp-Source: ABdhPJx8Jc6D+8J2xe+jplPG6WjflufBXyqLNydLZmg9K2ukmxfm1tClEJcFPfqxf5GDpWMtdTO8gQ==
X-Received: by 2002:a63:a01:: with SMTP id 1mr35267098pgk.360.1626868633306;
        Wed, 21 Jul 2021 04:57:13 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j12sm25930570pfj.208.2021.07.21.04.57.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 04:57:12 -0700 (PDT)
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        boris.ostrvsky@oracle.com, Like Xu <like.xu@linux.intel.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        xen-devel@lists.xenproject.org,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20210716085325.10300-1-lingshan.zhu@intel.com>
 <20210716085325.10300-2-lingshan.zhu@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH V8 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <fd117e37-8063-63a4-43cd-7cb555e5bab5@gmail.com>
Date:   Wed, 21 Jul 2021 19:57:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210716085325.10300-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/7/2021 4:53 pm, Zhu Lingshan wrote:
> +	} else if (xenpmu_data->pmu.r.regs.cpl & 3)

Lingshan, serious for this version ?

arch/x86/xen/pmu.c:438:9: error: expected identifier or ‘(’ before ‘return’
   438 |         return state;
       |         ^~~~~~
arch/x86/xen/pmu.c:439:1: error: expected identifier or ‘(’ before ‘}’ token
   439 | }
       | ^
arch/x86/xen/pmu.c: In function ‘xen_guest_state’:
arch/x86/xen/pmu.c:436:9: error: control reaches end of non-void 
function [-Werror=return-type]
   436 |         }
       |         ^
cc1: some warnings being treated as errors

> +			state |= PERF_GUEST_USER;
>   	}
