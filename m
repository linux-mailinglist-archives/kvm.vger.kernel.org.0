Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0C035F003
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 10:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350205AbhDNImr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 04:42:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44750 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232248AbhDNImq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Apr 2021 04:42:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618389745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QLAUVPyRG/bi0Rkny0RSuOIvl4SdAX8nBzWjhMALWA4=;
        b=CN+mz7eHaINp8vZ8TkQ7hAYssx5YvrhZb4uJTOMis322Nqa1HRVSHq5v36C8v1iXxfmdjx
        v1Z3fQt7dscA63fjWKnDISxGLKrQxilZ2S16B2ENnJubHedhYQqO8z5y53/PVoto+rqg2W
        qkg/JpbuIlgNbji1x30o9QUNJajLtyk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-EpWJ0d6nPUWrPBFcNhomZw-1; Wed, 14 Apr 2021 04:42:22 -0400
X-MC-Unique: EpWJ0d6nPUWrPBFcNhomZw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E8EB1020C25;
        Wed, 14 Apr 2021 08:42:21 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.57])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 363D416ED7;
        Wed, 14 Apr 2021 08:42:18 +0000 (UTC)
Date:   Wed, 14 Apr 2021 10:42:16 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        Jade Alglave <Jade.Alglave@arm.com>,
        maranget <luc.maranget@inria.fr>
Subject: Re: [kvm-unit-tests PATCH 0/3] Add support for external tests and
 litmus7 documentation
Message-ID: <20210414084216.khko7c7tk2tnu6bw@kamzik.brq.redhat.com>
References: <20210324171402.371744-1-nikos.nikoleris@arm.com>
 <aaabf2d9-ecea-8665-f43b-d3382963ff5a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaabf2d9-ecea-8665-f43b-d3382963ff5a@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021 at 05:52:37PM +0100, Nikos Nikoleris wrote:
> On 24/03/2021 17:13, Nikos Nikoleris wrote:
> > This set of patches makes small changes to the build system to allow
> > easy integration of tests not included in the repository. To this end,
> > it adds a parameter to the configuration script `--ext-dir=DIR` which
> > will instruct the build system to include the Makefile in
> > DIR/Makefile. The external Makefile can then add extra tests,
> > link object files and modify/extend flags.
> > 
> > In addition, to demonstrate how we can use this functionality, a
> > README file explains how to use litmus7 to generate the C code for
> > litmus tests and link with kvm-unit-tests to produce flat files.
> > 
> > Note that currently, litmus7 produces its own independent Makefile as
> > an intermediate step. Once this set of changes is committed, litmus7
> > will be modifed to make use hook to specify external tests and
> > leverage the build system to build the external tests
> > (https://github.com/relokin/herdtools7/commit/8f23eb39d25931c2c34f4effa096df58547a3bb4).
> > 
> 
> Just wanted to add that if anyone's interested in trying out this series
> with litmus7 I am very happy to help. Any feedback on this series or the way
> we use kvm-unit-tests would be very welcome!

Hi Nikos,

It's on my TODO to play with this. I just haven't had a chance yet. I'm
particularly slow right now because I'm in the process of handling a
switch of my email server from one type to another, requiring rewrites
of filters, new mail synchronization methods, and, in general, lots of
pain... Hopefully by the end of this week all will be done. Then, I can
start ignoring emails on purpose again, instead of due to the fact that
I can't find them :-)

Thanks,
drew

> 
> Thanks,
> 
> Nikos
> 
> > Nikos Nikoleris (3):
> >    arm/arm64: Avoid wildcard in the arm_clean recipe of the Makefile
> >    arm/arm64: Add a way to specify an external directory with tests
> >    README: Add a guide of how to run tests with litmus7
> > 
> >   configure           |   7 +++
> >   arm/Makefile.common |  11 +++-
> >   README.litmus7.md   | 125 ++++++++++++++++++++++++++++++++++++++++++++
> >   3 files changed, 141 insertions(+), 2 deletions(-)
> >   create mode 100644 README.litmus7.md
> > 
> 

