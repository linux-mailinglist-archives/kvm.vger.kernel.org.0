Return-Path: <kvm+bounces-46041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CCEC8AB0EB5
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:19:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 063171C25F58
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D01274664;
	Fri,  9 May 2025 09:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DTx7WEf0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5C5275849
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746782217; cv=none; b=sVRoSj1cDkArKoDtHFCqazBS9ADLKOqSoUthg/i+XzmIMmpW4D7BICFpdQUFpneONaXowJ9qJrJ/w4yiXc/r1JETlo2mTwQ/HF0/Bzapo7jiwGNm6VdMeLO+IDmRXHwwNBFB2+Gyssur9wJo8rFfuhNd3571R/+n0xorRsTgfUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746782217; c=relaxed/simple;
	bh=fWuJszRoYNIae1SRNi4ekLG9TgewBETWDbuBAJi2yAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LhJFnzw7v8NpZoOxmtrASv7FJ27NJSTrD4WN13TpcoveSTh75URPSNy3TVFqRUlBKO0e4KbAerq1hCA1rL/3/pRhjunoVcMd2ItRMjDtPtiAOyVRVgckMGddXwGdjrofQKLz0k0OjyrZ7oYdWNM0MQacB4B3reULYD896BbsToM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DTx7WEf0; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746782216; x=1778318216;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=fWuJszRoYNIae1SRNi4ekLG9TgewBETWDbuBAJi2yAI=;
  b=DTx7WEf05l58YdeYWMU2TeNRuOM/3hZyJK+GJSDm/hKnTD/Mbm822vu+
   2sraV09kyJa4imeEXJFPFWN98JChsjM2P0j4MsrM1cWo6//O1GlkJPnFD
   dlLbjB72pJvz6WUAW77UpKFy5oaMN9YJntDesfrkL1+ykDlkqpcJ7nC48
   XwhAgshVdDQCGBzIFr1NUuVnNFllIBZI/L6+kmMhnd8dGMvPcPO1QWgdX
   PQ85XT0lEga9pzxxbAHsevCffhpD/T3vgmXcL+DYE9pck6k2NSbMGYF8f
   rnTYE/xwSIxrKA/8NN8PDA12FU+/LC0eiqlHr45PG4RS3Nge2QfY5SPgT
   Q==;
X-CSE-ConnectionGUID: IrITnC5/Q8CMXzsSWEM+iQ==
X-CSE-MsgGUID: a8jA9qxASqSVXYyRRAqgwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="59599997"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="59599997"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:16:55 -0700
X-CSE-ConnectionGUID: WP0RCFLKT46ejuRYK87bag==
X-CSE-MsgGUID: zI96hvJRQfaATwVfgYUpog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="167641269"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 09 May 2025 02:16:49 -0700
Date: Fri, 9 May 2025 17:37:51 +0800
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
Subject: Re: [PATCH v4 19/27] target/i386/cpu: Remove
 CPUX86State::full_cpuid_auto_level field
Message-ID: <aB3M7/RlxxDFg5al@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-20-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-20-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:42PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:42 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 19/27] target/i386/cpu: Remove
>  CPUX86State::full_cpuid_auto_level field
> X-Mailer: git-send-email 2.47.1
> 
> The CPUX86State::full_cpuid_auto_level boolean was only
> disabled for the pc-q35-2.7 and pc-i440fx-2.7 machines,
> which got removed. Being now always %true, we can remove
> it and simplify x86_cpu_expand_features().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  target/i386/cpu.h |   3 --
>  target/i386/cpu.c | 106 ++++++++++++++++++++++------------------------
>  2 files changed, 51 insertions(+), 58 deletions(-)

This property is a fix, so,

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


