Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597D43402B5
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 11:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhCRKFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 06:05:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229600AbhCRKFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 06:05:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AE6464F38;
        Thu, 18 Mar 2021 10:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616061903;
        bh=KddoL2XE4uBf99evSPlBM3odoKUqV8uiIdkiEMeuARg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YwxOfGYU2tGsaOJ4g3FJ8E2dmNIGYdQiKcKsPfiwIeTC6Akd6uuzqZDMBpTXYBB8C
         wPaxvzP0yq1Vb3qFQoqyLMJS8Gi3b1oLhYw96Ir5KL91s1b8FT4LTQ9ZSOV3DLyru8
         uMRu/5KLQnx+jSW5UazRXg4hPcGVZ0j+pKxU8FAJ391aT1AjdCbgdJebQFGFsU7QjU
         1TSDU/T3sLV7GiDb16dvnjpb5lpJ0VQF+4mBFldm8m5kVBb+9089v4/iE2nT9rZkiZ
         T0z3vUwUI6gksslbP92OCnvL7/lqYzpscNm70Jeu4kN5FXBVFkxfQvWNx7VprqWH0+
         zAjfub8bIx6HQ==
From:   Will Deacon <will@kernel.org>
To:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andre Przywara <andre.przywara@arm.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Sami Mujawar <sami.mujawar@arm.com>,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool v3 00/22] Unify I/O port and MMIO trap handling
Date:   Thu, 18 Mar 2021 10:04:55 +0000
Message-Id: <161606068634.550587.17439092982108275200.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210315153350.19988-1-andre.przywara@arm.com>
References: <20210315153350.19988-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Mar 2021 15:33:28 +0000, Andre Przywara wrote:
> this version is addressing Alexandru's comments, fixing mostly minor
> issues in the naming scheme. The biggest change is to keep the
> ioport__read/ioport_write wrappers for the serial device.
> For more details see the changelog below.
> ==============
> 
> At the moment we use two separate code paths to handle exits for
> KVM_EXIT_IO (ioport.c) and KVM_EXIT_MMIO (mmio.c), even though they
> are semantically very similar. Because the trap handler callback routine
> is different, devices need to decide on one conduit or need to provide
> different handler functions for both of them.
> 
> [...]

Applied to kvmtool (master), thanks!

[01/22] ioport: Remove ioport__setup_arch()
        https://git.kernel.org/will/kvmtool/c/97531eb2ca70
[02/22] hw/serial: Use device abstraction for FDT generator function
        https://git.kernel.org/will/kvmtool/c/a81be31eee6e
[03/22] ioport: Retire .generate_fdt_node functionality
        https://git.kernel.org/will/kvmtool/c/9bc7e2ce343e
[04/22] mmio: Extend handling to include ioport emulation
        https://git.kernel.org/will/kvmtool/c/96f0c86ce221
[05/22] hw/i8042: Clean up data types
        https://git.kernel.org/will/kvmtool/c/fc7696277b29
[06/22] hw/i8042: Refactor trap handler
        https://git.kernel.org/will/kvmtool/c/f7ef3dc0cd28
[07/22] hw/i8042: Switch to new trap handlers
        https://git.kernel.org/will/kvmtool/c/d24bedb1cc9a
[08/22] x86/ioport: Refactor trap handlers
        https://git.kernel.org/will/kvmtool/c/82304999f936
[09/22] x86/ioport: Switch to new trap handlers
        https://git.kernel.org/will/kvmtool/c/3adbcb235020
[10/22] hw/rtc: Refactor trap handlers
        https://git.kernel.org/will/kvmtool/c/8c45f36430bd
[11/22] hw/rtc: Switch to new trap handler
        https://git.kernel.org/will/kvmtool/c/123ee474b97b
[12/22] hw/vesa: Switch trap handling to use MMIO handler
        https://git.kernel.org/will/kvmtool/c/38ae332ffcec
[13/22] hw/serial: Refactor trap handler
        https://git.kernel.org/will/kvmtool/c/47a510600e08
[14/22] hw/serial: Switch to new trap handlers
        https://git.kernel.org/will/kvmtool/c/59866df60b4b
[15/22] vfio: Refactor ioport trap handler
        https://git.kernel.org/will/kvmtool/c/a4a0dac75469
[16/22] vfio: Switch to new ioport trap handlers
        https://git.kernel.org/will/kvmtool/c/579bc61f8798
[17/22] virtio: Switch trap handling to use MMIO handler
        https://git.kernel.org/will/kvmtool/c/205eaa794be7
[18/22] pci: Switch trap handling to use MMIO handler
        https://git.kernel.org/will/kvmtool/c/1f56b9d10a28
[19/22] Remove ioport specific routines
        https://git.kernel.org/will/kvmtool/c/7e19cb54a7cc
[20/22] arm: Reorganise and document memory map
        https://git.kernel.org/will/kvmtool/c/f01cc778bd65
[21/22] hw/serial: ARM/arm64: Use MMIO at higher addresses
        https://git.kernel.org/will/kvmtool/c/45b4968e0de1
[22/22] hw/rtc: ARM/arm64: Use MMIO at higher addresses
        https://git.kernel.org/will/kvmtool/c/382eaad7b695

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
