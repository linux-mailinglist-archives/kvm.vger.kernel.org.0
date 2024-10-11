Return-Path: <kvm+bounces-28629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA78D99A4F4
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 15:24:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD0051C22EE3
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 13:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0668E219C8E;
	Fri, 11 Oct 2024 13:23:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBAB20CCE6;
	Fri, 11 Oct 2024 13:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728653032; cv=none; b=nUe9vB2rq02I0QylSs1yLhty6Do8Sya8hhqXwuXn2SFrxX6UKKAHdtN6uw6n0IkEwueTXtCKINR3yeBTmmb3ETVpMP/Rm54XmzX3fKHnhHhXp12i5RkTVp0DYkkxKVmNaCJtJ3Z1HqYSbLvcgHWaBcM7PziKLwpFddjDNE6nC5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728653032; c=relaxed/simple;
	bh=V2udko9ZAVBT/JZE9LFiU8HdpgIsV8hZNZ16ZvW3CpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYV3R+ZKGFp17iYsNjQKHXkbmvi4y0cA+bjSXjuh+oAR/coAFBHTmwwqz+zTNpFy7XWjmVo3rnlyPsYcmwqIE7oZ5u5pXSPSWz0CWLK3W4PF6+fGcpG7Jg4QNfWPhrj7X5ffbpxXIU/VgaCmEFEXbkOfdiRfYnTnRFyGDUN3NR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B39CC4CECE;
	Fri, 11 Oct 2024 13:23:48 +0000 (UTC)
Date: Fri, 11 Oct 2024 14:23:46 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [PATCH v6 06/11] efi: arm64: Map Device with Prot Shared
Message-ID: <Zwkm4v5aeUai7hcH@arm.com>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-7-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004144307.66199-7-steven.price@arm.com>

On Fri, Oct 04, 2024 at 03:43:01PM +0100, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Device mappings need to be emulated by the VMM so must be mapped shared
> with the host.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

