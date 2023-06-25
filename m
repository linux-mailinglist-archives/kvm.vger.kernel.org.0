Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE7A73D367
	for <lists+kvm@lfdr.de>; Sun, 25 Jun 2023 21:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjFYTpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 15:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjFYTpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 15:45:05 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884DB13E
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 12:45:04 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-341d62e78d3so13652575ab.3
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 12:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687722304; x=1690314304;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UD778V9DnbQQOIeZ16R9VPoinqYi52FwCCQW+55Zlfg=;
        b=nH/1GU6tAoZJ5TOiQyuLU9ktyEVt+6AGm7NmokBvorjStJrPO56/iNX19gld4nzsn6
         ZW62uYzB78gfffCvqXhO1huDp0UXF0Xq9ddibruZ1XGiQLG5oXVq5udjcdqh9OZOb/RG
         ZOWtOAMtf8cpWsoAoPPaRBUazUynWWEhReq4R9mNkVnJEKisAMchvHdsZ6nOdMM1rKgX
         cax65oJNsw1wDuZw0F/So6bbli7d4TseT9SPnjWr13bl9Mys8QTiuAEaiSn7uEaKst7x
         OA1mJAmQ9K6Rh1dkWd4zd03vphGJgrqe7WEGkUHUOjGomTIqpiXJO+r4Fm4JIF9VOnxV
         L0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687722304; x=1690314304;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UD778V9DnbQQOIeZ16R9VPoinqYi52FwCCQW+55Zlfg=;
        b=ZHyw5LPRkTJrk15fXGIRzFAfKQFchh1gT/E8cllxsdNiyAh2izkFOgcJo6cVaxCipq
         defNektkvzpWv2gFzcyRhxNmfqIgi55BoR8SnbVZ20vmhRi5mcJmtRHOjhY9E6b9NaI0
         vtZqyljsbPdQPE+yrvC0v4ZoOoWcCImJgf1yHeZR1XL5BESxklRW+RURQk7Ca1HppRmd
         ZsV7DjaPIu0NX9X/mr3HhGu+gGarMYx3lGvjKiBBtBo3iXcGbjAtAwFI3JmS8x0Ai2cR
         aJgksxJeDIty7IO9kt62I4C/1d4pEbApG63G2WsHWlziH4jLLtA2rggJnlnC/aWmymxx
         v7wA==
X-Gm-Message-State: AC+VfDxSXsVrPoKMXZN6ysOYjdK9qdUi2cGXhqgj3+YR8znPkSVtbgIv
        Ey1ewwLvL70mNq8LDU220ro=
X-Google-Smtp-Source: ACHHUZ7OVVWILzkNimUL7YZMLzzTvPEiDpBLJaMNeR74K2LfQUZbPkANTfFyrSM4IL9OYnt8ITIYDA==
X-Received: by 2002:a92:d910:0:b0:343:92a1:9cf4 with SMTP id s16-20020a92d910000000b0034392a19cf4mr20250462iln.19.1687722303599;
        Sun, 25 Jun 2023 12:45:03 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id v26-20020aa7809a000000b0062cf75a9e6bsm2540730pff.131.2023.06.25.12.45.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Jun 2023 12:45:03 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230617013138.1823-2-namit@vmware.com>
Date:   Sun, 25 Jun 2023 12:44:51 -0700
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <14C64FF1-A7D1-48F5-AD9C-09E8492FB5AC@gmail.com>
References: <20230617013138.1823-1-namit@vmware.com>
 <20230617013138.1823-2-namit@vmware.com>
To:     Andrew Jones <andrew.jones@linux.dev>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 16, 2023, at 6:31 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
> From: Nadav Amit <namit@vmware.com>
>=20
> Do not assume PAN is not supported or that sctlr_el1.SPAN is already =
set.
>=20
> Without setting sctlr_el1.SPAN, tests crash when they access the =
memory
> after an exception.

Andrew,

You=E2=80=99ve been kind enough to review the other patch-set and =
perhaps this
one fell through the cracks. Can you please have a look at this one
specifically and on:

https://lore.kernel.org/all/20230615003832.161134-1-namit@vmware.com/

These issues cause problem on other environments.

Thanks,
Nadav

