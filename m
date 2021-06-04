Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B670739B0B5
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 05:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhFDDIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 23:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhFDDIB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 23:08:01 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272A6C06174A
        for <kvm@vger.kernel.org>; Thu,  3 Jun 2021 20:06:10 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id r1so6704987pgk.8
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 20:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=pFoJDXCcwtiraqeuMDPU4cxFPAA0BggiQ26De9dZdOg=;
        b=atlaYC8JWePjkUnrFPU7myy5AMKAtjjHhkN9JucKtFVeEDUizcoYN52+6yHUEXHCtS
         NybbbHuGTMJdpgIVbOehWi8MqSxrkh3jWuTmkCaQs5EP6vZ13oUrYeol+GUpie3zqTdt
         dAt0r0LnLDJqh+jcyNzbdXalA+XdVNDBAe0aSO8trXeGfpzaGfX7Plv7P2eTKVlbeOo9
         6Z16Czgu6BmyWL+ZKIS1n+5NE59zNSPCU0J5qNhoh1T4bwRGEF+I7wLT2hMBm9qf1CXx
         gygfXkgmABdmggzzGYo32AL/SloMsIrhl0AUk3hZq5NddGqg3W3aJSh9Xb7M+f1Ih2oY
         3wMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=pFoJDXCcwtiraqeuMDPU4cxFPAA0BggiQ26De9dZdOg=;
        b=dlbRTtriCrxDw2oQnUjDKVZqtf7w0IyQ4rD/+VdMC+wHcZ6dJCAqjutq/X+xoPPWMh
         q+WzzHeuHTDJJOAN6fiq12+ct6mOAZcsudYZlnQ0kjjhzqFpuCUF7piDsccce4loL/1X
         S3u2rWUq7FV3+5JIuSRX5eKTDNAzaGLnvMmsDQLq8fAzFze58jkEcQVZLZ5vKX1Mu3IQ
         UlU86cx9VNjNkHf5OCJGgX3HAkXw/qKzCnbmsOS4WDRee3P30PzbtIjzLZ6fADRFVsi2
         BlXKAe8GohB1L3bbO0yIs7S+ZZkrauiVluibn1x9YZekP7dXjy4rICuxu/X5r78v3QAK
         tt/Q==
X-Gm-Message-State: AOAM533NaKcbWXg/W8pzBXb09xPmIiM8IRg8Jmgovn8kuK398n5tG3ZQ
        bLQmXNfCyN/nCkaUlvbZkzbhfVqALtwihQ==
X-Google-Smtp-Source: ABdhPJxlIoBDqSE6/w7zJB0azeKnNeEu2VWNWBSpw+APrfjc1z3RyHf4EDyvtuaywc3ToYHuhhfUIg==
X-Received: by 2002:a65:5bc6:: with SMTP id o6mr2662787pgr.364.1622775969432;
        Thu, 03 Jun 2021 20:06:09 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id a12sm388830pfg.102.2021.06.03.20.06.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Jun 2021 20:06:08 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: Create ISO images according to
 unittests.cfg
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20210604023453.905512-2-yi.sun@intel.com>
Date:   Thu, 3 Jun 2021 20:06:07 -0700
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <30FA4AAE-DBC9-4DB7-8742-079F2B3067C3@gmail.com>
References: <20210604023453.905512-1-yi.sun@intel.com>
 <20210604023453.905512-2-yi.sun@intel.com>
To:     Yi Sun <yi.sun@intel.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 3, 2021, at 7:34 PM, Yi Sun <yi.sun@intel.com> wrote:
>=20
> Create ISO image according to the configure file unittests.cfg,
> where describes the parameters of each test case.
>=20

Looks cool!

> diff --git a/x86/create_iso.sh b/x86/create_iso.sh
> new file mode 100755
> index 0000000..8486be7
> --- /dev/null
> +++ b/x86/create_iso.sh
> @@ -0,0 +1,71 @@
> +#!/bin/bash
> +set -e
> +config_file=3D$1
> +
> +opts=3D
> +extra_params=3D
> +kernel=3D
> +smp=3D
> +testname=3D
> +
> +
> +grub_cfg() {
> +
> +	kernel_elf=3D$1
> +	kernel_para=3D$2
> +
> +	cat << EOF
> +set timeout=3D0
> +set default=3D0
> +
> +
> +menuentry "${kernel_elf}" {
> +    multiboot /boot/${kernel_elf} ${kernel_para}

Any chance you can add an optional =E2=80=9Cmodule=E2=80=9D command =
here, that
would be configurable as a parameter to create_iso.sh?

I use such a command to provide parameters that kvm-unit-tests
usually gets from the =E2=80=9Cfirmware" (and therefore are not =
available
in certain environments).=20

The =E2=80=9Cmodule=E2=80=9D can look something like:
	NR_CPUS=3D56
	MEMSIZE=3D4096
	TEST_DEVICE=3D0
	BOOTLOADER=3D1=20

(kvm-unit-tests already knows to use these values)

This =E2=80=9Cmodule" would need to be copied into build/isofiles/boot =
as
well.

