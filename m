Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEE7867451
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 19:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbfGLRea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 13:34:30 -0400
Received: from ms.lwn.net ([45.79.88.28]:59320 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbfGLRea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 13:34:30 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id B29512CC;
        Fri, 12 Jul 2019 17:34:28 +0000 (UTC)
Date:   Fri, 12 Jul 2019 11:34:27 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Alex Shi <alex.shi@linux.alibaba.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 01/12] Documentation: move architectures together
Message-ID: <20190712113427.62fa7ffc@lwn.net>
In-Reply-To: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
References: <20190712022018.27989-1-alex.shi@linux.alibaba.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Jul 2019 10:20:07 +0800
Alex Shi <alex.shi@linux.alibaba.com> wrote:

> There are many different archs in Documentation/ dir, it's better to
> move them together in 'Documentation/arch' which follows from kernel source.

So this seems certain to collide badly with Mauro's RST-conversion monster
patch set.

More to the point, though...if we are going to thrash up things this
badly, we want to be sure that we're doing it right so we don't end up
renaming everything again.  Grouping stuff into a new arch/ subdirectory
adds a bit of order, but it doesn't do much toward trying to organize our
documentation for its readers, and it doesn't help us to modernize the
docs and get rid of the old, useless stuff.  A quick check shows that many
of these files have seen no changes other than typo fixes since the
beginning of the Git era.

So, in my mind, this needs some thought.  Maybe we want a
Documentation/arch in the end, but I'm not convinced that we should just
create it and fill it with a snow shovel.  This might be a good thing to
discuss at the kernel summit in September.

Thanks,

jon
