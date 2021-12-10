Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBC0470CC1
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 22:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344549AbhLJV5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 16:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344539AbhLJV5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 16:57:16 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B09C061746;
        Fri, 10 Dec 2021 13:53:41 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639173218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=FS3wlVwOwRWAaINXlttn8DXkX1i9/TPWcXiWxrUtLVE=;
        b=IFSH1FPIZNHmd3CIkzNDQpS8V9+63fcLmE5bnXludIlnCnSHeKDwJd4RlmlVumciL/EYN7
        medkWpZWPI5hGJg4s9Q73IYz8G8Dgn4FmgfYZBSElZ1efxMHXKSJOpDJwJT8u5vDXZK7Oo
        dXLbwsPU968cCKl12jZaqTl9oZ+oh5ut9CeGA3Vs2C3kqpoDxIkAVHQWCxVib17/xmMaec
        /bOSRzS1a3Rl2QbE2YW/JXjtCpppTaG62OwKyfsXdvZkMXGXctRSGgsEpEkl6iCSEBhIPk
        Xti26BLhLtkRudFDuVI4zMvBO+E1XwDjE7KSqUOjrkR4WLUz2UcU++BqxrmOnA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639173218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=FS3wlVwOwRWAaINXlttn8DXkX1i9/TPWcXiWxrUtLVE=;
        b=6xSO9NCtT6zRNacDqmnS9biTnTT4yvev+awkHt6pGEmWPiazTh2Ergs15MNj+UmyRf/lTJ
        frHeA2ijSviyNaBA==
To:     "Nakajima, Jun" <jun.nakajima@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: Re: Rewording of Setting IA32_XFD[18] (Re: Thoughts of AMX KVM
 support based on latest kernel)
In-Reply-To: <9F8F8297-E70F-427C-BEDA-9FAB86877DBD@intel.com>
Date:   Fri, 10 Dec 2021 22:53:37 +0100
Message-ID: <87bl1oxh26.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jun,

On Wed, Dec 08 2021 at 00:50, Jun Nakajima wrote:
>> On Nov 19, 2021, at 7:41 AM, Nakajima, Jun <jun.nakajima@intel.com> wrot=
e:
>> I=E2=80=99ll work with the H/W team on those (i.e. rewording and the com=
ponent 17 issue).
>>=20
>
> The following is a possible documentation update that may convey the
> rewording you requested.  Does this (the last sentence, =E2=80=9CIn addit=
ion,
> =E2=80=9C) work for you?
>
> 3.3 RECOMMENDATIONS FOR SYSTEM SOFTWARE
>
> System software may disable use of Intel AMX by clearing XCR0[18:17],
> by clearing CR4.OSXSAVE, or by setting IA32_XFD[18]. System software
> should initialize AMX state (e.g., by executing TILERELEASE) when
> doing so because maintaining AMX state in a non-initialized state may
> have negative power and performance implications. In addition,
> software should not rely on the state of the tile data after setting
> IA32_XFD[18]; software should always reload or reinitialize the tile
> data after clearing IA32_XFD[18].

looks good to me.

Thanks,

        tglx

