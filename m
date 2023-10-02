Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DF87B5A87
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 20:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238842AbjJBSqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 14:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbjJBSqD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 14:46:03 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A539AC
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 11:46:00 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c754c90b4bso1241345ad.2
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 11:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696272360; x=1696877160; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8kSRCnQrP7GCGBrc1UUOIIV1aoiUT07F0vO5xwuv0mE=;
        b=uJELmAMaz03XkhtSRIwYRCwoNVCOUZGsrWIjTzY+5RkJD1//I7I8GChWQifnTNx7wA
         n1QB0Ynz3IK9wHXXG16GcMKXyCqLHqilijZpeya3q/kiKXHrw0PaRbyX7lmKN68Z4lyg
         74OY29ZDmBCaf4VapcMCb0qr+qI6perSjSsEAbaHA/RNLxX5PC9jp+lYBMMH+CqW1qW7
         WcX8YloVIu1BLp+lEwksepLAG8ZThqP09I1x0vilwwuVr5JLTj7ygt9Qm6For86SzKHn
         zXZm0pEKBV8v7emR4rxgglmiglU9YSsh6/V1jewxyELbhccOnrZ7pKvfsJ+DVxF+XdFL
         Y4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696272360; x=1696877160;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8kSRCnQrP7GCGBrc1UUOIIV1aoiUT07F0vO5xwuv0mE=;
        b=jVp2XpU3K82zPHfLmFQhgw6k5rajjrKEkXRBqUIdxk4PoxsefXHCed+1CWTimO1we4
         Y+ok6rSalAX2FG4qqkUQYUvjr+XnqRdPEcMC0YFZXuyHfOXF4m0eTkTa9tMKjlfvtv54
         btTANx1swt/oDkKAasAyey3zqLQ0JZBQPtm2q9mK3rbZon1vpRNoAw2yfxzqZ11gmS3z
         J2tRnZK2E4VnTPUhP1eag/qMUqqiR8R8i1PnGQdT3B3tAInrRgZmsg+AxJsZriTIY6Op
         q73wvjdw0Z+paL/M0u/iTi/kdMS3bqiOXv7/CRgZTlV/GlJdXV6U2J1k+2+azpuLbO2f
         B+VA==
X-Gm-Message-State: AOJu0YwPevnZFbk9jWY92AXVwGoiGF2mR04Y8OHNSKQ434XPT8emxJHF
        4jmGatVJqud0MQ6uWjKXCoXy6VekmlI=
X-Google-Smtp-Source: AGHT+IFwNu2qW8CoPqxOWo5pHPn2BkknPX6/ha6VTGQvkh0EnmM8lW1B3hYnT7zbKi9Oua8Il85e+7AYD2I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4cd:b0:1c7:217c:3e4b with SMTP id
 o13-20020a170902d4cd00b001c7217c3e4bmr196964plg.5.1696272359895; Mon, 02 Oct
 2023 11:45:59 -0700 (PDT)
Date:   Mon, 2 Oct 2023 11:45:57 -0700
In-Reply-To: <ac097a26e96ded73e19200066b9063354096a8fd.camel@infradead.org>
Mime-Version: 1.0
References: <a3989e7ff9cca77f680f9bdfbaee52b707693221.camel@infradead.org>
 <ZRbolEa6RI3IegyF@google.com> <ee679de20e3a53772f9d233b9653fdc642781577.camel@infradead.org>
 <ZRsAvYecCOpeHvPY@google.com> <ac097a26e96ded73e19200066b9063354096a8fd.camel@infradead.org>
Message-ID: <ZRsP5cvyqLaihb76@google.com>
Subject: Re: [PATCH v2] KVM: x86: Use fast path for Xen timer delivery
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm <kvm@vger.kernel.org>, Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023, David Woodhouse wrote:
> On Mon, 2023-10-02 at 10:41 -0700, Sean Christopherson wrote:
> > On Fri, Sep 29, 2023, David Woodhouse wrote:
> > > On Fri, 2023-09-29 at 08:16 -0700, Sean Christopherson wrote:
> > > > On Fri, Sep 29, 2023, David Woodhouse wrote:
> > > > > From: David Woodhouse <dwmw@amazon.co.uk>
> > > > >=20
> > > > > Most of the time there's no need to kick the vCPU and deliver the=
 timer
> > > > > event through kvm_xen_inject_timer_irqs(). Use kvm_xen_set_evtchn=
_fast()
> > > > > directly from the timer callback, and only fall back to the slow =
path
> > > > > when it's necessary to do so.
> > > >=20
> > > > It'd be helpful for non-Xen folks to explain "when it's necessary".=
=C2=A0 IIUC, the
> > > > only time it's necessary is if the gfn=3D>pfn cache isn't valid/fre=
sh.
> > >=20
> > > That's an implementation detail.
> >=20
> > And?=C2=A0 The target audience of changelogs are almost always people t=
hat care about
> > the implementation.
> >
> > > Like all of the fast path functions that can be called from
> > > kvm_arch_set_irq_inatomic(), it has its own criteria for why it might=
 return
> > > -EWOULDBLOCK or not. Those are *its* business.
> >=20
> > And all of the KVM code is the business of the people who contribute to=
 the kernel,
> > now and in the future.=C2=A0 Yeah, there's a small chance that a detail=
ed changelog can
> > become stale if the patch races with some other in-flight change, but e=
ven *that*
> > is a useful data point.=C2=A0 E.g. if Paul's patches somehow broke/degr=
aded this code,
> > then knowing that what the author (you) intended/observed didn't match =
reality when
> > the patch was applied would be extremely useful information for whoever=
 encountered
> > the hypothetical breakage.
>=20
> Fair enough, but on this occasion it truly doesn't matter. It has
> nothing to do with the implementation of *this* patch. This code makes
> no assumptions and has no dependency on *when* that fast path might
> return -EWOULDBLOCK. Sometimes it does, sometimes it doesn't. This code
> just doesn't care one iota.
>=20
> If this code had *dependencies* on the precise behaviour of
> kvm_xen_set_evtchn_fast() that we needed to reason about, then sure,
> I'd have written those explicitly into the commit comment *and* tried
> to find some way of enforcing them with runtime warnings etc.
>=20
> But it doesn't. So I am no more inclined to document the precise
> behaviour of kvm_xen_set_evtchn_fast() in a patch which just happens to
> call it, than I am inclined to document hrtimer_cancel() or any other
> function called from the new code :)

Just because some bit of code doesn't care/differentiate doesn't mean the b=
ehavior
of said code is correct.  I agree that adding a comment to explain the gory=
 details
is unnecessary and would lead to stale code.  But changelogs essentially ca=
pture a
single point in a time, and a big role of the changelog is to help reviewer=
s and
readers understand (a) the *intent* of the change and (b) whether or not th=
at change
is correct.

E.g. there's an assumption that -EWOULDBLOCK is the only non-zero return co=
de where
the correct response is to go down the slow path.

I'm not asking to spell out every single condition, I'm just asking for cla=
rification
on what the intended behavior is, e.g.

  Use kvm_xen_set_evtchn_fast() directly from the timer callback, and fall
  back to the slow path if the event is valid but fast delivery isn't
  possible, which currently can only happen if delivery needs to block,
  e.g. because the gfn=3D>pfn cache is invalid or stale.

instead of simply saying "when it's necessary to do so" and leaving it up t=
o the
reader to figure what _they_ think that means, which might not always align=
 with
what the author actually meant.

> > > And in fact one of Paul's current patches is tweaking them subtly, bu=
t that
> > > isn't relevant here. (But yes, you are broadly correct in your
> > > understanding.)
> > >=20
> > > > > This gives a significant improvement in timer latency testing (us=
ing
> > > > > nanosleep() for various periods and then measuring the actual tim=
e
> > > > > elapsed).
> > > > >=20
> > > > > However, there was a reason=C2=B9 the fast path was dropped when =
this support
> > > >=20
> > > > Heh, please use [1] or [*] like everyone else.=C2=A0 I can barely s=
ee that tiny little =C2=B9.
> > >=20
> > > Isn't that the *point*? The reference to the footnote isn't supposed =
to
> > > detract from the flow of the main text. It's exactly how you'll see i=
t
> > > when typeset properly.
> > =C2=A0
> > Footnotes that are "typeset properly" have the entire footnote in a dif=
ferent
> > font+size.=C2=A0 A tiny number next to normal sized text just looks wei=
rd to me.
> >=20
> > And I often do a "reverse lookup" when I get to footnotes that are link=
s, e.g. to
> > gauge whether or not it's worth my time to follow the link.=C2=A0 Tryin=
g to find the
> > tiny =C2=B9 via a quick visual scan is an exercise in frustration, at l=
east for the
> > monospace font I use for reading mail, e.g. it's much more readable on =
my end in
> > an editor using a different font.
> >=20
> > Which is a big benefit to sticking to the old and kludgly ASCII: it pro=
vides a
> > fairly consistent experience regardless of what client/font/etc each re=
ader is
> > using.=C2=A0 I'm not completely against using unicode characters, e.g. =
for names with
> > characters not found in the Latin alphabet, but for code and things lik=
e this,
> > IMO simpler is better.
> >=20
> > > I've always assumed the people using [1] or [*] just haven't yet real=
ised
> > > that it's the 21st century and we are no longer limited to 7-bit ASCI=
I. Or
> > > haven't worked out how to type anything but ASCII.
> >=20
> > Please don't devolve into ad hominem attacks against other reviews and =
contributors.
> > If you want to argue that using footnote notation unicode is superior i=
n some way,
> > then by all means, present your arguments.
>=20
> Hey, you started the logical fallacies with the ad populum when you
> said "everyone else" :)
>
> Not that that was true; there are examples of =C2=B9 being used in the
> kernel changelog going back decades.

LOL, fine, "almost everyone else".
