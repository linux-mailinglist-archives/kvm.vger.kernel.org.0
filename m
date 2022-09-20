Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797305BD9E8
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 04:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiITCN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 22:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiITCN0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 22:13:26 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C7857544
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 19:13:25 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id c3so1569729vsc.6
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 19:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=LhprL2QVbzky7ZAXaXmKaCG2fZ/bG0UYXk9tOS7aXnY=;
        b=PGCJcjWLr4SHxMv8ivTAMamCPU/lkKK0dFqBEfZy+Xoh/g4UvHR8Tjalko7fnj29cf
         ECXwL9kH/aqs1iN4dEjp98ccsT9UZFvlEjmNb1ZOmBEMuslU7MeQ+dvTUeavKDHKQWkT
         Q4sdG5mzJs1M66f2/yOjLYV7Mr23g9I1tPE7KgDV5IWqbQPWUM6r7hi+cwY1VQ4e6HAG
         iYFfrDkQCOw8EuUPf0ygxePt4Cp2eXiDyNWgfI/4cE1WmmdejsR0gyunDCIeYe34a7rH
         /0OIP5YArMqkI2DI5zSGm4n52uKi+aoQYTAKw2OM/X8C/CcDvnsTdize+LSbiPaahbN2
         sv7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=LhprL2QVbzky7ZAXaXmKaCG2fZ/bG0UYXk9tOS7aXnY=;
        b=yM/lMdVunsFesq+8miNd92Mk8p5ByuJI1xlmcCLcVef1A4BPp4K9McyB8INrg+1872
         mZdXZ5g3T50dgEH2xQ0nRXmUnmqxYFS/Z/Dxijzf9hfi1KGhld2qxVE3lty+vDyrOvAD
         S1OmmeyPVVSfRwUlccsYEP3w5howRiRpRYaLBhPLLN/a53HqPIcD/Btd5qnLVsT5MwvS
         efp/SIqMPi3IY1mvAR58zf8xE/O8oOssAoXhjGZP6x3+ohsa4ET3EcB64LkZQ6xClA93
         n9Ou6oY8GbsyL/137jUZkqB/bk2IiqzgnwusJiRqeedOQyO+0Ggre7/4Gjfn1tk0PLSE
         X2Pw==
X-Gm-Message-State: ACrzQf0uNkrpjAlMQYM24EBZwtPTww1lPZ4xJCcGs8eLMeMf0MYvRFCA
        koBdmkXixhk9ErCJuFOEHkpeICE8i9VAcnUnAd+wcA==
X-Google-Smtp-Source: AMsMyM7wgUY6E8j/4SMw+/72+ih55ve9ug7EcEf9GLIsdD3MXqyNwHc4oK+hZoFAn5gEb/6kdxZ6GEWk15PY0d04huI=
X-Received: by 2002:a67:ea58:0:b0:38f:d89a:e4b3 with SMTP id
 r24-20020a67ea58000000b0038fd89ae4b3mr7517244vso.51.1663640004802; Mon, 19
 Sep 2022 19:13:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220917010600.532642-1-reijiw@google.com> <20220917010600.532642-5-reijiw@google.com>
 <87bkrbln84.wl-maz@kernel.org>
In-Reply-To: <87bkrbln84.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 19 Sep 2022 19:13:08 -0700
Message-ID: <CAAeT=FwN+5=1SjaHqpE2PCaa0H4_pkdz-OsTiRfd-WOzYaCNpw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: selftests: Add a test case for KVM_GUESTDBG_SINGLESTEP
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Mon, Sep 19, 2022 at 2:36 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sat, 17 Sep 2022 02:06:00 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Add a test case for KVM_GUESTDBG_SINGLESTEP to the debug-exceptions test.
> > The test enables single-step execution from userspace, and check if the
> > exit to userspace occurs for each instruction that is stepped.
> > Set the default number of the test iterations to a number of iterations
> > sufficient to always reproduce the problem that the previous patch fixes
> > on an Ampere Altra machine.
>
> A possibly more aggressive version of this test would be to force a
> (short lived) timer to fire on the same CPU, forcing an exit. This
> should hopefully result in a more predictable way to trigger the
> issue. But that's a reasonable test as a start.

Yes, that could result in a more predictable way to cause the specific case!
I will consider this at a future opportunity.

Thank you,
Reiji
