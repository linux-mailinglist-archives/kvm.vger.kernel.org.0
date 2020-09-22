Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF05F2744F0
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 17:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgIVPEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 11:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgIVPEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 11:04:40 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0364C061755;
        Tue, 22 Sep 2020 08:04:39 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id e23so23383922eja.3;
        Tue, 22 Sep 2020 08:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rTuxaF6O1YRLyKMSPcfljA3RrjzEfeLkAJT2nDUZ8d4=;
        b=CHjbVGA+TPZVznCI7EjIj6iyGkyuLhSqaA/THpmRb4O99PgoCnum9C9WLMBHZqvcUs
         /n22G4NPNzEibw1sGe3qHncS/9Zunmp9OaRLMRc1LvWgopKO0fSECsTInwAeqp+vaUSS
         8m1sKm77G/oWNQq8PiVNptSDZBCUs5eO4w9pSjqScVL5tlV7NPnfPuUSsFAKNRuJUJdr
         Hqur/30Bhjn4fHVuaV6L1UUPpDaHBCKiJWZ865nGhRpFlbs4dC5lqodhDF4hJZksYhb2
         JO6lATQCm1RYIZxO8g8SsyPei7RL/n5qwA/MbnN4DzP9RkNWfq2Wy52fm4XPWY2SoWrW
         O6uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rTuxaF6O1YRLyKMSPcfljA3RrjzEfeLkAJT2nDUZ8d4=;
        b=JTzMXeUCk0iP7T3chAl499PwQXoArMpkNY679laVjc8yhkFtv49ZKyuTudIj5AoA9p
         K57YtXLd+CzDrAxT67BEdMyBXz7xDo+6vet5rJ6EZcEYZKK0wrghMvd89bpyDzivL7eV
         XSeYeZwC+fXFnbjfWncJ69yAMiSPPg6tRNcTprUJrxkA8Qug1U5DfxNACLnA/2LlMlTx
         a49DI3aWh00YHkzSPcxlgDwW6375MZKVX1jZFTNFJnLcJsiKqioPF9dnqw7Dc6peSpyP
         4b8BR/WCvNEUyBPM6dqlD7sbcUc/IvmHY7//DmmcCnoPBu1zu8T3rFIxjIW41R7FzB+o
         fUkg==
X-Gm-Message-State: AOAM531l3asq01g1DyBbLP1MJzWOGpjCR/25SsH45zR6F2i3gaOLXcnB
        xgJNJmCn3+yxTgqu7ZLGgduyILDovDiodTmfVQ==
X-Google-Smtp-Source: ABdhPJySwKJqcDjkcsJx4Ik9l0Y5XJH+jcZvWOfWB+NVQERuSusC4kJo72GB5BScwpxuQP5E5SyQ+46LB2LAb83+4Go=
X-Received: by 2002:a17:906:934f:: with SMTP id p15mr5488098ejw.497.1600787078556;
 Tue, 22 Sep 2020 08:04:38 -0700 (PDT)
MIME-Version: 1.0
References: <1600066548-4343-1-git-send-email-wanpengli@tencent.com>
 <b39b1599-9e1e-8ef6-1b97-a4910d9c3784@oracle.com> <91baab6a-3007-655a-5c59-6425473d2e33@redhat.com>
 <CAB5KdOaV81ro=F8BiuFfR_OWrY1+AJ4QngSOXOZt7vH_bXPR5A@mail.gmail.com> <66a1479f-9603-5045-c307-804db1a62845@redhat.com>
In-Reply-To: <66a1479f-9603-5045-c307-804db1a62845@redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Tue, 22 Sep 2020 23:04:27 +0800
Message-ID: <CAB5KdOZ=w_ow=PF2nryoMEUgTjdmBeHWvL4k_Thwe6QcdXuhoA@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Analyze is_guest_mode() in svm_vcpu_run()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 22, 2020 at 10:56 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 22/09/20 16:54, Haiwei Li wrote:
> >> EXIT_FASTPATH_REENTER_GUEST handling up to vcpu_enter_guest)...
> > Hi, Paolo
> >
> > I have sent a patch to do this,
> >
> > https://lore.kernel.org/kvm/20200915113033.61817-1-lihaiwei.kernel@gmail.com/
>
> Cool, thanks.  I think I'll just squash it in Wanpeng's if you don't mind.

It's all ok. I don't mind. Thanks.

    Haiwei
