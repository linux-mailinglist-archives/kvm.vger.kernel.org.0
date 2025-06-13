Return-Path: <kvm+bounces-49527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CFDC5AD96AD
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:53:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A894B3BD694
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EF62253B67;
	Fri, 13 Jun 2025 20:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pVR5GWgk"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D1C24A069
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 20:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749848009; cv=none; b=IU4EY8iZ5ySJ/eP3pr0iM6Q4dxlV6O96Omc0MbwyxqaPf5H5WnkH1PhVQbKC3cQApIQUzX9DYCeJWD2jKbhvfM9VxaK6+KbxruwydWmrNo8vZ94hbNuish3b/EaNx0AQb9j/gk6KHk27/OOe//3MAiltEGmup3lSvmdqTFH1VJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749848009; c=relaxed/simple;
	bh=B5/IFja4RVVEVHRpLRymgFk1+5qawt7Y2fr5pwUM4K4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pEN8FP/sXQp0UVnSHTuB0DXl0rC16A2Kj2f9MUXjCTrzwvOlsjQSs+Ht52G5FfmyiIZvB/s48+fA5wex7RPLralOZ4FcfH4h7TekO/SEmeD0Fw53wyeRLbRc3OXKkFzwN5uHxfKVcLZ6B8HMs+gg/Nayxlw0EuyYELpVRum2fgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pVR5GWgk; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 13 Jun 2025 13:53:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749847991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fKlTMyrwwqDx/wAU3aYigDU8KWuXM98SDm/vlqdsd+M=;
	b=pVR5GWgkNqzsvtdbkN7JjzMCt22LvsxgOGhb/+msVanV1s7cBRUoJZ6bsNyRtYMjiXXiS3
	Jq95S+FMYqTB1feRQVAKEXu5wBaWE70jcJPnTo+rKRHdUgxmCbgd5muA55kq8S8KAcj3Ev
	bzi2e9zImCp9gL0sj9glDsWQV/2sN1A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Mingwei Zhang <mizhang@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/4] KVM: arm64: Add attribute to control
 GICD_TYPER2.nASSGIcap
Message-ID: <aEyPswyvfJ2-oC3l@linux.dev>
References: <20250613155239.2029059-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613155239.2029059-1-rananta@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 13, 2025 at 03:52:34PM +0000, Raghavendra Rao Ananta wrote:
> A shortcoming of the GIC architecture is that there's an absolute limit on
> the number of vPEs that can be tracked by the ITS. It is possible that
> an operator is running a mix of VMs on a system, only wanting to provide
> a specific class of VMs with hardware interrupt injection support.
> 
> The series introduces KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap vGIC attribute to allow
> the userspace to control GICD_TYPER2.nASSGIcap (GICv4.1) on a per-VM basis.
> 
> v1: https://lore.kernel.org/kvmarm/20250514192159.1751538-1-rananta@google.com/
> 
> v1 -> v2: https://lore.kernel.org/all/20250531012545.709887-1-oliver.upton@linux.dev/
>  - Drop all use of GICv4 in the UAPI and KVM-internal helpers in favor
>    of nASSGIcap. This changes things around to model a guest feature,
>    not a host feature.
> 
>  - Consolidate UAPI into a single attribute and expect userspace to use
>    to read the attribute for discovery, much like we do with the ID
>    registers
> 
>  - Squash documentation together with implementation
> 
>  - Clean up maintenance IRQ attribute handling, which I ran into as part
>    of reviewing this series
> 
> v2 -> v3:
>  - Update checks in vgic-v3.c and vgic-v4.c to also include nASSGIcap (via
>    vgic_supports_direct_sgis()) that's configured by the userspace. (Oliver)
> 
> Oliver Upton (2):
>   KVM: arm64: Disambiguate support for vSGIs v. vLPIs
>   KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling

Make sure you run checkpatch next time before sending out, it should've
warned you about sending patches w/o including your SOB.

Thanks,
Oliver

