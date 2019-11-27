Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7539910AC81
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 10:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfK0JQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 04:16:12 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40452 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfK0JQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 04:16:12 -0500
Received: by mail-wm1-f65.google.com with SMTP id y5so6517236wmi.5;
        Wed, 27 Nov 2019 01:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:mime-version:subject:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0BJv2rQbPmyg5RLJ0rIFY2UVBNyGhHyWWhsLwcSjmkw=;
        b=nSZ3oe7rGfunTsIADaXep5nf0AVArP4+QUSLzHg3Zxhg3saLVVO1ePhbPEGks6WEZs
         9dqD9tfG+yzDGeBsdmXG8LXSIWpPIYdGo7QTQw8mkEaTcy6mWmL9BVHwhwEr7dYhcKZ2
         vSTILlHO48dT1dcLT/JhexUE8jbP0NEn0LNP74+Mnz9KVclEWSD1OAv3i9CpgZpYs4hX
         J9Qpyub5aKpfTIJX+lhTWjkX+E3U081ZOQe8Tl+I+xC5+DdBbFuwB8HFAJshTfw8sJLw
         5BUjHMr+PL28OiryIOVxiiXCLYbOSkOW/lfnLuTvTadHdHFgNnbT14f5/olxfaOH0mOr
         MENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:mime-version:subject:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0BJv2rQbPmyg5RLJ0rIFY2UVBNyGhHyWWhsLwcSjmkw=;
        b=df1XXr4TTOK1SPUv0mZQyG5SxWRVh0jYA5GLquSN6QwKJEul9cFnMTrkyTrIYcdhqG
         W8GSd/Tmzhe1oGfQGWfJFp2kMRUO9DOFkYzDkyZnyE2jx8GnXtTCSdos7OkJujt8EWF0
         MebspGADE45bwlaxqD824fqzILxwwCl/IwwYtDy9i4T6n8uPOvbWfeVY3tZjDaGqYzlK
         JKdG9n0uQsP/vYA5qwef3uY+tDiX2M2rZOcsp8ejm9w3xzLmYQ8zST+1orJY4jSKe1bl
         JpJ1nDriCwmhcFWMHSfDTFj9HTDkEPEG978IYB/XuQLlX613MeYqLVRL2G9/nNVa3+UY
         dfOw==
X-Gm-Message-State: APjAAAW3739nuLxOK5ZnZNMwxQmlHde2+lYdVMt2V+woYIC7DZKDJs5P
        JQzwTlA8Cv6qT8sSK9J3RYo=
X-Google-Smtp-Source: APXvYqz025JqnWIO/Ncq+bSOi5sEijFLwElB0JpU6k1dNwDRd2yHM90gSYSczd60PcPiIw01pcQnew==
X-Received: by 2002:a1c:5603:: with SMTP id k3mr3512995wmb.150.1574846169501;
        Wed, 27 Nov 2019 01:16:09 -0800 (PST)
Received: from ?IPv6:2a01:e0a:466:71c0:9917:620f:cb41:ebf9? ([2a01:e0a:466:71c0:9917:620f:cb41:ebf9])
        by smtp.gmail.com with ESMTPSA id g21sm19975431wrb.48.2019.11.27.01.16.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 01:16:08 -0800 (PST)
From:   Christophe de Dinechin <christophe.de.dinechin@gmail.com>
X-Google-Original-From: Christophe de Dinechin <christophe@dinechin.org>
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v2] KVM: SVM: Fix "error" isn't initialized
In-Reply-To: <2967bd12-21bf-3223-e90b-96b4eaa8c4c2@gmail.com>
Date:   Wed, 27 Nov 2019 10:16:02 +0100
Cc:     "x86@kernel.org" <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        thomas.lendacky@amd.com, gary.hook@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Content-Transfer-Encoding: quoted-printable
Message-Id: <592F6B37-93C9-4184-BCFF-3B25AF4F7562@dinechin.org>
References: <2967bd12-21bf-3223-e90b-96b4eaa8c4c2@gmail.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 27 Nov 2019, at 08:23, Haiwei Li <lihaiwei.kernel@gmail.com> wrote:
>=20
> =46rom e7f9c786e43ef4f890b8a01f15f8f00786f4b14a Mon Sep 17 00:00:00 =
2001
> From: Haiwei Li <lihaiwei@tencent.com>
> Date: Wed, 27 Nov 2019 15:00:49 +0800
> Subject: [PATCH v2] fix: 'error' is not initialized
>=20
> There are a bunch of error paths were "error" isn't initialized.
>=20
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> arch/x86/kvm/svm.c           | 3 ++-
> drivers/crypto/ccp/psp-dev.c | 2 ++
> 2 files changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 362e874..9eef6fc 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -6308,7 +6308,8 @@ static int sev_flush_asids(void)
> 	up_write(&sev_deactivate_lock);
>=20
> 	if (ret)
> -		pr_err("SEV: DF_FLUSH failed, ret=3D%d, error=3D%#x\n", =
ret, error);
> +		pr_err("SEV: DF_FLUSH failed, ret=3D%d. PSP returned =
error=3D%#x\n",
> +		       ret, error);

This specific text change does not seem to match the patch description.

>=20
> 	return ret;
> }
> diff --git a/drivers/crypto/ccp/psp-dev.c =
b/drivers/crypto/ccp/psp-dev.c
> index 39fdd06..c486c24 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -155,6 +155,8 @@ static int __sev_do_cmd_locked(int cmd, void =
*data, int *psp_ret)
> 	unsigned int phys_lsb, phys_msb;
> 	unsigned int reg, ret =3D 0;
>=20
> +	*psp_ret =3D -1;
> +
> 	if (!psp)
> 		return -ENODEV;
>=20
> --
> 1.8.3.1

