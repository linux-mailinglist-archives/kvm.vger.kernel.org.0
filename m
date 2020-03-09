Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5887017EC9A
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 00:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbgCIXZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 19:25:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51656 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726275AbgCIXZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 19:25:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583796318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=Hfcvm2ZlOukJuswiiKJWZPmTd/9e9Orwpg5Kp0Nzshc=;
        b=NCL8tS43ALf0tuQO23tkuXl7RW4VOuKM8+cFdDtEcVUO1IhmQ6Nr4M1fz2LzyUa/Viosq6
        MmJUsFHVzquCFCTqYIuxW/i8lUsCoY+y8zIsq1f82ojhNc7X1/iUF7JE0o1lTnXbth/l+F
        bTziIpo2oMpxuP7OotQmEsxl+VTh/kE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-Ci7GLcamMEGkZwXoV6i15Q-1; Mon, 09 Mar 2020 19:25:15 -0400
X-MC-Unique: Ci7GLcamMEGkZwXoV6i15Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B36E107ACC4
        for <kvm@vger.kernel.org>; Mon,  9 Mar 2020 23:25:14 +0000 (UTC)
Received: from [10.10.124.102] (ovpn-124-102.rdu2.redhat.com [10.10.124.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E5ECB1001B0B;
        Mon,  9 Mar 2020 23:25:12 +0000 (UTC)
Subject: Re: [Patch v1] x86: Fix the logical destination mode test
To:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com,
        mtosatti@redhat.com, nilal@redhat.com
References: <1583795750-33197-1-git-send-email-nitesh@redhat.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <5dde9ad0-219a-4518-6099-bd493d1ff42e@redhat.com>
Date:   Mon, 9 Mar 2020 19:25:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1583795750-33197-1-git-send-email-nitesh@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/9/20 7:15 PM, Nitesh Narayan Lal wrote:
> There are following issues with the ioapic logical destination mode tes=
t:
>
> - A race condition that is triggered when the interrupt handler
> =C2=A0 ioapic_isr_86() is called at the same time by multiple vCPUs. Du=
e to this
>   the g_isr_86 is not correctly incremented. To prevent this a spinlock=
 is
>   added around =E2=80=98g_isr_86++=E2=80=99.
>
> - On older QEMU versions initial x2APIC ID is not set, that is why
> =C2=A0 the local APIC IDs of each vCPUs are not configured. Hence the l=
ogical
> =C2=A0 destination mode test fails/hangs. Adding =E2=80=98+x2apic=E2=80=
=99 to the qemu -cpu params
> =C2=A0 ensures that the local APICs are configured every time, irrespec=
tive of the
> =C2=A0 QEMU version.
>
> - With =E2=80=98-machine kernel_irqchip=3Dsplit=E2=80=99 included in th=
e ioapic test
> =C2=A0 test_ioapic_self_reconfigure() always fails and somehow leads to=
 a state where
> =C2=A0 after submitting IOAPIC fixed delivery - logical destination mod=
e request we
> =C2=A0 never receive an interrupt back. For now, the physical and logic=
al destination
> =C2=A0 mode tests are moved above test_ioapic_self_reconfigure().

The above were the reasons which were causing the ioapic logical destinat=
ion
mode test to fail/hang.

The previous discussion can be found at:
https://lore.kernel.org/kvm/20191205151610.19299-1-thuth@redhat.com/

Following is a test run with smp =3D 4 and -machine kernel_irqchip=3Dspli=
t.

[root@virtlab420 kvm-unit-tests]# git diff
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index d658bc8..348953b 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -46,7 +46,7 @@ timeout =3D 30
=C2=A0[ioapic]
=C2=A0file =3D ioapic.flat
=C2=A0smp =3D 4
-extra_params =3D -cpu qemu64,+x2apic
+extra_params =3D -cpu qemu64,+x2apic -machine kernel_irqchip=3Dsplit
=C2=A0arch =3D x86_64
=C2=A0
=C2=A0[cmpxchg8b]
[root@virtlab420 kvm-unit-tests]# ./tests/ioapic
BUILD_HEAD=3D83a3b429
timeout -k 1s --foreground 90s /usr/libexec/qemu-kvm -nodefaults -device
pc-testdev -device isa-debug-exit,iobase=3D0xf4,iosize=3D0x4 -vnc none -s=
erial stdio
-device pci-testdev -machine accel=3Dkvm -kernel /tmp/tmp.cS40xFvt0U -smp=
 4 -cpu
qemu64,+x2apic -machine kernel_irqchip=3Dsplit # -initrd /tmp/tmp.69rw56T=
ppH
enabling apic
enabling apic
enabling apic
enabling apic
paging enabled
cr0 =3D 80010011
cr3 =3D 61d000
cr4 =3D 20
x2apic enabled
PASS: version register read only test
PASS: id register only bits [24:27] writable
PASS: arbitration register set by id
PASS: arbtration register read only
PASS: edge triggered intr
PASS: level triggered intr
PASS: ioapic simultaneous edge interrupts
PASS: coalesce simultaneous level interrupts
PASS: sequential level interrupts
PASS: retriggered level interrupts without masking
PASS: masked level interrupt
PASS: unmasked level interrupt
PASS: masked level interrupt
PASS: unmasked level interrupt
PASS: retriggered level interrupts with mask
PASS: TMR for ioapic edge interrupts (expected false)
PASS: TMR for ioapic level interrupts (expected false)
PASS: TMR for ioapic level interrupts (expected true)
PASS: TMR for ioapic edge interrupts (expected true)
PASS: ioapic physical destination mode
PASS: ioapic logical destination mode
1012375 iterations before interrupt received
PASS: TMR for ioapic edge interrupts (expected false)
832021 iterations before interrupt received
PASS: TMR for ioapic level interrupts (expected false)
1009498 iterations before interrupt received
PASS: TMR for ioapic level interrupts (expected true)
994532 iterations before interrupt received
PASS: TMR for ioapic edge interrupts (expected true)
FAIL: Reconfigure self
SUMMARY: 26 tests, 1 unexpected failures
FAIL ioapic (26 tests, 1 unexpected failures)

Please let me know if there are any more suggestions/comments.

[...]

--=20
Nitesh

