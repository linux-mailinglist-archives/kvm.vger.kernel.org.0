Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13048477A70
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 18:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbhLPRUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 12:20:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47374 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbhLPRUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 12:20:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46E85B82477
        for <kvm@vger.kernel.org>; Thu, 16 Dec 2021 17:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EA5C36AE4;
        Thu, 16 Dec 2021 17:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639675205;
        bh=DmJfUcVa4WEqw43aPD7aqrGwtV991ysCoXXGRte8rfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPfIYfhhoIQdTv3KtxoKer/kqPUZbH6iRehQhuTNeMIsNx7kUjQmxZKSYhhqVBpKT
         LjLlUbTcsuxjyrorzpSRBCpAGuCZeGjTg/474oqq2+MONhNgz/n60z6sQx4Bpg33+G
         M5QX3YONFJZG8/NvXcbCXC3G9uwWqRvxPElbfKsWqb61anv1LFtBRBV16q+zwgIQjF
         UmYhFWBtYo/+Lqx8dN/uscJUU61qWpIOr7EjmgT1lGpuAuyvlY7mkzDs00lbT/XOFS
         e/hUfeE+dFKHPHHeRdQk+wHOF1XdbCFtu1v++kSOgl6LbPhzWS9n3sQPAy+toNMx5P
         CLNJWmK5q+45A==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mxuQE-00CaTQ-TO; Thu, 16 Dec 2021 17:20:02 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        kernel-team@android.com, qperret@google.com
Subject: Re: (subset) [PATCH v5 00/69] KVM: arm64: ARMv8.3/8.4 Nested Virtualization support
Date:   Thu, 16 Dec 2021 17:19:55 +0000
Message-Id: <163967515734.1690660.13878910598737761364.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, andre.przywara@arm.com, gankulkarni@os.amperecomputing.com, christoffer.dall@arm.com, kernel-team@android.com, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 29 Nov 2021 20:00:41 +0000, Marc Zyngier wrote:
> Here the bi-annual drop of the KVM/arm64 NV support code, the least
> loved series in the history of KVM!
> 
> Not a lot has changed since [1]: a number of bug fixes (wrong MMU
> context being selected leading to failing TLB invalidations, fixes
> around the handling of nested faults), a complete rewrite of the early
> exit handling, a change in the way the NV support is enabled
> ("kvm-arm.mode=nested"), and a rebase on top of 5.16-rc1.
> 
> [...]

Applied to next, thanks!

[04/69] KVM: arm64: Rework kvm_pgtable initialisation
        commit: 9d8604b28575ccab3afd8d6f56cab9a6c0d281ef

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


