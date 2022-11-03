Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE15617452
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 03:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiKCCiE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 22:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiKCCiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 22:38:02 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FD712A95;
        Wed,  2 Nov 2022 19:38:00 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso561312pjc.2;
        Wed, 02 Nov 2022 19:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jRNCs2fd3UsRFb9r1y0twS4Yp6GOe3jwOJN7LNY2xm4=;
        b=h4S9i5ttXBaxuB9R/I6Hk7fTETigk03EgjJb8pQyiGlx22czeeRnSjMQbzk9BMUIJo
         n24kmW5ifClcwoxUV41Nk8SeMKJeG4Yu4jxFyRPmC24nCXnS7QD0EesXge6XJIMFzHuP
         bVvtAQJCpKK858pC576CRj/V7bixhi9CECIjmPfR04OEP7gkmr1AVHS3pulQHlqQZOdk
         FfqNqNQ6/nAktm7S5eRhEUa9/F09i/+HAeYMy522A6eqBkZXktV2X68rbfLg/XIvqoya
         eLg9bDhesAWInAdwsvbR9m0cktH9TVYistrt6k56pLC/4d2R8NHX223zv80xsj9kGH8r
         DT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jRNCs2fd3UsRFb9r1y0twS4Yp6GOe3jwOJN7LNY2xm4=;
        b=6+Kvne1UTl9tPqKj2O0KCTYdJQG2q1+Bt1k7c1IbL0zcBaQKPx6g9iz5EzmUgdHPZT
         +pxAqSqWDq7eiDYG9qTUy2BJ44lBFbWr7FJ/868N5moRTbn1MqmNLmz+gbt2GRV8pCG+
         c6s0hmJ5OuO0aqGxmDdVGxKTJciQXGtDKh5lmWnraKndWa7kT32ds6F+WfpGCQphSZK1
         uIDu+Bw43IPwXzXY0NsPAkz8yNqcs0MzEJj8HNOmguaXmNISDu07wXxtXOVtOTVD2npe
         LOvJBHWrqKQRPES1CrPSaYY8K6PIuYdJQYtuJ+xOeo8fvrP/sPogmC1LWKG9daES7PQu
         ZkVg==
X-Gm-Message-State: ACrzQf3MLijDtFb0ceB28I9/m3w4RKpavCejragSZtNlt8FlzoUV0gcb
        zlNObWhNDiBEhPAGDnYH7P4=
X-Google-Smtp-Source: AMsMyM6imzg64dN+TbDK2pPP7Xz5Bg39zIg7DMjJDG00aehbhzFFTO6tqh9Uw4bikHlU0vFxBFQUwg==
X-Received: by 2002:a17:90a:ca13:b0:213:b85a:3bdb with SMTP id x19-20020a17090aca1300b00213b85a3bdbmr24782163pjt.97.1667443079402;
        Wed, 02 Nov 2022 19:37:59 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-93.three.co.id. [180.214.232.93])
        by smtp.gmail.com with ESMTPSA id mt16-20020a17090b231000b0020d48bc6661sm2137880pjb.31.2022.11.02.19.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 19:37:58 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 28C5310402C; Thu,  3 Nov 2022 09:37:54 +0700 (WIB)
Date:   Thu, 3 Nov 2022 09:37:54 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Liao Chang <liaochang1@huawei.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Fix a typo about the usage of kvcalloc()
Message-ID: <Y2Mpgm+zEetfZlWM@debian.me>
References: <20221103011749.139262-1-liaochang1@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="g7Bj2J/Ny5mTe2nT"
Content-Disposition: inline
In-Reply-To: <20221103011749.139262-1-liaochang1@huawei.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--g7Bj2J/Ny5mTe2nT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 03, 2022 at 09:17:49AM +0800, Liao Chang wrote:
> Swap the 1st and 2nd arguments to be consistent with the usage of
> kvcalloc().
>=20

This isn't typofix as suggested from the patch subject, right?

--=20
An old man doll... just what I always wanted! - Clara

--g7Bj2J/Ny5mTe2nT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY2MpfgAKCRD2uYlJVVFO
o7viAPkBnv2MutmdeR8i1olYydOxlacezVPJ3lXxLELtoChVDQEAkadliI+V3GQb
jLNxotI2n263ofu9eEIO7nxvdr2SeAo=
=0KCs
-----END PGP SIGNATURE-----

--g7Bj2J/Ny5mTe2nT--
