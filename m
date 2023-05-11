Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E806C6FF840
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 19:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbjEKRSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 13:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238936AbjEKRSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 13:18:33 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571E786BD
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 10:18:24 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id a1e0cc1a2514c-77f693190caso2732716241.0
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 10:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683825503; x=1686417503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9g3QPSW366xmIBoE8HQa8vjGvWDy8pwzthEW0pwdt28=;
        b=MipUL06ocXBu9FwukZ7DW2NA1NNmGyNqva3aZjTBC2oESbDvCcvVfylCT66cV7ezIB
         uPV9b5xDBpZIoxSEiZ0Wdsg3gBTvXTrF+mGI03zCPmSJWYoozdYYGiA11wdrwZSlycz4
         /i/2ycYyXxlhTDLPgPT8d7HeXqziet8Pk/HTK6fG+IrW3wE/ZFxtD5lLLvucOMfvHN4P
         OnvYzhpFk0LeFtwrEh8aCwnzHSGk7OqTxlIg8cAjqZnLLCUjGfsRlf/Ter8CLOi5Az2k
         JT4ihBgb0+2dcyW6LpjlZD2V7TlpzkZS+EuXMmwvlb9s+Y8SPJ+9CDw4OJCpsgKnu4wU
         eYqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683825503; x=1686417503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9g3QPSW366xmIBoE8HQa8vjGvWDy8pwzthEW0pwdt28=;
        b=j9QKFyzAbyDg3sF62jdlLtbzPBJWm3UjnSll/04Lb3zBmScGxTDcOLmFAPlEjHr5hx
         LhqUo86fb5UrH8Setq0DB/1ZTxoSK3R05ozzUPUkLje3wEImQ/q5GJzKnRyq3Gf9eLZf
         X19VqkgatByPmcDNe7Rnm+2O2K57uJJGdCPXPJMTgZ+ej7N2AWt6RMDl5fFrN2XeJuAd
         +hYV1SBTOjaYr7oxgomNVLm+oJojRmKxBKnwW+wXC3ysTkjw4hhsmgjeH1unYZUu7x+c
         VNCgpkcQfEcU5dUlcw1fWHX3wVtGdxxM8WIGwRYExOXCgKfgzBKCGEv1XIbrKYVGPdmT
         GEXw==
X-Gm-Message-State: AC+VfDyUiR4t5Yt1ctJ+Vqt0gyLCgiQM+eJnt8F9zrW4d8FzyrISUsYL
        NB1gxvrme7NADFt1B8SUvhs5ke5gXMVzPRlW8aiynQ==
X-Google-Smtp-Source: ACHHUZ43+BQhWUSZulu6UjBHzIWdkmWmLNZmOzHgMSGV0VvNDJlrAeTewbS6qaqSQipZKGmlTn2mDi8c09VzxKLRTOE=
X-Received: by 2002:a67:f047:0:b0:42c:761a:90ed with SMTP id
 q7-20020a67f047000000b0042c761a90edmr8867617vsm.6.1683825503429; Thu, 11 May
 2023 10:18:23 -0700 (PDT)
MIME-Version: 1.0
References: <ZErahL/7DKimG+46@x1n> <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n> <ZFLRpEV09lrpJqua@x1n> <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n> <ZFQC5TZ9tVSvxFWt@x1n> <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
 <ZFhO9dlaFQRwaPFa@x1n> <CAF7b7mqPdfbzj6cOWPsg+Owysc-SOTF+6UUymd9f0Mctag=8DQ@mail.gmail.com>
 <ZFwRuCuYYMtuUFFA@x1n>
In-Reply-To: <ZFwRuCuYYMtuUFFA@x1n>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 11 May 2023 10:17:56 -0700
Message-ID: <CALzav=e29rRw4TTRGpTkazgJpU1zPML3zQGoyeHj9Zbkq+yAdQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To:     Peter Xu <peterx@redhat.com>
Cc:     Anish Moorthy <amoorthy@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
        bgardon@google.com, ricarkol@google.com, kvm <kvm@vger.kernel.org>,
        kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 10, 2023 at 2:50=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
> On Tue, May 09, 2023 at 01:52:05PM -0700, Anish Moorthy wrote:
> > On Sun, May 7, 2023 at 6:23=E2=80=AFPM Peter Xu <peterx@redhat.com> wro=
te:
>
> What I wanted to do is to understand whether there's still chance to
> provide a generic solution.  I don't know why you have had a bunch of pmu
> stack showing in the graph, perhaps you forgot to disable some of the per=
f
> events when doing the test?  Let me know if you figure out why it happene=
d
> like that (so far I didn't see), but I feel guilty to keep overloading yo=
u
> with such questions.
>
> The major problem I had with this series is it's definitely not a clean
> approach.  Say, even if you'll all rely on userapp you'll still need to
> rely on userfaultfd for kernel traps on corner cases or it just won't wor=
k.
> IIUC that's also the concern from Nadav.

This is a long thread, so apologies if the following has already been discu=
ssed.

Would per-tid userfaultfd support be a generic solution? i.e. Allow
userspace to create a userfaultfd that is tied to a specific task. Any
userfaults encountered by that task use that fd, rather than the
process-wide fd. I'm making the assumption here that each of these fds
would have independent signaling mechanisms/queues and so this would
solve the scaling problem.

A VMM could use this to create 1 userfaultfd per vCPU and 1 thread per
vCPU for handling userfault requests. This seems like it'd have
roughly the same scalability characteristics as the KVM -EFAULT
approach.
