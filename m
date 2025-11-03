Return-Path: <kvm+bounces-61843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78077C2C72D
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 15:44:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C939D1894EA8
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 14:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58AC7280332;
	Mon,  3 Nov 2025 14:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R/hMa9/1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DA827FD4F
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 14:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762181008; cv=none; b=bs9EERlRLjwNjnsInMTkZs+8MDFLq5DXDaHOBGe1diofq/8Jez/vkext2It2mA7CP4lkWlR5PArlegf4OkCLKHwCBjMr5elNBwjadZdOQOYWicXXdtv/E+5PxZHarr96iNjRFi2S+Su1vU7O3VvKfJPg8iArijs7kvGwsENvkgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762181008; c=relaxed/simple;
	bh=rgzIUif7BymigCeBn3RihGliGYi9spsPrRXf4EkFZzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HXk6xnMr5DjbLUSbNTKiKMWd2WttnnzHVvjFp5v3XjEwsdZNrTlMXvlLsLG1YQICJXDNgQhyC0W581rlGz3LZFxoGHQuJucqqjGoOkQloB4Y4qX+ylLg9g63z8wf0yTEvszl4WUIS6SEtGbUoibgMOMW7/N4RxZNxP+rbgYSFO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R/hMa9/1; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762181007; x=1793717007;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=rgzIUif7BymigCeBn3RihGliGYi9spsPrRXf4EkFZzg=;
  b=R/hMa9/1A+g58DnEFhhyLClHQIUDuTInWYf4oVcEdnQFkAHLeh0w36T+
   yFWZEYIy4k3+hDwGWPEo6vj56JWi6IHRyuidEevykHG+ep85UpDGFUjha
   mBrM/c+9cFUR5yZ/jvg25clnHJOEIFCQmaDet/oex+NXRfUszmjiUm+F7
   fQ3v+AZ7T8qYSn3RkpuuIdi8wSHH6GjmiOrri0WqdMrZfHMsMfZbAaAnj
   +yjs+hVZoHojPnotidspcdIOD8ApoSNS8a7g4m3B2xGIA/DC7k09ddlKS
   NQXczgshD128LRmAzf9oUSi/tKbXNk6B4y7xqYs/L/OfO/9hgeK5+yrMu
   Q==;
X-CSE-ConnectionGUID: nUSXwEnITQWmHfTQEUuj0A==
X-CSE-MsgGUID: EnjVYY3CTsCdPfT6R032PQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="81885348"
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="81885348"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 06:43:26 -0800
X-CSE-ConnectionGUID: E98YbumfTHSdNpgxCn67lQ==
X-CSE-MsgGUID: kqvQMZqJSSaMwLYQkvXNUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="224130157"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa001.jf.intel.com with ESMTP; 03 Nov 2025 06:43:18 -0800
Date: Mon, 3 Nov 2025 23:05:32 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	qemu-devel@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
	Yanan Wang <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>, Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?iso-8859-1?Q?Cl=E9ment?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v4 00/27] hw/i386/pc: Remove deprecated 2.6 and 2.7 PC
 machines
Message-ID: <aQjEvN7zbBay8yDy@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20251031113344.7cb11540@imammedo-mac>
 <0942717b-214f-4e08-9e2a-6b87ded991c9@linaro.org>
 <aQTEKyQjqIIGtyP0@intel.com>
 <20251031152345.65b2caed@fedora>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251031152345.65b2caed@fedora>

On Fri, Oct 31, 2025 at 03:23:45PM +0100, Igor Mammedov wrote:
> Date: Fri, 31 Oct 2025 15:23:45 +0100
> From: Igor Mammedov <imammedo@redhat.com>
> Subject: Re: [PATCH v4 00/27] hw/i386/pc: Remove deprecated 2.6 and 2.7 PC
>  machines
> X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
> 
> On Fri, 31 Oct 2025 22:14:03 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
> 
> > Hi Igor and Philippe,
> > 
> > > On 31/10/25 11:33, Igor Mammedov wrote:  
> > > > On Thu,  8 May 2025 15:35:23 +0200
> > > > Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
> > > > 
> > > > Are you planning to resping it?
> > > > (if yes, I can provide you with a fixed 2/27 patch that removes all legacy cpu hp leftovers)  
> > > 
> > > Sorry, no, I already burned all the x86 credits I had for 2025 :S  
> > 
> > Don't say that, thanks for your efforts! :-)
> > 
> > > Zhao kindly offered to help with respin :)  
> > 
> > I haven't forgotten about this. I also plan to help it move forward
> > in the coming weeks.
> 
> in this case, I'll send reworked patch (not really tested)
> as a reply 2/27 so you could incorporate it on respin.

Thank Igor! I'll include that patch into v5.

Regards,
Zhao


