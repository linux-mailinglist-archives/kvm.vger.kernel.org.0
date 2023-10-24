Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACAC7D5B62
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 21:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344220AbjJXTVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 15:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343967AbjJXTVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 15:21:17 -0400
Received: from out-196.mta0.migadu.com (out-196.mta0.migadu.com [91.218.175.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5496C10C6
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 12:21:15 -0700 (PDT)
Date:   Tue, 24 Oct 2023 19:21:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698175273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XkPBe+q2Fd8HwrowwRNbd02bJEcCWTElAobJsH4r7wQ=;
        b=H0ZDTUBjF9ElzypQp7tDrswPltNTX86gbYWyDZZcr37nX42M7lC0JCUdH66liiWLqEf62x
        vbAateyLcy9vQZBTrutUI12pqaXhm6I/9kqU5mOOjEiE+QXGw4Tih7l7eyYc0ZVmx3+WZD
        8AfOKRM+Aa5R2lVAU8sPoOnpjzQqJ3Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Raghavendra Rao Ananta <rananta@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v8 00/13] KVM: arm64: PMU: Allow userspace to limit the
 number of PMCs on vCPU
Message-ID: <ZTgZJNbtzyGcwhwt@linux.dev>
References: <20231020214053.2144305-1-rananta@google.com>
 <86r0ll4267.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86r0ll4267.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 07:35:44PM +0100, Marc Zyngier wrote:
> On Fri, 20 Oct 2023 22:40:40 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> > 
> > Hello,
> > 
> > The goal of this series is to allow userspace to limit the number
> > of PMU event counters on the vCPU.  We need this to support migration
> > across systems that implement different numbers of counters.
> 
> FWIW, I've pushed out a branch[1] with a set of fixes that address
> some of the comments I had on this series. Feel free to squash them in
> your series as you see fit.

I did a second round of fixes on top of what Marc has and pushed that to
a branch [*]. If everything looks good I'll take it for 6.7.

[*] https://git.kernel.org/pub/scm/linux/kernel/git/oupton/linux.git/log/?h=kvm-arm64/pmu_pmcr_n

-- 
Thanks,
Oliver
