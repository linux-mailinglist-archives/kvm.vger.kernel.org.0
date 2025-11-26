Return-Path: <kvm+bounces-64651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AF84C898FE
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 12:39:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 217224E6AB5
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 11:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2E13246EC;
	Wed, 26 Nov 2025 11:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mnJd+THi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02683242D5;
	Wed, 26 Nov 2025 11:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764157125; cv=none; b=BQcaGhEEbkphQFH4eKR4oENHj8Y3thN6tScYmmxMZoKQK9tOSoG1vx8Mswy3W3rq79nB+7O0WGokHoIwXywg4qVzV7NppX5HIhDRq1avWnBBD1kJJtSuHawErOjRf0JyM9r24/bY/O8R98NiVcjiVmQu6VruHLLOXUuiY9ZOY0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764157125; c=relaxed/simple;
	bh=8Ci9qIas4o7sPCdSNP+D4JZKN0W53oO/eb7N06IRCks=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BimCCgmQ5Hqo4nH8KabFXfO2uVibdGwyYObBqeWXKdImbaItp3A+Z2Bc2seD68LO6EUm5znX93eh/N2cWbD3T9mk004SbkYO+kPU756m6k6ufxtH+vNz+/7EmHzKwITjEwklrFHTxTgJoBERtJDpkiJ5XlqxPJWu9s42a63EdQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mnJd+THi; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764157122; x=1795693122;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=8Ci9qIas4o7sPCdSNP+D4JZKN0W53oO/eb7N06IRCks=;
  b=mnJd+THinkgrXjVHFko7i1ETrV57ZoaRiKlJcU0vpvLfQY4hJHqsfS1O
   UonPjme1aYNtS6XQOhkOo8w5qUCj4gzDtIolF3RsR8hhZCYOt/m35a29k
   L0nwLoneNH06ZLq5y+KtsBtDQG1ikNh6w/CK1LVVd2SI/ofndWJWIyHB1
   b7XazRXcKQEa5n0MEQYnvrczc9PhJcydmXo70MYuyesS0BHyr4I95M8m+
   yCe0gp5Uf92UfaYVB7ZvDJpq4TUR+F0CuFQAzWUwKjoIvJrtdnWPbLQxL
   zmfSTgEyJpMYdBKYQ6EtOm8YyriEXoxsG6ru9Hb6rKf01p/UGrqfRIRmE
   Q==;
X-CSE-ConnectionGUID: 1KmXnDkqQMmXgGq2qTZSPQ==
X-CSE-MsgGUID: oAaAonKWQfS6jYR+oATqTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="66223740"
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="66223740"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 03:38:41 -0800
X-CSE-ConnectionGUID: ISg4W5Y1Qo+YgZq7Xm+gjw==
X-CSE-MsgGUID: WXccPcVMQwGjwSI2KXdLEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="192567071"
Received: from abityuts-desk.ger.corp.intel.com (HELO [10.245.245.127]) ([10.245.245.127])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 03:38:36 -0800
Message-ID: <c5f1344daeec43e5b5d9e6536c8c8b8a13323f7a.camel@linux.intel.com>
Subject: Re: [PATCH v6 0/4] vfio/xe: Add driver variant for Xe VF migration
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Matthew Brost <matthew.brost@intel.com>, Alex Williamson
 <alex@shazbot.org>
Cc: =?UTF-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>, Lucas De
 Marchi <lucas.demarchi@intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Jason Gunthorpe	 <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin
 Tian	 <kevin.tian@intel.com>, Shameer Kolothum <skolothumtho@nvidia.com>, 
	intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Michal Wajdeczko <michal.wajdeczko@intel.com>, 
	dri-devel@lists.freedesktop.org, Jani Nikula <jani.nikula@linux.intel.com>,
  Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie	 <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Lukasz Laguna	 <lukasz.laguna@intel.com>, Christoph
 Hellwig <hch@infradead.org>
Date: Wed, 26 Nov 2025 12:38:34 +0100
In-Reply-To: <aSZVybx3cgPw6HQh@lstrano-desk.jf.intel.com>
References: <20251124230841.613894-1-michal.winiarski@intel.com>
	 <20251125131315.60aa0614.alex@shazbot.org>
	 <aSZVybx3cgPw6HQh@lstrano-desk.jf.intel.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-2.fc41) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-11-25 at 17:20 -0800, Matthew Brost wrote:
> On Tue, Nov 25, 2025 at 01:13:15PM -0700, Alex Williamson wrote:
> > On Tue, 25 Nov 2025 00:08:37 +0100
> > Micha=C5=82 Winiarski <michal.winiarski@intel.com> wrote:
> >=20
> > > Hi,
> > >=20
> > > We're now at v6, thanks for all the review feedback.
> > >=20
> > > First 24 patches are now already merged through drm-tip tree, and
> > > I hope
> > > we can get the remaining ones through the VFIO tree.
> >=20
> > Are all those dependencies in a topic branch somewhere?=C2=A0 Otherwise
> > to
> > go in through vfio would mean we need to rebase our next branch
> > after
> > drm is merged.=C2=A0 LPC is happening during this merge window, so we
> > may
> > not be able to achieve that leniency in ordering.=C2=A0 Is the better
> > approach to get acks on the variant driver and funnel the whole
> > thing
> > through the drm tree?=C2=A0 Thanks,
>=20
> +1 on merging through drm if VFIO maintainers are ok with this. I've
> done this for various drm external changes in the past with
> maintainers
> acks.
>=20
> Matt

@Michal Winiarski

Are these patches depending on any other VFIO changes that are queued
for 6.19?=20

If not and with proper VFIO acks, I could ask Dave / Sima to allow this
for drm-xe-next-fixes pull. Then I also would need a strong
justification for it being in 6.19 rather in 7.0.

Otherwise we'd need to have the VFIO changes it depends on in a topic
branch, or target this for 7.0 and hold off the merge until we can
backmerge 6.9-rc1.

Thanks,
Thomas


>=20
> >=20
> > Alex


