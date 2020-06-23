Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C516204769
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 04:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731744AbgFWCoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 22:44:22 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39377 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730456AbgFWCoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 22:44:21 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49rVwb07zfz9sRh;
        Tue, 23 Jun 2020 12:44:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1592880258;
        bh=TC3tqLIz+n4OEref9BzGDWrFGTvbjQ0IM7oHwGCme0k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TsxNejoisspUBFYOHzYQfMU8Mtf+1lfGcCdvRbN5fEOZtuBNONJLbvZVi4z+/2g8F
         Qm2vNnAkcpszF3ABMvyeJSVBsRJN9ecjVy9YnyUT8lnIBpVo2ytv/S89IvR824M0IN
         pxYY4H6WLPhHfyajoKrgh60uvDMvMFwnZIdl4s70XhelYvmgYfqBjuwh0dfi5euaLU
         /1XzOGi+03E6Y9kNIrqS2DvfbInsHX0tSM3R2GVpT9Lyub5LT4PTqDZK3Us11FZq60
         cNgDFhC1sszvaABWUegsKfdnEM4E5/JRMK65sHVS+EUQkPnYBRLPrZi4JMgw/j1GEv
         EJu+X4cEa+5Eg==
Date:   Tue, 23 Jun 2020 12:44:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     syzbot <syzbot+dbf8cf3717c8ef4a90a0@syzkaller.appspotmail.com>,
        bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org, elver@google.com
Subject: Re: linux-next build error (9)
Message-ID: <20200623124413.08b2bd65@canb.auug.org.au>
In-Reply-To: <20200622094923.GP576888@hirez.programming.kicks-ass.net>
References: <000000000000c25ce105a8a8fcd9@google.com>
        <20200622094923.GP576888@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/e.qnKUb/HtDM9BzQZV5zrSJ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/e.qnKUb/HtDM9BzQZV5zrSJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Mon, 22 Jun 2020 11:49:23 +0200 Peter Zijlstra <peterz@infradead.org> wr=
ote:
>
> On Mon, Jun 22, 2020 at 02:37:12AM -0700, syzbot wrote:
> > Hello,
> >=20
> > syzbot found the following crash on:
> >=20
> > HEAD commit:    27f11fea Add linux-next specific files for 20200622
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D138dc743100=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D41c659db5ca=
da6f4
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3Ddbf8cf3717c8e=
f4a90a0
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >=20
> > IMPORTANT: if you fix the bug, please add the following tag to the comm=
it:
> > Reported-by: syzbot+dbf8cf3717c8ef4a90a0@syzkaller.appspotmail.com
> >=20
> > ./arch/x86/include/asm/kvm_para.h:99:29: error: inlining failed in call=
 to always_inline 'kvm_handle_async_pf': function attribute mismatch
> > ./arch/x86/include/asm/processor.h:824:29: error: inlining failed in ca=
ll to always_inline 'prefetchw': function attribute mismatch
> > ./arch/x86/include/asm/current.h:13:44: error: inlining failed in call =
to always_inline 'get_current': function attribute mismatch
> > arch/x86/mm/fault.c:1353:1: error: inlining failed in call to always_in=
line 'handle_page_fault': function attribute mismatch
> > ./arch/x86/include/asm/processor.h:576:29: error: inlining failed in ca=
ll to always_inline 'native_swapgs': function attribute mismatch
> > ./arch/x86/include/asm/fsgsbase.h:33:38: error: inlining failed in call=
 to always_inline 'rdgsbase': function attribute mismatch
> > ./arch/x86/include/asm/irq_stack.h:40:29: error: inlining failed in cal=
l to always_inline 'run_on_irqstack_cond': function attribute mismatch
> > ./include/linux/debug_locks.h:15:28: error: inlining failed in call to =
always_inline '__debug_locks_off': function attribute mismatch
> > ./include/asm-generic/atomic-instrumented.h:70:1: error: inlining faile=
d in call to always_inline 'atomic_add_return': function attribute mismatch
> > kernel/locking/lockdep.c:396:29: error: inlining failed in call to alwa=
ys_inline 'lockdep_recursion_finish': function attribute mismatch
> > kernel/locking/lockdep.c:4725:5: error: inlining failed in call to alwa=
ys_inline '__lock_is_held': function attribute mismatch =20
>=20
> Hurmph, I though that was cured in GCC >=3D 8. Marco?

So what causes this? Because we got a couple of these in our s390 builds la=
st night as well.

kernel/locking/lockdep.c:805:1: error: inlining failed in call to always_in=
line 'look_up_lock_class': function attribute mismatch
include/linux/debug_locks.h:15:28: error: inlining failed in call to always=
_inline '__debug_locks_off': function attribute mismatch

s390-linux-gcc (GCC) 8.1.0 / GNU ld (GNU Binutils) 2.30

--=20
Cheers,
Stephen Rothwell

--Sig_/e.qnKUb/HtDM9BzQZV5zrSJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7xbH4ACgkQAVBC80lX
0Gz/HAf+OkoHJ0nxoaDWNvkmBAm4xhg1OB0dpRaoirjK5bk7n/fAbNs22/GQVAhs
Zkqxme/IAehOEAWIEWlHiYEu8HfTLwB1lWWEojg8sJeIVzUi6Z6ssC6H0W/+IwtE
ibSjUohWeekOrL7L9IPglcCOHPAtHNj4Zb2Vu1jj4v9FIHCQyD5asidXq1NFWOC8
y7mLd49o0/qKWKmB+MdnpvYVeZcyFNp+HKijXGhGYR2LU+S2n9jIAeDFVybYdrKQ
5A6rX6QyZ/0kqRP7n1oOlBSzwA8duHJklZmJWhULPGniLvoMKIA20R9h9DB/sYac
OD/20J1gXckXBf56UngA6pm3rMH2xA==
=RQtf
-----END PGP SIGNATURE-----

--Sig_/e.qnKUb/HtDM9BzQZV5zrSJ--
