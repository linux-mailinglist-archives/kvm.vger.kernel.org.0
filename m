Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8D14908F
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 21:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbfFQTwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 15:52:08 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40036 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbfFQTwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 15:52:08 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so1723387pgj.7
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 12:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Huzwtb9vesUkS4OtmonBXYpBsORXGoOdaahU36ku800=;
        b=WpJ/W1wSYr2drIRBhEYIYKhVmyx4Cu+Fo/DaOeHqyLYpTLnWf28rjnS2kmk6h6NvXJ
         dlmVWe4nxPmdZlBkPvXUhN7iCJuh05GqXepK8RF8odlONnjtbhayZB2ZJ5T/pkLWydCo
         nOr/JdDo0XOPGDwTJWpV8dwy5F4zaYjRYabePODcKXNsEg3TcTpjPoSHWGIuy5G9IbX4
         xbsmuUrS7+aVQScMTcyDKwvk1MhKYlkEykNt6+KiKYKbu8euofZ3QA7imvP/6rPXd3/J
         Y8QXi7wMX11TaWv+ZP5kOa8AOPYBfkMmSX2r5cov2zF0MTQj8wDnbq8eerWIIbx16Qyp
         mD/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Huzwtb9vesUkS4OtmonBXYpBsORXGoOdaahU36ku800=;
        b=KPkFDQdDlvv7R+QCNrFxvay26gmjsegN0z88M/MS2TeLbtH0FQ9lKrBj+TVFjjODe9
         l/IRJO3f639PR/+qFcYrBTCTtLFeaJbL6zUfkrNXOC8qP01aZPb7FDnhwhCvlo2VO/at
         GrSQVEbz/Yy8G7ReHSWUuwSxlsq4d1Z/kvV1GiMkVGLzYlgubE+aL23OGdijHD1hb/wt
         fcchR4iRwrHLcBbqG9ECJwwhbFMa7eeHzjPdO7ZCohaTEZLq52NW5LL6HhngCbhFF/oy
         bw27NVwFKQYggH5rcwP5EIZ8BRg8Ew1Ld9+qdNzB1meBeMx7Jexgd4vqogiF5NtTaanW
         v25Q==
X-Gm-Message-State: APjAAAVVQ1gHE5Hgr2W3+QGPSkpa4kolnizWTW3V+34cQtfnN6j+k0VP
        qP3m5aCcuOYWcotiEsGwtCdg2L3U
X-Google-Smtp-Source: APXvYqzob8UNpdUk8t4WCUPcq0mBa+cxJs/QOITO6FkFoA41eat/SiDloHdUsblkdMUPDI6oVPvUhw==
X-Received: by 2002:a17:90a:21ac:: with SMTP id q41mr670101pjc.31.1560801127227;
        Mon, 17 Jun 2019 12:52:07 -0700 (PDT)
Received: from [10.33.114.148] ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id v28sm13915152pga.65.2019.06.17.12.52.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 12:52:06 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Mask undefined bits in exit
 qualifications
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190503174919.13846-1-nadav.amit@gmail.com>
Date:   Mon, 17 Jun 2019 12:52:05 -0700
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A9500030-816E-49F7-84C7-6176C722C2B0@gmail.com>
References: <20190503174919.13846-1-nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 3, 2019, at 10:49 AM, nadav.amit@gmail.com wrote:
>=20
> From: Nadav Amit <nadav.amit@gmail.com>
>=20
> On EPT violation, the exit qualifications may have some undefined =
bits.
>=20
> Bit 6 is undefined if "mode-based execute control" is 0.
>=20
> Bits 9-11 are undefined unless the processor supports advanced VM-exit
> information for EPT violations.
>=20
> Right now on KVM these bits are always undefined inside the VM (i.e., =
in
> an emulated VM-exit). Mask these bits to avoid potential false
> indication of failures.
>=20
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
> x86/vmx.h       | 20 ++++++++++++--------
> x86/vmx_tests.c |  4 ++++
> 2 files changed, 16 insertions(+), 8 deletions(-)
>=20
> diff --git a/x86/vmx.h b/x86/vmx.h
> index cc377ef..5053d6f 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -603,16 +603,20 @@ enum vm_instruction_error_number {
> #define EPT_ADDR_MASK		GENMASK_ULL(51, 12)
> #define PAGE_MASK_2M		(~(PAGE_SIZE_2M-1))
>=20
> -#define EPT_VLT_RD		1
> -#define EPT_VLT_WR		(1 << 1)
> -#define EPT_VLT_FETCH		(1 << 2)
> -#define EPT_VLT_PERM_RD		(1 << 3)
> -#define EPT_VLT_PERM_WR		(1 << 4)
> -#define EPT_VLT_PERM_EX		(1 << 5)
> +#define EPT_VLT_RD		(1ull << 0)
> +#define EPT_VLT_WR		(1ull << 1)
> +#define EPT_VLT_FETCH		(1ull << 2)
> +#define EPT_VLT_PERM_RD		(1ull << 3)
> +#define EPT_VLT_PERM_WR		(1ull << 4)
> +#define EPT_VLT_PERM_EX		(1ull << 5)
> +#define EPT_VLT_PERM_USER_EX	(1ull << 6)
> #define EPT_VLT_PERMS		(EPT_VLT_PERM_RD | EPT_VLT_PERM_WR | \
> 				 EPT_VLT_PERM_EX)
> -#define EPT_VLT_LADDR_VLD	(1 << 7)
> -#define EPT_VLT_PADDR		(1 << 8)
> +#define EPT_VLT_LADDR_VLD	(1ull << 7)
> +#define EPT_VLT_PADDR		(1ull << 8)
> +#define EPT_VLT_GUEST_USER	(1ull << 9)
> +#define EPT_VLT_GUEST_WR	(1ull << 10)
> +#define EPT_VLT_GUEST_EX	(1ull << 11)
>=20
> #define MAGIC_VAL_1		0x12345678ul
> #define MAGIC_VAL_2		0x87654321ul
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index c52ebc6..b4129e1 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -2365,6 +2365,10 @@ static void do_ept_violation(bool leaf, enum =
ept_access_op op,
>=20
> 	qual =3D vmcs_read(EXI_QUALIFICATION);
>=20
> +	/* Mask undefined bits (which may later be defined in certain =
cases). */
> +	qual &=3D ~(EPT_VLT_GUEST_USER | EPT_VLT_GUEST_WR | =
EPT_VLT_GUEST_EX |
> +		 EPT_VLT_PERM_USER_EX);
> +
> 	diagnose_ept_violation_qual(expected_qual, qual);
> 	TEST_EXPECT_EQ(expected_qual, qual);
>=20
> --=20
> 2.17.1

Ping.

