Return-Path: <kvm+bounces-41068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5DAAA6138B
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 15:20:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C486D16BE9E
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 14:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F37D7200BAA;
	Fri, 14 Mar 2025 14:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mgJp4B7/"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B99200B8B
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 14:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741962020; cv=none; b=nZbXKDtGTxd1fkEqCDBxDZXp8qKiCixc7uEMwNc0hXz3YSOqqh13j+Lk+gn6JbNqp8IE2Rcc4d0ji2QVnJsxQNanGACaxkFJNZwwRUKBWBLCAX4R3SyrBujt12AU1VFsPO3vrl3nJxIkPHaafLW/QtWWR5IhOdD3LAVu5m5WbBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741962020; c=relaxed/simple;
	bh=GUcUJyznokWWPvm96+h7aNJY4n+o7HfWX5a4PXwb7DA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jRctM5hdTLOKnIWJeI7cKL6LH/p2X79dI4HwvoHSHRLWWPd64iy9YqUMQLpcR23LQrW1b5fFHw648IpPOHCJUIRAU6h3yiPDWHbpJRXjuTRuhEDLw1K8AbPPh365rmxEPe9isWT4lYnUt67nZcICa5EQOZq9YRqfoUHnvKMEyk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mgJp4B7/; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 14 Mar 2025 15:20:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741962010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GUcUJyznokWWPvm96+h7aNJY4n+o7HfWX5a4PXwb7DA=;
	b=mgJp4B7/U32G0Owl7o+mMXkEW1f1F9EFGic4ntY1bWtoF8pTrrjpZ2TqvpKDg0Y45SuqS1
	6b0ypbDQYDY5OWseTT7ArD6hV5dY/aDm5h4zPLdkwLJqHkYrqFMm0DFmECMwOrI/horsuK
	WXqLaMDC6JV/0bOGhyYW5UHrIp+aT60=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v9 6/6] riscv: sbi: Add SSE extension tests
Message-ID: <20250314-378268547f75d0337f1a7836@orel>
References: <20250314111030.3728671-1-cleger@rivosinc.com>
 <20250314111030.3728671-7-cleger@rivosinc.com>
 <20250314-0940c2c0dcd92b285f43e4ca@orel>
 <56451a0e-7971-4619-8b2e-84c5129547b4@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56451a0e-7971-4619-8b2e-84c5129547b4@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 14, 2025 at 03:13:07PM +0100, Clément Léger wrote:
...
> Missed it. I'll resend a V10 if you don't have any other comments.

Other comments are on the cover letter.

Thanks,
drew

