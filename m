Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A32770BB1
	for <lists+kvm@lfdr.de>; Sat,  5 Aug 2023 00:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjHDWEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 18:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjHDWEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 18:04:00 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFC810F0
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 15:03:44 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-56942442eb0so27568697b3.1
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 15:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691186623; x=1691791423;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z5QE4e6WPNCCTrcuQvD50h/cVU5OOyClG9aBSPF6enk=;
        b=vM4uC4RuClRcmFO2qH/TANlQsWDEW+w4U9sW+sG8F4CCDdcV2tNthcz4YJ6PXz+56B
         oqFUNpVY1eBEVrxwliIA57bmsHnqMhmzXjy8U521V1m+rWHXTXQ/nE9iB9PLwoS2cdGY
         7UF3A0KKoCLferkfuF10jA2qDrwRUIQERhyJN66ymiLypJRXtzrYN9HmsXdOXjm4P3TN
         8r6STBjd9bG6Nix6A+scDPT6fGkyHJA56x9OaL5i8xMACEqeMxgiVcUju8xRuBySakA/
         RLQ9me9mrk7MBFj6YOhouZwKr3MwcQlfeVPnrAJGTBAcNtiUcjLAzNf1ojAR1NejBXa+
         Dt4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691186623; x=1691791423;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z5QE4e6WPNCCTrcuQvD50h/cVU5OOyClG9aBSPF6enk=;
        b=W/VeLQ8fWpS9+OqZkgszpaIF6OqfVZUIHgJ7mX63WOXKvxh7GF0gVySrVzoeCVoDzT
         VtnFHFvAm9d6kNU9e4J69OrQZgwvTUNUUpHKf1mck/g04ocr8mLerpFNXOsF25R/zMfd
         +1S+6WK8D3aUsa+XKq0ohIrp1X94Z8GiBuDcnXP8x0MkRV3BtrJ430rHH1sJ48Kn9qoL
         r/UkR33RGu0iWvZSyNgvVtXrwE48al7z6CDEyLI5zNW7O6tEIuR//uTwf4CKNV7t6Clh
         ZKvgwWv1kNd2VvZ3SBGL8aGMQ6SxBmzjDBReGYZ4NIsCs8/6ly6Lmv9UpRbfKxWQRV80
         dVzQ==
X-Gm-Message-State: AOJu0Yxruk5I1hvVsW2eiCIQg87wKmAela81QP6yeiOqh9wJNZuUD/pb
        xN2ALaQpAbsOUSMY506pY1qdXCDk7jg=
X-Google-Smtp-Source: AGHT+IFjaw3aSm7rjvvmijnXEXzRTq5HabQb/vYjmBeBj+YyrmCXw7NTiGSmKknyLfkweNzeT9xhYtbm3aE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:f807:0:b0:d09:b450:22eb with SMTP id
 u7-20020a25f807000000b00d09b45022ebmr14827ybd.1.1691186623542; Fri, 04 Aug
 2023 15:03:43 -0700 (PDT)
Date:   Fri, 4 Aug 2023 15:03:41 -0700
In-Reply-To: <20230706145247.ddjqsvmfdeimzva6@linux.intel.com>
Mime-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-3-stevensd@google.com>
 <20230705031002.xrxk42hli6oavtlt@linux.intel.com> <CAD=HUj6-VbznOOtn5WJee7Of_nh33ygg7_ph2G=hgnvNk_Cbsw@mail.gmail.com>
 <20230705105343.iounmlflfued7lco@linux.intel.com> <CAD=HUj5ezWt7rLAv2qOpFsMHyFU87Hqtw_p8pWNF5+oxbLhxDg@mail.gmail.com>
 <20230706145247.ddjqsvmfdeimzva6@linux.intel.com>
Message-ID: <ZM11vUK3vIjjykaz@google.com>
Subject: Re: [PATCH v7 2/8] KVM: Introduce __kvm_follow_pfn function
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     David Stevens <stevensd@chromium.org>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 06, 2023, Yu Zhang wrote:
> On Thu, Jul 06, 2023 at 02:29:24PM +0900, David Stevens wrote:
> > On Wed, Jul 5, 2023 at 7:53=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.intel=
.com> wrote:
> > >
> > > On Wed, Jul 05, 2023 at 06:22:59PM +0900, David Stevens wrote:
> > > > On Wed, Jul 5, 2023 at 12:10=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.=
intel.com> wrote:
> > > > >
> > > > > > @@ -2514,35 +2512,26 @@ static bool hva_to_pfn_fast(unsigned lo=
ng addr, bool write_fault,
> > > > > >   * The slow path to get the pfn of the specified host virtual =
address,
> > > > > >   * 1 indicates success, -errno is returned if error is detecte=
d.
> > > > > >   */
> > > > > > -static int hva_to_pfn_slow(unsigned long addr, bool *async, bo=
ol write_fault,
> > > > > > -                        bool interruptible, bool *writable, kv=
m_pfn_t *pfn)
> > > > > > +static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pf=
n_t *pfn)
> > > > > >  {
> > > > > > -     unsigned int flags =3D FOLL_HWPOISON;
> > > > > > +     unsigned int flags =3D FOLL_HWPOISON | FOLL_GET | foll->f=
lags;
> > > > > >       struct page *page;
> > > > > >       int npages;
> > > > > >
> > > > > >       might_sleep();
> > > > > >
> > > > > > -     if (writable)
> > > > > > -             *writable =3D write_fault;
> > > > > > -
> > > > > > -     if (write_fault)
> > > > > > -             flags |=3D FOLL_WRITE;
> > > > > > -     if (async)
> > > > > > -             flags |=3D FOLL_NOWAIT;
> > > > > > -     if (interruptible)
> > > > > > -             flags |=3D FOLL_INTERRUPTIBLE;
> > > > > > -
> > > > > > -     npages =3D get_user_pages_unlocked(addr, 1, &page, flags)=
;
> > > > > > +     npages =3D get_user_pages_unlocked(foll->hva, 1, &page, f=
lags);
> > > > > >       if (npages !=3D 1)
> > > > > >               return npages;
> > > > > >
> > > > > > +     foll->writable =3D (foll->flags & FOLL_WRITE) && foll->al=
low_write_mapping;
> > > > > > +
> > > > > >       /* map read fault as writable if possible */
> > > > > > -     if (unlikely(!write_fault) && writable) {
> > > > > > +     if (unlikely(!foll->writable) && foll->allow_write_mappin=
g) {
> > > > >
> > > > > I guess !foll->writable should be !(foll->flags & FOLL_WRITE) her=
e.
> > > >
> > > > The two statements are logically equivalent, although I guess using
> > > > !(foll->flags & FOLL_WRITE) may be a little clearer, if a little mo=
re
> > > > verbose.
> > >
> > > Well, as the comment says, we wanna try to map the read fault as writ=
able
> > > whenever possible. And __gfn_to_pfn_memslot() will only set the FOLL_=
WRITE
> > > for write faults. So I guess using !foll->writable will not allow thi=
s.
> > > Did I miss anything?
> >=20
> > We just set the foll->writable out parameter to be equal to
> > ((foll->flags & FOLL_WRITE) && foll->allow_write_mapping). Taking a =3D
> > foll->flags & FOLL_WRITE and b =3D foll->allow_write_mapping, we have
> > !(a && b) && b -> (!a || !b) && b -> (!a && b) || (!b && b) -> !a &&
> > b.
>=20
> Ouch, my bad again... I typed "!foll->writable", but missed the "!" in
> my head while calculating... Thanks! :)

The code is funky and confusing though.  Specifically, FOLL_WRITE without
allow_write_mapping is nonsensical, and yields the even more nonsensical ou=
tput
of a successful FOLL_WRITE with foll->writable=3D=3D%false.

It "works" because callers only consume foll->writable when foll->allow_wri=
te_mapping
is true, but relying on that is ugly and completely unnecessary.   Similarl=
y, the
"allow" terminology is misleading.  FOLL_WRITE *always* allows writable map=
pings.

This wasn't as much of problem in the previous code because the lower level=
s took
the pointer, i.e. avoided the "allow" terminology entirely.

So we should either keep that behavior, i.e. replace "bool allow_write_mapp=
ing"
with "bool *writable", or rename allow_write_mapping to something like
opportunistically_map_writable, and then unconditionally set foll->writable
whenever KVM obtains a writable mapping, i.e. regardless of whether the ori=
ginal
fault was a read or a write.

My vote is for the latter.  If opportunistically_map_writable is too verbos=
e,
try_map_writable would be another option.  Hmm, I'll make "try_map_writable=
" my
official vote.

Ah, and I also vote to use an if-elif instead of unconditionally setting fo=
ll->writable.
That makes the relationship between FOLL_WRITE and try_map_writable a bit m=
ore
obvious IMO.  E.g.

static bool hva_to_pfn_fast(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
{
	struct page *page[1];

	/*
	 * Fast pin a writable pfn only if it is a write fault request
	 * or the caller allows to map a writable pfn for a read fault
	 * request.
	 */
	if (!((foll->flags & FOLL_WRITE) || foll->try_map_writable))
		return false;

	if (get_user_page_fast_only(foll->hva, FOLL_WRITE, page)) {
		*pfn =3D page_to_pfn(page[0]);
		foll->writable =3D true;
		return true;
	}

	return false;
}

/*
 * The slow path to get the pfn of the specified host virtual address,
 * 1 indicates success, -errno is returned if error is detected.
 */
static int hva_to_pfn_slow(struct kvm_follow_pfn *foll, kvm_pfn_t *pfn)
{
	unsigned int flags =3D FOLL_HWPOISON | FOLL_GET | foll->flags;
	struct page *page;
	int npages;

	might_sleep();

	npages =3D get_user_pages_unlocked(foll->hva, 1, &page, flags);
	if (npages !=3D 1)
		return npages;

	if (foll->flags & FOLL_WRITE) {
		foll->writable =3D true;
	} else if (foll->try_map_writable) {
		struct page *wpage;

		/* map read fault as writable if possible */
		if (get_user_page_fast_only(foll->hva, FOLL_WRITE, &wpage)) {
			foll->writable =3D true;
			put_page(page);
			page =3D wpage;
		}
	}
	*pfn =3D page_to_pfn(page);
	return npages;
}

