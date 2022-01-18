Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E32491E65
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 05:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343693AbiAREJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 23:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245344AbiAREJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 23:09:08 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7447C061574
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 20:09:07 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id r138so26684099oie.3
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 20:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U8OOIDNjUJ77GHdf9PAPOZyv54eYdoAaAy1PMG/qK4U=;
        b=pHwQS1hXuX9sGssSqsed0YtI1zp4dpTt8VfEnBlXDdnh1S7iJCMfO9A7pG9o+5jby3
         WY2/YetVM2Z8GLhiczIIKLSku5xD40vpBP1KaDs5oPsaAm/EftQcgbSXEhA5ruTzBxrz
         I5N1NQMx53DoAOQ+qU9Tskmyg/3/ZQX8LAFjAsEZzUrr3d7qGfp2FQcTmJ+jS7uG17jc
         ZDBDj8v0QE7H3Kn5bkQvAcjrsURizt98JtJnI2/UyZgYCBrPoJtit/JyRBcIgjrkpqIF
         0nW5PEE5pEteFPkDtq2iDNn9I5XkEMhpjdAj5R7pirF2UCloWZ0ERTWjx12hzBKTpjrD
         wzMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U8OOIDNjUJ77GHdf9PAPOZyv54eYdoAaAy1PMG/qK4U=;
        b=BAxX30BoelvP8NcG0B7XfiFFQUVaucPrikV0Hu5L0n1xbOE8tuy01ZSmKxKRwOrvxz
         F0tN1gZMC2+J/reAYOmk2SCKr1EzrkDlBmQdIoL5wv6GEfsZ9v0ciMzkyMuft+FKJF/6
         Ju+X435/gWoGiHzrfEfudZ1oo0VmoRAW861i7/9GSHlB0aZ6u62Un7cEGtTmr5VbMAJ/
         BC7T//chFYLl4WqdVLwZd1+2GdiiYIrheo6sY62fRInSjGCQ6X2PYnroQHf7X34QLk+j
         OZo5hwPtonKxRpMSwvISoj29YtBM4lIFkSPv1j3Wv25bykSVIHRlG234RmwWlOoTUdKV
         yvPw==
X-Gm-Message-State: AOAM531v+uQ+xhAb0KMK7nq5Yf46HlEEytYf2Imbm/c7zokRIajNge8Q
        F2C1Lm/K/Wcy1/wGRaG2OyAdYsSDV95+pzCFx2tTzA==
X-Google-Smtp-Source: ABdhPJwsm1aTZCoBTz6977RBP8vTFxxPygcCN+9go8h+6X/o3FQtLE/eSA8yKeXAi5GnWRiKuG8190WBEKvnsdmx2a4=
X-Received: by 2002:a05:6808:297:: with SMTP id z23mr4647060oic.68.1642478946700;
 Mon, 17 Jan 2022 20:09:06 -0800 (PST)
MIME-Version: 1.0
References: <CALMp9eQZa_y3ZN0_xHuB6nW0YU8oO6=5zPEov=DUQYPbzLeQVA@mail.gmail.com>
 <453a2a09-5f29-491e-c386-6b23d4244cc2@gmail.com> <CALMp9eSkYEXKkqDYLYYWpJ0oX10VWECJTwtk_pBWY5G-vN5H0A@mail.gmail.com>
In-Reply-To: <CALMp9eSkYEXKkqDYLYYWpJ0oX10VWECJTwtk_pBWY5G-vN5H0A@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 17 Jan 2022 20:08:55 -0800
Message-ID: <CALMp9eQAMpnJOSk_Rw+pp2amwi8Fk4Np1rviKYxJtoicas=6BQ@mail.gmail.com>
Subject: Re: PMU virtualization and AMD erratum 1292
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 17, 2022 at 12:57 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Sun, Jan 16, 2022 at 8:26 PM Like Xu <like.xu.linux@gmail.com> wrote:
> ...
> > It's easy for KVM to clear the reserved bit PERF_CTL2[43]
> > for only (AMD Family 19h Models 00h-0Fh) guests.
>
> KVM is currently *way* too aggressive about synthesizing #GP for
> "reserved" bits on AMD hardware. Note that "reserved" generally has a
> much weaker definition in AMD documentation than in Intel
> documentation. When Intel says that an MSR bit is "reserved," it means
> that an attempt to set the bit will raise #GP. When AMD says that an
> MSR bit is "reserved," it does not necessarily mean the same thing.
> (Usually, AMD will write MBZ to indicate that the bit must be zero.)
>
> On my Zen3 CPU, I can write 0xffffffffffffffff to MSR 0xc0010204,
> without getting a #GP. Hence, KVM should not synthesize a #GP for any
> writes to this MSR.
>
> Note that the value I get back from rdmsr is 0x30fffdfffff, so there
> appears to be no storage behind bit 43. If KVM allows this bit to be
> set, it should ensure that reads of this bit always return 0, as they
> do on hardware.

Bit 19 (Intel's old Pin Control bit) seems to have storage behind it.
It is interesting that in Figure 13-7 "Core Performance Event-Select
Register (PerfEvtSeln)" of the APM volume 2, this "reserved" bit is
not marked in grey. The remaining "reserved" bits (which are marked in
grey), should probably be annotated with "RAZ."
