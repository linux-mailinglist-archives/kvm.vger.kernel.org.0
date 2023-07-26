Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F91764025
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 22:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjGZUHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 16:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjGZUH2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 16:07:28 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F76E1BF6
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 13:07:27 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56942442eb0so2090437b3.1
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 13:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690402046; x=1691006846;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BLwoLcOpwq60cWR6YSdxWHtgLvvLoNY8bFuxQjkGWsM=;
        b=P/d/F8jJR05hj5EI8P6MyGL5CFUWRd5x2ky0+RuPnM8Eym5U0dCd9PTQHzhB8NSH5w
         n21Y0otHktEWR6E9g0ekLXcEn4X584PrypKndjevw9zFmneBMQ2v1tttiGSpSyeaFyl4
         i30nhiDWOCjsCOkFAH+1s/NLQUAua6dJeop1Z1mDSZOSX+1yemtIEpdSNpJ3Sp0jYtQR
         uaQOqRTvUkDztBwqVUSjVPy5y1AOx6UGIimEPA4k84TlJMcuJhwcEBi2/pKxLC04TJOo
         9PAFEaOpDBsqZJjxOwZgkh9IV0XKuSx+czeM4s1ui5aErLuEr0KkNpRK3MHfFZ1soj5W
         eRUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690402046; x=1691006846;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BLwoLcOpwq60cWR6YSdxWHtgLvvLoNY8bFuxQjkGWsM=;
        b=NPuuvuJJIMWyeFviqpVyY9kl0fKTTJjLQiMNiqNASVenTaK9L7D6Sw1YBErXRCvPdL
         6GNgjSyq1hHjPtQTHPUwzgGpa9PT4crjwpSVKfFiHuYvB9nNzlQhwuzN97mRbylk/pI+
         vEB6Iql4igx6u6hRowqV9YBS8vZV57+60S/kNU4kRBAbRwnCSccW2aR0+JDSTyz8oRch
         4X8AGGAQ/tVUjWxdVoga2mRUvPTdy33WLvvkL9U1cy7d1Br8S2eetL7QFhkvDtwhTYr5
         +BfGZnbyUh5azDr8ufE701ohjXalzRDJnGMvMXCftDkmKyeUv9gDv11tezCu5lgTEfuM
         9vAg==
X-Gm-Message-State: ABy/qLY6556aKcN91pQ4VmeO7Ivrv+gBDIbxxtNj6Ys1ysyF24T4KzgY
        70ToInnHT1alSa2/M0SS62VhzhUQ9xc=
X-Google-Smtp-Source: APBJJlH8/GyGkBf92DERFRII5C2IjhJb0a2LQMw+Y0isUHXc2/wOuBJ0poY017e+upfxfx/6iJUok+WwZcU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ed08:0:b0:57a:118a:f31 with SMTP id
 k8-20020a81ed08000000b0057a118a0f31mr26090ywm.7.1690402046811; Wed, 26 Jul
 2023 13:07:26 -0700 (PDT)
Date:   Wed, 26 Jul 2023 13:07:25 -0700
In-Reply-To: <9a58e731421edad45dff31e681b83f90c5e9775e.camel@infradead.org>
Mime-Version: 1.0
References: <138f584bd86fe68aa05f20db3de80bae61880e11.camel@infradead.org>
 <20230418101306.98263-1-metikaya@amazon.co.uk> <ZHEXX/OG6suNGWPN@google.com> <9a58e731421edad45dff31e681b83f90c5e9775e.camel@infradead.org>
Message-ID: <ZMF8/SUw5ebkDhde@google.com>
Subject: Re: [PATCH v3] KVM: x86/xen: Implement hvm_op/HVMOP_flush_tlbs hypercall
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Metin Kaya <metikaya@amazon.co.uk>, kvm@vger.kernel.org,
        pbonzini@redhat.com, x86@kernel.org, bp@alien8.de, paul@xen.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        joao.m.martins@oracle.com
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

On Tue, Jul 25, 2023, David Woodhouse wrote:
> On Fri, 2023-05-26 at 13:32 -0700, Sean Christopherson wrote:
> > =C2=A0 : Aha!=C2=A0 And QEMU appears to have Xen emulation support.=C2=
=A0 That means KVM-Unit-Tests
> > =C2=A0 : is an option.=C2=A0 Specifically, extend the "access" test to =
use this hypercall instead
> > =C2=A0 : of INVLPG.=C2=A0 That'll verify that the flush is actually bei=
ng performed as expteced.
>=20
> That works. Metin has a better version that actually sets up the
> hypercall page properly and uses it, but that one bails out when Xen
> support isn't present, and doesn't show the failure mode quite so
> clearly. This is the simple version:

IIUC, y'all have already written both tests, so why not post both?  I certa=
inly
won't object to more tests if they provide different coverage.

> > Let me be more explicit this time: I am not applying this without a tes=
t.=C2=A0 I don't
> > care how trivial a patch may seem, I'm done taking patches without test=
 coverage
> > unless there's a *really* good reason for me to do so.
>=20
> Understood.
>=20
> So, we know it *works*, but the above is a one-off and not a
> *regression* test.
>=20
> It would definitely be nice to have regression tests that cover
> absolutely everything, but adding Xen guest support to the generic KVM-
> Unit-Tests might be considered overkill, because this *particular*
> thing is fairly unlikely to regress? It really is just calling
> kvm_flush_remote_tlbs(), and if that goes wrong we're probably likely
> to notice it anyway.
>=20
> What do you think?

I'm a-ok with just having basic test coverage.  We don't have anywhere near=
 100%
(or even 10%...) coverage of KVM's TLB management, so it would be ridiculou=
s to
require that for Xen PV.

I'd definitely love to change that, and raise the bar for test coverage in =
general,
but that'll take time (and effort).
