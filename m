Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E140930D7C4
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 11:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhBCKlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 05:41:13 -0500
Received: from elvis.franken.de ([193.175.24.41]:49435 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233734AbhBCKlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 05:41:11 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1l7FaD-0005T6-01; Wed, 03 Feb 2021 11:40:25 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id AD4EEC0D4A; Wed,  3 Feb 2021 11:37:26 +0100 (CET)
Date:   Wed, 3 Feb 2021 11:37:26 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: MIPS: remove unneeded semicolon
Message-ID: <20210203103726.GB7586@alpha.franken.de>
References: <1612232135-26683-1-git-send-email-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612232135-26683-1-git-send-email-yang.lee@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021 at 10:15:35AM +0800, Yang Li wrote:
> Eliminate the following coccicheck warning:
> ./arch/mips/kvm/mips.c:151:2-3: Unneeded semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  arch/mips/kvm/mips.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
