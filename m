Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494F33AC9FD
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 13:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbhFRLkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 07:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231128AbhFRLkp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 07:40:45 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 205E961260;
        Fri, 18 Jun 2021 11:38:36 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1luCpV-008QYN-2u; Fri, 18 Jun 2021 12:38:33 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-kernel@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Quentin Perret <qperret@google.com>
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        zhukeqian1@huawei.com, yuzenghui@huawei.com,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>, wanghaibin.wang@huawei.com
Subject: Re: [PATCH v7 0/4] KVM: arm64: Improve efficiency of stage2 page table
Date:   Fri, 18 Jun 2021 12:38:27 +0100
Message-Id: <162401627606.3015641.17627283030372951514.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210617105824.31752-1-wangyanan55@huawei.com>
References: <20210617105824.31752-1-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, alexandru.elisei@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, wangyanan55@huawei.com, qperret@google.com, julien.thierry.kdev@gmail.com, zhukeqian1@huawei.com, yuzenghui@huawei.com, suzuki.poulose@arm.com, gshan@redhat.com, catalin.marinas@arm.com, james.morse@arm.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Jun 2021 18:58:20 +0800, Yanan Wang wrote:
> This series makes some efficiency improvement of guest stage-2 page
> table code, and there are some test results to quantify the benefit.
> 
> Description for this series:
> We currently uniformly permorm CMOs of D-cache and I-cache in function
> user_mem_abort before calling the fault handlers. If we get concurrent
> guest faults(e.g. translation faults, permission faults) or some really
> unnecessary guest faults caused by BBM, CMOs for the first vcpu are
> necessary while the others later are not.
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: Introduce two cache maintenance callbacks
      commit: 6204004de3160900435bdb4b9a2fb8749a9277d2
[2/4] KVM: arm64: Introduce mm_ops member for structure stage2_attr_data
      commit: a4d5ca5c7cd8fe85056b8cb838fbcb7e5a05f356
[3/4] KVM: arm64: Tweak parameters of guest cache maintenance functions
      commit: 378e6a9c78a02b4b609846aa0afccf34d3038977
[4/4] KVM: arm64: Move guest CMOs to the fault handlers
      commit: 25aa28691bb960a76f0cffd8862144a29487f6ff

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


