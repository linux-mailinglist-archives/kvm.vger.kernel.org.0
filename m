Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7479A418
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 01:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfHVXzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 19:55:18 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41205 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbfHVXzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 19:55:17 -0400
Received: by mail-pg1-f195.google.com with SMTP id x15so4619130pgg.8
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2019 16:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=z4yDcghNcw1SKteBtQw+hsJxYgZah2OQIvghQp7Qk9E=;
        b=T4UhEcimAmeRVbXC5umZnoY5gGcEVevMBpLDoLBk6A5w+BQuJRODa24WEZMH2pp2s2
         1LtGEi4e0L0YVANmPgT7tswnTCMJEGpGgI2PKsYCFOIE5Ob6AouGdnaZjK2V6GNWSkj4
         lNBEZz3teB+gEu/VT8tZK8oWafGWGzQSaH5IyEVZwvKYxsul+WuZv19m9XGO4wkxiRJ/
         Cx9qLowucqwQLgt6DFoDuuhxEw6Fo1ItRfpoq9MBWssUdPHadlpDo0qPt6x5BMUj11IX
         W73/XfffCIqGchmzLpk0vWMvcsUM18SIUHCQ/eaELp27052DFxHl8XBQy4a2eOmnGy2I
         96Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=z4yDcghNcw1SKteBtQw+hsJxYgZah2OQIvghQp7Qk9E=;
        b=nMjxmV0wT+wyeARvfjxrg7mTWomI+kT5X4a5EX3jDMggs5qgW9buwaxrlejyvfn2b4
         5P1YCDs2AAbEWG1g1Pw4LpaPX1zjsdKm8tEM9DJJKKUBGmVFE8ZKXeFxaBBP/vx2fc52
         GKXYZdzRYkZF5BhQHZpq8Uxa1TT90Q9nwVuIzzB7uD+DdN/jlkeI+sXeY9ku9A8V2sAm
         RtT18reX1bMMU5zcYdbogCefO+ZURCxgOEUJcVkSQnl2cV2OQz9FOdHADf9YePrPZkEO
         NkdyePApemcP5IIGp7OUArYHwq5iEN9GRyc4Q2Z9Ho8E4gi7UjbfqaASwTIbacOdqjqk
         9meg==
X-Gm-Message-State: APjAAAUe3q0wUiGcXLA31n3fVPYuQCz4TscKFtPYxfbHtMyvb/sgWk2W
        CZzIiIBHRKR3GlYGKWUopzpHXUugeM8=
X-Google-Smtp-Source: APXvYqw5jz0NtXsA/9CihhefHV7xKR+eHuQ6j7vjudVgdtWuu/It7XQoU6qzLIK2MPqKA953kV1M0g==
X-Received: by 2002:a62:1d57:: with SMTP id d84mr1864014pfd.99.1566518116725;
        Thu, 22 Aug 2019 16:55:16 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id 65sm355725pgf.30.2019.08.22.16.55.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 16:55:15 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH] x86: Fix breakage of fw_cfg for 32-bit
 unit tests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190822235052.3703-1-sean.j.christopherson@intel.com>
Date:   Thu, 22 Aug 2019 16:55:14 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DCA6E594-72DC-43AD-A490-BAEC1DE85F7E@gmail.com>
References: <20190822235052.3703-1-sean.j.christopherson@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Aug 22, 2019, at 4:50 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> Ensure the fw_cfg overrides are parsed prior consuming any of said
> overrides.  fwcfg_get_u() treats zero as a valid overide value, which
> is slightly problematic since the overrides are in the .bss and thus
> initialized to zero.
>=20
> Add a limit check when indexing fw_override so that future code =
doesn't
> spontaneously explode.
>=20
> Cc: Nadav Amit <nadav.amit@gmail.com>
> Fixes: 03b1e4570f967 ("x86: Support environments without =
test-devices")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> lib/x86/fwcfg.c | 10 ++++++++--
> lib/x86/fwcfg.h |  2 --
> x86/cstart64.S  |  2 --
> 3 files changed, 8 insertions(+), 6 deletions(-)
>=20
> diff --git a/lib/x86/fwcfg.c b/lib/x86/fwcfg.c
> index d8d797f..06ef62c 100644
> --- a/lib/x86/fwcfg.c
> +++ b/lib/x86/fwcfg.c
> @@ -5,10 +5,11 @@
> static struct spinlock lock;
>=20
> static long fw_override[FW_CFG_MAX_ENTRY];
> +static bool fw_override_done;
>=20
> bool no_test_device;
>=20
> -void read_cfg_override(void)
> +static void read_cfg_override(void)
> {
> 	const char *str;
> 	int i;
> @@ -26,6 +27,8 @@ void read_cfg_override(void)
>=20
> 	if ((str =3D getenv("TEST_DEVICE")))
> 		no_test_device =3D !atol(str);
> +
> +    fw_override_done =3D true;
> }
>=20
> static uint64_t fwcfg_get_u(uint16_t index, int bytes)
> @@ -34,7 +37,10 @@ static uint64_t fwcfg_get_u(uint16_t index, int =
bytes)
>     uint8_t b;
>     int i;
>=20
> -    if (fw_override[index] >=3D 0)
> +    if (!fw_override_done)
> +        read_cfg_override();
> +
> +    if (index < FW_CFG_MAX_ENTRY && fw_override[index] >=3D 0)
> 	    return fw_override[index];

How did that happen? I remember I tested this code with KVM..

Anyhow,

Reviewed-by: Nadav Amit <nadav.amit@gmail.com>

Thanks for fixing it.

