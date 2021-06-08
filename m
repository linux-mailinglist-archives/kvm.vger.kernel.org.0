Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C000439EF60
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 09:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhFHHVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 03:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhFHHVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 03:21:24 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5EBC061574
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 00:19:31 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id fy24-20020a17090b0218b029016c5a59021fso6976896pjb.0
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 00:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=BYIHhnbEftU9L5M9rE951OO1C9RY9eOOUQzLQx6ekd4=;
        b=uhte3pQi+Ss6i9sXbwf28T9MxC7ywMaahpOQdJAEt+OOkcjWiUA9toLg0nD+ITbPcf
         kH9XXWB9jMUfBKa9FFN6lyNOnm1bMAzSiTRcJBDgqKb+u0PtcDyB6udc6dfNtqFJymYk
         yCZOslOlpQmZE7QnjdMZyC8O9oypl21GvHtykXXZ10Crdb5OPiUor8dc3SN6CQQb1KcQ
         hrVec+i8pIlUHk859F/+vQbJF4evT4ISbMi6RQadY13JIuvRq8fPCjNpn6aB8DKwG9gL
         tm8jOLBmWAtf6EpeWJpSpGB0yn6j2r33vMQ5yBD+73Mkm4aPaJ9s3Dnf1n+alw0Ou6aJ
         QhlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=BYIHhnbEftU9L5M9rE951OO1C9RY9eOOUQzLQx6ekd4=;
        b=tUz/j4mKOWUI/vAiR2Vlw6fMYybVHV2PCTGvv3v9F0XNmbMMcWW4ryXdIaD4NFSdqu
         eDrEiHzyrBceqchqSR8g3RY+FSB8Eb/qGplfOD9ZUvTvQ2HfgBSvzc89gM9QDzJBjZIu
         0hgy784byOlDvqwN0HMV/5RGV2yV0I8Jbo4AxjbevvhnGgO1EjjaJ1PIyYORSdz/qjhh
         7Xohr2N/8JPkMGl/Q16n/dRRIOkubkaE7JSL59a3HO9tm8i0oU27wd2/rpmU8TVb1lfc
         zswXhdM4nqnGyIsFlA/6fb6HanD7RoVq9IAAH3ycp9n3xqdLRkaPn1Jpyizxa7TVcwYN
         1ZLA==
X-Gm-Message-State: AOAM531C47dCN9tj2e+V4Eht+jOn92QJDHdcLqBl9iogkDSET8rzIof/
        Hq1EWbJKFxAab9YIyEh1uoo=
X-Google-Smtp-Source: ABdhPJwViVh0eGks268vJisWly5eiVDTuTGWrxBUJbW7Fh6gCTS+1ZluwOXbboNceyCtOh0K1KVl2g==
X-Received: by 2002:a17:902:6b04:b029:10d:8c9e:5f56 with SMTP id o4-20020a1709026b04b029010d8c9e5f56mr21782584plk.8.1623136771041;
        Tue, 08 Jun 2021 00:19:31 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id c20sm1429608pjr.35.2021.06.08.00.19.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jun 2021 00:19:30 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [kvm-unit-tests PATCH 2/2 v2] x86: Create ISO images according to
 unittests.cfg
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20210606080004.1112859-2-yi.sun@intel.com>
Date:   Tue, 8 Jun 2021 00:19:29 -0700
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5C662112-0C65-4C7A-BDD9-E6BC977F3293@gmail.com>
References: <20210606080004.1112859-1-yi.sun@intel.com>
 <20210606080004.1112859-2-yi.sun@intel.com>
To:     Yi Sun <yi.sun@intel.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Jun 6, 2021, at 1:00 AM, Yi Sun <yi.sun@intel.com> wrote:
>=20
> Create ISO image according to the configure file unittests.cfg,
> where describes the parameters of each test case.
>=20
> The grub.cfg in ios/boot/grub/ looks as following, taking case
> 'vmx_apicv_test' as an example:
>=20
> set timeout=3D0
> set default=3D0
>=20
> menuentry "vmx.elf" {
>    multiboot /boot/vmx.elf apic_reg_virt_test virt_x2apic_mode_test
>    module   /boot/module
>    boot
> }
>=20
> [1] All parameters are from '-append xxx' in the unittests.cfg.
> [2] The file 'module' is a fixed file that can be passed by paramters
> of script ./create_iso.sh.
>=20
> Signed-off-by: Yi Sun <yi.sun@intel.com>


Thanks Yi!

I gave it a spin and it works nicely.

One minor issue that I think worth fixing is silent failures. Initially, =
the script failed silently since I did not have the xorriso package =
installed on my Ubuntu (the error message "grub-mkrescue: error: xorriso =
not found.=E2=80=9D was suppressed). It would be nicer to print some =
error message in such case.


Two general notes regarding patch submission:

1. Please include a cover-letter (using git=E2=80=99s =
=E2=80=9C--cover-letter=E2=80=9D option), which would include general =
description of what the patch-set does. In addition, track changes =
between the versions.

2. Please use the same version for all patches. You can use git =E2=80=9C-=
v=E2=80=9D option for this matter.

Thanks again,
Nadav=
