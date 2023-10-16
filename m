Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D427CA85B
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 14:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbjJPMrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 08:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbjJPMrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 08:47:11 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64CF0ED
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 05:47:09 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DD0DDA7;
        Mon, 16 Oct 2023 05:47:49 -0700 (PDT)
Received: from [10.57.1.186] (unknown [10.57.1.186])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2218E3F5A1;
        Mon, 16 Oct 2023 05:47:08 -0700 (PDT)
Message-ID: <88ba308b-762f-fb7a-0324-eefae2efe464@arm.com>
Date:   Mon, 16 Oct 2023 13:47:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v2 0/2] KVM: arm64: PMU event filtering fixes
To:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20231013052901.170138-1-oliver.upton@linux.dev>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20231013052901.170138-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/2023 06:28, Oliver Upton wrote:
> Set of fixes to KVM's handling of the exception level event filtering in
> the PMU event type registers.
> 
> I dropped the PMU+NV disablement this time around as we need a complete
> fix for that problem. At the same time, I want to get a rework of our
> sysreg masks upstream soon to avoid any negative interaction with new
> PMU features going in on the driver side of things.
> 
> Additionally, I added a fix for the non-secure filtering bits that
> Suzuki had spotted (thanks!)
> 
> Oliver Upton (2):
>    KVM: arm64: Treat PMEVTYPER<n>_EL0.NSH as RES0
>    KVM: arm64: Virtualise PMEVTYPER<n>_EL1.{NSU,NSK}
> 
>   arch/arm64/kvm/pmu-emul.c      | 26 +++++++++++++++++---------
>   arch/arm64/kvm/sys_regs.c      |  8 ++++++--
>   include/kvm/arm_pmu.h          |  5 +++++
>   include/linux/perf/arm_pmuv3.h |  8 +++++---
>   4 files changed, 33 insertions(+), 14 deletions(-)
> 
> 
> base-commit: 6465e260f48790807eef06b583b38ca9789b6072


For the series:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
