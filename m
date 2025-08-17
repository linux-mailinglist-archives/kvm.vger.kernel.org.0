Return-Path: <kvm+bounces-54837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4E3BB2910F
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 02:52:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 194681B26E6C
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 00:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3CC1586C8;
	Sun, 17 Aug 2025 00:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LRpy3xtF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771B941AAC;
	Sun, 17 Aug 2025 00:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755391885; cv=none; b=IqMIOMus7V8L9osbNtJ+WJpqXMgBE+EGQ7+p+Vh5vnN/aZVJSjO1PcLV5QHiOnt6QzbQNw4zDDdwHXLJSkIBIALBOrlNXkO5XjYxoHIapR/R6q3U41rbDFHp5U46WZahSYWHDGnXeZSfMriySmNMZBIqsyHxaVm8YVijf74sjIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755391885; c=relaxed/simple;
	bh=rIsIJEO+oMZbI27S5muW/Dow3ApLCm+/8/X0szf6fbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dXAHdbYTTzVKcEV+NbmuulQS6ptmQEHlHJt1VRTnup7ITB/yr2yN5hN32YA6IGhsoodPcbplqek4zNRURCscsDp+d/2aNPpsR7Qlk1bJ7XmVHJ9qtxBBCwGhdf47QBPi5TNj/BADoPIJblIerhgb3ifY/kzCR3gpwTVWiIj/Rwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LRpy3xtF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3F2C4CEEF;
	Sun, 17 Aug 2025 00:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755391885;
	bh=rIsIJEO+oMZbI27S5muW/Dow3ApLCm+/8/X0szf6fbY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LRpy3xtFr11w9964odQDtOyRuqy8f394ZEOesUzrwh11f1PUT+BzOXr6KPAUcRYlR
	 r6Y7pmBtwUEpeEgVffVAu8tsrZSQSpd8l/vVmDTanSNCiTb0xi6jNYy9rG/oJfcFEN
	 06Dr1QM97Qy1DZJ2mlnWsxhYkCWi69AlMJpyixuEttKtZj6v1ZC4tk0R90vo3XZZhJ
	 SUMWBsiz15oRN+W3/dOw3iaPs1c05q3gQs8pnYVgRJ3+2BIf0J3z07X7s5FGmbhaof
	 NiUiySZw5P82eFhMpaNU5Ercj7VGeqphqbaoAhfdBIBKN0UVp7S6pS+ocEHyA3bpvt
	 Nl573Ha8GCHkg==
Date: Sat, 16 Aug 2025 20:51:23 -0400
From: Sasha Levin <sashal@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 6.12.y 0/7] KVM: x86: Backports for 6.12.y
Message-ID: <aKEnfEmNP_byUrxn@laps>
References: <20250815005725.2386187-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250815005725.2386187-1-seanjc@google.com>

On Thu, Aug 14, 2025 at 05:57:18PM -0700, Sean Christopherson wrote:
>More KVM backports, this time for 6.12.y (and with far fewer dependencies).
>
>Same note/caveat about Sasha already posting[1][2] many/most of these:

I've queued your backports up, thanks :)

