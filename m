Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D927B42FF
	for <lists+kvm@lfdr.de>; Sat, 30 Sep 2023 20:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbjI3S1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Sep 2023 14:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbjI3S1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Sep 2023 14:27:20 -0400
Received: from out-190.mta1.migadu.com (out-190.mta1.migadu.com [IPv6:2001:41d0:203:375::be])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9368AE1
        for <kvm@vger.kernel.org>; Sat, 30 Sep 2023 11:27:17 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696098435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fHjWeUwUzHpdUMgKgpnqE1STeGfAbmIbXCpljrvsbfc=;
        b=xjnxJTmvhvgoi9ivxjvefbvnNTCPI5BKQkMFepeY32S9maH6zpDsqYlJwR9oTZ81sq4Bf7
        PzANH8q4fl9+cVaW6tkaCDUSfZYPHk1/AoWdp8jTSuaUR9+TxXqM3qCZp8FO8GGSadORtx
        j6Z5dJmuc+L2GyBGUKLbVGYKbKYMVAc=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Joey Gouly <joey.gouly@arm.com>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 00/11] KVM: arm64: Accelerate lookup of vcpus by MPIDR values (and other fixes)
Date:   Sat, 30 Sep 2023 18:27:03 +0000
Message-ID: <169609840956.1767077.12635408767994539864.b4-ty@linux.dev>
In-Reply-To: <20230927090911.3355209-1-maz@kernel.org>
References: <20230927090911.3355209-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Sep 2023 10:09:00 +0100, Marc Zyngier wrote:
> This is a follow-up on [2], which addresses both the O(n) SGI injection
> issue, and cleans up a number of embarassing bugs steaming form the
> vcpuid/vcpu_idx confusion.
> 
> See the changelog below for details.
> 
> Oliver, assuming that you haven't changed your mind and that
> nobody shouts, feel free to queue this in -next.
> 
> [...]

Applied to kvmarm/next, thanks!

[01/11] KVM: arm64: vgic: Make kvm_vgic_inject_irq() take a vcpu pointer
        https://git.kernel.org/kvmarm/kvmarm/c/9a0a75d3ccee
[02/11] KVM: arm64: vgic-its: Treat the collection target address as a vcpu_id
        https://git.kernel.org/kvmarm/kvmarm/c/d455d366c451
[03/11] KVM: arm64: vgic-v3: Refactor GICv3 SGI generation
        https://git.kernel.org/kvmarm/kvmarm/c/f3f60a565391
[04/11] KVM: arm64: vgic-v2: Use cpuid from userspace as vcpu_id
        https://git.kernel.org/kvmarm/kvmarm/c/4e7728c81a54
[05/11] KVM: arm64: vgic: Use vcpu_idx for the debug information
        https://git.kernel.org/kvmarm/kvmarm/c/ac0fe56d46c0
[06/11] KVM: arm64: Use vcpu_idx for invalidation tracking
        https://git.kernel.org/kvmarm/kvmarm/c/5f4bd815ec71
[07/11] KVM: arm64: Simplify kvm_vcpu_get_mpidr_aff()
        https://git.kernel.org/kvmarm/kvmarm/c/0a2acd38d23b
[08/11] KVM: arm64: Build MPIDR to vcpu index cache at runtime
        https://git.kernel.org/kvmarm/kvmarm/c/5544750efd51
[09/11] KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when mpidr_data is available
        https://git.kernel.org/kvmarm/kvmarm/c/54a8006d0b49
[10/11] KVM: arm64: vgic-v3: Optimize affinity-based SGI injection
        https://git.kernel.org/kvmarm/kvmarm/c/b5daffb120bb
[11/11] KVM: arm64: Clarify the ordering requirements for vcpu/RD creation
        https://git.kernel.org/kvmarm/kvmarm/c/f9940416f193

--
Best,
Oliver
