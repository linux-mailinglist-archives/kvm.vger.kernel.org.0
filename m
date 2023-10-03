Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAED37B6E27
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 18:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240230AbjJCQM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 12:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239189AbjJCQM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 12:12:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DDBA6
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 09:12:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d8660e23801so1335326276.3
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 09:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696349572; x=1696954372; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9uQBvm4Fq+54VpMXbG4kdkrjzOsWloPr068ysYSR6Hc=;
        b=gD7QkIvWwo4VOqcoa9KhtXJzngPKzcJTUGzOHooVnlfS0ENN5gTxOqXOxthtAErH5+
         hHW6rgwv9jUDz++15e/ldOFl2RxbXfgnegykle48CJ5El/hhPoQ17avDfSM4Xg539soz
         t/u0eYzpM8jmf51TFQCMQhw3fU9gh5nhBlbPzAPqpSLkpwnLOjoz7dyj1MqjEk5hcBlb
         bwQX7ZrJPi1j5AIHxFfbgWJDxhls1/lsdmPsc75mEpn4/HDOpxZrJvl3dk8KfvLksW99
         fIDqv37qp5R8vsKBHKjqiaJfg0hej3o02x/29yrC0CzTspE7qqmM3TB1W7CU+9V9ZB3B
         +KRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696349572; x=1696954372;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9uQBvm4Fq+54VpMXbG4kdkrjzOsWloPr068ysYSR6Hc=;
        b=KHSFpGMRJDgVzQm/ck91hShDQ/eUc/e3pPaWoE4P+zQUekjzPVDCxmtTVYQJtDqrUw
         XOX/EHkh8gKAMexEQuFi6p3Jm2aauW18jChdL8w1D2dGrDPo+6AkN0DBxseml159nQwW
         BQdENEdv89nXD3wlXybQOAHaBbc+dF8Nz3DIq3x5vQPGgIOt4wuWL0QYjhnNDnml4Qcp
         hBhg33Ss43hxovd1QIA7YZBvbsm7FfN+lCz7/LJFb0d/+yQKax2e8bY/UGKT9XIUUm8O
         zWocaIsRVW6BjSdqt9vgk1d8Q9BsdJfznh5lj4I3I1VqY77ZOVzWJyv3r+Thye//8Z4z
         DqPw==
X-Gm-Message-State: AOJu0Ywzjs8h54bZBYi0KStbqI1lvumxUQZHGt5WjTmNz2p6xvZ9dGuE
        HgIcurxmSCiNbrJI0AVtS6EUSJQ9Mzw=
X-Google-Smtp-Source: AGHT+IEuYMJ8BCAtWpB91NPtpLQDE9hAcvYeMB8lwLvla7gu+qCLAH3DB4DSeDhHFqEi3H2ViX6mUFc2S8U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6dc1:0:b0:d8b:737f:8246 with SMTP id
 i184-20020a256dc1000000b00d8b737f8246mr188298ybc.2.1696349572099; Tue, 03 Oct
 2023 09:12:52 -0700 (PDT)
Date:   Tue, 3 Oct 2023 09:12:50 -0700
In-Reply-To: <b50afadea577065d90ae3dc8ca2aa67dcffcc50e.camel@infradead.org>
Mime-Version: 1.0
References: <a3989e7ff9cca77f680f9bdfbaee52b707693221.camel@infradead.org>
 <ZRbolEa6RI3IegyF@google.com> <ee679de20e3a53772f9d233b9653fdc642781577.camel@infradead.org>
 <ZRsAvYecCOpeHvPY@google.com> <ac097a26e96ded73e19200066b9063354096a8fd.camel@infradead.org>
 <ZRsP5cvyqLaihb76@google.com> <b50afadea577065d90ae3dc8ca2aa67dcffcc50e.camel@infradead.org>
Message-ID: <ZRw9gstj8TWiiBvd@google.com>
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
> On Mon, 2023-10-02 at 11:45 -0700, Sean Christopherson wrote:
> > E.g. there's an assumption that -EWOULDBLOCK is the only non-zero retur=
n code where
> > the correct response is to go down the slow path.
> >=20
> > I'm not asking to spell out every single condition, I'm just asking for=
 clarification
> > on what the intended behavior is, e.g.
> >=20
> > =C2=A0 Use kvm_xen_set_evtchn_fast() directly from the timer callback, =
and fall
> > =C2=A0 back to the slow path if the event is valid but fast delivery is=
n't
> > =C2=A0 possible, which currently can only happen if delivery needs to b=
lock,
> > =C2=A0 e.g. because the gfn=3D>pfn cache is invalid or stale.
> >=20
> > instead of simply saying "when it's necessary to do so" and leaving it =
up to the
> > reader to figure what _they_ think that means, which might not always a=
lign with
> > what the author actually meant.
>=20
>=20
> Fair enough. There's certainly scope for something along the lines of
>=20
>=20
> +	rc =3D kvm_xen_set_evtchn_fast(&e, vcpu->kvm);
> +	if (rc !=3D -EWOULDBLOCK) {
>=20
>    /*
>     * If kvm_xen_set_evtchn_fast() returned -EWOULDBLOCK, then set the
>     * timer_pending flag and kick the vCPU, to defer delivery of the=C2=
=A0
>     * event channel to a context which can sleep. If it fails for any
>     * other reasons, just let it fail silently. The slow path fails=C2=A0
>     * silently too; a warning in that case may be guest triggerable,
>     * should never happen anyway, and guests are generally going to
>     * *notice* timers going missing.
>     */
>=20
> +		vcpu->arch.xen.timer_expires =3D 0;
> +		return HRTIMER_NORESTART;
> +	}
>=20
> That's documenting *this* code, not the function it happens to call.
> It's more verbose than I would normally have bothered to be, but I'm
> all for improving the level of commenting in our code as long as it's
> adding value.=20

I'm completely ok with no comment, I just want something in the changelog. =
 I'm
also not opposed to a comment, but I don't think it's necessary.

I don't have a problem with digging around code to understand the subtletie=
s, or
even the high level "what" in many cases.  What I don't like is encounterin=
g code
where *nothing* explains the author's intent.  All too often I've encounter=
ed
historical code in KVM where it's not at all obvious if code does what the =
author
intended, e.g. if a bug was a simple goof or a completely misguided design =
choice.

Holler if you plan on sending a v4 with the comment.  I'm a-ok applying v3 =
with a
massaged changelog to fold in the gist of the comment.
