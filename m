Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3552826C915
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 21:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbgIPTDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 15:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbgIPRsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 13:48:35 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55826C0698CA;
        Wed, 16 Sep 2020 04:25:21 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id r7so9770983ejs.11;
        Wed, 16 Sep 2020 04:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+mqCE1Gph5m1yXF7bV6laGDpK9C2HQ1xfAV3LJcGXyk=;
        b=V0xugFUwP2zKWQ3C6C6Oo6ZRSdKDI6SRacL8HgfrX8iw1MKIHqeTIofH/h6gvBbrOi
         42G03NGAZdP94ZPBIcGONaBen5QoZ2w/rfCdfJCYNoys0kJx388ZNycBRMGPiRlr67sG
         KW8lI3PO88QDhLDuY3OJ90X6NJv2GgJ9r6C9CaNvVXnTTDKlcbAdivt5TrcK2tezpxce
         7/B+rW0/2DkYw6Tsnilr4rxufuCPPL5ntODuTgY3U+jCJJ6JpWVhwkPzWj8tjAw75gFd
         5CscWNzYtswiu78RmMUw8fEBQ/ez4V/wTNGtwdj/cENKEwLIoINUnat3vAqAqkp3MbdC
         +QHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+mqCE1Gph5m1yXF7bV6laGDpK9C2HQ1xfAV3LJcGXyk=;
        b=SGHZd6BlsZtGC/nZi3V/zXOEDM89+WavqKWVBJXvR2cbsF8lJ5jJ6AwfBO0p2UdshG
         zCoWBTSp9MRg84YI3ZdL+SEF+Mo9cbfCRLC/lngOjLE0JKtrJkPNMQDZJN7q9kQ1J5J0
         qhpNWBu+6n55+Qio91Y/5JMqH0kF1VUQFm54aOtD6OC3EJ/4W3n6U8vTugVkHZ8jROt3
         aCAre/m6p9qKC6Ziyt7GvbdWlTXkNCwHUETeyveRIzBCRwODaFiWVVBHL5axtqEulgvy
         RDMip6cUkL/rAU4A+huFxnb4fZHRu22OdYbacsCKfA9boR76zowiW266UJXgQrNa5CTN
         ub8A==
X-Gm-Message-State: AOAM532CjqNgaBurz1kS8q8SjaBOOzhYHjrE2S/9cvhklNtNVngfU5KM
        UkS0mw6cKZTS5sSolR4SEomV9LEIfR7fvavfKg==
X-Google-Smtp-Source: ABdhPJyixyYti8m5yiACM/A3dKdas+hh45AAS4bMeCuzp5+OiXXkuFr73Ln3baDPyaTPw4glCszAn/R857RwhcaCsng=
X-Received: by 2002:a17:906:aecb:: with SMTP id me11mr25984406ejb.217.1600255520046;
 Wed, 16 Sep 2020 04:25:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200916090342.748452-1-vkuznets@redhat.com> <6c2204ad-590b-025d-f728-0e6e67bf24ba@gmail.com>
 <87een2htis.fsf@vitty.brq.redhat.com>
In-Reply-To: <87een2htis.fsf@vitty.brq.redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Wed, 16 Sep 2020 19:25:08 +0800
Message-ID: <CAB5KdObJ4_0oJf+rwGXWNk6MsKm1j0dqrcGQkzQ63ek1LY=zMQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "KVM: Check the allocation of pv cpu mask"
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Haiwei Li <lihaiwei@tencent.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> =E4=BA=8E2020=E5=B9=B49=E6=9C=8816=
=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=887:04=E5=86=99=E9=81=93=EF=BC=
=9A
>
> Haiwei Li <lihaiwei.kernel@gmail.com> writes:
>
> > On 20/9/16 17:03, Vitaly Kuznetsov wrote:
> >> The commit 0f990222108d ("KVM: Check the allocation of pv cpu mask") w=
e
> >> have in 5.9-rc5 has two issue:
> >> 1) Compilation fails for !CONFIG_SMP, see:
> >>     https://bugzilla.kernel.org/show_bug.cgi?id=3D209285
> >>
> >> 2) This commit completely disables PV TLB flush, see
> >>     https://lore.kernel.org/kvm/87y2lrnnyf.fsf@vitty.brq.redhat.com/
> >>
> >> The allocation problem is likely a theoretical one, if we don't
> >> have memory that early in boot process we're likely doomed anyway.
> >> Let's solve it properly later.
> >
> > Hi, i have sent a patchset to fix this commit.
> >
> > https://lore.kernel.org/kvm/20200914091148.95654-1-lihaiwei.kernel@gmai=
l.com/T/#m6c27184012ee5438e5d91c09b1ba1b6a3ee30ee4
> >
> > What do you think?
>
> Saw it, looks good to me. We are, however, already very, very late in 5.9
> release cycle and the original issue you were addressing (allocation
> failure) is likely a theoretical only I suggest we just revert it before
> 5.9 is released. For 5.9 we can certainly take your PATCH2 merged with
> 0f99022210.
>
> This Paolo's call anyway)

I see.  Thank you.

Haiwei Li
