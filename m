Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB0732CEE8
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 09:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbhCDIyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 03:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbhCDIxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 03:53:54 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6657C061574;
        Thu,  4 Mar 2021 00:53:13 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id l132so25784951qke.7;
        Thu, 04 Mar 2021 00:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7yRX9wnbaqglQOqo35jp40oCDrn05rlNxnwnL03DlpE=;
        b=KZp4VpCLyjq4r7v+f3wf3DEJwmNX69ZdxRoq/N35GcQfqmjHiarec+NRj7KIldoeDn
         pZbEMbqOFxiQNvPhJdL/up4J+DHXdVPtN8l6ev1aGrjKVWrHdVUiyQ3Ne3+oN+ssrls6
         LxnEGJ3S+kkZGcOyVXuepIbNqb1RPDtwc1GiQwhln41uDV1zNmeLCoGVCz1Zou/rv8Km
         3zoPGw9sfJxB/GP+6HeJLHc7ZL8k/473wsXPli2Df4HTj+afRv1U+MNTSquDZmTG4vZZ
         1GO0fzGBFPwvgzS1jPRN+1sMTk1UKbe7A2bA5z1ZcNiHFJUYu/I4XRGD4g+xai+Z2UfJ
         P1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=7yRX9wnbaqglQOqo35jp40oCDrn05rlNxnwnL03DlpE=;
        b=BrsrX6sXJT4Igv+0Dy4ru0hFWHRrHKS8s1CqYahfpFjv50gCTHtU17o+rIa93aOkKx
         apfyuIMozmBdxcHZbCuU68GxH19Ns2AT31X2qK371pUoNR9V3wA7I7d4echRLgVVhqI1
         TD8vctw2hQSAd6qcgU46GV4l4AZ08M/H86Dvi6FJQcfsF45PJYWkT1f8dDk+W5obDj8R
         V0cs3B9puM29cVdw3MXMzuSoxX/wdLRwMF/NLA/imzA0v2vkStX/SDnOIcMAAR0VuRbA
         gldMY/GE59QROPINJ/dV5d6DJSmFw0qfjVIltjjDaf5MHM+eDgTO3DG/Ps/GD7h8m37i
         PYcA==
X-Gm-Message-State: AOAM530UPQMHNuz4/4GaSR/srqejclm9+kxQnQTIOLlQEjWRd40f5e67
        Le6felvS1iyGBxjTUCtXlAs=
X-Google-Smtp-Source: ABdhPJxjxqpmSS1hWEgEm4NSaHKWX/oNGl1qgvhGmr20OkNkRZoYpCeiWyVlFdEF31Z6wDbKA53ELg==
X-Received: by 2002:ae9:eb8a:: with SMTP id b132mr2828097qkg.296.1614847992933;
        Thu, 04 Mar 2021 00:53:12 -0800 (PST)
Received: from localhost (2603-7000-9602-8233-06d4-c4ff-fe48-9d05.res6.spectrum.com. [2603:7000:9602:8233:6d4:c4ff:fe48:9d05])
        by smtp.gmail.com with ESMTPSA id v145sm19926066qka.27.2021.03.04.00.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 00:53:12 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 4 Mar 2021 03:53:11 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 1/2] cgroup: sev: Add misc cgroup controller
Message-ID: <YECf9yxMMAztYEH4@slm.duckdns.org>
References: <20210302081705.1990283-1-vipinsh@google.com>
 <20210302081705.1990283-2-vipinsh@google.com>
 <YD+ubbB4Tz0ZlVvp@slm.duckdns.org>
 <YEB6ULUgbf+s8ydd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEB6ULUgbf+s8ydd@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Wed, Mar 03, 2021 at 10:12:32PM -0800, Vipin Sharma wrote:
> Right now there is no API for the caller to know total usage, unless they
> keep their own tally, I was thinking it will be useful to add one more API
> 
> unsigned long misc_cg_res_total_usage(enum misc_res_type type)
> 
> It will return root_cg usage for "type" resource.
> Will it be fine?

Yeah, that sounds fine.

Thanks.

-- 
tejun
