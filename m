Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446DB679FF9
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 18:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbjAXRSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 12:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbjAXRSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 12:18:47 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A97A4AA5E
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 09:18:45 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id w15so1399882qvs.11
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 09:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2LfJhFw/HjO85prr/+n24x4Lw1Az/iZVTOQ35U0vJPk=;
        b=YhoP2h9cs4sVzS+YglFxNK6Rcqx0MUi+FwfrQ33wk3UzCGOz8WkUtj2LzXW5IX9yXd
         8mnyP4IRqSQTUvazAsZdKWFmyM8zXk0deXkY5KxAdLc53ki0RzafOvOLvsqsB35/akJk
         uEiGearyMAcRkIKHjuOGK1/mYKxmS5BLD99/vt6s4pPwqc6v/1jgidlCckucMcuEp5gj
         bKfaNcITx+kkfCaGe9FTPZydnUdojwlVP/CrmZdn+nQYyyCOmBDdizYdHn3Xmg96MjU5
         ai/3P/ypTE5JfpVANAk+9XCzAwPwr2KyM8zV6aj6ZhpBDKMlntFz+CkaazfSnXS6vOSX
         BE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2LfJhFw/HjO85prr/+n24x4Lw1Az/iZVTOQ35U0vJPk=;
        b=QB7PiOZvmEr0hvUOYIMI5YJ5/Op/e5S2/l9GZqJb1X7VeAlg+rb9USOcbvoX6sfRaA
         BTXlPiMRjFlRCPwN5wsFWhhpoeLedk0LgODi4Z3jYQSD6MrBtaylJfTWjjado1Kk1y2x
         JtgceJpl9o3MgZNhef7LnIUelslEeEi7o0dEzKKVCsatFC0T9g4hE+QXSAOPpbG/eIBV
         ZRPqxQHH05iV8xoBAW+0eUNwNnB88M5T4yes62k3MtwdnvWZhSVM0kJp79LsWG5O1/Pt
         JBXcrWpxRmBdQVpbTO9Y7EGQR9y5qwUYoAUxxGRZWs7vJj2R8MEjCiM6iDr2rYjSJoKp
         ymeA==
X-Gm-Message-State: AFqh2kozZHskdrJyAXD4ujRM4at7bAMAsaIOA9mEMGtFrTNIAkPKKJgC
        EKHk7V0Sp0s79guwVDdVKGcQEJRdii/GRMP5PPH73g==
X-Google-Smtp-Source: AMrXdXt/fh2hub/gv2zmH5rPavw+lkx8d22y/t4FGs5wmiizn+95CKFFDpttcMeya72+jvskubmaSBZMJYIcUuKB+kE=
X-Received: by 2002:a05:6214:3113:b0:532:2acf:2577 with SMTP id
 ks19-20020a056214311300b005322acf2577mr1237633qvb.5.1674580724279; Tue, 24
 Jan 2023 09:18:44 -0800 (PST)
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-4-ricarkol@google.com>
 <CANgfPd_PgrZ_4oRDT3ZaqX=3jboD=2qEUKefp4TsKM36p187gw@mail.gmail.com>
 <Y9ALgtnd+h9ivn90@google.com> <Y9ARN5hWlAYVFBoK@google.com>
In-Reply-To: <Y9ARN5hWlAYVFBoK@google.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Tue, 24 Jan 2023 09:18:33 -0800
Message-ID: <CAOHnOrxGu2sU2+-M8+-nMiRc01BQvRug+S2rnBbK6HiCP_BMVw@mail.gmail.com>
Subject: Re: [PATCH 3/9] KVM: arm64: Add kvm_pgtable_stage2_split()
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Ben Gardon <bgardon@google.com>, pbonzini@redhat.com,
        maz@kernel.org, yuzenghui@huawei.com, dmatlack@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 24, 2023 at 9:11 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Tue, Jan 24, 2023 at 08:46:58AM -0800, Ricardo Koller wrote:
> > On Mon, Jan 23, 2023 at 05:03:23PM -0800, Ben Gardon wrote:
>
> [...]
>
> > > Would it be accurate to say:
> > > /* No huge pages can exist at the root level, so there's nothing to
> > > split here. */
> > >
> > > I think of "last level" as the lowest/leaf/4k level but
> > > KVM_PGTABLE_MAX_LEVELS - 1 is 3?
> >
> > Right, this is the 4k level.
> >
> > > Does ARM do the level numbering in
> > > reverse order to x86?
> >
> > Yes, it does. Interesting, x86 does
> >
> >       iter->level--;
> >
> > while arm does:
> >
> >       ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
> >
> > I don't think this numbering scheme is encoded anywhere in the PTEs, so
> > either architecture could use the other.
>
> The numbering we use in the page table walkers is deliberate, as it
> directly matches the Arm ARM. While we can certainly use either scheme
> I'd prefer we keep aligned with the architecture.

hehe, I was actually subtly suggesting our x86 friends to change their side.

>
> --
> Thanks,
> Oliver
