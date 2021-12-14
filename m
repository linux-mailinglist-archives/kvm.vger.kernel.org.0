Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D364474634
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 16:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbhLNPS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 10:18:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45662 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbhLNPSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 10:18:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 529DB61565
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 15:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C3DC34601;
        Tue, 14 Dec 2021 15:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639495103;
        bh=uxvNWmo7E2cDPFH+8p6MIfTuS2eQzq+7lncs4TS9T2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBjP1jE2iBnxO5RmP/aXjVs0wG7HydRKdxvBCjXDXuO+qedOOnJ56+IJyyx5zn7pf
         ICfKEkXKCenRCB9MLEWFdHWeaP8fRaxU9+5Tt92mQN1XGlmDGhZ7ffPCUmuNeXZkM8
         w8odnEA2gycOAAw1fqWQvVCASRzOydJcRn4LWVLaiNGawrt5RtuHBy75c/jiw1pKj4
         mUpx/qSxk8tJEjFJT7RdBX/87D7N4p/qhAP65uzP+o+akGMo9R6Iu/7hyobgrDWEnr
         4ygJeqDPEBV+kr8oadZVNOlBmZE/AmJMTt5wkEuSG9sTkAz8sGClU++OkHk5NrUb6h
         sJUxZBQ7yUMUQ==
From:   Will Deacon <will@kernel.org>
To:     Anup Patel <anup.patel@wdc.com>, maz@kernel.org,
        julien.thierry.kdev@gmail.com
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        Atish Patra <atishp@atishpatra.org>
Subject: Re: [PATCH v11 kvmtool 0/8] KVMTOOL RISC-V Support
Date:   Tue, 14 Dec 2021 15:18:10 +0000
Message-Id: <163949433071.4049230.18094387124072062307.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211119124515.89439-1-anup.patel@wdc.com>
References: <20211119124515.89439-1-anup.patel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Nov 2021 18:15:07 +0530, Anup Patel wrote:
> This series adds RISC-V support for KVMTOOL and it is based on the
> Linux-5.16-rc1. The KVM RISC-V patches have been merged in the Linux
> kernel since 5.16-rc1.
> 
> The KVMTOOL RISC-V patches can be found in riscv_master branch at:
> https//github.com/kvm-riscv/kvmtool.git
> 
> [...]

Applied to kvmtool (master), thanks!

[1/8] update_headers: Sync-up ABI headers with Linux-5.16-rc1
      https://git.kernel.org/will/kvmtool/c/5968b5ff26bb
[2/8] riscv: Initial skeletal support
      https://git.kernel.org/will/kvmtool/c/2e99678314c2
[3/8] riscv: Implement Guest/VM arch functions
      https://git.kernel.org/will/kvmtool/c/867159a7963b
[4/8] riscv: Implement Guest/VM VCPU arch functions
      https://git.kernel.org/will/kvmtool/c/42bfe448c1c3
[5/8] riscv: Add PLIC device emulation
      https://git.kernel.org/will/kvmtool/c/762224e47cc2
[6/8] riscv: Generate FDT at runtime for Guest/VM
      https://git.kernel.org/will/kvmtool/c/7c9aac003925
[7/8] riscv: Handle SBI calls forwarded to user space
      https://git.kernel.org/will/kvmtool/c/721da166a698
[8/8] riscv: Generate PCI host DT node
      https://git.kernel.org/will/kvmtool/c/cdd7d8cc0109

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
