Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D654A7319C8
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 15:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343903AbjFONVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 09:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343894AbjFONVN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 09:21:13 -0400
Received: from out-27.mta1.migadu.com (out-27.mta1.migadu.com [IPv6:2001:41d0:203:375::1b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0346270B
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 06:21:10 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686835268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1N2PfJFS89EFOCSeE5U73sMtxej+HkxZvFHecxXs22o=;
        b=ZnJKmAicUuKmbZxF+wZbgqPIu++0g4lbc80cJAGwX5M4XpVw7X9YrfnB43Xyby9thkWZja
        jZL01bIPK/M9OTb/N3Al4GmPIO+GqOrL3n12p4PA/f7fNp97+g8Q68K556KLOIdHor3nyq
        1j2mA0l0tNrIuJpF6C5MlXO3g+9BSeE=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] KVM: arm64: Fix hVHE init on CPUs where HCR_EL2.E2H is not RES1
Date:   Thu, 15 Jun 2023 13:20:19 +0000
Message-ID: <168683521445.136757.9747840058175928962.b4-ty@linux.dev>
In-Reply-To: <20230614155129.2697388-1-maz@kernel.org>
References: <20230614155129.2697388-1-maz@kernel.org>
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

On Wed, 14 Jun 2023 16:51:29 +0100, Marc Zyngier wrote:
> On CPUs where E2H is RES1, we very quickly set the scene for
> running EL2 with a VHE configuration, as we do not have any other
> choice.
> 
> However, CPUs that conform to the current writing of the architecture
> start with E2H=0, and only later upgrade with E2H=1. This is all
> good, but nothing there is actually reconfiguring EL2 to be able
> to correctly run the kernel at EL1. Huhuh...
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Fix hVHE init on CPUs where HCR_EL2.E2H is not RES1
      https://git.kernel.org/kvmarm/kvmarm/c/1700f89cb99a

--
Best,
Oliver
