Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA297B5939
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 19:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbjJBRlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 13:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjJBRlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 13:41:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E40B4
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 10:41:19 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c647150c254so5570751276.1
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 10:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696268478; x=1696873278; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I2qKfz7FtuCEEAr+FcQImglSqV/M/oqG44A6BkuudUw=;
        b=dPHhWy+hGEDlRGcGkulurwXrOCxu9sBMcdnT8nqQc5I2JcP3p2ejk4MjobB8ILhQMf
         VIPkgNob7GM0BE6n0M+5HuZMUOdcTyxKAVXKn9GqUKwtSpJvDbNtGpcLHcHSql3KVet4
         hHLiUS0qisE5YPoWVw6O/W7IwWxsJJ4XH9Vt5LcRXXoDdXsZsWMm4+2Bxwes2uiWC0AP
         zC4Jl8p/RTgjfzXw8eBg/i4rv0ukHBozybhbEqyvAXj9GuxlqvbMBwiRHDyflovkJ3Uz
         eqKDp9pN9uSRa0revh0VhBw8W5VTNjRyaBpz99LDVelHykN1W3JbzbgJvd7ogzuyu2vJ
         TR/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696268478; x=1696873278;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=I2qKfz7FtuCEEAr+FcQImglSqV/M/oqG44A6BkuudUw=;
        b=A/HzHn/DxqvIHfd/tt1MlM4N9vnwGIWeabMr2w+M5aqdUt9g2d7IE9E1Fuz07RBRwU
         4ZrSmMDQ1dLX83Rw/070Hara+lRll2P2ozx34poZO0HU0IDm2nJ1a2vaTW0f9ddnD89R
         b4xgp2xyMMT7oxZflBk+Ra7yNE/Xtsb0Yy0Gze2dSCSaPKUhb6FC/IF0dOQHTT6G3XwB
         yDChx6phwtQHWnaAKyxvkkS/ZwghNDeT94yQxp9dbx3awiUcilYpz3i2Ql6Yn9avmypo
         G9asqLAxf659oirsvcvXbDeWH+u2utxNEDlw6cWPf04MnM6CWjCBKRAKSXwDQcnJhAt1
         HiJQ==
X-Gm-Message-State: AOJu0YzjnpXg4x7J5zFnSG/z4kl2QaCKH8/0oRM3prHGVXxOuyi+q/Gq
        rTrhQ7EsVUeLUF6zem24xQac1uRpYvg=
X-Google-Smtp-Source: AGHT+IHEfLylolE41hjtA1PRNg0WE3J1NkB5TECLhGNKVi8nzwEN9Z2OvDPsveGb70LKFunCP8Z8cDFWBLQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:98c7:0:b0:ca3:3341:6315 with SMTP id
 m7-20020a2598c7000000b00ca333416315mr6944ybo.0.1696268478540; Mon, 02 Oct
 2023 10:41:18 -0700 (PDT)
Date:   Mon, 2 Oct 2023 10:41:17 -0700
In-Reply-To: <ee679de20e3a53772f9d233b9653fdc642781577.camel@infradead.org>
Mime-Version: 1.0
References: <a3989e7ff9cca77f680f9bdfbaee52b707693221.camel@infradead.org>
 <ZRbolEa6RI3IegyF@google.com> <ee679de20e3a53772f9d233b9653fdc642781577.camel@infradead.org>
Message-ID: <ZRsAvYecCOpeHvPY@google.com>
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 29, 2023, David Woodhouse wrote:
> On Fri, 2023-09-29 at 08:16 -0700, Sean Christopherson wrote:
> > On Fri, Sep 29, 2023, David Woodhouse wrote:
> > > From: David Woodhouse <dwmw@amazon.co.uk>
> > >=20
> > > Most of the time there's no need to kick the vCPU and deliver the tim=
er
> > > event through kvm_xen_inject_timer_irqs(). Use kvm_xen_set_evtchn_fas=
t()
> > > directly from the timer callback, and only fall back to the slow path
> > > when it's necessary to do so.
> >=20
> > It'd be helpful for non-Xen folks to explain "when it's necessary".=C2=
=A0 IIUC, the
> > only time it's necessary is if the gfn=3D>pfn cache isn't valid/fresh.
>=20
> That's an implementation detail.

And?  The target audience of changelogs are almost always people that care =
about
the implementation.

> Like all of the fast path functions that can be called from
> kvm_arch_set_irq_inatomic(), it has its own criteria for why it might ret=
urn
> -EWOULDBLOCK or not. Those are *its* business.

And all of the KVM code is the business of the people who contribute to the=
 kernel,
now and in the future.  Yeah, there's a small chance that a detailed change=
log can
become stale if the patch races with some other in-flight change, but even =
*that*
is a useful data point.  E.g. if Paul's patches somehow broke/degraded this=
 code,
then knowing that what the author (you) intended/observed didn't match real=
ity when
the patch was applied would be extremely useful information for whoever enc=
ountered
the hypothetical breakage.

> And in fact one of Paul's current patches is tweaking them subtly, but th=
at
> isn't relevant here. (But yes, you are broadly correct in your
> understanding.)
>=20
> > > This gives a significant improvement in timer latency testing (using
> > > nanosleep() for various periods and then measuring the actual time
> > > elapsed).
> > >=20
> > > However, there was a reason=C2=B9 the fast path was dropped when this=
 support
> >=20
> > Heh, please use [1] or [*] like everyone else.=C2=A0 I can barely see t=
hat tiny little =C2=B9.
>=20
> Isn't that the *point*? The reference to the footnote isn't supposed to
> detract from the flow of the main text. It's exactly how you'll see it
> when typeset properly.
=20
Footnotes that are "typeset properly" have the entire footnote in a differe=
nt
font+size.  A tiny number next to normal sized text just looks weird to me.

And I often do a "reverse lookup" when I get to footnotes that are links, e=
.g. to
gauge whether or not it's worth my time to follow the link.  Trying to find=
 the
tiny =C2=B9 via a quick visual scan is an exercise in frustration, at least=
 for the
monospace font I use for reading mail, e.g. it's much more readable on my e=
nd in
an editor using a different font.

Which is a big benefit to sticking to the old and kludgly ASCII: it provide=
s a
fairly consistent experience regardless of what client/font/etc each reader=
 is
using.  I'm not completely against using unicode characters, e.g. for names=
 with
characters not found in the Latin alphabet, but for code and things like th=
is,
IMO simpler is better.

> I've always assumed the people using [1] or [*] just haven't yet realised
> that it's the 21st century and we are no longer limited to 7-bit ASCII. O=
r
> haven't worked out how to type anything but ASCII.

Please don't devolve into ad hominem attacks against other reviews and cont=
ributors.
If you want to argue that using footnote notation unicode is superior in so=
me way,
then by all means, present your arguments.
