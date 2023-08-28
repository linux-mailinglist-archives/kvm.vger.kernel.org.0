Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CED78B45D
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 17:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjH1PYE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 28 Aug 2023 11:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjH1PXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 11:23:32 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68CCE0;
        Mon, 28 Aug 2023 08:23:30 -0700 (PDT)
Received: from hamburger.collabora.co.uk (hamburger.collabora.co.uk [IPv6:2a01:4f8:1c1c:f269::1])
        by madras.collabora.co.uk (Postfix) with ESMTP id A774A660716E;
        Mon, 28 Aug 2023 16:23:26 +0100 (BST)
From:   "Muhammad Usama Anjum" <usama.anjum@collabora.com>
In-Reply-To: <ZOy5L4WCiy1hsiu0@google.com>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
Date:   Mon, 28 Aug 2023 16:23:26 +0100
Cc:     "syzbot" <syzbot+412c9ae97b4338c5187e@syzkaller.appspotmail.com>,
        syzkaller-lts-bugs@googlegroups.com,
        "syzbot" <syzbot+b000b7d21f93fc69de32@syzkaller.appspotmail.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        =?utf-8?q?H=2E_Peter_Anvin?= <hpa@zytor.com>,
        "Jarkko Sakkinen" <jarkko@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
To:     "Sean Christopherson" <seanjc@google.com>
MIME-Version: 1.0
Message-ID: <6ba2-64ecbc00-5-39397d40@6469447>
Subject: =?utf-8?q?Re=3A?==?utf-8?q?_[v5=2E15]?= WARNING in 
 =?utf-8?q?kvm=5Farch=5Fvcpu=5Fioctl=5Frun?=
User-Agent: SOGoMail 5.8.4
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday, August 28, 2023 08:11 PM PKT, Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Aug 28, 2023, Muhammad Usama Anjum wrote:
> > On 5/5/23 1:28 PM, syzbot wrote:
> > > syzbot has found a reproducer for the following issue on:
> > > 
> > > HEAD commit: 8a7f2a5c5aa1 Linux 5.15.110
> > This same warning has also been found on  6.1.21.
> > 
> > > git tree: linux-5.15.y
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=15f12318280000
> > > kernel config: https://syzkaller.appspot.com/x/.config?x=ba8d5c9d6c5289f
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=412c9ae97b4338c5187e
> > > compiler: Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
> > > syz repro: https://syzkaller.appspot.com/x/repro.syz?x=10e13c84280000
> > > C reproducer: https://syzkaller.appspot.com/x/repro.c?x=149d9470280000
> > I've tried all the C and syz reproducers. I've also tried syz-crash which
> > launched multiple instances of VMs and ran syz reproducer. But the issue
> > didn't get reproduced.
> > 
> > I don't have kvm skills. Can someone have a look at the the warning
> > (probably by static analysis)?
> > 
> > > 
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/fc04f54c047f/disk-8a7f2a5c.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/6b4ba4cb1191/vmlinux-8a7f2a5c.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/d927dc3f9670/bzImage-8a7f2a5c.xz
> > > 
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+412c9ae97b4338c5187e@syzkaller.appspotmail.com
> > > 
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 0 PID: 3502 at arch/x86/kvm/x86.c:10310 kvm_arch_vcpu_ioctl_run+0x1d63/0x1f80
> 
> "Fixed" by https://lore.kernel.org/all/20230808232057.2498287-1-seanjc@google.com,
> in quotes because sadly the fix was to simply delete the sanity check :-(

Thank you so much Sean. Thank you so much Sean. Syzbot has been finding the issue in LTS kernels. I'm not sure if we should backport a patch which is just removing a false warning. 

#syz fix: KVM: x86: Remove WARN sanity check on hypervisor timer vs. UNINITIALIZED vCPU

