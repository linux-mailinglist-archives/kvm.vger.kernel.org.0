Return-Path: <kvm+bounces-30861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 842BD9BE017
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:14:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D6DAB22664
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:14:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 728F91D27B7;
	Wed,  6 Nov 2024 08:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a6+2FbD2"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1851D2B0E
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 08:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730880828; cv=none; b=dG2IzGn10gvVuMx3Xbt5DDo7eis3XaPJmeDBo9KgShZptgd7gdQFVEVAFLcMlxWsnddjwj65JafqfLhoxrwBh6wmZcoujEQy9Ax/6HBUCdVOJO1zhjk78uETyk8YQ/Nf+5+RGST/wJXyJMBMApyWOlCY//8k2cMWp21NYSynwqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730880828; c=relaxed/simple;
	bh=0Dgw5Yy1J4hzZYVxafYiW7YtF1JgBqqkNtpCVa9wC+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qpq5NWXr1ZWAjwEFNgYBd7qfDiGsKtGutDk/I8pTUNCVFDTG1ZB9TgEZPKBe6sFi2Qh7M1aNkHXAFtL9QkyhJG4VcM5letp0dkDtfJ3Zj3woxDBDh++k5iaGUcsQSe89vc3FNXxliycqy5Dx/a3cQC3BynM9OJpLNtMBlVtO8xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a6+2FbD2; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 6 Nov 2024 09:13:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730880822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PnR/1coHucik89mu9NBn4L2l7CigTPruU5E86tCEWrQ=;
	b=a6+2FbD29sqf8xYefH/Iu47fG0zKJF/xc8kc8Cfq9z6zYfWznqkxHFfx3EgU2nS/rrPTdm
	F0seELvN2DXItJoojFhSDUy5gz+dNXYhOvzjigp8QV8Wh5gYFi5xlU9OupIIMxB1yeyhGo
	aadEnxd7lYIk0cMw46daEMDUCNe65iQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, thuth@redhat.com, lvivier@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, npiggin@gmail.com
Subject: Re: [RFC kvm-unit-tests PATCH] lib/report: Return pass/fail result
 from report
Message-ID: <20241106-46bb88a736cb836739b5aa86@orel>
References: <20241023165347.174745-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023165347.174745-2-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 23, 2024 at 06:53:48PM +0200, Andrew Jones wrote:
> A nice pattern to use in order to try and maintain parsable reports,
> but also output unexpected values, is
> 
>     if (!report(value == expected_value, "my test")) {
>         report_info("failure due to unexpected value (received %d, expected %d)",
>                     value, expected_value);
>     }
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  lib/libcflat.h |  6 +++---
>  lib/report.c   | 28 +++++++++++++++++++++-------
>  2 files changed, 24 insertions(+), 10 deletions(-)

Merged.

Thanks,
drew

