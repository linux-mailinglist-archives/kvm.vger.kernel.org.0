Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997FD20EE20
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 08:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbgF3GMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 02:12:53 -0400
Received: from mga06.intel.com ([134.134.136.31]:10230 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgF3GMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 02:12:52 -0400
IronPort-SDR: Tq/jPCzosdP8vwJ0TgQYavDW5RaIym7RkHJKdOKFyiPjHQ7MgDqNu+XgYBmogT5aBslTDP6WRY
 VW2FOUGKfquw==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="207667129"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="207667129"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 23:12:52 -0700
IronPort-SDR: XbW0ERvHwlbn6rOYPfAXZL2Ce50DV687GcE1dEkHBxxKcL/WAm5IMqrsxzoQjvI1d0625+OlJm
 OHoI9NOwdBFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="312271971"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 29 Jun 2020 23:12:52 -0700
Date:   Mon, 29 Jun 2020 23:12:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     syzbot <syzbot+e0240f9c36530bda7130@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Subject: Re: KASAN: out-of-bounds Read in kvm_arch_hardware_setup
Message-ID: <20200630061252.GV12312@linux.intel.com>
References: <000000000000a0784a05a916495e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000a0784a05a916495e@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 27, 2020 at 01:01:13PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1654e385100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=be4578b3f1083656
> dashboard link: https://syzkaller.appspot.com/bug?extid=e0240f9c36530bda7130
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f3abc9100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131b7bb5100000

#syz dup: general protection fault in syscall_return_slowpath
