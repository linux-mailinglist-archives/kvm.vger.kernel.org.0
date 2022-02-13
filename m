Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44264B3BDB
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 15:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236590AbiBMOnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Feb 2022 09:43:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbiBMOnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Feb 2022 09:43:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9B25AEF9;
        Sun, 13 Feb 2022 06:43:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B74A0611AE;
        Sun, 13 Feb 2022 14:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D43C004E1;
        Sun, 13 Feb 2022 14:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644763405;
        bh=+cp9bFzWg3wGwAIw5MZ8QkoVpxGR06Zjxx+eGBXCGw8=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Jg1QyIMc8V3GphRky+NikI9HdaTdF40pBqhQ+G+BtFUCG81tTvrYmwLA8c3zqi9EQ
         wwSSnH9VOh3UkH7Ssoc5T5/lYwvB8h2SqW2Rer6LHpa9bXhtcguAVHlkzq8eYj9qa3
         OZYdQmNqTS7uyv2AfVEj+UUUDvXd606n9L9qqJlWX/G4TyOzBul2P36fh7qex0ZwGI
         CrlryOYjpPQR8tsapJF4OCDMsd1sxz8O0W4574BltOz44dxrukIhC9QAiAUokrYVt1
         pmX6IdHKsJv4A/PuHqyzWoNJh5dApI2oBmlu/53fik15aO2Deux7uu2Xjf1sPmCS4N
         jqxb1JavYydUQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 9A1DD5C0951; Sun, 13 Feb 2022 06:43:24 -0800 (PST)
Date:   Sun, 13 Feb 2022 06:43:24 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Zhouyi Zhou <zhouzhouyi@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rcu <rcu@vger.kernel.org>
Subject: Re: Set environment variable `KVM` makes build fail
Message-ID: <20220213144324.GS4285@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <d3e6a461-5b37-ecfb-d63c-d35af27f2682@molgen.mpg.de>
 <CAABZP2yOA2n-xux8uUC72vVYc14JfCawoOzp_pnTGDvY8cRSnw@mail.gmail.com>
 <f63abe64-6d4f-1374-5fd3-874a34c1c22f@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f63abe64-6d4f-1374-5fd3-874a34c1c22f@molgen.mpg.de>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 13, 2022 at 10:45:11AM +0100, Paul Menzel wrote:
> Dear Zhouyi,
> 
> 
> Am 13.02.22 um 09:07 schrieb Zhouyi Zhou:, and
> 
> > Thank you for your trust in me.
> 
> Thank you for your help.
> 
> > I think the following patch has a good explanation of what happened ;-)
> > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/tools/testing/selftests/rcutorture/bin/torture.sh?id=a7d89cfb8e1269cb6d22453adba56b8d0218589f
> > "The torture-test scripting's long-standing use of KVM as the
> > environment variable tracking the pathname of the rcutorture directory
> > now conflicts with allmodconfig builds due to the
> > virt/kvm/Makefile.kvm file's use of this as a makefile variable"
> 
> Indeed. In my script I had added the remote for the rcu git archive, but
> forgot to actually fetch the objects and refs, and missed the error message
> in the output.
> 
> Sorry for the noise, though the variable name should probably namespaced, as
> at least for the name `KVM` the chance are higher (still very small) that
> it’s set in the environment.

In -rcu and -next, it is now named "RCUTORTURE".  But if there are
other rcutorture environment variables in need of namespacing, please
let me know.

							Thanx, Paul
