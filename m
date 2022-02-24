Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65864C2A51
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 12:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbiBXLIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 06:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbiBXLIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 06:08:51 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6979A27CD2
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 03:08:22 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38B19106F;
        Thu, 24 Feb 2022 03:08:22 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 51EF93F70D;
        Thu, 24 Feb 2022 03:08:21 -0800 (PST)
Date:   Thu, 24 Feb 2022 11:08:42 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH 0/7] My set of KVM unit tests + fixes
Message-ID: <YhdnOjTFqka9zAFq@monolith.localdoman>
References: <20220208122148.912913-1-mlevitsk@redhat.com>
 <38346acd4f7b9cb5a38c3a1e2fba0ee01a82dc5b.camel@redhat.com>
 <Yhdb+ptbDLNR4+xk@monolith.localdoman>
 <5331482d6079448544d01e6745907e66d0402705.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5331482d6079448544d01e6745907e66d0402705.camel@redhat.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Feb 24, 2022 at 01:00:28PM +0200, Maxim Levitsky wrote:
> On Thu, 2022-02-24 at 10:20 +0000, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Wed, Feb 23, 2022 at 02:03:54PM +0200, Maxim Levitsky wrote:
> > > On Tue, 2022-02-08 at 14:21 +0200, Maxim Levitsky wrote:
> > > > Those are few kvm unit tests tha I developed.
> > > > 
> > > > Best regards,
> > > >     Maxim Levitsky
> > > > 
> > > > Maxim Levitsky (7):
> > > >   pmu_lbr: few fixes
> > > >   svm: Fix reg_corruption test, to avoid timer interrupt firing in later
> > > >     tests.
> > > >   svm: NMI is an "exception" and not interrupt in x86 land
> > > >   svm: intercept shutdown in all svm tests by default
> > > >   svm: add SVM_BARE_VMRUN
> > > >   svm: add tests for LBR virtualization
> > > >   svm: add tests for case when L1 intercepts various hardware interrupts
> > > >     (an interrupt, SMI, NMI), but lets L2 control either EFLAG.IF or GIF
> > > > 
> > > >  lib/x86/processor.h |   1 +
> > > >  x86/pmu_lbr.c       |   6 +
> > > >  x86/svm.c           |  41 +---
> > > >  x86/svm.h           |  63 ++++++-
> > > >  x86/svm_tests.c     | 447 +++++++++++++++++++++++++++++++++++++++++++-
> > > >  x86/unittests.cfg   |   3 +-
> > > >  6 files changed, 521 insertions(+), 40 deletions(-)
> > > > 
> > > > -- 
> > > > 2.26.3
> > > > 
> > > > 
> > > Any update on these patches?
> > 
> > It is possible that because you haven't sent the patches to the x86
> > maintainer (as per the MAINTAINERS file), this series has gone unnoticed.
> > Also, each patch should start with "kvm-unit-tests PATCH" (have a look at
> > the README file), so people can easily tell them apart from KVM patches,
> > which go to the same mailing list.
> Do kvm-unit tests have MAINTAINERS file? Those patches are not for the kernel
> but for the kvm-unit test project.

A simple ls should be sufficient [1] to answer that question.

[1] https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/master/MAINTAINERS

Thanks,
Alex

> 
> > 
> > You could try resending the entire series to the x86 mailing list and to
> > the relevant maintainers. To resend them, the convention is to modify the
> > subject prefix to "kvm-unit-tests PATCH RESEND" and send them without any
> > changes (though you can mention in the cover letter why you resent the
> > series).
> Thank you, I missed the prefix to be used!
> 
> > 
> > Hope this helps!
> > 
> > Thanks,
> > Alex
> 
> Thanks!
> Best regards,
> 	Maxim Levitsky
> 
> > 
> > > Best regards,
> > > 	Maxim Levitsky
> > > 
> 
> 
