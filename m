Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9561F765C04
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 21:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbjG0TVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 15:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbjG0TVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 15:21:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0E9F3
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 12:21:14 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d1efa597303so3312821276.0
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 12:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690485674; x=1691090474;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N9G/ZTR4COQvT9CRNn+hkovgqONhqlIueNuj6K5tcGQ=;
        b=xBHTT3KVX9QLc7yW+b5RrKfM9drAqalZnv9sztDszJdylja+tU4FdBfEmo3HQhC9xI
         U9F7znR83G7u1cVrp//fVvRo+PvWcypTIQ00kaDA40LH/ZTtCyVNYYHtcYBTYU9ZQ9z6
         gzxAZjgVcW6jvJIIJEQM917jeiLdLfQ7EQWpNvrDBCGySYsycNz0lAUkhdI8paqGSMiw
         vCEPVk3GPqTABK6yP158rHXBQDmslRC93Lub3D/K1rJN0xC/Hm4VJ2GjGCZo8cqz9xQN
         +zzUdCwCSYX7icNAGWfFz38t4b64Ivr9KnjbbQvEQqpHjCMmEj/5Z2ObvqBmqtRgBV02
         /aMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690485674; x=1691090474;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N9G/ZTR4COQvT9CRNn+hkovgqONhqlIueNuj6K5tcGQ=;
        b=ewVyMitf1Gh62xwTFtkNTZ2bm+46nLFo1h/yhjEW6BfylIMIcot4uRV2WhDJ4A5dSx
         eOeXiAw6pw3Jenz3AOLuoEV3TClBQLSTEzyvOwI+V9DmkgWVIBNOgi771agXxDZ/ysr4
         EQR9ryoRxJ+hilSygpmcSn1FQsOolnfAJ4SdSd1gyesRz1YmxBmtN3jnKB1H0qXs/ir7
         LLns1wK9EYp9D4AcVg5pW03BroWQEYq+r/XlPGpAet5bSe+olVxkhThRh9Daih4URdfe
         doCYUEn3HZKTA27U0CARlD1e8jNFYKzIwm80vACr66dwJBmBpHYk0pnS0xdPHtXzWA5b
         wy7A==
X-Gm-Message-State: ABy/qLbAu4miy1sI/himSUlsGMwYosLKW2WldYL2r9MrOntq3Lu/Rc6G
        GM5pv7HtDbj7Wnh25hcm8TM96I2JJ6w=
X-Google-Smtp-Source: APBJJlHKZEPA/h+URI+JAe6PtcfrSpjDrmuGE2d+sA/0M3svgNjtDxx3sTETWy8e1aGcToo89Cbaf/V5WAk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7405:0:b0:d16:7ccc:b406 with SMTP id
 p5-20020a257405000000b00d167cccb406mr37440ybc.5.1690485674195; Thu, 27 Jul
 2023 12:21:14 -0700 (PDT)
Date:   Thu, 27 Jul 2023 12:21:12 -0700
In-Reply-To: <ZMK/dluS5ALq1NYj@google.com>
Mime-Version: 1.0
References: <20230607224520.4164598-1-aaronlewis@google.com>
 <ZMGhJAMqtFa6sTkl@google.com> <14c0e28b-1a90-5d61-6758-7a25bd317405@gmail.com>
 <ZMK/dluS5ALq1NYj@google.com>
Message-ID: <ZMLDqM41ib1HUS2t@google.com>
Subject: Re: [PATCH v3 0/5] Add printf and formatted asserts in the guest
From:   Sean Christopherson <seanjc@google.com>
To:     JinrongLiang <ljr.kernel@gmail.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023, Sean Christopherson wrote:
> On Thu, Jul 27, 2023, JinrongLiang wrote:
> >=20
> > =E5=9C=A8 2023/7/27 06:41, Sean Christopherson =E5=86=99=E9=81=93:
> > > Side topic, if anyone lurking out there wants an easy (but tedious an=
d boring)
> > > starter project, we should convert all tests to the newfangled format=
ting and
> > > drop GUEST_ASSERT_N entirely.  Once all tests are converted, GUEST_AS=
SERT_FMT()
> > > and REPORT_GUEST_ASSERT_FMT can drop the "FMT" postfix.
> >=20
> > I'd be happy to get the job done.
> >=20
> > However, before I proceed, could you please provide a more detailed exa=
mple
> > or further guidance on the desired formatting and the specific changes =
you
> > would like to see?
>=20
> Hrm, scratch that request.  I was thinking we could convert tests one-by-=
one, but
> that won't work well because to do a one-by-one conversions, tests that u=
se
> GUEST_ASSERT_EQ() would need to first convert to e.g. GUEST_ASSERT_EQ_FMT=
() and
> then convert back, which would be a silly amount of churn just to a void =
a single
> selftests-wide patch.
>=20
> It probably makes sense to just convert everything as part of this series=
.  There
> are quite a few asserts that need a message, but not *that* many.

Aha!  And there's already a "tree"-wide patch in this area to rename ASSERT=
_EQ()
to TEST_ASSERT_EQ()[*].  I'll include that in v4 as well, and then piggybac=
k on it
to implement the new and improved GUEST_ASSERT_EQ().

[*] https://lore.kernel.org/all/20230712075910.22480-2-thuth@redhat.com
