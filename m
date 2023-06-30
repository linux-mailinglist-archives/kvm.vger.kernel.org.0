Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2606743FF1
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 18:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjF3Qkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 12:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjF3Qku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 12:40:50 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D160E3AA4
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 09:40:49 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-401d1d967beso3001cf.0
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 09:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688143249; x=1690735249;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1O2jb2ZRq3iKub8wzToWxUbybun5ApHXKfxPti5SoXo=;
        b=hB54yH6rPphXZa2pVpo7ah3BwI53myyvXN1Q2T3Owg6EnRSNtzjGMkgSegbzP9GoQS
         W0wBiYgT+q9g0MP9+MDg+zizhwFj786nKzoAHKlsbFtf5HYx6cWhcwCwbmcWfILEiUO7
         62f/waacoZXisGna2kWdP5CwK6tNadmozDerJ97LXVUv4gTEAHuI0dM5txxNNdD9RwMB
         P4vEMTpsmLnhuQS3jZr3VoyZMzK4ozq+VX5V8Muqy7Yu66Q7nThPDJ4jEZLck3g2FxbE
         diSmMbMKsL7xb7gLopsSerkwCBe7p5pSpaZIQZ3dJec1pWXkkM6aW0gflCGChTshz9Eh
         /VCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688143249; x=1690735249;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1O2jb2ZRq3iKub8wzToWxUbybun5ApHXKfxPti5SoXo=;
        b=ReFo/S6NJoRvynlCpY3NVTC54ruIqMsOpeRlbJ7lMUi37To4SqT9tSKb4c0L/yjGiZ
         yCQ2effSbbR425wYXXM3S1mHypju2YTRRGe/toPPfZg4ls+makW0S4cjGJqUkU/aTOlj
         dAlq7A40qQvbZZPrVL+HhhtDG5J0WRfzVb4wI7hM19BtzB4pvz0/VuSgiL6Gw90vORJC
         01yq3XigOi0bSB10H6rL29rWbOZ6TEhjl1K1aUmoTHrI/k6yq9F3f0wpgzkPAkbPbJjY
         yUQ7Y651PvxmXg2U5HgFLnv4Nbhd61SvMcq5zndxV/b4KPBQu9kxmt5mMIsCJEZD9pOX
         NKhQ==
X-Gm-Message-State: AC+VfDy7sEN0MRd8g69uhyMk2iEwxtbxPskOVWhANNkURTtxxfcJVChR
        5pcibasDwXFZ94Xbkg8+yAInaqwWHhcbApg50KUoNA==
X-Google-Smtp-Source: ACHHUZ7cgdzz/M+RL5lA57//vzlA/0JjcxrrS5JNEsira0Qrza1rWHs6rgnRQTXHVdOLklBsP5WZwoLfnNfi5S9K3Z8=
X-Received: by 2002:ac8:5905:0:b0:3f8:5b2:aef0 with SMTP id
 5-20020ac85905000000b003f805b2aef0mr815604qty.24.1688143248846; Fri, 30 Jun
 2023 09:40:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230504120042.785651-1-rkagan@amazon.de> <ZH6DJ8aFq/LM6Bk9@google.com>
 <CALMp9eS3F08cwUJbKjTRAEL0KyZ=MC==YSH+DW-qsFkNfMpqEQ@mail.gmail.com>
 <ZJ4dmrQSduY8aWap@google.com> <ZJ65CiW0eEL2mGg8@u40bc5e070a0153.ant.amazon.com>
 <ZJ7mjdZ8h/RSilFX@google.com> <ZJ7y9DuedQyBb9eU@u40bc5e070a0153.ant.amazon.com>
In-Reply-To: <ZJ7y9DuedQyBb9eU@u40bc5e070a0153.ant.amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 30 Jun 2023 09:40:37 -0700
Message-ID: <CALMp9eSNoHoAB4ZnMTZqvc8h2O8VL7RkLkSDeS-PSGi7usZ+TA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
To:     Roman Kagan <rkagan@amazon.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Like Xu <likexu@tencent.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 8:21=E2=80=AFAM Roman Kagan <rkagan@amazon.de> wrot=
e:
>
> On Fri, Jun 30, 2023 at 07:28:29AM -0700, Sean Christopherson wrote:
> > On Fri, Jun 30, 2023, Roman Kagan wrote:
> > > On Thu, Jun 29, 2023 at 05:11:06PM -0700, Sean Christopherson wrote:
> > > > @@ -74,6 +74,14 @@ static inline u64 pmc_read_counter(struct kvm_pm=
c *pmc)
> > > >         return counter & pmc_bitmask(pmc);
> > > >  }
> > > >
> > > > +static inline void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
> > > > +{
> > > > +       if (pmc->perf_event && !pmc->is_paused)
> > > > +               perf_event_set_count(pmc->perf_event, val);
> > > > +
> > > > +       pmc->counter =3D val;
> > >
> > > Doesn't this still have the original problem of storing wider value t=
han
> > > allowed?
> >
> > Yes, this was just to fix the counter offset weirdness.  My plan is to =
apply your
> > patch on top.  Sorry for not making that clear.
>
> Ah, got it, thanks!
>
> Also I'm now chasing a problem that we occasionally see
>
> [3939579.462832] Uhhuh. NMI received for unknown reason 30 on CPU 43.
> [3939579.462836] Do you have a strange power saving mode enabled?
> [3939579.462836] Dazed and confused, but trying to continue
>
> in the guests when perf is used.  These messages disappear when
> 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions") is
> reverted.  I haven't yet figured out where exactly the culprit is.

Maybe this is because KVM doesn't virtualize
IA32_DEBUGCTL.Freeze_PerfMon_On_PMI?

Consider:

1. PMC0 overflows, GLOBAL_STATUS[0] is set, and an NMI is delivered.
2. Before the guest's PMI handler clears GLOBAL_CTRL, PMC1 overflows,
GLOBAL_STATUS[1] is set, and an NMI is queued for delivery after the
next IRET.
3. The guest's PMI handler clears GLOBAL_CTRL, reads 3 from
GLOBAL_STATUS, writes 3 to GLOBAL_OVF_CTRL, re-enables GLOBAL_CTRL,
and IRETs.
4. The queued NMI is delivered, but GLOBAL_STATUS is now 0. No one
claims the NMI, so we get the spurious NMI message.

I don't know why this would require counting the retirement of
emulated instructions. It seems that hardware PMC overflow in the
early part of the guest's PMI handler would also be a problem.

> Thanks,
> Roman.
>
>
>
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>
>
>
