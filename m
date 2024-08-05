Return-Path: <kvm+bounces-23265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55FC294855B
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 00:13:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 011221F235A2
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 22:13:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB2D16E877;
	Mon,  5 Aug 2024 22:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AiNO/ArB"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0FE155351
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 22:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722896013; cv=none; b=Z9IteUyovn+uWRJJSWUTHHfROH9Eh8dpSj9m+QR+Lp0B7+f01NgmHNK/SqVTHSMc5qA+tqTpzIanB2QDV+YLccAiUWiR8JTH1ZBXmeKqz3HePyhzLR9r/VXTRlyJPVi5OSc5/mJKU0CCnkNR/MJZD/e+SDzrIa6quFlnJnUTTJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722896013; c=relaxed/simple;
	bh=ZU1mTqSIV2QJlHfcRpx8stQoTqRb8LzyAmWFgDvwkS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QxrHIb/RpFnpnCMg2JUPvCDUf3k1eNekRAdNSIBMQ0QYc+d/LqTjtX/PlWemqH/hxthz1CfJ9zOI8OiYYmhcc8sH8apKguTi72jr/k1F7I85SbjD3UsI1GGZ0+Kp/Wjvvsgs6NiD8VUcYmFAA/gECNt2K6+/asqr3X/DU8ic4WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AiNO/ArB; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722896009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TUbA93rWq6wVQt6emuecJgEcEoy6oGSe5x9ZbtIF5CQ=;
	b=AiNO/ArBxK0Dq9Yq5VCdP7e37xf1lfCxO3shfmd0hubd1CwEBScJecTKP2xfNHZMcQTHRl
	P/QGzHY78gCuSwlRzGoIy7CerCA0LkwiuZNXc233ak239HupwSyru/AjBrj+MJINEEoyB/
	zrYHB8rwC6pm/LFSzUszTzkIqbzFdUA=
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Takahiro Itazuri <itazur@amazon.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Dave Martin <Dave.Martin@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	zulinx86@gmail.com
Subject: Re: [PATCH v2] docs: KVM: Fix register ID of SPSR_FIQ
Date: Mon,  5 Aug 2024 22:13:16 +0000
Message-ID: <172289598051.3403941.16215399133849750692.b4-ty@linux.dev>
In-Reply-To: <20230606154628.95498-1-itazur@amazon.com>
References: <20230606154628.95498-1-itazur@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 6 Jun 2023 16:46:28 +0100, Takahiro Itazuri wrote:
> Fixes the register ID of SPSR_FIQ.
> 
> SPSR_FIQ is a 64-bit register and the 64-bit register size mask is
> 0x0030000000000000ULL.
> 
> 

Applied to kvmarm/fixes, thanks!

[1/1] docs: KVM: Fix register ID of SPSR_FIQ
      https://git.kernel.org/kvmarm/kvmarm/c/7fef1eb0b013

--
Best,
Oliver

