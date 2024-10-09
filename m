Return-Path: <kvm+bounces-28163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B302E995F44
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 07:53:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC3511C20F6B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 05:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE94D15F3FF;
	Wed,  9 Oct 2024 05:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Aml/62YK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7622AF1D
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 05:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728453203; cv=none; b=oS0uvuBI1JYVO4xBKjcQgrJciOZB3xie9G+M8VYfXoNoFLgWJ9WEzTx6NZy8+V0BV65dSjszu5eSDamMvZmZi8zVrbxkNy7Y12OeKL1pB4IXoRWtrHKqDPWssbueOaaYay6F/punmBwDpwIMTKskc9lterZh5CTNBq03GQgSVV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728453203; c=relaxed/simple;
	bh=0ilS+TEIzCQiqFlC+TTsmPgQDdJ1qwzqdbAsWGUD5hs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HiIYWwVz7NkR2NHiiivwOjMYgSj2poLy3It/xUxlSe85E21eI1u12bQbhfrXAkfBQOLXYPMcr/F43kUl0qYVgG3OmcGYZ/kx+E34+WHeIZPbWblez1wMSGntPuT4N9X0PHEnyPWN9LSJqPJOJLuWIEQUorlzcW+dZyb5AyVYa4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Aml/62YK; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728453202; x=1759989202;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0ilS+TEIzCQiqFlC+TTsmPgQDdJ1qwzqdbAsWGUD5hs=;
  b=Aml/62YK91dYzLq0DWZoWImffJpLhQdhU+bzsMDtypH/7qa2CEPRcvC0
   Ou84GXaljB2tiagrh4ZPelKQH7fU3mMI04wEAbvjBRxR2+CkRE3jRxSYU
   TUVC+jU63kZLOZTEJ5lYZJwg/ePTYqSWjWJkklk0dDKDvDuZ5O+UDE85B
   8N2dJWT2oNywP3PlE+bM//KUEMqsoLUcU/ie7kfYC5QPp9IaUt2xSdtNz
   RLFS+rd3qTwP5jbVl2KXG+BEzH2lx/CkzdlBielXt6GSfUUBkIN8Cjd9O
   GqB/dm1EPBbTUd936zHi2t703WK9k/+SSgBn7WVK+/oy3DadlywudM9pd
   A==;
X-CSE-ConnectionGUID: qu61ioNERnq6UH6ko86rZQ==
X-CSE-MsgGUID: v/kfhRXbTyimx/oT9o9jwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="27546163"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="27546163"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 22:53:21 -0700
X-CSE-ConnectionGUID: 1uy9UXJzR5WlZmqSMcANiA==
X-CSE-MsgGUID: DtsvWWfiTvid0l0/6LauKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="76449252"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 08 Oct 2024 22:53:15 -0700
Date: Wed, 9 Oct 2024 14:09:26 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Daniel P =?utf-8?B?LiBCZXJyYW5n77+9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Alex =?utf-8?B?QmVubu+/vWU=?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [RFC v2 01/12] qdev: Allow qdev_device_add() to add specific
 category device
Message-ID: <ZwYeFofVARVuL1i6@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
 <20240919061128.769139-2-zhao1.liu@intel.com>
 <20241008101425.00003b90@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008101425.00003b90@Huawei.com>

On Tue, Oct 08, 2024 at 10:14:25AM +0100, Jonathan Cameron wrote:
> Date: Tue, 8 Oct 2024 10:14:25 +0100
> From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
> Subject: Re: [RFC v2 01/12] qdev: Allow qdev_device_add() to add specific
>  category device
> X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
> 
> On Thu, 19 Sep 2024 14:11:17 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
> 
> > Topology devices need to be created and realized before board
> > initialization.
> > 
> > Allow qdev_device_add() to specify category to help create topology
> > devices early.
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> It's not immediately obvious what the category parameter is.
> Can you use DeviceCategory rather than long?

...

> > -DeviceState *qdev_device_add_from_qdict(const QDict *opts,
> > +DeviceState *qdev_device_add_from_qdict(const QDict *opts, long *category,
> >                                          bool from_json, Error **errp)
> >  {
> >      ERRP_GUARD();
> > @@ -655,6 +655,10 @@ DeviceState *qdev_device_add_from_qdict(const QDict *opts,
> >          return NULL;
> >      }
> >  
> > +    if (category && !test_bit(*category, dc->categories)) {
> > +        return NULL;
> > +    }
> > +

The category parameter is a bit not a bitmap, so, YES.

Thanks,
Zhao


