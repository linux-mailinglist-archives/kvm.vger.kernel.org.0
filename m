Return-Path: <kvm+bounces-42042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A8AFA71EA8
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:51:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2954F7A653A
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 18:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09FF124EF73;
	Wed, 26 Mar 2025 18:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MSZ7FCH4"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A1317F7
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 18:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743015110; cv=none; b=o+i6+S/RuP0WOsQZUBCK+SSLIPr4Q5zEoSd3NbyvBXSrf3TvPd/HKlr0xhh2mzVD2qv0t5zlvmrwHItCkOQv9OD29E61Vak9MdHcifkFnW2HL2KwlZRY5cu52ttlfzEnCxcSfbBKnUfCjPvxpis9Bhf6RN5WvmISCB6TReG+CrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743015110; c=relaxed/simple;
	bh=lrUgJMih6ZTpw55f6DR9oOLtoyDL+/x9zkHA2LrqQw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pduU9cN+al9UiXFHmHENDZ9o5EisqLqomJEqrE5xuSkGEVoSCPH0jsZZBjGdqindFkZ2c+8AzW9kznB6EM4XuFOXfryareJV7BbcbDtEVXvQ6FZxyXo/8Fj4JCVxHLelslPDe38aSBV2ZC+PdkGWv8Hop/Cl7eZvNwiLUVgZtyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MSZ7FCH4; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 26 Mar 2025 19:51:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743015104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=voLt4fdXkebJ8L5qGd4jfGNS1skgHWQ+LCozPmJP+KU=;
	b=MSZ7FCH4Xov8R8XeH4gys0oHruqKkh9bTmrsyVLsIIO6DS06RHAmdvtLm3jLtsNmzDx3vs
	Fk09iJ8yU1xL+QQDBL4dynEcNxydkaLNMuMva01esQVZviti/FdEOsycKLf8xy5FNoZKRt
	I2jds9vfmYQybdHRoddC0bHmDmg7fBU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 0/5] arm64: Change the default QEMU CPU
 type to "max"
Message-ID: <20250326-adedac8bee1bcff68cb0b849@orel>
References: <20250325160031.2390504-3-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325160031.2390504-3-jean-philippe@linaro.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 25, 2025 at 04:00:28PM +0000, Jean-Philippe Brucker wrote:
> This is v3 of the series that cleans up the configure flags and sets the
> default CPU type to "max" on arm64, in order to test the latest Arm
> features.
> 
> Since v2 [1] I moved the CPU selection to ./configure, and improved the
> help text. Unfortunately I couldn't keep most of the Review tags since
> there were small changes all over.
> 
> [1] https://lore.kernel.org/all/20250314154904.3946484-2-jean-philippe@linaro.org/
> 
> Alexandru Elisei (3):
>   configure: arm64: Don't display 'aarch64' as the default architecture
>   configure: arm/arm64: Display the correct default processor
>   arm64: Implement the ./configure --processor option
> 
> Jean-Philippe Brucker (2):
>   configure: Add --qemu-cpu option
>   arm64: Use -cpu max as the default for TCG
> 
>  scripts/mkstandalone.sh |  3 ++-
>  arm/run                 | 15 ++++++-----
>  riscv/run               |  8 +++---
>  configure               | 55 +++++++++++++++++++++++++++++++++++------
>  arm/Makefile.arm        |  1 -
>  arm/Makefile.common     |  1 +
>  6 files changed, 63 insertions(+), 20 deletions(-)
> 
> -- 
> 2.49.0

Thanks Jean-Philippe. I'll let Alex and Eric give it another look, but
LGTM.

drew

