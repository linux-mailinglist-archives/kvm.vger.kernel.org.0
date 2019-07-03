Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D69285DDE8
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 08:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfGCGJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 02:09:06 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39610 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfGCGJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 02:09:06 -0400
Received: by mail-pl1-f193.google.com with SMTP id b7so618408pls.6
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 23:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hET2ewOBHrzHyfX805NKjdfdW7LjNdQBKJAT8QkZeFk=;
        b=owaWrnuFuvqbAcnqFbCJJBdyhxm/mLGJ6H9UGr4e8bN8lzPlpTnlJNB/9ot3qH0MbQ
         stklO5Ea+OoG4tZcu+qg5c6ivrbyyxbU5kMauTw6TzYro1MxdjSsNKjdg9z19fYghHEF
         5l8dvUy1u93s5e7+g70no3KAT5Oi5IeaAoes9CPo1SFrUbFKGJzXLI5aod5Nfa4ryyC9
         Hyo0Y4Ev2Ecl+U05+pvD9KP3b4cOGe2bo8PGZEi+YA84G9tS/VNfy7Ud2E6scH0R+Cj8
         9nnrOuL0SvIrVBOtcM1XaBbY6milPcGMxmDKsrrVaHj7apk+4r8XOjMNU9CNHp7Jmuns
         HejQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hET2ewOBHrzHyfX805NKjdfdW7LjNdQBKJAT8QkZeFk=;
        b=j7B3vmSDz/EOnxUZ3Z19HEQ50WU6sGQKFp2q7R5RmLEIbLD0E3dkiJvAo3gXjiXS90
         XlC/YWnB+sHIH0eoX0Tn4VpSga6rjqnNfIun9XG87HSta4lLLKI0DCSverKM1gU3CuRo
         WHDLs3GMkw6N+hd68/qt9n/kmMt/7u0/jqinYARNiDGs/7vRnZfjz1//V1A3yuA5IY0B
         x38rzy0GbIB65s0BEG6vx0MUdPaWJPQ6gS10Vph4ES3Q6fyNdPCBqvBT+q5yxLvc3x49
         I71GpXsSr1In1wo0kGMGMrTvAtlDB+mu9LeNqMdy7jTDXYQXyvaqeYSSgUCHEcjlfDce
         Bl1g==
X-Gm-Message-State: APjAAAV6cMgxy8qDGfP+l98aXr7/UfLNZKTE+kEEBX5662CqCcPNGWeG
        9N8e2axicqm9rveLUGJ+EWY=
X-Google-Smtp-Source: APXvYqx/cbboog08YmgxxfRBRM9lQC2gcs3EmK1I5FBaTiGkO9IoBpAGx28oo/xrHeL6tyfsX4qXPA==
X-Received: by 2002:a17:902:9a84:: with SMTP id w4mr39263402plp.160.1562134144925;
        Tue, 02 Jul 2019 23:09:04 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id f2sm895934pgs.83.2019.07.02.23.09.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 23:09:03 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Support environments without
 test-devices
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <6bb2a5da-9528-cea9-300a-05d328077201@redhat.com>
Date:   Tue, 2 Jul 2019 23:09:02 -0700
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <567EEA72-611A-444D-9AA5-8218949235E4@gmail.com>
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-4-nadav.amit@gmail.com>
 <2e359eb2-4b2a-0a52-6c43-cd6037bb72ae@redhat.com>
 <F3480C92-28D8-470A-9E34-E87ECCE4FDD1@gmail.com>
 <73f56921-cb61-92fa-018a-5673e721dbef@redhat.com>
 <39BF29A2-D14B-4AC7-AE19-66EA8C136D98@gmail.com>
 <5a31871b-4010-dd01-9be6-944916753195@redhat.com>
 <954DC323-15B7-4B35-9249-AB03C9D01BB5@gmail.com>
 <6bb2a5da-9528-cea9-300a-05d328077201@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 2, 2019, at 10:39 PM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 03/07/19 01:39, Nadav Amit wrote:
>>> On Jul 2, 2019, at 11:28 AM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>>>=20
>>> On 02/07/19 19:45, Nadav Amit wrote:
>>>>>> I know you are not =E2=80=9Cserious=E2=80=9D, but I=E2=80=99ll =
use this opportunity for a small
>>>>>> clarification. You do need to provide the real number of CPUs as =
otherwise
>>>>>> things will fail. I do not use cpuid, as my machine, for example =
has two
>>>>>> sockets. Decoding the ACPI tables is the right way, but I was too =
lazy to
>>>>>> implement it.
>>>>> What about the mptables, too?
>>>> If you mean to reuse mptable.c from [1] or [2] - I can give it a =
shot. I am
>>>> not about to write my own parser.
>>>=20
>>> Sure.
>>=20
>> So mptable logic works on a couple of my machines, but not all.
>=20
> Can you send the patch anyway?  I can use it as a start for writing a
> MADT parser.

Sure, it could have used some more work=E2=80=A6 The original code is =
surprisingly
ugly. Sorry for not doing it myself - but believe me when I tell you =
that
enabling KVM to run on bare-metal is a misery which already took =
substantial
of time.

If only I had an ITP things could have been so much easier...

Anyhow, here is the code - it does not really use the number of CPUs, =
but
just shows it.

-- >8 --

Subject: [PATCH] x86: mptables parsing

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/x86/mptable.c   | 220 ++++++++++++++++++++++++++++++++++++++++++++
 lib/x86/mptable.h   |   6 ++
 x86/Makefile.common |   1 +
 x86/cstart64.S      |   1 +
 4 files changed, 228 insertions(+)
 create mode 100644 lib/x86/mptable.c
 create mode 100644 lib/x86/mptable.h

diff --git a/lib/x86/mptable.c b/lib/x86/mptable.c
new file mode 100644
index 0000000..52ae5cd
--- /dev/null
+++ b/lib/x86/mptable.c
@@ -0,0 +1,220 @@
+/*
+ * Copyright (c) 1996, by Steve Passe
+ * All rights reserved.
+ *
+ * hacked to make it work in userspace Linux by Ingo Molnar, same =
copyright
+ * Re-hacked to make suitable for KVM-unit-tests by Nadav Amit
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *	notice, this list of conditions and the following disclaimer.
+ * 2. The name of the developer may NOT be used to endorse or promote =
products
+ *	derived from this software without specific prior written =
permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' =
AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, =
THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR =
PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE =
LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR =
CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE =
GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS =
INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, =
STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN =
ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY =
OF
+ * SUCH DAMAGE.
+ */
+
+#include "libcflat.h"
+#include "mptable.h"
+
+/* EBDA is @ 40:0e in real-mode terms */
+#define EBDA_POINTER			0x040e		  /* location of =
EBDA pointer */
+
+/* CMOS 'top of mem' is @ 40:13 in real-mode terms */
+#define TOPOFMEM_POINTER		0x0413		  /* BIOS: base =
memory size */
+
+#define DEFAULT_TOPOFMEM		0xa0000
+
+#define BIOS_BASE			0xf0000
+#define BIOS_BASE2			0xe0000
+#define BIOS_SIZE			0x10000
+
+#define GROPE_AREA1			0x80000
+#define GROPE_AREA2			0x90000
+#define GROPE_SIZE			0x10000
+
+#define PROCENTRY_FLAG_EN	0x01
+#define PROCENTRY_FLAG_BP	0x02
+
+/* MP Floating Pointer Structure */
+struct mpfps {
+	char		signature[4];
+	uint32_t	pap;
+	uint8_t		length;
+	uint8_t		spec_rev;
+	uint8_t		checksum;
+	uint8_t		mpfb1;
+	uint8_t		mpfb2;
+	uint8_t		mpfb3;
+	uint8_t		mpfb4;
+	uint8_t		mpfb5;
+} __attribute__((packed));
+
+struct proc_entry {
+	uint8_t		type;
+	uint8_t		apicID;
+	uint8_t		apicVersion;
+	uint8_t		cpuFlags;
+	uint32_t	cpuSignature;
+	uint32_t	featureFlags;
+	uint32_t	reserved1;
+	uint32_t	reserved2;
+} __attribute__((packed));
+
+/* MP Configuration Table Header */
+struct mpcth {
+	char		signature[4];
+	uint16_t	base_table_length;
+	uint8_t		spec_rev;
+	uint8_t		checksum;
+	uint8_t		oem_id[8];
+	uint8_t		product_id[12];
+	uint32_t	oem_table_pointer;
+	uint16_t	oem_table_size;
+	uint16_t	entry_count;
+	uint32_t	apic_address;
+	uint16_t	extended_table_length;
+	uint8_t		extended_table_checksum;
+	uint8_t		reserved;
+	struct proc_entry entries[0];
+} __attribute__((packed));
+
+static void read_proc_entry(struct proc_entry *entry)
+{
+	int t, family, model;
+
+	printf("#\t%2d", (int) entry->apicID);
+	printf("\t 0x%2x", (unsigned int) entry->apicVersion);
+
+	printf("\t %s, %s",
+		(entry->cpuFlags & PROCENTRY_FLAG_BP) ? "BSP" : "AP",
+		(entry->cpuFlags & PROCENTRY_FLAG_EN) ? "usable" : =
"unusable");
+
+	t =3D (int) entry->cpuSignature;
+	family =3D (t >> 8) & 0xf;
+	model =3D (t >> 4) & 0xf;
+	if (family =3D=3D 0xf) {
+		family +=3D (t >> 20) & 0xff;
+		model +=3D (t >> 12) & 0xf0;
+	}
+
+	printf("\t %d\t %d\t %d", family, model, t & 0xf);
+	printf("\t 0x%04x\n", entry->featureFlags);
+}
+
+static int mp_config_table_header(uint32_t pap)
+{
+	struct mpcth *cth =3D (struct mpcth *)(unsigned long)pap;
+	int c;
+
+	if (!cth) {
+		printf("MP Configuration Table Header MISSING!\n");
+		return 1;
+	}
+
+	/* process all the CPUs */
+	printf("MP Table:\n#\tAPIC =
ID\tVersion\tState\t\tFamily\tModel\tStep\tFlags\n");
+	for (c =3D 0; c < cth->entry_count && cth->entries[c].type =3D=3D =
0; c++)
+		read_proc_entry(&cth->entries[c]);
+
+	printf("\n");
+
+	return c;
+}
+
+static struct mpfps *find_signature(unsigned long addr, unsigned int =
size)
+{
+	struct mpfps *mpfps =3D (struct mpfps *)addr;
+	const char MP_SIG[]=3D"_MP_";
+	unsigned int i;
+
+	for (i =3D 0; i < size / sizeof(mpfps); i++) {
+		if (!strncmp(mpfps[i].signature, MP_SIG, 4))
+			return &mpfps[i];
+	}
+	return NULL;
+}
+
+struct mem_location {
+	unsigned long addr;
+	unsigned long size;
+};
+
+const struct mem_location acpi_locations[] =3D {
+	{ DEFAULT_TOPOFMEM - 1024, 1024 },
+	{ BIOS_BASE, BIOS_SIZE },
+	{ BIOS_BASE2, BIOS_SIZE },
+	{ GROPE_AREA1, GROPE_SIZE },
+	{ GROPE_AREA2, GROPE_SIZE },
+	{ 0, 0 }
+};
+
+static struct mpfps *apic_probe(void)
+{
+	const struct mem_location *loc =3D acpi_locations;
+	uint16_t segment;
+	unsigned long target;
+	struct mpfps *mpfps;
+
+	/* search Extended Bios Data Area, if present */
+	segment =3D *(uint16_t *)EBDA_POINTER;
+
+	if (segment =3D=3D 0)
+		return NULL;
+
+	printf("\nEBDA points to: %x\n", segment);
+
+	target =3D (unsigned long)segment << 4;
+	printf("EBDA segment ptr: %lx\n", target);
+
+	mpfps =3D find_signature(target, 1024);
+	if (mpfps)
+		return mpfps;
+
+	/* read CMOS for real top of mem */
+	segment =3D *(uint16_t *)TOPOFMEM_POINTER;
+	--segment;				/* less ONE_KBYTE */
+	target =3D segment * 1024;
+
+	mpfps =3D find_signature(target, 1024);
+	if (mpfps)
+		return mpfps;
+
+	for (loc =3D acpi_locations; loc->addr !=3D 0; loc++) {
+		mpfps =3D find_signature(loc->addr, loc->size);
+		if (mpfps)
+			return mpfps;
+	}
+
+	return NULL;
+}
+
+int enumerate_cpus(void)
+{
+	struct mpfps *mpfps;
+
+	/* probe for MP structures */
+	mpfps =3D apic_probe();
+	if (mpfps =3D=3D NULL) {
+		printf("Could not find MP structures\n");
+		return 1;
+	}
+
+	/* check whether an MP config table exists */
+	if (mpfps->mpfb1)
+		return 1;
+
+	return mp_config_table_header(mpfps->pap);
+}
diff --git a/lib/x86/mptable.h b/lib/x86/mptable.h
new file mode 100644
index 0000000..c4fd098
--- /dev/null
+++ b/lib/x86/mptable.h
@@ -0,0 +1,6 @@
+#ifndef CFLAT_MPTABLE_H
+#define CFLAT_MPTABLE_H
+
+int enumerate_cpus(void);
+
+#endif
diff --git a/x86/Makefile.common b/x86/Makefile.common
index e612dbe..137e6d5 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -21,6 +21,7 @@ cflatobjs +=3D lib/x86/acpi.o
 cflatobjs +=3D lib/x86/stack.o
 cflatobjs +=3D lib/x86/fault_test.o
 cflatobjs +=3D lib/x86/delay.o
+cflatobjs +=3D lib/x86/mptable.o
=20
 OBJDIRS +=3D lib/x86
=20
diff --git a/x86/cstart64.S b/x86/cstart64.S
index cc7926a..0844b2a 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -247,6 +247,7 @@ start64:
 	mov mb_boot_info(%rip), %rbx
 	mov %rbx, %rdi
 	call setup_multiboot
+	call enumerate_cpus
 	call setup_libcflat
 	mov mb_cmdline(%rbx), %eax
 	mov %rax, __args(%rip)
--=20
2.17.1=
