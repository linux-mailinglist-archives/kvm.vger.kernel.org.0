Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314F2207C75
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 21:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391346AbgFXT6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 15:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391221AbgFXT6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jun 2020 15:58:05 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEC4C061573
        for <kvm@vger.kernel.org>; Wed, 24 Jun 2020 12:58:04 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l63so1923130pge.12
        for <kvm@vger.kernel.org>; Wed, 24 Jun 2020 12:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PgaMmtpkGqbKR3M2m9sNn9S1kNExQoTttRDdPiXcHjE=;
        b=UvskA3kJnR8QThcPBryiiZ0cw5pKXulcRMtV8OcGy7ZkwEly7sgHMCviw5apgnTvQO
         L/9GXbukdXgEQoND+1z/LUNcq6tezlXVOq934Vlq2VCDz4gW7IgmgrnJ22XIX+1E6kWE
         vDpI069xxtXMzX8O7mMWdyl+qVAHndsv0LseoxQxxJj6+yifA8GPQuSjTBGnQLYx/nwO
         x9bh7TZ2CP3E1e5Dq/RkFLlAEBdOPo1AWUVnwPlp9mHkESsig337MBcSdzGTHtVQyWVo
         NX4RLzqxEn2Nz/zFVworE5pfRF52nARrK2mrr+tk+d4oGf2U5M00tKkreQiX7QAMBT8X
         pKPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PgaMmtpkGqbKR3M2m9sNn9S1kNExQoTttRDdPiXcHjE=;
        b=hdrc4Gi4W3JkBuVIV8b/wjyOYlZNAIaFg8ICk1ZuYuNtspQh698oQt5/B0p7hNgSD3
         YUUq4Y/YGUbrG9t9/eQrPp4kfHAY9b8DWIDm5uUCTt1RdwbNF8mwE7sJFGsKdq/WmlX7
         eTPIChMtktIbl4LNOrtVB5nV12oA6LbKVU0Cx9GMdpsA8HVSM00HakUF4htQ4Qe+YoEV
         o5dbfJIlIPf+v//20xe94r394kOSpPkaGYDLaIioychpsSure4CnQLb/OpRSUmXO3r1T
         VzdpOyfjO86NBOrfK8B0r+n43kv1OBAyhzVaAO7URQvv7r/lA2ZWq4TMC0x9np7MhR9g
         Upsg==
X-Gm-Message-State: AOAM531/es2aYVfU1T9TxopFG6Hq14rpblkNFLf5wjpQmLxdWpwTTD8h
        vB7i6FxDIwv2GKxGXDxNv38=
X-Google-Smtp-Source: ABdhPJxloAYR9INUD1r7rwSzT5xHPmPpMeAc8Gwg4y72gwIEzlCjBdGcm2ibkCeOo6KM/G3bugh02w==
X-Received: by 2002:a63:924b:: with SMTP id s11mr22569206pgn.74.1593028684064;
        Wed, 24 Jun 2020 12:58:04 -0700 (PDT)
Received: from [10.0.1.10] (c-24-4-128-201.hsd1.ca.comcast.net. [24.4.128.201])
        by smtp.gmail.com with ESMTPSA id f23sm5895593pja.8.2020.06.24.12.58.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jun 2020 12:58:02 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH kvm-unit-tests] i386: setup segment registers before
 percpu areas
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200624141429.382157-1-pbonzini@redhat.com>
Date:   Wed, 24 Jun 2020 12:58:01 -0700
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A954DB27-C5E8-435B-A1D7-76D21943F70F@gmail.com>
References: <20200624141429.382157-1-pbonzini@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 24, 2020, at 7:14 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> The base of the percpu area is stored in the %gs base, and writing
> to %gs destroys it.  Move setup_segments earlier, before the %gs
> base is written.
>=20
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> x86/cstart.S | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/x86/cstart.S b/x86/cstart.S
> index 5ad70b5..77dc34d 100644
> --- a/x86/cstart.S
> +++ b/x86/cstart.S
> @@ -106,6 +106,7 @@ MSR_GS_BASE =3D 0xc0000101
> .globl start
> start:
>         mov $stacktop, %esp
> +        setup_segments
>         push %ebx
>         call setup_multiboot
>         call setup_libcflat
> @@ -118,7 +119,6 @@ start:
>=20
> prepare_32:
>         lgdtl gdt32_descr
> -	setup_segments
>=20
> 	mov %cr4, %eax
> 	bts $4, %eax  // pse
> =E2=80=94=20
> 2.26.2

As I said in a different thread, this change breaks my setup. It is =
better
not to make any assumption (or as few as possible) about the GDT content
after boot and load the GDTR before setting up the segments. So I prefer =
to
load the GDT before the segments. How about this change instead of =
yours?

-- >8 --

From: Nadav Amit <namit@vmware.com>
Date: Wed, 24 Jun 2020 19:50:36 +0000
Subject: [PATCH] x86: load gdt while loading segments

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/cstart.S | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/x86/cstart.S b/x86/cstart.S
index dd33d4d..1d8b8ac 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -95,6 +95,8 @@ MSR_GS_BASE =3D 0xc0000101
 .endm
=20
 .macro setup_segments
+	lgdtl gdt32_descr
+
 	mov $0x10, %ax
 	mov %ax, %ds
 	mov %ax, %es
@@ -106,6 +108,8 @@ MSR_GS_BASE =3D 0xc0000101
 .globl start
 start:
         mov $stacktop, %esp
+	setup_segments
+
         push %ebx
         call setup_multiboot
         call setup_libcflat
@@ -117,9 +121,6 @@ start:
         jmpl $8, $start32
=20
 prepare_32:
-        lgdtl gdt32_descr
-	setup_segments
-
 	mov %cr4, %eax
 	bts $4, %eax  // pse
 	mov %eax, %cr4
--=20


