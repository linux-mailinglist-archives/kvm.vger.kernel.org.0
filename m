Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E941ACDED
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 18:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgDPQmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 12:42:02 -0400
Received: from elvis.franken.de ([193.175.24.41]:42207 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727800AbgDPQld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 12:41:33 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1jP7Zy-0001kl-01; Thu, 16 Apr 2020 18:41:30 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 130E2C0144; Thu, 16 Apr 2020 18:35:21 +0200 (CEST)
Date:   Thu, 16 Apr 2020 18:35:21 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        maobibo <maobibo@loongson.cn>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH] mips: define pud_index() regardless of page table folding
Message-ID: <20200416163521.GB24743@alpha.franken.de>
References: <20200402081614.5696-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402081614.5696-1-rppt@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 02, 2020 at 11:16:14AM +0300, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> Commit 31168f033e37 ("mips: drop __pXd_offset() macros that duplicate
> pXd_index() ones") is correct that pud_index() & __pud_offset() are the
> same when pud_index() is actually provided, however it does not take into
> account the __PAGETABLE_PUD_FOLDED case. This has broken MIPS KVM
> compilation because it relied on availability of pud_index().
> 
> Define pud_index() regardless of page table folded. It will evaluate to
> actual index for 4-level pagetables and to 0 for folded PUD level.
> 
> Link: https://lore.kernel.org/lkml/20200331154749.5457-1-pbonzini@redhat.com
> Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  arch/mips/include/asm/pgtable-64.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
