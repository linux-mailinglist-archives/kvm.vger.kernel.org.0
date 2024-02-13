Return-Path: <kvm+bounces-8581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED49E85270E
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 02:51:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 873B81F23F35
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 01:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C7C7224DE;
	Tue, 13 Feb 2024 01:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vyKXQ2px"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C6022319;
	Tue, 13 Feb 2024 01:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707788635; cv=none; b=AxR5glQExdIaDALFGQGKqsrYrdeHjpRQKqtxetgTH0uu026nbXsYabKefrK1Wp2Ne9MS+ddDgs14TZbadSSl1n5IFGx1PftH4dOK3/10p+dB8+fxWZExGPVkmchRj3e2rUYROv7+iH4HXu34Qb4Y8jgXQacz3K1wt145P3BxaeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707788635; c=relaxed/simple;
	bh=TXuS2TssiOSkJMhoxy8H08CjJ973E8uafU+ukFCKIhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kDRlD7dRa4ORtxcvXHLHAplTJMCfAcdjQweRcKsFGjMToI/GF3wzKS56mcdVHsozmLLui2+mOI8AR7oWL7n551G650+dWRyMyrEsUHhjEsVHN3k5D71jQKvJHAjkqKqpk/Eu/9Tgul/KiO1ktvQmVypGCFzyQ58EVPNKoTskEFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vyKXQ2px; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707788630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SBqvF0QUm2o6p7011Huo34bPUEy9yxCkZTpXlg9c17E=;
	b=vyKXQ2pxsLXd4w42dHlvY922AIwxv3hFacw0GJO6An1Y2TRLP/zJfTdWyMOQRe8YT01Smu
	yxnEoraK3kwDAtCYjUNxXCbNZa+S3wZTYp5R5Out0rfUfbsu6gkYD4jGZOSHgNztZajEjs
	yLXmVulb+bP5/BpZtTvgcZ066ml9A+c=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	Raghavendra Rao Ananta <rananta@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] KVM: selftests: Print timer ctl register in ISTATUS assertion
Date: Tue, 13 Feb 2024 01:43:37 +0000
Message-ID: <170778861235.3388601.17324166104482314804.b4-ty@linux.dev>
In-Reply-To: <20240212210932.3095265-2-oliver.upton@linux.dev>
References: <20240212210932.3095265-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 12 Feb 2024 21:09:33 +0000, Oliver Upton wrote:
> Zenghui noted that the test assertion for the ISTATUS bit is printing
> the current timer value instead of the control register in the case of
> failure. While the assertion is sound, printing CNT isn't informative.
> 
> Change things around to actually print the CTL register value instead.
> 
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: selftests: Print timer ctl register in ISTATUS assertion
      https://git.kernel.org/kvmarm/kvmarm/c/8cdc71fbf655

--
Best,
Oliver

