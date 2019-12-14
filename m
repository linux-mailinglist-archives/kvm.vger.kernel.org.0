Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF6311F2CF
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 17:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfLNQ2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Dec 2019 11:28:21 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45769 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfLNQ2V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Dec 2019 11:28:21 -0500
Received: by mail-ot1-f67.google.com with SMTP id 59so3110753otp.12
        for <kvm@vger.kernel.org>; Sat, 14 Dec 2019 08:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p9TiU/p3iswBYZrdHpdDNv4k35V7tGo3wIsIIqH6Ut8=;
        b=UmX267PJ+IKeDMSTN0V3PZv2FHiub2P2r+RC6k05+7qBd3TWpLmfwXUwrcObbEuAKb
         qdw9Bqt7kVS39SJgc6/Ht5EdxnlQ9tlvmCURQLW/TS56voA0jqE9+W1zvBYee5PcWgl8
         C7YbNPvlcrhW8OhFqvBkqRAAwGJuukZAnU8gbwUDMd1HGvciBzCgd1gg9TgaHVLxHaUP
         zo915ceyznORJxfbYwib2hxkFL0GYEi2xcMJdiNcSP34NePaydSXsxE9hgCF9oMkCiBn
         hmC2++LOmgEC++diZ7hJAV0piPgpM6ujTg9HuohGHqdGPz+sBcCW3fe0gJJK2Z7ipFAM
         8Vxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p9TiU/p3iswBYZrdHpdDNv4k35V7tGo3wIsIIqH6Ut8=;
        b=GnX7ADnEWyWzCY6y2DZaDDhqfHrUl5Qvc/i+FEhHiwv5HnQUPK6xLR+rzyAQKm6YN6
         hS/r/cAJaQzUNKYU2popl7Iq2Xe6H+8JkcVXwMCoWgUZPo3gI27ojeQ30PafViW8UQ1H
         lF0x0WLuVyFGkGM7F4lOpdeVOtLEk31Qn2pKwWQ7Q2URpR2Br9WKgtG+B+qVZBrXfLjk
         BK+fJM7o+PZZiNTGLYYwFts6sUPfA/qCmY/hndxyO95uL0/1H1meq+loABYxJ5B88rxn
         3LT3HoYF1G2u0kxCmHcvc7KgOBgzXDp0xuZd7a9FpeMF0nEpops/6Dn6N4Ie/Arpa8YY
         +ZEQ==
X-Gm-Message-State: APjAAAVViNEei8QhkBH1H4HLwLevvq5A+3gmWnmaeD3UdOBOIWL9btRa
        MEbns3EpHY7PxoxdpAS3VWZiSzo4Xp5tTcDh1uG0Uw==
X-Google-Smtp-Source: APXvYqy/OPz3AmlE14QgU8VrRdOrCV26Ga9rccZipU0fmod/VFkxGGBRAPL5BNxU9UP3XWDwpKvIUN6iZPAdYPtQvdc=
X-Received: by 2002:a9d:4d8a:: with SMTP id u10mr21854614otk.232.1576340900088;
 Sat, 14 Dec 2019 08:28:20 -0800 (PST)
MIME-Version: 1.0
References: <20191214155614.19004-1-philmd@redhat.com>
In-Reply-To: <20191214155614.19004-1-philmd@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Sat, 14 Dec 2019 16:28:08 +0000
Message-ID: <CAFEAcA_QZtU9X4fxZk2oWAkN-zxXdQZejrSKZbDxPKLMwdFWgw@mail.gmail.com>
Subject: Re: [PATCH 0/8] Simplify memory_region_add_subregion_overlap(..., priority=0)
To:     =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Andrew Baumann <Andrew.Baumann@microsoft.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        kvm-devel <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        Joel Stanley <joel@jms.id.au>, qemu-arm <qemu-arm@nongnu.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        Paul Burton <pburton@wavecomp.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 14 Dec 2019 at 15:56, Philippe Mathieu-Daud=C3=A9 <philmd@redhat.co=
m> wrote:
>
> Hi,
>
> In this series we use coccinelle to replace:
> - memory_region_add_subregion_overlap(..., priority=3D0)
> + memory_region_add_subregion(...)
>
> Rationale is the code is easier to read, and reviewers don't
> have to worry about overlapping because it isn't used.

So our implementation of these two functions makes them
have the same behaviour, but the documentation comments
in memory.h describe them as different: a subregion added
with memory_region_add_subregion() is not supposed to
overlap any other subregion unless that other subregion
was explicitly marked as overlapping. My intention with the
API design here was that using the _overlap() version is
a statement of intent -- this region is *expected* to be
overlapping with some other regions, which hopefully
have a priority set so they go at the right order wrt this one.
Use of the non-overlap function says "I don't expect this
to overlap". (It doesn't actually assert that it doesn't
overlap because we have some legacy uses, notably
in the x86 PC machines, which do overlap without using
the right function, which we've never tried to tidy up.)

We used to have some #if-ed out code in memory.c which
was able to detect incorrect overlap, but it got removed
in commit b613597819587. I thought then and still do
that rather than removing code and API distinctions that
allow us to tell if the board code has done something
wrong (unintentional overlap, especially unintentional
overlap at the same priority value) it would be better to
fix the board bugs so we could enable the warnings/asserts...

thanks
-- PMM
