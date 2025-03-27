Return-Path: <kvm+bounces-42133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89710A73A45
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 18:17:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B9B03B318A
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 17:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE081B424D;
	Thu, 27 Mar 2025 17:17:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B46ED1ACEDE
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 17:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743095868; cv=none; b=FtbPq7eh4loJe9XePb2k8BENGyb9dFnJIjpQy8xVjAdVubMYpFalYtJaVE3ajk84cet96yFbM+8eVMXLZPuinM/7BUq+StRAWVvM/hm22kdg7Idlr6MXuc6hzoXipP7tYeQcpPoz5zIzw6NYQfZOdtIkxS8ujgdKD0GjAhEmDi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743095868; c=relaxed/simple;
	bh=ogOxqBm3/eXJ9AOkoCDmQbnGw/qiw68s2TZc94SMbTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oFr8Wye1kyC2QmdidI6SFOHHNvaALgBNJMFQtBWrgn7RcCtdEvi4xqHRUziAOAlKy3z6eUJafXGA1BTIBk1OsPBBIYi7SjcguK7m4EdJXA2GBO64O0am8FSSydysTUibhHYsvT8PFQjM2Zud6DRS+T8u6WStrcmnEJy8+3xiC/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3DEF31063;
	Thu, 27 Mar 2025 10:17:51 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D98EB3F63F;
	Thu, 27 Mar 2025 10:17:44 -0700 (PDT)
Date: Thu, 27 Mar 2025 17:17:42 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, eric.auger@redhat.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 0/5] arm64: Change the default QEMU CPU
 type to "max"
Message-ID: <Z-WINviy8d6_xKpE@raptor>
References: <20250325160031.2390504-3-jean-philippe@linaro.org>
 <20250326-adedac8bee1bcff68cb0b849@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326-adedac8bee1bcff68cb0b849@orel>

Hi Drew,

On Wed, Mar 26, 2025 at 07:51:35PM +0100, Andrew Jones wrote:
> On Tue, Mar 25, 2025 at 04:00:28PM +0000, Jean-Philippe Brucker wrote:
> > This is v3 of the series that cleans up the configure flags and sets the
> > default CPU type to "max" on arm64, in order to test the latest Arm
> > features.
> > 
> > Since v2 [1] I moved the CPU selection to ./configure, and improved the
> > help text. Unfortunately I couldn't keep most of the Review tags since
> > there were small changes all over.
> > 
> > [1] https://lore.kernel.org/all/20250314154904.3946484-2-jean-philippe@linaro.org/
> > 
> > Alexandru Elisei (3):
> >   configure: arm64: Don't display 'aarch64' as the default architecture
> >   configure: arm/arm64: Display the correct default processor
> >   arm64: Implement the ./configure --processor option
> > 
> > Jean-Philippe Brucker (2):
> >   configure: Add --qemu-cpu option
> >   arm64: Use -cpu max as the default for TCG
> > 
> >  scripts/mkstandalone.sh |  3 ++-
> >  arm/run                 | 15 ++++++-----
> >  riscv/run               |  8 +++---
> >  configure               | 55 +++++++++++++++++++++++++++++++++++------
> >  arm/Makefile.arm        |  1 -
> >  arm/Makefile.common     |  1 +
> >  6 files changed, 63 insertions(+), 20 deletions(-)
> > 
> > -- 
> > 2.49.0
> 
> Thanks Jean-Philippe. I'll let Alex and Eric give it another look, but
> LGTM.

Looks good to me too, just two nitpicks, not sure if it's worth respining just
for them, or if you want to make the changes when you apply the patches (or just
ignore them, that's fine too!).

Thanks,
Alex

