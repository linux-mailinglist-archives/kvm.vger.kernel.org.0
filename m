Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA8B72692D
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 20:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbjFGStk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 14:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjFGStj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 14:49:39 -0400
Received: from out-15.mta1.migadu.com (out-15.mta1.migadu.com [IPv6:2001:41d0:203:375::f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090CC18F
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 11:49:37 -0700 (PDT)
Date:   Wed, 7 Jun 2023 20:49:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686163776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3c51gT0c8ge8bN5s6qtc7sw8/WCeotK+DEJcJTjknHU=;
        b=qNuRLgR3+4ow49U5nHkOmjCRtfnSVDow8jM6GwT1qw1gn7HyNjdOH9c1invgoqcSkc9vrQ
        52h6lGYqId7UORj1JndcOkzIHduQfWW0mAATE9YtC0iCqulkzCTWg6aiGeh3328ymnhq3I
        M8CDYhbqwHY3rPneVEhhqLOo7dmnJIg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Alexandru Elisei <alexandru.elisei@arm.com>, thuth@redhat.com
Subject: Re: [kvm-unit-tests] arm/arm64: psci_cpu_on_test failures with tcg
Message-ID: <20230607-a09e9dfd2719c01bd6b39df5@orel>
References: <100579b3-649b-a57c-8639-edc6b22c7646@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <100579b3-649b-a57c-8639-edc6b22c7646@arm.com>
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

On Wed, May 31, 2023 at 11:41:33AM +0100, Nikos Nikoleris wrote:
> Hi,
> 
> I noticed that in the latest master the psci_cpu_on_test fails randomly for
> both arm and arm64 with tcg.
> 
> If I do:
> 
> $> for i in `seq 1 100`; do ACCEL=tcg MAX_SMP=8 ./run_tests.sh psci; done |
> grep FAIL
> 
> About 10 of the 100 runs fail for the arm and arm64 builds of the test. I
> had a look and I am not sure I understand why. When I run the test with kvm,
> I don't get any failures. Does anyone have an idea what could be causing
> this?
> 

I've also seen this failure on QEMU several times, but never investigated
it. Now that the CI is running the tests under TCG the urgency of fixing
it is higher, but we could also drop the psci test from the CI for now...

Thanks,
drew
