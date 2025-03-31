Return-Path: <kvm+bounces-42276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 268EAA770AE
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 00:02:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFA07163089
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 22:02:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE1BD21B9FC;
	Mon, 31 Mar 2025 22:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZLMTdS0C"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B11B43AA9;
	Mon, 31 Mar 2025 22:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743458544; cv=none; b=a0kekxlWic2J1vq5GkXmsr0KITCayBSlV+YjULagMM9360br/imSGdlpq5aiJzv/7Q9QGu4V7lpa84QJrBimUVXNtu+CDYi1odBlGiVvbYAS5/ul4Hjut4jXpeiLjiEglYdNS9sSu16kJ/JD3vPpFg8vzM+6vZBYn+dM+KrImwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743458544; c=relaxed/simple;
	bh=CbMsbTVguH+ElYJBx3ecoV42eLuWTt+NiKz5ex7ATOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PNVofvpWcZVgHEU1v6Fwu7J9p9TlCgLoTMZ5Kua/PyAcaPAJn3CIYJMR9bpdxnKY0nsSe9+sZaL8J+WqnQSzHu9IUsjD8EFuR1ILtZ3jE2O0X9s6AYcSKJAqf7+6MIHZvB9snrpKPHk92vX2nrqk7KSfWL4EPyMWGfByS2aUmDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZLMTdS0C; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6130C4CEE3;
	Mon, 31 Mar 2025 22:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743458543;
	bh=CbMsbTVguH+ElYJBx3ecoV42eLuWTt+NiKz5ex7ATOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZLMTdS0CUAr/UVjDj9ha7WjMsC8+9MwjKiQVn3nzBJQRIHLGuJnwhYgjLvdOv80Cr
	 935r5r1Ml3D9FrinqcJ+n6m4Z1/0OUIzaE/JgUyWihRlyRyZAeNZj2F7dtj0weHksN
	 2v6UfAJB6c9srlG/8FAi2gctAIqjLMe775ZGzn0VFTBX0BasX3bCAbEpy5q5LN3eR+
	 yj0ry7oWHJrtu2Mgbt8zQrSHvU9Bs8N4oGMMXC59MaXc33UoonzBxjVJfYZE//DV7o
	 Losb9PjBK6b5wwn0a3kgfUlo1ba8pR8rRJTJ2x4oB4labyjcDP5yqoYsqpA8osy3wN
	 HXwJK1X3ENH3g==
Date: Mon, 31 Mar 2025 12:02:23 -1000
From: Tejun Heo <tj@kernel.org>
To: James Houghton <jthoughton@google.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Yu Zhao <yuzhao@google.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 3/5] cgroup: selftests: Move cgroup_util into its own
 library
Message-ID: <Z-sQ76PG14ai9jC0@slm.duckdns.org>
References: <20250331213025.3602082-1-jthoughton@google.com>
 <20250331213025.3602082-4-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331213025.3602082-4-jthoughton@google.com>

On Mon, Mar 31, 2025 at 09:30:23PM +0000, James Houghton wrote:
> KVM selftests will soon need to use some of the cgroup creation and
> deletion functionality from cgroup_util.
> 
> Suggested-by: David Matlack <dmatlack@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>

Acked-by: Tejun Heo <tj@kernel.org>

Please feel free to route with the rest of the series.

Thanks.

-- 
tejun

