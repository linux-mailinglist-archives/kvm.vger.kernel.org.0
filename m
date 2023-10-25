Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815ED7D61C2
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 08:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbjJYGlk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 02:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjJYGlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 02:41:37 -0400
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DB2116
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 23:41:34 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698216092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+V0mzmAUC1BLMA6lZuW823syAxcLjG1i2u4rDFTorWY=;
        b=UOfJZblTBXvpo+sqavXRO7S8jQ0uW0ezlISMVjfdvwkUKm5MdXo7uD01YkBNcXjuOLdYj5
        bsagzk8bQh0cwGhBPAjhO6if9mHbeNNEQWBdKJ4djdBRH9kv06NCo7/V9aPLn+3jfNa8R3
        tg8QOki/wRn7s6NYMlY3TwT5D+IFNDI=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 0/5] KVM: arm64: NV trap forwarding fixes
Date:   Wed, 25 Oct 2023 06:40:16 +0000
Message-ID: <169821600970.2314766.13640889926051230442.b4-ty@linux.dev>
In-Reply-To: <20231023095444.1587322-1-maz@kernel.org>
References: <20231023095444.1587322-1-maz@kernel.org>
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

On Mon, 23 Oct 2023 10:54:39 +0100, Marc Zyngier wrote:
> As Miguel was reworking some of the NV trap list, it became clear that
> the 32bit handling didn't get much love. So I've taken Miguel's
> series, massaged it a bit, and added my own stuff.
> 
> Apart from the last patch, the all have been on the list and reviewed.
> I was hoping to take it into 6.6, but some of the late rework and the
> required testing have made it impossible.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/5] arm64: Add missing _EL12 encodings
      https://git.kernel.org/kvmarm/kvmarm/c/d5cb781b7741
[2/5] arm64: Add missing _EL2 encodings
      https://git.kernel.org/kvmarm/kvmarm/c/41f6c9344713
[3/5] KVM: arm64: Refine _EL2 system register list that require trap reinjection
      https://git.kernel.org/kvmarm/kvmarm/c/04cf54650554
[4/5] KVM: arm64: Do not let a L1 hypervisor access the *32_EL2 sysregs
      https://git.kernel.org/kvmarm/kvmarm/c/c7d11a61c7f7
[5/5] KVM: arm64: Handle AArch32 SPSR_{irq,abt,und,fiq} as RAZ/WI
      https://git.kernel.org/kvmarm/kvmarm/c/3f7915ccc902

--
Best,
Oliver
