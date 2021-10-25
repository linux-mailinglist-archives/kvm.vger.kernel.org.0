Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6191439B00
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 17:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbhJYQCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 12:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhJYQCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 12:02:07 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9CAC061745
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 08:59:45 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r2so11340392pgl.10
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 08:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w9P/Rne5ymD8b1qJ3aEv5OCeH/9kZPRIuSn6tq5OUHM=;
        b=j+elYf4ZW9A4N9j6WF9VhABHXAUfL9rCJDDq4F++efLWp0v63eFaShCvnoHiycTytx
         jYb7f5J71kyR4V+6hfdzX3l0Dr+ZKvaI5dPCHn3gB/x8Sj3yLl50euqBykgsDJThODec
         p3aLwMi2Ouf1R8qR+kaod4RpULeg6v+xY0Q0ebMLrqUwz+dzod6e16xlE+s7Wna4nxiZ
         OpOhw1kb5x+dhY5fTVSNeugGihImHCoqqDYK1u7lemdf7PfRXD/KGTZhXXO0i/3sQLY9
         1ckoh6d/ek98LtLtuq4DSsvdt1yj93tTSdMqGLV8MqYAy1c/+CeAGJRUdZaE2SozrEdg
         F18g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w9P/Rne5ymD8b1qJ3aEv5OCeH/9kZPRIuSn6tq5OUHM=;
        b=OuWIbEaWnfVRSdfa0s6+yu+6B7qLaWxZFD0UYDAYgDquA0mT+NEaSIo7B8cevOYecn
         tgu54JvGmYqKyD8hGBM5ySLgRe+psqoc6RQuSrsKbtnSX5+RK+Bct2dzlmpAcMtNhbUP
         pVBqHf6dbt2v2P/gQDEdnEA9xvRB7JxjnXKjNbxL2hR2IhoAl7xJ7TRdCQC2OSJ2Ujg0
         jo3a+VU75kbYCpOu03zivTKzyzf5L3igXxFnvVm3IdzkgGDkWlc1Pk2u3cQFyL+U4ZGf
         uPrVLTlseu/USjdIm9DlenL6wpJT9V4vOGyTF4BsQhe2tB0DBPO5qohX9+KcFL6ccbRp
         y7wA==
X-Gm-Message-State: AOAM53255QB9l3Sc2GIk0Naxr12Pf1luZG7vgRhbVoRj6DTXHPb1NCpJ
        LYhQ8F53CRe1C6ijULrCHXontg==
X-Google-Smtp-Source: ABdhPJwO39513NZAI+ELPplnBuLORATTfpsCJaggJoTWnfGpDNkg7etx8ulBZ8aa5mGR+Iozxj5wOg==
X-Received: by 2002:a63:8f09:: with SMTP id n9mr8654538pgd.466.1635177584732;
        Mon, 25 Oct 2021 08:59:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g11sm16758033pgn.41.2021.10.25.08.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 08:59:44 -0700 (PDT)
Date:   Mon, 25 Oct 2021 15:59:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] KVM: x86: APICv cleanups
Message-ID: <YXbUbB+l++P3XSZ5@google.com>
References: <20211022004927.1448382-1-seanjc@google.com>
 <23d9b009-2b48-d93c-3c24-711c4757ca1b@redhat.com>
 <9c159d2f23dc3957a2fda0301b25fca67aa21b30.camel@redhat.com>
 <b931906f-b38e-1cb5-c797-65ef82c8b262@redhat.com>
 <YXbAxkf1W37m9eZp@google.com>
 <674bc620-f013-d826-a4d4-00a142755a9e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <674bc620-f013-d826-a4d4-00a142755a9e@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 25, 2021, Paolo Bonzini wrote:
> On 25/10/21 16:35, Sean Christopherson wrote:
> > > So yeah, I think you're right.
> > Yep.  The alternative would be to explicitly check for a pending APICv update.
> > I don't have a strong opinion, I dislike both options equally:-)
> 
> No, checking for the update is worse and with this example, I can now point
> my finger on why I preferred the VM check even before: because even though
> the page fault path runs in vCPU context and uses a vCPU-specific role,
> overall the page tables are still per-VM.

Arguably the lack of incorporation into the page role is the underlying bug, and
all the shenanigans with synchronizing updates are just workarounds for that bug.
I.e. page tables are never strictly per-VM, they're per-role, but we fudge it in
this case because we don't want to take on the overhead of maintaining two sets
of page tables to handle APICv.
