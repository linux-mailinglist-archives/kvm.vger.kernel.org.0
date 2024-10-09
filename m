Return-Path: <kvm+bounces-28164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFBD6995F48
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 07:55:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3FD06B22A2D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 05:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5784161313;
	Wed,  9 Oct 2024 05:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fhHb9x04"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A21C2AF1D
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 05:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728453302; cv=none; b=pXTF3aIvWl+WgTlmXKIad+upnxee/dq9hnzdgtW213TN73klFWkm/oStuyCJ4q+tmR4kVR2uOUMP3TYSHSZyTc6iUa4vQqksRCkzCYoCTiVRYx/XZPOJg+zQCyrhsknA57Ebpt6xknO8Q+tMosgJmiez6oFovGRvU6hbKypHfAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728453302; c=relaxed/simple;
	bh=wMTrGWrNqEJ/3vJS5OVwKl/YUiB1j9er0HSj6wg9YsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HhT91FrtlZjhywNAenFsjoT6OSOIglTB99cDLS2XWpKKd6E6/vdT2nLHOzftCaXOgXbQTfJLCdJBHUav4nVRXMCIqJxkfjHNP/Y2Zqj9WAg6irQxE4wsSzg2hYylEQKWRg/N6M8rZFDiL1FNB/8d+fXYRw4akQpIKN+XYPKNO4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fhHb9x04; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728453302; x=1759989302;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wMTrGWrNqEJ/3vJS5OVwKl/YUiB1j9er0HSj6wg9YsY=;
  b=fhHb9x04lTSHCCNlwte1jBBXg20KFLKUJzLG0lbaHhO3c87e+W1Qo5w+
   I42UdvzKGv/ExtQybQ472le04ANivCv/kCyuzdgvxopkvtD509mMxVqcS
   vmxM2OddxoWSxcQv3eNQb4NJ3Apu4aXswd4uzqyo+JAuVYOx0Fz2ARNH6
   QCI0DB0R8g5xk8NNMxugaRfzEazrX+6M8BpkwvDFVHIpSFwneWJ+zjHj1
   4j/OQ5fVTf3GJ0MYu7VdjcNCHi5qww+XG5+/8/N/A0+Y/H2idL2V2sYrQ
   CT64VpD2git3613VBHVg1Sq8VzmiBZozyBY4h7x3bANhKdWFXQsV2T4uq
   g==;
X-CSE-ConnectionGUID: GyqnaEk+ROCHrvmEp4bVPg==
X-CSE-MsgGUID: UOY6xJMpQpe2hSuqvL4akw==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="27623662"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="27623662"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 22:55:01 -0700
X-CSE-ConnectionGUID: tj+D1EMQTfGPh480WuhJkQ==
X-CSE-MsgGUID: jqH4fZ4+RSaVVwxcKVhkAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="81154308"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa004.jf.intel.com with ESMTP; 08 Oct 2024 22:54:55 -0700
Date: Wed, 9 Oct 2024 14:11:06 +0800
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
Subject: Re: [RFC v2 03/12] system/vl: Create CPU topology devices from CLI
 early
Message-ID: <ZwYeek8iaoE2fu+C@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
 <20240919061128.769139-4-zhao1.liu@intel.com>
 <20241008105545.000013e0@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008105545.000013e0@Huawei.com>

On Tue, Oct 08, 2024 at 10:55:45AM +0100, Jonathan Cameron wrote:
> Date: Tue, 8 Oct 2024 10:55:45 +0100
> From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
> Subject: Re: [RFC v2 03/12] system/vl: Create CPU topology devices from CLI
>  early
> X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
> 
> 
> > +
> > +static void qemu_add_cli_devices_early(void)
> > +{
> > +    long category = DEVICE_CATEGORY_CPU_DEF;
> > +
> > +    qemu_add_devices(&category);
> > +}
> > +
> >  static void qemu_init_board(void)
> >  {
> >      /* process plugin before CPUs are created, but once -smp has been parsed */
> > @@ -2631,6 +2662,9 @@ static void qemu_init_board(void)
> >      /* From here on we enter MACHINE_PHASE_INITIALIZED.  */
> >      machine_run_board_init(current_machine, mem_path, &error_fatal);
> >  
> > +    /* Create CPU topology device if any. */
> > +    qemu_add_cli_devices_early();
> I wonder if this is too generic a name?
> 
> There are various other things we might want to do early.
> Maybe qemu_add_cli_cpu_def()

Sure, it makes sense.


