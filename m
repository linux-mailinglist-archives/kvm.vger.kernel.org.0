Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3413F37C3
	for <lists+kvm@lfdr.de>; Sat, 21 Aug 2021 02:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbhHUAic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 20:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhHUAib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 20:38:31 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC514C061575
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 17:37:52 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id a10so3833936qka.12
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 17:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oVcrrAzmS8oZP2qTydtJJoCyZ4L7Jauh4Ql3mnBj9do=;
        b=bUuR29y+YIXZHyaeBHI0XVuQbY3UYVN4bXtGYvof/c/8nmuLVmfLmVbuhY8/y0BZua
         OAAXRFQEY37RLxRztZNOXdgMYqypQJdMa9pg/pEA2ebpJEXsuWXvNVay3MyjneeQ/QtY
         TkP/OCvrRpUp0fYGpKgjWmdlfgvNDA1IxDsvoAVM06KQ2xbz2arP8xhjDT8wu8VdWBSF
         hARPZsLiA/5+jkiC644VpihBZ/e8/+N0HJQPSXn2zorq2z5AtylWtSYczBfnlTKYgWY1
         u8kSAkDtxq5VZXlWglSylDN4EgY9iMDQ9Vmy7rU3d31PrOlvr9zvhF2WtFJIELgzgNDM
         5OxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oVcrrAzmS8oZP2qTydtJJoCyZ4L7Jauh4Ql3mnBj9do=;
        b=cFMr0+djnkY5Emerjbk2GDNYThhd2BoayZPaklywgF1v3h8GKGp9xL75yvTnx8QGJw
         VJ5NknYE0OYEIeXRkPVK1Jp73gIx7jJyk7fVaaGliZBY8Dx692OaPuLedW/hgMzCs5Wt
         OKH0b7N9bvOfO2KFqa2V3DXqdwyNQm5sD4zinzEbatiJTVCNB69DNY8OZd3+XscxIO6L
         8h3d/AaU47+4vC9yJnU1dK4nnpZSQkdkOoCRBonMjNpLoNctR4qwHhdf+wJXaETWC7O+
         krbSIRoKM9XRF/VQg6s/phFg7O3QIUtJ+cRBndUkRBEgd8cIQ+p44fMdtj3jqtOuyJf+
         t/QQ==
X-Gm-Message-State: AOAM531Cg0jE7b8cVUi4gazV63JMrWDhYBHH6MZm9JjSsoZ8q0t4CURE
        +d09wCkqRphRWximpPf+3lqlrlJKqjuE2YcDEEx1Ng==
X-Google-Smtp-Source: ABdhPJwtfsQPBQySiS1OGGNkzSJeWNdNXhlJa8/JUULQtxLA5JtaFgWELT8rJf8OiZFn6t9eUDbDjBlp1yWT1QNW4xQ=
X-Received: by 2002:a05:620a:204e:: with SMTP id d14mr11345252qka.147.1629506271633;
 Fri, 20 Aug 2021 17:37:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
 <20210818000905.1111226-15-zixuanwang@google.com> <YSA/sYhGgMU72tn+@google.com>
In-Reply-To: <YSA/sYhGgMU72tn+@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 20 Aug 2021 17:37:40 -0700
Message-ID: <CAA03e5FRT7TgtDaV3mrTjaWF8njnFuRre0id8FFCDDdPbMeFPA@mail.gmail.com>
Subject: Re: [kvm-unit-tests RFC 14/16] x86 AMD SEV-ES: Copy UEFI #VC IDT entry
To:     Sean Christopherson <seanjc@google.com>
Cc:     Zixuan Wang <zixuanwang@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 4:50 PM Sean Christopherson <seanjc@google.com> wro=
te:
>
> On Wed, Aug 18, 2021, Zixuan Wang wrote:
> > AMD SEV-ES introduces a new #VC exception that handles the communicatio=
n
> > between guest and host.  UEFI already implements a #VC handler so there
> > is no need to re-implement it in KVM-Unit-Tests. To reuse this #VC
> > handler, this commit reads UEFI's IDT, copy the #VC IDT entry into
> > KVM-Unit-Tests' IDT.
> >
> > In this commit, load_idt() can work and now guest crashes in
> > setup_page_table(), which will be fixed by follow-up commits.
>
> As a stop gap to get SEV testing of any kind enabled, I think piggybackin=
g the
> vBIOS #VC handler is a great idea.  But long term, kvm-unit-tests absolut=
ely
> needs to have its own #VC handler.
>
> In addition to the downsides Joerg pointed out[*], relying on an external=
 #VC
> introduces the possibility of test failures that are tied to the vBIOS be=
ing
> used.  Such dependencies already exist to some extent, e.g. using a buggy=
 QEMU or
> SeaBIOS could certainly introduce failures, but those components are far =
more
> mature and less likely to break in weird ways unique to a specific test.
>
> Another potential issue is that it's possible vBIOS will be enlightened t=
o the
> point where it _never_ expects a #VC, e.g. does #VMGEXIT directly, and th=
us panics
> on any #VC instead of requesting the necessary emulation.
>
> Fixing the vBIOS image in the repo would mostly solve those problems, but=
 it
> wouldn't solve the lack of flexibility for the #VC handler, and debugging=
 a third
> party #VC handler would likely be far more difficult to debug when failur=
es
> inevitably occur.
>
> So, if these shenanigans give us test coverage now instead of a few month=
s from
> now, than I say go for it.  But, we need clear line of sight to a "native=
" #VC
> handler, confidence that it will actually get written in a timely manner,=
 and an
> easily reverted set of commits to unwind all of the UEFI stuff.
>
> [*] https://lkml.kernel.org/r/YRuURERGp8CQ1jAX@suse.de

Understood. I must admit, we didn=E2=80=99t have this long term perspective
when drafting these patches. But after reading this feedback, we see
your point. Luckily, unwinding the code to install the UEFI #VC
handler is trivial.

Also, we do believe that completing and submitting this patch series
such that it uses the UEFI=E2=80=99s #VC handler is the best next step, eve=
n
with the understanding that it=E2=80=99s not where we want to be six months=
 to
one year from now. The reason is that adding a new #VC handler is
non-trivial. It seems like a separate patch set. At the same time,
using the UEFI #VC handler unlocks a lot of testing (that=E2=80=99s totally
non-existent now) and it should be trivial to plumb in the (to be
written) kvm-unit-tests #VC handler. In other words, with this patch
the community can start using and adding to the tests that are
unlocked by the UEFI #VC handler while someone (in parallel) works on
a follow-on patch set to add a #VC handler to kvm-unit-tests.
