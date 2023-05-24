Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E608D7101C2
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 01:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbjEXXiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 19:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbjEXXh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 19:37:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E2312B
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 16:37:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba2b9ecfadaso3276893276.2
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 16:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684971478; x=1687563478;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lRKixmx29kHFhmvvJtxO+P8WwyZKKKL0TswHVA62TTg=;
        b=HMo3PsEOlHbDpwSZo0W0ifCAM/bCFfT8Q/TFc7+4n21mLX2IUue9LWbu7kskzqalXN
         fE3eh/8kVp/0ELn0rrU9i/H6sLJQnH1J1pYrACjgXeCx2+QOFsnfqtE+wN3ysVvPf0AI
         hnT7lUpssSKfGXfCMwTHe6JZRhLGVe6/aZ8OjciiICs6mE7HxHVC5ARci7xo+m3xsxvb
         M0+RGFf+7OTII9UaXoXg674A5hsDf7ab7RRulxbeuTpAFT+xsuFTQ4XuVhRXstqOK+vu
         C5K25wQgopGGnTc2MVmSoYU8QNJC2Vt+WBocRPjWNLHblchGKpkYNc6qRnCqv/x/tF1P
         3hlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684971478; x=1687563478;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lRKixmx29kHFhmvvJtxO+P8WwyZKKKL0TswHVA62TTg=;
        b=f/EUkmQOULS1lP85exzuqAn45+HmBwt1UDhZ7ves12xsAOEpy0st97R+ArceAJPNhx
         QM5dAWhtBJo13b+AQ7KnmM+Wv28TLjMjsry/q4v77iz8W5FNaFZ7j1CQ5OUhJnvLgi+r
         cPF9/3z3WQKP00CXVVqTF9I+XQGIXdEI6NAFonaV5fw/fEP3IqIIE8Jc4H7yaoN8SADu
         iM7soshhWF4dP9dXV9XZw/a1NoVs7TapMVQEfWIoz2mpEcj201wv5MLAnqiFjXiUZQ9z
         WvMM5Ix8lhUHYEoo/wXjht3tvARQS2eeeGOA1/zFnHK8cNTun9H8D0S5WX2V/26nvmt0
         ES2g==
X-Gm-Message-State: AC+VfDzz2/Ri4c55wIOTCBin1P7mBOPoxTm5m0G75FATZ1q5ltzA2WwK
        hGNsxbgdTqPagZnJHTagBXlgvmZKUa4=
X-Google-Smtp-Source: ACHHUZ5eOeDLR2dzzroB4RdLP7S27NoHuH6+uqmnsv4YXlugQiLB2yhHbZMsS1oBkOMP/bXtOhbtuhJWN/Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1024:b0:ba8:6422:7fc with SMTP id
 x4-20020a056902102400b00ba8642207fcmr964818ybt.7.1684971477866; Wed, 24 May
 2023 16:37:57 -0700 (PDT)
Date:   Wed, 24 May 2023 16:37:56 -0700
In-Reply-To: <f4ef3b07-d2f2-5cfc-6783-49e9b6be7a95@gmail.com>
Mime-Version: 1.0
References: <20230410105056.60973-1-likexu@tencent.com> <20230410105056.60973-6-likexu@tencent.com>
 <CALMp9eTLvJ6GW1mfgjO7CL7tW-79asykyz9=Fb=FfT74VRkDVA@mail.gmail.com>
 <9a7d5814-9eb1-d7af-7968-a6e3ebb90248@gmail.com> <CALMp9eR6DwY0EjAb1hcV9XGWQizN6R0dXtLaC4NXDgtCqv5cTA@mail.gmail.com>
 <81bbb700-9346-3d0d-ab86-6e684b185772@gmail.com> <CALMp9eSKnE8+jMpp0KzBRC7NDjT+S2cRz9CcBNDKB7JCU8dmTg@mail.gmail.com>
 <f4ef3b07-d2f2-5cfc-6783-49e9b6be7a95@gmail.com>
Message-ID: <ZG6f1GYvtZ/Ndf7H@google.com>
Subject: Re: [PATCH V5 05/10] KVM: x86/pmu: Disable vPMU if the minimum num of
 counters isn't met
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 19, 2023, Like Xu wrote:
> Jim, sorry for the late reply.
> 
> On 11/4/2023 10:58 pm, Jim Mattson wrote:
> > > > > Jim, does this help you or could you explain more about your confusion ?
> > > > 
> > > > You say that "fewer than four counters can lead to guest instability
> > > > as software expects four counters to be available." Your solution is
> > > > to disable the PMU, which leaves zero counters available. Zero is less
> > > > than four. Hence, by your claim, disabling the PMU can lead to guest
> > > > instability. I don't see how this is an improvement over one, two, or
> > > > three counters.

KVM can't do the right thing regardless.  I would rather have KVM explicitly tell
userspace via that it can't support a vPMU than to carry on with a bogus and
unexpected setup.

> > Does this actually guarantee that the requisite number of counters are
> > available and will always be available while the guest is running?
> 
> Not 100%, the scheduling of physical counters depends on the host perf scheduler.

Or put differently, the same thing that happens on Intel.  kvm_pmu_cap.num_counters_gp
is the number of counters reported by perf when KVM loads, i.e. barring oddities,
it's the number of counters present in the host.  Most importantly, if perf doesn't
find the expected number of counters, perf will bail and use software only events,
and then clear all of x86_pmu.

In other words, KVM's new sanity *should* be a nop with respect to current
behavior.  If we're concerned about "unnecessarily" hiding the PMU when there are
1-3 counters, I'd be ok with a WARN_ON_ONCE().

Actually, looking more closely, there's unaddressed feedback from v4[*].  Folding
that in, we can enable the sanity check for both Intel and AMD, though that's a
bit of a lie since Intel will be '1'.  But the code looks pretty!

	if (enable_pmu) {
		perf_get_x86_pmu_capability(&kvm_pmu_cap);

		/*
		 * WARN if perf did NOT disable hardware PMU if the number of
		 * architecturally required GP counters aren't present, i.e. if
		 * there are a non-zero number of counters, but fewer than what
		 * is architecturally required.
		 */
		if (!kvm_pmu_cap.num_counters_gp ||
		    WARN_ON_ONCE(kvm_pmu_cap.num_counters_gp < pmu_ops->MIN_NR_GP_COUNTERS))
			enable_pmu = false;
		else if (is_intel && !kvm_pmu_cap.version)
			enable_pmu = false;
	}

	if (!enable_pmu) {
		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
		return;
	}

[*] https://lore.kernel.org/all/ZC9ijgZBaz6p1ecw@google.com
