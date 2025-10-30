Return-Path: <kvm+bounces-61484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 70D80C20C2D
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 15:55:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 53C1D4F22CF
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 14:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D168E27CB35;
	Thu, 30 Oct 2025 14:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mEwX0MtB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D57926FDAC
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 14:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761835760; cv=none; b=OkyutzE5mdB432e9mlJgyhYHkeXPjs6zOa9GdEBTJQPWTcxw1IbHLkAsg04WkjV+VD6K2S77sLEwsnh0DmTycRwTNF1DX/4uR0qXfDTuLZm0cym7hmqijp0Y4sNZs7qWv/it+/KC5DZubYOF2WKR0ct962exLq8YgXk6AuepZ90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761835760; c=relaxed/simple;
	bh=Iddla4z7flI67h7EdMSDk02AU+XEEh2561J+ewfpQww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5J1AhVNo3AQSLeqzAfMDTjZXYbI33l6/BbDZYCPRRgCI4wyL6piRWphi8ZExaNBcv5SjDLatw7m83+SzoBYrbjQlZK/CVBXGnEkSgnzb62BjKqDIKv1R/AtqHCm8wDQ2sOBvoSJJ4kyhXzmuhALUn5+C6z/rUpCPuG6PtxE768=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mEwX0MtB; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761835760; x=1793371760;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Iddla4z7flI67h7EdMSDk02AU+XEEh2561J+ewfpQww=;
  b=mEwX0MtB4ICvcTNfvNV9/7zKEuyphGJF/EcfBj/Y+VKcoblEg8ELbpyP
   cXLbqkZM1XCW+VledD3Hxvwdz4l8ERWA183OAJzh6t6OQrQoaeeZ+nRc2
   1VcwTmrIab4KE7kL5dp45h7YpT9LOQmAdhEYsuDDSuIlPvUzc7DrxBuHC
   gyrd0qxHdLwBxTg7fqPhga1akYXqvKIneGexIBNdZeittxHiuMAWp4XTS
   VzMQtqSE3rZTNnYG70hR1pbF9asBqIvowoDc3CrUFi4GWn3fei+l1jw6A
   cBKzlrmo0o7XBeyn9KIImo05ahVyMlPe+bz7RRh37lW5IOeyydRZWH+mW
   Q==;
X-CSE-ConnectionGUID: s1Q2s32ERtOCbwHw6i3pTQ==
X-CSE-MsgGUID: uI/atfu+S22D+hl2MekqpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="64076015"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="64076015"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 07:49:19 -0700
X-CSE-ConnectionGUID: 18uW1v3FSGOYNruA8URLZg==
X-CSE-MsgGUID: Rb9i9bojQzu35J+ddr2Qww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="190311721"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa004.jf.intel.com with ESMTP; 30 Oct 2025 07:49:16 -0700
Date: Thu, 30 Oct 2025 23:11:27 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
	John Allen <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v3 02/20] i386/cpu: Clean up indent style of
 x86_ext_save_areas[]
Message-ID: <aQOAH0a9P3ZK+5H5@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-3-zhao1.liu@intel.com>
 <94d254b3-3d0f-4fe8-b6aa-da5df2b9c0e6@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94d254b3-3d0f-4fe8-b6aa-da5df2b9c0e6@intel.com>

On Mon, Oct 27, 2025 at 01:47:53PM +0800, Xiaoyao Li wrote:
> Date: Mon, 27 Oct 2025 13:47:53 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v3 02/20] i386/cpu: Clean up indent style of
>  x86_ext_save_areas[]
> 
> On 10/24/2025 2:56 PM, Zhao Liu wrote:
> 
> <empty commit message> isn't good.

Yeah, will add the description.


