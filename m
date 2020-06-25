Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102A220A558
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 20:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406424AbgFYS7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 14:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406110AbgFYS7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 14:59:37 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6501C08C5C1
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 11:59:37 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id h22so3733040pjf.1
        for <kvm@vger.kernel.org>; Thu, 25 Jun 2020 11:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=+skzyi9owssWDUhMo0xhimNAAsiH87Uo9lhCD/vwgZ4=;
        b=gsKKeHIPLjL6Kax393QJDsd2aKrFe6r8naVKaN+LcrRAEJBhNc/SXmmqexMitCovzN
         uxREm7JchewyoCtavz9TCDiQGqWTvoFyMryXS+48DS13xgQQoTnoJQHCZeijEjfcaOC3
         6487kNPwjSbnhOTTULEcouJa0M1sFHMElVe8eBX+pjCigiqiGZmr+QjzutEmKKeWNoxj
         PzHJRA+dTKnyT5IEFOp3OdgFvdG1l2+g402ezhn0H93zeg+4WDEuKWJnUoRHAM6woWac
         bXZdPzZHoSLeydj41kJbh49ZRR7A/xLL1Zb1frdxrPxekB3QL/f7XQ5Qm0DECClehS84
         gHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=+skzyi9owssWDUhMo0xhimNAAsiH87Uo9lhCD/vwgZ4=;
        b=jyqgM8pH7wumXIouQ6NgxVUXKY+lw697h5/kkc1no4C4SyQt/h2Ty+XMLtYgkHCTkr
         oi4lpxDFNg4/+51ApzokS0jXo91dGgw28ed1nYHRo/TUyc19/ef0/qne8vpzlXpC4mUD
         KdApD1gd+6qsW3ECaFie6AH+/jy4pC0bnZ0o/5uJpw+YN6bNp7rmi9jdtjwv3/19maP5
         0FKpOv+Youcz8TMd/lC6QX0vwnXANedhqvrn64ek8QWh5Ytr20SJarCYbDD44ST94zsl
         JKUY6DT2yEJVfSyd/+oKRy0k1v5U37KpKMAo4o08/rbpKHDL9fwb3ab63HRKADF+l0Wu
         BjFg==
X-Gm-Message-State: AOAM531V2Me765bw37PbCxCfQl0slA14Eq5+tphekoseUqgWIE3GVBIU
        tBC6r0DyH2JTOnWh0PHsDuE=
X-Google-Smtp-Source: ABdhPJxOg/9DeRR/TyqsV6wbahHb0qZvmJTQSubepTsazY0TukIAizPfYpwiD5AdyLZCXZSAk326Kw==
X-Received: by 2002:a17:902:a9c5:: with SMTP id b5mr24857605plr.239.1593111576950;
        Thu, 25 Jun 2020 11:59:36 -0700 (PDT)
Received: from [10.0.1.10] (c-24-4-128-201.hsd1.ca.comcast.net. [24.4.128.201])
        by smtp.gmail.com with ESMTPSA id d7sm23745343pfh.78.2020.06.25.11.59.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jun 2020 11:59:35 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH kvm-unit-tests] x86: move IDT away from address 0
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200624165455.19266-1-pbonzini@redhat.com>
Date:   Thu, 25 Jun 2020 11:59:34 -0700
Cc:     kvm <kvm@vger.kernel.org>, mcondotta@redhat.com,
        Thomas Huth <thuth@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8926010E-3AC0-4707-B1E2-A8DF576660F9@gmail.com>
References: <20200624165455.19266-1-pbonzini@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 24, 2020, at 9:54 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> Address 0 is also used for the SIPI vector (which is probably =
something worth
> changing as well), and now that we call setup_idt very early the SIPI =
vector
> overwrites the first few bytes of the IDT, and in particular the #DE =
handler.
>=20
> Fix this for both 32-bit and 64-bit, even though the different form of =
the
> descriptors meant that only 32-bit showed a failure.
>=20
> Reported-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> x86/cstart.S   | 10 +++++++---
> x86/cstart64.S | 11 ++++++++++-
> 2 files changed, 17 insertions(+), 4 deletions(-)
>=20
> diff --git a/x86/cstart.S b/x86/cstart.S
> index 77dc34d..e93dbca 100644
> --- a/x86/cstart.S
> +++ b/x86/cstart.S
> @@ -4,8 +4,6 @@
> .globl boot_idt
> .global online_cpus
>=20
> -boot_idt =3D 0
> -

I think that there is a hidden assumption about the IDT location in
realmode=E2=80=99s test_int(), which this would break:

static void test_int(void)
{
        init_inregs(NULL);

        boot_idt[11] =3D 0x1000; /* Store a pointer to address 0x1000 in =
IDT entry 0x11 */
        *(u8 *)(0x1000) =3D 0xcf; /* 0x1000 contains an IRET instruction =
*/

        MK_INSN(int11, "int $0x11\n\t");

        exec_in_big_real_mode(&insn_int11);
        report("int 1", 0, 1);
}

