Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381244C292E
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 11:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiBXKUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 05:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiBXKUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 05:20:53 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 483C628AD8A
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 02:20:22 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 061AC14BF;
        Thu, 24 Feb 2022 02:20:22 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 457373F70D;
        Thu, 24 Feb 2022 02:20:21 -0800 (PST)
Date:   Thu, 24 Feb 2022 10:20:42 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH 0/7] My set of KVM unit tests + fixes
Message-ID: <Yhdb+ptbDLNR4+xk@monolith.localdoman>
References: <20220208122148.912913-1-mlevitsk@redhat.com>
 <38346acd4f7b9cb5a38c3a1e2fba0ee01a82dc5b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38346acd4f7b9cb5a38c3a1e2fba0ee01a82dc5b.camel@redhat.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Feb 23, 2022 at 02:03:54PM +0200, Maxim Levitsky wrote:
> On Tue, 2022-02-08 at 14:21 +0200, Maxim Levitsky wrote:
> > Those are few kvm unit tests tha I developed.
> > 
> > Best regards,
> >     Maxim Levitsky
> > 
> > Maxim Levitsky (7):
> >   pmu_lbr: few fixes
> >   svm: Fix reg_corruption test, to avoid timer interrupt firing in later
> >     tests.
> >   svm: NMI is an "exception" and not interrupt in x86 land
> >   svm: intercept shutdown in all svm tests by default
> >   svm: add SVM_BARE_VMRUN
> >   svm: add tests for LBR virtualization
> >   svm: add tests for case when L1 intercepts various hardware interrupts
> >     (an interrupt, SMI, NMI), but lets L2 control either EFLAG.IF or GIF
> > 
> >  lib/x86/processor.h |   1 +
> >  x86/pmu_lbr.c       |   6 +
> >  x86/svm.c           |  41 +---
> >  x86/svm.h           |  63 ++++++-
> >  x86/svm_tests.c     | 447 +++++++++++++++++++++++++++++++++++++++++++-
> >  x86/unittests.cfg   |   3 +-
> >  6 files changed, 521 insertions(+), 40 deletions(-)
> > 
> > -- 
> > 2.26.3
> > 
> > 
> Any update on these patches?

It is possible that because you haven't sent the patches to the x86
maintainer (as per the MAINTAINERS file), this series has gone unnoticed.
Also, each patch should start with "kvm-unit-tests PATCH" (have a look at
the README file), so people can easily tell them apart from KVM patches,
which go to the same mailing list.

You could try resending the entire series to the x86 mailing list and to
the relevant maintainers. To resend them, the convention is to modify the
subject prefix to "kvm-unit-tests PATCH RESEND" and send them without any
changes (though you can mention in the cover letter why you resent the
series).

Hope this helps!

Thanks,
Alex

> 
> Best regards,
> 	Maxim Levitsky
> 
