Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E7B678C35
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 00:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbjAWXn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 18:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbjAWXn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 18:43:27 -0500
Received: from out-247.mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747B49774
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 15:43:25 -0800 (PST)
Date:   Mon, 23 Jan 2023 23:43:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674517403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OG7fkTt+dHrFA+j7+xTuGl9iMFxjNdGfDAv/XjtHX18=;
        b=QQl1/rfeKwPmkglKgPppVjLdnuv2f6bkqoVpDJJuc/jRI5QecxOqlKr0QGnGsPUNJERnYi
        sbqH/FB2+bKK0karI2p5EykhyCBevtCrJ9M4UAgMTb6+BnqYurEYgcxFwXPO5Rv20qwv8o
        fD69S+2KSShdQP+AWlGsmsY9xbcZV9E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com
Subject: Re: [PATCH 0/4] KVM: selftests: aarch64: page_fault_test S1PTW
 related fixes
Message-ID: <Y88bl/+lqrUCVKEf@google.com>
References: <20230110022432.330151-1-ricarkol@google.com>
 <Y88bRSisoRAML0M6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y88bRSisoRAML0M6@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 23, 2023 at 11:41:57PM +0000, Oliver Upton wrote:
> On Tue, Jan 10, 2023 at 02:24:28AM +0000, Ricardo Koller wrote:
> > Commit "KVM: arm64: Fix S1PTW handling on RO memslots" changed the way
> > S1PTW faults were handled by KVM.
> 
> I understand that this commit wasn't in Linus' tree at the time you sent
> these patches, could you please attribute it as:
> 
>   commit 406504c7b040 ("KVM: arm64: Fix S1PTW handling on RO memslots")
> 
> in v2?

Sorry, I was a bit terse. What I mean is to update all of the commit
messages to reflect the suggestion.

--
Thanks,
Oliver
