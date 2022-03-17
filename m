Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1539F4DC1ED
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 09:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbiCQIyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 04:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiCQIx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 04:53:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85301CABD6
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 01:52:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CFBAB81DA7
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 08:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C22C340EE;
        Thu, 17 Mar 2022 08:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647507161;
        bh=3MOnGAbOL7YWzZCDMztCvhjS2KbSf1PeCFSM6JMUXls=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iEPxF6MGs+uvzyw5A6CoxPTpHsWYPHTrNECLD5jcnd9UzfhFrvPYj4YYfalB0n5MM
         Bz1n5vTMVMKSuqUGE1KiK0FzUxi169Ks5Nl0ro8rtflzqrUCwUkRchc4FvnJaWyD0i
         0ccnd4ukGDArpUZlwFCRJzLyK2blpvY+lMjtHtRLePx0EvGYzTOUWc9laXdaR5QDP6
         3fgySvDkxE67sCdS8votp2PVjRVHaVfC0xdBPGzX0i8qAy6bsYWXAonuRz47C72mtB
         BB1Xyd38gSfgCZy07XDE/ZgXagsoIfT+5M0QhAp3Rtaq5yXjQKuVCBxo2luNeod9s6
         HJNIMyQ10LuhQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nUls6-00F7oq-II; Thu, 17 Mar 2022 08:52:38 +0000
MIME-Version: 1.0
Date:   Thu, 17 Mar 2022 08:52:38 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Oliver Upton <oupton@google.com>
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        pbonzini@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com
Subject: Re: [PATCH v2 2/3] KVM: arm64: selftests: add arch_timer_edge_cases
In-Reply-To: <YjLY5y+KObV0AR9g@google.com>
References: <20220317045127.124602-1-ricarkol@google.com>
 <20220317045127.124602-3-ricarkol@google.com> <YjLY5y+KObV0AR9g@google.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <5fe2be916e1dcfe491fd3b40466d1932@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: oupton@google.com, ricarkol@google.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com, pbonzini@redhat.com, alexandru.elisei@arm.com, eric.auger@redhat.com, reijiw@google.com, rananta@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-03-17 06:44, Oliver Upton wrote:
> On Wed, Mar 16, 2022 at 09:51:26PM -0700, Ricardo Koller wrote:
>> Add an arch_timer edge-cases selftest. For now, just add some basic
>> sanity checks, and some stress conditions (like waiting for the timers
>> while re-scheduling the vcpu). The next commit will add the actual 
>> edge
>> case tests.
>> 
>> This test fails without a867e9d0cc1 "KVM: arm64: Don't miss pending
>> interrupts for suspended vCPU".
>> 
>> Reviewed-by: Reiji Watanabe <reijiw@google.com>
>> Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>
>> Signed-off-by: Ricardo Koller <ricarkol@google.com>

[...]

>> +		asm volatile("wfi\n"
>> +			     "msr daifclr, #2\n"
>> +			     /* handle IRQ */
> 
> I believe an isb is owed here (DDI0487G.b D1.13.4). Annoyingly, I am
> having a hard time finding the same language in the H.a revision of the
> manual :-/

D1.3.6 probably is what you are looking for.

"Context synchronization event" is the key phrase to remember
when grepping through the ARM ARM. And yes, the new layout is
a nightmare (as if we really needed an additional 2800 pages...).

> 
>> +			     "msr daifset, #2\n"
>> +			     : : : "memory");
>> +	}
>> +}

[...]

>> +	/* tval should keep down-counting from 0 to -1. */
>> +	SET_COUNTER(DEF_CNT, test_args.timer);
>> +	timer_set_tval(test_args.timer, 0);
>> +	if (use_sched)
>> +		USERSPACE_SCHEDULE();
>> +	/* We just need 1 cycle to pass. */
>> +	isb();
> 
> Somewhat paranoid, but:
> 
> If the CPU retires the ISB much more quickly than the counter ticks, 
> its
> possible that you could observe an invalid TVAL even with a valid
> implementation.

Worse than that:

- ISB doesn't need to take any time at all. It just needs to ensure
   that everything is synchronised. Depending on how the CPU is built,
   this can come for free.

- There is no relation between the counter ticks and CPU cycles.

> What if you spin waiting for CNT to increment before the assertion? 
> Then
> you for sureknow (and can tell by reading the test) that the
> implementation is broken.

That's basically the only way to implement this. You can't rely
on any other event.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
