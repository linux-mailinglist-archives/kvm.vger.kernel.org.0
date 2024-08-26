Return-Path: <kvm+bounces-25048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C5A195EEC1
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 12:46:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 532ED1F23275
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 10:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7BD14D2A7;
	Mon, 26 Aug 2024 10:46:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C8639ACC;
	Mon, 26 Aug 2024 10:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724669176; cv=none; b=YuoBw+3eYVNpHa9U4sP5ctGVE2jo52TSDIY/umZSv2cKr0DZXr03AurBvxxaNGuTfJ0XWXN1CdVFpTERt9rh0aVsixHH3VJ5+eDeIVFbqtHFD2W+fNnnlREI2JSbPFJguiKJFDPsaXenfBJiXqCTA2gSaX8ecK+vPLjiSHnIYuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724669176; c=relaxed/simple;
	bh=XAj4Tq5MjaiO37oruDpqrEgc3uF2VimxxQHdGrtWnDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fI8hblSWxu3OFSiHiNMMeJPn2RS3z8HibO7BsBgmPXYJLgn6xEFU50HmpoNnIzCeJMKEro8AdZz+prEKvrijAWaRkC+a3mKCUxfGWAsVxBuvhpOYJJfQEbOPmBSM4HNTMqmodvZS6LVtZCtkJJ0dOams01Mb424JmV8GcBD8T4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9AFC51404;
	Mon, 26 Aug 2024 10:46:10 +0000 (UTC)
Date: Mon, 26 Aug 2024 13:46:19 +0300
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v5 16/19] arm64: Enable memory encrypt for Realms
Message-ID: <Zsxc-wqGaQLpyO-W@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-17-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819131924.372366-17-steven.price@arm.com>

On Mon, Aug 19, 2024 at 02:19:21PM +0100, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Use the memory encryption APIs to trigger a RSI call to request a
> transition between protected memory and shared memory (or vice versa)
> and updating the kernel's linear map of modified pages to flip the top
> bit of the IPA. This requires that block mappings are not used in the
> direct map for realm guests.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Co-developed-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

