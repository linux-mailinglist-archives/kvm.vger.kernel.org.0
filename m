Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB1AA76A758
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 05:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjHADLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 23:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjHADLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 23:11:38 -0400
Received: from mgamail.intel.com (unknown [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A0D19BD;
        Mon, 31 Jul 2023 20:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690859497; x=1722395497;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=NryKJShfM8SW3n7svt9Q1jFOZJgpKLahAZiBnH67rZY=;
  b=TGH+Ak6BtYG8lhfydC3MvxarNyZZUys2c6fynGEl3zKQBXwWPVEruH+g
   XVqp4r8spKPb09jDkHw1b3NvsHQG/EydZg3OAXwTu3QoMRikYMIZZCZh6
   L2mM1GarL5KoZUJeL/LYTNnQzB12lxQQPqzrZLMPDjIui9rMyqtxdVvQR
   h10J6vsHNwz6cd+Yk22+J5gladBisbr1ZfILu2hUyJtsqmiRjueOz08RM
   iPKwlGxX3uujupjgmXW7uv57KIDWuMTPDAZW4mE8iDs2pthaLiJSRTB/7
   zOfpQlOjdBCRvS3rQxVgpJdxDzfZDgEn6Ncf0eUsqjT7waZ7XuyfJwrOv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="372810269"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="asc'?scan'208";a="372810269"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 20:11:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="842555037"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="asc'?scan'208";a="842555037"
Received: from debian-skl.sh.intel.com (HELO debian-skl) ([10.239.160.45])
  by fmsmga002.fm.intel.com with ESMTP; 31 Jul 2023 20:11:34 -0700
Date:   Tue, 1 Aug 2023 11:12:05 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        zhi.a.wang@intel.com, zhenyuw@linux.intel.com, kvm@vger.kernel.org
Subject: Re: [PATCH] drm/i915/gvt: Fix bug in getting msg length in AUX CH
 registers handler
Message-ID: <ZMh4BW8a+82Ijzye@debian-scheme>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20230731112033.7275-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2KtKni1zqKU798lM"
Content-Disposition: inline
In-Reply-To: <20230731112033.7275-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--2KtKni1zqKU798lM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023.07.31 19:20:33 +0800, Yan Zhao wrote:
> Msg length should be obtained from value written to AUX_CH_CTL register
> rather than from enum type of the register.
>=20
> Commit 0cad796a2269  ("drm/i915: Use REG_BIT() & co. for AUX CH registers=
")
> incorrectly calculates the msg_length from reg type and yields below
> warning in intel_gvt_i2c_handle_aux_ch_write():
> "i915 0000:00:02.0: drm_WARN_ON(msg_length !=3D 4)".
>=20
> Fixes: 0cad796a2269 ("drm/i915: Use REG_BIT() & co. for AUX CH registers")
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---

Thanks for the fix!

Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>

>  drivers/gpu/drm/i915/gvt/edid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/edid.c b/drivers/gpu/drm/i915/gvt/e=
did.c
> index 2a0438f12a14..af9afdb53c7f 100644
> --- a/drivers/gpu/drm/i915/gvt/edid.c
> +++ b/drivers/gpu/drm/i915/gvt/edid.c
> @@ -491,7 +491,7 @@ void intel_gvt_i2c_handle_aux_ch_write(struct intel_v=
gpu *vgpu,
>  		return;
>  	}
> =20
> -	msg_length =3D REG_FIELD_GET(DP_AUX_CH_CTL_MESSAGE_SIZE_MASK, reg);
> +	msg_length =3D REG_FIELD_GET(DP_AUX_CH_CTL_MESSAGE_SIZE_MASK, value);
> =20
>  	// check the msg in DATA register.
>  	msg =3D vgpu_vreg(vgpu, offset + 4);
> --=20
> 2.17.1
>=20

--2KtKni1zqKU798lM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCZMh4AQAKCRCxBBozTXgY
J44nAJ9iw6SM1ZBIOoZovFO1eue/1cWpWQCeK9uQsOBPVhKevT97+erR/pKpjwM=
=Wsd+
-----END PGP SIGNATURE-----

--2KtKni1zqKU798lM--
