Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 429A61A4994
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 19:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgDJRyN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 13:54:13 -0400
Received: from mga17.intel.com ([192.55.52.151]:61501 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgDJRyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 13:54:13 -0400
IronPort-SDR: C+V99/oI6XeSAUdOGcX9f3f1gbSqfn9sPv77VUpWzc+BCn+vhzyBGy/pz9nvuEco9lysCXxfcC
 D0ex5ZBh8u2A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 10:54:13 -0700
IronPort-SDR: IkWAVfa693E8PfEMFbfR332OxsnjzmMMOXi/Uu9d/IaQwFCZ/KXXQSWeDiKeFpL8z2CXuCBUU8
 /tyqr0RXijew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,367,1580803200"; 
   d="scan'208";a="331238836"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 10 Apr 2020 10:54:13 -0700
Date:   Fri, 10 Apr 2020 10:54:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     syzbot <syzbot+e06e0f40470ee2de4dda@syzkaller.appspotmail.com>
Cc:     christoffer.dall@arm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        peterx@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: slab-out-of-bounds Read in gfn_to_hva
Message-ID: <20200410175412.GF22482@linux.intel.com>
References: <00000000000095762005a2f25f4d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000095762005a2f25f4d@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 10, 2020 at 09:39:12AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    5d30bcac Merge tag '9p-for-5.7-2' of git://github.com/mart..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17243a9fe00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2a7f60f3313b353e
> dashboard link: https://syzkaller.appspot.com/bug?extid=e06e0f40470ee2de4dda
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12b059afe00000
> 
> The bug was bisected to:
> 
> commit 5c0b4f3d5ccc2ced94b01c3256db1cf79dc95b81
> Author: Sean Christopherson <sean.j.christopherson@intel.com>
> Date:   Tue Feb 18 21:07:26 2020 +0000
> 
>     KVM: Move memslot deletion to helper function
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13d14de7e00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=10314de7e00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17d14de7e00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+e06e0f40470ee2de4dda@syzkaller.appspotmail.com
> Fixes: 5c0b4f3d5ccc ("KVM: Move memslot deletion to helper function")

#syz dup: KASAN: slab-out-of-bounds Read in __kvm_gfn_to_hva_cache_init
