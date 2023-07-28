Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D7B766922
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 11:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbjG1Jkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 05:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbjG1Jkp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 05:40:45 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E19E4F
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 02:40:44 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id 4fb4d7f45d1cf-5222b917e0cso2610551a12.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 02:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690537243; x=1691142043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aos280ZhyrnUClLZ5H7ZBauqqhDmO8EQZjHjP5yiH2w=;
        b=nhQJucTo/Vjc+6Ay+yc8BT/z2sWxYlXVhBKEFApkxjUBMwC3zt5T/Au0ArvfE37nsX
         qpdDnh8X/kw+S9jtxmKEU4bDDFR93oc7gZ1jH9GZTPVnLebtAzLX9fZrkJOXhSYixRWt
         McgDbrMUQSD/xpMtRTzLKel6mLVZoxqjjqHI7NrC1LdM88BRKLoXAY07aDLSP+PgfP4X
         aKkvUNhH/AlI4Dq7+etOHuUWA+cD9Qh8Bf8nK6GYT22H+xTXojePCXIMhoRDzhmeVjrK
         EgCzLTal02SsMSsX3lwQxwnO89JyjGY5znXPOgGq8iNia4xurqp6HHpAZJ4m7YkvZ8nJ
         rCvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690537243; x=1691142043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Aos280ZhyrnUClLZ5H7ZBauqqhDmO8EQZjHjP5yiH2w=;
        b=HrCpBI58QdFooP2h7HGidn50uLRdk6rXHzDKNv4EwnjCdBfkZwcJ8a25/wqv7LMQV+
         CE4gkPAxwUluRuN8k889N7ObOfCmz0QA7AVzCVcqqbts1lfayAVF7u4XHtgOeH3ns1XV
         sEBa7hqrPLQMwycLpj085zEVSRhH5FLwiyf80pNmq1IdGZsEgo2fCYGUkukqSlwGm5W5
         KBHcfF1BhcVOUkLoTCZQQmGY0DtTPIyY2yItXsRL8igvHgETeYOtags9A2uujp2xFMQm
         gx9TIwGj1TKkTSfs2rWuSB4eH1D6AyVyQwVV1oEDNcS90xNyRwfrQMdT2SDeb1qcvXLR
         kEHA==
X-Gm-Message-State: ABy/qLYSjAM8xJurhRlDl558JYiYtr0hdNmXE5YQlxOFyirLLRHaiVIh
        d6XL3j6ZR7Fo/OAoKr9qpizXOiIYfDwpzJIgY5o=
X-Google-Smtp-Source: APBJJlEg5r//kATi/PmJXGXXJrMzR+rh+aq3uc81/nkajDW9QLLGhqKQNY8rngQ8zinrmbKoaW19F+EB5KbkDBBaFCg=
X-Received: by 2002:aa7:d5d0:0:b0:522:2ada:c207 with SMTP id
 d16-20020aa7d5d0000000b005222adac207mr1521824eds.34.1690537242736; Fri, 28
 Jul 2023 02:40:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230607224520.4164598-1-aaronlewis@google.com>
 <ZMGhJAMqtFa6sTkl@google.com> <14c0e28b-1a90-5d61-6758-7a25bd317405@gmail.com>
 <ZMK/dluS5ALq1NYj@google.com> <ZMLDqM41ib1HUS2t@google.com>
In-Reply-To: <ZMLDqM41ib1HUS2t@google.com>
From:   Jinrong Liang <ljr.kernel@gmail.com>
Date:   Fri, 28 Jul 2023 17:40:31 +0800
Message-ID: <CAFg_LQXdrevoga+fZS=2SyCmmrcGQGeFUFfmoEDdirMKDC9nkA@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] Add printf and formatted asserts in the guest
To:     Sean Christopherson <seanjc@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> =E4=BA=8E2023=E5=B9=B47=E6=9C=8828=
=E6=97=A5=E5=91=A8=E4=BA=94 03:21=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Jul 27, 2023, Sean Christopherson wrote:
> > On Thu, Jul 27, 2023, JinrongLiang wrote:
> > >
> > > =E5=9C=A8 2023/7/27 06:41, Sean Christopherson =E5=86=99=E9=81=93:
> > > > Side topic, if anyone lurking out there wants an easy (but tedious =
and boring)
> > > > starter project, we should convert all tests to the newfangled form=
atting and
> > > > drop GUEST_ASSERT_N entirely.  Once all tests are converted, GUEST_=
ASSERT_FMT()
> > > > and REPORT_GUEST_ASSERT_FMT can drop the "FMT" postfix.
> > >
> > > I'd be happy to get the job done.
> > >
> > > However, before I proceed, could you please provide a more detailed e=
xample
> > > or further guidance on the desired formatting and the specific change=
s you
> > > would like to see?
> >
> > Hrm, scratch that request.  I was thinking we could convert tests one-b=
y-one, but
> > that won't work well because to do a one-by-one conversions, tests that=
 use
> > GUEST_ASSERT_EQ() would need to first convert to e.g. GUEST_ASSERT_EQ_F=
MT() and
> > then convert back, which would be a silly amount of churn just to a voi=
d a single
> > selftests-wide patch.
> >
> > It probably makes sense to just convert everything as part of this seri=
es.  There
> > are quite a few asserts that need a message, but not *that* many.
>
> Aha!  And there's already a "tree"-wide patch in this area to rename ASSE=
RT_EQ()
> to TEST_ASSERT_EQ()[*].  I'll include that in v4 as well, and then piggyb=
ack on it
> to implement the new and improved GUEST_ASSERT_EQ().
>
> [*] https://lore.kernel.org/all/20230712075910.22480-2-thuth@redhat.com

Thank you for your response and suggestions.  I believe your
recommendation is an excellent approach.

Please let me know if there's anything else I can help with or any
specific tasks you'd like me to work on. I appreciate your guidance
and the opportunity to contribute to KVM.
