Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21032DDB36
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 23:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732061AbgLQWNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 17:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732058AbgLQWNf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 17:13:35 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED268C061794
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 14:12:54 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id p187so185412iod.4
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 14:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cnQ0Lby0LlaKdxpu0lMFTLReLS4QL0QOqibD/gKpzVk=;
        b=tEayHahD/XCHnm/jdim1wQ0/K5C51gVllSs6rhqhzlS1j6wWWvoaL3ay52OUs5Ql5N
         8mQ2Ii+S3caP27iNABFqltVowPu7igG+xR8B8Hf7drL5EZtzVVzU5sadeUioM5O+CLQp
         3so0olhq5hujHgFgzhTWwHqQF2uslHVPF5SUJg5euAV2V4GUoEH6fOqwwFqEpuT4gxu1
         CPeFa0Ull7CTdTM/B6SuFZE0SjPCWmXKyVaTggtXHTBriyIcTND7Zp8YfiSw8li5AB9f
         gvTstqZfBw6yLpucXnETiud7ba4iw7cQuQ+REEYOeuxRC54ZLRbdRes2u2CqF8C547/W
         7f/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cnQ0Lby0LlaKdxpu0lMFTLReLS4QL0QOqibD/gKpzVk=;
        b=MForNwWvqyfXwLFozaEm825h+PsI2Y9VpFHLrJ7ANK7IP6xVDayYjArskYsDPVUL/1
         9jE0SgR2668BLT0vr3lK3ID91hSTx21NLS6QrNtpg+LN9Sj58oBXBtFGxwdKbtCuAu3d
         PPWQ9+NC8dfwIW8TT5G+yfZaSapndl5c8Z8P+mPtTYKqCbAiG/JMtzOe841kOo2bIqnE
         0kfnunUG3gRPB6GGwbVTSf8ZZe9bs2trLmRz5zgbkIyMRQwdHFxOdGzobBD9z3S3c3qX
         LQ2Mc6/pQ18yYAb8tHCoYF54csFOL4KFl9DcE05+iDUn26VHD6TK+J0Ga32cNEiFL7qV
         ijwQ==
X-Gm-Message-State: AOAM533MthATn1LiAYAfoNs7eIH9AEnlT6C3gxKibGgKawMQBRQj413Y
        t3BNd9tvlHZZuxscPNeJ+3Ho7/7pRageWANKdb5Hdg==
X-Google-Smtp-Source: ABdhPJx5Fx1yudtT27nkpOSYRKxz8vlFO/bf4ukq4Xkk23lpQBWAU+0il7Yb0ILIVqYmrDh8Lz3jYr5xv+Jym9/Ceyg=
X-Received: by 2002:a6b:b788:: with SMTP id h130mr1263330iof.134.1608243174149;
 Thu, 17 Dec 2020 14:12:54 -0800 (PST)
MIME-Version: 1.0
References: <20201116121942.55031-1-drjones@redhat.com> <902d4020-e295-b21f-cc7a-df5cdfc056ea@redhat.com>
 <20201120080556.2enu4ygvlnslmqiz@kamzik.brq.redhat.com> <6c53eb4d-32ed-ed94-a3ef-dca139b0003d@redhat.com>
 <20201216124638.paliq7v3erhpgfh6@kamzik.brq.redhat.com>
In-Reply-To: <20201216124638.paliq7v3erhpgfh6@kamzik.brq.redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 17 Dec 2020 14:12:43 -0800
Message-ID: <CANgfPd9euWMT-j6oNJwih5um9nBNQZg1DJf2BNnaO3oLX5gLUw@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] KVM: selftests: Cleanups, take 2
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 16, 2020 at 4:47 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Nov 20, 2020 at 09:48:26AM +0100, Paolo Bonzini wrote:
> > On 20/11/20 09:05, Andrew Jones wrote:
> > > So I finally looked closely enough at the dirty-ring stuff to see that
> > > patch 2 was always a dumb idea. dirty_ring_create_vm_done() has a comment
> > > that says "Switch to dirty ring mode after VM creation but before any of
> > > the vcpu creation". I'd argue that that comment would be better served at
> > > the log_mode_create_vm_done() call, but that doesn't excuse my sloppiness
> > > here. Maybe someday we can add a patch that adds that comment and also
> > > tries to use common code for the number of pages calculation for the VM,
> > > but not today.
> > >
> > > Regarding this series, if the other three patches look good, then we
> > > can just drop 2/4. 3/4 and 4/4 should still apply cleanly and work.
> >
> > Yes, the rest is good.
> >
>
> Ping?
>
> Thanks,
> drew

FWIW, patches 1, 3, and 4 look good to me too. Once these are merged,
I've got another new test ready to go which builds on these.
