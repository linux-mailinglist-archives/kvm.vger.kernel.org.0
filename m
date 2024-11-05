Return-Path: <kvm+bounces-30614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88E809BC487
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:07:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C922282CF0
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 05:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03FBF1B3951;
	Tue,  5 Nov 2024 05:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C5G9DUUq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF11776C61
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 05:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730783232; cv=none; b=D1dRogtTxHv38iqj88AKJvpcwyfRrcMFderc8j1ykRSc/eQYn1I1xTI+0SBIgz09ufLpLIPZGWKHoDB3scGYP+Bb6V+CF6LSTscvGdFD2i2aBIc9jURUcEyIVRRzZiObSTsZ52VC53qPJTLoCIlLIGRVdMXSyjrz4fgqEuxI/Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730783232; c=relaxed/simple;
	bh=7EVEDlAbCD/P8bosDovSaG5sItRv1jMliFkcaF8GHwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CJKcNw7WhCTM1aYPTC7KlRDFqwFB/GofPP0RyV2HjRck1PwFtRLLveYEPDkw/ZIYbdXDh4Eln+C8stoikKHQd2nr229T24o2lCQTeKD3G76jx/8LIWhIrcqCkfNjt6feZplJZHSNJ4rcLax7VYEHeLSE9i04lL+OBX+0xmqSdEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C5G9DUUq; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730783231; x=1762319231;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7EVEDlAbCD/P8bosDovSaG5sItRv1jMliFkcaF8GHwg=;
  b=C5G9DUUqASLysD0oJux4jdnKETft8x/AeDbAM8YS1zYhUWGiJ+sAwvaP
   TXglMFEv21ySxrQIQzfl4PTvwKGIp6zMXC29lMlVPDZ2PRVmo/OU86o6g
   1N6Uel76W9PcQyVk2QhlNz/OpzLdvs4weU0ubUO44uwnsWQ4xR6satZBI
   arVHHKEodPnLiSKtuH+bkC5IoRKK/QAO2QSMTEJMfUobKftYk98gNG5u3
   s0sgbMvoKF7YIM8V669PO9CoEahZ62yPjlLhjAbCNLfPSEBo+PTy96TMc
   QQRBAHe/sOnhjVIEOFDPob9pABlRf4GzrKJtzu/G8gVpCNIxbJQGB8E20
   w==;
X-CSE-ConnectionGUID: RrOj7+1CRAaZonZCVVePew==
X-CSE-MsgGUID: mhhXcIXLRVWrLkF24lyHTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="29929260"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="29929260"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 21:07:10 -0800
X-CSE-ConnectionGUID: baGyV9rbSBqiyb3Li+J14w==
X-CSE-MsgGUID: 5opq88LmRVC5sGSFGyiVKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="114663907"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 21:07:08 -0800
Message-ID: <7c0367f7-634c-485f-8c87-879ddfa2d29d@linux.intel.com>
Date: Tue, 5 Nov 2024 13:06:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/12] iommufd: Refactor __fault_domain_replace_dev()
 to be a wrapper of iommu_replace_group_handle()
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-3-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241104132513.15890-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 21:25, Yi Liu wrote:
> There is a wrapper of iommu_attach_group_handle(), so making a wrapper for
> iommu_replace_group_handle() for further code refactor. No functional change
> intended.

This patch is not a simple, non-functional refactoring. It allocates
attach_handle for all devices in domain attach/replace interfaces,
regardless of whether the domain is iopf-capable. Therefore, the commit
message should be rephrased to accurately reflect the patch's purpose
and rationale.

--
baolu

