Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FA648F0BD
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244126AbiANUDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiANUDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 15:03:03 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CFBC061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 12:03:03 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id s22so13668100oie.10
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 12:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=ZybI+S6hAkCCxP+Ll/swpa+c4zSIRA66W6LuulrkCis=;
        b=cY5fOVkbBDED5q8lwOSHENPidV1zUvdXxvBwxPXdk3wRjw0pXvo9hYCelTkgoiNzya
         9uFxCmaTJMK6al3vs8Id/bE1aCpbUY3VLuw3pSBVLNoNW4kzDSeWrfCSvQCBDlX8aq3F
         hRY2Fert15lfKEz/uh8d5vjF0q4RmhbAF4mxBobwNLOMATmMUGOOZEITdfWEJEf9Wm3M
         O+UvQtlVRYXni1VvP+mOWSjbt6iFJq7beDwbc1Nfw+7ZRm9xp76tbBPjtYZLj5S70qtC
         OZiYJdDyaUHSno8hQK/0pCT7vG3I6X+dxE9dA2ko4ebFLeG2A2vpjxvao96rd9lq2gYM
         xfuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=ZybI+S6hAkCCxP+Ll/swpa+c4zSIRA66W6LuulrkCis=;
        b=jnSmYjuaQmi6rFFdCOfthJu81iA0jvkLxbBq1AmQbN+bPL1z5nVqylFA9B57SnlO75
         e4TO+s5+kLiCYe/UaHerzjGtqXgHrbf/yWWBjeJ9hwxxLh//mlVOUm+x8FcPBIS6f+QR
         tnkYim/NQiCSSmcViTuZ6NDxccv3zDXcYlptxaF4l0iQUd1vRTXbw90c3LypU2V6yvnG
         Dt8G2g/M/o2i71Il2A1NyXPfx5TrUmMEr/IhITd7jjOw3GDc8laabArrXZG72LXuLUHR
         b5r1GPiDfmK2sCBukGXGhxW906gDSSekUNw3z3FDVjScBFPF5VMXWhF+dNOG+PhmQJk5
         Rctg==
X-Gm-Message-State: AOAM5310rlFfV3vSN7nIJfMY6w2cALcbRbdGw9tHIsWZf8l9oWLKj/Jd
        Chz+rLsnk4kNzt4FzU16BrpVbNAMY1j0N3AcFW77zCJZr+Q/sA==
X-Google-Smtp-Source: ABdhPJy+fGOvYNY7L58+PzlJBpW7nwpZ0OGvgvb+AgP937drhJuwSMNLNWO1l4j8ctSp7mhxxHl1t+XcxJhZqnUQOT4=
X-Received: by 2002:a05:6808:ddd:: with SMTP id g29mr14255928oic.66.1642190582650;
 Fri, 14 Jan 2022 12:03:02 -0800 (PST)
MIME-Version: 1.0
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 14 Jan 2022 12:02:52 -0800
Message-ID: <CALMp9eQZa_y3ZN0_xHuB6nW0YU8oO6=5zPEov=DUQYPbzLeQVA@mail.gmail.com>
Subject: PMU virtualization and AMD erratum 1292
To:     kvm list <kvm@vger.kernel.org>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From AMD erratum 1292:

The processor may experience sampling inaccuracies that cause the
following performance counters to overcount retire-based events.
 =E2=80=A2 PMCx0C0 [Retired Instructions]
 =E2=80=A2 PMCx0C1 [Retired Uops]
 =E2=80=A2 PMCx0C2 [Retired Branch Instructions]
 =E2=80=A2 PMCx0C3 [Retired Branch Instructions Mispredicted]
 =E2=80=A2 PMCx0C4 [Retired Taken Branch Instructions]
 =E2=80=A2 PMCx0C5 [Retired Taken Branch Instructions Mispredicted]
 =E2=80=A2 PMCx0C8 [Retired Near Returns]
 =E2=80=A2 PMCx0C9 [Retired Near Returns Mispredicted]
 =E2=80=A2 PMCx0CA [Retired Indirect Branch Instructions Mispredicted]
=E2=80=A2 PMCx0CC [Retired Indirect Branch Instructions]
 =E2=80=A2 PMCx0D1 [Retired Conditional Branch Instructions]
 =E2=80=A2 PMCx1C7 [Retired Mispredicted Branch Instructions due to Directi=
on Mismatch]
 =E2=80=A2 PMCx1D0 [Retired Fused Branch Instructions]

The recommended workaround is:

To count the non-FP affected PMC events correctly:
 =E2=80=A2 Use Core::X86::Msr::PERF_CTL2 to count the events, and
 =E2=80=A2 Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
 =E2=80=A2 Program Core::X86::Msr::PERF_CTL2[20] to 0b.

It's unfortunate that kvm's PMU virtualization completely circumvents
any attempt to employ the recommended workaround. Admittedly, bit 43
is "reserved," and it would be foolish for a hypervisor to let a guest
set a reserved bit in a host MSR. But, even the first recommendation
is impossible under KVM, because the host's perf subsystem actually
decides which hardware counter is going to be used, regardless of what
the guest asks for.

Am I the only one bothered by this?
