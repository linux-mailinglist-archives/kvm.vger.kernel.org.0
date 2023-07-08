Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6A674BAFD
	for <lists+kvm@lfdr.de>; Sat,  8 Jul 2023 03:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjGHBYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 21:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjGHBYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 21:24:12 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2A0C1
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 18:24:10 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id 5614622812f47-392116b8f31so2049354b6e.2
        for <kvm@vger.kernel.org>; Fri, 07 Jul 2023 18:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688779450; x=1691371450;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EwLtWHsjA4aEYVtqcxXeib5Cr4Npsv65latHJuREzQ8=;
        b=W8BAoC4FSnCZL1i3jJouW7r0cAGIct84oXPf2dL13/2xRjklt0847uD97ge4p1AZmx
         YfXdH2HVz0kKk1jVKtFtfMsQFfwxN6PrL7vp4x9wstFAsTZgsLTmbr1EnVK9WiDUxmWW
         Y6hm70WPiWM/xi3paezRSfWZAC1OoznHNtBY3x3qAhrgyFCDzBVjnepqgoVYKtT4JKZK
         ipD8RIEZ2tAS1+0ZhXtLAApgqSy2asu1gJZWyE+ArG+s3Yb/9DuUWppLaBosFiYUfGu/
         HB25J9wU9GJVp+5KrBn+LW7lTGA01TmhPI/+1B4W1Lac31h6aInXYGBya7C5tlNYa7Aj
         FCAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688779450; x=1691371450;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EwLtWHsjA4aEYVtqcxXeib5Cr4Npsv65latHJuREzQ8=;
        b=NEkSmanwo+cgt+Ew7HPWW5+kUdjQIPBK4G8XZrs5h9QmP90MB3uCQSgfSCCRBb4sUc
         /RVZwsjeAaj+ZX7x3x/MBgTNXsw7iDZToOujW+rRWctGah2OX+9Rg0I86vlWS8gfpEe8
         7nACwMo31N+l9TGQwJQqIK60fQVlZvIC/fXwz1JkbFaHOf/d0M636PEndW14vn4j8Xhx
         So5bXA93a1GyJokfxP9nPnN04H/pVv3pqfnxkbzuZFSIaT2thgDmY/5DVINoP3Oh4Pom
         4/lShICmTbR3hzBhwR6E2LIKUgSHaKuhNqMmAVO7oc5Cv0gtmVoZG5ki5RRM6y+sprjB
         ayfA==
X-Gm-Message-State: ABy/qLajvVF4KhpLFRvw8wJRDoRR09WNaiRhuYdQV5QVHl9+zM80qCE/
        XreK8NQaFslFY9VcgvtWUWE=
X-Google-Smtp-Source: APBJJlFYiiKaYxM9TyIdSqyx8in0NAJ8zTjvfxAcXqgnRQCFfK7ffJz2EcplUN3X83KZn2gGRkPEpg==
X-Received: by 2002:a05:6808:10c6:b0:3a3:9337:4099 with SMTP id s6-20020a05680810c600b003a393374099mr7921215ois.56.1688779449705;
        Fri, 07 Jul 2023 18:24:09 -0700 (PDT)
Received: from localhost ([61.68.2.145])
        by smtp.gmail.com with ESMTPSA id bd1-20020a170902830100b001b9c5e0393csm1771874plb.225.2023.07.07.18.24.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jul 2023 18:24:09 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 08 Jul 2023 11:24:02 +1000
Message-Id: <CTWECLG9DWKS.2K25HI799MU70@wheely>
Cc:     <david@gibson.dropbear.id.au>, <harshpb@linux.ibm.com>,
        <pbonzini@redhat.com>, <qemu-ppc@nongnu.org>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <ravi.bangoria@amd.com>
Subject: Re: [PATCH v6] ppc: Enable 2nd DAWR support on p10
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Shivaprasad G Bhat" <sbhat@linux.ibm.com>,
        =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        "Greg Kurz" <groug@kaod.org>,
        "Daniel Henrique Barboza" <danielhb413@gmail.com>
X-Mailer: aerc 0.15.2
References: <168871963321.58984.15628382614621248470.stgit@ltcd89-lp2>
 <b0047746-5b36-c39b-c669-055d08ca3164@gmail.com>
 <20230707135909.1b1a89d5@bahia>
 <9c7ca859-f568-9487-0776-a6464edc69b4@kaod.org>
 <c93ce2b0-98ce-0d65-b799-9b0e2a4d9ce0@linux.ibm.com>
In-Reply-To: <c93ce2b0-98ce-0d65-b799-9b0e2a4d9ce0@linux.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat Jul 8, 2023 at 2:10 AM AEST, Shivaprasad G Bhat wrote:
>
> On 7/7/23 19:54, C=C3=A9dric Le Goater wrote:
> > On 7/7/23 13:59, Greg Kurz wrote:
> >> Hi Daniel and Shiva !
> >>
> >> On Fri, 7 Jul 2023 08:09:47 -0300
> >> Daniel Henrique Barboza <danielhb413@gmail.com> wrote:
> >>
> >>> This one was a buzzer shot.
> >>>
> >>
> >> Indeed ! :-) I would have appreciated some more time to re-assess
> >> my R-b tag on this 2 year old bug though ;-)
> >
> > We should drop that patch IMO and ask for a resend with more tests
> > but that's a lot of work to build a PR :/
> >
> Hi Cedric,
>
>
> I will be taking care of Greg's comment on avoiding failures in TCG mode =
for
>
> cap-dawr1=3Don.

I have done a patch for DAWR0 and CIABR for TCG and spapr, maybe that
could go first in a series then extend it for DAWR1 with your KVM stuff,
if that is of any help.

> I have already shared the "make test" results.
>
>
> Do you want me to try any other tests?

Do we have any tests that test DAWR0 or 1?

Thanks,
Nick
