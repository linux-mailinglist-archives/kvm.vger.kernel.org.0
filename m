Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A53A7C6E71
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 14:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347163AbjJLMr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 08:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343872AbjJLMrY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 08:47:24 -0400
Received: from out-202.mta1.migadu.com (out-202.mta1.migadu.com [95.215.58.202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F7491
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 05:47:23 -0700 (PDT)
Date:   Thu, 12 Oct 2023 12:47:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697114841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WZ9ACy9q0K8a//vgGJWNbpd56b9FY1ywZnapIJn+tJU=;
        b=rRGaIjbL/RroesD2jDenYXaZsImfXC+68rPBgYiL69+Q/CmWrnjsYwZBYMc3NBAIKKnUnc
        jWjqQ2SO5Kc18nTS0dx7iWHAorLtqg7fRvPI5Z6luG62NrJoRW2p5Xtg2cQw5gpg91TGfq
        QTEIlyQqDXYjoUgGt/m3TKi8Sp37beI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     James Clark <james.clark@arm.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 2/2] KVM: arm64: Treat PMEVTYPER<n>_EL0.NSH as RES0
Message-ID: <ZSfq1Im2k2JVIY5H@linux.dev>
References: <20231011081649.3226792-1-oliver.upton@linux.dev>
 <20231011081649.3226792-3-oliver.upton@linux.dev>
 <2e724a19-1a58-ac6d-1697-c4a2b7a6962a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e724a19-1a58-ac6d-1697-c4a2b7a6962a@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 12, 2023 at 10:43:30AM +0100, James Clark wrote:
> ARMV8_PMU_EVTYPE_MASK is still used in access_pmu_evtyper() and
> reset_pmevtyper(), although it's not really an issue if you can't set
> the bits in the first place. But it probably makes sense to use the same
> mask everywhere.

Agreed. Well, the masking done for reads in access_pmu_evtyper() is
pointless since we sanitise the value when written. I'll update
reset_pmevtyper() though.

-- 
Thanks,
Oliver
