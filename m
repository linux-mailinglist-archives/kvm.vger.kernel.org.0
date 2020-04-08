Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3DA1A1967
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 03:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgDHBIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 21:08:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:4187 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHBIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 21:08:37 -0400
IronPort-SDR: cZFvGbaX4OqQ9GsCd2IKbmVqnqM1YN/34DeK93+DhGGSACNLOOBiISsD+Ok6F0lJ2t2f1Q5ECs
 cr4oN1hAZOuQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2020 18:08:36 -0700
IronPort-SDR: HbZuYYsiw/ks2csu/2ze1a2KnnrA46xrs4Px6zw8mG3s+LvWP3WzDPfwHmZvkUieVYjiMeYFGD
 NXpp4SB11YyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,357,1580803200"; 
   d="scan'208";a="275286114"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 07 Apr 2020 18:08:35 -0700
Date:   Tue, 7 Apr 2020 18:08:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     syzbot <syzbot+516667c144d77aa5ba3c@syzkaller.appspotmail.com>
Cc:     alex.shi@linux.alibaba.com, armijn@tjaldur.nl,
        gregkh@linuxfoundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        rfontana@redhat.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, willy@infradead.org
Subject: Re: KASAN: slab-out-of-bounds Read in __kvm_map_gfn
Message-ID: <20200408010835.GA9715@linux.intel.com>
References: <00000000000001be5205a2b90e71@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000001be5205a2b90e71@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 07, 2020 at 01:16:11PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    bef7b2a7 Merge tag 'devicetree-for-5.7' of git://git.kerne..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12672c5de00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=91b674b8f0368e69
> dashboard link: https://syzkaller.appspot.com/bug?extid=516667c144d77aa5ba3c
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1217010be00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=106c8febe00000

#syz dup: KASAN: slab-out-of-bounds Read in __kvm_gfn_to_hva_cache_init
