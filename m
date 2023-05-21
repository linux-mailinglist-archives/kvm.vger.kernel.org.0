Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C64770AFC7
	for <lists+kvm@lfdr.de>; Sun, 21 May 2023 21:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjEUTUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 May 2023 15:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjEUTUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 May 2023 15:20:05 -0400
Received: from out-12.mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A3DD1
        for <kvm@vger.kernel.org>; Sun, 21 May 2023 12:20:03 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684696801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UU9OP6GElzHy+Yh91vI4KeIdi/8W8EkfCUnsjLKuS98=;
        b=a5yVA71H13P4BRMca95xZA700GNT5VmrQydDHolH2mP8Y5bhZD7LgbRbrmUN9d5n91PZFv
        hmkPvdTlFF+wVs845PLlK53SaSEYe/Ov0flRT4UjCqL8RpcA8fFKXc2z1nbVpAVZCxvL+Z
        +8Z3fPI5bgmSbCMyCvooPVVCigkOZtg=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Relax trapping of CTR_EL0 when FEAT_EVT is available
Date:   Sun, 21 May 2023 19:19:50 +0000
Message-ID: <168469633655.1380373.17609383771397650020.b4-ty@linux.dev>
In-Reply-To: <20230515170016.965378-1-maz@kernel.org>
References: <20230515170016.965378-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 May 2023 18:00:16 +0100, Marc Zyngier wrote:
> CTR_EL0 can often be used in userspace, and it would be nice if
> KVM didn't have to emulate it unnecessarily.
> 
> While it isn't possible to trap the cache configuration registers
> indemendently from CTR_EL0 in the base ARMv8.0 architecture, FEAT_EVT
> allows these cache configuration registers (CCSIDR_EL1, CCSIDR2_EL1,
> CLIDR_EL1 and CSSELR_EL1) to be trapped indepdently by setting
> HCR_EL2.TID4.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Relax trapping of CTR_EL0 when FEAT_EVT is available
      https://git.kernel.org/kvmarm/kvmarm/c/c876c3f182a5

--
Best,
Oliver
