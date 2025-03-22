Return-Path: <kvm+bounces-41745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DA57A6C9D0
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 11:49:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55A241B66153
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 10:48:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFAAC1FA15E;
	Sat, 22 Mar 2025 10:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SBSLVQML"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CCC1F8F04
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 10:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742640392; cv=none; b=OoTutPhsmXvhOvV7GIciDFPk0UY2wQj3sqIltQAS1Uk7DYKH84E7oRp72ucWPLIqjm9PvPbg2yDY8UpG/TVKMbvWjLzZLSzxsu9zeJ6M121nwWzb3sPpHRSfZzzhUbe9561VGvPKWSHP0FYbsjcOOdrNRLI73SiNmm32H/QFcR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742640392; c=relaxed/simple;
	bh=x0loCfDUka1cBNoP21mRx2AyCifJwxSz3ewOoJemxRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=czATOpD3ABQM7dHNGFwT6lst2v9HAvqFIrix9q9dtNrRZAGG1i8vk+sDH5Ltonq38HPVO6SV8KQ4tvKrEv5ascSqpRhVOlCAiEIqEB1qNmPxn4rJYy0uf0QQOWmUcb0gU0ZWCIcX+MYuaeDm5Khbhka2uZfzXWVBwjTwp2U36eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SBSLVQML; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 22 Mar 2025 11:46:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742640388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Aq4lPivi9PmV469UbUNcJtpLaFoa1nsoqqrqthUmtJU=;
	b=SBSLVQMLKxhHDzVJWB71hS5dvREPWq1dWyCM4O3NH3inOkcliCXGnzidA5OxXjDP5kgs7S
	3pFEuuRjmKvU+FKBtpg0JzERpDKD6S1zVYQvPv/mFi4EhlZ2l4HpwO9WQszBB9vOr7gb32
	Wsg68qD9LmlqW/hIQ9fTzv0MjL+ZSJA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v11 0/8] riscv: add SBI SSE extension tests
Message-ID: <20250322-2b07672652d6ce2c0972a62d@orel>
References: <20250317164655.1120015-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250317164655.1120015-1-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 05:46:45PM +0100, Clément Léger wrote:
> This series adds tests for SBI SSE extension as well as needed
> infrastructure for SSE support. It also adds test specific asm-offsets
> generation to use custom OFFSET and DEFINE from the test directory.
> 
> These tests can be run using an OpenSBI version that implements latest
> specifications modification [1]
> 
> Link: https://github.com/rivosinc/opensbi/tree/dev/cleger/sse [1]

Merged.

Thanks,
drew

