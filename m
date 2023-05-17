Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5352A7064D8
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 12:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjEQKGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 06:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbjEQKGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 06:06:13 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1BEA1B3
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 03:06:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 67CD31FB;
        Wed, 17 May 2023 03:06:56 -0700 (PDT)
Received: from [10.57.58.217] (unknown [10.57.58.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1B3E3F663;
        Wed, 17 May 2023 03:06:09 -0700 (PDT)
Message-ID: <fe6f3e07-e24e-65a9-510f-00bdb25ae807@arm.com>
Date:   Wed, 17 May 2023 11:06:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 0/2] KVM: arm64: Handle MTE Set/Way CMOs
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
References: <20230515204601.1270428-1-maz@kernel.org>
Content-Language: en-GB
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <20230515204601.1270428-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/05/2023 21:45, Marc Zyngier wrote:
> When the MTE support was added, it seens the handling of MTE Set/Way
> was ommited, meaning that the guest will get an UNDEF if it tries to
> do something that is quite stupid, but still allowed by the
> architecture...

Sorry about that, as you say it's quite a stupid thing for a guest to
attempt and it hadn't occurred to me when implementing KVM support.

Both patches:

Reviewed-by: Steven Price <steven.price@arm.com>

Thanks,

Steve

> 
> Found by inspection while writting the trap support for NV.
> 
> Marc Zyngier (2):
>   arm64: Add missing Set/Way CMO encodings
>   KVM: arm64: Handle trap of tagged Set/Way CMOs
> 
>  arch/arm64/include/asm/sysreg.h |  6 ++++++
>  arch/arm64/kvm/sys_regs.c       | 19 +++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 

