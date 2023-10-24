Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69007D5B89
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 21:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344278AbjJXTeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 15:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344261AbjJXTeX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 15:34:23 -0400
Received: from out-204.mta1.migadu.com (out-204.mta1.migadu.com [IPv6:2001:41d0:203:375::cc])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C58510D4
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 12:34:20 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698176058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VGFv9nNyXkjRC7gzx1YN3bIT7P68k/2WpWgP/TeoPsc=;
        b=niDDOtUwCDYMF+cGtFw2Bxn0/z163ixYjhLvy4gn49nszXxU69mjJ3KtL3dW4COxOU5RRg
        BV5FoRin/Hxn9hlnVocN03Ov2/jyYaHwf1127MI1oQn3ko0k3QtS4bPf5TW/uE+zXOEAec
        nHA7nrPUsJkEd3ZitgHVHw+GB+eNN6w=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 0/2] KVM: arm64: PMU event filtering fixes
Date:   Tue, 24 Oct 2023 19:33:57 +0000
Message-ID: <169817600537.1684379.12304541130454554096.b4-ty@linux.dev>
In-Reply-To: <20231019185618.3442949-1-oliver.upton@linux.dev>
References: <20231019185618.3442949-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,TO_EQ_FM_DIRECT_MX autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Oct 2023 18:56:16 +0000, Oliver Upton wrote:
> PMU event exception level filtering fixes
> 
> Fixes to KVM's handling of the PMUv3 exception level filtering bits:
> 
>  - NSH (count at EL2) and M (count at EL3) should be stateful when the
>    respective EL is advertised in the ID registers but have no effect on
>    event counting.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/2] KVM: arm64: Make PMEVTYPER<n>_EL0.NSH RES0 if EL2 isn't advertised
      https://git.kernel.org/kvmarm/kvmarm/c/bc512d6a9b92
[2/2] KVM: arm64: Add PMU event filter bits required if EL3 is implemented
      https://git.kernel.org/kvmarm/kvmarm/c/ae8d3522e5b7

--
Best,
Oliver
