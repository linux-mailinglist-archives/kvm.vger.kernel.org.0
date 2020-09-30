Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C004E27E328
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 09:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbgI3H6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 03:58:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48382 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbgI3H6x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 03:58:53 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601452731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9UK1L1ZkImu26Sre+1+L0kxvnt8evmM4tiE1NkrMAeg=;
        b=D5dLbpD9lY22YccFeDEYuVEJhuNsgTPe7E2jXV/KEnfWRc1CkRnAZdmkaRcdMnlJPdKp5V
        x7mGFCxX9+KG9EENHKHygLe6jgvZr2geNDKiWjvAuveM00PaakZZo2N8WGWdqt1WdCnk8l
        xlxGFjNa0kXi3uGu2FJirPIoiwrTZzY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-TJ916KJOOwqggiYIDRRdIw-1; Wed, 30 Sep 2020 03:58:46 -0400
X-MC-Unique: TJ916KJOOwqggiYIDRRdIw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C030E1074652;
        Wed, 30 Sep 2020 07:58:44 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DE085C1CF;
        Wed, 30 Sep 2020 07:58:42 +0000 (UTC)
Date:   Wed, 30 Sep 2020 09:58:41 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Alex =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee@linaro.org>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v4 00/12] Support disabling TCG on ARM (part 2)
Message-ID: <20200930095841.3df7f8ee@redhat.com>
In-Reply-To: <20200929224355.1224017-1-philmd@redhat.com>
References: <20200929224355.1224017-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 30 Sep 2020 00:43:43 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> wrote:

> Cover from Samuel Ortiz from (part 1) [1]:
>=20
>   This patchset allows for building and running ARM targets with TCG
>   disabled. [...]
>=20
>   The rationale behind this work comes from the NEMU project where we're
>   trying to only support x86 and ARM 64-bit architectures, without
>   including the TCG code base. We can only do so if we can build and run
>   ARM binaries with TCG disabled.

I don't recall exact reason but TCG variant is used by bios-tables-test
to test arm/virt so it will probably break that
(it has something to do with how KVM uses CPU/GIC, which was making
ACPI tables not stable (i.e. depend on host), so comparison with master
tables was failing)


>=20
> v4 almost 2 years later... [2]:
> - Rebased on Meson
> - Addressed Richard review comments
> - Addressed Claudio review comments
>=20
> v3 almost 18 months later [3]:
> - Rebased
> - Addressed Thomas review comments
> - Added Travis-CI job to keep building --disable-tcg on ARM
>=20
> v2 [4]:
> - Addressed review comments from Richard and Thomas from v1 [1]
>=20
> Regards,
>=20
> Phil.
>=20
> [1]: https://lists.gnu.org/archive/html/qemu-devel/2018-11/msg02451.html
> [2]: https://www.mail-archive.com/qemu-devel@nongnu.org/msg689168.html
> [3]: https://www.mail-archive.com/qemu-devel@nongnu.org/msg641796.html
> [4]: https://lists.gnu.org/archive/html/qemu-devel/2019-08/msg05003.html
>=20
> Green CI:
> - https://cirrus-ci.com/build/4572961761918976
> - https://gitlab.com/philmd/qemu/-/pipelines/196047779
> - https://travis-ci.org/github/philmd/qemu/builds/731370972
>=20
> Based-on: <20200929125609.1088330-1-philmd@redhat.com>
> "hw/arm: Restrict APEI tables generation to the 'virt' machine"
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg745792.html
>=20
> Philippe Mathieu-Daud=C3=A9 (10):
>   accel/tcg: Add stub for cpu_loop_exit()
>   meson: Allow optional target/${ARCH}/Kconfig
>   target/arm: Select SEMIHOSTING if TCG is available
>   target/arm: Restrict ARMv4 cpus to TCG accel
>   target/arm: Restrict ARMv5 cpus to TCG accel
>   target/arm: Restrict ARMv6 cpus to TCG accel
>   target/arm: Restrict ARMv7 R-profile cpus to TCG accel
>   target/arm: Restrict ARMv7 M-profile cpus to TCG accel
>   target/arm: Reorder meson.build rules
>   .travis.yml: Add a KVM-only Aarch64 job
>=20
> Samuel Ortiz (1):
>   target/arm: Do not build TCG objects when TCG is off
>=20
> Thomas Huth (1):
>   target/arm: Make m_helper.c optional via CONFIG_ARM_V7M
>=20
>  default-configs/arm-softmmu.mak |  3 --
>  meson.build                     |  8 +++-
>  target/arm/cpu.h                | 12 ------
>  accel/stubs/tcg-stub.c          |  5 +++
>  target/arm/cpu_tcg.c            |  4 +-
>  target/arm/helper.c             |  7 ----
>  target/arm/m_helper-stub.c      | 73 +++++++++++++++++++++++++++++++++
>  .travis.yml                     | 35 ++++++++++++++++
>  hw/arm/Kconfig                  | 32 +++++++++++++++
>  target/arm/Kconfig              |  4 ++
>  target/arm/meson.build          | 40 +++++++++++-------
>  11 files changed, 184 insertions(+), 39 deletions(-)
>  create mode 100644 target/arm/m_helper-stub.c
>  create mode 100644 target/arm/Kconfig
>=20

