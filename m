Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3E120A56A
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 21:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404577AbgFYTEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 15:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403781AbgFYTEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 15:04:00 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E35FC08C5C1
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 12:04:00 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x8so2310301plm.10
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 12:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=E1c+PT1iEkl5alUsfcLe2/4Qaq/rGgEbjG+QmdbJjhw=;
        b=Nj6+0TaYctoW49eFbEEgcCGVpiAi2puHtFPE5Zm4QS9h3e5yeAOLs1TiFND+rcWU9q
         StMNI+po3ObyKVmwAax83lum43wX0Tw5z818tsvUcfc3OHhFeUKLtR6d3e/P2yKgU51Z
         Xhut56cO8UDFxCTcW9dr0TRAmzgzq2pKtFe9+CQhtclOOpsU/Lqq3b7vbPcYA/DRJh/C
         Yg0Yn23MZbxkN/DiGSVkTDgXXSI6kmcJVWLQ1rkcqDE7VqYMDXekhCz02VDdbaiQf5Tf
         Yl5n/xFKZWUG+RiDlS7MY+uJWBe/EBSK7rKMV6xoaHUnyPFxqHsZvhdd/DwEnhBZ6N4R
         M3Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=E1c+PT1iEkl5alUsfcLe2/4Qaq/rGgEbjG+QmdbJjhw=;
        b=S8x2S+5RPGzrOxCtGcrQkrfbwL2nloR6jvyBvVaFHuAY6V4UZxyO5maXIut7ltJ2FW
         7PTZJcVtO2WL1A+UpsrjJpE8+jXH1GjHxRtz1NtssR+C956b2jFRujDYxVViaRPnabj6
         pQwK4pjqYYn0zNYBZ4BEGQVc1ONGt0W39LHLCpiawM1ywoD1GM9XLNouCnXemWDrM60Q
         34hhyVamZW5rJTQAVKDil5G4VTbmx+CGLCWtpKH0Fk3N4yiEDsw7cL9/+/04wEpWz/tx
         55Y3qsoASpbC/X9LKllD2ja6SOjLrM/RBJN1q6nh73Z9PdQMCbKPeTT7lNPWY7A53HZb
         cMdA==
X-Gm-Message-State: AOAM532kwgKfGjR/Pcb2+Sn39gzN6PS9RSqA9H1XqbioEPv664+kssV9
        Q3X7iXQV0SbbaaS2tIrTYxw=
X-Google-Smtp-Source: ABdhPJyGB6yhVEgGRY5hiV3lJp2uocy9dEqOEQVcCjOm2XMRhsAACV0f1TeV4j8vKSHXqjyh8QE5yA==
X-Received: by 2002:a17:90a:e007:: with SMTP id u7mr4941123pjy.208.1593111839563;
        Thu, 25 Jun 2020 12:03:59 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:5ca0:c8b1:77cc:5741? ([2601:647:4700:9b2:5ca0:c8b1:77cc:5741])
        by smtp.gmail.com with ESMTPSA id 130sm23310365pfw.176.2020.06.25.12.03.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jun 2020 12:03:58 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH kvm-unit-tests] x86: move IDT away from address 0
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <8926010E-3AC0-4707-B1E2-A8DF576660F9@gmail.com>
Date:   Thu, 25 Jun 2020 12:03:57 -0700
Cc:     kvm <kvm@vger.kernel.org>, mcondotta@redhat.com,
        Thomas Huth <thuth@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0B89566F-796D-4146-87CE-CC73D6246CED@gmail.com>
References: <20200624165455.19266-1-pbonzini@redhat.com>
 <8926010E-3AC0-4707-B1E2-A8DF576660F9@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 25, 2020, at 11:59 AM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>> On Jun 24, 2020, at 9:54 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>>=20
>> Address 0 is also used for the SIPI vector (which is probably =
something worth
>> changing as well), and now that we call setup_idt very early the SIPI =
vector
>> overwrites the first few bytes of the IDT, and in particular the #DE =
handler.
>>=20
>> Fix this for both 32-bit and 64-bit, even though the different form =
of the
>> descriptors meant that only 32-bit showed a failure.
>>=20
>> Reported-by: Thomas Huth <thuth@redhat.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>> x86/cstart.S   | 10 +++++++---
>> x86/cstart64.S | 11 ++++++++++-
>> 2 files changed, 17 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/x86/cstart.S b/x86/cstart.S
>> index 77dc34d..e93dbca 100644
>> --- a/x86/cstart.S
>> +++ b/x86/cstart.S
>> @@ -4,8 +4,6 @@
>> .globl boot_idt
>> .global online_cpus
>>=20
>> -boot_idt =3D 0
>> -
>=20
> I think that there is a hidden assumption about the IDT location in
> realmode=E2=80=99s test_int(), which this would break.

[ Sorry for the previous wrong quote of my attempt the fix ]

The original offending code:

static void test_int(void)
{
        init_inregs(NULL);

        *(u32 *)(0x11 * 4) =3D 0x1000; /* Store a pointer to address =
0x1000 in IDT entry 0x11 */
        *(u8 *)(0x1000) =3D 0xcf; /* 0x1000 contains an IRET instruction =
*/

        MK_INSN(int11, "int $0x11\n\t");

        exec_in_big_real_mode(&insn_int11);
        report("int 1", 0, 1);
}

static void test_sti_inhibit(void)
{
        init_inregs(NULL);

        *(u32 *)(0x73 * 4) =3D 0x1000; /* Store IRQ 11 handler in the =
IDT */
        *(u8 *)(0x1000) =3D 0xcf; /* 0x1000 contains an IRET instruction =
*/

        MK_INSN(sti_inhibit, "cli\n\t"
                             "movw $0x200b, %dx\n\t"
                             "movl $1, %eax\n\t"
                             "outl %eax, %dx\n\t" /* Set IRQ11 */
                             "movl $0, %eax\n\t"
                             "outl %eax, %dx\n\t" /* Clear IRQ11 */
                             "sti\n\t"
                             "hlt\n\t");
        exec_in_big_real_mode(&insn_sti_inhibit);

        report("sti inhibit", ~0, 1);
}


