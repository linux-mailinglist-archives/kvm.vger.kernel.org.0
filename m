Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7043C59CC75
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 01:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238782AbiHVXqq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 19:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238766AbiHVXqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 19:46:45 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5428A4D4C0
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 16:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661212004; x=1692748004;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=3wply6lLS23NAlxls7wiHXwcJrxsDOjA6HxqGJL3QsQ=;
  b=kYLLs08K3XWtaecJds2KQ4giZF4f93sHzJieCEoVL2r0rqaqNWvsujPm
   Z4u7FT8Tt0UZW18KpVihjY1zIgQNnGkwPmcIfGUiNJ3/B+9stH9WIDivi
   zRv6jqN8Dj/zcmnvdch7ABhEiaJf/pukWYfzfziKJfYXSHA26GsPrTV38
   XU9y1GYEP1JYiUq9oA1Zi2pj6VQwkLCovH5BPACTZfrAquik9VFAwvrS/
   nuR/fegK9Me2JIJsqW/kLSwh9xLvGHPu1NxOQHdrkwD1tGxBX0ZsI5wWA
   936va2/ATbwtydZzOBBDAxmGqm6Lc9uUDZKsRA3u44vJ1Ssm+4lNoxhSi
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="273301113"
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="asc'?scan'208";a="273301113"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 16:46:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="asc'?scan'208";a="669769254"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.159.108])
  by fmsmga008.fm.intel.com with ESMTP; 22 Aug 2022 16:46:42 -0700
Date:   Tue, 23 Aug 2022 07:21:40 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     bugzilla-daemon@kernel.org, kvm@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Subject: Re: [Bug 216388] New: On Host, kernel errors in KVM, on guests, it
 shows CPU stalls
Message-ID: <20220822232140.GL1089@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <bug-216388-28872@https.bugzilla.kernel.org/>
 <YwPB6W2tVIGWD7kD@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YGTp3YEHyFTiE1eD"
Content-Disposition: inline
In-Reply-To: <YwPB6W2tVIGWD7kD@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--YGTp3YEHyFTiE1eD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022.08.22 17:50:33 +0000, Sean Christopherson wrote:
> +GVT folks
>
> On Sun, Aug 21, 2022, bugzilla-daemon@kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D216388
> >=20
> >             Bug ID: 216388
> >            Summary: On Host, kernel errors in KVM, on guests, it shows =
CPU
> >                     stalls
> >            Product: Virtualization
> >            Version: unspecified
> >     Kernel Version: 5.19.0 / 5.19.1 / 5.19.2
> >           Hardware: All
> >                 OS: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: high
> >           Priority: P1
> >          Component: kvm
> >           Assignee: virtualization_kvm@kernel-bugs.osdl.org
> >           Reporter: nanook@eskimo.com
> >         Regression: No
> >=20
> > Created attachment 301614
> >   --> https://bugzilla.kernel.org/attachment.cgi?id=3D301614&action=3De=
dit
> > The configuration file used to Comile this kernel.
> >=20
> > This behavior has persisted across 5.19.0, 5.19.1, and 5.19.2.  While t=
he
> > kernel I am taking this example from is tainted (owing to using Intel
> > development drivers for GPU virtualization), it is also occurring on
> > non-tainted kernels on servers with no development or third party modul=
es
> > installed.
> >=20
> > INFO: task CPU 2/KVM:2343 blocked for more than 1228 seconds.
> > [207177.050049]       Tainted: G     U    I       5.19.2 #1
> > [207177.050050] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disa=
bles
> > this message.
> > [207177.050051] task:CPU 2/KVM       state:D stack:    0 pid: 2343 ppid=
:     1
> > flags:0x00000002
> > [207177.050054] Call Trace:
> > [207177.050055]  <TASK>
> > [207177.050056]  __schedule+0x359/0x1400
> > [207177.050060]  ? kvm_mmu_page_fault+0x1ee/0x980
> > [207177.050062]  ? kvm_set_msr_common+0x31f/0x1060
> > [207177.050065]  schedule+0x5f/0x100
> > [207177.050066]  schedule_preempt_disabled+0x15/0x30
> > [207177.050068]  __mutex_lock.constprop.0+0x4e2/0x750
> > [207177.050070]  ? aa_file_perm+0x124/0x4f0
> > [207177.050071]  __mutex_lock_slowpath+0x13/0x20
> > [207177.050072]  mutex_lock+0x25/0x30
> > [207177.050075]  intel_vgpu_emulate_mmio_read+0x5d/0x3b0 [kvmgt]
>=20
> This isn't a KVM problem, it's a KVMGT problem (despite the name, KVMGT i=
s very
> much not KVM).
>=20
> > [207177.050084]  intel_vgpu_rw+0xb8/0x1c0 [kvmgt]
> > [207177.050091]  intel_vgpu_read+0x20d/0x250 [kvmgt]
> > [207177.050097]  vfio_device_fops_read+0x1f/0x40
> > [207177.050100]  vfs_read+0x9b/0x160
> > [207177.050102]  __x64_sys_pread64+0x93/0xd0
> > [207177.050104]  do_syscall_64+0x58/0x80
> > [207177.050106]  ? kvm_on_user_return+0x84/0xe0
> > [207177.050107]  ? fire_user_return_notifiers+0x37/0x70
> > [207177.050109]  ? exit_to_user_mode_prepare+0x41/0x200
> > [207177.050111]  ? syscall_exit_to_user_mode+0x1b/0x40
> > [207177.050112]  ? do_syscall_64+0x67/0x80
> > [207177.050114]  ? irqentry_exit+0x54/0x70
> > [207177.050115]  ? sysvec_call_function_single+0x4b/0xa0
> > [207177.050116]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > [207177.050118] RIP: 0033:0x7ff51131293f
> > [207177.050119] RSP: 002b:00007ff4ddffa260 EFLAGS: 00000293 ORIG_RAX:
> > 0000000000000011
> > [207177.050121] RAX: ffffffffffffffda RBX: 00005599a6835420 RCX:
> > 00007ff51131293f
> > [207177.050122] RDX: 0000000000000004 RSI: 00007ff4ddffa2a8 RDI:
> > 0000000000000027
> > [207177.050123] RBP: 0000000000000004 R08: 0000000000000000 R09:
> > 00000000ffffffff
> > [207177.050124] R10: 0000000000065f10 R11: 0000000000000293 R12:
> > 0000000000065f10
> > [207177.050124] R13: 00005599a6835330 R14: 0000000000000004 R15:
> > 0000000000065f10
> > [207177.050126]  </TASK>
> >=20
> >      I am seeing this on Intel i7-6700k, i7-6850k, and i7-9700k platfor=
ms.

One recent regression fix on Comet Lake is https://patchwork.freedesktop.or=
g/patch/496987/,
it's on the way to 6.0-rc and would be pushed to 5.19 stable as well. But l=
ooks this
report impacts on more platforms? We'll double check.

Thanks

> >=20
> >      This did not happen on 5.17 kernels, and 5.18 kernels never ran st=
able
> > enough on my platforms to actually run them for more than a few minutes.
> >=20
> >      Likewise 6.0-rc1 has not been stable enough to run in production. =
 After
> > less than three hours running on my workstation it locked hard with eve=
n the
> > magic sys-request key being unresponsive and only power cycling the mac=
hine got
> > it back.
> >=20
> >      The operating system in use for the host on all machines is Ubuntu=
 22.04.
> >=20
> >      Guests vary with Ubuntu 22.04 being the most common but also Mint,=
 Debian,
> > Manjaro, Centos, Fedora, ScientificLinux, Zorin, and Windows being in u=
se.
> >=20
> >      I see the same issue manifest on platforms running only Ubuntu gue=
sts as
> > with guests of varying operating systems. =20
> >=20
> >      The configuration file I used to compile this kernel is attached. =
 I
> > compiled it with gcc 12.1.0.
> >=20
> >      This behavior does not manifest itself instantly, typically the ma=
chine
> > needs to be running 3-7 days before it does.  Once it does guests keep =
stalling
> > and restarting libvirtd does not help.  Only thing that seems to is a h=
ard
> > reboot of the physical host.  For this reason I believe the issue lies =
strictly
> > with the host and not the guests.
> >=20
> >      I have listed it as a severity of high since it is completely serv=
ice
> > interrupting.
> >=20
> > --=20
> > You may reply to this email to add a comment.
> >=20
> > You are receiving this mail because:
> > You are watching the assignee of the bug.

--YGTp3YEHyFTiE1eD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCYwQPegAKCRCxBBozTXgY
JwVzAJ9AGCbs4pALTV0EbDPc7WMK/2Ig9gCaA86BaIuoLjxNrPIGDl/B97DXroQ=
=W/db
-----END PGP SIGNATURE-----

--YGTp3YEHyFTiE1eD--
