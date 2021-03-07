Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34014330108
	for <lists+kvm@lfdr.de>; Sun,  7 Mar 2021 13:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhCGMtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Mar 2021 07:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbhCGMsp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Mar 2021 07:48:45 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BB6C06174A;
        Sun,  7 Mar 2021 04:48:42 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id n79so6717425qke.3;
        Sun, 07 Mar 2021 04:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Sh8Gq3xXPV8r6pCBgU3qRZ/zv3llBCo/ukoG7YI1B6o=;
        b=W1llN+mC69wsu46WFlBMoFXcOnmVr7w0NFEv8x9AJaKgTSImmeCGxTwulSESANzMZb
         5QrRLyXhWRLdMn3gd1w7hSGEjUbXmxrPBJhCpf4ux983dCPe45FS6mktIWQisPQhK9Tq
         NLveo8d3ow+mrKYvQ3/lYmyhm6XFWaI62Se/mDoLeEQxG1pEq/xvPZroRcaQI8iRPw45
         OCAfkJvZelYLqfG/lrbAps9A4zLtFQBb/iUebqGE129kI3dXK+o6bcV2UoCZUlLFIYDP
         xGMCNUzTC2uJraLOZlHmOfbCc+uflS6Vi+SrfcoEJHdcKiM3w5V7v/WrAO1Rw+XJL31t
         P8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Sh8Gq3xXPV8r6pCBgU3qRZ/zv3llBCo/ukoG7YI1B6o=;
        b=SMtzRnbgjnY96v5iXLG1jKJ3QgaaU21ndupZPGJqGqtmoO9r80ydxuchTUiNNk9gn5
         SZzhG5ZWLSoAvlwKvwjuSc3+O2nAUIiHXUFtuqM+BxHmc6vU/dscrB54i7Ndw7Z3APrD
         DtFpA9JPn4Bunwu4h1ox0rHNWKl6Dq0iumRQV1+g+IVtyZCBIABg7o7/2RbpJzWUoIEG
         QbJKwI7+27/w0iI2Mh4qfFcqxL2ePrajXu1fK6BQ3nLRC7MrBmi54VLe2L9VQOjIEnfL
         jknMbUniOzwLJY6VHOb0RVzk98ktZRftT0c0MiiUeyr7s9bn549e27zOksJiJ0+2KkKw
         pTTA==
X-Gm-Message-State: AOAM530yG88O+/m0hHILgfn/2rhVqR8WL9Pj4V2zvCFjwIhsgzeIu1sK
        5LeNyFkSbk4vs6yBIheB1xU=
X-Google-Smtp-Source: ABdhPJx3c7mILG8MIBfrQS6fPbhTs6qFOLaaIS6D52odgn+G5oEd+ci+KjN5R16r7BoJb1S4sbz+hw==
X-Received: by 2002:a37:a282:: with SMTP id l124mr16162623qke.37.1615121321567;
        Sun, 07 Mar 2021 04:48:41 -0800 (PST)
Received: from localhost (2603-7000-9602-8233-06d4-c4ff-fe48-9d05.res6.spectrum.com. [2603:7000:9602:8233:6d4:c4ff:fe48:9d05])
        by smtp.gmail.com with ESMTPSA id e190sm5640131qkd.122.2021.03.07.04.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 04:48:41 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Sun, 7 Mar 2021 07:48:40 -0500
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
Subject: Re: [Patch v3 0/2] cgroup: New misc cgroup controller
Message-ID: <YETLqGIw1GekWdYK@slm.duckdns.org>
References: <20210304231946.2766648-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304231946.2766648-1-vipinsh@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Thu, Mar 04, 2021 at 03:19:44PM -0800, Vipin Sharma wrote:
> This patch series is creating a new misc cgroup controller for limiting
> and tracking of resources which are not abstract like other cgroup
> controllers.
> 
> This controller was initially proposed as encryption_id but after
> the feedbacks, it is now changed to misc cgroup.
> https://lore.kernel.org/lkml/20210108012846.4134815-2-vipinsh@google.com/

Vipin, thank you very much for your persistence and patience. The patchset
looks good to me. Michal, as you've been reviewing the series, can you
please take another look and ack them if you don't find anything
objectionable?

-- 
tejun
