Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8733C460414
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 05:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355611AbhK1ExD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Nov 2021 23:53:03 -0500
Received: from rere.qmqm.pl ([91.227.64.183]:16555 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343913AbhK1EvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Nov 2021 23:51:02 -0500
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 4J1wvh31dgzNL;
        Sun, 28 Nov 2021 05:47:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1638074864; bh=T0svUg/TJeCaOj3VBZ/3tRgBnlIZMjU65z9Fv+g5zQQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nn7s8QPTQ/loie98xkMYWvJAWdNi0ygFbehqQ63G9aASvWbHHSf28+XNOM2IsqPek
         Id9Qk7aFHuFwrGibBi8TresAAu9XqBcHIi12aTTvDPBLXczkWFqaVeOOJqwU7nzdju
         cV9IwxL2w6Fd22ryYwl1Sh9x2PviA4Kf1ikAu3uR5SMygCLmnTRZxshC+MEAGrH0Kv
         tsp5I9URKJw3bR68w4MVuWQ2xdmfd6DgYPrQCMsS55RcJLwTkVCCw/V2t3AdcHjMnW
         QCHQOrGKek5wpaMAmZUhPLRcHZ38Wx/IlUleKYu8VrTTTyi1x1pbkvgBzAZLAICths
         2w9BfRFMcSpxg==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.103.3 at mail
Date:   Sun, 28 Nov 2021 05:47:43 +0100
From:   =?iso-8859-2?B?TWljaGGzoE1pcm9zs2F3?= <mirq-linux@rere.qmqm.pl>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, kvm@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-csky@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-snps-arc@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 3/9] all: replace bitmap_weigth() with
 bitmap_{empty,full,eq,gt,le}
Message-ID: <YaMJ7x8viyKyYk6w@qmqm.qmqm.pl>
References: <20211128035704.270739-1-yury.norov@gmail.com>
 <20211128035704.270739-4-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211128035704.270739-4-yury.norov@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 27, 2021 at 07:56:58PM -0800, Yury Norov wrote:
> bitmap_weight() counts all set bits in the bitmap unconditionally.
> However in some cases we can traverse a part of bitmap when we
> only need to check if number of set bits is greater, less or equal
> to some number.
> 
> This patch replaces bitmap_weight() with one of
> bitmap_{empty,full,eq,gt,le), as appropriate.
> 
> In some places driver code has been optimized further, where it's
> trivial.
[...]

I think this patch needs to be split. bitmap_full/empty() conversions
can be separated (don't need the bitmap_weight_*() functions) and
not all changes are trivial. Besides, gathering and checking all the
acks needed into one patch seems problematic.

Best Regards,
Micha³ Miros³aw
