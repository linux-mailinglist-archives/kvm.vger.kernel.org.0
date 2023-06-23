Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFBF73BBEA
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 17:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjFWPmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 11:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjFWPmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 11:42:36 -0400
Received: from out-48.mta1.migadu.com (out-48.mta1.migadu.com [95.215.58.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC2E2116
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 08:42:35 -0700 (PDT)
Date:   Fri, 23 Jun 2023 17:42:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687534953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G+MTodN3kyOFXBPrjPWQRpf8J+2/Q2L34DIk7x6CPCA=;
        b=AlV6SXO/Xhf60Iog3kNPiaKZVudIG2tR4Jv4imRvys3rMqXKi0gJffhGYnT+03oRxM3bc8
        X7Bc7id+1CpyBLeILeggX2eBmebnCQ4XZb3yxl8L1BWy8/WUw7iJFD4AEkkFXjwga4bZ84
        0rzWFqHNvxpHA7LhsQvcYbxmNkdqAdI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Alexandru Elisei <alexandru.elisei@arm.com>, thuth@redhat.com
Subject: Re: [kvm-unit-tests] arm/arm64: psci_cpu_on_test failures with tcg
Message-ID: <20230623-b5c6eb9ef3526abd6c45b30c@orel>
References: <100579b3-649b-a57c-8639-edc6b22c7646@arm.com>
 <20230607-a09e9dfd2719c01bd6b39df5@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607-a09e9dfd2719c01bd6b39df5@orel>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 07, 2023 at 08:49:36PM +0200, Andrew Jones wrote:
> On Wed, May 31, 2023 at 11:41:33AM +0100, Nikos Nikoleris wrote:
> > Hi,
> > 
> > I noticed that in the latest master the psci_cpu_on_test fails randomly for
> > both arm and arm64 with tcg.
> > 
> > If I do:
> > 
> > $> for i in `seq 1 100`; do ACCEL=tcg MAX_SMP=8 ./run_tests.sh psci; done |
> > grep FAIL
> > 
> > About 10 of the 100 runs fail for the arm and arm64 builds of the test. I
> > had a look and I am not sure I understand why. When I run the test with kvm,
> > I don't get any failures. Does anyone have an idea what could be causing
> > this?
> > 
> 
> I've also seen this failure on QEMU several times, but never investigated
> it. Now that the CI is running the tests under TCG the urgency of fixing
> it is higher, but we could also drop the psci test from the CI for now...

I just applied a patch[1] to drop the psci test from CI to arm/queue
because I was missing the nice green checkmark. We should certainly try
to figure out why it fails on tcg, though.

[1] https://gitlab.com/jones-drew/kvm-unit-tests/-/commit/bf4b759459e922b2e22c4281397a1857d4568186

Thanks,
drew
