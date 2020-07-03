Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B45B213463
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 08:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgGCGo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 02:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgGCGoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 02:44:25 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D69C08C5C1
        for <kvm@vger.kernel.org>; Thu,  2 Jul 2020 23:44:25 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q8so31444985iow.7
        for <kvm@vger.kernel.org>; Thu, 02 Jul 2020 23:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=odGB8TNyWCdqWFOvUPdduy/mDuwvatkITzLXwOy1S7Q=;
        b=kKUS7IMNGJY2+SzWhECJRvZNNLG61zPX5yQWSTMsnOPMQh1wEqANmYx1X5IwvVjZDo
         LlF1J+5FtWC1ePNf1VvN8on1sudpcFECX9oPYqa9OdYuMACu26oR+JKAkC+IuIB5XyQm
         FC5/vvVnssevvXfbTwP6cEKK0n6Vi5kUl2Nms2ozUsiK3CT6mcYmkmD4hxcm6/N5SP5s
         wYYAaepu5Lo97ReO3dMVJJOa63tQMh/da8qLLsj77aRqN49f5IHWl6kgysAuRVOPU40Z
         CgbK1UV4X2sEjNbxzoFETpcyMT6Ey3pRY29i1VePvCaMRyr/evpln+3V1+AsxqlXZZTC
         MVow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=odGB8TNyWCdqWFOvUPdduy/mDuwvatkITzLXwOy1S7Q=;
        b=rCB1JUFuztsGBTq91dRU9dWis13KL0fC3JC8T77Ouovw7x6WR/yKi+RQwxsH5E55KT
         g68/GZG2HQgKRFjiWNPc+40joa3XQ/cClUMVfVOvc+kFAhzXl+q2Z1J64gASjQaWCQla
         iqJauPa5VkI00UlkwwdQuP/fsPCjOcPh5Sxps5x1IqCKfb4wXiOjRPRlfgOo01y2YG6r
         HDrrp+wyo+INAFE/fr6GKJaGS5HBPu0zKeo9pfZjIM9vlNsY4Hbjy/8LRzhDssyl9LFT
         5d29it8z/BFBibMdk4cOmjiwNrrboeYu1egmwwOF9HW9U/a33M/SKNGMR+CRSE1LzVtG
         htPw==
X-Gm-Message-State: AOAM530jCSIkjbFFRQld+2ANlzWWl11MZ9dwTrJDvDu1lcHLWOp+sLl5
        5EeG3KX+xWbWUt/OJY68Nkt8xXxhLcneJScfikYKZg==
X-Google-Smtp-Source: ABdhPJzPjYsVNTjPsHGn5aGpeM2rXoN818Ai/fS/PfHZI4ezHdmCt4f8T4PdyoBQUvwn6ueXUn0EW38be6NrYO+Dk9A=
X-Received: by 2002:a05:6602:2dd4:: with SMTP id l20mr11019260iow.13.1593758664519;
 Thu, 02 Jul 2020 23:44:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200702221237.2517080-1-abhishekbh@google.com>
 <e7bc00fc-fe53-800e-8439-f1fbdca5dd26@redhat.com> <CAN_oZf2t+gUqXe19Yo1mTzAgk2xNhssE-9p58EvH-gw5jpuvzA@mail.gmail.com>
In-Reply-To: <CAN_oZf2t+gUqXe19Yo1mTzAgk2xNhssE-9p58EvH-gw5jpuvzA@mail.gmail.com>
From:   Abhishek Bhardwaj <abhishekbh@google.com>
Date:   Thu, 2 Jul 2020 23:43:47 -0700
Message-ID: <CA+noqoj6u9n_KKohZw+QCpD-Qj0EgoCXaPEsryD7ABZ7QpqQfg@mail.gmail.com>
Subject: Re: [PATCH v3] x86/speculation/l1tf: Add KConfig for setting the L1D
 cache flush mode
To:     Anthony Steinhauser <asteinhauser@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Waiman Long <longman@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86 <x86@kernel.org>, Doug Anderson <dianders@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have tried to steer away from kernel command line args for a few reasons.

I am paraphrasing my colleague Doug's argument here (CC'ed him as well) -

- The command line args are getting unwieldy. Kernel command line
parameters are not a scalable way to set kernel config. It's intended
as a super limited way for the bootloader to pass info to the kernel
and also as a way for end users who are not compiling the kernel
themselves to tweak kernel behavior.

- Also, we know we want this setting from the start. This is a
definite smell that it deserves to be a compile time thing rather than
adding extra code + whatever miniscule time at runtime to pass an
extra arg.

I think this was what CONFIGS were intended for. I'm happy to add all
this to the commit message once it's approved in spirit by the
maintainers.

On Thu, Jul 2, 2020 at 8:18 PM Anthony Steinhauser
<asteinhauser@google.com> wrote:
>
> Yes, this probably requires an explanation why the change is necessary
> or useful. Without that it is difficult to give some meaningful
> feedback.



-- 
Abhishek
