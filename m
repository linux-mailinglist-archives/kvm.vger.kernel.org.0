Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325CA1B8337
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 04:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgDYCSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 22:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbgDYCSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 22:18:46 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9989320776;
        Sat, 25 Apr 2020 02:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587781126;
        bh=+/xVjrg1YQaMoG8G2O+p2JLhT90x00i5C4LT2gABEl8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fmhczGs00Rlyc7NqWn3tSWDdPoAn2fELcXr+j64Kp8BATfKVtyLx6a9FhUYrtf9gf
         ZMxNlZRHyQ/hPXPlH5YoCj0cCPFl54Tz4uaorBXOwnNHP6Dw1lj4q8WL1hdopi1Ypr
         QotQbxp21x9SoVKRKVdxF0DushMOB9kWfUTTPrLo=
Date:   Fri, 24 Apr 2020 19:18:35 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     syzbot <syzbot+9af6d43c1beabec8fd05@syzkaller.appspotmail.com>
Cc:     dvyukov@google.com, gleb@kernel.org, gregkh@linuxfoundation.org,
        gwshan@linux.vnet.ibm.com, hpa@zytor.com, jslaby@suse.com,
        jslaby@suse.cz, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, mpe@ellerman.id.au, pbonzini@redhat.com,
        ruscur@russell.cc, stewart@linux.vnet.ibm.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Subject: Re: KASAN: use-after-free Read in tty_open
Message-ID: <20200425021835.GA849@sol.localdomain>
References: <000000000000dd04830598d50133@google.com>
 <0000000000002d42ee05a4127cfc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000002d42ee05a4127cfc@google.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 05:23:03PM -0700, syzbot wrote:
> syzbot suspects this bug was fixed by commit:
> 
> commit ca4463bf8438b403596edd0ec961ca0d4fbe0220
> Author: Eric Biggers <ebiggers@google.com>
> Date:   Sun Mar 22 03:43:04 2020 +0000
> 
>     vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11594fc8100000
> start commit:   07c4b9e9 Merge tag 'scsi-fixes' of git://git.kernel.org/pu..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=79f79de2a27d3e3d
> dashboard link: https://syzkaller.appspot.com/bug?extid=9af6d43c1beabec8fd05
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=113886fae00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1263520ae00000
> 
> If the result looks correct, please mark the bug fixed by replying with:
> 
> #syz fix: vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console
