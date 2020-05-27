Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3F71E33F4
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 02:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgE0AMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 20:12:15 -0400
Received: from mga04.intel.com ([192.55.52.120]:14717 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725969AbgE0AMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 20:12:14 -0400
IronPort-SDR: DUsAlBE1/cbQEr8X+PBFtbDIy0V8b40WT/FunzzkusoxVmFEHCkM+1/OyY/yGD3carKpYHmCX9
 TQ+Vxve+fkYQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 17:12:14 -0700
IronPort-SDR: KQnRZ+5k13psFrnBoq88rIvT+3D2Ihvhk0t6qttIJX/a2X43NEjNGfsHwVkQ/uwwamVkqckvKK
 WaU0dtnyT74A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,439,1583222400"; 
   d="scan'208";a="345350156"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 26 May 2020 17:12:13 -0700
Date:   Tue, 26 May 2020 17:12:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     syzbot <syzbot+904752567107eefb728c@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, eesposit@redhat.com, gregkh@linuxfoundation.org,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, rafael@kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Subject: Re: kernel BUG at arch/x86/kvm/mmu/mmu.c:LINE! (2)
Message-ID: <20200527001213.GA31696@linux.intel.com>
References: <000000000000935ffd05a6939060@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000935ffd05a6939060@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 02:13:19PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    c11d28ab Add linux-next specific files for 20200522
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=153b5016100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3f6dbdea4159fb66
> dashboard link: https://syzkaller.appspot.com/bug?extid=904752567107eefb728c
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11510cba100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=129301e2100000
> 
> The bug was bisected to:
> 
> commit 63d04348371b7ea4a134bcf47c79763d969e9168
> Author: Paolo Bonzini <pbonzini@redhat.com>
> Date:   Tue Mar 31 22:42:22 2020 +0000
> 
>     KVM: x86: move kvm_create_vcpu_debugfs after last failure point
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1226e8ee100000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=1126e8ee100000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1626e8ee100000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+904752567107eefb728c@syzkaller.appspotmail.com
> Fixes: 63d04348371b ("KVM: x86: move kvm_create_vcpu_debugfs after last failure point")
> 
> L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
> ------------[ cut here ]------------
> kernel BUG at arch/x86/kvm/mmu/mmu.c:3722!

The bisection has a completely different signature, it's likely a different
bug.  I'll take a look at both.
