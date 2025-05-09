Return-Path: <kvm+bounces-46049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DAE3AB0EEC
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B046C5226CF
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D190D2701A4;
	Fri,  9 May 2025 09:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lVk9rJzt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE09A275849
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746782730; cv=none; b=tfNcqlMFodWkzbSljvH6k0pSkyVn97uQIHR2WmK8WeinyHEDZckljW5TtpDHW1tJy1Cq6NfCIzReqaU0CNr2qkwmMqDxe877ASnCFWYG04mAXPKZDW8JGyo5GL3tx8wBbWpXcSoPhTpkq1XB6U+ZPMNmpTSiSXWp4BeMxblnD2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746782730; c=relaxed/simple;
	bh=9iNtYOExfCHQLupl4872ceXY3Fwlz00/haql1chioEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J/zyH1LFegtXRl6r5MLJzGJAPCERFPQEY6B9LVWtvOFA5izTmVlyEGdMlRvnppJjwnvgwGeVufUsPbhcjk/Xeb9zxpx0BhKoosynQQFVx1YwYouYVRq9hPNNuUWsRa09lHQvjW0M0zae9LKD6ySCAOigqfAukmySCPX2U7CVZe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lVk9rJzt; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746782728; x=1778318728;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=9iNtYOExfCHQLupl4872ceXY3Fwlz00/haql1chioEs=;
  b=lVk9rJztWr7FO3vpW83zf46RnxOgYXjcCm90HEyCjKQhvfvT8J14EhYz
   GONxIXYuxDV10F/zL3y9s1df8a7kKEeXUpfP8R2+mYArNbYJoO4o8Us4Y
   7QU3VdMjINBKOzV3A9eYAlvt80Dvii9ZBI9llwJL84ZJjK3h1InGyi12J
   ZuoKvxM3ynMYn7uo19o+2HrCKdZO2MEJ4NXOh2IqUgzQzAgKC7WP360ea
   J9e0h5PwN70LhdwV9J0x+O04hDlJTnWqUm+jQRle1l3KrAzhnqv+A8qYV
   Ukt/yesz5BqpNBTxfxsp7ZyeyB0zAqAkx7xyiE9gHXwXVaqCufpSq7Bcu
   Q==;
X-CSE-ConnectionGUID: uJZ48XZvRLSY63GzKMSNiA==
X-CSE-MsgGUID: lk+I32EEQzur665XzoS+Ww==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="58822989"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="58822989"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:25:26 -0700
X-CSE-ConnectionGUID: Jm0O7L1BQUKWI+PSzhWqwA==
X-CSE-MsgGUID: 05/v4SvJSY2CwuTEFUrItg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="140620735"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa003.fm.intel.com with ESMTP; 09 May 2025 02:25:19 -0700
Date: Fri, 9 May 2025 17:46:21 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
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
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?iso-8859-1?Q?Cl=E9ment?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v4 26/27] hw/char/virtio-serial: Do not expose the
 'emergency-write' property
Message-ID: <aB3O7WrGQc1N5+ny@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-27-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-27-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:49PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:49 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 26/27] hw/char/virtio-serial: Do not expose the
>  'emergency-write' property
> X-Mailer: git-send-email 2.47.1
> 
> The VIRTIO_CONSOLE_F_EMERG_WRITE feature bit was only set
> in the hw_compat_2_7[] array, via the 'emergency-write=off'
> property. We removed all machines using that array, lets remove
> that property. All instances have this feature bit set and
> it can not be disabled. VirtIOSerial::host_features mask is
> now unused, remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  include/hw/virtio/virtio-serial.h | 2 --
>  hw/char/virtio-serial-bus.c       | 9 +++------
>  2 files changed, 3 insertions(+), 8 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


