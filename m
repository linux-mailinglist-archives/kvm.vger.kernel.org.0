Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C9E3256BB
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 20:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbhBYTcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 14:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234796AbhBYT3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 14:29:34 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F86FC061788
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 11:28:54 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id l7so76612pfd.3
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 11:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=eg2T+GAall58PHie1pc/1M6D3b3c5ZA2F5gwbRjHzXI=;
        b=XAH5DbX0NmfVOZxrBQ+uQ636JLbgHKyf211mfe0oio2b5HL4OwBHllfrayb5aPqFAn
         nWNdqykSp2SPQx8Gx5x6frsT1jZ7KF1iNTaqjfzHL6P/RXcS9j0n0kFaXHlVnybSjAmr
         T1sA3Q5mtuCtDlkBw7zl9DfLWWrlAGvpl4t6ID1wDcTcdcLipJRr/R+Yj5j6iqpt21sw
         zKLoW2cRYxfCfjqcqsZD9GL+j3uWv5aUfKAsQ8t9kBvHkV5GMMwUeXIPqFKbR0oElrRx
         m9ja9x2qv+DAe51QHMjWLI/k1N14adZPcUKSnBErPA5m/lSfEBsTmqVhKa5otSB0NDb0
         fhQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=eg2T+GAall58PHie1pc/1M6D3b3c5ZA2F5gwbRjHzXI=;
        b=YJ/PWzMemv5TfF59NzJPuG1yJ0fPQwppyIj4Yq0fyBlAKJyTLtw07NiBnHmbJXiTZF
         JD1rprN15Fwf5fBUOA3aofJorh9OoZKxsJ9R44+PPxtQ8c/Xm11vWHSO9k84mCLtrYaP
         snNPDuy1WHjYRwNDGUHRfJ+Pd0I4eDHJuKuFKDIu/Qk6xQUoqgR+JL/TjFQW/AclY7MH
         O6UxA4qjJK3W71AnHJ89qv2Pr6FnWUwsqulZwx7iR/j35bBlkn7ZKU1w1c7yWXSYHJJ9
         MNL8ocWKCmfIycnxHaf2rguzGbGLwRqvC3kStV76XJQpNlUdaaQsPvgg7Az+Qv/i/c7S
         RUNA==
X-Gm-Message-State: AOAM530rMr6XZxkTwUHzBY3tfYJ/LGbwAnNSfPeU2yrORDwYr94OQe9D
        evjfCCqS8XCtWWbF761ZxeuLEw==
X-Google-Smtp-Source: ABdhPJyXQztSjriJUwr+YzP+mFraH1PK/i2Qee5tybeVsmvbD3+TQKAmth+5mPNoDOkUQyEtlsqkJg==
X-Received: by 2002:a63:6705:: with SMTP id b5mr4351009pgc.165.1614281333590;
        Thu, 25 Feb 2021 11:28:53 -0800 (PST)
Received: from google.com ([2620:0:1008:10:9474:84b:e7ae:d5fc])
        by smtp.gmail.com with ESMTPSA id gj24sm6736615pjb.4.2021.02.25.11.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 11:28:52 -0800 (PST)
Date:   Thu, 25 Feb 2021 11:28:46 -0800
From:   Vipin Sharma <vipinsh@google.com>
To:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc:     thomas.lendacky@amd.com, tj@kernel.org, brijesh.singh@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com,
        hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, rientjes@google.com, dionnaglaze@google.com,
        kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] cgroup: sev: Add misc cgroup controller
Message-ID: <YDf6bpSxX6I5xdqZ@google.com>
References: <20210218195549.1696769-1-vipinsh@google.com>
 <20210218195549.1696769-2-vipinsh@google.com>
 <YDVIdycgk8XL0Zgx@blackbook>
 <YDcuQFMbe5MaatBe@google.com>
 <YDdzcfLxsCeYxLNG@blackbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YDdzcfLxsCeYxLNG@blackbook>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 25, 2021 at 10:52:49AM +0100, Michal Koutný wrote:
> On Wed, Feb 24, 2021 at 08:57:36PM -0800, Vipin Sharma <vipinsh@google.com> wrote:
> > This function is meant for hot unplug functionality too.
> Then I'm wondering if the current form is sufficient, i.e. the generic
> controller can hardly implement preemption but possibly it should
> prevent any additional charges of the resource. (Or this can be
> implemented the other subsystem and explained in the
> misc_cg_set_capacity() docs.)

My approach here is that it is the responsibility of the caller to:
1. Check the return value and proceed accordingly.
2. Ideally, let all of the usage be 0 before deactivating this resource
   by setting capacity to 0

But I see your point that it makes sense for this call to always
succeed. I think I can simplify this function now to just have xchg() (for
memory barrier) so that new value is immediately reflected in
misc_cg_try_charge() and no new charges will succeed.

Is the above change good?

> 
> > Just to be on the same page are you talking about adding an events file
> > like in pids?
> Actually, I meant just the kernel log message. As it's the simpler part
> and even pid events have some inconsistencies wrt hierarchical
> reporting.

I see, thanks, I will add some log messages, 

if (new_usage > res->max || new_usage > misc_res_capacity[type)) {
  pr_info("cgroup: charge rejected by misc controller for %s resource in ",
          misc_res_name[type]);
  pr_cont_cgroup_path(i->css.cgroup);
  pr_cont("\n");
  ...
}

Only difference compared to pids will be that here logs will be printed
for every failure.

I was thinking to add more information in the log like what is the current
limits (max and capacity) and what new usage would have been. Will there
be any objection to extra information?

> 
> > However, if I take reference at the first charge and remove reference at
> > last uncharge then I can keep the ref count in correct sync.
> I see now how it works. I still find it a bit complex. What about making
> misc_cg an input parameter and making it the callers responsibility to
> keep a reference? (Perhaps with helpers for the most common case.)

Yeah, that can simplify the misc controller, I will have to add couple of
more helper APIs for callers having simple use cases. I will make this
change.

Thanks
Vipin
