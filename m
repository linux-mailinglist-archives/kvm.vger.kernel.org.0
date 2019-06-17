Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E257149561
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 00:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfFQWqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 18:46:32 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37995 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfFQWqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 18:46:32 -0400
Received: by mail-pg1-f193.google.com with SMTP id v11so6557150pgl.5
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 15:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RHH9aETgrxKTQtMIcKoGTFH6Rs7uSfSEU18DzXBZvzA=;
        b=RBavaWFTZjH/eavqccZoCAQRXwFGHtIFY+rhbjfpRu293TG63KvD4YgLoOE0EtVuPU
         WgtdXjgREcX7iwJBnixNyeywCWGCbRq/9VptaalNU+kxWl2MAcpuqNvZeJgGcL91tLH9
         VuhwTHbjDTWaaOzDlO2tKptnnahDIGbc19YOQPrFjdqev1jpqYU1ggDVNI3du7OGyEB8
         fgwvxLwLYEupGkKXQIXybteCE78HyxzHWMIsHywKSGjzu9NXK48GAnwmwIHWUiEh+o2k
         ToK79P17zb9ef9T68/7MOOQ8coTEApKisEfjeCC51PBvQMyUIeWdAl0x6yBzG17hstWd
         3jGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RHH9aETgrxKTQtMIcKoGTFH6Rs7uSfSEU18DzXBZvzA=;
        b=D/VWrmlawg0ZokKCl7T+PRyYg/ORRnhCc0TGJSTtMCi5Q+DHhIhbvrbDzgQmux35Ol
         4LuTGNbkIDyeXFK0YEo7v7woARdu7pTFG6i8yyPgNRtSqpMQHhPDwf2yByxTV0bH2Y7g
         VfM+tx4lprO0dQP6IzvY929PwaVupTVtNoue4xDFt/JjYp8bX++0IayErbIRHIgCEuer
         Ps/Ad5F4IVxvVX2iG/Ty1P3mCLuWjn11QC+ofeXEz1JvYx7vLivRUjwvEpnimYklcGh2
         ZA1F8IMFqNkzZaR6QsKGc7jvNaJjN/l0CCM4sNPPEJUDuAlu4zaRuBE4TXiN+82p5/5R
         Dvmw==
X-Gm-Message-State: APjAAAVHWUjTv16OInsITg63Ky4r9tHHQDvdTNWw35R/0vlKhp4DWWXv
        CULvnon4OAkhmhEnQP2jDCU/wjIS
X-Google-Smtp-Source: APXvYqyvXnNnlUl8odBG7mSpq0w4Wu0+h7G7INjDlDvq4nXRm9h1jlAVrEgW5iqPUBbU8zrmKJUQmA==
X-Received: by 2002:a17:90a:23a4:: with SMTP id g33mr1558869pje.115.1560811591651;
        Mon, 17 Jun 2019 15:46:31 -0700 (PDT)
Received: from [10.33.114.148] ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id m19sm19214001pff.153.2019.06.17.15.46.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 15:46:31 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Mask undefined bits in exit
 qualifications
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <720b1ba2-11aa-6baf-9f21-aa3e1e324afa@oracle.com>
Date:   Mon, 17 Jun 2019 15:46:28 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <09CF02B6-D229-479C-A3A2-56D50E030BF9@gmail.com>
References: <20190503174919.13846-1-nadav.amit@gmail.com>
 <A9500030-816E-49F7-84C7-6176C722C2B0@gmail.com>
 <720b1ba2-11aa-6baf-9f21-aa3e1e324afa@oracle.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 17, 2019, at 3:22 PM, Krish Sadhukhan =
<krish.sadhukhan@oracle.com> wrote:
>=20
>=20
>=20
> On 06/17/2019 12:52 PM, Nadav Amit wrote:
>>> On May 3, 2019, at 10:49 AM, nadav.amit@gmail.com wrote:
>>>=20
>>> From: Nadav Amit <nadav.amit@gmail.com>
>>>=20
>>> On EPT violation, the exit qualifications may have some undefined =
bits.
>>>=20
>>> Bit 6 is undefined if "mode-based execute control" is 0.
>>>=20
>>> Bits 9-11 are undefined unless the processor supports advanced =
VM-exit
>>> information for EPT violations.
>>>=20
>>> Right now on KVM these bits are always undefined inside the VM =
(i.e., in
>>> an emulated VM-exit). Mask these bits to avoid potential false
>>> indication of failures.
>>>=20
>>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>>> ---
>>> x86/vmx.h       | 20 ++++++++++++--------
>>> x86/vmx_tests.c |  4 ++++
>>> 2 files changed, 16 insertions(+), 8 deletions(-)
>>>=20
>>> diff --git a/x86/vmx.h b/x86/vmx.h
>>> index cc377ef..5053d6f 100644
>>> --- a/x86/vmx.h
>>> +++ b/x86/vmx.h
>>> @@ -603,16 +603,20 @@ enum vm_instruction_error_number {
>>> #define EPT_ADDR_MASK		GENMASK_ULL(51, 12)
>>> #define PAGE_MASK_2M		(~(PAGE_SIZE_2M-1))
>>>=20
>>> -#define EPT_VLT_RD		1
>>> -#define EPT_VLT_WR		(1 << 1)
>>> -#define EPT_VLT_FETCH		(1 << 2)
>>> -#define EPT_VLT_PERM_RD		(1 << 3)
>>> -#define EPT_VLT_PERM_WR		(1 << 4)
>>> -#define EPT_VLT_PERM_EX		(1 << 5)
>>> +#define EPT_VLT_RD		(1ull << 0)
>>> +#define EPT_VLT_WR		(1ull << 1)
>>> +#define EPT_VLT_FETCH		(1ull << 2)
>>> +#define EPT_VLT_PERM_RD		(1ull << 3)
>>> +#define EPT_VLT_PERM_WR		(1ull << 4)
>>> +#define EPT_VLT_PERM_EX		(1ull << 5)
>>> +#define EPT_VLT_PERM_USER_EX	(1ull << 6)
>>> #define EPT_VLT_PERMS		(EPT_VLT_PERM_RD | =
EPT_VLT_PERM_WR | \
>>> 				 EPT_VLT_PERM_EX)
>>> -#define EPT_VLT_LADDR_VLD	(1 << 7)
>>> -#define EPT_VLT_PADDR		(1 << 8)
>>> +#define EPT_VLT_LADDR_VLD	(1ull << 7)
>>> +#define EPT_VLT_PADDR		(1ull << 8)
>>> +#define EPT_VLT_GUEST_USER	(1ull << 9)
>>> +#define EPT_VLT_GUEST_WR	(1ull << 10)
>=20
> This one should be named EPT_VLT_GUEST_RW, assuming you are naming =
them
> according to the 1-setting of the bits.

Whatever you wish (unless someone else has different preference).

>>> +#define EPT_VLT_GUEST_EX	(1ull << 11)
>>>=20
>>> #define MAGIC_VAL_1		0x12345678ul
>>> #define MAGIC_VAL_2		0x87654321ul
>>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>>> index c52ebc6..b4129e1 100644
>>> --- a/x86/vmx_tests.c
>>> +++ b/x86/vmx_tests.c
>>> @@ -2365,6 +2365,10 @@ static void do_ept_violation(bool leaf, enum =
ept_access_op op,
>>>=20
>>> 	qual =3D vmcs_read(EXI_QUALIFICATION);
>>>=20
>>> +	/* Mask undefined bits (which may later be defined in certain =
cases). */
>>> +	qual &=3D ~(EPT_VLT_GUEST_USER | EPT_VLT_GUEST_WR | =
EPT_VLT_GUEST_EX |
>>> +		 EPT_VLT_PERM_USER_EX);
>>> +
>=20
> The "DIAGNOSE" macro doesn't check any of these bits, so this masking
> seems redundant.

The DIAGNOSE macro is not the one who causes errors. It=E2=80=99s the:

  TEST_EXPECT_EQ(expected_qual, qual);

That comes right after the call to diagnose_ept_violation_qual().

>=20
> Also, don't we need to check for the relevant conditions before =
masking
> the bits ? For example, EPT_VLT_PERM_USER_EX is dependent on =
"mode-based
> execute control" VM-execution control" and the other ones depend on =
bit 7
> and 8 of the Exit Qualification field.

The tests right now do not =E2=80=9Cemulate=E2=80=9D these bits, so the =
expected
qualification would never have EPT_VLT_PERM_USER_EX (for instance) set. =
Once
someone implements tests for these bits, he would need to change the
masking.

