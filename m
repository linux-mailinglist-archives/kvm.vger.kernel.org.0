Return-Path: <kvm+bounces-35297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 707E5A0BC27
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 16:36:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C14F16404E
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 15:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0BD1C5D63;
	Mon, 13 Jan 2025 15:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xGgARKy7"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E1E240225
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 15:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736782584; cv=none; b=jWJsqSqIOAifBKVx1qBftAx1e1kUx1TsaWxZUrBY8wR+S9bcNpiC0klx/luPPOrkJ3UNxxCEHM9+FAZAaLvY7uneX8EjY/+paiz0romBXeBsQ1sLjZSLAn7mB9zCGQ6QeSutzxYISNqUJkHrOVp5pjGkfi3Y5ngutbw0CPnuiSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736782584; c=relaxed/simple;
	bh=+nG1tiVCZGk/wR/T5QprY+Is6v4sI7WXd46EmUH7ZJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U34Tx5RskHMRZylL72ld0P77YnIQnTZG6aokDz4EShcN4GdUBDyrHs7Ui2it6vu3p5z7VZlPkGZ3W/Y+vnc8cRw6DVA5uFEtdJpyAUIE78L/Fre4GLzeJQtVSWUxJkEHrEhBY02lUxFkrcdDvdMXhVwTrKyV1d5LIVdZO3WCyuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xGgARKy7; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 13 Jan 2025 16:36:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736782581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f+ZhNWjJvKKMM6F9wHDZ1KS3Q3+s48tX81YEFzM2Q+o=;
	b=xGgARKy7PvzqHsmwzdV65KgiqZq5Ji0S9ZuFgq2jegzXn8a7ZrK5n+aQRmYe/QlPfRsyEz
	hMLLmn5lmxqONtrK5rk9sH2Ic5UZGUXuMGEnKhHkaB+twfGjex3LuXL/Bx9u4VdvtpDNNg
	PWf7zwBAxLifcyavKu1G2aktrhFfYwM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Jon Kohler <jon@nutanix.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, 
	Thomas Huth <thuth@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Eric Auger <eric.auger@redhat.com>, Nina Schoetterl-Glausch <nsg@linux.ibm.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH] Makefile: add portable mode
Message-ID: <20250113-e645de551c7279ba77e4fb74@orel>
References: <20250105175723.2887586-1-jon@nutanix.com>
 <Z4UQKTLWpVs5RNbA@arm.com>
 <806860A3-4538-4BC3-B6B9-FA5118990D78@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <806860A3-4538-4BC3-B6B9-FA5118990D78@nutanix.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 13, 2025 at 02:49:11PM +0000, Jon Kohler wrote:
> 
> 
> > On Jan 13, 2025, at 8:07 AM, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > !-------------------------------------------------------------------|
> >  CAUTION: External Email
> > 
> > |-------------------------------------------------------------------!
> > 
> > Hi,
> > 
> > On Sun, Jan 05, 2025 at 10:57:23AM -0700, Jon Kohler wrote:
> >> Add a 'portable' mode that packages all relevant flat files and helper
> >> scripts into a tarball named 'kut-portable.tar.gz'.
> >> 
> >> This mode is useful for compiling tests on one machine and running them
> >> on another without needing to clone the entire repository. It allows
> >> the runner scripts and unit test configurations to remain local to the
> >> machine under test.
> > 
> > Have you tried make standalone? You can then copy the tests directory, or even a
> > particular test.
> 
> Yes, standalone does not work when copying tests from one host to another. The
> use case for portable mode is to be able to compile within one environment and
> test in completely separate environment. I was not able to accomplish that with
> standalone mode by itself.
>

standalone scripts should be portable. If they're missing something, then
we should fix that. Also 'make install' should include everything
necessary, otherwise it should be fixed. Then, we could consider adding
another target like 'make package' which would do 'make install' to a
temporary directory and tar/gzip or whatever the installation into a
package.

Thanks,
drew

