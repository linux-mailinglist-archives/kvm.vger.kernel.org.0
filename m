Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381B357111B
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 06:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiGLELp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 00:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiGLELl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 00:11:41 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC2A2A95D;
        Mon, 11 Jul 2022 21:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657599100; x=1689135100;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ArqaeZnuX8QcKhVxfL4Y5BxNELzHnsMjFtshijKs5MA=;
  b=NXnu+I1EgN9clc32bRoPeT0kHgZWvn/6zX/wCgfHn/aKNJWG+LOb8p4k
   fXxK1en9yex0Hu9oizgw/eeIvmzeBdLOsnErElfj953jf5+HBj0QGI0JF
   IVxbkFfcepdb2iRKLKCO5eAKXnLJNmEYC5VqN8w0fgC4V2AUQr6I3L3Ub
   3kSBgG7bE6Vm74/CaQrksLWA1Par4+JsXnkAkWIvvdqSLxLGm0bYia0tG
   l5/xg08cO0raMXlXN0Nhf6AoQjGP/VPxr0s1XUBMdTM1TSU3v5B3pUbNz
   DFAJFWdYIzAne6KKExX51oThlek3K6CQluQGMiVzPFNs2hldQkocDXyiF
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="348810695"
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="348810695"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 21:11:39 -0700
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="592493357"
Received: from snaskant-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.60.27])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 21:11:36 -0700
Message-ID: <b2ac926a9175306b4ae04f73a23c100645d642b6.camel@intel.com>
Subject: Re: [PATCH 11/12] Documentation: x86: Use literal code block for
 TDX dmesg output
From:   Kai Huang <kai.huang@intel.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-doc@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 12 Jul 2022 16:11:34 +1200
In-Reply-To: <20220709042037.21903-12-bagasdotme@gmail.com>
References: <20220709042037.21903-1-bagasdotme@gmail.com>
         <20220709042037.21903-12-bagasdotme@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-07-09 at 11:20 +0700, Bagas Sanjaya wrote:
> The dmesg output blocks are using line blocks, which is incorrect, since
> this will render the blocks as normal paragraph with preserved line
> breaks instead of code blocks.
>=20
> Use literal code blocks instead for the output.

Thank you very much!

Obviously I am not familiar with .rst.   I'll fix.

>=20
> Fixes: f05f595045dfc7 ("Documentation/x86: Add documentation for TDX host=
 support")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  Documentation/x86/tdx.rst | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
>=20
> diff --git a/Documentation/x86/tdx.rst b/Documentation/x86/tdx.rst
> index 4430912a2e4f05..f5bd22b89159ec 100644
> --- a/Documentation/x86/tdx.rst
> +++ b/Documentation/x86/tdx.rst
> @@ -41,11 +41,11 @@ TDX boot-time detection
>  -----------------------
> =20
>  Kernel detects TDX and the TDX private KeyIDs during kernel boot.  User
> -can see below dmesg if TDX is enabled by BIOS:
> +can see below dmesg if TDX is enabled by BIOS::
> =20
> -|  [..] tdx: SEAMRR enabled.
> -|  [..] tdx: TDX private KeyID range: [16, 64).
> -|  [..] tdx: TDX enabled by BIOS.
> +   [..] tdx: SEAMRR enabled.
> +   [..] tdx: TDX private KeyID range: [16, 64).
> +   [..] tdx: TDX enabled by BIOS.
> =20
>  TDX module detection and initialization
>  ---------------------------------------
> @@ -79,20 +79,20 @@ caller.
>  User can consult dmesg to see the presence of the TDX module, and whethe=
r
>  it has been initialized.
> =20
> -If the TDX module is not loaded, dmesg shows below:
> +If the TDX module is not loaded, dmesg shows below::
> =20
> -|  [..] tdx: TDX module is not loaded.
> +   [..] tdx: TDX module is not loaded.
> =20
>  If the TDX module is initialized successfully, dmesg shows something
> -like below:
> +like below::
> =20
> -|  [..] tdx: TDX module: vendor_id 0x8086, major_version 1, minor_versio=
n 0, build_date 20211209, build_num 160
> -|  [..] tdx: 65667 pages allocated for PAMT.
> -|  [..] tdx: TDX module initialized.
> +   [..] tdx: TDX module: vendor_id 0x8086, major_version 1, minor_versio=
n 0, build_date 20211209, build_num 160
> +   [..] tdx: 65667 pages allocated for PAMT.
> +   [..] tdx: TDX module initialized.
> =20
> -If the TDX module failed to initialize, dmesg shows below:
> +If the TDX module failed to initialize, dmesg shows below::
> =20
> -|  [..] tdx: Failed to initialize TDX module.  Shut it down.
> +   [..] tdx: Failed to initialize TDX module.  Shut it down.
> =20
>  TDX Interaction to Other Kernel Components
>  ------------------------------------------
> @@ -143,10 +143,10 @@ There are basically two memory hot-add cases that n=
eed to be prevented:
>  ACPI memory hot-add and driver managed memory hot-add.  The kernel
>  rejectes the driver managed memory hot-add too when TDX is enabled by
>  BIOS.  For instance, dmesg shows below error when using kmem driver to
> -add a legacy PMEM as system RAM:
> +add a legacy PMEM as system RAM::
> =20
> -|  [..] tdx: Unable to add memory [0x580000000, 0x600000000) on TDX enab=
led platform.
> -|  [..] kmem dax0.0: mapping0: 0x580000000-0x5ffffffff memory add failed
> +   [..] tdx: Unable to add memory [0x580000000, 0x600000000) on TDX enab=
led platform.
> +   [..] kmem dax0.0: mapping0: 0x580000000-0x5ffffffff memory add failed
> =20
>  However, adding new memory to ZONE_DEVICE should not be prevented as
>  those pages are not managed by the page allocator.  Therefore,

