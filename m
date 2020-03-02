Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579151754EB
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 08:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgCBHzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 02:55:15 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49556 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726905AbgCBHzO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Mar 2020 02:55:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583135713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ubCgVO4Lxh7R5ahjK5aJcWi1Y58omxPT4I8Zt2yPA3o=;
        b=euQiBR/3e898OxOMLDHoxU94XIXDKd3zSrhnRTkubO8F2Mlz3pJKHsFW5iTsEb5CWrtW1M
        7zUCmQSwshdfwR0nmIy4Kzb2mbgfIzD0WBczlv8AHEEb8hvJsqzlY2XQ/Dp4UA7y42+Eu1
        tzNg/L6u4wfUnbwQovpyQ5e6EAah5fI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-JfQN5IcJM92lGbxbYrgWZw-1; Mon, 02 Mar 2020 02:55:12 -0500
X-MC-Unique: JfQN5IcJM92lGbxbYrgWZw-1
Received: by mail-wr1-f71.google.com with SMTP id j32so5394452wre.13
        for <kvm@vger.kernel.org>; Sun, 01 Mar 2020 23:55:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ubCgVO4Lxh7R5ahjK5aJcWi1Y58omxPT4I8Zt2yPA3o=;
        b=kuRF1koau+nzD9Ar06rGvlVIKHiSl2C1aK5jmEHZGX2FotP3hToBIRCNYpvxDBePAE
         K2jm9NWlgStg5GglcqTQylsDTWluht3zK0UOg3n53SThul1WSsEiaIeRjIJelP0iuTsc
         0oE7FDxEqfuIFKlOp6Dd74V1l4olwPnXoPWVo7r6ILxbzp95d744HxGyrM3PcqFMw2Ai
         vGv25rXSZSFuVEJNbecatyTG3PbFotUUa26p3q3dr8+zjSl3EsiQedyeId7YC8m8bL1J
         CVoBbCLIZjD5r5MKCmcq0PRH6s9jV9aEOy2YJ0qrwQyvno8lBVWBIRjN8dWWkqnxt7TB
         z1iA==
X-Gm-Message-State: APjAAAWEbAWIVcYaVDy+016FcX407c99JqtfPK4qxsoZU9QnDb9GaHRu
        UoM06NeDCwaK0lZk+h70Ymrv4X1VEONhphtmp0ekEmSpAq09jZstaj8sr8rH9vCvb5Gs5XCASk7
        xUZbe1AxPf2HN
X-Received: by 2002:adf:ee85:: with SMTP id b5mr20833471wro.34.1583135710883;
        Sun, 01 Mar 2020 23:55:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqzi7AJ0SCNECQ6RasXRLX+a+kCxziJZWsPeuxvUu88m1MymLtvAU6clgSwEuFCyVcKi5xdimg==
X-Received: by 2002:adf:ee85:: with SMTP id b5mr20833430wro.34.1583135710566;
        Sun, 01 Mar 2020 23:55:10 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e1d9:d940:4798:2d81? ([2001:b07:6468:f312:e1d9:d940:4798:2d81])
        by smtp.gmail.com with ESMTPSA id t124sm16043823wmg.13.2020.03.01.23.55.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 23:55:09 -0800 (PST)
Subject: Re: [PATCH] KVM: X86: Fix dereference null cpufreq policy
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
References: <1583133336-7832-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ab51f6c9-a67d-0107-772a-7fe57a2319cf@redhat.com>
Date:   Mon, 2 Mar 2020 08:55:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1583133336-7832-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/03/20 08:15, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> cpufreq policy which is get by cpufreq_cpu_get() can be NULL if it is failure,
> this patch takes care of it.
> 
> Fixes: aaec7c03de (KVM: x86: avoid useless copy of cpufreq policy)
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>

My bad, I checked kobject_put but didn't check that kobj is first in
struct cpufreq_policy.

I think we should do this in cpufreq_cpu_put or, even better, move the
kobject struct first in struct cpufreq_policy.  Rafael, Viresh, any
objection?

Paolo

>  		policy = cpufreq_cpu_get(cpu);
> -		if (policy && policy->cpuinfo.max_freq)
> -			max_tsc_khz = policy->cpuinfo.max_freq;
> +		if (policy) {
> +			if (policy->cpuinfo.max_freq)
> +				max_tsc_khz = policy->cpuinfo.max_freq;
> +			cpufreq_cpu_put(policy);
> +		}

