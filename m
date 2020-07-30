Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6E4233B80
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 00:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730406AbgG3WpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 18:45:18 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54032 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728588AbgG3WpR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 18:45:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596149115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=XnPkxsGGs9YoHo3katNXW8C+7SKWRLj30i0bY7uISx4=;
        b=Ij6iGutX7HLAnPaCoJwNoujh2sWdUSOGMfefjNGnJDmWH6QsE+z26lK77b+C2t1YYLtXZQ
        vaP+YnIxmLp0hznX8dy3CH0zv4v4OxgqIBxphF21JrtQOJ+kY1RU2rndYzkVlef3yl/bU6
        xdVmesw2nIItG2167u5qAj067OFL5gA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-wW_mlJM6OJejyPXL8GIqyw-1; Thu, 30 Jul 2020 18:45:13 -0400
X-MC-Unique: wW_mlJM6OJejyPXL8GIqyw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAA201DE0;
        Thu, 30 Jul 2020 22:45:11 +0000 (UTC)
Received: from [10.10.115.111] (ovpn-115-111.rdu2.redhat.com [10.10.115.111])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D17D5512FE;
        Thu, 30 Jul 2020 22:45:06 +0000 (UTC)
Subject: Re: WARNING: suspicious RCU usage - while installing a VM on a CPU
 listed under nohz_full
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
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
References: <ece36eb1-253a-8ec6-c183-309c10bb35d5@redhat.com>
 <CANRm+Cywhi1p5gYLfG=JcyTdYuWK+9bGqF6HD-LiBJM9Q5ykNQ@mail.gmail.com>
 <CANRm+CwrT=gxxgkNdT3wFwzWYYh3FFrUU=aTqH8VT=MraU7jkw@mail.gmail.com>
 <57ea501b-bf54-3fc0-4a8f-2820df623b14@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <8c99291a-adf5-d357-f916-e86b5a0100aa@redhat.com>
Date:   Thu, 30 Jul 2020 18:45:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <57ea501b-bf54-3fc0-4a8f-2820df623b14@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5YVdlSIv17ft256YZZqzv5CNNOpl3OQCc"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5YVdlSIv17ft256YZZqzv5CNNOpl3OQCc
Content-Type: multipart/mixed; boundary="P1nmfbal5o9A8mVhzK7pa2mTZXCLfS9vu"

--P1nmfbal5o9A8mVhzK7pa2mTZXCLfS9vu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 7/29/20 8:34 AM, Nitesh Narayan Lal wrote:
> On 7/28/20 10:38 PM, Wanpeng Li wrote:
>> Hi Nitesh=EF=BC=8C
>> On Wed, 29 Jul 2020 at 09:00, Wanpeng Li <kernellwp@gmail.com> wrote:
>>> On Tue, 28 Jul 2020 at 22:40, Nitesh Narayan Lal <nitesh@redhat.com> wr=
ote:
>>>> Hi,
>>>>
>>>> I have recently come across an RCU trace with the 5.8-rc7 kernel that =
has the
>>>> debug configs enabled while installing a VM on a CPU that is listed un=
der
>>>> nohz_full.
>>>>
>>>> Based on some of the initial debugging, my impression is that the issu=
e is
>>>> triggered because of the fastpath that is meant to optimize the writes=
 to x2APIC
>>>> ICR that eventually leads to a virtual IPI in fixed delivery mode, is =
getting
>>>> invoked from the quiescent state.
>> Could you try latest linux-next tree? I guess maybe some patches are
>> pending in linux-next tree, I can't reproduce against linux-next tree.
> Sure, I will try this today.

Hi Wanpeng,

I am not seeing the issue getting reproduced with the linux-next tree.
Although, I am still seeing a Warning stack trace:

[=C2=A0 139.220080] RIP: 0010:kvm_arch_vcpu_ioctl_run+0xb57/0x1320 [kvm]
[=C2=A0 139.226837] Code: e8 03 0f b6 04 18 84 c0 74 06 0f 8e 4a 03 00 00 4=
1 c6 85 48
31 00 00 00 e9 24 f8 ff ff 4c 89 ef e8 7e ac 02 00 e9 3d f8 ff ff <0f> 0b e=
9 f2
f8 ff ff 48f
[=C2=A0 139.247828] RSP: 0018:ffff8889bc397cb8 EFLAGS: 00010202
[=C2=A0 139.253700] RAX: 0000000000000001 RBX: dffffc0000000000 RCX: ffffff=
ffc1fc3bef
[=C2=A0 139.261695] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88=
8f0fa1a8a0
[=C2=A0 139.269692] RBP: ffff8889bc397d18 R08: ffffed113786a7d0 R09: ffffed=
113786a7d0
[=C2=A0 139.277686] R10: ffff8889bc353e7f R11: ffffed113786a7cf R12: ffff88=
89bc35423c
[=C2=A0 139.285682] R13: ffff8889bc353e40 R14: ffff8889bc353e6c R15: ffff88=
897f536000
[=C2=A0 139.293678] FS:=C2=A0 00007f3d8a71c700(0000) GS:ffff888a3c400000(00=
00)
knlGS:0000000000000000
[=C2=A0 139.302742] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[=C2=A0 139.309186] CR2: 0000000000000000 CR3: 00000009bc34c004 CR4: 000000=
00003726e0
[=C2=A0 139.317180] Call Trace:
[=C2=A0 139.320002]=C2=A0 kvm_vcpu_ioctl+0x3ee/0xb10 [kvm]
[=C2=A0 139.324907]=C2=A0 ? sched_clock+0x5/0x10
[=C2=A0 139.328875]=C2=A0 ? kvm_io_bus_get_dev+0x1c0/0x1c0 [kvm]
[=C2=A0 139.334375]=C2=A0 ? ioctl_file_clone+0x120/0x120
[=C2=A0 139.339079]=C2=A0 ? selinux_file_ioctl+0x98/0x570
[=C2=A0 139.343895]=C2=A0 ? selinux_file_mprotect+0x5b0/0x5b0
[=C2=A0 139.349088]=C2=A0 ? irq_matrix_assign+0x360/0x430
[=C2=A0 139.353904]=C2=A0 ? rcu_read_lock_sched_held+0xe0/0xe0
[=C2=A0 139.359201]=C2=A0 ? __fget_files+0x1f0/0x300
[=C2=A0 139.363532]=C2=A0 __x64_sys_ioctl+0x128/0x18e
[=C2=A0 139.367948]=C2=A0 do_syscall_64+0x33/0x40
[=C2=A0 139.371974]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
[=C2=A0 139.377643] RIP: 0033:0x7f3d98d0a88b

Are you also triggering anything like this in your environment?


>
--=20
Nitesh


--P1nmfbal5o9A8mVhzK7pa2mTZXCLfS9vu--

--5YVdlSIv17ft256YZZqzv5CNNOpl3OQCc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl8jTXEACgkQo4ZA3AYy
ozmiGQ//fkHHxJH+iTnevqVxvOMlDiRSfTx4c7y6W9oOZvLk636ge1vKvW6g0Sj6
4m6z1L995xIs2UYQSDsOOubvuCF+qj9VDTlu82UgjJiNnZGiuIWkpgcyZpS5vrKw
UyGfgDj/2qq2/ZDwF3QWdb/o5/z1vWJ7NPGt/th7qUx11bcBzPkO5Sq29szrjfkm
KBmrz5y7Qee97JAoPydGgTUhRAd2L0qbcFU57g5nr4ZN2MVa1ImF9xMUqplWCVtw
KAP7mWJk3fAMcHNZOYoEkr90lJpAuUz+2rYouIrmkt2/+rbOhsChMtUw/qZTEPgv
xU4X3SiXN5SbKNuH1Yb0/+672ZVnsoRdgsHk2Xf0EUYrRrWwuqawzLFt7hBibj+e
KGqCuM2KVe0FiH1dbeFCqncCcIQAXU5sjRwDExYgpHfVDO/uJ5KHwT75phRzc8/W
w0rfvsWc+KsERc0F/pCL5fTFbGybqT4r02MRGq5TFG64L9rlLPtatUeG+4kgm5au
f7mqudiRkY5GZzOIwgiAizdoSBHwRWeF1RNBzCUtKS9ZALAQJUPaGBkuQtbWszx7
4Cyc+T6JG9sY+03RElUXMmgeBkeZlI85B7ImJClOvrK5C1Qg49MsDLEQEC3vBsXE
zjzzTkcr+pNrvcxxE/2mj943JLFLuKvD0dcjMeJTOXemsOsUj14=
=wZpp
-----END PGP SIGNATURE-----

--5YVdlSIv17ft256YZZqzv5CNNOpl3OQCc--

