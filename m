Return-Path: <kvm+bounces-52581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C595FB06F11
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 09:36:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 410FA3B2B6F
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 07:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5B628D8CD;
	Wed, 16 Jul 2025 07:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wcivdutf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84B1289E0B;
	Wed, 16 Jul 2025 07:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752651369; cv=none; b=WdKZXw8vY8PleqQKLq3zIWv2XxsYV8NzxzYi5jg7s8ESR4uDeb0h8KgCbwuvL1kUhFjAoafeY0CwguuWVgcnL42EmDL1o+9aC4Dc+/ssfMOsbqwYuO9ulQDECoLyZpglpNWcs0J7gpoYkCeAfouksofNJqRhG2zWuat/ieb6F9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752651369; c=relaxed/simple;
	bh=SLxwHXEqd1OUWiEYMVIKGR7ibc8WPwr3uMVi8v3Vptw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a3Wy0TUFMUth4bw2g6DQaVAR0NTUpx9Ra6eREI1pkUT6PYDpnO3cJEqGHuYnzN9HRq0MMX+jCX6zcJqZqk7q4FNwYDsWo+zgBrzkIGfUgYrcFg2UZX4ycXNtufUUoeTRCvXZxy5ehVY29Unk0+vUmNIdctBt2N2ot1r0YuRZJ3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wcivdutf; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752651368; x=1784187368;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SLxwHXEqd1OUWiEYMVIKGR7ibc8WPwr3uMVi8v3Vptw=;
  b=WcivdutfNN85F3mKegftkmmAZb+XjPuJfrkFzfKcbSqRtiEm+0FTko9J
   hOKeWXNTHcZYwbhaSUmZ+Mz/KgvW3b2NSNYMxOytV7D6abEHyQ8IIWZUL
   0+cdpXvhCjfFZVIDRWRCwGjf2xJyNIrx3hTKEGQ1LeYUJN+e5v5iC9Yda
   flIFXWihWfs8tV6bsicjiK1hzqYRU15SGcygv1tKOdQsn/mJ2Y9YJkHJ1
   Ql8Vzef3cszNYdPvrbPCXl1AN12E7eGLEiONwhIY3dJnsyiTRDwt3gs79
   7gEEwzFz1kajNIhq3bRVmim/owVAOynUWL5R4u4mXj1h2m5zk8wmLpNnQ
   A==;
X-CSE-ConnectionGUID: bpCP9Rh7ScihEAKqgEQwvQ==
X-CSE-MsgGUID: jBrzcU3ZT/SO6uef5YH9TQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="65458026"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="65458026"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 00:36:06 -0700
X-CSE-ConnectionGUID: hY0dnPHtTOiIv2bf3XuWdg==
X-CSE-MsgGUID: +jK6Yk6xTfOJ47JGHLkZWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="157985544"
Received: from smile.fi.intel.com ([10.237.72.52])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 00:35:51 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1ubwg6-0000000Fr3T-1IQh;
	Wed, 16 Jul 2025 10:35:46 +0300
Date: Wed, 16 Jul 2025 10:35:46 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: WangYuli <wangyuli@uniontech.com>
Cc: airlied@gmail.com, akpm@linux-foundation.org,
	alison.schofield@intel.com, andrew+netdev@lunn.ch,
	arend.vanspriel@broadcom.com, bp@alien8.de,
	brcm80211-dev-list.pdl@broadcom.com, brcm80211@lists.linux.dev,
	colin.i.king@gmail.com, cvam0000@gmail.com,
	dan.j.williams@intel.com, dave.hansen@linux.intel.com,
	dave.jiang@intel.com, dave@stgolabs.net, davem@davemloft.net,
	dri-devel@lists.freedesktop.org, edumazet@google.com,
	gregkh@linuxfoundation.org, guanwentao@uniontech.com, hpa@zytor.com,
	ilpo.jarvinen@linux.intel.com, intel-xe@lists.freedesktop.org,
	ira.weiny@intel.com, j@jannau.net, jeff.johnson@oss.qualcomm.com,
	jgross@suse.com, jirislaby@kernel.org, johannes.berg@intel.com,
	jonathan.cameron@huawei.com, kuba@kernel.org, kvalo@kernel.org,
	kvm@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux@treblig.org,
	lucas.demarchi@intel.com, marcin.s.wojtas@gmail.com,
	ming.li@zohomail.com, mingo@kernel.org, mingo@redhat.com,
	netdev@vger.kernel.org, niecheng1@uniontech.com,
	oleksandr_tyshchenko@epam.com, pabeni@redhat.com,
	pbonzini@redhat.com, quic_ramess@quicinc.com, ragazenta@gmail.com,
	rodrigo.vivi@intel.com, seanjc@google.com, shenlichuan@vivo.com,
	simona@ffwll.ch, sstabellini@kernel.org, tglx@linutronix.de,
	thomas.hellstrom@linux.intel.com, vishal.l.verma@intel.com,
	x86@kernel.org, xen-devel@lists.xenproject.org,
	yujiaoliang@vivo.com, zhanjun@uniontech.com
Subject: Re: [PATCH v2 6/8] serial: 8250_dw: Fix typo "notifer"
Message-ID: <aHdWUu58e_nCadX4@smile.fi.intel.com>
References: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
 <2BF1749F02ADE664+20250715134407.540483-6-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2BF1749F02ADE664+20250715134407.540483-6-wangyuli@uniontech.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Jul 15, 2025 at 09:44:05PM +0800, WangYuli wrote:
> There is a spelling mistake of 'notifer' in the comment which
> should be 'notifier'.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko



