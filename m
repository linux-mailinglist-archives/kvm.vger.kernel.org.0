Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C88D67FC2
	for <lists+kvm@lfdr.de>; Sun, 14 Jul 2019 17:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfGNPVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Jul 2019 11:21:09 -0400
Received: from out4437.biz.mail.alibaba.com ([47.88.44.37]:40350 "EHLO
        out4437.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726403AbfGNPVJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 14 Jul 2019 11:21:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0TWrpoRa_1563117663;
Received: from IT-FVFX43SYHV2H.lan(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0TWrpoRa_1563117663)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 14 Jul 2019 23:21:03 +0800
Subject: Re: [PATCH 01/12] Documentation: move architectures together
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-sh@vger.kernel.org
References: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
 <20190712113427.62fa7ffc@lwn.net>
From:   Alex Shi <alex.shi@linux.alibaba.com>
Message-ID: <36c522c5-975e-e38e-daad-0f3d9f93b186@linux.alibaba.com>
Date:   Sun, 14 Jul 2019 23:21:03 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712113427.62fa7ffc@lwn.net>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jon,

Thanks for quick response!

ÔÚ 2019/7/13 ÉÏÎç1:34, Jonathan Corbet Ð´µÀ:
> On Fri, 12 Jul 2019 10:20:07 +0800
> Alex Shi <alex.shi@linux.alibaba.com> wrote:
> 
>> There are many different archs in Documentation/ dir, it's better to
>> move them together in 'Documentation/arch' which follows from kernel source.
> 
> So this seems certain to collide badly with Mauro's RST-conversion monster
> patch set.

I don't mean that, sorry, and we can figure out if both of them are worthy to be picked up.

> 
> More to the point, though...if we are going to thrash up things this
> badly, we want to be sure that we're doing it right so we don't end up
> renaming everything again.  Grouping stuff into a new arch/ subdirectory
> adds a bit of order, but it doesn't do much toward trying to organize our
> documentation for its readers, and it doesn't help us to modernize the
> docs and get rid of the old, useless stuff.  A quick check shows that many
> of these files have seen no changes other than typo fixes since the
> beginning of the Git era.

Right, there is some docs which need to be update or even drop, and a reorder would be a timing to push each of arch maintainer to do something, isn't it? Anyway, reordering  documents like kernel source dir could be one of choices. :)

> 
> So, in my mind, this needs some thought.  Maybe we want a
> Documentation/arch in the end, but I'm not convinced that we should just
> create it and fill it with a snow shovel.  This might be a good thing to
> discuss at the kernel summit in September.

Thanks for considering, anyway, it could be a good start to get hands dirty whether the arch dir is needed. 

Thanks
Alex
