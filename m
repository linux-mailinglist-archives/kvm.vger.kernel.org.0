Return-Path: <kvm+bounces-20090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA4A091083F
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:30:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94E9C282952
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 14:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4EF91AE09B;
	Thu, 20 Jun 2024 14:29:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131151AD9E6;
	Thu, 20 Jun 2024 14:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718893793; cv=none; b=K5ZK5o/dBKuhXl0YVELc8luAASinvLtkCVYcNJDG+5onRVSaKQYGFF84lCppCRjMcKEV+DyFPYGsy6N4deMcg/PCwANQfegW1jJgc7DNA465f2FlPRh0EzTbOwa5yAcq3Oi4W7fx4kpfzAZR/e9XBDNDDT0TowzYmkMLbIfCL6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718893793; c=relaxed/simple;
	bh=SRU2NdFqSqSkLqzcm3STPgO2LKecOnhkgE7HzUBHCTU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=crXLe0BdEIXv4hFYyAcZC+OhE7eAf6Ehpl8aQz9HZocEbjpws0NnAlZUSE5EdnYpdvK8Q98RcxQdLPJSQDlevk3YYfvXah6fqjmcnaeuOBQkdkcfJxxkDEkoE2wMvU7KyE26yYtcvQPwrDKmFPv+FW2ndfHKeKH9m3sviyqYatw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4W4jYn1xfsz4wbr;
	Fri, 21 Jun 2024 00:29:49 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com, Gautam Menghani <gautam@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Naveen N Rao <naveen@kernel.org>, Vaibhav Jain <vaibhav@linux.ibm.com>
In-Reply-To: <20240520175742.196329-1-gautam@linux.ibm.com>
References: <20240520175742.196329-1-gautam@linux.ibm.com>
Subject: Re: [PATCH v9] arch/powerpc/kvm: Add support for reading VPA counters for pseries guests
Message-Id: <171889374980.827284.11720698970898625071.b4-ty@ellerman.id.au>
Date: Fri, 21 Jun 2024 00:29:09 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Mon, 20 May 2024 23:27:40 +0530, Gautam Menghani wrote:
> PAPR hypervisor has introduced three new counters in the VPA area of
> LPAR CPUs for KVM L2 guest (see [1] for terminology) observability - 2
> for context switches from host to guest and vice versa, and 1 counter
> for getting the total time spent inside the KVM guest. Add a tracepoint
> that enables reading the counters for use by ftrace/perf. Note that this
> tracepoint is only available for nestedv2 API (i.e, KVM on PowerVM).
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/1] arch/powerpc/kvm: Add support for reading VPA counters for pseries guests
      https://git.kernel.org/powerpc/c/e1f288d2f9c69bb8965db9fb99a19b58231a00dd

cheers

