Return-Path: <kvm+bounces-33642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 468489EFA29
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 18:59:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 499DB16E6A7
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 17:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0CA1222D6A;
	Thu, 12 Dec 2024 17:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="blWaZUXR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691CC216E0B
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 17:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026119; cv=none; b=dwi4CtNV/D/hXY0Fwdz7QkEum4bij6Mzs6Xo3o/ILn/JHbrh7MwiDhAeyhOCammLuOGjxUhAbOwLnsRAomZLD+voyRlUdIoP8lfh1cZAOGeTtbBXOrhjLtAN3sTk2Qlj/LVMd0jCit7HMXLFnbGGFAyhZj+5NcNKYNGMeMkEvBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026119; c=relaxed/simple;
	bh=WCauBqTZ+or2lrsOaY+8YEVqqP6EQVvDCkpfIihYUzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qfuTwHG7EVQ/N9LUzfEgatAiaehL8bN2j/D0oKfr9yQfV6b6I0nlAW+SASy7AucUuQSlpnyYXC5W3h9fa7zyjtfQ2MI1eD7Cbfi1iG1kuU4PhJikvynymrYaA2JZNvT32BtHOJhk9V+8eXfi75NzrFznd3w6XWw8xUb+bi0lzBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=blWaZUXR; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734026117; x=1765562117;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WCauBqTZ+or2lrsOaY+8YEVqqP6EQVvDCkpfIihYUzo=;
  b=blWaZUXRktfo5RAThzqRf1xMExGp4tMza0jMqaKzy88NrNYs7FvPQYsh
   2SVf1C2WdG92Mzok8jzfaYP43x5Ho7GvFEsVY2doZTv8WFz7FM9wf6BK3
   sVwZKzsjfYaIE0X+vxt38pwieoiCRe84ut/0o8tfi4XRhtuw0aAD1zyQO
   DenytYgp+MfhDYRvLUOTlXDu7yFeQaD9KfshLq6pVir0ynyHHNQs5TpHu
   187p3xugrmgglcdzFZDCIP93RSnmco3ktiKtXh/tvecn2JG6/CGaCJkyO
   IdP86iAm8JHqGZYrrLKxqiFWtZ711hJaJJ7CtR6AizMu5LHerrwwqbh35
   A==;
X-CSE-ConnectionGUID: Tppc/dmdTDGJpZJbx3blAA==
X-CSE-MsgGUID: Me6VwskoQhG+Fn92UXdeDw==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="34590992"
X-IronPort-AV: E=Sophos;i="6.12,229,1728975600"; 
   d="scan'208";a="34590992"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 09:55:17 -0800
X-CSE-ConnectionGUID: dzMcCecMSp+wxrLO8KOX5Q==
X-CSE-MsgGUID: hneBst+YQbutJ8arz2IQ5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,229,1728975600"; 
   d="scan'208";a="101328087"
Received: from puneetse-mobl.amr.corp.intel.com (HELO localhost) ([10.125.110.112])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 09:55:15 -0800
Date: Thu, 12 Dec 2024 11:55:13 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 19/60] i386/tdx: Parse TDVF metadata for TDX VM
Message-ID: <Z1sjgcTxgCpmFweY@iweiny-mobl>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-20-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105062408.3533704-20-xiaoyao.li@intel.com>

On Tue, Nov 05, 2024 at 01:23:27AM -0500, Xiaoyao Li wrote:
> After TDVF is loaded to bios MemoryRegion, it needs parse TDVF metadata.

This commit message is pretty thin.  I think this could be squashed back into
patch 18 and use the better justfication for the changes there.

Ira

> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  hw/i386/pc_sysfw.c         | 7 +++++++
>  target/i386/kvm/tdx-stub.c | 5 +++++
>  target/i386/kvm/tdx.c      | 5 +++++
>  target/i386/kvm/tdx.h      | 3 +++
>  4 files changed, 20 insertions(+)
> 
> diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
> index ef80281d28bb..5a373bf129a1 100644
> --- a/hw/i386/pc_sysfw.c
> +++ b/hw/i386/pc_sysfw.c
> @@ -37,6 +37,7 @@
>  #include "hw/block/flash.h"
>  #include "sysemu/kvm.h"
>  #include "sev.h"
> +#include "kvm/tdx.h"
>  
>  #define FLASH_SECTOR_SIZE 4096
>  
> @@ -280,5 +281,11 @@ void x86_firmware_configure(hwaddr gpa, void *ptr, int size)
>          }
>  
>          sev_encrypt_flash(gpa, ptr, size, &error_fatal);
> +    } else if (is_tdx_vm()) {
> +        ret = tdx_parse_tdvf(ptr, size);
> +        if (ret) {
> +            error_report("failed to parse TDVF for TDX VM");
> +            exit(1);
> +        }
>      }
>  }
> diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
> index b614b46d3f4a..a064d583d393 100644
> --- a/target/i386/kvm/tdx-stub.c
> +++ b/target/i386/kvm/tdx-stub.c
> @@ -6,3 +6,8 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>  {
>      return -EINVAL;
>  }
> +
> +int tdx_parse_tdvf(void *flash_ptr, int size)
> +{
> +    return -EINVAL;
> +}
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index d5ebc2430fd1..334dbe95cc77 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -338,6 +338,11 @@ int tdx_pre_create_vcpu(CPUState *cpu, Error **errp)
>      return 0;
>  }
>  
> +int tdx_parse_tdvf(void *flash_ptr, int size)
> +{
> +    return tdvf_parse_metadata(&tdx_guest->tdvf, flash_ptr, size);
> +}
> +
>  static bool tdx_guest_get_sept_ve_disable(Object *obj, Error **errp)
>  {
>      TdxGuest *tdx = TDX_GUEST(obj);
> diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
> index e5d836805385..6b7926be3efe 100644
> --- a/target/i386/kvm/tdx.h
> +++ b/target/i386/kvm/tdx.h
> @@ -6,6 +6,7 @@
>  #endif
>  
>  #include "confidential-guest.h"
> +#include "hw/i386/tdvf.h"
>  
>  #define TYPE_TDX_GUEST "tdx-guest"
>  #define TDX_GUEST(obj)  OBJECT_CHECK(TdxGuest, (obj), TYPE_TDX_GUEST)
> @@ -30,6 +31,7 @@ typedef struct TdxGuest {
>      char *mrownerconfig;    /* base64 encoded sha348 digest */
>  
>      MemoryRegion *tdvf_mr;
> +    TdxFirmware tdvf;
>  } TdxGuest;
>  
>  #ifdef CONFIG_TDX
> @@ -40,5 +42,6 @@ bool is_tdx_vm(void);
>  
>  int tdx_pre_create_vcpu(CPUState *cpu, Error **errp);
>  void tdx_set_tdvf_region(MemoryRegion *tdvf_mr);
> +int tdx_parse_tdvf(void *flash_ptr, int size);
>  
>  #endif /* QEMU_I386_TDX_H */
> -- 
> 2.34.1
> 

