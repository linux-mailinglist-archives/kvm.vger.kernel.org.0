Return-Path: <kvm+bounces-11065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E5308727FC
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 20:50:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 346221F2936E
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 19:50:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65CAA86644;
	Tue,  5 Mar 2024 19:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WqPxyIUv"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450025C5FD
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 19:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709668190; cv=none; b=GgiNuL0Mt3PdXi9zhGUVx0GuBS+rI9RdqLQbAx+zoKLrvL4X/+hrAl+dzWheOQ6tKZ7NRVSzLv0AbZUF7zN7pob9YdsCLCvcAY+jZ2ii4jsoPBBfR0pWMa/LpGD8qnBs0u3Yl0yWgQN/FNuWK72pgQ8I5tB5aZYud12R3oMft5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709668190; c=relaxed/simple;
	bh=+WKDowJ/Vyo6jEXEBn5BtLH+g7pYLXM9AnPMMTv2bzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tqe5BHhEiz5+D9cWAFZovgsqdU1HAs7NFLdoQtSS9N1ghsw6nqrHmlh4dbrzYCQFP1ccp6MyzRHjgBXT9a9s6Mkt6Z0R3HDGVMh7ihm2mLCMNNB+JhR982oO0DRRLW7FFjs5iK7Q1fiFLmELq+fbodGQOVmXBOAWOSB4zhtTwtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WqPxyIUv; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 5 Mar 2024 19:49:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709668185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z6IK7WTxYDII1ZZxniDW+JY/tgmWm66Vu1jWnH6jiRw=;
	b=WqPxyIUvJbTV79UAzinYrjAvZXcW8HGl7VrNMOVbVNT/0O7k1Ewhrkj5Ft8HkntmqFn9WS
	JHT1SKWyIbrYqUns5W/KZ59IJHyxbMfCHyIhGc9v8olorlZhcdLkBtlGGf0oPRs4YkEdtf
	MNPL9vXFLouuU/C4RYbgpz6yz2+9KEc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Krister Johansen <kjlx@templeofstupid.com>
Cc: stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 5.15.y 0/2] fix softlockups in stage2_apply_range()
Message-ID: <Zed3T8SGyIkvW-Ru@linux.dev>
References: <cover.1709665227.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1709665227.git.kjlx@templeofstupid.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 05, 2024 at 11:41:38AM -0800, Krister Johansen wrote:
> Hi Stable Team,
> In 5.15, unmapping large kvm vms on arm64 can generate softlockups.  My team has
> been hitting this when tearing down VMs > 100Gb in size.
> 
> Oliver fixed this with the attached patches.  They've been in mainline since
> 6.1.
> 
> I tested on 5.15.150 with these patches applied. When they're present,
> both the dirty_log_perf_test detailed in the second patch, and
> kvm_page_table_test no longer generate softlockups when unmapping VMs
> with large memory configurations.
> 
> Would you please consider these patches for inclusion in an upcoming 5.15
> release?

Backport looks fine, and I have no issues with this going to stable if
it helps folks.

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

