Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC14D234041
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731700AbgGaHml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgGaHmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:42:40 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74733C061574;
        Fri, 31 Jul 2020 00:42:40 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id k12so5193216otr.1;
        Fri, 31 Jul 2020 00:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uUxxuAaUM3IhS80H69+dAMfn0XD0l8mgz/kqOVjRY3I=;
        b=fQ2YIZXs7donFRASvMsynBa5CcpLxDDJz0Cr3cFBg9UHav+7Lh7dekb7B4E6U13l5M
         pfAarsMlgxPDIpL7PKCiI33EWLHCu7f/CIcFwrXh1oE4r5BjrxrQqWATZ6NT2M8JcyQW
         tdKgRc+krOws5+FUHMa6h8aVU/dU2cawvt8BrrlPAMuYF7CbyhMUtCLhKClUUcPDT6Qy
         qk4DJpfqoft8I3a76G+DW5wCt9OPzsxYJRjo9zFBAoByYu8I3SaZzbzd2pvTZ/aTv/1a
         iUIcZSpxsogrzdrZbwkm15h0E3aGXURLPm054Ah8dBFAWtSTrlbJ7n1W9Vm6J56A2Xti
         WHmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uUxxuAaUM3IhS80H69+dAMfn0XD0l8mgz/kqOVjRY3I=;
        b=nhrlNCBsvK7Zu6CqllKkO21dLqGOD1fDJeZuW4+MUatH56us1MpChww+etNdku4bTx
         D08nkAZGByDxiVM19ARgQ/LKoHwo/RRmAwrdVOO8GBA5fahbjuVlOJkncjg3MJ1JrUwO
         30sO09CL8lFrlYuA8c5AbT1eL+eMv1EF2eh38W9sP9etY4W7sZlooPf0Qjcyzc2ZGXBS
         /+bFbA2T0892kBJ/89B6CCTmPPIySubrVFCMOlNPts5C0qM6XiFSmJSzadubZ1M3MBJ4
         6v4mYubCtlDNRX134hs/1fHsEeWNyRvuGNMB/M0bJOjBgvrx6BHOgdvwfS0lAYWB/dB6
         KVwQ==
X-Gm-Message-State: AOAM532UTZMV8Lk0sypJKCLY61uni15EWhYVbPN1JvfzkgPgcTmT1waP
        USTFTPyxYhAHHRubOx3ODmCdP/5PDv75x74JjPE=
X-Google-Smtp-Source: ABdhPJwAs4xUqdcaj3HAoZdwT+nBk/AUjPDS6TK5BTAbMq2R/xq2CyItrrwmH3ZQUh977NQfhoGB6uZsQtZGMU1ekZM=
X-Received: by 2002:a05:6830:23a1:: with SMTP id m1mr1982994ots.185.1596181359851;
 Fri, 31 Jul 2020 00:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <ece36eb1-253a-8ec6-c183-309c10bb35d5@redhat.com>
 <CANRm+Cywhi1p5gYLfG=JcyTdYuWK+9bGqF6HD-LiBJM9Q5ykNQ@mail.gmail.com>
 <CANRm+CwrT=gxxgkNdT3wFwzWYYh3FFrUU=aTqH8VT=MraU7jkw@mail.gmail.com>
 <57ea501b-bf54-3fc0-4a8f-2820df623b14@redhat.com> <8c99291a-adf5-d357-f916-e86b5a0100aa@redhat.com>
In-Reply-To: <8c99291a-adf5-d357-f916-e86b5a0100aa@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 31 Jul 2020 15:42:28 +0800
Message-ID: <CANRm+CzAPnGRA8PTFsPQVVwpLnbdt=jwocgOB2CG5Ti8KWV9ig@mail.gmail.com>
Subject: Re: WARNING: suspicious RCU usage - while installing a VM on a CPU
 listed under nohz_full
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        "frederic@kernel.org" <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Juri Lelli <juri.lelli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 31 Jul 2020 at 06:45, Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
>
> On 7/29/20 8:34 AM, Nitesh Narayan Lal wrote:
> > On 7/28/20 10:38 PM, Wanpeng Li wrote:
> >> Hi Nitesh=EF=BC=8C
> >> On Wed, 29 Jul 2020 at 09:00, Wanpeng Li <kernellwp@gmail.com> wrote:
> >>> On Tue, 28 Jul 2020 at 22:40, Nitesh Narayan Lal <nitesh@redhat.com> =
wrote:
> >>>> Hi,
> >>>>
> >>>> I have recently come across an RCU trace with the 5.8-rc7 kernel tha=
t has the
> >>>> debug configs enabled while installing a VM on a CPU that is listed =
under
> >>>> nohz_full.
> >>>>
> >>>> Based on some of the initial debugging, my impression is that the is=
sue is
> >>>> triggered because of the fastpath that is meant to optimize the writ=
es to x2APIC
> >>>> ICR that eventually leads to a virtual IPI in fixed delivery mode, i=
s getting
> >>>> invoked from the quiescent state.
> >> Could you try latest linux-next tree? I guess maybe some patches are
> >> pending in linux-next tree, I can't reproduce against linux-next tree.
> > Sure, I will try this today.
>
> Hi Wanpeng,
>
> I am not seeing the issue getting reproduced with the linux-next tree.
> Although, I am still seeing a Warning stack trace:
>
> [  139.220080] RIP: 0010:kvm_arch_vcpu_ioctl_run+0xb57/0x1320 [kvm]
> [  139.226837] Code: e8 03 0f b6 04 18 84 c0 74 06 0f 8e 4a 03 00 00 41 c=
6 85 48
> 31 00 00 00 e9 24 f8 ff ff 4c 89 ef e8 7e ac 02 00 e9 3d f8 ff ff <0f> 0b=
 e9 f2
> f8 ff ff 48f
> [  139.247828] RSP: 0018:ffff8889bc397cb8 EFLAGS: 00010202
> [  139.253700] RAX: 0000000000000001 RBX: dffffc0000000000 RCX: ffffffffc=
1fc3bef
> [  139.261695] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff888f0=
fa1a8a0
> [  139.269692] RBP: ffff8889bc397d18 R08: ffffed113786a7d0 R09: ffffed113=
786a7d0
> [  139.277686] R10: ffff8889bc353e7f R11: ffffed113786a7cf R12: ffff8889b=
c35423c
> [  139.285682] R13: ffff8889bc353e40 R14: ffff8889bc353e6c R15: ffff88897=
f536000
> [  139.293678] FS:  00007f3d8a71c700(0000) GS:ffff888a3c400000(0000)
> knlGS:0000000000000000
> [  139.302742] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  139.309186] CR2: 0000000000000000 CR3: 00000009bc34c004 CR4: 000000000=
03726e0
> [  139.317180] Call Trace:
> [  139.320002]  kvm_vcpu_ioctl+0x3ee/0xb10 [kvm]
> [  139.324907]  ? sched_clock+0x5/0x10
> [  139.328875]  ? kvm_io_bus_get_dev+0x1c0/0x1c0 [kvm]
> [  139.334375]  ? ioctl_file_clone+0x120/0x120
> [  139.339079]  ? selinux_file_ioctl+0x98/0x570
> [  139.343895]  ? selinux_file_mprotect+0x5b0/0x5b0
> [  139.349088]  ? irq_matrix_assign+0x360/0x430
> [  139.353904]  ? rcu_read_lock_sched_held+0xe0/0xe0
> [  139.359201]  ? __fget_files+0x1f0/0x300
> [  139.363532]  __x64_sys_ioctl+0x128/0x18e
> [  139.367948]  do_syscall_64+0x33/0x40
> [  139.371974]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  139.377643] RIP: 0033:0x7f3d98d0a88b
>
> Are you also triggering anything like this in your environment?

I see other issue when rmmod kvm modules. :)

 ------------[ cut here ]------------
 WARNING: CPU: 5 PID: 2837 at kernel/rcu/tree_plugin.h:1738 call_rcu+0xd3/0=
x800
 CPU: 5 PID: 2837 Comm: rmmod Not tainted 5.8.0-rc7-next-20200728 #1
 RIP: 0010:call_rcu+0xd3/0x800
 RSP: 0018:ffffae25c302bd90 EFLAGS: 00010002
 RAX: 0000000000000001 RBX: ffffffff944e4f80 RCX: 0000000000000000
 RDX: 0000000000000101 RSI: 000000000000009f RDI: ffffffff93308cef
 RBP: ffffae25c302bdf0 R08: 000000000000074e R09: 0000000000002a2f
 R10: 0000000000000002 R11: ffffffff944dcf80 R12: ffffffff936ef4c0
 R13: ffff9702ce1fd900 R14: ffffffff920e2bd0 R15: 00000000ffff3849
 FS:  00007fc99b242700(0000) GS:ffff9702ce000000(0000) knlGS:00000000000000=
00
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055905332dd58 CR3: 00000003eeb46005 CR4: 00000000001706e0
 Call Trace:
  call_rcu_zapped+0x70/0x80
  lockdep_unregister_key+0xa6/0xf0
  destroy_workqueue+0x1b1/0x210
  kvm_irqfd_exit+0x15/0x20 [kvm]
  kvm_exit+0x78/0x80 [kvm]
  vmx_exit+0x1e/0x50 [kvm_intel]
  __x64_sys_delete_module+0x1e6/0x260
  do_syscall_64+0x63/0x350
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7fc99ad7b9e7
