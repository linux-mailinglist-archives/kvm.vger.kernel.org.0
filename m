Return-Path: <kvm+bounces-145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 923B17DC37F
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 01:20:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6071A1C20BB4
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 00:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71B20382;
	Tue, 31 Oct 2023 00:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tb7dmYJa"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A1A363
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 00:20:08 +0000 (UTC)
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D54101
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 17:20:06 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698711604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rnvNwstApga/n5Q/VR2tMhWzCGL++TvXQJTFi268TAQ=;
	b=tb7dmYJawd7xZag82S3GdIw9dUQf08z8neaS0bUOBQcSQpQ8yLZP3eS+pV0g4qm0m6GinS
	pr+PAJGWFdkOE27i5pqSVlk16cZYW04UqkTGvYVsvZz8OvZjeEhQEDr5dBhoeZl9vcEmvz
	xZSpvNfy7X+Y+AGzMopsgVoPLhaaX1g=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	kvm@vger.kernel.org,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 0/2] tools: Makefile fixes for sysreg generation
Date: Tue, 31 Oct 2023 00:19:19 +0000
Message-ID: <169871155376.54520.13627627149376112404.b4-ty@linux.dev>
In-Reply-To: <20231027005439.3142015-1-oliver.upton@linux.dev>
References: <20231027005439.3142015-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 27 Oct 2023 00:54:37 +0000, Oliver Upton wrote:
> Fixing a couple of issues in the Makefile changes required to get sysreg
> generation working.
> 
> Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> Cc: Aishwarya TCV <aishwarya.tcv@arm.com>
> 
> Oliver Upton (2):
>   tools: arm64: Fix references to top srcdir in Makefile
>   KVM: selftests: Avoid using forced target for generating arm64 headers
> 
> [...]

Applied to kvmarm/next, thanks!

[1/2] tools headers arm64: Fix references to top srcdir in Makefile
      https://git.kernel.org/kvmarm/kvmarm/c/fbb075c11663
[2/2] KVM: selftests: Avoid using forced target for generating arm64 headers
      https://git.kernel.org/kvmarm/kvmarm/c/70c7b704ca72

--
Best,
Oliver

