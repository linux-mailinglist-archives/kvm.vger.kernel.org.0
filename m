Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17ACE3CB97E
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 17:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240551AbhGPPRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 11:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240514AbhGPPRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 11:17:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4D4461408;
        Fri, 16 Jul 2021 15:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626448481;
        bh=P+Aoq7iQ2gqlhK+iLjPpTY5cto67TEdWIgCwEVk2u2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYViLqT6w66JmUHsV5YHTGR1gus4ro94Q+CGqrtgNk6T/XikKrXmHyNfG0GVjksBx
         b6AhT6Xhdp9X2+CzfYTFNFsyDTaRidGJwhubVs1kenmO6hGS2ORDw90RHJAuF62oIu
         hhIy6Q3tAD83tMDTlo4DzKyCp0qRJEYxxa7nRLqUY22NeSt1r8Vqg3kOnzuDm+bjkt
         aGL6j6uFeqx9JmK2H/Ypm146v6gpi//pD3ZFZp6sIBA6CGo2YxupQrSpAMnKSEKRAb
         YSaT+5e6m39YnZ9Pqr/YnrOmZy92pnLEO66Qy3CYPe1Bn1WIYp7siVTbh6MrJwtriy
         /NJKvDEq1vBdQ==
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org, julien.thierry.kdev@gmail.com,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, maz@kernel.org,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com,
        pierre.gondois@arm.com, andre.przywara@arm.com
Subject: Re: [PATCH v3 kvmtool 0/4] arm/arm64: PCI Express 1.1 support
Date:   Fri, 16 Jul 2021 16:14:32 +0100
Message-Id: <162644775452.1074809.4162170370958700594.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210713170631.155595-1-alexandru.elisei@arm.com>
References: <20210713170631.155595-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Jul 2021 18:06:27 +0100, Alexandru Elisei wrote:
> Patches + EDK2 binary that I used for testing can be found at [5].
> 
> This series aims to add support for PCI Express 1.1. It is based on the
> last patch [0] of the reassignable BAR series. The patch was discarded at
> the time because there was no easy solution to solve the overlap between
> the UART address and kvmtool's PCI I/O region, which made EDK2 and/or a
> guest compiled with 64k pages very unhappy [1]. This is not the case
> anymore, as the UART has been moved to address 0x1000000 in commit
> 45b4968e0de1 ("hw/serial: ARM/arm64: Use MMIO at higher addresses").
> 
> [...]

Applied to kvmtool (master), thanks!

[1/4] Move fdt_irq_fn typedef to fdt.h
      https://git.kernel.org/will/kvmtool/c/070fb918a563
[2/4] arm/fdt.c: Don't generate the node if generator function is NULL
      https://git.kernel.org/will/kvmtool/c/6b74f68fcf06
[3/4] arm/arm64: Add PCI Express 1.1 support
      https://git.kernel.org/will/kvmtool/c/e69b7663b06e
[4/4] arm/arm64: vfio: Add PCI Express Capability Structure
      https://git.kernel.org/will/kvmtool/c/25c1dc6c4942

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
