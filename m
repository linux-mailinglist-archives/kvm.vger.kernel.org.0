Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEE90112737
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 10:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfLDJ0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 04:26:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29561 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726166AbfLDJ0U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 04:26:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575451577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jUuRDdnXhCHO/NEUeUPUPsA/97IPezLMrW4ezc6k+9o=;
        b=F0VqG86d6hC25MHkU8xeDfYTqLYHi6/G5XdjBhE3CwrkqsvBlY4r5pQWwM/3liMxtmx34w
        KTEciGAP1u5uxB+KXR7jBfp6Au1vZQtAJKvBRKQfghpatpZ2vdTOel89TYEEsKhvAE8lW3
        VTQooINClEHeOW0BfYpGRVbEjqfs/bI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-l4Tj670KNhyTTrwqbxR2WA-1; Wed, 04 Dec 2019 04:26:16 -0500
Received: by mail-wr1-f70.google.com with SMTP id u18so3344170wrn.11
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 01:26:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MT4/tfwIPaDsN4vYfFd3gEaF9rrqRXt+8txO4zjJd9o=;
        b=nJoIwkLpsJqwkDKmAZ3uJfcQobfmKowmPDrEmHp5iGVJUevOBMeBj84Vs5FvH0e8Rn
         j5isD0Xg5qdrs44FkVqGLhTiBtoXsbFZK1q9fOnLFV6Rv4+MIlN1+PIRWwIbRWlW1aML
         uabY2156bQhpjl1NKg3h8m71gJa8bL5VKVWMyb88nhzXh0jb10SaubkZu9Dg6s4fz1cZ
         KKJqCOsFcJn1qpqPkeQ2sXVjncHD4EKZXtacxLGOarxg2qaTRD/lGe/q9VP/KoMtMQ/X
         66EIxTzo6cAV5YX8yv6O3+yTHSLilEXHdOl+w1eQGgZRGZ7jzMAwdIjkGiD1K7LyC0cm
         Jhdg==
X-Gm-Message-State: APjAAAWv+kNULPY6IO6Ary1OH8xVfZ6MNCXoz1fSvbCW7U2jZS+WSLPE
        N1E3pLPLtgNph1RbC6MV2uEW/FEBLPLVsndDEdkWde4lBNu7YFheyX7qg8V1/5f56ZyDEOMztmP
        THhQMENcksKcf
X-Received: by 2002:a7b:cb46:: with SMTP id v6mr22387011wmj.117.1575451575073;
        Wed, 04 Dec 2019 01:26:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqwRVLIPHq0X1w4SmiKY1LeXp4vxUB8NUYGDePnpKQOfdTm3CXhxIEkco+pRZHHgug5mizjUqg==
X-Received: by 2002:a7b:cb46:: with SMTP id v6mr22386980wmj.117.1575451574780;
        Wed, 04 Dec 2019 01:26:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id b17sm7145776wrp.49.2019.12.04.01.26.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 01:26:14 -0800 (PST)
Subject: Re: KASAN: vmalloc-out-of-bounds Write in kvm_dev_ioctl_get_cpuid
To:     syzbot <syzbot+e3f4897236c4eeb8af4f@syzkaller.appspotmail.com>,
        bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
References: <000000000000ea5ec20598d90e50@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <77d993a5-5d41-14d1-e51d-52e092c84c42@redhat.com>
Date:   Wed, 4 Dec 2019 10:26:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <000000000000ea5ec20598d90e50@google.com>
Content-Language: en-US
X-MC-Unique: l4Tj670KNhyTTrwqbxR2WA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/12/19 05:15, syzbot wrote:
> Hello,
>=20
> syzbot found the following crash on:
>=20
> HEAD commit:=C2=A0=C2=A0=C2=A0 596cf45c Merge branch 'akpm' (patches from=
 Andrew)
> git tree:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D103acb7ae0000=
0
> kernel config:=C2=A0 https://syzkaller.appspot.com/x/.config?x=3D8eb54eee=
6e6ca4a7
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=3De3f4897236c4eeb8af4f
> compiler:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gcc (GCC) 9.0.0 20181231 (e=
xperimental)
> syz repro:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 https://syzkaller.appspot.com/x/=
repro.syz?x=3D15b87c82e00000
> C reproducer:=C2=A0=C2=A0 https://syzkaller.appspot.com/x/repro.c?x=3D112=
50f36e00000
>=20
> IMPORTANT: if you fix the bug, please add the following tag to the commit=
:
> Reported-by: syzbot+e3f4897236c4eeb8af4f@syzkaller.appspotmail.com
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: vmalloc-out-of-bounds in __do_cpuid_func_emulated
> arch/x86/kvm/cpuid.c:323 [inline]
> BUG: KASAN: vmalloc-out-of-bounds in do_cpuid_func
> arch/x86/kvm/cpuid.c:814 [inline]
> BUG: KASAN: vmalloc-out-of-bounds in do_cpuid_func
> arch/x86/kvm/cpuid.c:810 [inline]
> BUG: KASAN: vmalloc-out-of-bounds in kvm_dev_ioctl_get_cpuid+0xad7/0xb0b
> arch/x86/kvm/cpuid.c:891
> Write of size 4 at addr ffffc90000d36050 by task syz-executor490/9767
>=20
> CPU: 1 PID: 9767 Comm: syz-executor490 Not tainted 5.4.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
> =C2=A0__dump_stack lib/dump_stack.c:77 [inline]
> =C2=A0dump_stack+0x197/0x210 lib/dump_stack.c:118
> =C2=A0print_address_description.constprop.0.cold+0x5/0x30b mm/kasan/repor=
t.c:374
> =C2=A0__kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
> =C2=A0kasan_report+0x12/0x20 mm/kasan/common.c:638
> =C2=A0__asan_report_store4_noabort+0x17/0x20 mm/kasan/generic_report.c:13=
9
> =C2=A0__do_cpuid_func_emulated arch/x86/kvm/cpuid.c:323 [inline]
> =C2=A0do_cpuid_func arch/x86/kvm/cpuid.c:814 [inline]
> =C2=A0do_cpuid_func arch/x86/kvm/cpuid.c:810 [inline]
> =C2=A0kvm_dev_ioctl_get_cpuid+0xad7/0xb0b arch/x86/kvm/cpuid.c:891
> =C2=A0kvm_arch_dev_ioctl+0x300/0x4b0 arch/x86/kvm/x86.c:3387
> =C2=A0kvm_dev_ioctl+0x127/0x17d0 arch/x86/kvm/../../../virt/kvm/kvm_main.=
c:3593
> =C2=A0vfs_ioctl fs/ioctl.c:47 [inline]
> =C2=A0file_ioctl fs/ioctl.c:539 [inline]
> =C2=A0do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:726
> =C2=A0ksys_ioctl+0xab/0xd0 fs/ioctl.c:743
> =C2=A0__do_sys_ioctl fs/ioctl.c:750 [inline]
> =C2=A0__se_sys_ioctl fs/ioctl.c:748 [inline]
> =C2=A0__x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:748
> =C2=A0do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
> =C2=A0entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x440159
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89
> f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
> f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffd106332c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440159
> RDX: 0000000020000080 RSI: 00000000c008ae09 RDI: 0000000000000003
> RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004019e0
> R13: 0000000000401a70 R14: 0000000000000000 R15: 0000000000000000
>=20
>=20
> Memory state around the buggy address:
> =C2=A0ffffc90000d35f00: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9
> =C2=A0ffffc90000d35f80: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9
>> ffffc90000d36000: 00 00 00 00 00 00 00 00 00 00 f9 f9 f9 f9 f9 f9
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
> =C2=A0ffffc90000d36080: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9
> =C2=A0ffffc90000d36100: f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9 f9
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>=20
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>=20

Ouch, this is bad.  Sending a patch now.

Paolo

