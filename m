Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7641B5A813
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2019 04:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfF2CAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 22:00:06 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38168 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfF2CAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 22:00:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id d18so8020119wrs.5
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2019 19:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=B6AU7P+P8rUKmkNdP6DqwNn/o4U3fMkGuLeRgUtB+yQ=;
        b=GGmds0IOmE8ZB38UglMsEupeJbpcClHv13k0ZGdgR+6htdz21WdmCiSEszgQeQNnFf
         c24OPjoId6tEIGrdclGZCp9YjhhkZ3I30nolPwYybR237YfuXqELWSJxOJVAqfcuTiI5
         Nyq00nRx75Mxjh7DDfk9gfqOTYwW9Jc6sYKqk6tcBXQ4ojgjuBsIHEloceNEMNGPwAO/
         LW3iIiOpHp5yReTxtQXg3o03koxNRG3FIz9WKfPykn+Jjchot+TheA0izOD/3q/2o5nI
         9mSBDs9FA4p2YFSMqkOUXPU7/RM0MAoR6fguDQLcWJ/B920GpEAAroHjwX5/IeAR0Riy
         lv+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=B6AU7P+P8rUKmkNdP6DqwNn/o4U3fMkGuLeRgUtB+yQ=;
        b=ajvUn41cVTVN8jQBMgaD+ed2nGsdVM6b1HZXOq6LdRY4yDBIbkTjKW7yrC5dRgKtCb
         zw2PIBMit/Se2YW3j9AX/5D0crw0V+xv3uxKk0phvOM37j/geGSoDpcZVD1HRH3P+DuG
         4TOohiExlefmyCNLmjjPCjcXZElWJLvHjx7n9ZF3+bmZE1kyEU1I9NcrXeZVpI1fXLS3
         1YL6CrgflM0K8eYHjGvnOs9vUY8dTFoPN5XQH9GJXlDRqsKngW0COghomLztnnZMFdf3
         c6/34dFQ2f6BEmDM0FPcY6dCkthE2PbnMhsrJKaq1tGoy3gl3lozdUUneJCCXY/VnzLL
         eeZA==
X-Gm-Message-State: APjAAAWhZKdcmYJdlQylnl6b94jolEnCBEbiBiooZYli4gFT6zw4ovmC
        Sw3nA2xD3Jyee07kFVs0zKs=
X-Google-Smtp-Source: APXvYqxfas246PIazPejgcyvhEzmya8xsD38Spddss9oHA/gkcg8TtDKwp9ZZzADYxrle84MOjm76A==
X-Received: by 2002:a5d:5302:: with SMTP id e2mr9500761wrv.347.1561773603637;
        Fri, 28 Jun 2019 19:00:03 -0700 (PDT)
Received: from [10.33.114.148] ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id o20sm9178022wrh.8.2019.06.28.19.00.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 19:00:02 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH 2/2] kvm-unit-test nVMX: Test Host Segment Registers and
 Descriptor Tables on vmentry of nested guests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190628221447.23498-3-krish.sadhukhan@oracle.com>
Date:   Fri, 28 Jun 2019 19:00:00 -0700
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com, pbonzini@redhat.com,
        jmattson@google.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <5F6321E0-0F9F-464B-B20B-2A6669C7C76E@gmail.com>
References: <20190628221447.23498-1-krish.sadhukhan@oracle.com>
 <20190628221447.23498-3-krish.sadhukhan@oracle.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 28, 2019, at 3:14 PM, Krish Sadhukhan =
<krish.sadhukhan@oracle.com> wrote:
>=20
> According to section "Checks on Host Segment and Descriptor-Table
> Registers" in Intel SDM vol 3C, the following checks are performed on
> vmentry of nested guests:
>=20
>    - In the selector field for each of CS, SS, DS, ES, FS, GS and TR, =
the
>      RPL (bits 1:0) and the TI flag (bit 2) must be 0.
>    - The selector fields for CS and TR cannot be 0000H.
>    - The selector field for SS cannot be 0000H if the "host =
address-space
>      size" VM-exit control is 0.
>    - On processors that support Intel 64 architecture, the =
base-address
>      fields for FS, GS, GDTR, IDTR, and TR must contain canonical
>      addresses.
>=20
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
> lib/x86/processor.h |   5 ++
> x86/vmx_tests.c     | 159 ++++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 164 insertions(+)
>=20
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 4fef0bc..c6edc26 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -461,6 +461,11 @@ static inline void write_pkru(u32 pkru)
>         : : "a" (eax), "c" (ecx), "d" (edx));
> }
>=20
> +static u64 make_non_canonical(u64 addr)
> +{
> +	return (addr | 1ull << 48);
> +}

You may wan to make it =E2=80=9Cstatic inline=E2=80=9D. On my system I =
get:

processor.h:464:12: error: =E2=80=98make_non_canonical=E2=80=99 defined =
but not used [-Werror=3Dunused-function]

