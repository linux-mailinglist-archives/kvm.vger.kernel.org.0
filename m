Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2E958C22B
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 05:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbiHHDr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 23:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234847AbiHHDrY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 23:47:24 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9632101C4;
        Sun,  7 Aug 2022 20:47:23 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id u133so7059423pfc.10;
        Sun, 07 Aug 2022 20:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=bKYnCu9pm/upzkFb2rqM0O6IeVnkl0xkaP6BrnNiWiw=;
        b=YBJPrJESmEquNKfQZ/vBt+maelA+mPuN6dwEDskoVT3pmUQm9rt82jf9slr69uh/bW
         yd8ybu1hVs9Q2EzvXD7x5TETl+3O+YP0ggKWgUfR007GhGwChqaOS2xGH4fI+yqJiW8I
         I1QdHnAag4OwtDWP8oLSvwF7qvVE4CW7WdutJk8Z5D73s9+GpJw2LbCNm0F+4mRvsZ0I
         xhWfA1W22N5cjAN7cVCsh+j8AO4fHnx+rPFhsMkibo4bAuPe+jjS6tjWJ3UkNEyhbA5L
         dPiLu4ZpqPjLcOx63NJLYqFLgHyqE78U8XnsG/+kSz2lSr3NB6WLa9h7ldyhI0hyvC+0
         Y3mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=bKYnCu9pm/upzkFb2rqM0O6IeVnkl0xkaP6BrnNiWiw=;
        b=eMQvmjBYSttGSSKVW8Eo0ogD2+gD5ruODECEBdZ7DAyavwC4AymP4RH6pXmiBZzdCM
         Nhb2lTFTH0DmE+T82FOPAHmQui7zbuNmB5X+qHOirYUAS0BAQy0qlQEJ7N/8T+jEm9BT
         mT6mnTsvJMaZ+IgvjJbEEVtgVe2toYweX6iIFRk9+ToCgdbEcqTlqG7q5rJETKUkegwo
         zoivuZCiO8PJNH3eXSWZU7xb3gNx7hIZDzl3GGvKbWKcq7xV3444nNyhFls3+UibLSJn
         MO4R94p91nMo3/NRmUyHILN6W6SJFM72m8jrCxeRXKVuPnmrGgOo0NtGu35cWvbDPCAF
         Vy6A==
X-Gm-Message-State: ACgBeo11c7WHaE0/SJBaAYJo9VNJ9BSVGToR+M43Pw0HFiFPByfmyqt0
        rDnX7SXsYUAXAJcgHG0e2a8=
X-Google-Smtp-Source: AA6agR4ayOy784e0JdQQhr8OF5/PdVjLyE3beMJquor85LqMNJiE/j4nMyUQ7HIlGH8+sPBGBFsaUQ==
X-Received: by 2002:a63:5148:0:b0:41d:6628:80a3 with SMTP id r8-20020a635148000000b0041d662880a3mr3957991pgl.359.1659930443309;
        Sun, 07 Aug 2022 20:47:23 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-85.three.co.id. [180.214.232.85])
        by smtp.gmail.com with ESMTPSA id d8-20020aa797a8000000b00528c8ed356dsm7565212pfq.96.2022.08.07.20.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Aug 2022 20:47:22 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 056671039EA; Mon,  8 Aug 2022 10:47:18 +0700 (WIB)
Date:   Mon, 8 Aug 2022 10:47:18 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 000/103] KVM TDX basic feature support
Message-ID: <YvCHRuq8B69UMSuq@debian.me>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
        protocol="application/pgp-signature"; boundary="mo0AN5RiRVHwqA1Y"
Content-Disposition: inline
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--mo0AN5RiRVHwqA1Y
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 07, 2022 at 03:00:45PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>=20
> KVM TDX basic feature support
>=20
> Hello.  This is v8 the patch series vof KVM TDX support.
> This is based on v5.19-rc8 + kvm/queue branch + TDX HOST patch series.
> The tree can be found at https://github.com/intel/tdx/tree/kvm-upstream
> How to run/test: It's describe at https://github.com/intel/tdx/wiki/TDX-K=
VM
>=20
> Major changes from v7:
> - Use xarray to track whether GFN is private or shared. Drop SPTE_SHARED_=
MASK.
>   The complex state machine with SPTE_SHARED_MASK was ditched.
> - Large page support is implemented. But will be posted as independent RF=
C patch.
> - fd-based private page v7 is integrated. This is mostly same to Chao's p=
atches.
>   It's in github.
>=20
> Thanks,
> Isaku Yamahata
>=20

Hi, thanks for the series.

When building htmldocs, I found new warnings:

Documentation/x86/tdx.rst:69: WARNING: Unexpected indentation.
Documentation/x86/tdx.rst:70: WARNING: Block quote ends without a blank lin=
e; unexpected unindent.
Documentation/virt/kvm/tdx-tdp-mmu.rst: WARNING: document isn't included in=
 any toctree

I have applied the fixup (also with line blocks to code blocks conversion):

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/inde=
x.rst
index cdb8b43ce7970a..ff2db9ab428d3c 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -20,3 +20,4 @@ KVM
    review-checklist
=20
    intel-tdx
+   tdx-tdp-mmu
diff --git a/Documentation/x86/tdx.rst b/Documentation/x86/tdx.rst
index 6c6b09ca6ba407..34f0b9e5ee5678 100644
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

--mo0AN5RiRVHwqA1Y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTsebsWCPCpxY9T92n/R0PGQ3AzwAUCYvCHOwAKCRD/R0PGQ3Az
wOKRAYDoUs/UsE1xGxTc3HJtDisFuUa8l2g1WXkFhZ3kO2GwJGXqaEalUVN8lVgc
pGzwr4oBgKV92B34ny7L+15t9Rwif9EYIhvPAVr1DisL9rWois+XSFEDpx8C8i3Q
fgB2HD60nw==
=nHRq
-----END PGP SIGNATURE-----

--mo0AN5RiRVHwqA1Y--
