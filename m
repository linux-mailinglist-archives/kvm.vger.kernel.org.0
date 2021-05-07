Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A86376558
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 14:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236852AbhEGMly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 08:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhEGMlx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 08:41:53 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5552EC061574;
        Fri,  7 May 2021 05:40:54 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id a5so484875pfa.11;
        Fri, 07 May 2021 05:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K0GDzDwQRyBfODABKyw5LLI9ujmEOh6+qR+zb02Vkbw=;
        b=Z0NORb9zPpAnBIhoiVQcJ/JPUDLXhBlNo4Lc/ml2QdvtGXszL+j5clrN40ofix0rrt
         OhA9CAnuwzJJHr5VMn8u4pOhnLTve3ssdslJSMZ/y0iuVY6wKxotaeq3eZWw+SPeJbiA
         uQzK4n90YodGutnlO6oV0x/Q7SzusfBcjOihQEyVZWQ2umJTNtK3xpbRE7AMR8fiZHEE
         xGH1FVXnpQbguiucjfzTX/GNMY3A0Ir8rfsfFYrSPDBub71db9LenlW4BwLlQ35KsRiy
         pI74NwHqGTkvn5+ogLlnIgd4DvcbbB0L7kGoCCjCPOVaia6xDsh9pQ6brkIRSdzhwXYz
         KkHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K0GDzDwQRyBfODABKyw5LLI9ujmEOh6+qR+zb02Vkbw=;
        b=YZA5VxJwNcqsMF8ptrUCnQJUjjSkRQ11FlHLdfI9AAMkxxXwkgvfNPsDrdV8ZXnWcT
         4kt87ynqxtwwF44XCs439ox/xC9kylWTthQgK6WC2n+c+2uGsnMVd96HbjBSCEpihi2O
         +NT+3xsefPK3+gImw4W/sGXOlE0UlF1Nn0129Whh++zNyUf1Okq7Fk+UaCTDmvU4NQfB
         oI5NAFitPHruzNwJHBYn3OWkXgehWiqDZ0qxTK2xRiRBK11tZxBCvh1aGmLZAwnodQAI
         2M5zTGug6kZlr6s/hzpmwc7UH5jBRrmVpNGh1vzrLGzyhVrI2/9siyg0oonEmLSkyQpC
         Jufw==
X-Gm-Message-State: AOAM5336ZmnBR+ca2SoPYUmQhBTENSi7Fme5igs+BY1+Opq4u1S3UJr4
        6FlQbdbS06pbkHU+CPr2alI=
X-Google-Smtp-Source: ABdhPJz/SealIvabP7ffELGzmScDoaFvJraiTa5lh8vtwVwLejQeozppMlBQGlGe2Jbw3EoFvegReg==
X-Received: by 2002:a63:5b1a:: with SMTP id p26mr9748867pgb.65.1620391253811;
        Fri, 07 May 2021 05:40:53 -0700 (PDT)
Received: from localhost ([203.87.99.126])
        by smtp.gmail.com with ESMTPSA id f14sm4658373pjq.50.2021.05.07.05.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 05:40:52 -0700 (PDT)
Date:   Fri, 7 May 2021 22:40:49 +1000
From:   Balbir Singh <bsingharora@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 1/6] delayacct: Use sched_clock()
Message-ID: <20210507124049.GC4236@balbir-desktop>
References: <20210505105940.190490250@infradead.org>
 <20210505111525.001031466@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505111525.001031466@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05, 2021 at 12:59:41PM +0200, Peter Zijlstra wrote:
> Like all scheduler statistics, use sched_clock() based time.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---

Goind by your comment about preemption safety not being a concern
the patch looks good.

Acked-by: Balbir Singh <bsingharora@gmail.com>
