Return-Path: <kvm+bounces-34502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB5EB9FFF4C
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 20:15:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C94EC1883BE8
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 19:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4B831B6D0B;
	Thu,  2 Jan 2025 19:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PRLFCIVZ"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36AE1B4F3D
	for <kvm@vger.kernel.org>; Thu,  2 Jan 2025 19:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735845319; cv=none; b=H4FGsvsF4SNXZ1DPej0VpxdkyZ687afQiNCN7PyPBifEBjc/2fLI/nRoRN/HxWEMRfuqnhnORsHv96qVxmHgA5vGc2QW1SJpRZjZnmrrToLFdgOVccXyRBjiI7Q0iy2oRYqWChgDmMnVZHjHBbFWHKVlFlOFp1ojfpIAnNabeUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735845319; c=relaxed/simple;
	bh=K0Bq/LpjtP4wPfZSKsasYBHe+rHjQB7D3W09Uj9kqsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bYKNBVW+QZ193FviB+7z6B9jh4L123zMYCbbSqzoI8HzSUQ5AgiloIaEI+J6TfnBs5Sc2WpRJXEohJNjHptx+7OceXMNkSpdfi+u5+t/gzUmg07yQbM6HHJmyWKvVsg4MPcdXb3I1/Wu0KMG5zy4x54m4HwuRPTYJvGvlokCBcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PRLFCIVZ; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 2 Jan 2025 11:15:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735845314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MUdOeCCuXTYBJa2Y14aYbmR7lqycVvovev0PA0FkkeM=;
	b=PRLFCIVZNJ2TOKznSd93zqgxpqnVt9wA3U7ums0392W1LkplKZ4eJ2vjkNvPK2mrhcQ0Zo
	dsqhqrcpHM36uCRoKEZmwO7hwRb4MGvbdBqU9E/Ho6HvqOL/Eh+3T2FBrvVS9YK6Xaq3Cp
	8BvA1LJ6AZiCVmuvDB2/g5/8Y/9r7Io=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>
Subject: Re: [PATCH v2 00/12] KVM: arm64: Add NV timer support
Message-ID: <Z3blvPxzCxVeCA40@linux.dev>
References: <20241217142321.763801-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217142321.763801-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 17, 2024 at 02:23:08PM +0000, Marc Zyngier wrote:
> Here's another version of the series initially posted at [1], which
> implements support for timers in NV context.
> 
> From v1:
> 
> - Repainted EL0->EL1 when rambling about the timers
> 
> - Simplified access to EL1 counters from HYP context
> 
> - Update the status register when handled as an early trap
> 
> - Added some documentation about the default PPI numbers
> 
> The whole thing has been tested with 6.13-rc3 as part of the my NV
> integration branch [2], and is functional enough to run an L3 guest
> with kvmtool as the VMM and EDK2 as the firmware. YMMV.
> 
> [1] https://lore.kernel.org/r/20241202172134.384923-1-maz@kernel.org
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-next

Time to let it rip!

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

