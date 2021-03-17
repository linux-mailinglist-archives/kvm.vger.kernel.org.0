Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F1233EEA9
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 11:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhCQKro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 06:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhCQKrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 06:47:12 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A84C06174A
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 03:47:12 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id p21so2210710lfu.11
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 03:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=D3+asHosyveO3oNqTVARLLdoW1Ou9vqvVWN+nWXsQeQ=;
        b=o7bQ1ZzIX+fJXuP1r/bh5GMs42fiAxUxu1QXPWAKpj2w6yKDrhD48H4Rv/5Op+q/OB
         n8aA07Rf27hMMwO0xxDxgMRi2T9c7sC7TOxpjqeDldO+YxvzDqh+eDCLXkBkmf38bPMK
         1zN6nLly0EXOcuJViS84zkRAXJPtTNn6LKCyHluSx3QpSciUpfbXwtAjxSeK2ABLxN7S
         lKAxqCXOpAKXB947hJ0NnPvoH/weFbjtUDbuBLJBmvK3QNnV5JDS63OL9B5E3GaiahnE
         foRn5mx8oeuPNmhCa5Y2wkRBzbcoRfooIy4dbEH9f/bIzph3yyJdE5dOvGMOCgeb6n0m
         nITQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=D3+asHosyveO3oNqTVARLLdoW1Ou9vqvVWN+nWXsQeQ=;
        b=AyxKXirJu1r6uVyh9jPjdQNfzA5ZnOSS7wDFePY4lLR80J86XKOzdogLsRQt2oGcm6
         LxAzfB7rtr3Bl1olLwTRkjhmkDS7fJm81j3MtnTCNMNmP/7jEDQy86QA8d8iq3Z4iwi3
         akQ71owyQeFLAyT0z8dzOOBKfAzD53RoUGh7IUeoJLTa9J0PpHDEmEbujZRI5gyOlG/d
         AoK8gZqJhyPT84B8iqTaKMaFSCXLrd/f+7BuAV/2cTb8TLsmji3ncuJ78/sf7T7mThfB
         6FxWbfhilD+Qzxmt/5JAHFJOzdhIRpDp5wVJns324TS71KkWBNeFq8iEkfESitp9Piuz
         jazg==
X-Gm-Message-State: AOAM532UuTmcD0p1zP/C1Uvp2BlGvoA9/jB8k2mCl4yN3lhhBTtO4XMD
        Fif/JmZMgMkRhWhOV1c5Nco=
X-Google-Smtp-Source: ABdhPJwJ6zZpwKWrLon7pi5cJss5vmuxf4IvR48Obhmib/18xZAK9Q/JGreMefi9kf8icV0gQd3HRA==
X-Received: by 2002:a05:6512:3481:: with SMTP id v1mr1992641lfr.193.1615978030762;
        Wed, 17 Mar 2021 03:47:10 -0700 (PDT)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id g14sm3476727ljj.3.2021.03.17.03.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 03:47:10 -0700 (PDT)
Message-ID: <7257025149c6a7369e7e2fd7c6291879c4bc127d.camel@gmail.com>
Subject: Re: [RFC v3 4/5] KVM: add ioregionfd context
From:   Elena Afanasova <eafanasova@gmail.com>
To:     Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, mst@redhat.com, cohuck@redhat.com,
        john.levon@nutanix.com
Date:   Wed, 17 Mar 2021 03:46:59 -0700
In-Reply-To: <6ff79d0b-3b6a-73d3-ffbd-e4af9758735f@redhat.com>
References: <cover.1613828726.git.eafanasova@gmail.com>
         <4436ef071e55d88ff3996b134cc2303053581242.1613828727.git.eafanasova@gmail.com>
         <2ee8cb35-3043-fc06-9973-c8bb33a90d40@redhat.com>
         <2e7dfb1c-fe13-4e6d-ae65-133116866c2a@redhat.com>
         <c9d8e6a6b533e67192b391dd902e27609121222c.camel@gmail.com>
         <50823987-d285-7a18-7c46-771f08c3c0ff@redhat.com>
         <95b1dc00ff533ce004ecc656bd130bd07e29a1f0.camel@gmail.com>
         <6ff79d0b-3b6a-73d3-ffbd-e4af9758735f@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-03-11 at 11:04 +0800, Jason Wang wrote:
> 
> On 2021/3/11 12:41 上午, Elena Afanasova wrote:
> > On Wed, 2021-03-10 at 15:11 +0100, Paolo Bonzini wrote:
> > > On 10/03/21 14:20, Elena Afanasova wrote:
> > > > On Tue, 2021-03-09 at 09:01 +0100, Paolo Bonzini wrote:
> > > > > On 09/03/21 08:54, Jason Wang wrote:
> > > > > > > +        return;
> > > > > > > +
> > > > > > > +    spin_lock(&ctx->wq.lock);
> > > > > > > +    wait_event_interruptible_exclusive_locked(ctx->wq,
> > > > > > > !ctx-
> > > > > > > > busy);
> > > > > > 
> > > > > > Any reason that a simple mutex_lock_interruptible() can't
> > > > > > work
> > > > > > here?
> > > > > 
> > > > > Or alternatively why can't the callers just take the
> > > > > spinlock.
> > > > > 
> > > > 
> > > > I'm not sure I understand your question. Do you mean why locked
> > > > version
> > > > of wait_event() is used?
> > > 
> > > No, I mean why do you need to use ctx->busy and wait_event,
> > > instead
> > > of 
> > > operating directly on the spinlock or on a mutex.
> > > 
> > 
> > When ioregionfd communication is interrupted by a signal
> > ioctl(KVM_RUN)
> > has to return to userspace. I'm not sure it's ok to do that with
> > the
> > spinlock/mutex being held.
> 
> 
> So you don't answer my question. Why you can't use
> mutex_lock_interruptible() here?
> 
> It looks can do exactly what you want here.
> 
> Thanks
> 
I think mutex could work here. I used it for the first implementation.
But is it ok to hold a mutex on kernel->user transitions? Is it correct
pattern in this case? 
If ioctl returns to userspace and then ioregionfd is deleted or vcpu fd
is closed, with a mutex held it will be necessary to unlock it. But I
think it’s a bit clearer to use wake_up in e.g. kvm_vcpu_release
instead of mutex_unlock. Paolo, could you please also comment on this?

> 
> 

