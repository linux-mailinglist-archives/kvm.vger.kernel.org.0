Return-Path: <kvm+bounces-65255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ED6C1CA21E4
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 02:41:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8AD33302C4E8
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 01:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DB3224468B;
	Thu,  4 Dec 2025 01:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JShxxfsR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D2C136672;
	Thu,  4 Dec 2025 01:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764812435; cv=none; b=VTkG9WVhqytZLdA6V2AOiKTSxlVB6OC+Tu+et/5WTjnoq6Q8CEVRFlCPN3l6omAwKVZcx863SMl6rnDKfVD6BK1NFoGI17wIJM3ttNosc27Uz17o75k382hoGsuCp+AG9Rx/Vgi6ycifak8U8+UmriEznPiUmtJEX4wdOIW72lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764812435; c=relaxed/simple;
	bh=5Lx9qbC/zGM3s7a6W/37VXabwbyKKLBCTbhV98JjIxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hwg3eEmkU+kh2P6c8I/RUBU2RcLMGufC8qRBsqpE1SNfTcdnxvakTb20/tXJsjpoYxRjCCV6/jl4Jd1Bm4VEU1ox91vB3gVd6mFQ0JiAB13oFNmt/Qn0nZKs1kYj2GZQ0Si5mXiEyBXJMMQNSEbH138QJnspQPmJtRireZP7pjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JShxxfsR; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764812433; x=1796348433;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5Lx9qbC/zGM3s7a6W/37VXabwbyKKLBCTbhV98JjIxs=;
  b=JShxxfsRaPh+7kWLckUrQh2vmEG7IwrKwzPdbHSrUsofPKEOYqLH9+MQ
   dfk/kGB1t9IkV4NTrSehcefl2nerTZDoTNrvIBMPtSHe8bpMPTQj1VF2j
   tetb1DlR6Qv5uv/9X3CHOkUkrOSz2fUlJxmxwdPQC0osHRKgAApu2KJc/
   cmg72/+CGSkPdtkZe1SC7gK6vkc5ocXxB2PT4Uc4+6AkQMDGVvIbtB2nA
   RD9AjqKs1loj5EmAGCU6mcFpf1cacl7tn7rW7oDoBEtR7/1OWRUrlOPiY
   2+CrUNXJHig4KExmktzrbVf8Zi+KccVJLLcpHfuVKJ8dM0qmyNSI/9DzB
   g==;
X-CSE-ConnectionGUID: SW3wQ3c4TkGpovqVDlaIWw==
X-CSE-MsgGUID: HLQK3WMIQ+aX1bQUEkpO2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66785261"
X-IronPort-AV: E=Sophos;i="6.20,247,1758610800"; 
   d="scan'208";a="66785261"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 17:40:32 -0800
X-CSE-ConnectionGUID: oPnbOD6qQ1+rTdngMoWc4g==
X-CSE-MsgGUID: XEYEFZCrRp2cMJ7EJuNHDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,247,1758610800"; 
   d="scan'208";a="225796883"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 17:40:32 -0800
Date: Wed, 3 Dec 2025 17:40:26 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: david laight <david.laight@runbox.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>, x86@kernel.org,
	David Kaplan <david.kaplan@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 04/11] x86/bhi: Make clear_bhb_loop() effective on
 newer CPUs
Message-ID: <20251204014026.v5huyriswsqu3jat@desk>
References: <20251119-vmscape-bhb-v4-4-1adad4e69ddc@linux.intel.com>
 <4ed6763b-1a88-4254-b063-be652176d1af@intel.com>
 <e9678dd1-7989-4201-8549-f06f6636274b@suse.com>
 <f7442dc7-be8d-43f8-b307-2004bd149910@intel.com>
 <20251121181632.czfwnfzkkebvgbye@desk>
 <e99150f3-62d4-4155-a323-2d81c1d6d47d@intel.com>
 <20251121212627.6vweba7aehs4cc3h@desk>
 <20251122110558.64455a8d@pumpkin>
 <20251124193126.sdmrhk6dw4jgf5ql@desk>
 <20251125113407.7b241b59@pumpkin>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125113407.7b241b59@pumpkin>

On Tue, Nov 25, 2025 at 11:34:07AM +0000, david laight wrote:
> On Mon, 24 Nov 2025 11:31:26 -0800
> Pawan Gupta <pawan.kumar.gupta@linux.intel.com> wrote:
> 
> > On Sat, Nov 22, 2025 at 11:05:58AM +0000, david laight wrote:
> ...
> > > For subtle reasons one of the mitigations that slows kernel entry caused
> > > a doubling of the execution time of a largely single-threaded task that
> > > spends almost all its time in userspace!
> > > (I thought I'd disabled it at compile time - but the config option
> > > changed underneath me...)  
> > 
> > That is surprising. If its okay, could you please share more details about
> > this application? Or any other way I can reproduce this?
> 
> The 'trigger' program is a multi-threaded program that wakes up every 10ms
> to process RTP and TDM audio data.
> So we have a low RT priority process with one thread per cpu.
> Since they are RT they usually get scheduled on the same cpu as last lime.
> I think this simple program will have the desired effect:
> A main process that does:
> 	syscall(SYS_clock_gettime, CLOCK_MONOTONIC, &start_time);
> 	start_time += 1sec;
> 	for (n = 1; n < num_cpu; n++)
> 		pthread_create(thread_code, start_time);
> 	thread_code(start_time);
> with:
> thread_code(ts)
> {
> 	for (;;) {
> 		ts += 10ms;
> 		syscall(SYS_clock_nanosleep, CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL);
> 		do_work();
> 	}
> 
> So all the threads wake up at exactly the same time every 10ms.
> (You need to use syscall(), don't look at what glibc does.)
> 
> On my system the program wasn't doing anything, so do_work() was empty.
> What matters is whether all the threads end up running at the same time.
> I managed that using pthread_broadcast(), but the clock code above
> ought to be worse (and I've since changed the daemon to work that way
> to avoid all this issues with pthread_broadcast() being sequential
> and threads not running because the target cpu is running an ISR or
> just looping in kernel).
> 
> The process that gets 'hit' is anything cpu bound.
> Even a shell loop (eg while :; do ;: done) but with a counter will do.
> 
> Without the 'trigger' program, it will (mostly) sit on one cpu and the
> clock frequency of that cpu will increase to (say) 3GHz while the other
> all run at 800Mhz.
> But the 'trigger' program runs threads on all the cpu at the same time.
> So the 'hit' program is pre-empted and is later rescheduled on a
> different cpu - running at 800MHz.
> The cpu speed increases, but 10ms later it gets bounced again.

Sorry I haven't tried creating this test yet.

> The real issue is that the cpu speed is associated with the cpu, not
> the process running on it.

So if the 'hit' program gets scheduled to a CPU that is running at 3GHz
then we don't expect a dramatic performance drop? Setting scaling_governor
to "performance" would be an interesting test.

