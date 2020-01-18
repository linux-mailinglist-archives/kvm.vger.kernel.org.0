Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7765214152A
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 01:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730377AbgARAUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 19:20:43 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36946 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730260AbgARAUm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 19:20:42 -0500
Received: by mail-pf1-f195.google.com with SMTP id p14so12684512pfn.4
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2020 16:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m3h/W8lqDdFKwEHCrbyJzrLdFQM/pJ9sVRXglt6YDYQ=;
        b=kvr0v0s1kNxe8wi0/pZb2h5wnq8SNLnkb6pHHE90D/pT9+LMi7xFKZOFVcp9HfU4xr
         0iyb1rVKPA58+lSavwCtSXLh1Tie9qVFOZNI3Oc5eWtRn5IREzOpoZB3yNXTq1XQBHX5
         L0IYp+Y1pBOVLQV5nL20l9mICwVllcudxTPZhF+DqN8yy09kPIWNt5IxI3j8fGJafPQj
         5Kt+AsZrGSLosoOKTi0QKgVMJOQqALaO5HY0zLv1kEZgoghU/646OWZHsC7QL9ABGIhO
         Gj5qCfypClRW9OlR6pnwut3O5PB2oVWLZXKOvNSU2v90xtMUqQk2980cjqJ2x7wEvzF8
         Cjvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=m3h/W8lqDdFKwEHCrbyJzrLdFQM/pJ9sVRXglt6YDYQ=;
        b=s3yWcvyQYDTRWxF4WAKABaudfKe5aCWv2QVCAaqHfJoEC7RdBYdQyYLBaKfcQgKLw7
         EpEjOOqhgZW1QoU8ejuc+ITSyN5qz0EkZb8f/HoRTva50nZzxUPexBUEo7HI5Y4KTcvj
         1Wqv+tklagwr6qK9EUeV8I+ZsJEwmT6r7USYMmR3ZWCsPTYdAMC0E/q6rbehun4HGu3H
         lROBC8Kps1zEz3+i5SobaU8zZ+tk/sRL49cqEcT09R3K8X90YulW0don00HnChQYm9J3
         168/JwQVxY3fWJZlE2RUQOy9HJJVCF3CGrnX3Q+PgPsjmYPp/i4+Q5aU6HectQflRK2j
         C29Q==
X-Gm-Message-State: APjAAAXDmvawRNVfM9UEiLsQN5uFfE4vHmbGpNqY6dGedk3CVqrgoam9
        FfB4RtjSZ2dm/yoKG3/FEzvgjQ==
X-Google-Smtp-Source: APXvYqyqjjNrpJUOB0pv/AYm/1R6oj2fdn+BMxZwXjB7orWA/iUam5Ak7XcF/wyM7f4b/qi0VBNLhg==
X-Received: by 2002:a63:fa50:: with SMTP id g16mr48053954pgk.202.1579306841722;
        Fri, 17 Jan 2020 16:20:41 -0800 (PST)
Received: from google.com ([2620:15c:100:202:d78:d09d:ec00:5fa7])
        by smtp.gmail.com with ESMTPSA id x33sm29390830pga.86.2020.01.17.16.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 16:20:40 -0800 (PST)
Date:   Fri, 17 Jan 2020 16:20:36 -0800
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH] KVM: nVMX: WARN on failure to set IA32_PERF_GLOBAL_CTRL
Message-ID: <20200118002036.GA249180@google.com>
References: <20191214003358.169496-1-oupton@google.com>
 <20191217232229.GH11771@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217232229.GH11771@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 03:22:29PM -0800, Sean Christopherson wrote:
> On Fri, Dec 13, 2019 at 04:33:58PM -0800, Oliver Upton wrote:
> > Writes to MSR_CORE_PERF_GLOBAL_CONTROL should never fail if the VM-exit
> > and VM-entry controls are exposed to L1. Promote the checks to perform a
> > full WARN if kvm_set_msr() fails and remove the now unused macro
> > SET_MSR_OR_WARN().
> > 
> > Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> 
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

Ping :)
