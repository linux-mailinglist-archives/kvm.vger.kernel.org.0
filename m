Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28856597CB8
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 06:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240744AbiHREHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 00:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiHREHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 00:07:18 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A499BADCCB;
        Wed, 17 Aug 2022 21:07:17 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id s4-20020a17090a5d0400b001fabc6bb0baso1883463pji.1;
        Wed, 17 Aug 2022 21:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=AnPSl2fv4YbAZeiwPXo9GgV/ehsBxgGdylPQL3o6spM=;
        b=ptP4Ji8viXhGPjcOy/fbF85TK2SNGt84RoM9E2TFEclO1YX8mbAUVonYhmRU6BtHw+
         5GqYH2phWi1AEkCQbqRaUi1lQnoVb4XWq/hMig/WcWRtuksHhNJ2Yo3q+e39oYFiicUY
         mzRbIqKedFQkKtKzyfVXSRXOcLU7bPO26OKFjpkYH1X8oMnFEbnLAp+9AFJtTeWzxtpY
         qIQKHIOHmPo0PWDJbQLqdH1U4YSLA7vKI/QARIFFcpkETwK96m6VfSeGqpbnSeTEJKyM
         R6HuYgnvA36S9gRNLMHqFmX9oWFT4eqAYJNbgPF9KuPyTYNduVkJEAQlQgXzuR3AR6Ik
         gkRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=AnPSl2fv4YbAZeiwPXo9GgV/ehsBxgGdylPQL3o6spM=;
        b=Us2EImYP5agHcx9w7ZHesiz74XXmc7zctZU5RG+xJdCpz6vEQ/o2VYsScKI7w68t4N
         vGcRWOimyMXiccDfyAzELILk4me/X98uBYmHC8++KfvYe8UoJvo5/vGK2mCuo2GFKz6X
         AY5DOo9+BZUgBDAXAyiSzz1K4ltO3HQ3xUPYs/jfoBBX0V2QDG7Pcp0f04uxDvhDOUVY
         EmindKs2MyMIybZFf0cH1RE7bMIPcNdyXWY3RCk6u6ntOGbJyjRsFHYvJHB7t/1lbcQH
         PxsgvnGNj8oFJ6INvR6t3yiuIwWvC+oSC6eXYpfnxWi3EeIe9MaPahMjG/LpzIDDvFo/
         ok7A==
X-Gm-Message-State: ACgBeo2j0S7YQqRnFaabR9X3gmf76TjGoX9mBUw+fWbiejk7KNrhz14i
        hze+S5DPOXGsTPu1QUnLkCk=
X-Google-Smtp-Source: AA6agR7RbEswr8TlmgOgVJ5hVBPXC7kT3XKkzbljcTfqyQdLIIUjyNgP3g30gvDtmk2IMAUI1RWbmQ==
X-Received: by 2002:a17:902:ea04:b0:172:a8e1:d076 with SMTP id s4-20020a170902ea0400b00172a8e1d076mr1299368plg.133.1660795637070;
        Wed, 17 Aug 2022 21:07:17 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-86.three.co.id. [180.214.233.86])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902d50200b0016a0bf0ce32sm253726plg.70.2022.08.17.21.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 21:07:16 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 587B1101BD7; Thu, 18 Aug 2022 11:07:13 +0700 (WIB)
Date:   Thu, 18 Aug 2022 11:07:13 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Subject: Re: [PATCH v5 22/22] Documentation/x86: Add documentation for TDX
 host support
Message-ID: <Yv268Z0i+rq7r/oR@debian.me>
References: <cover.1655894131.git.kai.huang@intel.com>
 <0712bc0b05a0c6c42437fba68f82d9268ab3113e.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7MH2uFN9Wf7hT8bf"
Content-Disposition: inline
In-Reply-To: <0712bc0b05a0c6c42437fba68f82d9268ab3113e.1655894131.git.kai.huang@intel.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--7MH2uFN9Wf7hT8bf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2022 at 11:17:50PM +1200, Kai Huang wrote:
> +Kernel detects TDX and the TDX private KeyIDs during kernel boot.  User
> +can see below dmesg if TDX is enabled by BIOS:
> +
> +|  [..] tdx: SEAMRR enabled.
> +|  [..] tdx: TDX private KeyID range: [16, 64).
> +|  [..] tdx: TDX enabled by BIOS.
> +
<snipped>
> +Initializing the TDX module consumes roughly ~1/256th system RAM size to
> +use it as 'metadata' for the TDX memory.  It also takes additional CPU
> +time to initialize those metadata along with the TDX module itself.  Both
> +are not trivial.  Current kernel doesn't choose to always initialize the
> +TDX module during kernel boot, but provides a function tdx_init() to
> +allow the caller to initialize TDX when it truly wants to use TDX:
> +
> +        ret =3D tdx_init();
> +        if (ret)
> +                goto no_tdx;
> +        // TDX is ready to use
> +

Hi,

The code block above produces Sphinx warnings:

Documentation/x86/tdx.rst:69: WARNING: Unexpected indentation.
Documentation/x86/tdx.rst:70: WARNING: Block quote ends without a blank lin=
e; unexpected unindent.

I have applied the fixup:

---- >8 ----

diff --git a/Documentation/x86/tdx.rst b/Documentation/x86/tdx.rst
index 6c6b09ca6ba407..4430912a2e4f05 100644
--- a/Documentation/x86/tdx.rst
+++ b/Documentation/x86/tdx.rst
@@ -62,7 +62,7 @@ use it as 'metadata' for the TDX memory.  It also takes a=
dditional CPU
 time to initialize those metadata along with the TDX module itself.  Both
 are not trivial.  Current kernel doesn't choose to always initialize the
 TDX module during kernel boot, but provides a function tdx_init() to
-allow the caller to initialize TDX when it truly wants to use TDX:
+allow the caller to initialize TDX when it truly wants to use TDX::
=20
         ret =3D tdx_init();
         if (ret)

> +If the TDX module is not loaded, dmesg shows below:
> +
> +|  [..] tdx: TDX module is not loaded.
> +
> +If the TDX module is initialized successfully, dmesg shows something
> +like below:
> +
> +|  [..] tdx: TDX module: vendor_id 0x8086, major_version 1, minor_versio=
n 0, build_date 20211209, build_num 160
> +|  [..] tdx: 65667 pages allocated for PAMT.
> +|  [..] tdx: TDX module initialized.
> +
> +If the TDX module failed to initialize, dmesg shows below:
> +
> +|  [..] tdx: Failed to initialize TDX module.  Shut it down.
<snipped>
> +There are basically two memory hot-add cases that need to be prevented:
> +ACPI memory hot-add and driver managed memory hot-add.  The kernel
> +rejectes the driver managed memory hot-add too when TDX is enabled by
> +BIOS.  For instance, dmesg shows below error when using kmem driver to
> +add a legacy PMEM as system RAM:
> +
> +|  [..] tdx: Unable to add memory [0x580000000, 0x600000000) on TDX enab=
led platform.
> +|  [..] kmem dax0.0: mapping0: 0x580000000-0x5ffffffff memory add failed
> +

For dmesg ouput, use literal code block instead of line blocks, like:

---- >8 ----

diff --git a/Documentation/x86/tdx.rst b/Documentation/x86/tdx.rst
index 4430912a2e4f05..1eaeb7cd14d76f 100644
--- a/Documentation/x86/tdx.rst
+++ b/Documentation/x86/tdx.rst
@@ -41,11 +41,11 @@ TDX boot-time detection
 -----------------------
=20
 Kernel detects TDX and the TDX private KeyIDs during kernel boot.  User
-can see below dmesg if TDX is enabled by BIOS:
+can see below dmesg if TDX is enabled by BIOS::
=20
-|  [..] tdx: SEAMRR enabled.
-|  [..] tdx: TDX private KeyID range: [16, 64).
-|  [..] tdx: TDX enabled by BIOS.
+  [..] tdx: SEAMRR enabled.
+  [..] tdx: TDX private KeyID range: [16, 64).
+  [..] tdx: TDX enabled by BIOS.
=20
 TDX module detection and initialization
 ---------------------------------------
@@ -79,20 +79,20 @@ caller.
 User can consult dmesg to see the presence of the TDX module, and whether
 it has been initialized.
=20
-If the TDX module is not loaded, dmesg shows below:
+If the TDX module is not loaded, dmesg shows below::
=20
-|  [..] tdx: TDX module is not loaded.
+  [..] tdx: TDX module is not loaded.
=20
 If the TDX module is initialized successfully, dmesg shows something
-like below:
+like below::
=20
-|  [..] tdx: TDX module: vendor_id 0x8086, major_version 1, minor_version =
0, build_date 20211209, build_num 160
-|  [..] tdx: 65667 pages allocated for PAMT.
-|  [..] tdx: TDX module initialized.
+  [..] tdx: TDX module: vendor_id 0x8086, major_version 1, minor_version 0=
, build_date 20211209, build_num 160
+  [..] tdx: 65667 pages allocated for PAMT.
+  [..] tdx: TDX module initialized.
=20
-If the TDX module failed to initialize, dmesg shows below:
+If the TDX module failed to initialize, dmesg shows below::
=20
-|  [..] tdx: Failed to initialize TDX module.  Shut it down.
+  [..] tdx: Failed to initialize TDX module.  Shut it down.
=20
 TDX Interaction to Other Kernel Components
 ------------------------------------------
@@ -143,10 +143,10 @@ There are basically two memory hot-add cases that nee=
d to be prevented:
 ACPI memory hot-add and driver managed memory hot-add.  The kernel
 rejectes the driver managed memory hot-add too when TDX is enabled by
 BIOS.  For instance, dmesg shows below error when using kmem driver to
-add a legacy PMEM as system RAM:
+add a legacy PMEM as system RAM::
=20
-|  [..] tdx: Unable to add memory [0x580000000, 0x600000000) on TDX enable=
d platform.
-|  [..] kmem dax0.0: mapping0: 0x580000000-0x5ffffffff memory add failed
+  [..] tdx: Unable to add memory [0x580000000, 0x600000000) on TDX enabled=
 platform.
+  [..] kmem dax0.0: mapping0: 0x580000000-0x5ffffffff memory add failed
=20
 However, adding new memory to ZONE_DEVICE should not be prevented as
 those pages are not managed by the page allocator.  Therefore,

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--7MH2uFN9Wf7hT8bf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYv266wAKCRD2uYlJVVFO
oyx0AP0YyAWyVtjuQQqW4JTzVnNEYTyqobjaY+aeJY4Vn+CWxQEAzzi4fFqlZR3c
pjH6M71UkIpsnblFe05YyFOFN7r6aAA=
=J01X
-----END PGP SIGNATURE-----

--7MH2uFN9Wf7hT8bf--
