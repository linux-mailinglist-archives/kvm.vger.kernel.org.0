Return-Path: <kvm+bounces-66615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B4D40CD9015
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 12:02:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB6373020486
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 11:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F27C33F37B;
	Tue, 23 Dec 2025 11:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SJYNNzXI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665842EDD57;
	Tue, 23 Dec 2025 11:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766487652; cv=none; b=HE1s5V20P1/N2PRQQcCaBEuCfg36RspTDBlQR7xjsFKMtIpPFbN1EFDvh/rMpBDd4h0IcM6fQCldQyW6jAnUXpmUrXPJRuqiYgRoSKpCRM0KPEiVzMOFFI3FhnninhzcOs0YlqPpuoQOlJBj8PzAWwdL04iHbdlIdoeEyynmd9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766487652; c=relaxed/simple;
	bh=4avTbt42prlBNalmcGAKQTVD3tD+58Evm9BeZ+vt8oE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lKsHQirE9xmgOcmBbnE5rmuusJNbCjAJ2mWu0dlOgvnsfZwPmy5niPNzf8T+NwnkngIzDseh3JGkVXItF9Do4S1zskC/N0LapVhSTxTR9LznXooiy5yJG51npZlcfN5O5s+l+ntBhuARARU4RQXP69ODDgkhIU6qvpq62QbL7u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SJYNNzXI; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766487651; x=1798023651;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4avTbt42prlBNalmcGAKQTVD3tD+58Evm9BeZ+vt8oE=;
  b=SJYNNzXIL0DXR+cFcDi9y9FrQBIevZ6UJx9MKI8l1CAppF47hdxLo82y
   R2pVtsUB7gNiCLz7Qb7hBU2jxo9PdVXw5B9XIQxE76v9gnCyjuR4X8ot+
   4I2T7oTRVX+BAzO4z2iqoFFpNscUcUJkDHKrGjakXy7FkmvJEa/8k/iGI
   0l5JIhXLywaHw6+FgYrapCujfXkfHs5Gc+OEeaHhomJWk4F1JMPdkKAEm
   1pkNC7pRoywuS9wSMuNG+kTpM5TJCK47PDj7I4TPXJui0/1psjUlSuymh
   AS+DWNM06A5mtqJG/8geLUs2+TBdz0+ScEkTHKuz+L4vCluAh4QxhJ72S
   g==;
X-CSE-ConnectionGUID: GOsWqqiDT7O2o2HfdCd56A==
X-CSE-MsgGUID: mSxAT7GFRhSJX7twRo54AQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="68380462"
X-IronPort-AV: E=Sophos;i="6.21,170,1763452800"; 
   d="scan'208";a="68380462"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2025 03:00:50 -0800
X-CSE-ConnectionGUID: eCWj/22QRDigcDopZ0YMyg==
X-CSE-MsgGUID: fMt3G3l3Rqq2bHIAdXNgkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,170,1763452800"; 
   d="scan'208";a="199422625"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa007.fm.intel.com with ESMTP; 23 Dec 2025 03:00:46 -0800
Date: Tue, 23 Dec 2025 18:44:20 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 14/26] mm: Add __free() support for folio_put()
Message-ID: <aUpyhIqQODMZ3W6d@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-15-yilun.xu@linux.intel.com>
 <20251219115507.00002848@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219115507.00002848@huawei.com>

On Fri, Dec 19, 2025 at 11:55:07AM +0000, Jonathan Cameron wrote:
> On Mon, 17 Nov 2025 10:22:58 +0800
> Xu Yilun <yilun.xu@linux.intel.com> wrote:
> 
> > Allow for the declaration of struct folio * variables that trigger
> > folio_put() when they go out of scope.
> > 
> > Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
> > ---
> >  include/linux/mm.h | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index d16b33bacc32..2456bb775e27 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1425,6 +1425,8 @@ static inline void folio_put(struct folio *folio)
> >  		__folio_put(folio);
> >  }
> >  
> > +DEFINE_FREE(folio_put, struct folio *, if (_T) folio_put(_T))
> 
> Seems like a reasonable addition to me.
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Sorry I'll also drop this one cause I'll drop __free() in tdx core.

> 
> > +
> >  /**
> >   * folio_put_refs - Reduce the reference count on a folio.
> >   * @folio: The folio.
> 

