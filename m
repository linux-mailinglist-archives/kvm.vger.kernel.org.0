Return-Path: <kvm+bounces-5658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B0A782464C
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 17:33:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E3E01C22326
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 16:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 432792574B;
	Thu,  4 Jan 2024 16:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TFZCiWFR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FBD24B59
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 16:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704385963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=akWgTmFa47rUgoDK+eCBTLMBxssII8Qcvv2CCCWck0g=;
	b=TFZCiWFREfR/dKvowRqAxIBuLvnttqjhVzkqOSYvhueuHFRGfhmmdkXpyZKmE+R4soobSf
	WkXE2j1JT+BrF4yuxHSoakXhJeucftiZP8P5SYkR2/LYso/QrE8cRVeneT+iXKUxGFwzau
	jsM9yOHhg+mSk2Lm0KR9BGW7N39odko=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-xTJVl1_DNb6oUc7HRMNp3w-1; Thu, 04 Jan 2024 11:32:41 -0500
X-MC-Unique: xTJVl1_DNb6oUc7HRMNp3w-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-556c60c7eb8so288905a12.0
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 08:32:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704385961; x=1704990761;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=akWgTmFa47rUgoDK+eCBTLMBxssII8Qcvv2CCCWck0g=;
        b=tC0WAxXOPprJAIp/3dhqWIbFM7CeMnuCXYqmVLAggQmenQp1zhPIlyPivgJ4TFRe/9
         dp8IA0FxQtGE6WR/jeTmwjvmN+8SHQC3gXz3ucQTrw5bflQrF4Hcx6jzzWappQ272BWe
         vj3Jw8hY3DkpVeasCytlQYaGolDh9X3v1am45TwCGXTY3NvnuGSTv7V5ZWP/P5s4j5m/
         ghROMulicac0Pz5GLbYFX33ZLM2IplS9+RLXxlnJbp2MTyMXqnujNiyWwyR66U6uJhvt
         s70Yyl1i/SBrhl+U+i9t0912qIV4t+AVbGDLdSNNlAoNue+N6DeBATM1P4Ue7eHVY5+5
         g6Qw==
X-Gm-Message-State: AOJu0Yz2V2rYAaGNMcDmN+UaHtNdD3q4nlIkVVZiNC2N3DqDWwbcZPKl
	NAqfmGNoXU3w784hcLriSr4vTMwzlzH8BjHYNM4c8S55fDDmxZhVESsfpzy3RK0tjb7i56Ozfo9
	YTZeLpdXrcRMrOklg2RmJ
X-Received: by 2002:a50:9b41:0:b0:555:beee:3107 with SMTP id a1-20020a509b41000000b00555beee3107mr643813edj.54.1704385960862;
        Thu, 04 Jan 2024 08:32:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGkU3VZtlbN/tQ5N+t31BDoSe635YfcI99gHwRMBuflYlar3qJChwlxHQkPU1QvyoHUrRjhwQ==
X-Received: by 2002:a50:9b41:0:b0:555:beee:3107 with SMTP id a1-20020a509b41000000b00555beee3107mr643804edj.54.1704385960573;
        Thu, 04 Jan 2024 08:32:40 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id ev14-20020a056402540e00b00556e497cc96sm1967009edb.84.2024.01.04.08.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jan 2024 08:32:39 -0800 (PST)
Message-ID: <b327b546-4a5f-462d-baeb-804a33bd3f6a@redhat.com>
Date: Thu, 4 Jan 2024 17:32:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] Guest OSes die simultaneously (bisected)
To: paulmck@kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Like Xu
 <like.xu@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
 Kan Liang <kan.liang@linux.intel.com>, Luwei Kang <luwei.kang@intel.com>,
 Peter Zijlstra <peterz@infradead.org>, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Breno Leitao <leitao@debian.org>, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>
References: <3d8f5987-e09c-4dd2-a9c0-8ba22c9e948a@paulmck-laptop>
 <88f49775-2b56-48cc-81b8-651a940b7d6b@paulmck-laptop>
 <ZZX6pkHnZP777DVi@google.com>
 <77d7a3e3-f35e-4507-82c2-488405b25fa4@paulmck-laptop>
 <c6d5dd6e-2dec-423c-af39-213f17b1a9db@paulmck-laptop>
 <CABgObfYG-ZwiRiFeGbAgctLfj7+PSmgauN9RwGMvZRfxvmD_XQ@mail.gmail.com>
 <b2775ea5-20c9-4dff-b4b1-bbb212065a22@paulmck-laptop>
Content-Language: en-US
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <b2775ea5-20c9-4dff-b4b1-bbb212065a22@paulmck-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/4/24 17:06, Paul E. McKenney wrote:
> Although I am happy to have been able to locate the commit (and even
> happier that Sean spotted the problem and that you quickly pushed the
> fix to mainline!), chasing this consumed a lot of time and systems over
> an embarrassingly large number of months.  As in I first spotted this
> bug in late July.  Despite a number of increasingly complex attempts,
> bisection became feasible only after the buggy commit was backported to
> our internal v5.19 code base.  🙁

Yes, this strikes two sore points.

One is that I have also experienced being able to bisect only with a 
somewhat more linear history (namely the CentOS Stream 9 aka c9s 
frankenkernel [1]) and not with upstream.  Even if the c9s kernel is not 
a fully linear set of commits, there's some benefit from merge commits 
that consist of slightly more curated set of patches, where each merge 
commit includes both new features and bugfixes.  Unfortunately, whether 
you'll be able to do this with the c9s kernel depends a lot on the 
subsystems involved and on the bug.  Both are factors that may or may 
not be known in advance.

The other, of course, is testing.  The KVM selftests infrastructure is 
meant for this kind of white box problem, but the space of tests that 
can be written is so large, that there's always too few tests.  It 
shines when you have a clear bisection but an unclear fix (in the past I 
have had cases where spending two days to write a test led me to writing 
a fix in thirty minutes), but boosting the reproducibility is always a 
good thing.

> And please understand that I am not casting shade on those who wrote,
> reviewed, and committed that buggy commit.  As in I freely confess that
> I had to stare at Sean's fix for a few minutes before I figured out what
> was going on.

Oh don't worry about that---rather, I am going to cast a shade on those 
that did not review the commit, namely me.  I am somewhat obsessed with 
Boolean logic and *probably* I would have caught it, or would have asked 
to split the use of designated initializers to a separate patch.  Any of 
the two could, at least potentially, have saved you quite some time.

> Instead, the point I am trying to make is that carefully
> constructed tests can serve as tireless and accurate code reviewers.
> This won't ever replace actual code review, but my experience indicates
> that it will help find more bugs more quickly and more easily.

TBH this (conflict between virtual addresses on the host and the guest 
leading to corruption of the guest) is probably not the kind of 
adversarial test that one would have written or suggested right off the 
bat.  But it should be written now indeed.

Paolo

[1] 
https://www.theregister.com/2023/06/30/enterprise_distro_feature_devconf/


