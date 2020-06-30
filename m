Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28F820EE1D
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 08:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgF3GM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 02:12:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:2096 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729808AbgF3GM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jun 2020 02:12:29 -0400
IronPort-SDR: tmazwPYorPvvbcDDUczUvBHHEx+U5xlRLIZ70Sitse9as+FqAJOyhNBcdoBJp0TD2NVhpMkhAs
 Smtiych/N7sw==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="164168151"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="164168151"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 23:12:28 -0700
IronPort-SDR: GpJLMbiIm0KKYRJwt+XBk+4Xa0tN+rvlhQZ3nfspt4KCAM3Hbn68kepGtS2moHfvf0lSz3K8/b
 VRgxFJUeOeew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="277321994"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 29 Jun 2020 23:12:28 -0700
Date:   Mon, 29 Jun 2020 23:12:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     syzbot <syzbot+b46fb19f175c5c7d1f03@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Subject: Re: general protection fault in pvclock_gtod_notify
Message-ID: <20200630061228.GU12312@linux.intel.com>
References: <0000000000002e703905a902457b@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000002e703905a902457b@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 26, 2020 at 01:08:19PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    4a21185c Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16958f4d100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bf3aec367b9ab569
> dashboard link: https://syzkaller.appspot.com/bug?extid=b46fb19f175c5c7d1f03
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1080e9c5100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1685d2e3100000

#syz dup: general protection fault in syscall_return_slowpath
