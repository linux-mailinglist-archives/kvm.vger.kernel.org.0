Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D384742BEAE
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 13:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhJMLMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 07:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229571AbhJMLMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 07:12:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C71561053;
        Wed, 13 Oct 2021 11:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634123402;
        bh=SB9agUm5CyigMOVILHSp+MuvRsvJ3wpwV+USy9ZpwJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doQIGCvIpGjOqD5dK5wzw2HF78VooPshL5CIdu3IfzhJf0YLCdxwi2F6fe6GL3rD2
         a9tYFz8eSPs7qf8wzSzw216d+yGSfJhH0/9N2Dc6Vk3u6Xw9XM3MM+aMp4GQNEy6CW
         3o5245eogw36vv0sZg+RSvGfo7l6SMWudma/lfConeguMR/utjcjx0lltd86h0ffRt
         GLu46iQ1QY9oDr/T1goWCcDbCcDPy5oRfyzemMDETFqNtzrarwHw8PoQn9k15nT+y5
         WHtedxyxxWg1ANHRv8V+G+MCxSyu/yvr+7V8jK+5Rk3nRPTLwk6dIsjMGiVWdWjpCA
         poqK7PW2TnvuA==
From:   Will Deacon <will@kernel.org>
To:     julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, jean-philippe@linaro.org,
        andre.przywara@arm.com
Subject: Re: [PATCH v2 kvmtool 0/7] vfio/pci: Fix MSIX table and PBA size allocation
Date:   Wed, 13 Oct 2021 12:09:57 +0100
Message-Id: <163411062031.138160.12661365878705396972.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211012132510.42134-1-alexandru.elisei@arm.com>
References: <20211012132510.42134-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Oct 2021 14:25:03 +0100, Alexandru Elisei wrote:
> This series is meant to rework the way the MSIX table and PBA are allocated
> to prevent situations where the size allocated by kvmtool is larger than
> the size of the BAR that holds them.
> 
> Patches 1-3 are fixes for stuff I found when I was investing a bug
> triggered by the incorrect sizing of the table and PBA.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/7] arm/gicv2m: Set errno when gicv2_update_routing() fails
      https://git.kernel.org/will/kvmtool/c/e3b0ade2de2b
[2/7] vfio/pci.c: Remove double include for assert.h
      https://git.kernel.org/will/kvmtool/c/3d3dca077ae2
[3/7] pci: Fix pci_dev_* print macros
      https://git.kernel.org/will/kvmtool/c/34bfe5f632a4
[4/7] vfio/pci: Rename PBA offset in device descriptor to fd_offset
      https://git.kernel.org/will/kvmtool/c/5f44d5d6e45f
[5/7] vfio/pci: Rework MSIX table and PBA physical size allocation
      https://git.kernel.org/will/kvmtool/c/f93acc042fbd
[6/7] vfio/pci: Print an error when offset is outside of the MSIX table or PBA
      https://git.kernel.org/will/kvmtool/c/b20d6e302940
[7/7] vfio/pci: Align MSIX Table and PBA size to guest maximum page size
      https://git.kernel.org/will/kvmtool/c/39181fc6429f

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
