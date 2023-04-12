Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E5E6DEFE7
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 10:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjDLI4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 04:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjDLIz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 04:55:58 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27C94A272
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 01:55:43 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 501D91684;
        Wed, 12 Apr 2023 01:56:07 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 29BBB3F587;
        Wed, 12 Apr 2023 01:55:21 -0700 (PDT)
Date:   Wed, 12 Apr 2023 09:55:18 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 0/6] arm: pmu: Fix random failures of
 pmu-chain-promotion
Message-ID: <ZDZx9uPIZVKEhQTw@monolith.localdoman>
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <968a026e-066e-deea-d02f-f64133295ff1@redhat.com>
 <xcd3kt23ffdq5qfziuyp2vgwv7ndkmh3acepbpqqhhrokv755e@wuiltddj2hj2>
 <7l36wddzolsq7psm5gvra7w6emzlojj5utn7pnrsmwyx6v6jh7@zzrrwbty5zfq>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7l36wddzolsq7psm5gvra7w6emzlojj5utn7pnrsmwyx6v6jh7@zzrrwbty5zfq>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Apr 12, 2023 at 09:34:36AM +0200, Andrew Jones wrote:
> On Tue, Apr 04, 2023 at 02:47:49PM +0200, Andrew Jones wrote:
> > On Tue, Apr 04, 2023 at 08:23:15AM +0200, Eric Auger wrote:
> > > Hi,
> > > 
> > > On 3/15/23 12:07, Eric Auger wrote:
> > > > On some HW (ThunderXv2), some random failures of
> > > > pmu-chain-promotion test can be observed.
> > > >
> > > > pmu-chain-promotion is composed of several subtests
> > > > which run 2 mem_access loops. The initial value of
> > > > the counter is set so that no overflow is expected on
> > > > the first loop run and overflow is expected on the second.
> > > > However it is observed that sometimes we get an overflow
> > > > on the first run. It looks related to some variability of
> > > > the mem_acess count. This variability is observed on all
> > > > HW I have access to, with different span though. On
> > > > ThunderX2 HW it looks the margin that is currently taken
> > > > is too small and we regularly hit failure.
> > > >
> > > > although the first goal of this series is to increase
> > > > the count/margin used in those tests, it also attempts
> > > > to improve the pmu-chain-promotion logs, add some barriers
> > > > in the mem-access loop, clarify the chain counter
> > > > enable/disable sequence.
> > > >
> > > > A new 'pmu-memaccess-reliability' is also introduced to
> > > > detect issues with MEM_ACCESS event variability and make
> > > > the debug easier.
> > > >
> > > > Obviously one can wonder if this variability is something normal
> > > > and does not hide any other bug. I hope this series will raise
> > > > additional discussions about this.
> > > >
> > > > https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v1
> > > 
> > > Gentle ping.
> > 
> > I'd be happy to take this, but I was hoping to see some r-b's and/or t-b's
> > from some of the others.
> 
> Any takers? Ricardo? Alexandru?

Will try to have a look as soon as I can, and run some tests, am hoping this
week (but no promises!).

Thanks,
Alex

> 
> Thanks,
> drew
