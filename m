Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79AD6787C7
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 21:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbjAWU3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 15:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjAWU3V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 15:29:21 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A2E26AF
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 12:29:21 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674505759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JNKgjEey+jD1QCB2y7BoSEW91Ll3Cspvy/BSqQryTQo=;
        b=cZjkYP94sB3Uph5potWP3gkjVjMey9Xpxkp9Id1CgSUufnH3qAUwbszZoxjyO0oGn3vqk/
        zOFccW7rLYVq+vweDrlnZdpewe1i+Ndp0B62ri8RpDUSfCqKOlrRSmT21vOP8szG8+zeJ/
        UI8pvBHKq+aSBu565/V4Ugr45ZgdLvI=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Limit IPI-ing when accessing GICR_{C,S}ACTIVER0
Date:   Mon, 23 Jan 2023 20:29:09 +0000
Message-Id: <167450419462.2571033.11871060147028793348.b4-ty@linux.dev>
In-Reply-To: <20230112154840.1808595-1-maz@kernel.org>
References: <20230112154840.1808595-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 15:48:40 +0000, Marc Zyngier wrote:
> When a vcpu is accessing *its own* redistributor's SGIs/PPIs, there
> is no point in doing a stop-the-world operation. Instead, we can
> just let the access occur as we do with GICv2.
> 
> This is a very minor optimisation for a non-nesting guest, but
> a potentially major one for a nesting L1 hypervisor which is
> likely to access the emulated registers pretty often (on each
> vcpu switch, at the very least).
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: vgic-v3: Limit IPI-ing when accessing GICR_{C,S}ACTIVER0
      https://git.kernel.org/kvmarm/kvmarm/c/fd2b165ce2cc

--
Best,
Oliver
