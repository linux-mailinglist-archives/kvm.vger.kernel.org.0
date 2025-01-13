Return-Path: <kvm+bounces-35309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95FC7A0BEC4
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 18:22:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AF493A7C1A
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 17:22:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F9461AAA1C;
	Mon, 13 Jan 2025 17:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CMea5Ktw"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB408190692
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 17:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736788968; cv=none; b=p0379Qq8IbGoUI6rCdsBW7TjoLXJA47HIfXRvPjEVSoRORxR3agcQuMDFnGR9aGE1sv1lYytFeKh7VtL44NGPBULZ/9yRvj3Z1EjWN0WtfZ/RDb9XKy1++bUnO5PjhL836D36fkPLIFCWpEqu5hwkaydsw2mVpnHWic6K/eFkWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736788968; c=relaxed/simple;
	bh=1SYhWMR//MH4q0r3Z+RTc17CbnTV2tHdPftxZGU3qAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rCetN9PsEQxtcl6G5k4114zo7ylGZ77UK/lGUpS7oy9KHDyD5bw4FHpXKGqQlAcuZCNSwdRXU9fHwuUx077kW1jolhWpP7KXgAtlKp6LpI9VDk0nTMiLXU32tYsM0Xep+AiwuGo8WrkM37lzNpsBdNJJDD27tmrobNpEAk40P1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CMea5Ktw; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 13 Jan 2025 18:22:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736788963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1SYhWMR//MH4q0r3Z+RTc17CbnTV2tHdPftxZGU3qAY=;
	b=CMea5KtwVtsNA7HrhG3mjvs3Hq/An8VkR3gR2aRVbTo/doG9a0Q2YWCx4laJFB03V/HIo/
	R3T9g/RBp6/fgIZSOcPNV4kkTbzHNj6pppFQ9b5WVutTH/p+ai4JLavhUuXpc3Rllb3Se7
	yADyIxz93ZvujsKQf5gJOSumIMHtcFo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v4 5/5] riscv: sbi: Add SSE extension tests
Message-ID: <20250113-5f909e9cad611aa6b69c52fc@orel>
References: <20241125162200.1630845-1-cleger@rivosinc.com>
 <20241125162200.1630845-6-cleger@rivosinc.com>
 <20250108-162405687be625303572c303@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108-162405687be625303572c303@orel>
X-Migadu-Flow: FLOW_OUT


I still haven't finished the review, I just hit send instead of
save-as-draft by mistake :-) However, sending now for you to take a look
at what I have so for in parallel with me finishing the review also makes
sense.

Thanks,
drew

