Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8919D1A196A
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 03:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgDHBIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 21:08:52 -0400
Received: from mga04.intel.com ([192.55.52.120]:1944 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHBIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 21:08:52 -0400
IronPort-SDR: jrkZGworERqx6k44Ou4dXC3Jja8r6/MWg+f5gQcGLnDeJJVjCOPETGasjFoplVMWqF6+zrmSfc
 zAV7C86QKRkA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2020 18:08:51 -0700
IronPort-SDR: 1fLAkmH3kPwmWuWlWtQjh84iVdStswyVqxVe61K9C8xSinLBYuX41xL/ULGQ4G+9kBFdrtTyZa
 YaCBVgCsYfTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,357,1580803200"; 
   d="scan'208";a="398043103"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 07 Apr 2020 18:08:51 -0700
Date:   Tue, 7 Apr 2020 18:08:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     syzbot <syzbot+a65b3f8eec6b27650a25@syzkaller.appspotmail.com>
Cc:     christoffer.dall@arm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
        peterx@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: slab-out-of-bounds Read in kvm_read_guest_page
Message-ID: <20200408010851.GB9715@linux.intel.com>
References: <0000000000003e2e5905a2b8ea2c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000003e2e5905a2b8ea2c@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 07, 2020 at 01:06:11PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    bef7b2a7 Merge tag 'devicetree-for-5.7' of git://git.kerne..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16e40efbe00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=91b674b8f0368e69
> dashboard link: https://syzkaller.appspot.com/bug?extid=a65b3f8eec6b27650a25
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14869db7e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d2731fe00000
> 
> The bug was bisected to:
> 
> commit 36947254e5f981aeeedab1c7dfa35fc34d330e80
> Author: Sean Christopherson <sean.j.christopherson@intel.com>
> Date:   Tue Feb 18 21:07:32 2020 +0000
> 
>     KVM: Dynamically size memslot array based on number of used slots
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10a24a5de00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=12a24a5de00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=14a24a5de00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+a65b3f8eec6b27650a25@syzkaller.appspotmail.com
> Fixes: 36947254e5f9 ("KVM: Dynamically size memslot array based on number of used slots")

#syz dup: KASAN: slab-out-of-bounds Read in __kvm_gfn_to_hva_cache_init
