Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B87226C83
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 18:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbgGTQ4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 12:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729270AbgGTQ4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 12:56:14 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BAEC061794;
        Mon, 20 Jul 2020 09:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=yEZNkurgufx3ZCb4un54sl+Zam6nWfgmzTVWvZxSg20=; b=H7oC7q4e5JxlLxxTULi3bOB4rS
        w6Cr/4ehI3EIGohxKjayYspKcodudDbHHHdKLokO5GAtwd7irSWAWka/2XXgfba668SjHbjt4Y7/s
        FORgV8iC42DaNFVGgClVy7YC/7wxOfAxlw0Y55SbPETQhMXDXOkh+XW/EJyKKNVEEStOl63flDUrf
        4G1BeE57RMUmf8pvEe5CAI3ES7lIvyq8uJpE9hk9JlqoTZ2rQL3eNCA3Py1mLLhrHXWPRxOE3JMIx
        kMz2/2z8/QZVRSKHbiCL0kulXD40C+91ZovsuU1NQKUnJrSpIml94wGAWaUgGVOH9pD8UdN6Jcy2b
        eIm/Fc3w==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxZ5H-0008W2-QN; Mon, 20 Jul 2020 16:56:12 +0000
Subject: Re: linux-next: Tree for Jul 20 (arch/x86/kvm/)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
References: <20200720194225.17de9962@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <1d2aa97d-4a94-673c-dc82-509da221c5d6@infradead.org>
Date:   Mon, 20 Jul 2020 09:56:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200720194225.17de9962@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/20/20 2:42 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20200717:
> 

on x86_64:

  CC [M]  arch/x86/kvm/mmu/page_track.o
In file included from ../include/linux/pid.h:5:0,
                 from ../include/linux/sched.h:14,
                 from ../include/linux/kvm_host.h:12,
                 from ../arch/x86/kvm/mmu/page_track.c:14:
../arch/x86/kvm/mmu/page_track.c: In function ‘kvm_page_track_write’:
../include/linux/rculist.h:727:30: error: left-hand operand of comma expression has no effect [-Werror=unused-value]
  for (__list_check_srcu(cond),     \
                              ^
../arch/x86/kvm/mmu/page_track.c:232:2: note: in expansion of macro ‘hlist_for_each_entry_srcu’
  hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
  ^~~~~~~~~~~~~~~~~~~~~~~~~
../arch/x86/kvm/mmu/page_track.c: In function ‘kvm_page_track_flush_slot’:
../include/linux/rculist.h:727:30: error: left-hand operand of comma expression has no effect [-Werror=unused-value]
  for (__list_check_srcu(cond),     \
                              ^
../arch/x86/kvm/mmu/page_track.c:258:2: note: in expansion of macro ‘hlist_for_each_entry_srcu’
  hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
  ^~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors



-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
