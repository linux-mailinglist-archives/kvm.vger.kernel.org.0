Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F9F7D163E
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 21:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjJTTRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 15:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJTTRd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 15:17:33 -0400
Received: from out-207.mta1.migadu.com (out-207.mta1.migadu.com [95.215.58.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC081A8
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 12:17:31 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697829449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJIDp3kn3J9YYqvI7e1P1Uh08vnn+UrS9mMpb3yPd6Q=;
        b=UuGnDEPcvOoDcHuVVctCpYwXIpYG4p4fFch3ajCp9SJC1XZtdlum8UjoLQnLhQR8t7DwYD
        zDdqL4SendwJ8cr58LzgBiOgxK0VEiBAXsJVYGDevHC17K5OvYzKYr0B6t6UKxKxZoimnd
        PYSDr78UrJOiL86tCwix34r6vn8VaZo=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>, kvm@vger.kernel.org,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 0/5] KVM: arm64: Load stage-2 in vcpu_load() on VHE
Date:   Fri, 20 Oct 2023 19:16:53 +0000
Message-ID: <169782936475.237746.6910655136004742028.b4-ty@linux.dev>
In-Reply-To: <20231018233212.2888027-1-oliver.upton@linux.dev>
References: <20231018233212.2888027-1-oliver.upton@linux.dev>
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

On Wed, 18 Oct 2023 23:32:07 +0000, Oliver Upton wrote:
> Thanks Zenghui for the review, I've addressed your feedback.
> 
> v2: https://lore.kernel.org/kvmarm/20231012205422.3924618-1-oliver.upton@linux.dev/
> 
> v2 -> v3:
>  - Save the right context in __tlb_switch_to_guest()
>  - Drop stale declarations from kvm_hyp.h
>  - Fix typo in changelog
> 
> [...]

Applied to kvmarm/next, thanks!

[1/5] KVM: arm64: Don't zero VTTBR in __tlb_switch_to_host()
      https://git.kernel.org/kvmarm/kvmarm/c/38ce26bf2666
[2/5] KVM: arm64: Restore the stage-2 context in VHE's __tlb_switch_to_host()
      https://git.kernel.org/kvmarm/kvmarm/c/4288ff7ba195
[3/5] KVM: arm64: Reload stage-2 for VMID change on VHE
      https://git.kernel.org/kvmarm/kvmarm/c/5eba523e1e5e
[4/5] KVM: arm64: Rename helpers for VHE vCPU load/put
      https://git.kernel.org/kvmarm/kvmarm/c/27cde4c0fe28
[5/5] KVM: arm64: Load the stage-2 MMU context in kvm_vcpu_load_vhe()
      https://git.kernel.org/kvmarm/kvmarm/c/934bf871f011

--
Best,
Oliver
