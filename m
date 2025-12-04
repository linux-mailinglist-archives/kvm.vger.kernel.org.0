Return-Path: <kvm+bounces-65304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD50CA5915
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 22:56:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C9B53091CF2
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 21:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D19552EC563;
	Thu,  4 Dec 2025 21:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aegVw1OL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1729025742F;
	Thu,  4 Dec 2025 21:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764885367; cv=none; b=jZkqp7nZV0uwrQ5ICUYqJcx2DjQ+8BJ5KZK2MSWOQro/AsefwyMonAaZllSCLiwxEWi4gmJtipbBVXfwUmdk82an7w+CBgAruJEBJqPFD3q8cMb+nKeEuYoJ//ea7bHkQid7KKy8Mvr83xfuiUcQOZn2JqbqfF2+zg24eqba5Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764885367; c=relaxed/simple;
	bh=iVJpYeZX3MOItli+/aGTjrcrH74T0/oy3f2nKK8xIvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZBwY8p2Lv8bDqs4az6XZR7kbM0VQNZxqqfL0S7DBq/DkTlxrDgu5o/Y9wvTm7HQXNSV3lUva1N8LTd5LuY5PMCPS1trDLCJI2Xp/Zj/MNAFioBmHtccIbM/oiSxyxKswzMMUx59KVkCTX6PE7YVs2MftMryxSz8O0WzKcRaZ64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aegVw1OL; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764885365; x=1796421365;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iVJpYeZX3MOItli+/aGTjrcrH74T0/oy3f2nKK8xIvk=;
  b=aegVw1OLcywX2gEyhLe4ySA/RC/912mh0IYDtPcDWmweTm1IHnrlkRZv
   axUx2m1er6mgq3eWYeS6rfWq9gq3w0c2qBwIHjSX6yJ89bpQ21hq3wN7a
   cg+wsK3FaRiNGGRM4SxsKSeT1lmtH4GyYJCMxcIPuXgWw4DpyUViEtHZj
   nKlnJj4x+8bjPcb1JUN8EsA3z/xQh51EZfuWT6bEHEQ9nQoA1B+DcNhoC
   1rsyTO1U0QkC9wlHjUiYhm5rbPwbb0gD+52XkoqFbH8Ad5oL1ZvfQ6fYo
   eY/x5GoMgt0eDHJWlqTS+rpEX3PhZjnuuYHQ+sVfuPuEwVgo3yVw+ST91
   g==;
X-CSE-ConnectionGUID: i/+lo48MQjGGDZj3P9En0w==
X-CSE-MsgGUID: LBnZSSkpQEG8yYYR3lz0uQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="66810341"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="66810341"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 13:56:04 -0800
X-CSE-ConnectionGUID: yf9ibuwsQvKS3bV5HVJJWg==
X-CSE-MsgGUID: hqG07uTCSnWk7eKIwWfXZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="195131447"
Received: from unknown (HELO windy) ([10.241.226.132])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 13:56:04 -0800
Date: Thu, 4 Dec 2025 13:56:02 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: david laight <david.laight@runbox.com>
Cc: Dave Hansen <dave.hansen@intel.com>, 
	Nikolay Borisov <nik.borisov@suse.com>, x86@kernel.org, David Kaplan <david.kaplan@amd.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>, 
	Tao Zhang <tao1.zhang@intel.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 04/11] x86/bhi: Make clear_bhb_loop() effective on
 newer CPUs
Message-ID: <smt7yrupcypkjsfrtlwp6kznol3mrgrer63plubwfp2hcunoul@yi5rbq5r3w5j>
References: <e9678dd1-7989-4201-8549-f06f6636274b@suse.com>
 <f7442dc7-be8d-43f8-b307-2004bd149910@intel.com>
 <20251121181632.czfwnfzkkebvgbye@desk>
 <e99150f3-62d4-4155-a323-2d81c1d6d47d@intel.com>
 <20251121212627.6vweba7aehs4cc3h@desk>
 <20251122110558.64455a8d@pumpkin>
 <20251124193126.sdmrhk6dw4jgf5ql@desk>
 <20251125113407.7b241b59@pumpkin>
 <20251204014026.v5huyriswsqu3jat@desk>
 <20251204091511.757ea777@pumpkin>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204091511.757ea777@pumpkin>

On Thu, Dec 04, 2025 at 09:15:11AM +0000, david laight wrote:
> On Wed, 3 Dec 2025 17:40:26 -0800
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com> wrote:
> 
> > On Tue, Nov 25, 2025 at 11:34:07AM +0000, david laight wrote:
> > > On Mon, 24 Nov 2025 11:31:26 -0800
> > > Pawan Gupta <pawan.kumar.gupta@linux.intel.com> wrote:
> > >   
> > > > On Sat, Nov 22, 2025 at 11:05:58AM +0000, david laight wrote:  
> > > ...  
> > > > > For subtle reasons one of the mitigations that slows kernel entry caused
> > > > > a doubling of the execution time of a largely single-threaded task that
> > > > > spends almost all its time in userspace!
> > > > > (I thought I'd disabled it at compile time - but the config option
> > > > > changed underneath me...)    
> > > > 
> > > > That is surprising. If its okay, could you please share more details about
> > > > this application? Or any other way I can reproduce this?  
> > > 
> > > The 'trigger' program is a multi-threaded program that wakes up every 10ms
> > > to process RTP and TDM audio data.
> > > So we have a low RT priority process with one thread per cpu.
> > > Since they are RT they usually get scheduled on the same cpu as last lime.
> > > I think this simple program will have the desired effect:
> > > A main process that does:
> > > 	syscall(SYS_clock_gettime, CLOCK_MONOTONIC, &start_time);
> > > 	start_time += 1sec;
> > > 	for (n = 1; n < num_cpu; n++)
> > > 		pthread_create(thread_code, start_time);
> > > 	thread_code(start_time);
> > > with:
> > > thread_code(ts)
> > > {
> > > 	for (;;) {
> > > 		ts += 10ms;
> > > 		syscall(SYS_clock_nanosleep, CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL);
> > > 		do_work();
> > > 	}
> > > 
> > > So all the threads wake up at exactly the same time every 10ms.
> > > (You need to use syscall(), don't look at what glibc does.)
> > > 
> > > On my system the program wasn't doing anything, so do_work() was empty.
> > > What matters is whether all the threads end up running at the same time.
> > > I managed that using pthread_broadcast(), but the clock code above
> > > ought to be worse (and I've since changed the daemon to work that way
> > > to avoid all this issues with pthread_broadcast() being sequential
> > > and threads not running because the target cpu is running an ISR or
> > > just looping in kernel).
> > > 
> > > The process that gets 'hit' is anything cpu bound.
> > > Even a shell loop (eg while :; do ;: done) but with a counter will do.
> > > 
> > > Without the 'trigger' program, it will (mostly) sit on one cpu and the
> > > clock frequency of that cpu will increase to (say) 3GHz while the other
> > > all run at 800Mhz.
> > > But the 'trigger' program runs threads on all the cpu at the same time.
> > > So the 'hit' program is pre-empted and is later rescheduled on a
> > > different cpu - running at 800MHz.
> > > The cpu speed increases, but 10ms later it gets bounced again.  
> > 
> > Sorry I haven't tried creating this test yet.
> > 
> > > The real issue is that the cpu speed is associated with the cpu, not
> > > the process running on it.  
> > 
> > So if the 'hit' program gets scheduled to a CPU that is running at 3GHz
> > then we don't expect a dramatic performance drop? Setting scaling_governor
> > to "performance" would be an interesting test.
> 
> I failed to find a way to lock the cpu frequency (for other testing) on
> that system an i7-7xxx - and the system will start thermally throttling
> if you aren't careful.

i7-7xxx would be Kaby Lake gen, those shouldn't need to deploy BHB clear
mitigation. I am guessing it is the legacy-IBRS mitigation in your case.

What you described looks very similar to the issue fixed by commit:

  aa1567a7e644 ("intel_idle: Add ibrs_off module parameter to force-disable IBRS")

    Commit bf5835bcdb96 ("intel_idle: Disable IBRS during long idle")
    disables IBRS when the cstate is 6 or lower. However, there are
    some use cases where a customer may want to use max_cstate=1 to
    lower latency. Such use cases will suffer from the performance
    degradation caused by the enabling of IBRS in the sibling idle thread.
    Add a "ibrs_off" module parameter to force disable IBRS and the
    CPUIDLE_FLAG_IRQ_ENABLE flag if set.

    In the case of a Skylake server with max_cstate=1, this new ibrs_off
    option will likely increase the IRQ response latency as IRQ will now
    be disabled.

    When running SPECjbb2015 with cstates set to C1 on a Skylake system.

    First test when the kernel is booted with: "intel_idle.ibrs_off":

      max-jOPS = 117828, critical-jOPS = 66047

    Then retest when the kernel is booted without the "intel_idle.ibrs_off"
    added:

      max-jOPS = 116408, critical-jOPS = 58958

    That means booting with "intel_idle.ibrs_off" improves performance by:

      max-jOPS:      +1.2%, which could be considered noise range.
      critical-jOPS: +12%,  which is definitely a solid improvement.

> ISTR that the hardware does most of the work.
> So I'm not sure what difference "performance" makes (and can't remember what
> might be set for that system - could set set anyway.)

> We did have to disable some of the low power states, waking the cpu from those
> just takes far too long.

Seems like you have a workaround in place already.

