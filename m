Return-Path: <kvm+bounces-53541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85600B13ACB
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 14:53:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E14FF3AE6AD
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 12:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABE6C265CC5;
	Mon, 28 Jul 2025 12:53:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBDC2221265
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 12:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753707192; cv=none; b=qzcJpysnnG6IOauBQ71hFT5lCB5xPcGKfgozFP2k6ei1R3PUeFdZoh9bRAQ+TU1fCCxiQHmmsWJtETTxgiMkcF9vSTpf+Ibq92Urfnj3UgTyy1qJVIz1C5cU7dLauzHRrKB5uQDgudr7HkuQaSA/dWmYlhm1NkXPsdEw/2D+QDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753707192; c=relaxed/simple;
	bh=Jdh9o/Y0Iy5TBBq90JKzzlRxmv+rTS6SEbUqi/ayZbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=twYMTplRLyqOkvF0ndfaOXlZXvosmQkrwfhaDJKzo8jktyiEt8Ob8fweLlPZYSt74KbAK2m3aGYisQsasR5jmSBG4qsnEOf1pPCCmEiHK+5b63edzNxPuBWqSFu0kvB2FOUadwmYXx7xLNjtr/AuP6NYCJhmwqspyAQRg/qxA4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38E4B1516;
	Mon, 28 Jul 2025 05:53:01 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 83DA43F66E;
	Mon, 28 Jul 2025 05:53:08 -0700 (PDT)
Date: Mon, 28 Jul 2025 13:52:58 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 0/2] Fixes for recent kvmtool support
 changes
Message-ID: <aIdym4nTlteKr32-@raptor>
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

Hi Mathias,

Was on holiday, and couldn't reply earlier. Just wanted to say thank you for the
fixes!

Alex

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
> -- 
> 2.47.2
> 

