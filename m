Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A34443538
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 19:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbhKBSQI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 14:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbhKBSQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 14:16:08 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8ADBC061203
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 11:13:32 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id y26so265271lfa.11
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 11:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3aAa2g6F5cEPDJn1H2dtRZP1YIEtghO4gfoLlk3Pcbw=;
        b=GfYlX9OX1sXNX3bqVCRC2BllZhiCQ8NlGee8f88VSWYP2ig7CAf2Utra5o2oD74c2m
         +LjbuarZU+QVe8722G9iG/Teg9V+KcqsX7jhPWSWsrMbt/+96RWuBKMlxbX1mZC6qwJL
         8y5WE3+1DVmd5KG7eWHV5sNzPGKyrj+Xzf3WdLkvC/FYsEJtUniSvAYJm7MX6ewTxgOy
         FDC2VdZZVY1yQ2bbhwySRoE9HsQ2vLGfsXW80jdTrOFsJ6EKRLaPDzinyL9R8o9A2CJL
         nUvoPS7fgisBAp0eYwymB/TozwaXgxlAMK4KJ6zTIv36tvXmIoyBh1R/s72FpjxvNflN
         aa4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3aAa2g6F5cEPDJn1H2dtRZP1YIEtghO4gfoLlk3Pcbw=;
        b=hYxkQkoU8FXfqr/xwTYdwbkfg2dYzkRU+OM8a2+JQ05g8hSMC8XqxefPNEEQLh17PL
         lY+Su7YF5sAm4vE1tu5h3PhTrUQufIE0qL1/gZ0vxN8h528FE0SawzGbpBP84DxCAT5T
         /LWiaof6NU01v+Sq+bylH1SfGIjr3PEiD1/kqoctrSI0euRRyoGjF6m+fK10DliVojfy
         pX+Hu79NcT7DFCfNo5vSmPLXQOOJxnr+rKizFoOEotampDL1ofbKwPP1M9BCsYVFZ/FE
         Jhz9uYkkRY8SBXzaCTBpWehIGe4sjC+D1hhJKtx1UI5BU3PICoE7o70eltqNUzLtmFkR
         YFdA==
X-Gm-Message-State: AOAM5325lrdpqQtCPFVmD5V80Big+nWA7dfGXmHTmM1wAY46Uyaqa8wR
        W0dHCPA//h1grSjL8S18Xooiz9/ZR2Ra8ZF/0Bvhww==
X-Google-Smtp-Source: ABdhPJzQPbuMorJmK9nCRvVx6XoY1VFFKPA5GSxKNeEFkMIqDPnhiabLHyeOXvMUuFZ9AiY07W2nVcpOLfoYU8dKgiA=
X-Received: by 2002:a05:6512:3c9e:: with SMTP id h30mr5245802lfv.93.1635876810700;
 Tue, 02 Nov 2021 11:13:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211011194615.2955791-1-vipinsh@google.com> <YWSdTpkzNt3nppBc@google.com>
 <CALMp9eRzPXg2WS6-Yy6U90+B8wXm=zhVSkmAym4Y924m7FM-7g@mail.gmail.com>
 <YWhgxjAwHhy0POut@google.com> <CALMp9eQ4y+YO7THjfpHzJPmoODkUqoPUURaBvL+OdGjZhAMuTA@mail.gmail.com>
In-Reply-To: <CALMp9eQ4y+YO7THjfpHzJPmoODkUqoPUURaBvL+OdGjZhAMuTA@mail.gmail.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 2 Nov 2021 11:12:53 -0700
Message-ID: <CAHVum0eMByJA5Yc0iom6w5+Web105cYoJ-94jxzLPTLVpYOHSw@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Add a wrapper for reading INVPCID/INVEPT/INVVPID
 type
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry for the late reply.

On Thu, Oct 14, 2021 at 10:05 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Thu, Oct 14, 2021 at 9:54 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Oct 11, 2021, Jim Mattson wrote:
> > > On Mon, Oct 11, 2021 at 1:23 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Mon, Oct 11, 2021, Vipin Sharma wrote:
> > > > > -     if (type > 3) {
> > > > > +     if (type > INVPCID_TYPE_MAX) {
> > > >
> > > > Hrm, I don't love this because it's not auto-updating in the unlikely chance that
> > > > a new type is added.  I definitely don't like open coding '3' either.  What about
> > > > going with a verbose option of
> > > >
> > > >         if (type != INVPCID_TYPE_INDIV_ADDR &&
> > > >             type != INVPCID_TYPE_SINGLE_CTXT &&
> > > >             type != INVPCID_TYPE_ALL_INCL_GLOBAL &&
> > > >             type != INVPCID_TYPE_ALL_NON_GLOBAL) {
> > > >                 kvm_inject_gp(vcpu, 0);
> > > >                 return 1;
> > > >         }
> > >
> > > Better, perhaps, to introduce a new function, valid_invpcid_type(),
> > > and squirrel away the ugliness there?
> >

I might not have understood your auto-updating concern correctly, can
I change these macros to an enum like:

enum INVPCID_TYPE {
        INVPCID_TYPE_INDIV_ADDR,
        INVPCID_TYPE_SINGLE_CTXT,
        INVPCID_TYPE_ALL_INCL_GLOBAL,
        INVPCID_TYPE_ALL_NON_GLOBAL,
        INVPCID_TYPE_MAX,
};

My check in the condition will be then "if (type >= INVPCID_TYPE_MAX) {}"
This way if there is a new type added, max will be auto updated. Will
this answers your concern?

> > Oh, yeah, definitely.  I missed that SVM's invpcid_interception() has the same
> > open-coded check.
> >
> > Alternatively, could we handle the invalid type in the main switch statement?  I
> > don't see anything in the SDM or APM that architecturally _requires_ the type be
> > checked before reading the INVPCID descriptor.  Hardware may operate that way,
> > but that's uArch specific behavior unless there's explicit documentation.
>
> Right. INVVPID and INVEPT are explicitly documented to check the type
> first, but INVPCID is not.

It seems to me that I can move type > 3 check to kvm_handle_invpcid()
switch statement. I can replace BUG() in that switch statement with
kvm_inject_gp for the default case, I won't even need INVPCID_TYPE_MAX
in this case.

If you are fine with this approach then I will send out a patch where
invalid type is handled  in kvm_handle_invpcid() switch statement.

Thanks
Vipin
