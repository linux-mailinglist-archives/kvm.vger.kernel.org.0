Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB926D61A2
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 14:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbjDDMxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 08:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbjDDMxM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 08:53:12 -0400
Received: from out-55.mta1.migadu.com (out-55.mta1.migadu.com [IPv6:2001:41d0:203:375::37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D391D8
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 05:53:07 -0700 (PDT)
Date:   Tue, 4 Apr 2023 14:47:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680612468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6oSkwVtAFz/64zpfFDW2DBrJENzw8H7IvhaMYTJCvpI=;
        b=CczpIPdHmGEqeMZsQ5AcnIOuWUYeUoVhwi+Tg96ZC62y/UmPOXs8Ivf4vUaY+XH4XjUkpG
        2ips9Xbspa7uU06niAqAIzMDZ5Hoc7lsOILCNcnSpvDkWw+zhG783oJZM9E9/utsaGn2PN
        It5WDHF+ciP8uyMUFmQPVMYYGWsOa0I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH 0/6] arm: pmu: Fix random failures of
 pmu-chain-promotion
Message-ID: <xcd3kt23ffdq5qfziuyp2vgwv7ndkmh3acepbpqqhhrokv755e@wuiltddj2hj2>
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <968a026e-066e-deea-d02f-f64133295ff1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <968a026e-066e-deea-d02f-f64133295ff1@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 08:23:15AM +0200, Eric Auger wrote:
> Hi,
> 
> On 3/15/23 12:07, Eric Auger wrote:
> > On some HW (ThunderXv2), some random failures of
> > pmu-chain-promotion test can be observed.
> >
> > pmu-chain-promotion is composed of several subtests
> > which run 2 mem_access loops. The initial value of
> > the counter is set so that no overflow is expected on
> > the first loop run and overflow is expected on the second.
> > However it is observed that sometimes we get an overflow
> > on the first run. It looks related to some variability of
> > the mem_acess count. This variability is observed on all
> > HW I have access to, with different span though. On
> > ThunderX2 HW it looks the margin that is currently taken
> > is too small and we regularly hit failure.
> >
> > although the first goal of this series is to increase
> > the count/margin used in those tests, it also attempts
> > to improve the pmu-chain-promotion logs, add some barriers
> > in the mem-access loop, clarify the chain counter
> > enable/disable sequence.
> >
> > A new 'pmu-memaccess-reliability' is also introduced to
> > detect issues with MEM_ACCESS event variability and make
> > the debug easier.
> >
> > Obviously one can wonder if this variability is something normal
> > and does not hide any other bug. I hope this series will raise
> > additional discussions about this.
> >
> > https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v1
> 
> Gentle ping.

I'd be happy to take this, but I was hoping to see some r-b's and/or t-b's
from some of the others.

Thanks,
drew
