Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D1D4D919C
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 01:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344004AbiCOAcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 20:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343959AbiCOAci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 20:32:38 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515323AA70
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 17:31:27 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2d07ae0b1c4so183941647b3.11
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 17:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YnoyBJB4Vv+r/cyuNhSI23nMPjDoxQQKXvsuHnpgbcI=;
        b=PSFX9gfeFcOI3JOPqNvJetxxmUTBlvBY8E8nVXjfau+zKPvT4Ae1Miv61r/b0yl+Jy
         9ov2T/6OM54/+FPS1f9ldXjbCnRrDSNOGFc64criJJ5uhfyuemoZqlJqcXbMtyfJsX7E
         XHWFBFDIOYnCpY9ZJA7YgtgUkK+l5vHyw+omD5kCIBWNzv1r1n4Ewsxziq1TYVn43Xyr
         jFTKLJB48bTExvvnMVYSmW3nOmzzqFoLhq3s7QWWw8rGUivo17gAE65VBEWONLAsO4En
         uTrubKEXSj4wv+pZGX/QRaKfMf538zH0eDKlynRFg2sX6wI5YSxV2QQHptfBHrqNMEEc
         VBkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YnoyBJB4Vv+r/cyuNhSI23nMPjDoxQQKXvsuHnpgbcI=;
        b=zoc/n3FJ1ykU1G53m8z4RD9vWoPIoBGq4S3kFezx15O64GA3CUUCOrUqwJ+vgx6Xbh
         XDgXbJic82ZG/O9hrVuCYUIqEsyaVfsCgaGSyDdvx1+Pz8w1rjZcoMXfPdNS8x1vUR9I
         rtAuD3Rah7kWrwYiLEnUBUjSlb5mK3eSExxDDEcHqkU6oR0h7XtxQMz1HJ1Yji3qG2G0
         F3G48wKHAgadRA7ytUTN1R//4EHx9xJBuSF5LPvXOK0JJ9qObBr+BxkMiqjFfI4+u5c+
         jonkpzN6L5X4xevzwdW5MjBVOGGpyNxBRGjxmDCPl4wrcdBxUUggxuKY8Uju63PVCiXp
         EJ9w==
X-Gm-Message-State: AOAM532uvQQ9NawdsikCXFjB6TkHOE/2cfZ4Plp65ORfzfxi6P24x3wC
        PjrhPxhdzx+n0HkZPsZdv7wrq2GF8SD10pWeB3uxeg==
X-Google-Smtp-Source: ABdhPJx0ZQH+VD+ZyMThZH6pJAH5dliNKcrn86KX8y9RAJDtsJQVBBS5ElKUjCu1XR/RgGug+LADQgGpd2KZUUJ1lsA=
X-Received: by 2002:a81:57c5:0:b0:2d6:eefb:a518 with SMTP id
 l188-20020a8157c5000000b002d6eefba518mr22401412ywb.427.1647304286043; Mon, 14
 Mar 2022 17:31:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com> <20220224172559.4170192-10-rananta@google.com>
 <Yi+fNr9w28Nz2j3G@google.com>
In-Reply-To: <Yi+fNr9w28Nz2j3G@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 14 Mar 2022 17:31:14 -0700
Message-ID: <CAJHc60z5cuGHquGa-06=p3SuZrwu1pjh75f1ccHhuCUzvnT5Hg@mail.gmail.com>
Subject: Re: [PATCH v4 09/13] Docs: KVM: Rename psci.rst to hypercalls.rst
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Mar 14, 2022 at 1:02 PM Oliver Upton <oupton@google.com> wrote:
>
> On Thu, Feb 24, 2022 at 05:25:55PM +0000, Raghavendra Rao Ananta wrote:
> > Since the doc now covers more of general hypercalls'
> > details, rather than just PSCI, rename the file to a
> > more appropriate name- hypercalls.rst.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>
> You should move the file before adding to it IMO (switch this patch with
> the previous one).
>
Sure, I can do that.

Regards,
Raghavendra

> Reviewed-by: Oliver Upton <oupton@google.com>
>
> > ---
> >  Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} | 0
> >  1 file changed, 0 insertions(+), 0 deletions(-)
> >  rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (100%)
> >
> > diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> > similarity index 100%
> > rename from Documentation/virt/kvm/arm/psci.rst
> > rename to Documentation/virt/kvm/arm/hypercalls.rst
> > --
> > 2.35.1.473.g83b2b277ed-goog
> >
