Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A062D15B7E2
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 04:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbgBMDmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 22:42:07 -0500
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:58946 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729470AbgBMDmH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 22:42:07 -0500
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2020 22:42:06 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave06.hostedemail.com (Postfix) with ESMTP id DAD0781238EC
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 03:32:28 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 8F5A3100E7B40;
        Thu, 13 Feb 2020 03:32:27 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3868:3870:3871:3874:4321:5007:10004:10400:10848:11232:11658:11914:12297:12740:12760:12895:13019:13069:13149:13230:13311:13357:13439:14181:14659:14721:21080:21611:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:20,LUA_SUMMARY:none
X-HE-Tag: debt42_6ca657be6622e
X-Filterd-Recvd-Size: 1290
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Thu, 13 Feb 2020 03:32:26 +0000 (UTC)
Message-ID: <71b3bf53c0fc3c68b10368092022e3bf2cffc506.camel@perches.com>
Subject: Re: [PATCH] KVM: x86: enable -Werror
From:   Joe Perches <joe@perches.com>
To:     linmiaohe <linmiaohe@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linus Walleij <linux.walleij@sterricsson.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date:   Wed, 12 Feb 2020 19:31:08 -0800
In-Reply-To: <12259a951c5e47359c46f7875e758d41@huawei.com>
References: <12259a951c5e47359c46f7875e758d41@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-02-13 at 01:40 +0000, linmiaohe wrote:
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> > Avoid more embarrassing mistakes.  At least those that the compiler can catch.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---

I think adding -Werror is a bad idea as
new versions of compilers can create
additional compilation warnings and
break builds in the future.



