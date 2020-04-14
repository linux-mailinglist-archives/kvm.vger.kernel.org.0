Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7782E1A71B1
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 05:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404623AbgDNDUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 23:20:13 -0400
Received: from mga18.intel.com ([134.134.136.126]:59129 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404573AbgDNDUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 23:20:13 -0400
IronPort-SDR: BcYFW3kiW4MvyYThOXamxTT1yBmPcpUV9IJwXBvRVCqN3PQ2nrUllMSghtoKnASsd1iGT0Lifh
 z+ONkwhCrdRw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2020 20:20:12 -0700
IronPort-SDR: fmJBGYP5nFgZE0zLQisEHNdMws0RK21VQDcq5j06o1LekTyDfUix97xcWF6JOIa0HHKTdB0/58
 pX3iqfT+Ykqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,381,1580803200"; 
   d="scan'208";a="253069800"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 13 Apr 2020 20:20:12 -0700
Date:   Mon, 13 Apr 2020 20:20:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     syzbot <syzbot+2e0179e5185bcd5b9440@syzkaller.appspotmail.com>
Cc:     christoffer.dall@arm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
        peterx@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: slab-out-of-bounds Read in gfn_to_memslot
Message-ID: <20200414032011.GQ21204@linux.intel.com>
References: <0000000000003311fd05a327a060@google.com>
 <000000000000f6ae4905a32a0633@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000f6ae4905a32a0633@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 13, 2020 at 04:03:04AM -0700, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 36947254e5f981aeeedab1c7dfa35fc34d330e80
> Author: Sean Christopherson <sean.j.christopherson@intel.com>
> Date:   Tue Feb 18 21:07:32 2020 +0000
> 
>     KVM: Dynamically size memslot array based on number of used slots
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1099775de00000
> start commit:   4f8a3cc1 Merge tag 'x86-urgent-2020-04-12' of git://git.ke..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=1299775de00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1499775de00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3bfbde87e8e65624
> dashboard link: https://syzkaller.appspot.com/bug?extid=2e0179e5185bcd5b9440
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e78c7de00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14cf613fe00000
> 
> Reported-by: syzbot+2e0179e5185bcd5b9440@syzkaller.appspotmail.com
> Fixes: 36947254e5f9 ("KVM: Dynamically size memslot array based on number of used slots")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz dup: KASAN: slab-out-of-bounds Read in __kvm_gfn_to_hva_cache_init
