Return-Path: <kvm+bounces-56257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F2B4B3B43C
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 09:29:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 739FD1B2613D
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 07:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 220A626B76C;
	Fri, 29 Aug 2025 07:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NLqm+KPV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B6026A0D5
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 07:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756452534; cv=none; b=s/dje5U2j7yM+KOvfNVkFUcaZwxakMt8lbYOFlQWKFPBkwNjpriemws4pBX5ed4L7OwZeJVzRzLII760fvDlpvB4vhLSGPdLt5EpOxPujSbQpnoMuu4P1Xt8qgAFs3SKH2l1Wr2pLQLI0E1OOrqwzuq6AORmEsDQTOo0j4hsucE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756452534; c=relaxed/simple;
	bh=XDoflb1z6uV+m7t5bBomDLPKLaOuGR6Fg/aQ7zz+4+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iPy8PJKWVETiIHsKm0/i8J23jM70WfLIqtgE7pknoAfK9Oc4WziMoITd7SbQTFOLoJIWCK7YwD6aa+211v7HDhY9IXS0TefGvPZfLefrO285ywcFuMiZGb/HqRHFso0y3IqHilB3P7GNOwLAYeBmqAZJFqc/Cm81/q1JGR9tCWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NLqm+KPV; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756452534; x=1787988534;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XDoflb1z6uV+m7t5bBomDLPKLaOuGR6Fg/aQ7zz+4+w=;
  b=NLqm+KPVgIfMITxymU2QrBQrzdLr8UceXaEv9ffXqEKymOuEmWkENlsO
   pywHX1Sd667LNh88FHzv1pNNb8R5aZXvUuavi+4+5VhiL+5rjsDTz8NIr
   OaF5K8MHRqNzA5tQp5SdSposXtB9LIOxkA1vcW0rz/4lEriGIvRU+3k7Q
   kMGsHIkObC5xw1NMSmGnC4y8LjecwEY2xWO7PmdY/rCwzOB8ewH0JiSEu
   29Sp6u4XT4m+rMlIWXN+5Pi71AATDnGCm0f6QJ8DbY08hvlgUiAEdWT74
   pU5v0UbOQPNLwcqsHVc4p0M94NwMohmd85+axx1rAzNY218zAt8kIDP7X
   Q==;
X-CSE-ConnectionGUID: GPLOsD4ATzS5kG/38y+FYQ==
X-CSE-MsgGUID: UIDyO4u1TNCTkif6LUBwNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62566889"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62566889"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 00:28:53 -0700
X-CSE-ConnectionGUID: qhGLGVW3QEeWU8Jwc5YdXg==
X-CSE-MsgGUID: 2oiBc1k7SU2dBDFinzNngg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="169843616"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa007.fm.intel.com with ESMTP; 29 Aug 2025 00:28:46 -0700
Date: Fri, 29 Aug 2025 15:50:33 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
	kvm@vger.kernel.org, aharivel@redhat.com
Subject: Re: [PATCH 2/2] vfio scsi ui: Error-check
 qio_channel_socket_connect_sync() the same way
Message-ID: <aLFbyaluXSmmhUFk@intel.com>
References: <20250723133257.1497640-1-armbru@redhat.com>
 <20250723133257.1497640-3-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723133257.1497640-3-armbru@redhat.com>

On Wed, Jul 23, 2025 at 03:32:57PM +0200, Markus Armbruster wrote:
> Date: Wed, 23 Jul 2025 15:32:57 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: [PATCH 2/2] vfio scsi ui: Error-check
>  qio_channel_socket_connect_sync() the same way
> 
> qio_channel_socket_connect_sync() returns 0 on success, and -1 on
> failure, with errp set.  Some callers check the return value, and some
> check whether errp was set.
> 
> For consistency, always check the return value, and always check it's
> negative.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>  hw/vfio-user/proxy.c     | 2 +-
>  scsi/pr-manager-helper.c | 9 ++-------
>  ui/input-barrier.c       | 5 +----
>  3 files changed, 4 insertions(+), 12 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


