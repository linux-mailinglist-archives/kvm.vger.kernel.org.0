Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C910471152
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 04:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345806AbhLKDwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 22:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236273AbhLKDwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 22:52:16 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DEAC061714
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 19:48:40 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id w15-20020a4a9d0f000000b002c5cfa80e84so2864645ooj.5
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 19:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+DAiWwhbhf5mzupY++s4IWYZHYOZ9W8B0LFJHzjR4SI=;
        b=YxowbIUKlq3wkGPorar1DdyK8l3BCxozc2EV6JQV4fiA+VDVLgHmk6ME1DwUsLx8St
         AvXWGHWM6B48Uk5oi0GyB7b7CtP4DxriI7XxA+kqp0E6FuW+mN1KqsjxazCRHPNovgyR
         pZotyZ6W35hQbRMW6vaOzQrttmBSe7aKT2NgPeWhZsjZaoU47EV/KoCnjGrMTCbRNnZT
         EFKCvUHGNSn0Sdiv+EWNOrH46j6vtuoIsyXK4YELqt5Rp3VTfXeh5yALVFpzFReTxIko
         55fKgEzy7eboqKDWd2L9WfAFE0vF9tlGzH+YD8Qa5j6uipqbBOHE6am8N/58bnC4ZG8w
         uVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+DAiWwhbhf5mzupY++s4IWYZHYOZ9W8B0LFJHzjR4SI=;
        b=qcOFfM3+M6Hn0U7kS7XI/HG3TeSGfYDhqICuf++L1+CdmA3wYQRXyNNYNw6D/Kd9zN
         b1bWx2VOd+AjcuRNbR9SF33dLPWIyujwuC6CdB6lWSv10WCDqii1vgR+OKASRuIkQ6Hb
         6eOiYaYpeBkov8Txa31qUJguWDxbYs61Gve+l7GJgIg8B2xdCtEYEInDgEAqAIdCREAi
         iB8EIQILdlj6N65y6pnzroa6yi3J2+wTk2/g6bY6etdVRzS6L10L7awze6s32NQErgcP
         j3GO73ydk30uteiBc1Ht92BqjnZdtw/9NMFRGepk11pWLIbM3XdHDdDPKt9prYTIAiw6
         k1+A==
X-Gm-Message-State: AOAM530Ik2X4vjt9HP0dThqN1Foq2x/3Elk6ZZ+JDWQfhsdcZV1rWawb
        sZnZ67cf0HLS8vW/iax2PmHRXOqUfNJmf6c/7HB73MyfOmQotg==
X-Google-Smtp-Source: ABdhPJzQ3WEnpBZx1+MKClb8xTkWkqLKlVYYUvJBIikKDOS7TwrepwTdpFxygZgNVXHMAGcTGlKSeBwkRAQTG86lRSc=
X-Received: by 2002:a4a:3042:: with SMTP id z2mr10915248ooz.47.1639194519067;
 Fri, 10 Dec 2021 19:48:39 -0800 (PST)
MIME-Version: 1.0
References: <20211117080304.38989-1-likexu@tencent.com> <c840f1fe-5000-fb45-b5f6-eac15e205995@redhat.com>
 <CALMp9eRA8hw9zVEwnZEX56Gao-MibX5A+XXYS-n-+X0BkhrSvQ@mail.gmail.com> <438d42de-78e1-0ce9-6a06-38194de4abd4@redhat.com>
In-Reply-To: <438d42de-78e1-0ce9-6a06-38194de4abd4@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 10 Dec 2021 19:48:27 -0800
Message-ID: <CALMp9eSLU1kfffC3Du58L8iPY6LmKyVO0yU7c3wEnJAD9JZw4w@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/svm: Add module param to control PMU virtualization
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021 at 6:15 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/10/21 20:25, Jim Mattson wrote:
> > In the long run, I'd like to be able to override this system-wide
> > setting on a per-VM basis, for VMs that I trust. (Of course, this
> > implies that I trust the userspace process as well.)
> >
> > How would you feel if we were to add a kvm ioctl to override this
> > setting, for a particular VM, guarded by an appropriate permissions
> > check, like capable(CAP_SYS_ADMIN) or capable(CAP_SYS_MODULE)?
>
> What's the rationale for guarding this with a capability check?  IIRC
> you don't have such checks for perf_event_open (apart for getting kernel
> addresses, which is not a problem for virtualization).

My reasoning was simply that for userspace to override a mode 0444
kernel module parameter, it should have the rights to reload the
module with the parameter override. I wasn't thinking specifically
about PMU capabilities.
