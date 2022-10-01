Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7DB5F1AE0
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 10:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJAIa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Oct 2022 04:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiJAIax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Oct 2022 04:30:53 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28916A00CD;
        Sat,  1 Oct 2022 01:30:50 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 3so5980689pga.1;
        Sat, 01 Oct 2022 01:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=cFeD0M5xSrQodsOWcwdaI2yI/lmgB0wGYqo3yTddMdA=;
        b=AwNiyAOvGXRQ7hj3w1vSkiCL68oksAQ1OYsh9mRanGA/u4HVNAdSriOBvhWdwibuQn
         BNpzLJ0BRUTbD89mb4MwElamz9UgQQl0R4zke6cGX8nTBGzGmIymvtR8nt1Sy7K4u5eL
         6sXyWMju1RySR1uBRR8Ks+BQRjfFaKo6kpEusvSa16N+GMZhCgj/rg/c7drMAweIT0f9
         Uqw87MBTfRyhb9iulHhXVTSWwS3cC1gx9i/kcjCiajNpxR7Npr7ACN4sXkxzOtljA+Jv
         iPknjjt9X+gG68ab4aywF7Dx60zFoIrDWOrxjuwBM6oF3ktDyvgpqRV4HgRnmX+3yNie
         cMhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=cFeD0M5xSrQodsOWcwdaI2yI/lmgB0wGYqo3yTddMdA=;
        b=glHY3Oz/NSCeYqyTpkmkqzOM2cuYgdqvukL8hCOXQUXDti8iIr1SRgYe23FfhhSm8p
         qcgtXlOVNft9mP9uki0OMSrYKoAFsDRGxxnl36d45qF2hnDU0wYGjR62Fcrt+yCTHt77
         gdVwuz1thxd2fMp+hJYAA8Ob3dblOb9K/3B3kNQmzDB/lHhsTQhxjRkZtG8J/4qjn6TN
         P0rKdOLULE+tHWu5mz/KtBQ6Hb7lqAU9krBStSvKt2fF9MCFxH6SrK4713vbW44rie5y
         DQTsm3Kk0GBt95aS+rBAmwlQFTOhh/aVKolEBz4V3rJJXXfbWdjz5WcwdSYsyF9DsTlB
         sjzA==
X-Gm-Message-State: ACrzQf069czm7JSZqo8KtHMnP3DxS92vf+FKo0R40/P5ZrgD5kKODT2J
        Yd6sTNk42VE+IOjyWCjtzk0=
X-Google-Smtp-Source: AMsMyM5Spl6ouoTkparKt60BCXVcbZhOsWzZJiI19kA8+xOTOwALSypTZIfYPt70Bsiq0c22/WecVg==
X-Received: by 2002:a62:64cd:0:b0:55f:9b3f:6619 with SMTP id y196-20020a6264cd000000b0055f9b3f6619mr1562782pfb.86.1664613049372;
        Sat, 01 Oct 2022 01:30:49 -0700 (PDT)
Received: from debian.me (subs09a-223-255-225-74.three.co.id. [223.255.225.74])
        by smtp.gmail.com with ESMTPSA id l7-20020a170903120700b001766a3b2a26sm3330465plh.105.2022.10.01.01.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 01:30:48 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 39B0710368E; Sat,  1 Oct 2022 15:30:45 +0700 (WIB)
Date:   Sat, 1 Oct 2022 15:30:44 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v9 000/105] KVM TDX basic feature support
Message-ID: <Yzf6tD9HZasmPVvY@debian.me>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NNRX505jNWEKhWuY"
Content-Disposition: inline
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--NNRX505jNWEKhWuY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 30, 2022 at 03:16:54AM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>=20
> KVM TDX basic feature support
>=20
> Hello.  This is v9 the patch series vof KVM TDX support.
> This is based on v6.0-rc7 + the following patch series with minor update =
like
> compile fix.
>=20
> - TDX host kernel support v5
>   https://lore.kernel.org/lkml/cover.1655894131.git.kai.huang@intel.com/
> - kvm hardware initialization v5
>   https://lore.kernel.org/lkml/cover.1663869838.git.isaku.yamahata@intel.=
com/
> - fd-based approach for supporing KVM v8
>   https://lore.kernel.org/lkml/20220915142913.2213336-1-chao.p.peng@linux=
=2Eintel.com/
>=20
> The tree can be found at https://github.com/intel/tdx/tree/kvm-upstream
> How to run/test: It's describe at https://github.com/intel/tdx/wiki/TDX-K=
VM
>=20
> Major changes from v8:
> - rebased to v6.0-rc7
> - Integrated with kvm hardware initialization.  Check all packages has at=
 least
>   one online CPU when creating guest TD and refuse cpu offline during gue=
st TDs
>   are running.
> - Integrated fd-based private page v8 as prerequisite.
> - TDP MMU: Introduced more callbacks instead of single callback.
>=20
> Thanks,
> Isaku Yamahata
>=20

Hi Isaku,

I'm still getting the same htmldocs warnings as in v8 (see [1]). It seems
like the fixup there has not been applied to this version.

Thanks.

[1]: https://lore.kernel.org/lkml/YvCHRuq8B69UMSuq@debian.me/

--=20
An old man doll... just what I always wanted! - Clara

--NNRX505jNWEKhWuY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYzf6sAAKCRD2uYlJVVFO
o6ARAP0QyXbF8e2G4rR5zoKhmZwAAcY5hWnxm0qITxDjEWFxVwEAyFroa5+eNYX7
BdcJOeLfRuI82PpX96SJOWWLwR3n2gg=
=p0m1
-----END PGP SIGNATURE-----

--NNRX505jNWEKhWuY--
