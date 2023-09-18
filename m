Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE307A50B5
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 19:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjIRRMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 13:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbjIRRMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 13:12:21 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E165E95
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:12:14 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c43cd8b6cbso22255965ad.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695057134; x=1695661934; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=659GHH68Qik1MotwcN3AFB6jrNnzdXDCMl8drsSEIHc=;
        b=hLGbuAKrE9DTWGy1Riv8q2MsmtJU0sgfB7owLe8oD59FJwWjNltypX2v6lqJ649R7W
         WSiRqstwLarwAF/w8g1/wEfN28U0C7wFGOgS1QZKy56JhWC/Bqf+RCcDpwvszrBAGkHg
         JoxTeVPsztu919g6A6R285gjT0Ub/dhEBi18DWdSvIUpgGrtbTwaOv2Of4cwJTO/T9IO
         c7dLJPjcYQClGbF9YeSmAcg2IQHH0E7AyS27V1bG0n1TETXOUET1c82uhxLjbSfhS7RD
         LEUCucqaSkR5KX4jYFA63Z9fBss4m7rXRU0sJ0R/fIRm0dId7vG296MpSb2fSkXN6U95
         jGTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695057134; x=1695661934;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=659GHH68Qik1MotwcN3AFB6jrNnzdXDCMl8drsSEIHc=;
        b=hZOVW4snIbJS9ru7Oa/nQjZdPcp1M7/PHz8ZAoq1kwdmZSUxlelKcsTq6cQuzpL+JY
         PGJVnOdUuLIJr7JXBnt9H51kYCj6ZmxBa0zOTen1xONYZtukziYXqcbKvYQ1k3ptY6RW
         +VxJuIiBgmUVA0cLO40l6TODng8MrGrFx1tg3DjFGdjediI06n71/xKxF+BZH7twPWOz
         jIQODXugAyxONREeZNVMZ8WhBXrKlxmT6nQdKgjED2XTc2PBT76AzItg8AWKoTvgF14X
         HdqoIRJPDopyDw5s5nKA7Wvecj/fHeZL6VdijhgnXtdf/XnNWdBNRRzGcSzoaV5XQ6LF
         7U5A==
X-Gm-Message-State: AOJu0YyCviOMlOmNa6m9bN9M5SNxLZtHePM0VhFYXcjfkF5GPI8orGH4
        a3j8G8q75vRlvtL7tiaZQgrwrfkxIXM=
X-Google-Smtp-Source: AGHT+IEiOkDRbui71X/Bu81O+8Z/DgF8jElm9dyqi3kpEzI1O15GI4wzIYS9rPRXIl0kVb/BtCX43B8uLxU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:db01:b0:1c3:411c:9b7c with SMTP id
 m1-20020a170902db0100b001c3411c9b7cmr198939plx.13.1695057134315; Mon, 18 Sep
 2023 10:12:14 -0700 (PDT)
Date:   Mon, 18 Sep 2023 10:12:13 -0700
In-Reply-To: <8527f707315812d9ac32201b37805256fab4a0a1.camel@infradead.org>
Mime-Version: 1.0
References: <20230918144111.641369-1-paul@xen.org> <ZQh4Zi5Rj3RP9Niw@google.com>
 <8527f707315812d9ac32201b37805256fab4a0a1.camel@infradead.org>
Message-ID: <ZQiE7SExjbCVffAE@google.com>
Subject: Re: [PATCH v3 00/13] KVM: xen: update shared_info and vcpu_info handling
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paul Durrant <paul@xen.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Durrant <pdurrant@amazon.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023, David Woodhouse wrote:
> On Mon, 2023-09-18 at 09:18 -0700, Sean Christopherson wrote:
> > On Mon, Sep 18, 2023, Paul Durrant wrote:
> > > From: Paul Durrant <pdurrant@amazon.com>
> > >=20
> > > Currently we treat the shared_info page as guest memory and the VMM i=
nforms
> > > KVM of its location using a GFN. However it is not guest memory as su=
ch;
> > > it's an overlay page. So we pointlessly invalidate and re-cache a map=
ping
> > > to the *same page* of memory every time the guest requests that share=
d_info
> > > be mapped into its address space. Let's avoid doing that by modifying=
 the
> > > pfncache code to allow activation using a fixed userspace HVA as well=
 as
> > > a GPA.
> > >=20
> > > Also, if the guest does not hypercall to explicitly set a pointer to =
a
> > > vcpu_info in its own memory, the default vcpu_info embedded in the
> > > shared_info page should be used. At the moment the VMM has to set up =
a
> > > pointer to the structure explicitly (again treating it like it's in
> > > guest memory, despite being in an overlay page). Let's also avoid the
> > > need for that. We already have a cached mapping for the shared_info
> > > page so just use that directly by default.
> >=20
> > 1. Please Cc me on *all* patches if you Cc me on one patch.=C2=A0 I bel=
ive this is
> > =C2=A0=C2=A0 the preference of the vast majority of maintainers/reviewe=
rs/contributors.
> > =C2=A0=C2=A0 Having to go spelunking to find the rest of a series is an=
noying.
> >=20
> > 2. Wait a reasonable amount of time between posting versions.=C2=A0 1 h=
our is not
> > =C2=A0=C2=A0 reasonable.=C2=A0 At an *absolute minimum*, wait 1 busines=
s day.
> >=20
> > 3. In the cover letter, summarize what's changed between versions.=C2=
=A0 Lack of a
> > =C2=A0=C2=A0 summary exacerbates the problems from #1 and #2, e.g. I ha=
ve a big pile of
> > =C2=A0=C2=A0 mails scattered across my mailboxes, and I am effectively =
forced to find and
> > =C2=A0=C2=A0 read them all if I want to have any clue as to why I have =
a 12 patch series
> > =C2=A0=C2=A0 on version 3 in less than two business days.
>=20
> I meant to mention that too.
>=20
> > P.S. I very much appreciate that y'all are doing review publicly, thank=
 you!
>=20
> Well, to a certain extent you can't have both #2 and the P.S. Or at
> least doesn't work very well if we try.
>=20
> Paul and I were literally sitting in the same room last Friday talking
> about this, and of course you saw the very first iteration of it on the
> mailing list rather than it being done in private and then presented as
> a fait accompli.=C2=A0We try to set that example for those around us.
>=20
> (Just as you saw the very first attempt at the exit-on-hlt thing, and
> the lore.kernel.org link was what I gave to my engineers to tell them
> to see what happens if they try that.)
>=20
> And there *are* going to be a couple of rounds of rapid review and
> adjustment as we start from scratch in the open, as I firmly believe
> that we should. I *want* to do it in public and I *want* you to be able
> to see it, but I don't necessarily think it works for us to *wait* for
> you. Maybe it makes more sense for you to dive deep into the details
> only after the rapid fire round has finished?
>=20
> Unless you don't *want* those first rounds to be in public? But I don't
> think that's the right approach.
>=20
> Suggestions welcome.
>=20
> Maybe in this particular case given that I said something along the
> lines of "knock something up and let's see how I feel about it when I
> see it", it should be using an 'RFC' tag until I actually approve it?
> Not sure how to extrapolate that to the general case, mind you.

Tag them RFC, explain your expectations, goals, and intent in the cover let=
ter,
don't copy+paste cover letters verbatim between versions, and summarize the=
 RFC(s)
when you get to a point where you're ready for others to jump in.  The cove=
r
letter is *identical* from v1=3D>v2=3D>v3, how is anyone supposed to unders=
tand what
on earth is going on unless they happened to be in the same room as ya'll o=
n
Friday?

Doing rapid-fire, early review on beta-quality patches is totally fine, so =
long
as it's clear that others can effectively ignore the early versions unless =
they
are deeply interested or whatever.

A disclaimer at the top of the cover letter, e.g.

  This series is a first attempt at an idea David had to improve performanc=
e
  of the pfncache when KVM is emulating Xen.  David and I are still working=
 out
  the details, it's probably not necessary for other folks to review this r=
ight
  now.

along with a summary of previous version and a transition from RFC =3D> non=
-RFC
makes it clear when I and others are expected to get involved.

In other words, use tags and the cover letter to communicate, don't just vi=
ew the
cover letter as a necessary evil to get people to care about your patches.
