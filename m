Return-Path: <kvm+bounces-2196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C57467F327A
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 16:39:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FB2A28299C
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 15:39:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3DF58121;
	Tue, 21 Nov 2023 15:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="POO5o7dn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93A85810B
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 15:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F64C433C7;
	Tue, 21 Nov 2023 15:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700581151;
	bh=byE/AD6/qik8nkB4C5AWDnkXvzFCypeDeMYz6qVK9qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POO5o7dnSABx3DhuEE8JEpLKYdAydbmzi0cludVPplFgz/6XBIrsVDqIpPgw2a3BJ
	 0PTyO9BUEQddFasuMsrni75Fd2ujvr3fP592uFuP+teLPSKEFPlC+u++mgOeaABa82
	 Jq7fIGEpnwKfQmkahomOdX5qYAtaEU+7xwBEDtFaBEuBPIMiNulnpjqwrdy8oXf2S9
	 BQ9v6D4BtETnZGpfzHIqkwKWZXHcAqv2rVf2qoK/knIVKYVrO80fAm1r1li+3X9rUz
	 obCgVdode+JqsYgMsYwFD4Oowhqb10WK9DixSlJp2X7n/AnKaQ3IKzWUgFqXOQQREv
	 z69Jkd3DVNpgg==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org,
	Eduardo Bart <edub4rt@gmail.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	alex@mikhalevich.com,
	jean-philippe@linaro.org
Subject: Re: [PATCH kvmtool v2 0/1] virtio: Cancel and join threads when exiting devices
Date: Tue, 21 Nov 2023 15:39:01 +0000
Message-Id: <170058073150.653630.17599038677837339499.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20231117170455.80578-1-edub4rt@gmail.com>
References: <20231117170455.80578-1-edub4rt@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 17 Nov 2023 14:04:14 -0300, Eduardo Bart wrote:
> This is v2 of my patch fixing possible crashes in extra threads of kvmtool after powering off guest machines.
> 
> I've addressed changes requested by Jean-Philippe Brucker and Will Deacon.
> 
> 
> Eduardo Bart (1):
>   virtio: Cancel and join threads when exiting devices
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] virtio: Cancel and join threads when exiting devices devices
      https://git.kernel.org/will/kvmtool/c/74af1456dfa0

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

