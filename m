Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1B032C67C
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355217AbhCDA3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449031AbhCCPnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 10:43:21 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068BFC061756;
        Wed,  3 Mar 2021 07:42:41 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id 2so8748800qtw.1;
        Wed, 03 Mar 2021 07:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=474jOip4IgCUoyMxBEribCWEBGxFGSV2OmSthT7tIzw=;
        b=OUl4a0iSBisVMbYesUskXLxC/LPLDhIN0Z0JGTf84f1GApfyQKw6BzripeCpctzhaH
         +D7phCtY7W74P4MAMDNeGvYAAtxOcvPJwTwYjkvlPb+txGb+DC6yw9LLjjgmdNwNaBLz
         T+iX1Z5f0zC8hh/Oq4MPpupIK8Xjsq53GLg0aO8HXh+mEfyHxI0LsJ3V1WVo9UY0nEtk
         0VvSkiHz7Limw2jEyntvTsr41cqWhO/K1Rrur6QvaBoUNUytNHeQY6W0T9h/gLj3Jcox
         6FVq2aCkhvKl8XALF/xuQlmwzULpBOvkkCmMpA80t6IHJ0shgNDsfE82JWH6mpsFuv8Q
         m9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=474jOip4IgCUoyMxBEribCWEBGxFGSV2OmSthT7tIzw=;
        b=ukwpOc9i0N5mS+7ylyxgpOYfaXxO/rwKJ13Svg6w2NF8Fwt2Vy/xNzzARA1sYnEerT
         PSJUvsXPvrlYdG/niAhRAwqAuMmIeiC0ebXxTYfioqOmgZF0MhG9WVP1K0Iwt9b0oDH0
         509IB5yI6fX6lxQWOOiqMb3vQbRSYIJ/XBoQiKdFazpdG4qAikJY78IBeyr84MXSOf/H
         2CHKirbWMAnFT29ThgvzufvXw/RHQwaAj1scahcmmsL2wBCOKANY0GcA490WWDIwxcOm
         2kB1Bx3KrFilW+8DaYltbAcjGvCU3JQX0e+qemmxqMMb3TdX/YqdRsaAq/zNsVqfbMcg
         N+kw==
X-Gm-Message-State: AOAM533C9ie2rtnSwb80uatIZGVb1dr0qrU+ELhC8VWsX8KSpT5dVIDS
        ye78jluj6zJpvpxvHFPhWeUARowUhpF9Xg==
X-Google-Smtp-Source: ABdhPJwLjx1ZIM0IGSCFJl5U/6zxO0tdSMromsGM+JquTtBrWC0ilXZSSOQoOEy0rSaf15B4HSmo9g==
X-Received: by 2002:ac8:754a:: with SMTP id b10mr23629995qtr.251.1614786160009;
        Wed, 03 Mar 2021 07:42:40 -0800 (PST)
Received: from localhost (2603-7000-9602-8233-06d4-c4ff-fe48-9d05.res6.spectrum.com. [2603:7000:9602:8233:6d4:c4ff:fe48:9d05])
        by smtp.gmail.com with ESMTPSA id j24sm5067992qka.67.2021.03.03.07.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 07:42:39 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 3 Mar 2021 10:42:37 -0500
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
Message-ID: <YD+ubbB4Tz0ZlVvp@slm.duckdns.org>
References: <20210302081705.1990283-1-vipinsh@google.com>
 <20210302081705.1990283-2-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302081705.1990283-2-vipinsh@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Tue, Mar 02, 2021 at 12:17:04AM -0800, Vipin Sharma wrote:
> +/**
> + * struct misc_res: Per cgroup per misc type resource
> + * @max: Maximum count of the resource.
> + * @usage: Current usage of the resource.
> + */
> +struct misc_res {
> +	unsigned int max;
> +	atomic_t usage;
> +};

Can we do 64bits so that something which counts memory can use this too?

> +/*
> + * Miscellaneous resources capacity for the entire machine. 0 capacity means
> + * resource is not initialized or not present in the host.
> + *
> + * root_cg.max and capacity are independent of each other. root_cg.max can be
> + * more than the actual capacity. We are using Limits resource distribution
> + * model of cgroup for miscellaneous controller. However, root_cg.current for a
> + * resource will never exceeds the resource capacity.
                                ^
                                typo

> +int misc_cg_set_capacity(enum misc_res_type type, unsigned int capacity)
> +{
> +	if (!valid_type(type))
> +		return -EINVAL;
> +
> +	for (;;) {
> +		int usage;
> +		unsigned int old;
> +
> +		/*
> +		 * Update the capacity while making sure that it's not below
> +		 * the concurrently-changing usage value.
> +		 *
> +		 * The xchg implies two full memory barriers before and after,
> +		 * so the read-swap-read is ordered and ensures coherency with
> +		 * misc_cg_try_charge(): that function modifies the usage
> +		 * before checking the capacity, so if it sees the old
> +		 * capacity, we see the modified usage and retry.
> +		 */
> +		usage = atomic_read(&root_cg.res[type].usage);
> +
> +		if (usage > capacity)
> +			return -EBUSY;

I'd rather go with allowing bringing down capacity below usage so that the
users can set it to a lower value to drain existing usages while denying new
ones. It's not like it's difficult to check the current total usage from the
caller side, so I'm not sure it's very useful to shift the condition check
here.

> +int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
> +		       unsigned int amount)
> +{
...
> +	for (i = cg; i; i = parent_misc(i)) {
> +		res = &i->res[type];
> +
> +		/*
> +		 * The atomic_long_add_return() implies a full memory barrier
> +		 * between incrementing the count and reading the capacity.
> +		 * When racing with misc_cg_set_capacity(), we either see the
> +		 * new capacity or the setter sees the counter has changed and
> +		 * retries.
> +		 */
> +		new_usage = atomic_add_return(amount, &res->usage);
> +		if (new_usage > res->max ||
> +		    new_usage > misc_res_capacity[type]) {
> +			pr_info("cgroup: charge rejected by misc controller for %s resource in ",
> +				misc_res_name[type]);
> +			pr_cont_cgroup_path(i->css.cgroup);
> +			pr_cont("\n");

Should have commented on this in the priv thread but don't print something
on every rejection. This often becomes a nuisance and can make an easy DoS
vector at worst. If you wanna do it, print it once per cgroup or sth like
that.

Otherwise, looks good to me.

Thanks.

-- 
tejun
