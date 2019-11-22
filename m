Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD6761079AD
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 21:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKVUyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 15:54:55 -0500
Received: from mga04.intel.com ([192.55.52.120]:26529 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbfKVUyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 15:54:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 12:54:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="358238784"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 22 Nov 2019 12:54:53 -0800
Date:   Fri, 22 Nov 2019 12:54:53 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     syzbot <syzbot+7e2ab84953e4084a638d@syzkaller.appspotmail.com>
Cc:     casey@schaufler-ca.com, frederic@kernel.org,
        gregkh@linuxfoundation.org, hpa@zytor.com, jmattson@google.com,
        jmorris@namei.org, karahmed@amazon.de,
        kstewart@linuxfoundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, mingo@kernel.org,
        mingo@redhat.com, pasha.tatashin@oracle.com, pbonzini@redhat.com,
        pombredanne@nexb.com, rkrcmar@redhat.com, serge@hallyn.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Subject: Re: general protection fault in __schedule (2)
Message-ID: <20191122205453.GE31235@linux.intel.com>
References: <000000000000e67a05057314ddf6@google.com>
 <0000000000005eb1070597ea3a1f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000005eb1070597ea3a1f@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 11:19:00PM -0800, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 8fcc4b5923af5de58b80b53a069453b135693304
> Author: Jim Mattson <jmattson@google.com>
> Date:   Tue Jul 10 09:27:20 2018 +0000
> 
>     kvm: nVMX: Introduce KVM_CAP_NESTED_STATE
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124cdbace00000
> start commit:   234b69e3 ocfs2: fix ocfs2 read block panic
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=114cdbace00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=164cdbace00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5fa12be50bca08d8
> dashboard link: https://syzkaller.appspot.com/bug?extid=7e2ab84953e4084a638d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150f0a4e400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f67111400000
> 
> Reported-by: syzbot+7e2ab84953e4084a638d@syzkaller.appspotmail.com
> Fixes: 8fcc4b5923af ("kvm: nVMX: Introduce KVM_CAP_NESTED_STATE")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Is there a way to have syzbot stop processing/bisecting these things
after a reasonable amount of time?  The original crash is from August of
last year...

Note, the original crash is actually due to KVM's put_kvm() fd race, but
whatever we want to blame, it's a duplicate.

#syz dup: general protection fault in kvm_lapic_hv_timer_in_use
