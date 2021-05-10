Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E3D377CEB
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 09:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhEJHKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 03:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhEJHKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 03:10:06 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C68CC061573;
        Mon, 10 May 2021 00:09:01 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id l4so22872403ejc.10;
        Mon, 10 May 2021 00:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0CHUOqR7/6H1oK4FSD7YVVjmtCKdO0zZLijsAd48zvc=;
        b=mf3VK1MIRy4CFEQRAmNjb53ZfY4H1BMaZ0Gx3dZEcf8ctXJoZWDf2jEMhvIxzoxyuI
         BUOKek91RdMkyVUBdaw+t6bLWgL2d73H25g2MzE6bz7oLD8ivDuzly/qmkrxXbmDNH7R
         Rq/zMQTU0/TraVY3jD+H/gRwC4BQQiBWmkaCdjajNLqc+u4+4cxWfAATSzn/cddM2y2a
         DwAEESVIoRedDEmNA7wGfggknVVvIPc8cnrDWxjH5ElfNIbuqQCSTxBXHnq8HooH6UVT
         jqV9st5IZ7T4AO5HpBerfcFGe/jcVvkh9tteM8LqIwDoHqgrCauHlEO13tRyR6shsEN5
         dK8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=0CHUOqR7/6H1oK4FSD7YVVjmtCKdO0zZLijsAd48zvc=;
        b=mCY03Vjt16wtTeI2b3O29dHmGRgFXbfl/vIxTWrPBtsx53Y6Duf6QG7XlTwYz9gjh7
         LU5nWMFqeV3O/Sntb9b0PiAoIrNz2HDBh6YzLwNQ68Hn8uLzbfHZw5/1bvmEuat6++F5
         bhfD9RMxBt/lzD6r0dInwAPGRPbpuFa9N7JBH5u0qvhgLO755eh8Tt2JztTE51brvr2K
         zbzbo1145JImgAneq6OSqNp7AYX1PLgwtaZ61IoLgrRpvb+sC1i1WP+JkUwC1tEqmVGi
         P3zjdYsm8ZgqmzbtS1TQuXE4JCfogVqHBrjXAmMXmV/PqBW8/fb1p4tFXQoysyHg6H1e
         rAUw==
X-Gm-Message-State: AOAM533XQ+8x/yK+KuBZFOH9QjZCDSWEywDu9kYa9K2mhVlpRKwJe1Uy
        tXeboaI0X9q57VlArBKUZ5ok9Ac5LsE=
X-Google-Smtp-Source: ABdhPJy+LzEA5+0rdJ8WUcSRzq+XV6TJr5bczBiF93K/R+YPbIxKej5mYDyRmXkWloihWvNfWtNVJA==
X-Received: by 2002:a17:907:3e23:: with SMTP id hp35mr24575568ejc.437.1620630540127;
        Mon, 10 May 2021 00:09:00 -0700 (PDT)
Received: from gmail.com (0526E777.unconfigured.pool.telekom.hu. [5.38.231.119])
        by smtp.gmail.com with ESMTPSA id p4sm8413406ejr.81.2021.05.10.00.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 00:08:59 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Mon, 10 May 2021 09:08:57 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, bsingharora@gmail.com, pbonzini@redhat.com,
        maz@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 0/6] sched,delayacct: Some cleanups
Message-ID: <YJjcCTD14kZFtBo+@gmail.com>
References: <20210505105940.190490250@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505105940.190490250@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> Hi,
> 
> Due to:
> 
>   https://lkml.kernel.org/r/0000000000001d43ac05c0f5c6a0@google.com
> 
> and general principle, delayacct really shouldn't be using ktime (pvclock also
> really shouldn't be doing what it does, but that's another story). This lead me
> to looking at the SCHED_INFO, SCHEDSTATS, DELAYACCT (and PSI) accounting hell.
> 
> The rest of the patches are an attempt at simplifying all that a little. All
> that crud is enabled by default for distros which is leading to a death by a
> thousand cuts.
> 
> The last patch is an attempt at default disabling DELAYACCT, because I don't
> think anybody actually uses that much, but what do I know, there were no ill
> effects on my testbox. Perhaps we should mirror
> /proc/sys/kernel/sched_schedstats and provide a delayacct sysctl for runtime
> frobbing.

Reviewed-by: Ingo Molnar <mingo@kernel.org>

(This includes the #6 RFC patch.)

Thanks,

	Ingo
