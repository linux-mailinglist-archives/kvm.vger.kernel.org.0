Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E2B56371D
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 17:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiGAPl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 11:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiGAPlz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 11:41:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8240E3FBF7
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 08:41:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E2716248A
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 15:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEB2C341C8;
        Fri,  1 Jul 2022 15:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656690113;
        bh=og68YfdXPEH3qKNVeVsGI9srdVkkQqbXkGUG4yvFvG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNW5yJMnC/kmRsIqGaeKijiYm7shqg6ShDVI6uyix23FOtMQmLa2OjUKlfK7FdnIl
         GzCOWV8kRsc+WeevE+L4Cw9UAlSLMNgWKyXbAyIfCxqdZnlwCj/hkyvKXiR5GywzGj
         2xwUbfmKicrN3Qr0LC34PVdt3iZsccY/joCtwWfI8nn2UUSz1sHKQAnGhMm+m9NsmH
         MB/cVRG6mSEsMS/+YdUzEKRvPCQQTRbYBIN6cdqLzsOWGtuBK/1M4BQpRRuzNdZWey
         Vo5Rgukl4rWn+XHYU37coXekIUVwa4u0MqJG5gD29Z4GqKS0l66TOWhSU1OHIQrpAj
         vI/GKll7ITnUQ==
From:   Will Deacon <will@kernel.org>
To:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, andre.przywara@arm.com,
        kvm@vger.kernel.org, sashal@kernel.org, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, jean-philippe@linaro.org
Subject: Re: [PATCH kvmtool v2 00/12] Virtio v1 support
Date:   Fri,  1 Jul 2022 16:41:29 +0100
Message-Id: <165668814104.3745495.15985302997775885106.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220701142434.75170-1-jean-philippe.brucker@arm.com>
References: <20220701142434.75170-1-jean-philippe.brucker@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 1 Jul 2022 15:24:22 +0100, Jean-Philippe Brucker wrote:
> This is version 2 of the modern virtio support for kvmtool.
> 
> Since v1 [1]:
> * Repaired vhost-net for pci-modern, by adding patches 4 and 5
> * Added patch 6 that extends the feature fields and simplifies modern
>   features handling
> * Added patch 12, a small cleanup
> 
> [...]

Applied to kvmtool (master), thanks!

[01/12] virtio/pci: Delete MSI routes
        https://git.kernel.org/will/kvmtool/c/c6590f782be6
[02/12] virtio: Extract init_vq() for PCI and MMIO
        https://git.kernel.org/will/kvmtool/c/d0607293c937
[03/12] virtio/pci: Make doorbell offset dynamic
        https://git.kernel.org/will/kvmtool/c/21c9bc744087
[04/12] virtio/pci: Use the correct eventfd for vhost notification
        https://git.kernel.org/will/kvmtool/c/73fd13686e22
[05/12] virtio/net: Set vhost backend after queue address
        https://git.kernel.org/will/kvmtool/c/de166e5f7edc
[06/12] virtio: Prepare for more feature bits
        https://git.kernel.org/will/kvmtool/c/3c8f82b8d4a7
[07/12] virtio: Move PCI transport to pci-legacy
        https://git.kernel.org/will/kvmtool/c/930876d51193
[08/12] virtio: Add support for modern virtio-pci
        https://git.kernel.org/will/kvmtool/c/b0d56e3c994a
[09/12] virtio: Move MMIO transport to mmio-legacy
        https://git.kernel.org/will/kvmtool/c/22a0823676f1
[10/12] virtio: Add support for modern virtio-mmio
        https://git.kernel.org/will/kvmtool/c/5fe5eb04de80
[11/12] virtio/pci: Initialize all vectors to VIRTIO_MSI_NO_VECTOR
        https://git.kernel.org/will/kvmtool/c/3d5cefc2eb3e
[12/12] virtio/pci: Remove VIRTIO_PCI_F_SIGNAL_MSI
        https://git.kernel.org/will/kvmtool/c/c86ef0b86366

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
