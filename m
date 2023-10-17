Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B5F7CBCF1
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 09:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbjJQH7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 03:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjJQH7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 03:59:13 -0400
Received: from out-206.mta0.migadu.com (out-206.mta0.migadu.com [IPv6:2001:41d0:1004:224b::ce])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55D493
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 00:59:11 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697529550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G1kYh2Q4VYYngM8yqVtVdbokk228ME22Rcp9maAMl5I=;
        b=RmBkn54ovRBxvCVKMh/lfW/h28uMK+pcDzuvheqUTV8vNPJJhF2W1iUI4ylHE8oFF1oeOy
        b5YYXzXXJd73eDKY3CbXyfWJSJuuG0xtYhS/rAmQpxtruEZTmG3346uCYzxFmkxZGFGFGE
        +Or7kh+7R1VSk9MiNdp9zps65RDrbIY=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v2 0/5] KVM: arm64: Load stage-2 in vcpu_load() on VHE
Date:   Tue, 17 Oct 2023 07:58:46 +0000
Message-ID: <169752952219.1493360.2687310984257403037.b4-ty@linux.dev>
In-Reply-To: <20231012205422.3924618-1-oliver.upton@linux.dev>
References: <20231012205422.3924618-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,TO_EQ_FM_DIRECT_MX autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Oct 2023 20:54:17 +0000, Oliver Upton wrote:
> Clearly my half-assed attempt at this series needed a bit of TLC.
> Respinning with Marc's diff to make sure the stage-2 is in a consistent
> state after VMID rollover and MMU notifiers triggering TLB invalidation.
> 
> v2: https://lore.kernel.org/kvmarm/20231006093600.1250986-1-oliver.upton@linux.dev/
> 
> Marc Zyngier (2):
>   KVM: arm64: Restore the stage-2 context in VHE's
>     __tlb_switch_to_host()
>   KVM: arm64: Reload stage-2 for VMID change on VHE
> 
> [...]

Applied to kvmarm/next, thanks!

[1/5] KVM: arm64: Don't zero VTTBR in __tlb_switch_to_host()
      https://git.kernel.org/kvmarm/kvmarm/c/65221c1f57f6
[2/5] KVM: arm64: Restore the stage-2 context in VHE's __tlb_switch_to_host()
      https://git.kernel.org/kvmarm/kvmarm/c/35a647ce2419
[3/5] KVM: arm64: Reload stage-2 for VMID change on VHE
      https://git.kernel.org/kvmarm/kvmarm/c/052166906b67
[4/5] KVM: arm64: Rename helpers for VHE vCPU load/put
      https://git.kernel.org/kvmarm/kvmarm/c/8f7d6be28d46
[5/5] KVM: arm64: Load the stage-2 MMU context in kvm_vcpu_load_vhe()
      https://git.kernel.org/kvmarm/kvmarm/c/0556bbf8a5ed

--
Best,
Oliver
