Return-Path: <kvm+bounces-18735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A81858FAD57
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 10:18:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B99A1F226C1
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 08:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F8B31422C3;
	Tue,  4 Jun 2024 08:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LsNhnrJb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA70F139CFF
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 08:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717489112; cv=none; b=IFORB0Ek60fBGwpZ3oVrYh3gaMf3TLBPM8CI8waR3ro0BRMlRmeV1IvNKSpopE2BP4mVZk92BCZlDLAZBxF3ybU+s5q8kb2bRfwP/Pemv3dtLroQ9l4eiEjhUvNwUnjMX0ASCk+jkKWJp0BzK48a7cpkpZeTX2DkjKnskMt213A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717489112; c=relaxed/simple;
	bh=T6qZEH63FFuFYtelDyLGAv9Vpeeu3+M490fJp4SljgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ap2l+p9CTSdCfoHHyOtkwC+bbtDxuwf4rFdF8eWoiI4TtvdVEvfS9t70OCCcn4DZ32EKB31JUu7L1lU7NzKeKNXop+PwDlJaScyeMlGAMhC5hUsRdLTKmMTykQ72mHlUpkB8pGxO3k5Q1ziYJsHkE6UZ4gX29HXjggE2eo33+1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LsNhnrJb; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717489110; x=1749025110;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T6qZEH63FFuFYtelDyLGAv9Vpeeu3+M490fJp4SljgU=;
  b=LsNhnrJb+eYm3VJmPC09GugQtpQMRRoCNgkxhcrws2F66H2jrmC91ixm
   Lcd8+ekilDBfhX5LlVJGsloTpKv79D2qIiXALXtkXAUA1n+C52HWNypOO
   XbtcBh0OF6jk/MZZVmg7RaOYTfcGe6Vb6trikBh3Kf1LuvmYCy3adow0R
   UQcCw312e1mRr2udxllP8VQKvhmg/lPWx01SCrsIo8r7rSHrDH1Uml458
   cuJPZtIaT4ai3+jFs1gC2GUjYzpxdqk7XBz+plaqsX6etAmtAyyg8520I
   QMeIolrZxiptj5KiefB6e/f7DhnsYkRCynnjKgclNbjM0aW0yI633qMrJ
   g==;
X-CSE-ConnectionGUID: rXR8ZLNVSDKnpGaaliDs8A==
X-CSE-MsgGUID: 2qdbgjy8QR6rNhePBqYCSg==
X-IronPort-AV: E=McAfee;i="6600,9927,11092"; a="31518820"
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="31518820"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2024 01:18:27 -0700
X-CSE-ConnectionGUID: ZLkK9vr3Qi6T22a7gQdEpw==
X-CSE-MsgGUID: WIUIwbV2QBChE1vi6Mj3Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="37027956"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa007.fm.intel.com with ESMTP; 04 Jun 2024 01:18:22 -0700
Date: Tue, 4 Jun 2024 16:33:48 +0800
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
Subject: Re: [RFC v2 1/7] hw/core: Make CPU topology enumeration arch-agnostic
Message-ID: <Zl7RbLrYUN0cg+t4@intel.com>
References: <20240530101539.768484-1-zhao1.liu@intel.com>
 <20240530101539.768484-2-zhao1.liu@intel.com>
 <87plsyfc1r.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87plsyfc1r.fsf@pond.sub.org>

Hi Markus,

On Mon, Jun 03, 2024 at 02:25:36PM +0200, Markus Armbruster wrote:
> Date: Mon, 03 Jun 2024 14:25:36 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [RFC v2 1/7] hw/core: Make CPU topology enumeration
>  arch-agnostic
> 
> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > Cache topology needs to be defined based on CPU topology levels. Thus,
> > define CPU topology enumeration in qapi/machine.json to make it generic
> > for all architectures.
> >
> > To match the general topology naming style, rename CPU_TOPO_LEVEL_SMT
> > and CPU_TOPO_LEVEL_PACKAGE to CPU_TOPO_LEVEL_THREAD and
> > CPU_TOPO_LEVEL_SOCKET.
> >
> > Also, enumerate additional topology levels for non-i386 arches, and add
> > helpers for topology enumeration and string conversion.
> >
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> 
> [...]
> 
> > diff --git a/qapi/machine.json b/qapi/machine.json
> > index bce6e1bbc412..7ac5a05bb9c9 100644
> > --- a/qapi/machine.json
> > +++ b/qapi/machine.json
> > @@ -1667,6 +1667,46 @@
> >       '*reboot-timeout': 'int',
> >       '*strict': 'bool' } }
> >  
> > +##
> > +# @CPUTopoLevel:
> 
> I understand you're moving existing enum CPUTopoLevel into the QAPI
> schema.  I think the idiomatic QAPI name would be CpuTopologyLevel.
> Would you be willing to rename it, or would that be too much churn?

Sure, I'll rename it as you suggested.

> > +#
> > +# An enumeration of CPU topology levels.
> > +#
> > +# @invalid: Invalid topology level, used as a placeholder.
> > +#
> > +# @thread: thread level, which would also be called SMT level or logical
> > +#     processor level. The @threads option in -smp is used to configure
> > +#     the topology of this level.
> > +#
> > +# @core: core level. The @cores option in -smp is used to configure the
> > +#     topology of this level.
> > +#
> > +# @module: module level. The @modules option in -smp is used to
> > +#     configure the topology of this level.
> > +#
> > +# @cluster: cluster level. The @clusters option in -smp is used to
> > +#     configure the topology of this level.
> > +#
> > +# @die: die level. The @dies option in -smp is used to configure the
> > +#     topology of this level.
> > +#
> > +# @socket: socket level, which would also be called package level. The
> > +#     @sockets option in -smp is used to configure the topology of this
> > +#     level.
> > +#
> > +# @book: book level. The @books option in -smp is used to configure the
> > +#     topology of this level.
> > +#
> > +# @drawer: drawer level. The @drawers option in -smp is used to
> > +#     configure the topology of this level.
> 
> docs/devel/qapi-code-gen.rst section Documentation markup:
> 
>     For legibility, wrap text paragraphs so every line is at most 70
>     characters long.
> 
>     Separate sentences with two spaces.

Thank you for pointing this.

About separating sentences, is this what I should be doing?

# @drawer: drawer level. The @drawers option in -smp is used to
#  configure the topology of this level.


Thanks,
Zhao


