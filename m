Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F756787C4
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 21:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjAWU2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 15:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbjAWU2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 15:28:53 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DBC4C12
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 12:28:51 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674505729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J6Na5HPdYQumueESWAtILS5PbaewkSyT05UaySizfmg=;
        b=SkY8XFxoqZH/i7erZ9tU01KwzOnocihjrjhXnjmrRPtaBOBxPb3Edt2FkenRpBeslRVQ4r
        i+/iZSoeweo0eDyDov0V7pMi1GhAql5QkTAnDMJF4vzpnHAelQmBnHCe0YIbpwSS88gspK
        7jE1XUExFjFjWw2DURgVsyiYn+CXIN4=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Kill CPACR_EL1_TTA definition
Date:   Mon, 23 Jan 2023 20:28:38 +0000
Message-Id: <167450411333.2570464.16313880797706670802.b4-ty@linux.dev>
In-Reply-To: <20230112154803.1808559-1-maz@kernel.org>
References: <20230112154803.1808559-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 15:48:03 +0000, Marc Zyngier wrote:
> Since the One True Way is to use the new generated definition,
> kill the KVM-specific definition of CPACR_EL1_TTA, and move
> over to CPACR_ELx_TTA, hopefully for the same result.
> 
> 

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Kill CPACR_EL1_TTA definition
      https://git.kernel.org/kvmarm/kvmarm/c/7a5e9c8f0b2d

--
Best,
Oliver
