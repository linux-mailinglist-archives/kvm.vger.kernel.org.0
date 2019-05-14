Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4781F1C2D9
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 08:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbfENGMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 02:12:38 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:47060 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfENGMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 02:12:37 -0400
Received: by mail-oi1-f195.google.com with SMTP id 203so11212525oid.13;
        Mon, 13 May 2019 23:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hLResyxVAoKnxSO3tSv4vzpoXWxctilVSYRrQC6r+DU=;
        b=nqZHwUJ1k1pGSF8O0yU6GN+s/gJfmKKIVnQHcWn//O896CEu6Qm0jlZpnUdxgpUYZl
         Bk1yO7yYbjYfQIG8pPnEvIdthSk1D+UUzVbTt5idF1Qd7ieBuC6tJ98YAHykmWbXmLGE
         jUVRz8f+TgQOs9z/q1tR/QdMDnMCRSYQfbe8QTHSusjt/yuVc3jIA/AkhhLAFKzmrVf1
         3R91wTJ47L0O1gaL7VzVhrlyt+Eqtfs/Dkb9FbB4A+EqIb7YH1WX3qKDpDSMyJP8CfXo
         gf6dck4ZVxbIYVa1II5xu+QZCsFOGSaguhg2xUl60H3O0ijmOgv2o9z1mxsc5jy9dGoV
         GZBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hLResyxVAoKnxSO3tSv4vzpoXWxctilVSYRrQC6r+DU=;
        b=CkvhJwSJ9QuovEnk7DRpyhTFbUQr1jiArw5v4Z2iVS2b6ZcgYzjdzEBy/1lFttuX5F
         7KgsRSy11SkoMbJEi2oYZJHTVzAXRhtomLrnbC3WJZM//a3seTUrT/40VXGGOjSQX6i2
         aH6MKNt3eClAxOq2DF4GdLhYEnP3zV95E8TS4A5dfL/SIHhXsHxo6JWh0nDaZzZ3XCBq
         /gq1wHBroz+lp/dR7pl90X6EzuoA70nkUoHeR5mDfiouyFDKq5rEeXEkezBef0c8yJzM
         HbnopCpyk4kf1nxaQcuY0LALYQx5UMHe39/q602UwS1b+SHvILkziDPrQ9n285pHMqXb
         oZVg==
X-Gm-Message-State: APjAAAV018YmLw34i5t/XsWbAkt4UUEGEgoTJPK7lWS0STTdYRPhKV+D
        MmKCHrqHOymJuH3IjnlWfI93/1y/UhiW5uTaRZE=
X-Google-Smtp-Source: APXvYqxr2Jl35M+eyfGzBRcEs/9upDdKRevfrghz2M5WOlzSgPDxmC0zWE8om3ogkRU4SWMs6rXTe8AaWjdrG+MS/Xw=
X-Received: by 2002:aca:750f:: with SMTP id q15mr1964813oic.141.1557814356989;
 Mon, 13 May 2019 23:12:36 -0700 (PDT)
MIME-Version: 1.0
References: <1557740799-5792-1-git-send-email-wanpengli@tencent.com> <20190513133548.GA6538@flask>
In-Reply-To: <20190513133548.GA6538@flask>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 14 May 2019 14:13:50 +0800
Message-ID: <CANRm+Cy5n2hMpK4OcKXmYdCkyMd4nK6D1Qq36tcJhTHY5h9TRg@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Enable IA32_MSIC_ENABLE MONITOR bit when
 exposing mwait/monitor
To:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 May 2019 at 21:35, Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.c=
om> wrote:
>
> 2019-05-13 17:46+0800, Wanpeng Li:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > MSR IA32_MSIC_ENABLE bit 18, according to SDM:
> >
> >  | When this bit is set to 0, the MONITOR feature flag is not set (CPUI=
D.01H:ECX[bit 3] =3D 0).
> >  | This indicates that MONITOR/MWAIT are not supported.
> >  |
> >  | Software attempts to execute MONITOR/MWAIT will cause #UD when this =
bit is 0.
> >  |
> >  | When this bit is set to 1 (default), MONITOR/MWAIT are supported (CP=
UID.01H:ECX[bit 3] =3D 1).
> >
> > This bit should be set to 1, if BIOS enables MONITOR/MWAIT support on h=
ost and
> > we intend to expose mwait/monitor to the guest.
>
> The CPUID.01H:ECX[bit 3] ought to mirror the value of the MSR bit and
> as userspace has control of them both, I'd argue that it is userspace's
> job to configure both bits to match on the initial setup.
>
> Also, CPUID.01H:ECX[bit 3] is a better guard than kvm_mwait_in_guest().
> kvm_mwait_in_guest() affects the behavior of MONITOR/MWAIT, not its
> guest visibility.
> Some weird migration cases might want MONITOR in CPUID without
> kvm_mwait_in_guest() and the MSR should be correct there as well.
>
> Missing the MSR bit shouldn't be a big problem for guests, so I am in
> favor of fixing the userspace code.
>
> Thanks.
>
> (For extra correctness in KVM, we could implement toggling of the CPUID
>  bit based on guest writes to the MSR.)

Do it in v2 and a separate qemu patch, thanks for your review.

Regards,
Wanpeng Li
