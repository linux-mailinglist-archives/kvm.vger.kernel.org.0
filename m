Return-Path: <kvm+bounces-28056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB43B992972
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 12:46:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 374101F22B32
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 10:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A25ED1D0DDE;
	Mon,  7 Oct 2024 10:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="amUJxBoV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31358189F45
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 10:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728297975; cv=none; b=Uy9c2Ud9bmpOmXCfoxrtFbOQEu2gNyLJ1tDwgJsCR9uXMRzdY4LTh2PZUqHYLZBwFHnlqL+uy/xmEnExO57FMYGSPrWANxve6T6OcZoZbOm/FA6gVsYxIBx1M/LqzYp5b2+yLPZsDv+6LM+quIBIy7ZAtLUkKxb9kP9ASZtd7NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728297975; c=relaxed/simple;
	bh=B7T9+eTv/Zw/x8yFPq2kpJfgxfT66Zaq5LvJc4Qn1No=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n9Xsa0RS9US35dpCUjaWDh843FUAAgDLmagI+XO8rqovflDA0WgdnU0nTpNKLlbPEwi9OFYJSB0jPhazSNlfDdkTvZVahJnSDKSaXdOKN4ncSyR/j9q0k7JhCaXqyB9Nz8OV7AblJkvFAgIiqEf3HNkbUelTD8Ly+zUvME2DL2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=amUJxBoV; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728297974; x=1759833974;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=B7T9+eTv/Zw/x8yFPq2kpJfgxfT66Zaq5LvJc4Qn1No=;
  b=amUJxBoV/tMwLNhjb2VXht3lx6VdxwloH9ogC6JEH1ID0/GyCfW+OwHv
   UWU5KS6VfoXUli2cF3jvCoQUplvm05Zr4v4KIeU18HIwRnttT8fSE6v/V
   287yhN6na8aHSKEm3Rj0IenDXPuKSFvN/WHNJ0+6unQcgSxUg4uEj/T2D
   4QB5ePpbBVGi3RZBIyezk4YLRqXstTSVwu3ikmRfnoYf1IfZ72oF8BQDN
   w1kh88VA4OCRvWdlgHs1Zgw0EkYWNlwYJYuZ5+yh6stry8KMQ+DCwWntW
   tzI3Wvum1gSCq/lD2W0xxhoCFjNDZQ3bS9Ftpp+P7kAmNB/PM0av1nVd8
   g==;
X-CSE-ConnectionGUID: +AIHngHkQp+2g7iJzjPzkA==
X-CSE-MsgGUID: M2Wu5gTxTxe0CFsxPjjnVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11217"; a="30323835"
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="30323835"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 03:46:14 -0700
X-CSE-ConnectionGUID: AX+g0EMbQD6q55DiWdQOyA==
X-CSE-MsgGUID: dW1FG9hzTJijhkJ9dGXajQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="75004461"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 07 Oct 2024 03:46:09 -0700
Date: Mon, 7 Oct 2024 19:02:19 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S.Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v2 3/7] hw/core: Add smp cache topology for machine
Message-ID: <ZwO/u0T+65b2/cFg@intel.com>
References: <20240908125920.1160236-1-zhao1.liu@intel.com>
 <20240908125920.1160236-4-zhao1.liu@intel.com>
 <20240917100048.00001bcf@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917100048.00001bcf@Huawei.com>

On Tue, Sep 17, 2024 at 10:00:48AM +0100, Jonathan Cameron wrote:
> Date: Tue, 17 Sep 2024 10:00:48 +0100
> From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
> Subject: Re: [PATCH v2 3/7] hw/core: Add smp cache topology for machine
> X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
> 
> On Sun,  8 Sep 2024 20:59:16 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
> 
> > With smp-cache object support, add smp cache topology for machine by
> > linking the smp-cache object.
> > 
> > Also add a helper to access cache topology level.
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>
> Minor stuff. The property stuff is something I seems to mostly get wrong
> so needs more eyes but fwiw looks fine to me.

Yes and thank you!

> With the tweaks suggested below.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> > ---
> > Changes since Patch v1:
> >  * Integrated cache properties list into MachineState and used -machine
> >    to configure SMP cache properties. (Markus)
> > 
> > Changes since RFC v2:
> >  * Linked machine's smp_cache to smp-cache object instead of a builtin
> >    structure. This is to get around the fact that the keyval format of
> >    -machine can't support JSON.
> >  * Wrapped the cache topology level access into a helper.
> > ---
> >  hw/core/machine-smp.c | 41 ++++++++++++++++++++++++++++++++++++++++
> >  hw/core/machine.c     | 44 +++++++++++++++++++++++++++++++++++++++++++
> >  include/hw/boards.h   | 10 ++++++++++
> >  3 files changed, 95 insertions(+)
> > 
> > diff --git a/hw/core/machine-smp.c b/hw/core/machine-smp.c
> > index 5d8d7edcbd3f..b517c3471d1a 100644
> > --- a/hw/core/machine-smp.c
> > +++ b/hw/core/machine-smp.c
> > @@ -261,6 +261,41 @@ void machine_parse_smp_config(MachineState *ms,
> >      }
> >  }
> >  
> > +bool machine_parse_smp_cache(MachineState *ms,
> > +                             const SmpCachePropertiesList *caches,
> > +                             Error **errp)
> > +{
> > +    const SmpCachePropertiesList *node;
> > +    DECLARE_BITMAP(caches_bitmap, CACHE_LEVEL_AND_TYPE__MAX);
> > +
> > +    for (node = caches; node; node = node->next) {
> > +        /* Prohibit users from setting the cache topology level to invalid. */
> > +        if (node->value->topology == CPU_TOPOLOGY_LEVEL_INVALID) {
> > +            error_setg(errp,
> > +                       "Invalid cache topology level: %s. "
> > +                       "The topology should match the "
> > +                       "valid CPU topology level",
> 
> I think that's too much wrapping for an error message. Makes them hard
> to grep for.

I understand you mean the last sentence should not be on separate lines
but should be continuous in one line, right?

> > +                       CpuTopologyLevel_str(node->value->topology));
> > +            return false;
> > +        }
> > +
> > +        /* Prohibit users from repeating settings. */
> > +        if (test_bit(node->value->cache, caches_bitmap)) {
> > +            error_setg(errp,
> > +                       "Invalid cache properties: %s. "
> > +                       "The cache properties are duplicated",
> > +                       CacheLevelAndType_str(node->value->cache));
> > +            return false;
> > +        } else {
> 
> returned anyway in the above path, so can drop the else and reduce
> indent a little.

Sure.

Thanks,
Zhao

> > +            ms->smp_cache.props[node->value->cache].topology =
> > +                node->value->topology;
> > +            set_bit(node->value->cache, caches_bitmap);
> > +        }
> > +    }
> > +
> > +    return true;
> > +}
> > +
> 
> 

