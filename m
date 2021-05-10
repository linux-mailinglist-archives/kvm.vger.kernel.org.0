Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4771377E68
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhEJInq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbhEJInq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 04:43:46 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F15C061573;
        Mon, 10 May 2021 01:42:42 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gj14so9349660pjb.5;
        Mon, 10 May 2021 01:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=scJ3NrXTuahw2yzhmVWfK55O/lDzcVrCShB7rGVBtm8=;
        b=PS27FdqMFAg4Onslbjd5Aa5ZmxzmzbIGz1ym+AC/D31HVIdNGujgRDR5GyLhJfgRgj
         jDNZ0f1YPgKVBnFVHGkEm8hCk7GIcP2S6kUrvA6p5XVxt7yWFaH3WEhZALhtXuzVw1mA
         8mmxF2BeAOOH9LtvKpG0bMED8dhGdzHxG4Lyr+oxjeVEDgpYlnBW7c1TeF7uMr5pX5v+
         k5JMDhqCX/AJU/A+PNmFr0zD4noYtLB5+oweW+wvcEnZaYQBM0TBUp4h7IySWZKHEh6d
         NxolZmEVKH+pjxxEoz6iaTM7Gwu2K8z6ELo3yf6fbDvfXi/L7y3mdO278xzDLfxK/9Yu
         dnVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=scJ3NrXTuahw2yzhmVWfK55O/lDzcVrCShB7rGVBtm8=;
        b=h10It0Jx0l/hXaeH8W1K/u+BsyGstDdkaXG/iLKcwO3iLRHJ0Fc0aiAr1YJKMhTG9t
         MjZQqtEvqBQM/qDGnQ6gAF5VT/SHq8wo4hymfMem3zjC2JVPOkvT7RTeCSLRMkSZM4Rg
         5uVmxbYVCVBDU879OPVaFonu8H3256FZDFqTE8BLtf3RM8IbQsRbX0azVX4OsfblqFXP
         YWkkFcdpnIql4Han+viYr4L/vP9lAgSVPXSOhRLvLiBFwLC/KpdpN5feagXgV/npz5WX
         EObi8CtoTD+oRXiiFX6EXGacTJRkw7TTn3qliJfLwKmu5lHOkdr8ve/JRYbUZSC+LK3u
         JjEQ==
X-Gm-Message-State: AOAM531p5SjO4cpi8Q9MOnRy8+NHbCjNTkJPkitVaW/avs6dGG8v43Ag
        Z+3Jj4zDuANWilm2OblGpmo=
X-Google-Smtp-Source: ABdhPJyMQKlO5I8qVaoBnwoIE+yxgQz2GSn7SF+EIHLp1k/jtff5dNN0fmjDj6iAzEKDTKyRIVn2sA==
X-Received: by 2002:a17:90b:11cf:: with SMTP id gv15mr26761960pjb.178.1620636161472;
        Mon, 10 May 2021 01:42:41 -0700 (PDT)
Received: from localhost ([203.87.99.126])
        by smtp.gmail.com with ESMTPSA id h9sm10786984pfv.14.2021.05.10.01.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 01:42:40 -0700 (PDT)
Date:   Mon, 10 May 2021 18:42:36 +1000
From:   Balbir Singh <bsingharora@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 5/6] delayacct: Add static_branch in scheduler hooks
Message-ID: <20210510084236.GE4236@balbir-desktop>
References: <20210505105940.190490250@infradead.org>
 <20210505111525.248028369@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505111525.248028369@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05, 2021 at 12:59:45PM +0200, Peter Zijlstra wrote:
> Cheaper when delayacct is disabled.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---

Acked-by: Balbir Singh <bsingharora@gmail.com> 
