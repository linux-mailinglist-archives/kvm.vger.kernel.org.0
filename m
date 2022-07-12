Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D72857111F
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 06:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiGLEM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 00:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiGLEMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 00:12:23 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D85C2A95D;
        Mon, 11 Jul 2022 21:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657599143; x=1689135143;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=EuuGYBH9oerHZqfH8JWBeHqaQkBsxFcht36rh5t3Was=;
  b=mCWbty0rM+bdQiooAXYSs2KFPEr8V9O5CdNjZuaGYa4dUqhIb8zr7W8d
   WViU2CZLYL17qfvEvvvsYxoi5bg6EcDeZKtLnUWrVT00iKx9jx9Vd5Ao8
   pQh1Tc/P8snEPuDoBJMFy/5l8X50n1Ht+RR8o4k4MGg3mgQ1OFwsq+4Ek
   cUjfp+D+Y1TVIlD73Zv1WogbMeudHrTlaLg+URm0ikfzECIHBrvMlLOGd
   SY3zyHb3kysaTopEgRZ7DLJY5uyPTChxlBSGIbcI/7qBmsUJt1Q9bcWEz
   dZPh8P4l9gegD+arOXp+vAn2G8x1oB0isOFmlOn6UjEtc1YYbLP8Wef0k
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="265245678"
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="265245678"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 21:12:22 -0700
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="721836139"
Received: from snaskant-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.60.27])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 21:12:19 -0700
Message-ID: <5aeecaf07c4749e496507d3ca75ff78189e5b8cd.camel@intel.com>
Subject: Re: [PATCH 10/12] Documentation: x86: Enclose TDX initialization
 code inside code block
From:   Kai Huang <kai.huang@intel.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-doc@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Date:   Tue, 12 Jul 2022 16:12:17 +1200
In-Reply-To: <20220709042037.21903-11-bagasdotme@gmail.com>
References: <20220709042037.21903-1-bagasdotme@gmail.com>
         <20220709042037.21903-11-bagasdotme@gmail.com>
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
> kernel test robot reported htmldocs warning on Documentation/x86/tdx.rst:
>=20
> Documentation/x86/tdx.rst:69: WARNING: Unexpected indentation.
> Documentation/x86/tdx.rst:70: WARNING: Block quote ends without a blank l=
ine; unexpected unindent.
>=20
> These warnings above are due to missing code block marker before TDX
> initialization code, which confuses Sphinx as normal block quote instead.
>=20
> Add literal code block marker to fix the warnings.

Thank you! will fix.

>=20
> Link: https://lore.kernel.org/linux-doc/202207042107.YqVvxdJz-lkp@intel.c=
om/
> Fixes: f05f595045dfc7 ("Documentation/x86: Add documentation for TDX host=
 support")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  Documentation/x86/tdx.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/Documentation/x86/tdx.rst b/Documentation/x86/tdx.rst
> index 6c6b09ca6ba407..4430912a2e4f05 100644
> --- a/Documentation/x86/tdx.rst
> +++ b/Documentation/x86/tdx.rst
> @@ -62,7 +62,7 @@ use it as 'metadata' for the TDX memory.  It also takes=
 additional CPU
>  time to initialize those metadata along with the TDX module itself.  Bot=
h
>  are not trivial.  Current kernel doesn't choose to always initialize the
>  TDX module during kernel boot, but provides a function tdx_init() to
> -allow the caller to initialize TDX when it truly wants to use TDX:
> +allow the caller to initialize TDX when it truly wants to use TDX::
> =20
>          ret =3D tdx_init();
>          if (ret)

