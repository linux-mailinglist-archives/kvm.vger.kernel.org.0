Return-Path: <kvm+bounces-61921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FBAAC2E5D3
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 00:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 185324E2E63
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 23:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C514D2FD7D8;
	Mon,  3 Nov 2025 23:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lFRU1VPc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1459A23184F;
	Mon,  3 Nov 2025 23:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762211042; cv=none; b=Sa2eQQDIIC5qFKqvTLuA9ANszaknbRRVKU3inhbc5OtJvtCncCsPOqTKlnbJ29M6uI4q39bmZFsglvWwDwGzoPGWaF+nuE56FXztlQvoSqn6R+S0zW/zvs4F+XMpj+HHrYigyWxBSqGcsaB69AJUiBg6dKs0YHxLVhlUF2dsLcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762211042; c=relaxed/simple;
	bh=8P1KEoLVfyK8ttLf3HKtbNioD47MCP5kf76Tz9Ckmr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h5oFDQT9afM3zQmcCmEe6PBeGTXU1ZMwArmTPhMIqlt5yyu8xDHVRm8nXVGEmEXx1TXQxKYswPgHVC3nCnoMWIoLkW0YCwuP79LxUIM408wdgzvnRZRty4YpMmHHG3P/0W/+Ac65eRn8tkcWVYZe0QFvRRwDUg4QLTPwDrDU6Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lFRU1VPc; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762211040; x=1793747040;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8P1KEoLVfyK8ttLf3HKtbNioD47MCP5kf76Tz9Ckmr4=;
  b=lFRU1VPcCGO+6taK0LSWLDMMB5BGfaHUzQbrZ/tAYFYR+x3t3MAIjBcd
   sUiKdHlw1zZDICtlpGRIIhhKNxHPonUicsegjahU0ZFJDtgMDDY+F+roR
   Y9Q/vXy6IHW4I36Ousl6JzpygZ+1Gd+JHnenLJiNcG+JQkVhGtjQMLVuJ
   ZFTa4r6dHdSeXrBq5xwRqj8Ywqbb7f+zs2d6Yv0QyU7B2taTYVyNPJFfj
   w4Fb3Hht4xjCg43O41/tydBX8fG1cSJjFT+0qRAQmr9U1f5EmgDtQ7Am+
   idosryQR2ZheLkya1ShqPIWgMaI+vsgwjHigZ0c5w3WQOqA8xL5km798s
   w==;
X-CSE-ConnectionGUID: MHz4pe/USX2XNCVwtDq2Ow==
X-CSE-MsgGUID: zxl4TQNsReS1y8kupYKjxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64201870"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64201870"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 15:04:00 -0800
X-CSE-ConnectionGUID: TNdubzDBTJ2A08ogQgtZ7w==
X-CSE-MsgGUID: 9aW3zwC0SE6LSE7U86DUNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="186856262"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO desk) ([10.124.220.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 15:03:59 -0800
Date: Mon, 3 Nov 2025 15:03:53 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v3 0/3] VMSCAPE optimization for BHI variant
Message-ID: <20251103230353.ifsayclvtw7bzyga@desk>
References: <20251027-vmscape-bhb-v3-0-5793c2534e93@linux.intel.com>
 <f07e3144-edcd-4b5c-8b4a-fb6bdd90943b@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f07e3144-edcd-4b5c-8b4a-fb6bdd90943b@intel.com>

On Mon, Nov 03, 2025 at 12:07:30PM -0800, Dave Hansen wrote:
> On 10/27/25 16:43, Pawan Gupta wrote:
> > | iPerf user-net | IBPB    | BHB Clear |
> > |----------------|---------|-----------|
> > | UDP 1-vCPU_p1  | -12.5%  |   1.3%    |
> ...
> 
> Could you clarify what "1.3%" means? Is that relative to the baseline,
> or relative to the IBPB number?

This is relative to the baseline, sorry I didn't mention that explicitly.

> If it's relative to the baseline, then this data either looks wrong or
> noisy since there are a lot of places where adding the BHB Clear loop
> makes things faster.

I will double check, but I am fairly positive that this wasn't noisy.
Surprisingly, there were a few other cases where the BHB-clearing was
performing better than the baseline.

