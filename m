Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FE2754574
	for <lists+kvm@lfdr.de>; Sat, 15 Jul 2023 01:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjGNXjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 19:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjGNXjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 19:39:21 -0400
Received: from out-34.mta0.migadu.com (out-34.mta0.migadu.com [IPv6:2001:41d0:1004:224b::22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2720A3A92
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 16:39:20 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689377957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jloQl3mwfaZfH8d2ByjCMyNRFlRxRtmSdVoT9U0tNLI=;
        b=J04/4lMyXDAWfmX2rtun1P9s5HmMvcf8GOs82atI3QV9KiCL6JMKMNwxYRYgrzKfJARGFj
        lY0CtDZXiD5FInWDe+aj8x+L4aYFhV5nH1vEVGfwL4KtjW6fOERBUym6Z6kgcgmMT2L6d1
        tIYv85R2zqRHcRDdr2WaenOnwrCQ2Kc=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     chenxiang <chenxiang66@hisilicon.com>, james.morse@arm.com,
        maz@kernel.org
Cc:     Oliver Upton <oliver.upton@linux.dev>, linuxarm@huawei.com,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Fix the name of sys_reg_desc related to PMU
Date:   Fri, 14 Jul 2023 23:39:08 +0000
Message-ID: <168937794037.1949583.6772215423683999782.b4-ty@linux.dev>
In-Reply-To: <1689305920-170523-1-git-send-email-chenxiang66@hisilicon.com>
References: <1689305920-170523-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jul 2023 11:38:40 +0800, chenxiang wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> For those PMU system registers defined in sys_reg_descs[], use macro
> PMU_SYS_REG() / PMU_PMEVCNTR_EL0 / PMU_PMEVTYPER_EL0 to define them, and
> later two macros call macro PMU_SYS_REG() actually.
> Currently the input parameter of PMU_SYS_REG() is another macro which is
> calculation formula of the value of system registers, so for example, if
> we want to "SYS_PMINTENSET_EL1" as the name of sys register, actually
> the name we get is as following:
> (((3) << 19) | ((0) << 16) | ((9) << 12) | ((14) << 8) | ((1) << 5))
> The name of system register is used in some tracepoints such as
> trace_kvm_sys_access(), if not set correctly, we need to analyze the
> inaccurate name to get the exact name (which also is inconsistent with
> other system registers), and also the inaccurate name occupies more space.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Fix the name of sys_reg_desc related to PMU
      https://git.kernel.org/kvmarm/kvmarm/c/9d2a55b403ee

--
Best,
Oliver
