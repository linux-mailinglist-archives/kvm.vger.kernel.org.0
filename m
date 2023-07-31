Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8286376A04F
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 20:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbjGaSY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 14:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjGaSYZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 14:24:25 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF9A1BC1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 11:24:18 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-583f048985bso64132387b3.2
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 11:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690827857; x=1691432657;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1/EEbSVk8mYUaE0SN2Bc3r0yvzs2EUpAITVg+S9v2GQ=;
        b=7KjY1kSiElTJJuWBtAviRpp0weoOhE9oS4UCQPAuEZZZEIwV/BvF4nUtoWY0vI52sc
         xoW23xcaYg72EmDFuPZnPGybPBO9COaGwV2/7T0gpn39T86VkIxqalsDeeo2bzfjEWTj
         ECm7AYM4CNa0RriXcN/bgaFRDqe6S1IzGkjjQCyXMttNvTMKx8aehMEQ08onWOMQLakS
         bl7pV2sGnTHeC36WawODw2/ZoURh+EAnUGUV/oqTPIrDmJ1j9l+4hndcrrr+hDaQrElA
         pE0uAhThPdNIF+bYSgtfG34z3QcqblFsh1qxblqtIgwVvqZaudQDJoE8nrdZgCLf1YbR
         yz0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690827857; x=1691432657;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1/EEbSVk8mYUaE0SN2Bc3r0yvzs2EUpAITVg+S9v2GQ=;
        b=PY9S2m9ra3DpJ/4QbhVgsZad6Ah2PdoZfePmqhsypnI2nFF+zYD4+GNyB8CBiSZC3S
         0cgUO5YzwZiiBqPOlrC4p/UUPMaqCHqHCfVMwtozrSIOvOPK+V0rEJ14liJJSkZl9w18
         EfKUQus3aMgX2sUAUN2GVh9IeL/43oFjBiqK35WuKjSxmovoLP+AJPomAdRSq+WoqVtk
         Ti//AdBqkIsym2A7TfXbeXjNRZ7UyEHL2Rx1raRQTHjyd/2SsBcl6U4Gsuz8AzkCU2vB
         +s6cXKrJiI64fCAC2qD85oWLkJu0k06IcbrisARH4d96lvceMazs7OsZk7DtMonGn2mE
         8B8Q==
X-Gm-Message-State: ABy/qLbPLgxS9mVa20xG+I+fJfNtszQhrsDvWw+wnDWgPiGaS4N04ntl
        Ls/FSp4jlx6Dii24pfhAo6uuAy5gTUI=
X-Google-Smtp-Source: APBJJlHfP3UCtqpjLxnNoRj1P91ZUliT249SqC2lLpi/z81MpLIjgiv9NNNd9grIXWF0TSe6XS87mDvlqn0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a784:0:b0:577:d5b:7ce3 with SMTP id
 e126-20020a81a784000000b005770d5b7ce3mr84601ywh.9.1690827857409; Mon, 31 Jul
 2023 11:24:17 -0700 (PDT)
Date:   Mon, 31 Jul 2023 11:24:15 -0700
In-Reply-To: <ZMf1TkrUjP6+/VSC@google.com>
Mime-Version: 1.0
References: <20230626182016.4127366-1-mizhang@google.com> <20230626182016.4127366-3-mizhang@google.com>
 <ec65c77a-3499-6278-f352-9bbe25a44b96@infradead.org> <ZMf1TkrUjP6+/VSC@google.com>
Message-ID: <ZMf8T8kdiDJlqtmS@google.com>
Subject: Re: [PATCH v2 2/6] KVM: Documentation: Update the field name gfns and
 its description in kvm_mmu_page
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023, Mingwei Zhang wrote:
> On Mon, Jun 26, 2023, Randy Dunlap wrote:
> > Hi--
> > 
> > On 6/26/23 11:20, Mingwei Zhang wrote:
> > > Update the field 'gfns' in kvm_mmu_page to 'shadowed_translation' to be
> > > consistent with the code. Also update the corresponding 'gfns' in the
> > > comments. The more detailed description of 'shadowed_translation' is
> > > already inlined in the data structure definition, so no need to duplicate
> > > the text but simply just update the names.
> > > 
> > > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > > Reviewed-by: Kai Huang <kai.huang@intel.com>
> > > ---
> > >  Documentation/virt/kvm/x86/mmu.rst | 9 +++++----
> > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> > > index 561efa8ec7d7..4c9044b4dc6c 100644
> > > --- a/Documentation/virt/kvm/x86/mmu.rst
> > > +++ b/Documentation/virt/kvm/x86/mmu.rst
> > > @@ -221,11 +221,12 @@ Shadow pages contain the following information:
> > >      at __pa(sp2->spt).  sp2 will point back at sp1 through parent_pte.
> > >      The spt array forms a DAG structure with the shadow page as a node, and
> > >      guest pages as leaves.
> > > -  gfns:
> > > -    An array of 512 guest frame numbers, one for each present pte.  Used to
> > > -    perform a reverse map from a pte to a gfn. When role.direct is set, any
> > > +  shadowed_translation:
> > > +    An array of 512 shadow translation entries, one for each present pte. Used
> > > +    to perform a reverse map from a pte to a gfn. When role.direct is set, any
> > >      element of this array can be calculated from the gfn field when used, in
> > > -    this case, the array of gfns is not allocated. See role.direct and gfn.
> > > +    this case, the array of shadowed_translation is not allocated. See
> > 
> > I cannot parse the before version nor the after version of this sentence (new version):
> > 
> >                                                   When role.direct is set, any
> >     element of this array can be calculated from the gfn field when used, in
> >     this case, the array of shadowed_translation is not allocated.
> > 
> > 
> 
> Sorry for the late reply.  Why is it not parsed? It just means that when
> role.direct is set, do not use gfns. The gfn can be calculated from the
> base address + offset. The base address here is the 'gfn' field in
> kvm_mmu_page.

It's a bit of a run-on sentence with confusing pronoun usage.  How about this?

  When role.direct is set, the shadow_translation array is not allocated as the
  per-SPTE gfn is simply an offset from the base gfn, and KVM doesn't track
  access permissions for direct shadow pages.
