Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758492827CA
	for <lists+kvm@lfdr.de>; Sun,  4 Oct 2020 03:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgJDBTW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 21:19:22 -0400
Received: from smtprelay0170.hostedemail.com ([216.40.44.170]:52936 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726225AbgJDBTW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Oct 2020 21:19:22 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 6875512D9;
        Sun,  4 Oct 2020 01:19:21 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:800:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:9025:10004:10400:10848:11026:11658:11914:12043:12296:12297:12438:12555:12760:12986:13069:13073:13161:13229:13311:13357:13439:13618:13845:14181:14659:14721:21080:21324:21433:21627:21811:30025:30054:30070,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:113,LUA_SUMMARY:none
X-HE-Tag: body07_5705ce2271b1
X-Filterd-Recvd-Size: 1443
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Sun,  4 Oct 2020 01:19:19 +0000 (UTC)
Message-ID: <250919192de237dadf36218ee6b4dabf1bd4cbde.camel@perches.com>
Subject: Where is the declaration of buffer used in kernel_param_ops .get
 functions?
From:   Joe Perches <joe@perches.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org, rcu@vger.kernel.org,
        linux-mm@kvack.org
Date:   Sat, 03 Oct 2020 18:19:18 -0700
In-Reply-To: <cover.1601770305.git.joe@perches.com>
References: <cover.1601770305.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These patches came up because I was looking for
the location of the declaration of the buffer used
in kernel/params.c struct kernel_param_ops .get
functions.

I didn't find it.

I want to see if it's appropriate to convert the
sprintf family of functions used in these .get
functions to sysfs_emit.

Patches submitted here:
https://lore.kernel.org/lkml/5d606519698ce4c8f1203a2b35797d8254c6050a.1600285923.git.joe@perches.com/T/

Anyone know if it's appropriate to change the
sprintf-like uses in these functions to sysfs_emit
and/or sysfs_emit_at?


