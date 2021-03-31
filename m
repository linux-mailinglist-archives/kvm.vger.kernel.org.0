Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E79134F802
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 06:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhCaEcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 00:32:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56584 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhCaEbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 00:31:42 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12V4OtYL012344;
        Wed, 31 Mar 2021 04:29:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=jZzMIjY2XlBA9lqomrEcWjkgBg3vzw6cwVEXQsnkoy8=;
 b=HIgSM5dzg5vy/U6oQ0ue+ji7TjDVaifkmt2TC+GdOHEEc4400+BPiepwlqmXkp3ZdYv6
 dODu4xpneir8dpWeW+eVBSuGwz2uqLDliBNsOFfXtASDOuQHhPkc/QTsC2wvJ+LZCq9z
 LGO29RHrQcSWJiSstaaUQLZs1c2wtZ+URrIs0NevkdKMBha44tXt5at0UNqsiUJAaPPl
 Vhj4g6cn2rTRd419OI40Y1wQbltzWyes0rfsjUK49kTL7/rMCXZBL68rhoMhpUbAfXjQ
 YcVY0QpogX8qAFWb+AcwGIT5CRbYqoW4GPo4XjOR1cYsLK4L4GHvPKyOHmzLC6qmFO5l xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37mafv0tpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 04:29:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12V4PZtY012978;
        Wed, 31 Mar 2021 04:29:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 37mabknwvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 04:29:53 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 12V4Tarv012513;
        Wed, 31 Mar 2021 04:29:40 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Mar 2021 21:29:36 -0700
Date:   Wed, 31 Mar 2021 07:29:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     syzbot <syzbot+015dd7cdbbbc2c180c65@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, bp@alien8.de, daniel.vetter@ffwll.ch,
        daniel.vetter@intel.com, hpa@zytor.com, jmattson@google.com,
        jmorris@namei.org, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        m.szyprowski@samsung.com, mchehab@kernel.org, mingo@redhat.com,
        seanjc@google.com, serge@hallyn.com,
        syzkaller-bugs@googlegroups.com, tfiga@chromium.org,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Subject: Re: [syzbot] WARNING in unsafe_follow_pfn
Message-ID: <20210331042922.GE2065@kadam>
References: <000000000000ca9a6005bec29ebe@google.com>
 <2db3c803-6a94-9345-261a-a2bb74370c02@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2db3c803-6a94-9345-261a-a2bb74370c02@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9939 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103300000 definitions=main-2103310032
X-Proofpoint-ORIG-GUID: 8U9S4YCrdfA3ra6tRyXiCiMZhDB1YF_P
X-Proofpoint-GUID: 8U9S4YCrdfA3ra6tRyXiCiMZhDB1YF_P
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9939 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 adultscore=0
 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103300000
 definitions=main-2103310032
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 30, 2021 at 07:04:30PM +0200, Paolo Bonzini wrote:
> On 30/03/21 17:26, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    93129492 Add linux-next specific files for 20210326
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=169ab21ad00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=6f2f73285ea94c45
> > dashboard link: https://syzkaller.appspot.com/bug?extid=015dd7cdbbbc2c180c65
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119b8d06d00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112e978ad00000
> > 
> > The issue was bisected to:
> > 
> > commit d40b9fdee6dc819d8fc35f70c345cbe0394cde4c
> > Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Date:   Tue Mar 16 15:33:01 2021 +0000
> > 
> >      mm: Add unsafe_follow_pfn
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=122d2016d00000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=112d2016d00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=162d2016d00000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+015dd7cdbbbc2c180c65@syzkaller.appspotmail.com
> > Fixes: d40b9fdee6dc ("mm: Add unsafe_follow_pfn")
> 
> This is basically intentional because get_vaddr_frames is broken, isn't it?
> I think it needs to be ignored in syzkaller.

What?

The bisect is wrong (because it's blaming the commit which added the
warning instead of the commit which added the buggy caller) but the
warning is correct.

Plus users are going to be seeing this as well.  According to the commit
message for 69bacee7f9ad ("mm: Add unsafe_follow_pfn") "Unfortunately
there's some users where this is not fixable (like v4l userptr of iomem
mappings)".  It sort of seems crazy to dump this giant splat and then
tell users to ignore it forever because it can't be fixed...  0_0

regards,
dan carpenter

> 
> Paolo
> 
> > ------------[ cut here ]------------
> > unsafe follow_pfn usage
> > WARNING: CPU: 1 PID: 8426 at mm/memory.c:4807 unsafe_follow_pfn+0x20f/0x260 mm/memory.c:4807
> > Modules linked in:
> > CPU: 0 PID: 8426 Comm: syz-executor677 Not tainted 5.12.0-rc4-next-20210326-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > RIP: 0010:unsafe_follow_pfn+0x20f/0x260 mm/memory.c:4807
> > Code: 8b 7c 24 20 49 89 6d 00 e8 6e 84 64 07 e9 30 ff ff ff e8 f4 19 cb ff 48 c7 c7 40 1f 76 89 c6 05 56 eb 09 0c 01 e8 34 1a 21 07 <0f> 0b e9 71 fe ff ff 41 bc ea ff ff ff e9 06 ff ff ff e8 1a 65 0f
> > RSP: 0018:ffffc9000161f660 EFLAGS: 00010282
> > RAX: 0000000000000000 RBX: 1ffff920002c3ecc RCX: 0000000000000000
> > RDX: ffff88801954d580 RSI: ffffffff815c3fd5 RDI: fffff520002c3ebe
> > RBP: ffff888023d56948 R08: 0000000000000000 R09: 0000000000000000
> > R10: ffffffff815bd77e R11: 0000000000000000 R12: 0000000021000000
> > R13: ffff8880143a4010 R14: 0000000000000000 R15: 0000000000000110
> > FS:  00000000005d1300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f172c4cd6c0 CR3: 0000000011f70000 CR4: 00000000001506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >   get_vaddr_frames+0x337/0x600 drivers/media/common/videobuf2/frame_vector.c:72
> >   vb2_create_framevec+0x55/0xc0 drivers/media/common/videobuf2/videobuf2-memops.c:50
> >   vb2_vmalloc_get_userptr+0xce/0x4c0 drivers/media/common/videobuf2/videobuf2-vmalloc.c:90
> >   __prepare_userptr+0x342/0x15f0 drivers/media/common/videobuf2/videobuf2-core.c:1128
> >   __buf_prepare+0x635/0x7d0 drivers/media/common/videobuf2/videobuf2-core.c:1367
> >   vb2_core_qbuf+0xa9d/0x11c0 drivers/media/common/videobuf2/videobuf2-core.c:1658
> >   vb2_qbuf+0x135/0x1a0 drivers/media/common/videobuf2/videobuf2-v4l2.c:820
> >   vb2_ioctl_qbuf+0xfb/0x140 drivers/media/common/videobuf2/videobuf2-v4l2.c:1050
> >   v4l_qbuf drivers/media/v4l2-core/v4l2-ioctl.c:2027 [inline]
> >   v4l_qbuf+0x92/0xc0 drivers/media/v4l2-core/v4l2-ioctl.c:2021
> >   __video_do_ioctl+0xb94/0xe20 drivers/media/v4l2-core/v4l2-ioctl.c:2951
> >   video_usercopy+0x253/0x1300 drivers/media/v4l2-core/v4l2-ioctl.c:3297
> >   v4l2_ioctl+0x1b3/0x250 drivers/media/v4l2-core/v4l2-dev.c:366
> >   vfs_ioctl fs/ioctl.c:48 [inline]
> >   __do_sys_ioctl fs/ioctl.c:753 [inline]
> >   __se_sys_ioctl fs/ioctl.c:739 [inline]
> >   __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
> >   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> > RIP: 0033:0x443639
> > Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007ffee3065668 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443639
> > RDX: 0000000020000140 RSI: 00000000c058560f RDI: 0000000000000004
> > RBP: 00000000004031e0 R08: 00000000004004a0 R09: 00000000004004a0
> > R10: 00236962762f7665 R11: 0000000000000246 R12: 0000000000403270
> > R13: 0000000000000000 R14: 00000000004b1018 R15: 00000000004004a0
> > 
> > 
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> > syzbot can test patches for this issue, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
> > 
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/2db3c803-6a94-9345-261a-a2bb74370c02%40redhat.com.
