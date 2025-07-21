Return-Path: <kvm+bounces-52982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E1EB8B0C590
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 15:53:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41D184E3264
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 13:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 307392D97B6;
	Mon, 21 Jul 2025 13:53:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1999D288CBC
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 13:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753105980; cv=none; b=eg5tOWVlcIq355vg33soQM8V/QevF+D2LL1QnIKLevilRAxui9XYUWeJnwG3iLdMFHHiy6xTXsU1fajGUJ7Ty+8aIIXVSOJ+XWJPc39ZEw8sHka28Ivo/s17g2QqYpgK5mGTRNY0dzyDyNuTAm4IndojXOkL8+LOwp7InjU50kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753105980; c=relaxed/simple;
	bh=qpeSfYxKwAjwjoxGWaw8L97AAHuomKZmHTsR2SgOeb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tQzEKejRxsLvSkJkrvYyCEjICIJ4oXBWkt0eeL32x3QV2VLwXThC6ItFnqrgf0MSpWzz4TXb2aMQvUQ11JttoVi4raAX4PNfSPemlY2dlUGp3GnES2Idol3frTgY3iec2A4hf2LMhumX5Bv7eIu7ATfEM9hhV90k+EWVJ6JZmvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A639C153B;
	Mon, 21 Jul 2025 06:52:52 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43CA93F66E;
	Mon, 21 Jul 2025 06:52:55 -0700 (PDT)
Date: Mon, 21 Jul 2025 14:52:52 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/7] arm64: Add capability denoting FEAT_RASv1p1
Message-ID: <aH5GNCKboWSYq8nS@arm.com>
References: <20250721101955.535159-1-maz@kernel.org>
 <20250721101955.535159-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250721101955.535159-2-maz@kernel.org>

On Mon, Jul 21, 2025 at 11:19:49AM +0100, Marc Zyngier wrote:
> Detecting FEAT_RASv1p1 is rather complicated, as there are two
> ways for the architecture to advertise the same thing (always a
> delight...).
> 
> Add a capability that will advertise this in a synthetic way to
> the rest of the kernel.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

