Return-Path: <kvm+bounces-29077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA4E9A2386
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 15:20:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2ACF31C26909
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 13:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA831DE2AD;
	Thu, 17 Oct 2024 13:20:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCE31DA619
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 13:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729171223; cv=none; b=ZDBavKuff0Ux3f/Jl4pRtwokfXc3rI7/TgmDiJgc5Qyz4RSVNST4q2M9LlvljtoN2B1nZ0uz7BLM/eT7BVYpLaWY5aEbVSZQuVzCZGfZqaIovqnElI3/fELdm/GN00BNIxO3hiTN4t9fRlD5NhwqwO40Xyejzh2j+XjdllCF9JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729171223; c=relaxed/simple;
	bh=b1F2rAMLKNqC1thl0v7x7eTWsNQogAU/A9ONoHQjZU0=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bWpki7a+kJml8dMpQDp66TRTzPuqGO1w4nrp/xqjqr04Ne/n9TgQjuA6gh/5Nlvm7Dm0DxQP8A9ppRB0biwokxSGSL9e/mxDqkQG+AtwtrNP4li2SWlTSRjosvy/y92LQJU3maxYgSJw/WTnAgxHQBpjnd52+vlIYTZ3Bf7Rk3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XTpLc1979z6FGlY;
	Thu, 17 Oct 2024 21:18:32 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 446BD1400F4;
	Thu, 17 Oct 2024 21:20:16 +0800 (CST)
Received: from localhost (10.126.174.164) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 17 Oct
 2024 15:20:14 +0200
Date: Thu, 17 Oct 2024 14:20:13 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Zhao Liu <zhao1.liu@intel.com>
CC: "Daniel P . =?ISO-8859-1?Q?Berrang=E9?=" <berrange@redhat.com>, "Igor
 Mammedov" <imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Philippe =?ISO-8859-1?Q?Ma?=
 =?ISO-8859-1?Q?thieu-Daud=E9?= <philmd@linaro.org>, Yanan Wang
	<wangyanan55@huawei.com>, "Michael S.Tsirkin " <mst@redhat.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Richard Henderson
	<richard.henderson@linaro.org>, Eric Blake <eblake@redhat.com>, "Markus
 Armbruster" <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Alex
 =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Peter Maydell
	<peter.maydell@linaro.org>, Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>, <qemu-riscv@nongnu.org>, <qemu-arm@nongnu.org>,
	"Zhenyu Wang" <zhenyu.z.wang@intel.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v3 1/7] hw/core: Make CPU topology enumeration
 arch-agnostic
Message-ID: <20241017142013.00006c41@Huawei.com>
In-Reply-To: <20241017095227.00006d85@Huawei.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
	<20241012104429.1048908-2-zhao1.liu@intel.com>
	<20241017095227.00006d85@Huawei.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 frapeml500008.china.huawei.com (7.182.85.71)

RESEND (sorry for noise).
Quotes in email address issue meant the server bounced it.

On Thu, 17 Oct 2024 09:52:27 +0100
Jonathan Cameron <Jonathan.Cameron@Huawei.com> wrote:

> On Sat, 12 Oct 2024 18:44:23 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
> 
> > Cache topology needs to be defined based on CPU topology levels. Thus,
> > define CPU topology enumeration in qapi/machine.json to make it generic
> > for all architectures.
> > 
> > To match the general topology naming style, rename CPU_TOPO_LEVEL_* to
> > CPU_TOPOLOGY_LEVEL_*, and rename SMT and package levels to thread and
> > socket.
> > 
> > Also, enumerate additional topology levels for non-i386 arches, and add
> > a CPU_TOPOLOGY_LEVEL_DEFAULT to help future smp-cache object to work
> > with compatibility requirement of arch-specific cache topology models.
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>  
> LGTM with one incredibly trivial comment inline.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> >  #endif /* HW_I386_TOPOLOGY_H */
> > diff --git a/qapi/machine-common.json b/qapi/machine-common.json
> > index b64e4895cfd7..db3e499fb382 100644
> > --- a/qapi/machine-common.json
> > +++ b/qapi/machine-common.json
> > @@ -5,7 +5,7 @@
> >  # See the COPYING file in the top-level directory.
> >  
> >  ##
> > -# = Machines S390 data types
> > +# = Common machine types
> >  ##
> >  
> >  ##
> > @@ -18,3 +18,47 @@
> >  ##
> >  { 'enum': 'S390CpuEntitlement',
> >    'data': [ 'auto', 'low', 'medium', 'high' ] }
> > +
> > +##
> > +# @CpuTopologyLevel:
> > +#
> > +# An enumeration of CPU topology levels.
> > +#
> > +# @invalid: Invalid topology level.  
> 
> Really trivial but why a capital I on Invalid here but not the
> t of thread below?
> 
> > +#
> > +# @thread: thread level, which would also be called SMT level or
> > +#     logical processor level.  The @threads option in
> > +#     SMPConfiguration is used to configure the topology of this
> > +#     level.  
> 


