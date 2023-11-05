Return-Path: <kvm+bounces-589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1229E7E1318
	for <lists+kvm@lfdr.de>; Sun,  5 Nov 2023 11:56:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4FCF5B20E79
	for <lists+kvm@lfdr.de>; Sun,  5 Nov 2023 10:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80F1BB650;
	Sun,  5 Nov 2023 10:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e+kkbpRP"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6EE23C4
	for <kvm@vger.kernel.org>; Sun,  5 Nov 2023 10:56:03 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F69C5;
	Sun,  5 Nov 2023 02:55:59 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9c5b313b3ffso519094966b.0;
        Sun, 05 Nov 2023 02:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699181758; x=1699786558; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wLlmdqKDgjoXfxsRxGmv0Du0/95oMIzm4XrXAI635sc=;
        b=e+kkbpRP7ZlnQBjpYERkDev/mpeqKJn5vjUAv7kpzjcAxclEt11+ac3cVLCwBo1vK+
         rk3iuJ83JeOu9FneICEhEMZsh+v0r9GmFqCMXXB/OHH1uWQlTsAYHZR7V3m79DwwhOcc
         qx4+rlMX9asRT85LrQLa6vNbm1/+OTauX2BfFWx5oIIhL4G0x4VUupU9k+rQj3RSwKGJ
         grwJJqMKDTRLj3Eh9goGKXMrFQf87OUvDwLPv3hEBwZB5VvZ0IVE0LyCFS9c77xEJNEt
         lDoSg2MR7PTvTToX13/gVfRjnYV2Q5OPmvB6atIrjwDKB/2OJdkqVNiqPWFbDlILk68t
         666g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699181758; x=1699786558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wLlmdqKDgjoXfxsRxGmv0Du0/95oMIzm4XrXAI635sc=;
        b=u4ntUFdFecIqlYvJmFmiuFOqtn0Zfxh/PBpCvJT8Yn/gaXXHyqOdqdGGu8P2bf4Oty
         5ChwZQb52YqvWZn1F13dzncDShR9VWRIwHq2AnCWkyj4f/O8suMnNfOk+Qm6rj6EkA1Y
         QcnPi4UNIzmGh4CzL++kqoXIwBoTdwEPEIRv4EeuFcboV1jcl4nkW3KvOjhE0eaUb6At
         HuhG5EKhva+JAClfTRH0dQkPta6vyxVKWT5WWoHER+FpcvR+v0GK5srcWtD/zRr+ni5g
         d5TL+zR0+fCF/swk9+5rQptwW2h3pUwoEK1oBs3MDTYldzzT+kq/DHceuOq4dqYqk3h9
         PtAw==
X-Gm-Message-State: AOJu0YyF4LI8GnAT9tR+tk0Mea+OcBRvqcblWb8QVD+sEm6LhLRincT0
	yUU+V2bTSjm4yRejNEkw7RdAbTKkD8dgyQX3RQ==
X-Google-Smtp-Source: AGHT+IErK/NnAMAclh4fcUbU98HvhoTiS/JyKL9RJ9uSpSW69FZGSCsjR6s/8wvV6nX6fLe+dEbkyIfKYJbThjXG3DY=
X-Received: by 2002:a17:907:268a:b0:9e0:4910:1664 with SMTP id
 bn10-20020a170907268a00b009e049101664mr16838ejc.18.1699181757343; Sun, 05 Nov
 2023 02:55:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Zheyu Ma <zheyuma97@gmail.com>
Date: Sun, 5 Nov 2023 18:55:45 +0800
Message-ID: <CAMhUBjmXMYsEoVYw_M8hSZjBMHh24i88QYm-RY6HDta5YZ7Wgw@mail.gmail.com>
Subject: [BUG] KVM: VMX: WARNING in nested_vmx_vmexit
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	x86@kernel.org
Cc: kvm@vger.kernel.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I have encountered a warning while testing the KVM module on Linux.
Below, I've outlined the steps to reproduce the issue, along with the
associated log that reveals the warning.

Here is a simple PoC:

#define _GNU_SOURCE

#include <stdint.h>
#include <string.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

#include <linux/kvm.h>

#define ADDR_TEXT 0x0000
#define ADDR_GDT 0x1000
#define ADDR_LDT 0x1800
#define ADDR_PML4 0x2000
#define ADDR_PDP 0x3000
#define ADDR_PD 0x4000
#define ADDR_STACK0 0x0f80
#define ADDR_VAR_HLT 0x2800
#define ADDR_VAR_SYSRET 0x2808
#define ADDR_VAR_SYSEXIT 0x2810
#define ADDR_VAR_IDT 0x3800
#define ADDR_VAR_TSS64 0x3a00
#define ADDR_VAR_TSS64_CPL3 0x3c00
#define ADDR_VAR_TSS16 0x3d00
#define ADDR_VAR_TSS16_2 0x3e00
#define ADDR_VAR_TSS16_CPL3 0x3f00
#define ADDR_VAR_TSS32 0x4800
#define ADDR_VAR_TSS32_2 0x4a00
#define ADDR_VAR_TSS32_CPL3 0x4c00
#define ADDR_VAR_TSS32_VM86 0x4e00
#define ADDR_VAR_VMXON_PTR 0x5f00
#define ADDR_VAR_VMCS_PTR 0x5f08
#define ADDR_VAR_VMEXIT_PTR 0x5f10
#define ADDR_VAR_VMWRITE_FLD 0x5f18
#define ADDR_VAR_VMWRITE_VAL 0x5f20
#define ADDR_VAR_VMXON 0x6000
#define ADDR_VAR_VMCS 0x7000
#define ADDR_VAR_VMEXIT_CODE 0x9000
#define ADDR_VAR_USER_CODE 0x9100
#define ADDR_VAR_USER_CODE2 0x9120

#define SEL_LDT (1 << 3)
#define SEL_CS16 (2 << 3)
#define SEL_DS16 (3 << 3)
#define SEL_CS16_CPL3 ((4 << 3) + 3)
#define SEL_DS16_CPL3 ((5 << 3) + 3)
#define SEL_CS32 (6 << 3)
#define SEL_DS32 (7 << 3)
#define SEL_CS32_CPL3 ((8 << 3) + 3)
#define SEL_DS32_CPL3 ((9 << 3) + 3)
#define SEL_CS64 (10 << 3)
#define SEL_DS64 (11 << 3)
#define SEL_CS64_CPL3 ((12 << 3) + 3)
#define SEL_DS64_CPL3 ((13 << 3) + 3)
#define SEL_CGATE16 (14 << 3)
#define SEL_TGATE16 (15 << 3)
#define SEL_CGATE32 (16 << 3)
#define SEL_TGATE32 (17 << 3)
#define SEL_CGATE64 (18 << 3)
#define SEL_CGATE64_HI (19 << 3)
#define SEL_TSS16 (20 << 3)
#define SEL_TSS16_2 (21 << 3)
#define SEL_TSS16_CPL3 ((22 << 3) + 3)
#define SEL_TSS32 (23 << 3)
#define SEL_TSS32_2 (24 << 3)
#define SEL_TSS32_CPL3 ((25 << 3) + 3)
#define SEL_TSS32_VM86 (26 << 3)
#define SEL_TSS64 (27 << 3)
#define SEL_TSS64_HI (28 << 3)
#define SEL_TSS64_CPL3 ((29 << 3) + 3)
#define SEL_TSS64_CPL3_HI (30 << 3)

#define MSR_IA32_FEATURE_CONTROL 0x3a
#define MSR_IA32_VMX_BASIC 0x480
#define MSR_IA32_SMBASE 0x9e
#define MSR_IA32_SYSENTER_CS 0x174
#define MSR_IA32_SYSENTER_ESP 0x175
#define MSR_IA32_SYSENTER_EIP 0x176
#define MSR_IA32_STAR 0xC0000081
#define MSR_IA32_LSTAR 0xC0000082
#define MSR_IA32_VMX_PROCBASED_CTLS2 0x48B

#define NEXT_INSN $0xbadc0de
#define PREFIX_SIZE 0xba1d
const char kvm_asm16_cpl3[] =3D
"\x0f\x20\xc0\x66\x83\xc8\x01\x0f\x22\xc0\xb8\xa0\x00\x0f\x00\xd8\xb8\x2b\x=
00\x8e\xd8\x8e\xc0\x8e\xe0\x8e\xe8\xbc\x00\x01\xc7\x06\x00\x01\x1d\xba\xc7\=
x06\x02\x01\x23\x00\xc7\x06\x04\x01\x00\x01\xc7\x06\x06\x01\x2b\x00\xcb";
const char kvm_asm32_paged[] =3D "\x0f\x20\xc0\x0d\x00\x00\x00\x80\x0f\x22\=
xc0";
const char kvm_asm32_vm86[] =3D
"\x66\xb8\xb8\x00\x0f\x00\xd8\xea\x00\x00\x00\x00\xd0\x00";
const char kvm_asm32_paged_vm86[] =3D
"\x0f\x20\xc0\x0d\x00\x00\x00\x80\x0f\x22\xc0\x66\xb8\xb8\x00\x0f\x00\xd8\x=
ea\x00\x00\x00\x00\xd0\x00";
const char kvm_asm64_enable_long[] =3D
"\x0f\x20\xc0\x0d\x00\x00\x00\x80\x0f\x22\xc0\xea\xde\xc0\xad\x0b\x50\x00\x=
48\xc7\xc0\xd8\x00\x00\x00\x0f\x00\xd8";
const char kvm_asm64_init_vm[] =3D
"\x0f\x20\xc0\x0d\x00\x00\x00\x80\x0f\x22\xc0\xea\xde\xc0\xad\x0b\x50\x00\x=
48\xc7\xc0\xd8\x00\x00\x00\x0f\x00\xd8\x48\xc7\xc1\x3a\x00\x00\x00\x0f\x32\=
x48\x83\xc8\x05\x0f\x30\x0f\x20\xe0\x48\x0d\x00\x20\x00\x00\x0f\x22\xe0\x48=
\xc7\xc1\x80\x04\x00\x00\x0f\x32\x48\xc7\xc2\x00\x60\x00\x00\x89\x02\x48\xc=
7\xc2\x00\x70\x00\x00\x89\x02\x48\xc7\xc0\x00\x5f\x00\x00\xf3\x0f\xc7\x30\x=
48\xc7\xc0\x08\x5f\x00\x00\x66\x0f\xc7\x30\x0f\xc7\x30\x48\xc7\xc1\x81\x04\=
x00\x00\x0f\x32\x48\x83\xc8\x00\x48\x21\xd0\x48\xc7\xc2\x00\x40\x00\x00\x0f=
\x79\xd0\x48\xc7\xc1\x82\x04\x00\x00\x0f\x32\x48\x83\xc8\x00\x48\x21\xd0\x4=
8\xc7\xc2\x02\x40\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x1e\x40\x00\x00\x48\xc7\x=
c0\x81\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc1\x83\x04\x00\x00\x0f\x32\x48\x0d\=
xff\x6f\x03\x00\x48\x21\xd0\x48\xc7\xc2\x0c\x40\x00\x00\x0f\x79\xd0\x48\xc7=
\xc1\x84\x04\x00\x00\x0f\x32\x48\x0d\xff\x17\x00\x00\x48\x21\xd0\x48\xc7\xc=
2\x12\x40\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x04\x2c\x00\x00\x48\xc7\xc0\x00\x=
00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x00\x28\x00\x00\x48\xc7\xc0\xff\xff\xff\=
xff\x0f\x79\xd0\x48\xc7\xc2\x02\x0c\x00\x00\x48\xc7\xc0\x50\x00\x00\x00\x0f=
\x79\xd0\x48\xc7\xc0\x58\x00\x00\x00\x48\xc7\xc2\x00\x0c\x00\x00\x0f\x79\xd=
0\x48\xc7\xc2\x04\x0c\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x06\x0c\x00\x00\x0f\x=
79\xd0\x48\xc7\xc2\x08\x0c\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x0a\x0c\x00\x00\=
x0f\x79\xd0\x48\xc7\xc0\xd8\x00\x00\x00\x48\xc7\xc2\x0c\x0c\x00\x00\x0f\x79=
\xd0\x48\xc7\xc2\x02\x2c\x00\x00\x48\xc7\xc0\x00\x05\x00\x00\x0f\x79\xd0\x4=
8\xc7\xc2\x00\x4c\x00\x00\x48\xc7\xc0\x50\x00\x00\x00\x0f\x79\xd0\x48\xc7\x=
c2\x10\x6c\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x12\=
x6c\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x0f\x20\xc0\x48\xc7\xc2=
\x00\x6c\x00\x00\x48\x89\xc0\x0f\x79\xd0\x0f\x20\xd8\x48\xc7\xc2\x02\x6c\x0=
0\x00\x48\x89\xc0\x0f\x79\xd0\x0f\x20\xe0\x48\xc7\xc2\x04\x6c\x00\x00\x48\x=
89\xc0\x0f\x79\xd0\x48\xc7\xc2\x06\x6c\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\=
x0f\x79\xd0\x48\xc7\xc2\x08\x6c\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79=
\xd0\x48\xc7\xc2\x0a\x6c\x00\x00\x48\xc7\xc0\x00\x3a\x00\x00\x0f\x79\xd0\x4=
8\xc7\xc2\x0c\x6c\x00\x00\x48\xc7\xc0\x00\x10\x00\x00\x0f\x79\xd0\x48\xc7\x=
c2\x0e\x6c\x00\x00\x48\xc7\xc0\x00\x38\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x14\=
x6c\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x16\x6c\x00=
\x00\x48\x8b\x04\x25\x10\x5f\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x00\x00\x00\x0=
0\x48\xc7\xc0\x01\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x02\x00\x00\x00\x48\x=
c7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x00\x20\x00\x00\x48\xc7\xc0\=
x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x02\x20\x00\x00\x48\xc7\xc0\x00\x00=
\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x04\x20\x00\x00\x48\xc7\xc0\x00\x00\x00\x0=
0\x0f\x79\xd0\x48\xc7\xc2\x06\x20\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x=
79\xd0\x48\xc7\xc1\x77\x02\x00\x00\x0f\x32\x48\xc1\xe2\x20\x48\x09\xd0\x48\=
xc7\xc2\x00\x2c\x00\x00\x48\x89\xc0\x0f\x79\xd0\x48\xc7\xc2\x04\x40\x00\x00=
\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x0a\x40\x00\x00\x48\xc=
7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x0e\x40\x00\x00\x48\xc7\xc0\x=
00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x10\x40\x00\x00\x48\xc7\xc0\x00\x00\=
x00\x00\x0f\x79\xd0\x48\xc7\xc2\x16\x40\x00\x00\x48\xc7\xc0\x00\x00\x00\x00=
\x0f\x79\xd0\x48\xc7\xc2\x14\x40\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x7=
9\xd0\x48\xc7\xc2\x00\x60\x00\x00\x48\xc7\xc0\xff\xff\xff\xff\x0f\x79\xd0\x=
48\xc7\xc2\x02\x60\x00\x00\x48\xc7\xc0\xff\xff\xff\xff\x0f\x79\xd0\x48\xc7\=
xc2\x1c\x20\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x1e=
\x20\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x20\x20\x0=
0\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x22\x20\x00\x00\x=
48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x00\x08\x00\x00\x48\xc7\=
xc0\x58\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x02\x08\x00\x00\x48\xc7\xc0\x50=
\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x04\x08\x00\x00\x48\xc7\xc0\x58\x00\x0=
0\x00\x0f\x79\xd0\x48\xc7\xc2\x06\x08\x00\x00\x48\xc7\xc0\x58\x00\x00\x00\x=
0f\x79\xd0\x48\xc7\xc2\x08\x08\x00\x00\x48\xc7\xc0\x58\x00\x00\x00\x0f\x79\=
xd0\x48\xc7\xc2\x0a\x08\x00\x00\x48\xc7\xc0\x58\x00\x00\x00\x0f\x79\xd0\x48=
\xc7\xc2\x0c\x08\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc=
2\x0e\x08\x00\x00\x48\xc7\xc0\xd8\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x12\x=
68\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x14\x68\x00\=
x00\x48\xc7\xc0\x00\x3a\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x16\x68\x00\x00\x48=
\xc7\xc0\x00\x10\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x18\x68\x00\x00\x48\xc7\xc=
0\x00\x38\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x00\x48\x00\x00\x48\xc7\xc0\xff\x=
ff\x0f\x00\x0f\x79\xd0\x48\xc7\xc2\x02\x48\x00\x00\x48\xc7\xc0\xff\xff\x0f\=
x00\x0f\x79\xd0\x48\xc7\xc2\x04\x48\x00\x00\x48\xc7\xc0\xff\xff\x0f\x00\x0f=
\x79\xd0\x48\xc7\xc2\x06\x48\x00\x00\x48\xc7\xc0\xff\xff\x0f\x00\x0f\x79\xd=
0\x48\xc7\xc2\x08\x48\x00\x00\x48\xc7\xc0\xff\xff\x0f\x00\x0f\x79\xd0\x48\x=
c7\xc2\x0a\x48\x00\x00\x48\xc7\xc0\xff\xff\x0f\x00\x0f\x79\xd0\x48\xc7\xc2\=
x0c\x48\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x0e\x48=
\x00\x00\x48\xc7\xc0\xff\x1f\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x10\x48\x00\x0=
0\x48\xc7\xc0\xff\x1f\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x12\x48\x00\x00\x48\x=
c7\xc0\xff\x1f\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x14\x48\x00\x00\x48\xc7\xc0\=
x93\x40\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x16\x48\x00\x00\x48\xc7\xc0\x9b\x20=
\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x18\x48\x00\x00\x48\xc7\xc0\x93\x40\x00\x0=
0\x0f\x79\xd0\x48\xc7\xc2\x1a\x48\x00\x00\x48\xc7\xc0\x93\x40\x00\x00\x0f\x=
79\xd0\x48\xc7\xc2\x1c\x48\x00\x00\x48\xc7\xc0\x93\x40\x00\x00\x0f\x79\xd0\=
x48\xc7\xc2\x1e\x48\x00\x00\x48\xc7\xc0\x93\x40\x00\x00\x0f\x79\xd0\x48\xc7=
\xc2\x20\x48\x00\x00\x48\xc7\xc0\x82\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x2=
2\x48\x00\x00\x48\xc7\xc0\x8b\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x1c\x68\x=
00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x1e\x68\x00\x00\=
x48\xc7\xc0\x00\x91\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x20\x68\x00\x00\x48\xc7=
\xc0\x02\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x06\x28\x00\x00\x48\xc7\xc0\x0=
0\x05\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x0a\x28\x00\x00\x48\xc7\xc0\x00\x00\x=
00\x00\x0f\x79\xd0\x48\xc7\xc2\x0c\x28\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\=
x0f\x79\xd0\x48\xc7\xc2\x0e\x28\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79=
\xd0\x48\xc7\xc2\x10\x28\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x0=
f\x20\xc0\x48\xc7\xc2\x00\x68\x00\x00\x48\x89\xc0\x0f\x79\xd0\x0f\x20\xd8\x=
48\xc7\xc2\x02\x68\x00\x00\x48\x89\xc0\x0f\x79\xd0\x0f\x20\xe0\x48\xc7\xc2\=
x04\x68\x00\x00\x48\x89\xc0\x0f\x79\xd0\x48\xc7\xc0\x18\x5f\x00\x00\x48\x8b=
\x10\x48\xc7\xc0\x20\x5f\x00\x00\x48\x8b\x08\x48\x31\xc0\x0f\x78\xd0\x48\x3=
1\xc8\x0f\x79\xd0\x0f\x01\xc2\x48\xc7\xc2\x00\x44\x00\x00\x0f\x78\xd0\xf4";
const char kvm_asm64_vm_exit[] =3D
"\x48\xc7\xc3\x00\x44\x00\x00\x0f\x78\xda\x48\xc7\xc3\x02\x44\x00\x00\x0f\x=
78\xd9\x48\xc7\xc0\x00\x64\x00\x00\x0f\x78\xc0\x48\xc7\xc3\x1e\x68\x00\x00\=
x0f\x78\xdb\xf4";
const char kvm_asm64_cpl3[] =3D
"\x0f\x20\xc0\x0d\x00\x00\x00\x80\x0f\x22\xc0\xea\xde\xc0\xad\x0b\x50\x00\x=
48\xc7\xc0\xd8\x00\x00\x00\x0f\x00\xd8\x48\xc7\xc0\x6b\x00\x00\x00\x8e\xd8\=
x8e\xc0\x8e\xe0\x8e\xe8\x48\xc7\xc4\x80\x0f\x00\x00\x48\xc7\x04\x24\x1d\xba=
\x00\x00\x48\xc7\x44\x24\x04\x63\x00\x00\x00\x48\xc7\x44\x24\x08\x80\x0f\x0=
0\x00\x48\xc7\x44\x24\x0c\x6b\x00\x00\x00\xcb";

#define KVM_SMI _IO(KVMIO, 0xb7)

#define CR0_PE 1
#define CR0_MP (1 << 1)
#define CR0_EM (1 << 2)
#define CR0_TS (1 << 3)
#define CR0_ET (1 << 4)
#define CR0_NE (1 << 5)
#define CR0_WP (1 << 16)
#define CR0_AM (1 << 18)
#define CR0_NW (1 << 29)
#define CR0_CD (1 << 30)
#define CR0_PG (1 << 31)

#define CR4_VME 1
#define CR4_PVI (1 << 1)
#define CR4_TSD (1 << 2)
#define CR4_DE (1 << 3)
#define CR4_PSE (1 << 4)
#define CR4_PAE (1 << 5)
#define CR4_MCE (1 << 6)
#define CR4_PGE (1 << 7)
#define CR4_PCE (1 << 8)
#define CR4_OSFXSR (1 << 8)
#define CR4_OSXMMEXCPT (1 << 10)
#define CR4_UMIP (1 << 11)
#define CR4_VMXE (1 << 13)
#define CR4_SMXE (1 << 14)
#define CR4_FSGSBASE (1 << 16)
#define CR4_PCIDE (1 << 17)
#define CR4_OSXSAVE (1 << 18)
#define CR4_SMEP (1 << 20)
#define CR4_SMAP (1 << 21)
#define CR4_PKE (1 << 22)

#define EFER_SCE 1
#define EFER_LME (1 << 8)
#define EFER_LMA (1 << 10)
#define EFER_NXE (1 << 11)
#define EFER_SVME (1 << 12)
#define EFER_LMSLE (1 << 13)
#define EFER_FFXSR (1 << 14)
#define EFER_TCE (1 << 15)
#define PDE32_PRESENT 1
#define PDE32_RW (1 << 1)
#define PDE32_USER (1 << 2)
#define PDE32_PS (1 << 7)
#define PDE64_PRESENT 1
#define PDE64_RW (1 << 1)
#define PDE64_USER (1 << 2)
#define PDE64_ACCESSED (1 << 5)
#define PDE64_DIRTY (1 << 6)
#define PDE64_PS (1 << 7)
#define PDE64_G (1 << 8)

struct tss16 {
uint16_t prev;
uint16_t sp0;
uint16_t ss0;
uint16_t sp1;
uint16_t ss1;
uint16_t sp2;
uint16_t ss2;
uint16_t ip;
uint16_t flags;
uint16_t ax;
uint16_t cx;
uint16_t dx;
uint16_t bx;
uint16_t sp;
uint16_t bp;
uint16_t si;
uint16_t di;
uint16_t es;
uint16_t cs;
uint16_t ss;
uint16_t ds;
uint16_t ldt;
} __attribute__((packed));

struct tss32 {
uint16_t prev, prevh;
uint32_t sp0;
uint16_t ss0, ss0h;
uint32_t sp1;
uint16_t ss1, ss1h;
uint32_t sp2;
uint16_t ss2, ss2h;
uint32_t cr3;
uint32_t ip;
uint32_t flags;
uint32_t ax;
uint32_t cx;
uint32_t dx;
uint32_t bx;
uint32_t sp;
uint32_t bp;
uint32_t si;
uint32_t di;
uint16_t es, esh;
uint16_t cs, csh;
uint16_t ss, ssh;
uint16_t ds, dsh;
uint16_t fs, fsh;
uint16_t gs, gsh;
uint16_t ldt, ldth;
uint16_t trace;
uint16_t io_bitmap;
} __attribute__((packed));

struct tss64 {
uint32_t reserved0;
uint64_t rsp[3];
uint64_t reserved1;
uint64_t ist[7];
uint64_t reserved2;
uint32_t reserved3;
uint32_t io_bitmap;
} __attribute__((packed));

static void fill_segment_descriptor(uint64_t* dt, uint64_t* lt, struct
kvm_segment* seg)
{
uint16_t index =3D seg->selector >> 3;
uint64_t limit =3D seg->g ? seg->limit >> 12 : seg->limit;
uint64_t sd =3D (limit & 0xffff) | (seg->base & 0xffffff) << 16 |
(uint64_t)seg->type << 40 | (uint64_t)seg->s << 44 |
(uint64_t)seg->dpl << 45 | (uint64_t)seg->present << 47 | (limit &
0xf0000ULL) << 48 | (uint64_t)seg->avl << 52 | (uint64_t)seg->l << 53
| (uint64_t)seg->db << 54 | (uint64_t)seg->g << 55 | (seg->base &
0xff000000ULL) << 56;
dt[index] =3D sd;
lt[index] =3D sd;
}

static void fill_segment_descriptor_dword(uint64_t* dt, uint64_t* lt,
struct kvm_segment* seg)
{
fill_segment_descriptor(dt, lt, seg);
uint16_t index =3D seg->selector >> 3;
dt[index + 1] =3D 0;
lt[index + 1] =3D 0;
}

static void setup_syscall_msrs(int cpufd, uint16_t sel_cs, uint16_t sel_cs_=
cpl3)
{
char buf[sizeof(struct kvm_msrs) + 5 * sizeof(struct kvm_msr_entry)];
memset(buf, 0, sizeof(buf));
struct kvm_msrs* msrs =3D (struct kvm_msrs*)buf;
struct kvm_msr_entry* entries =3D msrs->entries;
msrs->nmsrs =3D 5;
entries[0].index =3D MSR_IA32_SYSENTER_CS;
entries[0].data =3D sel_cs;
entries[1].index =3D MSR_IA32_SYSENTER_ESP;
entries[1].data =3D ADDR_STACK0;
entries[2].index =3D MSR_IA32_SYSENTER_EIP;
entries[2].data =3D ADDR_VAR_SYSEXIT;
entries[3].index =3D MSR_IA32_STAR;
entries[3].data =3D ((uint64_t)sel_cs << 32) | ((uint64_t)sel_cs_cpl3 << 48=
);
entries[4].index =3D MSR_IA32_LSTAR;
entries[4].data =3D ADDR_VAR_SYSRET;
ioctl(cpufd, KVM_SET_MSRS, msrs);
}

static void setup_32bit_idt(struct kvm_sregs* sregs, char* host_mem,
uintptr_t guest_mem)
{
sregs->idt.base =3D guest_mem + ADDR_VAR_IDT;
sregs->idt.limit =3D 0x1ff;
uint64_t* idt =3D (uint64_t*)(host_mem + sregs->idt.base);
for (int i =3D 0; i < 32; i++) {
struct kvm_segment gate;
gate.selector =3D i << 3;
switch (i % 6) {
case 0:
gate.type =3D 6;
gate.base =3D SEL_CS16;
break;
case 1:
gate.type =3D 7;
gate.base =3D SEL_CS16;
break;
case 2:
gate.type =3D 3;
gate.base =3D SEL_TGATE16;
break;
case 3:
gate.type =3D 14;
gate.base =3D SEL_CS32;
break;
case 4:
gate.type =3D 15;
gate.base =3D SEL_CS32;
break;
case 5:
gate.type =3D 11;
gate.base =3D SEL_TGATE32;
break;
}
gate.limit =3D guest_mem + ADDR_VAR_USER_CODE2;
gate.present =3D 1;
gate.dpl =3D 0;
gate.s =3D 0;
gate.g =3D 0;
gate.db =3D 0;
gate.l =3D 0;
gate.avl =3D 0;
fill_segment_descriptor(idt, idt, &gate);
}
}

static void setup_64bit_idt(struct kvm_sregs* sregs, char* host_mem,
uintptr_t guest_mem)
{
sregs->idt.base =3D guest_mem + ADDR_VAR_IDT;
sregs->idt.limit =3D 0x1ff;
uint64_t* idt =3D (uint64_t*)(host_mem + sregs->idt.base);
for (int i =3D 0; i < 32; i++) {
struct kvm_segment gate;
gate.selector =3D (i * 2) << 3;
gate.type =3D (i & 1) ? 14 : 15;
gate.base =3D SEL_CS64;
gate.limit =3D guest_mem + ADDR_VAR_USER_CODE2;
gate.present =3D 1;
gate.dpl =3D 0;
gate.s =3D 0;
gate.g =3D 0;
gate.db =3D 0;
gate.l =3D 0;
gate.avl =3D 0;
fill_segment_descriptor_dword(idt, idt, &gate);
}
}

struct kvm_text {
uintptr_t typ;
const void* text;
uintptr_t size;
};

struct kvm_opt {
uint64_t typ;
uint64_t val;
};

#define KVM_SETUP_PAGING (1 << 0)
#define KVM_SETUP_PAE (1 << 1)
#define KVM_SETUP_PROTECTED (1 << 2)
#define KVM_SETUP_CPL3 (1 << 3)
#define KVM_SETUP_VIRT86 (1 << 4)
#define KVM_SETUP_SMM (1 << 5)
#define KVM_SETUP_VM (1 << 6)
static volatile long syz_kvm_setup_cpu(volatile long a0, volatile long
a1, volatile long a2, volatile long a3, volatile long a4, volatile
long a5, volatile long a6, volatile long a7)
{
const int vmfd =3D a0;
const int cpufd =3D a1;
char* const host_mem =3D (char*)a2;
const struct kvm_text* const text_array_ptr =3D (struct kvm_text*)a3;
const uintptr_t text_count =3D a4;
const uintptr_t flags =3D a5;
const struct kvm_opt* const opt_array_ptr =3D (struct kvm_opt*)a6;
uintptr_t opt_count =3D a7;
const uintptr_t page_size =3D 4 << 10;
const uintptr_t ioapic_page =3D 10;
const uintptr_t guest_mem_size =3D 24 * page_size;
const uintptr_t guest_mem =3D 0;
(void)text_count;
int text_type =3D text_array_ptr[0].typ;
const void* text =3D text_array_ptr[0].text;
uintptr_t text_size =3D text_array_ptr[0].size;
for (uintptr_t i =3D 0; i < guest_mem_size / page_size; i++) {
struct kvm_userspace_memory_region memreg;
memreg.slot =3D i;
memreg.flags =3D 0;
memreg.guest_phys_addr =3D guest_mem + i * page_size;
if (i =3D=3D ioapic_page)
memreg.guest_phys_addr =3D 0xfec00000;
memreg.memory_size =3D page_size;
memreg.userspace_addr =3D (uintptr_t)host_mem + i * page_size;
ioctl(vmfd, KVM_SET_USER_MEMORY_REGION, &memreg);
}
struct kvm_userspace_memory_region memreg;
memreg.slot =3D 1 + (1 << 16);
memreg.flags =3D 0;
memreg.guest_phys_addr =3D 0x30000;
memreg.memory_size =3D 64 << 10;
memreg.userspace_addr =3D (uintptr_t)host_mem;
ioctl(vmfd, KVM_SET_USER_MEMORY_REGION, &memreg);
struct kvm_sregs sregs;
if (ioctl(cpufd, KVM_GET_SREGS, &sregs))
return -1;
struct kvm_regs regs;
memset(&regs, 0, sizeof(regs));
regs.rip =3D guest_mem + ADDR_TEXT;
regs.rsp =3D ADDR_STACK0;
sregs.gdt.base =3D guest_mem + ADDR_GDT;
sregs.gdt.limit =3D 256 * sizeof(uint64_t) - 1;
uint64_t* gdt =3D (uint64_t*)(host_mem + sregs.gdt.base);
struct kvm_segment seg_ldt;
seg_ldt.selector =3D SEL_LDT;
seg_ldt.type =3D 2;
seg_ldt.base =3D guest_mem + ADDR_LDT;
seg_ldt.limit =3D 256 * sizeof(uint64_t) - 1;
seg_ldt.present =3D 1;
seg_ldt.dpl =3D 0;
seg_ldt.s =3D 0;
seg_ldt.g =3D 0;
seg_ldt.db =3D 1;
seg_ldt.l =3D 0;
sregs.ldt =3D seg_ldt;
uint64_t* ldt =3D (uint64_t*)(host_mem + sregs.ldt.base);
struct kvm_segment seg_cs16;
seg_cs16.selector =3D SEL_CS16;
seg_cs16.type =3D 11;
seg_cs16.base =3D 0;
seg_cs16.limit =3D 0xfffff;
seg_cs16.present =3D 1;
seg_cs16.dpl =3D 0;
seg_cs16.s =3D 1;
seg_cs16.g =3D 0;
seg_cs16.db =3D 0;
seg_cs16.l =3D 0;
struct kvm_segment seg_ds16 =3D seg_cs16;
seg_ds16.selector =3D SEL_DS16;
seg_ds16.type =3D 3;
struct kvm_segment seg_cs16_cpl3 =3D seg_cs16;
seg_cs16_cpl3.selector =3D SEL_CS16_CPL3;
seg_cs16_cpl3.dpl =3D 3;
struct kvm_segment seg_ds16_cpl3 =3D seg_ds16;
seg_ds16_cpl3.selector =3D SEL_DS16_CPL3;
seg_ds16_cpl3.dpl =3D 3;
struct kvm_segment seg_cs32 =3D seg_cs16;
seg_cs32.selector =3D SEL_CS32;
seg_cs32.db =3D 1;
struct kvm_segment seg_ds32 =3D seg_ds16;
seg_ds32.selector =3D SEL_DS32;
seg_ds32.db =3D 1;
struct kvm_segment seg_cs32_cpl3 =3D seg_cs32;
seg_cs32_cpl3.selector =3D SEL_CS32_CPL3;
seg_cs32_cpl3.dpl =3D 3;
struct kvm_segment seg_ds32_cpl3 =3D seg_ds32;
seg_ds32_cpl3.selector =3D SEL_DS32_CPL3;
seg_ds32_cpl3.dpl =3D 3;
struct kvm_segment seg_cs64 =3D seg_cs16;
seg_cs64.selector =3D SEL_CS64;
seg_cs64.l =3D 1;
struct kvm_segment seg_ds64 =3D seg_ds32;
seg_ds64.selector =3D SEL_DS64;
struct kvm_segment seg_cs64_cpl3 =3D seg_cs64;
seg_cs64_cpl3.selector =3D SEL_CS64_CPL3;
seg_cs64_cpl3.dpl =3D 3;
struct kvm_segment seg_ds64_cpl3 =3D seg_ds64;
seg_ds64_cpl3.selector =3D SEL_DS64_CPL3;
seg_ds64_cpl3.dpl =3D 3;
struct kvm_segment seg_tss32;
seg_tss32.selector =3D SEL_TSS32;
seg_tss32.type =3D 9;
seg_tss32.base =3D ADDR_VAR_TSS32;
seg_tss32.limit =3D 0x1ff;
seg_tss32.present =3D 1;
seg_tss32.dpl =3D 0;
seg_tss32.s =3D 0;
seg_tss32.g =3D 0;
seg_tss32.db =3D 0;
seg_tss32.l =3D 0;
struct kvm_segment seg_tss32_2 =3D seg_tss32;
seg_tss32_2.selector =3D SEL_TSS32_2;
seg_tss32_2.base =3D ADDR_VAR_TSS32_2;
struct kvm_segment seg_tss32_cpl3 =3D seg_tss32;
seg_tss32_cpl3.selector =3D SEL_TSS32_CPL3;
seg_tss32_cpl3.base =3D ADDR_VAR_TSS32_CPL3;
struct kvm_segment seg_tss32_vm86 =3D seg_tss32;
seg_tss32_vm86.selector =3D SEL_TSS32_VM86;
seg_tss32_vm86.base =3D ADDR_VAR_TSS32_VM86;
struct kvm_segment seg_tss16 =3D seg_tss32;
seg_tss16.selector =3D SEL_TSS16;
seg_tss16.base =3D ADDR_VAR_TSS16;
seg_tss16.limit =3D 0xff;
seg_tss16.type =3D 1;
struct kvm_segment seg_tss16_2 =3D seg_tss16;
seg_tss16_2.selector =3D SEL_TSS16_2;
seg_tss16_2.base =3D ADDR_VAR_TSS16_2;
seg_tss16_2.dpl =3D 0;
struct kvm_segment seg_tss16_cpl3 =3D seg_tss16;
seg_tss16_cpl3.selector =3D SEL_TSS16_CPL3;
seg_tss16_cpl3.base =3D ADDR_VAR_TSS16_CPL3;
seg_tss16_cpl3.dpl =3D 3;
struct kvm_segment seg_tss64 =3D seg_tss32;
seg_tss64.selector =3D SEL_TSS64;
seg_tss64.base =3D ADDR_VAR_TSS64;
seg_tss64.limit =3D 0x1ff;
struct kvm_segment seg_tss64_cpl3 =3D seg_tss64;
seg_tss64_cpl3.selector =3D SEL_TSS64_CPL3;
seg_tss64_cpl3.base =3D ADDR_VAR_TSS64_CPL3;
seg_tss64_cpl3.dpl =3D 3;
struct kvm_segment seg_cgate16;
seg_cgate16.selector =3D SEL_CGATE16;
seg_cgate16.type =3D 4;
seg_cgate16.base =3D SEL_CS16 | (2 << 16);
seg_cgate16.limit =3D ADDR_VAR_USER_CODE2;
seg_cgate16.present =3D 1;
seg_cgate16.dpl =3D 0;
seg_cgate16.s =3D 0;
seg_cgate16.g =3D 0;
seg_cgate16.db =3D 0;
seg_cgate16.l =3D 0;
seg_cgate16.avl =3D 0;
struct kvm_segment seg_tgate16 =3D seg_cgate16;
seg_tgate16.selector =3D SEL_TGATE16;
seg_tgate16.type =3D 3;
seg_cgate16.base =3D SEL_TSS16_2;
seg_tgate16.limit =3D 0;
struct kvm_segment seg_cgate32 =3D seg_cgate16;
seg_cgate32.selector =3D SEL_CGATE32;
seg_cgate32.type =3D 12;
seg_cgate32.base =3D SEL_CS32 | (2 << 16);
struct kvm_segment seg_tgate32 =3D seg_cgate32;
seg_tgate32.selector =3D SEL_TGATE32;
seg_tgate32.type =3D 11;
seg_tgate32.base =3D SEL_TSS32_2;
seg_tgate32.limit =3D 0;
struct kvm_segment seg_cgate64 =3D seg_cgate16;
seg_cgate64.selector =3D SEL_CGATE64;
seg_cgate64.type =3D 12;
seg_cgate64.base =3D SEL_CS64;
int kvmfd =3D open("/dev/kvm", O_RDWR);
char buf[sizeof(struct kvm_cpuid2) + 128 * sizeof(struct kvm_cpuid_entry2)]=
;
memset(buf, 0, sizeof(buf));
struct kvm_cpuid2* cpuid =3D (struct kvm_cpuid2*)buf;
cpuid->nent =3D 128;
ioctl(kvmfd, KVM_GET_SUPPORTED_CPUID, cpuid);
ioctl(cpufd, KVM_SET_CPUID2, cpuid);
close(kvmfd);
const char* text_prefix =3D 0;
int text_prefix_size =3D 0;
char* host_text =3D host_mem + ADDR_TEXT;
if (text_type =3D=3D 8) {
if (flags & KVM_SETUP_SMM) {
if (flags & KVM_SETUP_PROTECTED) {
sregs.cs =3D seg_cs16;
sregs.ds =3D sregs.es =3D sregs.fs =3D sregs.gs =3D sregs.ss =3D seg_ds16;
sregs.cr0 |=3D CR0_PE;
} else {
sregs.cs.selector =3D 0;
sregs.cs.base =3D 0;
}
*(host_mem + ADDR_TEXT) =3D 0xf4;
host_text =3D host_mem + 0x8000;
ioctl(cpufd, KVM_SMI, 0);
} else if (flags & KVM_SETUP_VIRT86) {
sregs.cs =3D seg_cs32;
sregs.ds =3D sregs.es =3D sregs.fs =3D sregs.gs =3D sregs.ss =3D seg_ds32;
sregs.cr0 |=3D CR0_PE;
sregs.efer |=3D EFER_SCE;
setup_syscall_msrs(cpufd, SEL_CS32, SEL_CS32_CPL3);
setup_32bit_idt(&sregs, host_mem, guest_mem);
if (flags & KVM_SETUP_PAGING) {
uint64_t pd_addr =3D guest_mem + ADDR_PD;
uint64_t* pd =3D (uint64_t*)(host_mem + ADDR_PD);
pd[0] =3D PDE32_PRESENT | PDE32_RW | PDE32_USER | PDE32_PS;
sregs.cr3 =3D pd_addr;
sregs.cr4 |=3D CR4_PSE;
text_prefix =3D kvm_asm32_paged_vm86;
text_prefix_size =3D sizeof(kvm_asm32_paged_vm86) - 1;
} else {
text_prefix =3D kvm_asm32_vm86;
text_prefix_size =3D sizeof(kvm_asm32_vm86) - 1;
}
} else {
sregs.cs.selector =3D 0;
sregs.cs.base =3D 0;
}
} else if (text_type =3D=3D 16) {
if (flags & KVM_SETUP_CPL3) {
sregs.cs =3D seg_cs16;
sregs.ds =3D sregs.es =3D sregs.fs =3D sregs.gs =3D sregs.ss =3D seg_ds16;
text_prefix =3D kvm_asm16_cpl3;
text_prefix_size =3D sizeof(kvm_asm16_cpl3) - 1;
} else {
sregs.cr0 |=3D CR0_PE;
sregs.cs =3D seg_cs16;
sregs.ds =3D sregs.es =3D sregs.fs =3D sregs.gs =3D sregs.ss =3D seg_ds16;
}
} else if (text_type =3D=3D 32) {
sregs.cr0 |=3D CR0_PE;
sregs.efer |=3D EFER_SCE;
setup_syscall_msrs(cpufd, SEL_CS32, SEL_CS32_CPL3);
setup_32bit_idt(&sregs, host_mem, guest_mem);
if (flags & KVM_SETUP_SMM) {
sregs.cs =3D seg_cs32;
sregs.ds =3D sregs.es =3D sregs.fs =3D sregs.gs =3D sregs.ss =3D seg_ds32;
*(host_mem + ADDR_TEXT) =3D 0xf4;
host_text =3D host_mem + 0x8000;
ioctl(cpufd, KVM_SMI, 0);
} else if (flags & KVM_SETUP_PAGING) {
sregs.cs =3D seg_cs32;
sregs.ds =3D sregs.es =3D sregs.fs =3D sregs.gs =3D sregs.ss =3D seg_ds32;
uint64_t pd_addr =3D guest_mem + ADDR_PD;
uint64_t* pd =3D (uint64_t*)(host_mem + ADDR_PD);
pd[0] =3D PDE32_PRESENT | PDE32_RW | PDE32_USER | PDE32_PS;
sregs.cr3 =3D pd_addr;
sregs.cr4 |=3D CR4_PSE;
text_prefix =3D kvm_asm32_paged;
text_prefix_size =3D sizeof(kvm_asm32_paged) - 1;
} else if (flags & KVM_SETUP_CPL3) {
sregs.cs =3D seg_cs32_cpl3;
sregs.ds =3D sregs.es =3D sregs.fs =3D sregs.gs =3D sregs.ss =3D seg_ds32_c=
pl3;
} else {
sregs.cs =3D seg_cs32;
sregs.ds =3D sregs.es =3D sregs.fs =3D sregs.gs =3D sregs.ss =3D seg_ds32;
}
} else {
sregs.efer |=3D EFER_LME | EFER_SCE;
sregs.cr0 |=3D CR0_PE;
setup_syscall_msrs(cpufd, SEL_CS64, SEL_CS64_CPL3);
setup_64bit_idt(&sregs, host_mem, guest_mem);
sregs.cs =3D seg_cs32;
sregs.ds =3D sregs.es =3D sregs.fs =3D sregs.gs =3D sregs.ss =3D seg_ds32;
uint64_t pml4_addr =3D guest_mem + ADDR_PML4;
uint64_t* pml4 =3D (uint64_t*)(host_mem + ADDR_PML4);
uint64_t pdpt_addr =3D guest_mem + ADDR_PDP;
uint64_t* pdpt =3D (uint64_t*)(host_mem + ADDR_PDP);
uint64_t pd_addr =3D guest_mem + ADDR_PD;
uint64_t* pd =3D (uint64_t*)(host_mem + ADDR_PD);
pml4[0] =3D PDE64_PRESENT | PDE64_RW | PDE64_USER | pdpt_addr;
pdpt[0] =3D PDE64_PRESENT | PDE64_RW | PDE64_USER | pd_addr;
pd[0] =3D PDE64_PRESENT | PDE64_RW | PDE64_USER | PDE64_PS;
sregs.cr3 =3D pml4_addr;
sregs.cr4 |=3D CR4_PAE;
if (flags & KVM_SETUP_VM) {
sregs.cr0 |=3D CR0_NE;
*((uint64_t*)(host_mem + ADDR_VAR_VMXON_PTR)) =3D ADDR_VAR_VMXON;
*((uint64_t*)(host_mem + ADDR_VAR_VMCS_PTR)) =3D ADDR_VAR_VMCS;
memcpy(host_mem + ADDR_VAR_VMEXIT_CODE, kvm_asm64_vm_exit,
sizeof(kvm_asm64_vm_exit) - 1);
*((uint64_t*)(host_mem + ADDR_VAR_VMEXIT_PTR)) =3D ADDR_VAR_VMEXIT_CODE;
text_prefix =3D kvm_asm64_init_vm;
text_prefix_size =3D sizeof(kvm_asm64_init_vm) - 1;
} else if (flags & KVM_SETUP_CPL3) {
text_prefix =3D kvm_asm64_cpl3;
text_prefix_size =3D sizeof(kvm_asm64_cpl3) - 1;
} else {
text_prefix =3D kvm_asm64_enable_long;
text_prefix_size =3D sizeof(kvm_asm64_enable_long) - 1;
}
}
struct tss16 tss16;
memset(&tss16, 0, sizeof(tss16));
tss16.ss0 =3D tss16.ss1 =3D tss16.ss2 =3D SEL_DS16;
tss16.sp0 =3D tss16.sp1 =3D tss16.sp2 =3D ADDR_STACK0;
tss16.ip =3D ADDR_VAR_USER_CODE2;
tss16.flags =3D (1 << 1);
tss16.cs =3D SEL_CS16;
tss16.es =3D tss16.ds =3D tss16.ss =3D SEL_DS16;
tss16.ldt =3D SEL_LDT;
struct tss16* tss16_addr =3D (struct tss16*)(host_mem + seg_tss16_2.base);
memcpy(tss16_addr, &tss16, sizeof(tss16));
memset(&tss16, 0, sizeof(tss16));
tss16.ss0 =3D tss16.ss1 =3D tss16.ss2 =3D SEL_DS16;
tss16.sp0 =3D tss16.sp1 =3D tss16.sp2 =3D ADDR_STACK0;
tss16.ip =3D ADDR_VAR_USER_CODE2;
tss16.flags =3D (1 << 1);
tss16.cs =3D SEL_CS16_CPL3;
tss16.es =3D tss16.ds =3D tss16.ss =3D SEL_DS16_CPL3;
tss16.ldt =3D SEL_LDT;
struct tss16* tss16_cpl3_addr =3D (struct tss16*)(host_mem + seg_tss16_cpl3=
.base);
memcpy(tss16_cpl3_addr, &tss16, sizeof(tss16));
struct tss32 tss32;
memset(&tss32, 0, sizeof(tss32));
tss32.ss0 =3D tss32.ss1 =3D tss32.ss2 =3D SEL_DS32;
tss32.sp0 =3D tss32.sp1 =3D tss32.sp2 =3D ADDR_STACK0;
tss32.ip =3D ADDR_VAR_USER_CODE;
tss32.flags =3D (1 << 1) | (1 << 17);
tss32.ldt =3D SEL_LDT;
tss32.cr3 =3D sregs.cr3;
tss32.io_bitmap =3D offsetof(struct tss32, io_bitmap);
struct tss32* tss32_addr =3D (struct tss32*)(host_mem + seg_tss32_vm86.base=
);
memcpy(tss32_addr, &tss32, sizeof(tss32));
memset(&tss32, 0, sizeof(tss32));
tss32.ss0 =3D tss32.ss1 =3D tss32.ss2 =3D SEL_DS32;
tss32.sp0 =3D tss32.sp1 =3D tss32.sp2 =3D ADDR_STACK0;
tss32.ip =3D ADDR_VAR_USER_CODE;
tss32.flags =3D (1 << 1);
tss32.cr3 =3D sregs.cr3;
tss32.es =3D tss32.ds =3D tss32.ss =3D tss32.gs =3D tss32.fs =3D SEL_DS32;
tss32.cs =3D SEL_CS32;
tss32.ldt =3D SEL_LDT;
tss32.cr3 =3D sregs.cr3;
tss32.io_bitmap =3D offsetof(struct tss32, io_bitmap);
struct tss32* tss32_cpl3_addr =3D (struct tss32*)(host_mem + seg_tss32_2.ba=
se);
memcpy(tss32_cpl3_addr, &tss32, sizeof(tss32));
struct tss64 tss64;
memset(&tss64, 0, sizeof(tss64));
tss64.rsp[0] =3D ADDR_STACK0;
tss64.rsp[1] =3D ADDR_STACK0;
tss64.rsp[2] =3D ADDR_STACK0;
tss64.io_bitmap =3D offsetof(struct tss64, io_bitmap);
struct tss64* tss64_addr =3D (struct tss64*)(host_mem + seg_tss64.base);
memcpy(tss64_addr, &tss64, sizeof(tss64));
memset(&tss64, 0, sizeof(tss64));
tss64.rsp[0] =3D ADDR_STACK0;
tss64.rsp[1] =3D ADDR_STACK0;
tss64.rsp[2] =3D ADDR_STACK0;
tss64.io_bitmap =3D offsetof(struct tss64, io_bitmap);
struct tss64* tss64_cpl3_addr =3D (struct tss64*)(host_mem + seg_tss64_cpl3=
.base);
memcpy(tss64_cpl3_addr, &tss64, sizeof(tss64));
if (text_size > 1000)
text_size =3D 1000;
if (text_prefix) {
memcpy(host_text, text_prefix, text_prefix_size);
void* patch =3D memmem(host_text, text_prefix_size, "\xde\xc0\xad\x0b", 4);
if (patch)
*((uint32_t*)patch) =3D guest_mem + ADDR_TEXT + ((char*)patch - host_text) =
+ 6;
uint16_t magic =3D PREFIX_SIZE;
patch =3D memmem(host_text, text_prefix_size, &magic, sizeof(magic));
if (patch)
*((uint16_t*)patch) =3D guest_mem + ADDR_TEXT + text_prefix_size;
}
memcpy((void*)(host_text + text_prefix_size), text, text_size);
*(host_text + text_prefix_size + text_size) =3D 0xf4;
memcpy(host_mem + ADDR_VAR_USER_CODE, text, text_size);
*(host_mem + ADDR_VAR_USER_CODE + text_size) =3D 0xf4;
*(host_mem + ADDR_VAR_HLT) =3D 0xf4;
memcpy(host_mem + ADDR_VAR_SYSRET, "\x0f\x07\xf4", 3);
memcpy(host_mem + ADDR_VAR_SYSEXIT, "\x0f\x35\xf4", 3);
*(uint64_t*)(host_mem + ADDR_VAR_VMWRITE_FLD) =3D 0;
*(uint64_t*)(host_mem + ADDR_VAR_VMWRITE_VAL) =3D 0;
if (opt_count > 2)
opt_count =3D 2;
for (uintptr_t i =3D 0; i < opt_count; i++) {
uint64_t typ =3D opt_array_ptr[i].typ;
uint64_t val =3D opt_array_ptr[i].val;
switch (typ % 9) {
case 0:
sregs.cr0 ^=3D val & (CR0_MP | CR0_EM | CR0_ET | CR0_NE | CR0_WP |
CR0_AM | CR0_NW | CR0_CD);
break;
case 1:
sregs.cr4 ^=3D val & (CR4_VME | CR4_PVI | CR4_TSD | CR4_DE | CR4_MCE |
CR4_PGE | CR4_PCE |
    CR4_OSFXSR | CR4_OSXMMEXCPT | CR4_UMIP | CR4_VMXE | CR4_SMXE |
CR4_FSGSBASE | CR4_PCIDE |
    CR4_OSXSAVE | CR4_SMEP | CR4_SMAP | CR4_PKE);
break;
case 2:
sregs.efer ^=3D val & (EFER_SCE | EFER_NXE | EFER_SVME | EFER_LMSLE |
EFER_FFXSR | EFER_TCE);
break;
case 3:
val &=3D ((1 << 8) | (1 << 9) | (1 << 10) | (1 << 12) | (1 << 13) | (1 << 1=
4) |
(1 << 15) | (1 << 18) | (1 << 19) | (1 << 20) | (1 << 21));
regs.rflags ^=3D val;
tss16_addr->flags ^=3D val;
tss16_cpl3_addr->flags ^=3D val;
tss32_addr->flags ^=3D val;
tss32_cpl3_addr->flags ^=3D val;
break;
case 4:
seg_cs16.type =3D val & 0xf;
seg_cs32.type =3D val & 0xf;
seg_cs64.type =3D val & 0xf;
break;
case 5:
seg_cs16_cpl3.type =3D val & 0xf;
seg_cs32_cpl3.type =3D val & 0xf;
seg_cs64_cpl3.type =3D val & 0xf;
break;
case 6:
seg_ds16.type =3D val & 0xf;
seg_ds32.type =3D val & 0xf;
seg_ds64.type =3D val & 0xf;
break;
case 7:
seg_ds16_cpl3.type =3D val & 0xf;
seg_ds32_cpl3.type =3D val & 0xf;
seg_ds64_cpl3.type =3D val & 0xf;
break;
case 8:
*(uint64_t*)(host_mem + ADDR_VAR_VMWRITE_FLD) =3D (val & 0xffff);
*(uint64_t*)(host_mem + ADDR_VAR_VMWRITE_VAL) =3D (val >> 16);
break;
default:
exit(1);
}
}
regs.rflags |=3D 2;
fill_segment_descriptor(gdt, ldt, &seg_ldt);
fill_segment_descriptor(gdt, ldt, &seg_cs16);
fill_segment_descriptor(gdt, ldt, &seg_ds16);
fill_segment_descriptor(gdt, ldt, &seg_cs16_cpl3);
fill_segment_descriptor(gdt, ldt, &seg_ds16_cpl3);
fill_segment_descriptor(gdt, ldt, &seg_cs32);
fill_segment_descriptor(gdt, ldt, &seg_ds32);
fill_segment_descriptor(gdt, ldt, &seg_cs32_cpl3);
fill_segment_descriptor(gdt, ldt, &seg_ds32_cpl3);
fill_segment_descriptor(gdt, ldt, &seg_cs64);
fill_segment_descriptor(gdt, ldt, &seg_ds64);
fill_segment_descriptor(gdt, ldt, &seg_cs64_cpl3);
fill_segment_descriptor(gdt, ldt, &seg_ds64_cpl3);
fill_segment_descriptor(gdt, ldt, &seg_tss32);
fill_segment_descriptor(gdt, ldt, &seg_tss32_2);
fill_segment_descriptor(gdt, ldt, &seg_tss32_cpl3);
fill_segment_descriptor(gdt, ldt, &seg_tss32_vm86);
fill_segment_descriptor(gdt, ldt, &seg_tss16);
fill_segment_descriptor(gdt, ldt, &seg_tss16_2);
fill_segment_descriptor(gdt, ldt, &seg_tss16_cpl3);
fill_segment_descriptor_dword(gdt, ldt, &seg_tss64);
fill_segment_descriptor_dword(gdt, ldt, &seg_tss64_cpl3);
fill_segment_descriptor(gdt, ldt, &seg_cgate16);
fill_segment_descriptor(gdt, ldt, &seg_tgate16);
fill_segment_descriptor(gdt, ldt, &seg_cgate32);
fill_segment_descriptor(gdt, ldt, &seg_tgate32);
fill_segment_descriptor_dword(gdt, ldt, &seg_cgate64);
if (ioctl(cpufd, KVM_SET_SREGS, &sregs))
return -1;
if (ioctl(cpufd, KVM_SET_REGS, &regs))
return -1;
return 0;
}

uint64_t r[6] =3D {0xffffffffffffffff, 0xffffffffffffffff,
0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff,
0xffffffffffffffff};

int main(void)
{
syscall(__NR_mmap, /*addr=3D*/0x1ffff000ul, /*len=3D*/0x1000ul,
/*prot=3D*/0ul, /*flags=3D*/0x32ul, /*fd=3D*/-1, /*offset=3D*/0ul);
syscall(__NR_mmap, /*addr=3D*/0x20000000ul, /*len=3D*/0x1000000ul,
/*prot=3D*/7ul, /*flags=3D*/0x32ul, /*fd=3D*/-1, /*offset=3D*/0ul);
syscall(__NR_mmap, /*addr=3D*/0x21000000ul, /*len=3D*/0x1000ul,
/*prot=3D*/0ul, /*flags=3D*/0x32ul, /*fd=3D*/-1, /*offset=3D*/0ul);

intptr_t res =3D 0;
res =3D openat(AT_FDCWD, "/dev/kvm", O_RDONLY, 0);
if (res !=3D -1)
r[0] =3D res;
res =3D syscall(__NR_ioctl, /*fd=3D*/r[0], /*cmd=3D*/KVM_CREATE_VM, /*type=
=3D*/0ul);
if (res !=3D -1)
r[1] =3D res;
res =3D syscall(__NR_ioctl, /*fd=3D*/r[1], /*cmd=3D*/KVM_CREATE_VCPU, /*id=
=3D*/0ul);
if (res !=3D -1)
r[2] =3D res;

*(uint64_t*)0x20000000 =3D 8;
*(uint64_t*)0x20000008 =3D 0x20000040;
*(uint64_t*)0x20000010 =3D 0x3f;
memcpy((void*)0x20000040,
"\x0f\x08\x2e\x3e\x0f\xaa\x67\x0f\x70\x39\x00\xba\xf8\x0c\x66\xb8\xd8\xfa\x=
7c\x87\x66\xef\xba\xfc\x0c\xb0\x48\xee\x66\x0f\x7d\x29\xff\x71\x0e\xba\xf8\=
x0c\x66\xb8\x34\x12\x43\x8c\x66\xef\xba\xfc\x0c\x66\xed\x0f\x01\xc8\xba\x43=
\x00\xed\x0f\x4c\x80\x00\x48",
63);
syz_kvm_setup_cpu(/*fd=3D*/-1, /*cpufd=3D*/r[2], /*usermem=3D*/0x20fe8000,
/*text=3D*/0x20000000, /*ntext=3D*/1, /*flags=3D*/0x77, /*opts=3D*/0,
/*nopt=3D*/0);

// memcpy((void*)0x20000180, "/dev/kvm\000", 9);
res =3D openat(AT_FDCWD, "/dev/kvm", O_RDONLY, 0);
// res =3D syscall(__NR_openat, /*fd=3D*/0xffffffffffffff9cul,
/*file=3D*/0x20000180ul, /*flags=3D*/0ul, /*mode=3D*/0ul);
if (res !=3D -1)
r[3] =3D res;
res =3D syscall(__NR_ioctl, /*fd=3D*/r[3], /*cmd=3D*/KVM_CREATE_VM, /*type=
=3D*/0ul);
if (res !=3D -1)
r[4] =3D res;
res =3D syscall(__NR_ioctl, /*fd=3D*/r[4], /*cmd=3D*/KVM_CREATE_VCPU, /*id=
=3D*/0ul);
if (res !=3D -1)
r[5] =3D res;
*(uint64_t*)0x20000100 =3D 0x40;
*(uint64_t*)0x20000108 =3D 0;
*(uint64_t*)0x20000110 =3D 0;
syz_kvm_setup_cpu(/*fd=3D*/r[4], /*cpufd=3D*/r[5], /*usermem=3D*/0x20fe8000=
,
/*text=3D*/0x20000100, /*ntext=3D*/1, /*flags=3D*/0x68, /*opts=3D*/0,
/*nopt=3D*/0);

syscall(__NR_ioctl, /*fd=3D*/r[5], /*cmd=3D*/KVM_RUN, /*arg=3D*/0ul);
syscall(__NR_ioctl, /*fd=3D*/r[5], /*cmd=3D*/KVM_SMI, 0);
*(uint64_t*)0x20000140 =3D 8;
*(uint64_t*)0x20000148 =3D 0;
*(uint64_t*)0x20000150 =3D 0;
*(uint64_t*)0x200001c0 =3D 4;
*(uint64_t*)0x200001c8 =3D 6;
*(uint64_t*)0x200001d0 =3D 2;
*(uint64_t*)0x200001d8 =3D 0x2000;
syz_kvm_setup_cpu(/*fd=3D*/r[4], /*cpufd=3D*/r[5], /*usermem=3D*/0x20fe7000=
,
/*text=3D*/0x20000140, /*ntext=3D*/1, /*flags=3D*/0, /*opts=3D*/0x200001c0,
/*nopt=3D*/2);
syscall(__NR_ioctl, /*fd=3D*/r[5], /*cmd=3D*/KVM_RUN, /*arg=3D*/0ul);

return 0;
}

Upon running the PoC, the following log was generated:

[   15.032353][  T210] ------------[ cut here ]------------
[   15.032721][  T210] WARNING: CPU: 1 PID: 210 at
arch/x86/kvm/vmx/nested.c:4733 nested_vmx_vmexit+0x2056/0x3770
[   15.033364][  T210] Modules linked in:
[   15.033587][  T210] CPU: 1 PID: 210 Comm: poc Not tainted 6.6.0+ #7
[   15.033937][  T210] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
[   15.034526][  T210] RIP: 0010:nested_vmx_vmexit+0x2056/0x3770
[   15.043358][  T210]  vcpu_enter_guest+0x571/0x4930
[   15.044476][  T210]  kvm_arch_vcpu_ioctl_run+0x70b/0x29b0
[   15.045423][  T210]  kvm_vcpu_ioctl+0x55f/0xe90
[   15.047243][  T210]  do_syscall_64+0x43/0xf0
[   15.047438][  T210]  entry_SYSCALL_64_after_hwframe+0x6f/0x77
[   15.050852][  T210] ---[ end trace 0000000000000000 ]---

The warning appears to be related to the nested VM exit process, but I
am not intimately familiar with the inner workings of the KVM
subsystem. Any insights or guidance on how to approach this issue
would be greatly appreciated.

Thank you for your time and assistance.

Best regards,
Zheyu Ma

