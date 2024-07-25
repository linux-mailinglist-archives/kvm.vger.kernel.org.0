Return-Path: <kvm+bounces-22225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3BCC93C104
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 13:41:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C67B81C20F47
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 11:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0442199248;
	Thu, 25 Jul 2024 11:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CEmMLG4a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D7F16D4C3
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 11:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721907653; cv=none; b=jtPwzcSODSsFUl0WExsYzbEABFMqSEXExMT8EPlsOAR/iFxRByQuxi3I56ohi256XPkr4JI0Pa2Fn/zhnHMfmKkJdmpOAy2qllet6EU9FC8VsVly8y+gD1uIrQgpBux7ST+iqwzKs4lffSmrQwN2cI7cn+Bb+oowMh5icWdWU54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721907653; c=relaxed/simple;
	bh=+MUHoDV+o+BAqrEJb2hWev0rKEyLw15W/zcIr7FnVd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TaqxJMISd2/sRswkoux22FdetB3DrTur7NPioKUL5rpOfvfRJ28FKEaP7abCXyyhUtwFJ+KOiy/tb9SE4rjvNyVxGfJrQRrR/kOc2Cd6n4oUtmVVgcYCVIqumuJazXKLz2sccXKFsZYFxDCykRslQtacs3c8W45dUTZbQc+W4Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CEmMLG4a; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721907651; x=1753443651;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+MUHoDV+o+BAqrEJb2hWev0rKEyLw15W/zcIr7FnVd4=;
  b=CEmMLG4aB5sWdtEtDosJ0l3t6/TzzN6znSH9RSKLC09D1I6yPQKzY3Mi
   ymZM25LZSofvzy0izbxfX34EFAbb5mSbUYaBXAzsHlncFhTqpZvg+KfcL
   S52lPpm+mWGcbtsTt91poRWMXohVEeYx1w9c8xG/S9iaIKI2Km5mNZbJD
   QuUiRJPdH3Yl/l6QXeTHFPScD8mQaRc9mA8l/Dsq7lNQDBq1lVAGAwE9x
   vfSglftC1gDNvL7bG3RZW6dE3kW7/VCe6ek90aOARK5AHgm4hz7OYuUFD
   bexkrqgnC3gsWpyVne/AMVbUQBw45sV+VHNHE+p6lF6X5ZHfafyaRhGI6
   g==;
X-CSE-ConnectionGUID: ak4Pf0piRaKuj9vRdbIyCg==
X-CSE-MsgGUID: sYHLM3rrQ2m0rBXp5XuzWQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11143"; a="19512923"
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="19512923"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 04:40:51 -0700
X-CSE-ConnectionGUID: IvbzGUkuRsqjmtEJqj5HHA==
X-CSE-MsgGUID: OUEK940ySL6fN9WTOTAudg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,235,1716274800"; 
   d="scan'208";a="53664396"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa008.jf.intel.com with ESMTP; 25 Jul 2024 04:40:46 -0700
Date: Thu, 25 Jul 2024 19:56:30 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH 2/8] qapi/qom: Introduce smp-cache object
Message-ID: <ZqI9bqQDVUU7liW1@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
 <20240704031603.1744546-3-zhao1.liu@intel.com>
 <87wmld361y.fsf@pond.sub.org>
 <Zp5tBHBoeXZy44ys@intel.com>
 <87h6cfowei.fsf@pond.sub.org>
 <ZqEV8uErCn+QkOw8@intel.com>
 <871q3hua56.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871q3hua56.fsf@pond.sub.org>

Hi Markus,

On Thu, Jul 25, 2024 at 10:51:49AM +0200, Markus Armbruster wrote:

[snip]

> >> What's the use case?  The commit messages don't tell.
> >
> > i386 has the default cache topology model: l1 per core/l2 per core/l3
> > per die.
> >
> > Cache topology affects scheduler performance, e.g., kernel's cluster
> > scheduling.
> >
> > Of course I can hardcode some cache topology model in the specific cpu
> > model that corresponds to the actual hardware, but for -cpu host/max,
> > the default i386 cache topology model has no flexibility, and the
> > host-cpu-cache option doesn't have enough fine-grained control over the
> > cache topology.
> >
> > So I want to provide a way to allow user create more fleasible cache
> > topology. Just like cpu topology.
> 
> 
> So the use case is exposing a configurable cache topology to the guest
> in order to increase performance.  Performance can increase when the
> configured virtual topology is closer to the physical topology than a
> default topology would be.  This can be the case with CPU host or max.
> 
> Correct?

Yes! That's x86 use case. Jonathan also helped me explain his ARM use case.

> >> Why does that use case make no sense without SMP?
> >
> > As the example I mentioned, for Intel hyrbid architecture, P cores has
> > l2 per core and E cores has l2 per module. Then either setting the l2
> > topology level as core nor module, can emulate the real case.
> >
> > Even considering the more extreme case of Intel 14th MTL CPU, where
> > some E cores have L3 and some don't even have L3. As well as the last
> > time you and Daniel mentioned that in the future we could consider
> > covering more cache properties such as cache size. But the l3 size can
> > be different in the same system, like AMD's x3D technology. So
> > generally configuring properties for @name in a list can't take into
> > account the differences of heterogeneous caches with the same @name.
> >
> > Hope my poor english explains the problem well. :-)
> 
> I think I understand why you want to configure caches.  My question was
> about the connection to SMP.
> 
> Say we run a guest with a single core, no SMP.  Could configuring caches
> still be useful then?

No, for this case the CPU topology (of x86) would be 1 core per module, 1
module per die, 1 die per socket.

Then this core actually owns the l1/l2/l3.

> >> Can the same @name occur multiple times?  Documentation doesn't tell.
> >> If yes, what does that mean?
> >
> > Yes, this means the later one will override the previous one with the same
> > name.
> 
> Needs documenting.
> 
> If you make it an error, you don't have to document it :)

OK!

> >> Say we later add value "l1" for unified level 1 cache.  Would "l1" then
> >> conflict with "l1d" and "l1u"?
> >
> > Yes, we should check in smp/machine code and ban l1 and l1i/l1d at the
> > same time. This check I suppose is easy to add.
> >
> >> May @topo be "invalid"?  Documentation doesn't tell.  If yes, what does
> >> that mean?
> >
> > Yes, just follow the intel's spec, invalid means the current topology
> > information is invalid, which is used to encode x86 CPUIDs. So when I
> > move this level to qapi, I just keeped this. Otherwise, I need to
> > re-implement the i386 specific invalid level.
> 
> I'm afraid I don't understand what is supposed to happen when I tell
> QEMU to make a cache's topology invalid.

Currently this series doesn't allow users to set invalid, if they do, QEMU
reports an error.

So this invalid is just for QEMU internal use. Do you think it's okay?

[snip]

> > Ah, I also considerred this. I didn't use "type" because people usually
> > uses cache type to indicate INSTRUCTION/DATA/UNIFIED and cache level to
> > indicate LEVEL 1/LEVEL 2/LEVEL 3. The enumeration here is a combination of
> > type+level. So I think it's better to avoid the type term.
> 
> SmpCacheLevelAndType is quite a mouthful.

Better name! Thanks!

Regards,
Zhao


