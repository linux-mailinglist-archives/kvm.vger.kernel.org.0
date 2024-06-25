Return-Path: <kvm+bounces-20476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3200291689B
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:09:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2FB2B2578C
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7B8158D76;
	Tue, 25 Jun 2024 13:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QD8ZQ7NF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853F91482F8;
	Tue, 25 Jun 2024 13:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719320982; cv=none; b=Ve/PaKf7907Jf8tVJHuqRYWG9bZF0ZLlQqkH6y3mzxxJscmgyxM4Pw/VkhR+qKRCFrBfSIR8m+tjh8gnXPRH5dkWmRLXYfmqemitGK4YWfHA0vHA0dPm6/RdRsIm3Cq0iPjBZrAzq9E7VeImAVgr92j8EaJpzTwMLM3hrEb7Xv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719320982; c=relaxed/simple;
	bh=v0RrGnLJx96prKt+gVIo7mfb5YkYNM0TlmCRr2Ajoag=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=lteCoBvyoMgFpYMUyoyG87/3WTLDqjXNGR03g8/TlBn1fg6hAVVkA7/3630TZt4B6jbWnN3Vpck969Hwjw6L+gowhwZI8sM04qgX0itg5Lh4sN1lH+IIiWiZjTCbW3bTHyiZl51CxK285zUpi+tuT/vuFk2xdgNffeZTxqPx/HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QD8ZQ7NF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7BEC32781;
	Tue, 25 Jun 2024 13:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719320982;
	bh=v0RrGnLJx96prKt+gVIo7mfb5YkYNM0TlmCRr2Ajoag=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QD8ZQ7NFU9d2hK4o1vb9mt2wQ/fpgjkrBHTBm69mj3jPOwaAgTPSBF/Q640zSrv5v
	 I2D8M/3o/R0umwh6RGK4vpi0AvO90fZgCDvGC9To4SLkJXpDNd7SXpVHTlLG4lMoXx
	 AmttHbtmFNOMoZurji7AOEgYaqggSeSggCFzk1hJeQm668lV/R/5k5F2r5O8BCjrlL
	 OWMcpdYfn6kn/vNMFLGRyzcdQ4CfCsofuU2LssYm3BBJ5n7CW3KRvg+Zi3M3oXpU9S
	 dZrVEGKEr5aRHniKepmCKwhTk8FpNqOcrhjzucqUHwjChHsOSbh9dkePuQOgdMOrYL
	 JM8Rk9yLBNjYQ==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM5vY-0079jB-Bo;
	Tue, 25 Jun 2024 14:09:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 25 Jun 2024 14:09:40 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu
 <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 4/4] KVM: arm64: Honor trap routing for TCR2_EL1
In-Reply-To: <20240625130042.259175-5-maz@kernel.org>
References: <20240625130042.259175-1-maz@kernel.org>
 <20240625130042.259175-5-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <95089bc5144ead3a4f195dbff159491f@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2024-06-25 14:00, Marc Zyngier wrote:
> TCR2_EL1 handling is missing the handling of its trap configuration:
> 
> - HCRX_EL2.TCR2En must be handled in conjunction with 
> HCR_EL2.{TVM,TRVM}
> 
> - HFG{R,W}TR_EL2.TCR_EL1 does apply to TCR2_EL1 as well
> 
> Without these two controls being implemented, it is impossible to
> correctly route TCR2_EL1 traps.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)

Gahh, stale staging directory, please ignore this patch (5/5 is the 
same).

         M.
-- 
Jazz is not dead. It just smells funny...

