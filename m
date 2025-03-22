Return-Path: <kvm+bounces-41746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC151A6C9CE
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 11:49:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C37C716C78E
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 10:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B531FBEAC;
	Sat, 22 Mar 2025 10:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J5XI+VRX"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173161F9AB1
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 10:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742640432; cv=none; b=rFBVD+bCAeYhCtw4vkSOA9LOvBnhMbMURxSWbd0KSPVfHH/1w1GSZJAuEZvINbrEGEVrvbPfvxKik2B+6lvLK+8Cz+7muK2DWaWtS5v+B0Nd29OGcww0U1/lvtvZlGfcE/BguHEKi31UYcCKwfQCzOePcqf9aB9vB+PAly9HnW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742640432; c=relaxed/simple;
	bh=t3XFprVtQBIlwa1e1kuYwk7/HvVtG5NfumZ0X940sVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MzgmbocGesO+7EAZTRMfaAeSlC08LklBWYg/CoPMOHnCeBNYiFUw3LEoEDZ6E/hSicAWDlxUtCsBYJc9q5dzUEzwU6Y1XjlTXTQjN7PCM1/O/skmHn8JM3MvPHFByXw20JK8yZJdurnJXtR7CjjIvelrzKBjfS+Svlen6zW5p3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J5XI+VRX; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 22 Mar 2025 11:46:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742640423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f9F0smYuHKAtWS7/MZNtZi4wxTftvdoTJwVJsXsPUBw=;
	b=J5XI+VRXljQV8dV7S04l6Yqdm1JzMZYgFvz4WATuh30YUGAtRDEII7D1N5T3eqSFIzB2nH
	rW/L0UGe67hkhoNEYxUw3FbtEfYdoiLpHa34CxNO/Fb0DabwB865Ll4DJtIywsAZ0hyL+a
	smJWSFGLBvEYQ0y96XCrwWYumhiip2I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Akshay Behl <akshaybehl231@gmail.com>
Cc: kvm@vger.kernel.org, cleger@rivosinc.com, atishp@rivosinc.com
Subject: Re: [kvm-unit-tests PATCH v3] riscv: Refactor SBI FWFT lock tests
Message-ID: <20250322-17dd3209602eeda6341745c9@orel>
References: <20250320173235.16547-1-akshaybehl231@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250320173235.16547-1-akshaybehl231@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 20, 2025 at 11:02:35PM +0530, Akshay Behl wrote:
> This patch adds a generic function for lock tests for all
> the sbi fwft features. It expects the feature is already
> locked before being called and tests the locked feature.
> 
> Signed-off-by: Akshay Behl <akshaybehl231@gmail.com>

Merged.

Thanks,
drew

