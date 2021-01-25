Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF53030343B
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732080AbhAZFU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:20:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:52710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730753AbhAYQeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 11:34:11 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5065F22510;
        Mon, 25 Jan 2021 16:33:30 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l44nw-009ujO-DD; Mon, 25 Jan 2021 16:33:28 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Cc:     zhukeqian1@huawei.com, James Morse <james.morse@arm.com>,
        yuzenghui@huawei.com, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        yezengruan@huawei.com, Gavin Shan <gshan@redhat.com>,
        wanghaibin.wang@huawei.com, Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 0/3] Some optimization for stage-2 translation
Date:   Mon, 25 Jan 2021 16:33:25 +0000
Message-Id: <161159237705.2330282.4465806083809381814.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210114121350.123684-1-wangyanan55@huawei.com>
References: <20210114121350.123684-1-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, wangyanan55@huawei.com, linux-arm-kernel@lists.infradead.org, will@kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, zhukeqian1@huawei.com, james.morse@arm.com, yuzenghui@huawei.com, suzuki.poulose@arm.com, julien.thierry.kdev@gmail.com, yezengruan@huawei.com, gshan@redhat.com, wanghaibin.wang@huawei.com, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jan 2021 20:13:47 +0800, Yanan Wang wrote:
> This patch series(v3) make some optimization for stage-2 translation.
> 
> About patch-1:
> Procedures of hyp stage-1 map and guest stage-2 map are quite different,
> but they are now tied closely by function kvm_set_valid_leaf_pte().
> So adjust the relative code for ease of code maintenance in the future.
> 
> [...]

Applied to kvm-arm64/concurrent-translation-fault, thanks!

[1/3] KVM: arm64: Adjust partial code of hyp stage-1 map and guest stage-2 map
      commit: 8ed80051c8c31d1587722fdb3af16677eba9d693
[2/3] KVM: arm64: Filter out the case of only changing permissions from stage-2 map path
      commit: 694d071f8d85d504055540a27f0dbe9dbf44584e
[3/3] KVM: arm64: Mark the page dirty only if the fault is handled successfully
      commit: 509552e65ae8287178a5cdea2d734dcd2d6380ab

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


