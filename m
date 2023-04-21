Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97926EB0BA
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 19:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbjDURkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 13:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbjDURkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 13:40:06 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA0612582
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 10:40:04 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a814fe0ddeso26880625ad.2
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 10:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682098804; x=1684690804;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dhmzadUG3fZs7husXeA0WbkxQGo5+WSirow/ZLJYIA8=;
        b=pJm4mnRWylHJ0Gat/ee7mWuQRrm9PVz1aPFna537nzZRRXGR4K5lTDHOl8n5i2uu48
         EUMk6MzxI+9wqOFuxraK0ZbUpvCC4tIGAsXhspbFezqRX8BE1BxwJy8OKhTaDOjig6ob
         Px/LF85jpt9vPJa9dFPxJ+yv7OdYPoEljuimK0lpmB0E+KgSvniPG4vuKuefphuSeJcZ
         QluANtigCw2t0Hv/9nffvdU0U1OIAQSzStrVHs0TvaHhsrMAaXJtyA1lkV0TkygyEeGT
         7DoXIwF2Nyu9/i4GFaAA3xw7svYLkVVtdjP39DUN/74Ax/5uxGgKNcnH1gusSFvtPnIO
         Fd3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682098804; x=1684690804;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dhmzadUG3fZs7husXeA0WbkxQGo5+WSirow/ZLJYIA8=;
        b=Q/5KA2asbIXcyPFHPxX5o7zYvOGXDYoSEdlH96dZcOtszMWyv1Genj1poXKPsKNLH4
         6fl6f8AAvJUZfCW0ASnMDoEbMmDYtloLKVgvcygRr8gQCO0ECVCUP5TuGuhA9ASzEvX4
         mFS98c9k1TB64O0bNuhQPq0uKxj9t1dpAHjP88KmUnoclDwwx8hCXtqigys418IDFixU
         Q0ZXthQQ6ru6xqCmHq52ff5ORD2rDLJ2A1VqkS3RcapRf++9+TTEpx6TAhJrkWTFNogq
         pVj5eJenvaCSiw4qV4l2t88aYkJYpFr6Pa6ai53pOTig4ar0cbBZHH/DWJMaDLrc/LUr
         4Dxw==
X-Gm-Message-State: AAQBX9eP29XsDx0q/bD1oVfFk1yvAetMwX9xjH60sK5bGX8NFA01r/1z
        PVDAujchcNhORd7isRA6Aqw=
X-Google-Smtp-Source: AKy350YGTGp3cJL7b4EnpySmGHmH/RmGOJNpVyZKI5FM1zZ1uha5N7JLEpkc6v8GyUuGJfA+4+aGYA==
X-Received: by 2002:a17:903:1ce:b0:1a2:a8d0:838e with SMTP id e14-20020a17090301ce00b001a2a8d0838emr5564267plh.61.1682098803815;
        Fri, 21 Apr 2023 10:40:03 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.95])
        by smtp.gmail.com with ESMTPSA id ju18-20020a170903429200b001a526805b86sm2987436plb.191.2023.04.21.10.40.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Apr 2023 10:40:03 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <ZEGuogfbtxPNUq7t@x1n>
Date:   Fri, 21 Apr 2023 10:39:51 -0700
Cc:     Anish Moorthy <amoorthy@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, Sean Christopherson <seanjc@google.com>,
        James Houghton <jthoughton@google.com>, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com,
        kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n>
 <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n>
To:     Peter Xu <peterx@redhat.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Apr 20, 2023, at 2:29 PM, Peter Xu <peterx@redhat.com> wrote:
>=20
> Hi, Anish,
>=20
> [Copied Nadav Amit for the last few paragraphs on userfaultfd, because
> Nadav worked on a few userfaultfd performance problems; so maybe he'll
> also have some ideas around]

Sorry for not following this thread and previous ones.

I skimmed through and I hope my answers would be helpful and relevant=E2=80=
=A6

Anyhow, I also encountered to some extent the cost of locking (not the
contention). In my case, I only did a small change to reduce the =
overhead of
acquiring the locks by =E2=80=9Ccombining" the locks of =
faulting_pending_wqh and
fault_wqh, which are (almost?) always acquired together. I only acquired
fault_pending_wqh and then introduced =E2=80=9Cfake_spin_lock()=E2=80=9D =
which only got
lockdep to understand the fault_wqh is already protected.

But as I said, this solution was only intended to reduce the cost of =
locking,
and it does not solve the contention.

If I understand the problem correctly, it sounds as if the proper =
solution
should be some kind of a range-locks. If it is too heavy or the =
interface can
be changed/extended to wake a single address (instead of a range),
simpler hashed-locks can be used.=
