Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AC9355CD1
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 22:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbhDFUYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 16:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbhDFUYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 16:24:39 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1C7C06174A
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 13:24:29 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id d10so6366801pgf.12
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 13:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V0BcqnHBM8kTtyrgcoW/hBV3fuCVIq7e+TIjd/e7i94=;
        b=duhKgM91jkrJsfOa7vCI1IYtwNfQpSyp11CRfKyr6xJl9humFfyFOFWgwbhHmaAbrg
         s/7mpk707s6TWAJJhOgimn3KSHjbhiGhpD9rGnm23VM5ikGsK1B1oBF8t2fsif0Gg4p8
         Q1hT7rX8zSh4FztVbCkUvrNRkjz3TDKus8yKbdpfANA+SRU/4XTOvFfOY2SbYk+kZG7z
         ArZUYEty2aqIkk0fOy3gPVH74REJWx+T/Twq8JCu+5U1niqb/706PNe8/zGCQe06noXE
         3Gor5QNOdX4S1bwmQlbPrU4sytEnEe/m02Lh8hNoVzm4ZArpnHkawOo+7yjB3U7EAlkf
         6/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V0BcqnHBM8kTtyrgcoW/hBV3fuCVIq7e+TIjd/e7i94=;
        b=tIlGzhghpf9er4H+sUGrv6/oKuf71KeNxaFSZxwa3m77/sozoM1oqeLab0zZVdZQaE
         RRGQLmHyhfbvnKE6SvFncAOh+N37QkJBeILEJqeCL9mG09urUjJU//8G2hM6+mJoP+c6
         wI/7iVVUErqIF9BaF24v2Hbk+vQha4u0K4BZExn/UoBuak8/m7beUkvZt8hu9cgxDWpi
         SWtDkqHbsJ1nQpgKLycISJwxu/1aE/SnNbyXJmRNPyIKBeVPBx03KE9OuHtV2jUBQrGa
         wGqJ/7Z/xhuCYakl4CLvv/8fQe+Dsnp0iAT7tskS5dEsOE1qUheK8z5pdWpEttCCim7p
         6mxg==
X-Gm-Message-State: AOAM532eyzEJddjfG2l2MmZ7Jf053Se7W1zsoHon3592v9vNhDkFz15/
        8plHe6gWOYCfQSskzo1bLyA0yv7dioRzIrdld8Cx8w==
X-Google-Smtp-Source: ABdhPJxD4kr8Do6CpstBpV6S9yPqtnMNcZC2rx2F72ZZCV/bOH6S1IcmE2NuXOj2HGPWmL1FbnimXYQ6sDkYNqInJ1s=
X-Received: by 2002:a65:6645:: with SMTP id z5mr28107125pgv.273.1617740669222;
 Tue, 06 Apr 2021 13:24:29 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.22.394.2104041728020.2958@hadrien>
 <YGsobMdyqwzi9vr7@google.com> <CABgObfZBAtac5TF=i3wpXT8aOpTNzM1e+VZay3QtCckph=O3=Q@mail.gmail.com>
In-Reply-To: <CABgObfZBAtac5TF=i3wpXT8aOpTNzM1e+VZay3QtCckph=O3=Q@mail.gmail.com>
From:   Nathan Tempelman <natet@google.com>
Date:   Tue, 6 Apr 2021 13:24:18 -0700
Message-ID: <CAKiEG5q3qpnzdz3A82ZnZWfFMcMfLnV4x2h9KvYLReisP_Gz6w@mail.gmail.com>
Subject: Re: [kvm:queue 120/120] arch/x86/kvm/svm/sev.c:1380:2-8: preceding
 lock on line 1375 (fwd)
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Julia Lawall <julia.lawall@inria.fr>,
        Danmei Wei <danmei.wei@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Robert Hu <robert.hu@intel.com>, kvm <kvm@vger.kernel.org>,
        kbuild-all@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yeah I've got the fix for this pending, Sean did call it out last week
after it was queued. I've been trying to get a self test built to
verify this patch before pushing the v3 since I thought I had some
time before the next release closes, but I can go ahead and get out
the v3 asap and keep you all updated if the self tests turn anything
up.

On Mon, Apr 5, 2021 at 8:35 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On Mon, Apr 5, 2021 at 5:10 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Sun, Apr 04, 2021, Julia Lawall wrote:
> > > Is an unlock needed on line 1380?
> >
> > Yep, I reported it as well, but only after it was queued.  I'm guessing Paolo
> > will tweak the patch or drop it for now.
>
> Yeah, it's a public holiday here but either Nathan or I will post v3.
>
> Paolo
>
