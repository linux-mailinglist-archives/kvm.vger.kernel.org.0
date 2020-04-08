Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C32971A196C
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 03:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgDHBJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 21:09:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:40735 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgDHBJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 21:09:07 -0400
IronPort-SDR: DwAssjsFtJebpUKFbc/q5EtBjAImjvHHMK5bzHaKV9BhV+aW1zszHSetNdqZdAMj6wDSLeipsV
 mqjuXafGbDVA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2020 18:09:06 -0700
IronPort-SDR: HFXzplmA++ljj+MF2xSFCUd7g4U4i1LR3jmtpn80baJ/KtVluMzJxO/gHMwBPj2ksvNyfbBvA2
 vpkfxIajxGbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,357,1580803200"; 
   d="scan'208";a="297098923"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Apr 2020 18:09:06 -0700
Date:   Tue, 7 Apr 2020 18:09:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     syzbot <syzbot+89a42836ac72e6a02d35@syzkaller.appspotmail.com>
Cc:     christoffer.dall@arm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
        peterx@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: slab-out-of-bounds Read in kvm_vcpu_gfn_to_memslot
Message-ID: <20200408010905.GC9715@linux.intel.com>
References: <000000000000fca9a205a2b90dd6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000fca9a205a2b90dd6@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 07, 2020 at 01:16:10PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    bef7b2a7 Merge tag 'devicetree-for-5.7' of git://git.kerne..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15ce12cde00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=91b674b8f0368e69
> dashboard link: https://syzkaller.appspot.com/bug?extid=89a42836ac72e6a02d35
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c69db7e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17b8b02be00000
> 
> The bug was bisected to:
> 
> commit 36947254e5f981aeeedab1c7dfa35fc34d330e80
> Author: Sean Christopherson <sean.j.christopherson@intel.com>
> Date:   Tue Feb 18 21:07:32 2020 +0000
> 
>     KVM: Dynamically size memslot array based on number of used slots
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15f1b1fbe00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=17f1b1fbe00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=13f1b1fbe00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+89a42836ac72e6a02d35@syzkaller.appspotmail.com
> Fixes: 36947254e5f9 ("KVM: Dynamically size memslot array based on number of used slots")

#syz dup: KASAN: slab-out-of-bounds Read in __kvm_gfn_to_hva_cache_init
