Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D176A3AE689
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 11:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhFUJ40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 05:56:26 -0400
Received: from elvis.franken.de ([193.175.24.41]:40946 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhFUJ4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 05:56:25 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lvGd8-000490-00; Mon, 21 Jun 2021 11:54:10 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 7982FC071C; Mon, 21 Jun 2021 11:53:54 +0200 (CEST)
Date:   Mon, 21 Jun 2021 11:53:54 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     zhouchuangao <zhouchuangao@vivo.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips/kvm: Use BUG_ON instead of if condition followed by
 BUG
Message-ID: <20210621095354.GD4425@alpha.franken.de>
References: <1619166910-70744-1-git-send-email-zhouchuangao@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619166910-70744-1-git-send-email-zhouchuangao@vivo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 01:35:09AM -0700, zhouchuangao wrote:
> BUG_ON uses unlikely in if(), it can be optimized at compile time.
> 
> Usually, the condition in if() is not satisfied. In my opinion,
> this can improve the efficiency of the multi-stage pipeline.
> 
> Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
> ---
>  arch/mips/kvm/tlb.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
