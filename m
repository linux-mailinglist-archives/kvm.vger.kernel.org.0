Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6281905F6
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 07:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgCXG4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 02:56:13 -0400
Received: from ma1-aaemail-dr-lapp01.apple.com ([17.171.2.60]:53722 "EHLO
        ma1-aaemail-dr-lapp01.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725869AbgCXG4M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 02:56:12 -0400
X-Greylist: delayed 31140 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Mar 2020 02:56:11 EDT
Received: from pps.filterd (ma1-aaemail-dr-lapp01.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp01.apple.com (8.16.0.27/8.16.0.27) with SMTP id 02NMCD1X021279;
        Mon, 23 Mar 2020 15:17:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : content-type
 : mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=20180706;
 bh=UCE0rzv5Q5lP+LqGnWVnT1u8zlQ2TXO4wf/ucT4JVd0=;
 b=aVTWdlIqC3P2J1jUoKiv6YIlriO+IVl5L9tbhhjv+bkLLNjLs5v+Z1VfYBwuDj3oS5PV
 i1dfEHstCbJo95NN8F4MbUhXkrqNNYJ/JTPmslYTpUv0U0krddo1ileFrJ/bJ80zKF8C
 XTqIpIisqD9hni67462dfasuMrd/mkq7PkV+hrBzS0rQgdADK7HHs8+zEsUu48kKS3hZ
 LinHphTau6iDuyUwb6JXatfLk4oNXwcS6/w566x9qjPu3Edgm5Is9oJMzA7DZ8JhUblZ
 FGvPLfxW6919VOvJUqBuhl0aMZ/R87sNf5ZNJZE1tu+uKyovcuyOsEtOIcCpc0hQeCDk xA== 
Received: from rn-mailsvcp-mta-lapp02.rno.apple.com (rn-mailsvcp-mta-lapp02.rno.apple.com [10.225.203.150])
        by ma1-aaemail-dr-lapp01.apple.com with ESMTP id 2ywhk3d6ke-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Mon, 23 Mar 2020 15:17:10 -0700
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216])
 by rn-mailsvcp-mta-lapp02.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) with ESMTPS id <0Q7O00EWG38K4C20@rn-mailsvcp-mta-lapp02.rno.apple.com>;
 Mon, 23 Mar 2020 15:17:08 -0700 (PDT)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q7O00I002WWJ500@nwk-mmpp-sz13.apple.com>; Mon,
 23 Mar 2020 15:17:08 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 20c0c410705af0c5efefeb0380f25862
X-Va-E-CD: 4a050f8ff28e73a244f948b438afd6eb
X-Va-R-CD: 12fa8a08ddfb4c3bc137e13c5b4d8ac0
X-Va-CD: 0
X-Va-ID: 13ed8a80-e1ab-49eb-a6fc-07fb0e349a58
X-V-A:  
X-V-T-CD: 20c0c410705af0c5efefeb0380f25862
X-V-E-CD: 4a050f8ff28e73a244f948b438afd6eb
X-V-R-CD: 12fa8a08ddfb4c3bc137e13c5b4d8ac0
X-V-CD: 0
X-V-ID: c610f126-744f-4226-84a6-100a9536334d
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_09:2020-03-23,2020-03-23 signatures=0
Received: from [17.234.34.141] (unknown [17.234.34.141])
 by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q7O00L8Y37XII70@nwk-mmpp-sz13.apple.com>; Mon,
 23 Mar 2020 15:17:07 -0700 (PDT)
Content-type: text/plain; charset=us-ascii
MIME-version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH 2/2] README: Document steps to run the tests
 on macOS
From:   Cameron Esfahani <dirty@apple.com>
In-reply-to: <20200320145541.38578-3-r.bolshakov@yadro.com>
Date:   Mon, 23 Mar 2020 15:17:07 -0700
Cc:     kvm@vger.kernel.org
Content-transfer-encoding: quoted-printable
Message-id: <80D748E3-4FE5-4E98-ADB6-4062377EF960@apple.com>
References: <20200320145541.38578-1-r.bolshakov@yadro.com>
 <20200320145541.38578-3-r.bolshakov@yadro.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
X-Mailer: Apple Mail (2.3445.104.11)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_09:2020-03-23,2020-03-23 signatures=0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Cameron Esfahani <dirty@apple.com>

Cameron Esfahani
dirty@apple.com

"We do what we must because we can."

Aperture Science



> On Mar 20, 2020, at 7:55 AM, Roman Bolshakov <r.bolshakov@yadro.com> =
wrote:
>=20
> While at it, mention that hvf is a valid accel parameter.
>=20
> Cc: Cameron Esfahani <dirty@apple.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
> README.macOS.md | 47 +++++++++++++++++++++++++++++++++++++++++++++++
> README.md       |  6 ++++--
> 2 files changed, 51 insertions(+), 2 deletions(-)
> create mode 100644 README.macOS.md
>=20
> diff --git a/README.macOS.md b/README.macOS.md
> new file mode 100644
> index 0000000..de46d5f
> --- /dev/null
> +++ b/README.macOS.md
> @@ -0,0 +1,47 @@
> +# kvm-unit-tests on macOS
> +
> +Cross-compiler with ELF support is required for build of =
kvm-unit-tests on
> +macOS.
> +
> +## Building cross-compiler from source
> +
> +A cross-compiler toolchain can be built from source using =
crosstool-ng. The
> +latest released version of
> +[crosstool-ng](https://github.com/crosstool-ng/crosstool-ng) can be =
installed
> +using [homebrew](https://brew.sh)
> +```
> +$ brew install crosstool-ng
> +```
> +
> +A case-sensitive APFS/HFS+ volume has to be created using Disk =
Utility as a
> +build and installation directory for the cross-compiler. Please [see =
Apple
> =
+documentation](https://support.apple.com/guide/disk-utility/dsku19ed921c/=
mac)
> +for details.
> +
> +Assuming the case-sensitive volume is named /Volumes/BuildTools, the
> +cross-compiler can be built and installed there:
> +```
> +$ X_BUILD_DIR=3D/Volumes/BuildTools/ct-ng-build
> +$ X_INSTALL_DIR=3D/Volumes/BuildTools/x-tools
> +$ mkdir $X_BUILD_DIR
> +$ ct-ng -C $X_BUILD_DIR x86_64-unknown-linux-gnu
> +$ ct-ng -C $X_BUILD_DIR build CT_PREFIX=3D$X_INSTALL_DIR
> +```
> +
> +Once compiled, the cross-compiler can be used to build the tests:
> +```
> +$ ./configure =
--cross-prefix=3D$X_INSTALL_DIR/x86_64-unknown-linux-gnu/bin/x86_64-unknow=
n-linux-gnu-
> +$ make
> +```
> +
> +## Pre-built cross-compiler
> +
> +x86_64-elf-gcc package in Homebrew provides pre-built cross-compiler =
but it
> +fails to compile kvm-unit-tests.
> +
> +## Running the tests
> +
> +GNU coreutils should be installed prior to running the tests:=20
> +```
> +$ brew install coreutils
> +```
> diff --git a/README.md b/README.md
> index 396fbf8..48be206 100644
> --- a/README.md
> +++ b/README.md
> @@ -15,6 +15,8 @@ To create the test images do:
>=20
> in this directory.  Test images are created in ./ARCH/\*.flat
>=20
> +NOTE: GCC cross-compiler is required for [build on =
macOS](README.macOS.md).
> +
> ## Standalone tests
>=20
> The tests can be built as standalone.  To create and use standalone =
tests do:
> @@ -47,7 +49,7 @@ environment variable:
>=20
>     QEMU=3D/tmp/qemu/x86_64-softmmu/qemu-system-x86_64 ./x86-run =
./x86/msr.flat
>=20
> -To select an accelerator, for example "kvm" or "tcg", specify the
> +To select an accelerator, for example "kvm", "hvf" or "tcg", specify =
the
> ACCEL=3Dname environment variable:
>=20
>     ACCEL=3Dkvm ./x86-run ./x86/msr.flat
> @@ -78,7 +80,7 @@ which can then be accessed in the usual ways, e.g. =
VAL =3D getenv("KEY").
> Any key=3Dval strings can be passed, but some have reserved meanings =
in
> the framework.  The list of reserved environment variables is below
>=20
> -    QEMU_ACCEL                   either kvm or tcg
> +    QEMU_ACCEL                   either kvm, hvf or tcg
>     QEMU_VERSION_STRING          string of the form `qemu -h | head =
-1`
>     KERNEL_VERSION_STRING        string of the form `uname -r`
>=20
> --=20
> 2.24.1
>=20

