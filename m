Return-Path: <kvm+bounces-66616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B9615CD901B
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 12:02:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E36E23015865
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 11:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB2C633EB0B;
	Tue, 23 Dec 2025 11:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q6XgtUWT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FBD7262A;
	Tue, 23 Dec 2025 11:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766487729; cv=none; b=BSXeTpRFycigWdVeWnuXeRVzI9ftSxQmFppDqb1pW2mqVmkbmjfFkUR7uAu0boZFVlti0edMymfQzCwN4PMZp4q5NhswC+d9h/UYOSM6hqqhA7pFf4xxdAlEOGUEDP21B0DyIQZcowuPuLpkCSD0z6AnMt9aVdjjPhtiQgApS68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766487729; c=relaxed/simple;
	bh=i2XVCarflFtkPgBD3RghuFj0IIwOjlwkyUptvOUHpTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SzjQENhuKdTiSwAuYXx2KCUfmYaE4axsueVP8HCni1Cx8aU2Ij6CraJzxPQYPKb7LwWsRWXkyQzIisnKqHzux5+GcqkIR/GISIehzPyHRjTR7catLoc4EvUQ/ME7NPcNRsvEl1nGHd1WGyVYjEqi1ekkkLDoX6YqA1HisgE4zgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q6XgtUWT; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766487728; x=1798023728;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i2XVCarflFtkPgBD3RghuFj0IIwOjlwkyUptvOUHpTo=;
  b=Q6XgtUWTz+AYdt9qFD2Vydb+Kv1TZ3+gFRvVqJAbHkbOoZxCsXJ0bswU
   IxZP+2NdZOs4n9YG2zr6VpZ4zmIVBFgIFy/8azUREEgK5aljEmzGaVPOD
   0LvNozNmGR1HIE3cRkc3h3CGr7/j2T+AO6hmljL8QIUChvqy4+dDg8zyl
   yaRCvmMwK8s5GRi1l0InuDUo9l6l0lIfVLxE3OEZCTetvc/EhogF5wpef
   leY7f+ILYQsWpZNgAO7Qj0niCMNG5GbnYa7D8RRljt7Ez8dV3nKfMXHkW
   0ecACbapxXwp41L9srPKjKadd0D4xFjwO+ZG68V8sOu+y5ec5Cr/HJvPd
   g==;
X-CSE-ConnectionGUID: dacG7//oShGr6WGjpqrRKA==
X-CSE-MsgGUID: dUNqKJaRSu+5rSLKeG33EA==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="85751127"
X-IronPort-AV: E=Sophos;i="6.21,170,1763452800"; 
   d="scan'208";a="85751127"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2025 03:02:08 -0800
X-CSE-ConnectionGUID: 9JfQte06SfGMTxrxn4rBxA==
X-CSE-MsgGUID: i0cIpRz8SUa0aae0I9RIRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,170,1763452800"; 
   d="scan'208";a="200260796"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa009.fm.intel.com with ESMTP; 23 Dec 2025 03:02:04 -0800
Date: Tue, 23 Dec 2025 18:45:38 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 26/26] coco/tdx-host: Finally enable SPDM session and
 IDE Establishment
Message-ID: <aUpy0nCG/vqyCow3@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-27-yilun.xu@linux.intel.com>
 <20251219120616.00000890@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219120616.00000890@huawei.com>

On Fri, Dec 19, 2025 at 12:06:16PM +0000, Jonathan Cameron wrote:
> On Mon, 17 Nov 2025 10:23:10 +0800
> Xu Yilun <yilun.xu@linux.intel.com> wrote:
> 
> > The basic SPDM session and IDE functionalities are all implemented,
> > enable them.
> > 
> > Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
> Hard to disagree with this one :)
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Thanks for all your review, tagged them in my v2.

