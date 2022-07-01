Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6524F563113
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 12:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiGAKMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 06:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbiGAKMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 06:12:41 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222D214D32
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 03:12:40 -0700 (PDT)
Date:   Fri, 1 Jul 2022 12:12:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656670358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0klCRHa1TKXeYdIki8pgL7JbGn8L4SURehoCkZfEsrE=;
        b=pOuzVe4gpAJp+k03DGDfh5yM8f0zBPpBJrNjT4oxcpJOTn5mHLqiVu575KQuQLko4k5BEh
        fLXii7dajUlbUt2Bzhjh6kfN+lHPTbpRwNv9NoMHt3rQIiZQ+zDRcxaJjiysXTb8221fz9
        38qEGZ/5yCG7ZzI9o9VeBosbdsFZ8QU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com, ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH v3 01/27] lib: Fix style for acpi.{c,h}
Message-ID: <20220701101237.qtz2ejlvj3rvj5oc@kamzik>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-2-nikos.nikoleris@arm.com>
 <20220701092719.63g4kv6co65dnpnd@kamzik>
 <8c1c4e1b-6723-b7b2-065b-20959e9cc5cd@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c1c4e1b-6723-b7b2-065b-20959e9cc5cd@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


(Dropping the drjones@redhat.com address from CC since, as of today,
it's generating auto address-not-valid messages.)

On Fri, Jul 01, 2022 at 10:52:28AM +0100, Nikos Nikoleris wrote:
> Hi Drew
> 
> Thanks for the review!
> 
> On 01/07/2022 10:27, Andrew Jones wrote:
> > Hi Nikos,
> > 
> > I guess you used Linux's scripts/Lindent or something for this
> > conversion. Can you please specify what you used/did in the
> > commit message?
> > 
> 
> I fixed the style by hand but happy to use Lindent in the next iteration.

Yeah, I recommend it. I used it for commit 0e9812980ee5 ("lib: Fix
whitespace"). I did need to modify it to allow 100 columns instead of 80,
though. Also, I then looked at the changes with 'git diff -b' and saw a
few other things to modify by hand.

> 
> > On Thu, Jun 30, 2022 at 11:02:58AM +0100, Nikos Nikoleris wrote:
> > > Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > > ---
> > >   lib/acpi.h | 148 ++++++++++++++++++++++++++---------------------------
> > >   lib/acpi.c |  70 ++++++++++++-------------
> > >   2 files changed, 108 insertions(+), 110 deletions(-)
> > 
> > It looks like the series is missing the file move patch. Latest master
> > still doesn't have lib/acpi.*
> > 
> 
> I am sorry, I missed the first patch. The missing patch is doing a move of
> acpi.{h,c} [1].
> 
> FWIW, I tried combining the patches in one but I ended up with a big diff. I
> found it much easier to check that everything looks ok when the overall
> change was split in two patches.

Yes, please do it in two separate patches with the move patch generated
with -M, as you've done in [1].

Thanks,
drew

> 
> [1]: https://github.com/relokin/kvm-unit-tests/commit/959ca08c23dbaa490b936303b94b006352a29d43
> 
> Thanks,
> 
> Nikos
> 
> > Thanks,
> > drew
