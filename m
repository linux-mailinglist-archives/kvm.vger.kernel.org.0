Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D28820EE19
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 08:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbgF3GLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 02:11:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:56664 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgF3GLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 02:11:51 -0400
IronPort-SDR: SWeiPHPHTaUUvP2lGpElwJJaB+GLorP+UeZTj67Rq2nYmsn0Un4mchnI0DbwWrB06CFVqDkJ+l
 o40xmWn/iLJA==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="145228536"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="145228536"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 23:11:50 -0700
IronPort-SDR: WHE0t9yzwpQ0xsCGPsCSh2IpbpMzO83OTzGpFF2gffqQMYkSgRBW7p3bEYpUK5mE+OUzVt0xek
 mSi74pFIOZSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="386605000"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 29 Jun 2020 23:11:49 -0700
Date:   Mon, 29 Jun 2020 23:11:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     syzbot <syzbot+a99874f5323ce6088e53@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Subject: Re: KASAN: null-ptr-deref Read in kvm_arch_check_processor_compat
Message-ID: <20200630061149.GT12312@linux.intel.com>
References: <000000000000077a6505a8bf57b2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000077a6505a8bf57b2@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 05:17:15AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=135e7235100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d195fe572fb15312
> dashboard link: https://syzkaller.appspot.com/bug?extid=a99874f5323ce6088e53
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14d001be100000

#syz dup: general protection fault in syscall_return_slowpath
