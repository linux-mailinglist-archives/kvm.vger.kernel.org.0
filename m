Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBC4344E18
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 19:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhCVSFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 14:05:14 -0400
Received: from foss.arm.com ([217.140.110.172]:36346 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231817AbhCVSEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 14:04:52 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65454113E;
        Mon, 22 Mar 2021 11:04:51 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A7AB3F718;
        Mon, 22 Mar 2021 11:04:50 -0700 (PDT)
Date:   Mon, 22 Mar 2021 18:04:45 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Fix the devicetree parser for
 stdout-path
Message-ID: <20210322180445.7164b991@slackpad.fritz.box>
In-Reply-To: <20210322085336.2lxg457refhvntls@kamzik.brq.redhat.com>
References: <20210318180727.116004-1-nikos.nikoleris@arm.com>
        <20210322085336.2lxg457refhvntls@kamzik.brq.redhat.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Mar 2021 09:53:36 +0100
Andrew Jones <drjones@redhat.com> wrote:

> On Thu, Mar 18, 2021 at 06:07:23PM +0000, Nikos Nikoleris wrote:
> > This set of patches fixes the way we parse the stdout-path
> > property in the DT. The stdout-path property is used to set up
> > the console. Prior to this, the code ignored the fact that
> > stdout-path is made of the path to the uart node as well as
> > parameters. As a result, it would fail to find the relevant DT
> > node. In addition to minor fixes in the device tree code, this
> > series pulls a new version of libfdt from upstream.
> > 
> > v1: https://lore.kernel.org/kvm/20210316152405.50363-1-nikos.nikoleris@arm.com/
> > 
> > Changes in v2:
> >   - Added strtoul and minor fix in strrchr
> >   - Fixes in libfdt_clean
> >   - Minor fix in lib/libfdt/README
> > 
> > Thanks,
> > 
> > Nikos
> >  
> 
> Applied to arm/queue

So I understand that this is a bit late now, but is this really the way
forward: to just implement libc functions as we go, from scratch, and
merge them without any real testing?
I understand that hacking up strchr() is fun, but when it comes to
those string parsing functions, it gets a bit hairy, and I feel like we
are dismissing decades of experience here by implementing stuff from
scratch. At the very least we should run some unit tests (!) on newly
introduced C library functions?

Or probably the better alternative: we pick some existing C library,
and start to borrow implementations from there? Is klibc[1] a good
choice, maybe?

Cheers,
Andre

[1] https://git.kernel.org/pub/scm/libs/klibc/klibc.git/


> 
> https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue
> 
> Thanks,
> drew 
> 

