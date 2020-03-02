Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 025F7175543
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 09:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgCBIMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 03:12:13 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40345 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgCBIMM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 03:12:12 -0500
Received: by mail-pf1-f196.google.com with SMTP id l184so2589580pfl.7
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 00:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uiixe7VTNTZjkUXMFLMDS3Y2pxtxz+Vh1/ihMtzRMVI=;
        b=dy70itIEAmsCXfVzSU650FzvkKJIOE5y7NgZ20qW+FcP3TMQoXjNc4LKo1uoaGAjOG
         XQr00jxsE1FYlOikWvxQ+JdGKnZsY6Oe8nTptzDegixpcrCTQt8JVdZgWo1M4nIjvOm/
         1M5sNFKs5l2TFEc3D3vzGRFgXBCapHNzI4mRLN/rQHmOgTIDXx6rTxuOvhu3DE2ujvuQ
         5mMjG9xWRNFfo1NPFFelDNebQUJLc1TcDljcE+Cb7VbwsesYfMzipP1IszHEsj0WPYNo
         25FfPMb4quuCAB2u2oU8eDPLyyqjkZUopZZ3bu21vrad2b9H1+/4odT0geHvtywDaoxT
         CfRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uiixe7VTNTZjkUXMFLMDS3Y2pxtxz+Vh1/ihMtzRMVI=;
        b=LTDOr9+7ZPnWaiIGpi4udUSWB5fljg1qjJeBh3/EoGcsCzoLKdXr0gJZ5mKogOi4d9
         8IQT1EMoSJUNTMf34OpzE+QjWpyfFHxXE7EuqnKpCxg9oayXMmlPQGekfVZ1D4qGmWpH
         BG4Hp5Fj6aVVrMbijn7a8gSUFm6fKfUXPlq7obyn9XiVJRiEWJKMr0YXQCfIYd3NS60G
         GrPvm/S/Y9kMAbtw+OQHz8QflkVzQ9HIfWvFPv2h9V4droIxJXaZrbG9usfIKJU3yPHv
         xnYtxZBHJwnlvhNIhZ4/BDGVA7XblTk2gA0zOV3fMGUqq0p2FhmrVgBtExOvC6oAnqJ0
         0i1Q==
X-Gm-Message-State: APjAAAVP6gnK+eIjQpxA4e11rN5KJNErKh+HTv9fodChp0lAvOiIsqPY
        Yee9zyPhVMBWMKHpDR5+nhRt1g==
X-Google-Smtp-Source: APXvYqwPqXg9y4z1RZRMwnewbFTvr4F0/qjs0khbEDYRPehQH4P/51Sz/t9mRLOPFtgea4hWxFraaA==
X-Received: by 2002:a63:4555:: with SMTP id u21mr18083511pgk.66.1583136730489;
        Mon, 02 Mar 2020 00:12:10 -0800 (PST)
Received: from localhost ([122.167.24.230])
        by smtp.gmail.com with ESMTPSA id x4sm15178437pgi.76.2020.03.02.00.12.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 00:12:09 -0800 (PST)
Date:   Mon, 2 Mar 2020 13:42:07 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH] KVM: X86: Fix dereference null cpufreq policy
Message-ID: <20200302081207.3kogqwxbkujqgc7z@vireshk-i7>
References: <1583133336-7832-1-git-send-email-wanpengli@tencent.com>
 <ab51f6c9-a67d-0107-772a-7fe57a2319cf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab51f6c9-a67d-0107-772a-7fe57a2319cf@redhat.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02-03-20, 08:55, Paolo Bonzini wrote:
> On 02/03/20 08:15, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> > 
> > cpufreq policy which is get by cpufreq_cpu_get() can be NULL if it is failure,
> > this patch takes care of it.
> > 
> > Fixes: aaec7c03de (KVM: x86: avoid useless copy of cpufreq policy)
> > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> 
> My bad, I checked kobject_put but didn't check that kobj is first in
> struct cpufreq_policy.
> 
> I think we should do this in cpufreq_cpu_put or, even better, move the
> kobject struct first in struct cpufreq_policy.  Rafael, Viresh, any
> objection?
> 
> Paolo
> 
> >  		policy = cpufreq_cpu_get(cpu);
> > -		if (policy && policy->cpuinfo.max_freq)
> > -			max_tsc_khz = policy->cpuinfo.max_freq;
> > +		if (policy) {
> > +			if (policy->cpuinfo.max_freq)
> > +				max_tsc_khz = policy->cpuinfo.max_freq;
> > +			cpufreq_cpu_put(policy);
> > +		}

I think this change makes sense and I am not sure why should we even
try to support cpufreq_cpu_put(NULL).

-- 
viresh
