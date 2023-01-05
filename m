Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AF465F019
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 16:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbjAEPaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 10:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjAEPaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 10:30:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7963D9CC;
        Thu,  5 Jan 2023 07:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 056D361AF9;
        Thu,  5 Jan 2023 15:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68475C433EF;
        Thu,  5 Jan 2023 15:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672932621;
        bh=N5kVPjkKTgjrzzrxUIoZaOuMPZJESbY+VzfMe0AvOXQ=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=nZRYoHZ8HPJTLfePbI6xcdnaeBciRnfl77NvG5KQ2gA8uXPbUcudFePLYOmFupLUm
         3tJoumVOSP5LimB2DL/+AcFvgsLALMOn7plZ8CyPBVO8bhl198Ud9r3hkkSZFPfeUp
         7B767D9fLuMD1MtFS17fOehUobBzPGSqk3nO06oXb3DNisYvAyWTd94WX8aFeyl7o0
         SQG+CK0pJbwGV1Y+lprC5qKT7Vc41YT3Yoa4uGbmn9jq/+0sv60+xVg3t7ebC/CcJs
         Wd0xsVulNsfh8Y0yfk+eqJL0BuS5tM54xpqs9JtjgtQWokWL9dgXczT4QxwMfLgqoQ
         1urhDfFMiRbXw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 121225C029A; Thu,  5 Jan 2023 07:30:21 -0800 (PST)
Date:   Thu, 5 Jan 2023 07:30:21 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, rostedt@goodmis.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH rcu 06/27] arch/s390/kvm: Remove "select SRCU"
Message-ID: <20230105153021.GR4028633@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230105003759.GA1769545@paulmck-ThinkPad-P17-Gen-1>
 <20230105003813.1770367-6-paulmck@kernel.org>
 <Y7aFAqmgF4eu6SNH@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7aFAqmgF4eu6SNH@osiris>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05, 2023 at 09:06:26AM +0100, Heiko Carstens wrote:
> On Wed, Jan 04, 2023 at 04:37:52PM -0800, Paul E. McKenney wrote:
> > Now that the SRCU Kconfig option is unconditionally selected, there is
> > no longer any point in selecting it.  Therefore, remove the "select SRCU"
> > Kconfig statements.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> > Cc: Janosch Frank <frankja@linux.ibm.com>
> > Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Heiko Carstens <hca@linux.ibm.com>
> > Cc: Vasily Gorbik <gor@linux.ibm.com>
> > Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> > Cc: Sven Schnelle <svens@linux.ibm.com>
> > Cc: <kvm@vger.kernel.org>
> > Cc: <linux-s390@vger.kernel.org>
> > ---
> >  arch/s390/kvm/Kconfig | 1 -
> >  1 file changed, 1 deletion(-)
> 
> Acked-by: Heiko Carstens <hca@linux.ibm.com>

Thank you, Heiko!  I will apply on my next rebase.

							Thanx, Paul
