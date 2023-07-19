Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C128758D4F
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 07:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjGSFpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 01:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjGSFpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 01:45:43 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E45018E
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 22:45:42 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-666eba6f3d6so4329268b3a.3
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 22:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689745542; x=1690350342;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GpYVe+K4N2AVq5RLqdAWngfkcEzNRoNK/cVqRuEcyWE=;
        b=YAtGqRidGi08yabf9tSMuEEbFGiG25LVYNeqXcGeCn2r8SoQJUv6TnuTq/DZsLegHp
         YtPN0IRgQSK5zW6KgpyN8uT6raZEh0zDVdvtivi9EgiVTvkJJzG5h+7QNhM/OMHLcPXU
         EJZ0v2sqJF1WWKScLQul6nZDjnd0Wm3hSHXzhTdhtjjZYsGkbRfanQ5ga6Vipd0nXWI0
         h8+AA0XEEFnpLPr7Jn0/0KjsRHJcWA6JpyGqbMaRs8xHRhLVCUaCvWq4AThcgNPRmoS+
         lAVARz2yO8Dc+XjeFYWPocbIEezRhXkJVpPnJ4uDBOdEh+D517nViMndLSEQbWJUjXu6
         8K/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689745542; x=1690350342;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GpYVe+K4N2AVq5RLqdAWngfkcEzNRoNK/cVqRuEcyWE=;
        b=aYH0LtEq8AHk7v0Ck7OxtT6Cdc0JHMZDpEkkmtVP+IM7aobqQEROrlxDU4abG6Zhia
         u2nXrUO7FmHV796NHkJbNevg1O5ghWXkvD55Brr6Q4R2+4OoM+sc0Gja08j/kyJw+Qyz
         dDSJY/+1CC1cMQEfk6Lnko8fCpzfr5H4uaPGe5jq6C57x2rYlOoKhyGappYwTD2cWU8K
         iio4qFsRSZ1YRiJqLa8VS2EDUmT/xhejFblhyAO7qKwep4HrQE/IXpWDE+l9+yHUSDgQ
         eblHIuow86PpawW1V3YSDdRrANv596wRoWHtLGm2OW3EZJ0/yJ+Js8GJhnsl0R+nqzBO
         +QXQ==
X-Gm-Message-State: ABy/qLYYeqKR5go6SDZNR97BjKQuGCqjpM0pwpVdd9CW+htTZ28cyOul
        b0qGfrOlozW7gGGGbit0JBg=
X-Google-Smtp-Source: APBJJlFf/gV0F0U0nwTUNOA7IELfp3gSfQNZDOYYLyy2U6tghsZJdRLsiuWNVX2ugkmiIHOJVLU2Xg==
X-Received: by 2002:a05:6a20:394a:b0:130:9af7:bfa with SMTP id r10-20020a056a20394a00b001309af70bfamr16123327pzg.60.1689745541562;
        Tue, 18 Jul 2023 22:45:41 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id x3-20020a170902ea8300b001b895336435sm2905403plb.21.2023.07.18.22.45.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jul 2023 22:45:41 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v1 2/2] arm64: Define name for the bits
 used in SCTLR_EL1_RES1
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230719031926.752931-3-shahuang@redhat.com>
Date:   Tue, 18 Jul 2023 22:45:29 -0700
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <FDD82614-A542-46AA-A85B-6A437F802B6F@gmail.com>
References: <20230719031926.752931-1-shahuang@redhat.com>
 <20230719031926.752931-3-shahuang@redhat.com>
To:     Shaoqin Huang <shahuang@redhat.com>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jul 18, 2023, at 8:19 PM, Shaoqin Huang <shahuang@redhat.com> =
wrote:
>=20
> Currently some fields in SCTLR_EL1 don't define a name and directly =
used
> in the SCTLR_EL1_RES1, that's not good now since these fields have =
been
> functional and have a name.
>=20
> According to the ARM DDI 0487J.a, define the name related to these
> fields.
>=20
> Suggested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>

Thanks for doing that!

While I debugged my SCTLR issue on EFI, I did try to grep =E2=80=9CSPAN", =
and this
patch would=E2=80=99ve certainly helped.


