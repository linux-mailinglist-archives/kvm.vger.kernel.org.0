Return-Path: <kvm+bounces-68482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EE2E5D3A10F
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 09:13:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2433F30422A4
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 08:13:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0A033B96F;
	Mon, 19 Jan 2026 08:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T5KJLmlt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C755233B6E7;
	Mon, 19 Jan 2026 08:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768810385; cv=none; b=AfOOHs68abmDNRGf/y8+R3evXxUAHyUqkZ9bIolmlpuuSBAzOWHp2d35DTVxuzU0WAlpjZrH6njs/m1UHJB7Zssh7xfVz83/uNJMidypo5v4IjGYGythPEHvVSDm8jZQDn64Jv4KAub1Jh7Mwb4FWLr4Bq18fbBzuk9lKhTI5J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768810385; c=relaxed/simple;
	bh=JRVFlFti6RQS26zzqATSJWs5ScqOeMeP6L0Xnp1VpA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sqQnZ60UtTv40U+tAZFiPRbwcieaT06xMSBLhGGFL1RjdKDTXs0nvylF7aSnGF4EfdR9w8zSncPwO0SxzGpMw3CjwjqX4J21q0KLF9f4v016koGix+PzzEzrmT9izpgRUlurp5F8Xfc8xyx9yEPVKSgBB2SKpBY0ugFSWtMBdFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T5KJLmlt; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768810383; x=1800346383;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JRVFlFti6RQS26zzqATSJWs5ScqOeMeP6L0Xnp1VpA4=;
  b=T5KJLmlty2J1oc1n6j8ZrBZgGE0tlh8XUyrxEfd32TwtvlR4lmDTG9rQ
   geW0DoCwPeun0Q8v/tMujlXRHrMbBy14StuaMnKLaCAMT/0kDGGY81iC+
   KA912xMpHoG5NqLP5u8bAgo4sSl+l39hepdTPvMyIyJAh2RJU7b9mjG+H
   q6GUoaa/kOh6kjIF/tuhdz+7X5Czma4+wP4yin0ZekiiRpVwAVguMDbFp
   P/HoW1M9LOghLlNgXKu/YSdcDK27mTnK3xTT/jM6Mc8rCDae2RwIMIuoe
   kMxxM6mD4AqOE84fMCdFmLDgMlcjXP6MpHDGFqFTFnPoJnyC8qXrifM+w
   g==;
X-CSE-ConnectionGUID: bCiY6o8MQem3ciOF3zkNJQ==
X-CSE-MsgGUID: zBuQXETmT62tvnO4TYYYcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="80738722"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="80738722"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 00:13:03 -0800
X-CSE-ConnectionGUID: 0lZ31phJRhG5kCbfyESufQ==
X-CSE-MsgGUID: amCx/Nv0RCeFaqoXnDHZ/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="236494493"
Received: from aotchere-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.249])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 00:12:58 -0800
Date: Mon, 19 Jan 2026 10:12:55 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, x86@kernel.org, Chao Gao <chao.gao@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 2/2] x86/virt/tdx: Print TDX module version during init
Message-ID: <aW3nh8n6I8rJxPXl@tlindgre-MOBL1>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
 <20260109-tdx_print_module_version-v2-2-e10e4ca5b450@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109-tdx_print_module_version-v2-2-e10e4ca5b450@intel.com>

On Fri, Jan 09, 2026 at 12:14:31PM -0700, Vishal Verma wrote:
> It is useful to print the TDX module version in dmesg logs. This is
> currently the only way to determine the module version from the host. It
> also creates a record for any future problems being investigated. This
> was also requested in [1].
> 
> Include the version in the log messages during init, e.g.:
> 
>   virt/tdx: TDX module version: 1.5.24
>   virt/tdx: 1034220 KB allocated for PAMT
>   virt/tdx: module initialized
> 
> Print the version in get_tdx_sys_info(), right after the version
> metadata is read, which makes it available even if there are subsequent
> initialization failures.

Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>

