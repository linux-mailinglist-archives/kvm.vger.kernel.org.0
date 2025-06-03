Return-Path: <kvm+bounces-48264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12893ACC10E
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:14:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9ECE13A18AC
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 07:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02A902686A8;
	Tue,  3 Jun 2025 07:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p9h2De5k"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519C02C324C
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 07:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748934862; cv=none; b=YjRZyh0EY12zOT5TrJmW50jyy9BJQAh6wqDf9HLkJcNQRjHOop+WpHH/U7epR8zXYzGrk9hPnManrVDgsMtcKNQ86ys9BIkOTImteBbmukdQJmT65ocoPvpJXbFmxpinty14jjyJBVLYB4UX4K95+W4A4kRd095Fid3neHTAndY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748934862; c=relaxed/simple;
	bh=02KzWszP4AaV+0yKzQ0zV0b4VDWCqtEaG14P4v1HiRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YQcB8NfcxjNVLFMQUMu/jNL93V1oavWLjRZ8qQIiVcZSc7k316YQ9YIsZksMCqW3kUD8jV0fDhzRvynTgelrwfN2iPH0khd5UUO6eq5mqP1Ih1yl8PYmc9Uf+0d5MqIpRxPWLFCbb4p6zKh39xUgGH5trQm05HbHtnxDIGl7EMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=p9h2De5k; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 3 Jun 2025 09:14:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748934856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=271pIvO6TV0rA+Jd4Usis7eXvzCSybFhiFB4KR/S7to=;
	b=p9h2De5kMe3kKRA/OQj44YMoWxPJzIZ6K7HgpqfRDIkPPoYxjY9HMB5lTZ1Se1OjAfcCHD
	2/aEMymiqqdxQp1zbKrUvaM2ltT2LqdSxVTTGuNuKTeC+OcAcLnBzyvsSJkF9ZgER2DQxK
	dEgDgBW/I+I47KFqKE75OPxNdAH1/nY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Ved Shanbhogue <ved@rivosinc.com>
Subject: Re: [PATCH 1/3] lib/riscv: export FWFT functions
Message-ID: <20250603-96ca9fbc275ae7cb68f8da49@orel>
References: <20250523075341.1355755-1-cleger@rivosinc.com>
 <20250523075341.1355755-2-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250523075341.1355755-2-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, May 23, 2025 at 09:53:08AM +0200, Clément Léger wrote:
> These functions will probably be needed by other tests as well, expose
> them.

s/probably//

> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  lib/riscv/asm/sbi.h |  5 +++++
>  lib/riscv/sbi.c     | 20 ++++++++++++++++++
>  riscv/sbi-fwft.c    | 49 +++++++++++++--------------------------------
>  3 files changed, 39 insertions(+), 35 deletions(-)

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

