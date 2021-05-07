Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E386337655E
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 14:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237021AbhEGMnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 08:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236866AbhEGMnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 08:43:16 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81F7C061574;
        Fri,  7 May 2021 05:42:16 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id b21so429085pft.10;
        Fri, 07 May 2021 05:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r343sYYX3gjN34sl7yfwkl65nAO5cMLx9O8W6LxV6Nc=;
        b=evv0J+LZlt/VQzYYuIj0rgKwkQS/VtXVdS02h5ttTfvb1bX/ktG8vkIu9N+6IsHOmI
         SS8cqRonUFMi6Kc0T1vVQNDrKqyVeZiI3CND7gXrj9UjtlLwDtdWnM50mXwmX/yuY4ba
         Q5zVO0F4jF3YacJ/Hd7QZx9IqvImXN0lDnK4v9zD9+bS+CFiQD9BszPTpDOv8+st0xsC
         Xry647hK3VMEkBRm4BSzpJktrJeC+MnJaPdcjVT3V69abts0fe44EdLYeuyxR/Rx+QHT
         rafpZqkdFt8jB2UYfbifJ0uT0eGPGJwVswJLSpmRQAg6dq5fEd3LHBUttNkJNshIksvl
         9W8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r343sYYX3gjN34sl7yfwkl65nAO5cMLx9O8W6LxV6Nc=;
        b=go087+mmW5MLW38oZ6hpl+fq6CKwN7WQRVZDctgdnah2CODXQWZl9DISVPY/bJpa3C
         h/h0VjrwtBFM9gT5ZOjwQWeb2+B9zM+C7AaSat9Il45YMK/dAJ1HrNXDlKJZrSu9HZ6Q
         Ze0w+zH/EMT8Ez1L7jLyKsqkviRxAql8M49gAA403s5Jg9UD7ACuC97Q1Ss8B1syo3qH
         qNBQmpbxpRtnB7KmjOINkSafUgflCAKsCMg9Xn1eH3prIjO8GwEqXWdukNqffd6K38e6
         DXrkGkX0QZQ0MB28FZCPGRlbYfqGQJFPPQH9aFtYnORWpOjC2Kty/vsEyFVGuNONntYP
         Yk5g==
X-Gm-Message-State: AOAM532TBxrxNRCRZXelCK33RYEvwjHQVCrr/DOFXQTLssc8pu+28qLS
        vpdG+wmnVn0/p1gP3O7kZ5Y=
X-Google-Smtp-Source: ABdhPJzM2zFMU9YP7Gehcxa4p+2nJPHQJOWmhaYM/aumwLmSuF04zaSgJBWlb8j+UKRVSUC1WI4Azw==
X-Received: by 2002:aa7:8d03:0:b029:259:f2ed:1849 with SMTP id j3-20020aa78d030000b0290259f2ed1849mr10504817pfe.30.1620391336346;
        Fri, 07 May 2021 05:42:16 -0700 (PDT)
Received: from localhost ([203.87.99.126])
        by smtp.gmail.com with ESMTPSA id y14sm4642676pfm.123.2021.05.07.05.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 05:42:12 -0700 (PDT)
Date:   Fri, 7 May 2021 22:42:09 +1000
From:   Balbir Singh <bsingharora@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 4/6] kvm: Select SCHED_INFO instead of TASK_DELAY_ACCT
Message-ID: <20210507124209.GD4236@balbir-desktop>
References: <20210505105940.190490250@infradead.org>
 <20210505111525.187225172@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505111525.187225172@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05, 2021 at 12:59:44PM +0200, Peter Zijlstra wrote:
> AFAICT KVM only relies on SCHED_INFO. Nothing uses the p->delays data
> that belongs to TASK_DELAY_ACCT.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---

Acked-by: Balbir Singh <bsingharora@gmail.com>
