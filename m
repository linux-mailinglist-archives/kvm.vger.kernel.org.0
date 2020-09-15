Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C875E269C9B
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 05:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgIODix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 23:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIODiw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 23:38:52 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A417C06174A
        for <kvm@vger.kernel.org>; Mon, 14 Sep 2020 20:38:52 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id t76so2264369oif.7
        for <kvm@vger.kernel.org>; Mon, 14 Sep 2020 20:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YAXBjBENifJ2WHKzEspwGIV0qPvjAstlV+oI+lp9xko=;
        b=pQ7U5LwP5WLsPt3rh7gXYHW3wAgDKFZS/WXIKIaxZl9TOEk+U7WH2eEqkfhPBDTDXC
         OHmp58CpuUD6UWIX6qghGZAwsiCX2EYFk1ZDc+oi1d4fdU76j9exybrEeAevhXzhPbtc
         vzlJl/FZPMp66vPod97In4uYBzrnzyCvmPTDrjAhm8nm7SHS7ZNqAgd5JqzPu3xngLhf
         k0Uh3YaxdGwcGRZDnLgqMjmERvocBoaucLyDhCCaguqph+7YsoJDdc6X3vs0Ny2uSGlM
         2Gaz4u+Yl5WC9R2tuevjQ4HUQoye4IPp8yinVSafZha4zpsNjFD2T0Buk6WYowOMGVgT
         vczA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YAXBjBENifJ2WHKzEspwGIV0qPvjAstlV+oI+lp9xko=;
        b=n5MvPhpdnhVPCrKVNsogTjCuLrdtagkDl0/gvkuY1XIPe3jjRDat+VcFe5n/TrBM3r
         cBPk2GSGon9tMqwMDWa29t3Kc5k9Tv2XldRq0GFfNcsnbqsGce5yAh9t80jUg1Vdbi0J
         BC5h2XGHOifIOis99Rug2PvsavI8DYvbR94VXqhciPi94tED0OCM6MMyPXpwjFcGYY06
         Yq2vpfHMIuXpDcHAYEbFQ/BKfywqYBaGyl0eUQuCZeWKEnVNXwnTFDgdd/jofME83yOj
         rbakUB7G8rE3W/06w+rzuNPhndfSw/3Yvjm4G0xCsuWYe07E9PuTlinl2Qf1DsnWUEFJ
         9vDQ==
X-Gm-Message-State: AOAM530Wp5eyvdUX/G04o/wpT9ZoIHwETuZVhjlDGn17Qy8Alj6WaxtJ
        bPfzsImSs7Chdv2RyzA2IONIle7+a06/0TQxYGW4s64U0AA=
X-Google-Smtp-Source: ABdhPJzbVItrbklO73it1OwE9Yk+eEVpyoWzB74egOmcJpennM4v0mapmSxdgnzUJ/dxErfkyeh9OrLkE65h8oWFbjo=
X-Received: by 2002:aca:f0a:: with SMTP id 10mr1894198oip.13.1600141130846;
 Mon, 14 Sep 2020 20:38:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200829005720.5325-1-krish.sadhukhan@oracle.com>
 <CALMp9eSiB=NkuZJV+m-j-KcxqVzkqTf5fUS7r9vBSaY8TyK_Rg@mail.gmail.com>
 <a825c6db-cf50-9189-ceee-e57b2d64d585@redhat.com> <CALMp9eTUT-tsGu0gfVcR8VTcq7aVH87PsegnsbU6TXOoLHkfMA@mail.gmail.com>
 <CALMp9eS+Vgo2O5=ApWEYCrDz80QE0E7OQyLYwrEjErXD2+uZUw@mail.gmail.com>
In-Reply-To: <CALMp9eS+Vgo2O5=ApWEYCrDz80QE0E7OQyLYwrEjErXD2+uZUw@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 14 Sep 2020 20:38:39 -0700
Message-ID: <CALMp9eQnMRk0ydYpgXRiNr-zmEvooGYYSJ=WnW3TwgEb7Ady-g@mail.gmail.com>
Subject: Re: [PATCH] nSVM: Add a test for the P (present) bit in NPT entry
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 14, 2020 at 8:13 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Mon, Sep 14, 2020 at 5:18 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Fri, Sep 11, 2020 at 8:36 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >
> > > On 31/08/20 23:55, Jim Mattson wrote:
> > > > Moreover, older AMD hardware never sets bits 32 or 33 at all.
> > >
> > > Interesting, I didn't know this.  Is it documented at all?
> >
> > You'll have to find an old version of the APM. For example, see page
> > 56 of http://www.0x04.net/doc/amd/33047.pdf (this was back when SVM
> > was a separate document).
>
> Ah ha. It looks like bits 32 and 33 weren't there in version 3.14 of
> the APM volume 2 in September 2007. (See
> http://application-notes.digchip.com/019/19-44680.pdf, pages 410-411.)
> They had appeared by version 3.17 in June 2010. Maybe someone from AMD
> can enlighten us. My memory's just not that good.

In fact, if I recall correctly, this is why AMD has *two* bits where
it would seem that one bit should suffice; they actually have three
states:

00: No information provided
01: Final translation
10: Page table walk
