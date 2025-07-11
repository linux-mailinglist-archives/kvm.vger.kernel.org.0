Return-Path: <kvm+bounces-52176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 432F5B01FE2
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 16:57:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E2C21CC223D
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 14:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13F3A2EA15C;
	Fri, 11 Jul 2025 14:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NYjeQnyb"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CEC2E9EBA
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 14:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752245622; cv=none; b=Sa48/BTBZPGOG8klsd/KYF1YndvEKxAon9PZLBEO6BCaxlNuxRQlsu2WFvRQ+uevX5iyrXbEdJ6CpRDzBKaO16OAqWJD/RRKInOkKq3fn4iW+Q+A088cHBKXOHdXfgCLDgjWFlWH1rLQvgTb2c87LOkftste/M9G4QrCK6HitZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752245622; c=relaxed/simple;
	bh=iErwGMZHHC7GpMU526qYe0NIdbBNgLXvyha6MMdoQWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EbzYDD7p7NWGxXyVrY3RcwLjgRIDTILAsqlh+oqVepYjjC2Vxbh1UDgmfdddH/jROH2XajZeNwgsfR/C/gEKFNopLWQ8Y4hbos0OcUxw3amMxQrBP5jDREb+X2l3lchurAKNiDngQC69oNDJ60OKgBHT25w11zze8YKmdFdgbqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NYjeQnyb; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 11 Jul 2025 16:53:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752245617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b6BATk9k0MDlC5I83YagIKQxOMy1sKnPTKHeItK3Q58=;
	b=NYjeQnybD97/p6uS1JUf3p2qzuoVM95WZCECwnPOhhyKGjt/DpSQay7/mUgoe8m8juvVVo
	qlUCnVvfpG8uQkXuZFYv6q5zPJhWO7PAGbSWIDbftvrUehF7I5p1O8pza3Knilhg4UsbYE
	S0CRwCjRztIYYwiFv7Ul967zgp/3sGs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 0/2] Fixes for recent kvmtool support
 changes
Message-ID: <20250711-35fa6917768a36c9d868209d@orel>
References: <20250711091438.17027-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250711091438.17027-1-minipli@grsecurity.net>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 11, 2025 at 11:14:36AM +0200, Mathias Krause wrote:
> Hi,
> 
> these two patches fix issues with the kvmtool support series[1] recently
> merged.
> 
> Please apply!
> 
> [1] https://lore.kernel.org/kvm/20250625154813.27254-1-alexandru.elisei@arm.com/
> 
> Mathias Krause (2):
>   scripts: Fix typo for multi-line params match
>   scripts: Fix params regex match
> 
>  scripts/common.bash | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>

Merged.

Thanks,
drew

