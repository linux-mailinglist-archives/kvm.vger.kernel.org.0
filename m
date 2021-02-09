Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B68314EFA
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 13:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBIMfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 07:35:12 -0500
Received: from mail-40140.protonmail.ch ([185.70.40.140]:10252 "EHLO
        mail-40140.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhBIMfL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 07:35:11 -0500
Date:   Tue, 09 Feb 2021 12:34:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=protonmail; t=1612874068;
        bh=yEcvRrsspIqbqlpAa+0JXJhrUIT4HVaCwFcBxOILxQY=;
        h=Date:To:From:Reply-To:Subject:From;
        b=vY8YbRsV+56U+Zw9FY8puothkxtGCdbYAholv0rLZ+naGRIY4/7ACN7d3bilRX4Mz
         x2gMA7bbIPpIsDbZQlkdM1NLqQZPYKzbWXKgiwk02gCTnDgrW9zO+TBlJKZPp36f51
         OQus0r6tNOFEUt3c4CzmqIfC3mUY064ZYg/YtbgY=
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
From:   dashdruid <dashdruid@protonmail.ch>
Reply-To: dashdruid <dashdruid@protonmail.ch>
Subject: Older Linux 2.6 VM freezes randomly in KVM
Message-ID: <7X0x3mMP-GgKMD-kLgrTDJJydoxyP-Wc900Yszjiz5jAX7RZkwcIpiI6tD828LSp_hJFP-Krjxkut3Vlqk66MFrd1LvCnd1QkWEN-iRIjys=@protonmail.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello List,

I have the following host server:

Debian Wheezy 3.2.0-4-amd64

ii=C2=A0 pve-qemu-kvm=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 2.2-28=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 amd64=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Full virtualization on x86 hardware
rc=C2=A0 qemu-kvm=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.1.2+dfsg-6+deb7u19=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 amd64=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Full virtualizati=
on on x86 hardware

Running a Debian 5 guest with 2.6.26-2-amd64 kernel.

The VM freezes randomly (once, twice in a month). There is no indication ne=
ither on the host or guest console or logs why is it happening. The machine=
 is running a lot of other BSD and Windows VMs, only this has a problem. Wh=
en it freezes I can still connect to the console with VNC but I will not be=
 able to login or type anything and it is unreachable from the network.
Did anyone run into something similar? I don't want to upgrade neither the =
host nor the guest because besides this they are doing their job just fine.

This is also the oldest legacy VM there so I assume this is something relat=
ed to the 2.6 kernels scheduler, maybe it does not get some resources or in=
terrupts what it should and don't know what to do from that point but as I =
said there is no kernel crash or anything like that the VM just hangs.

Any ideas?

Thanks

Sent with ProtonMail Secure Email.
