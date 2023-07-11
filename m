Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6692574F89A
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 22:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjGKUBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 16:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjGKUBT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 16:01:19 -0400
Received: from out-5.mta1.migadu.com (out-5.mta1.migadu.com [95.215.58.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D9710D2
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 13:01:18 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689105676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BW7lu2mzgzGoDumkBjzINg6OFqwOhCaVlVWH0EynxSc=;
        b=lyVgupKC1qIjP3KD7eNvfKsAd1v8v8em8uJUofb+1dh3vYQFcPEvTWdYYG44rmUuKc4Eb1
        AraP3PTFuP5b/Oq+8JOUkFnSgIuVdVugPlvBC2QLTHA17Sqre82Yd8QB8liZjhKSMjHljd
        V4LCRrvNUnqzy3bVFke3mZmZrPGQ9OU=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: timers: Use CNTHCTL_EL2 when setting non-CNTKCTL_EL1 bits
Date:   Tue, 11 Jul 2023 20:00:46 +0000
Message-ID: <168910562677.2605377.4826778238561780912.b4-ty@linux.dev>
In-Reply-To: <20230627140557.544885-1-maz@kernel.org>
References: <20230627140557.544885-1-maz@kernel.org>
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

On Tue, 27 Jun 2023 15:05:57 +0100, Marc Zyngier wrote:
> It recently appeared that, whien running VHE, there is a notable
> difference between using CNTKCTL_EL1 and CNTHCTL_EL2, despite what
> the architecture documents:
> 
> - When accessed from EL2, bits [19:18] and [16:10] same bits have
>   the same assignment as CNTHCTL_EL2
> - When accessed from EL1, bits [19:18] and [16:10] are RES0
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: timers: Use CNTHCTL_EL2 when setting non-CNTKCTL_EL1 bits
      https://git.kernel.org/kvmarm/kvmarm/c/fe769e6c1f80

--
Best,
Oliver
