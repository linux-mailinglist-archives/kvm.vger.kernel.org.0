Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30F433434E
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 17:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbhCJQme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 11:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbhCJQmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 11:42:13 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4178AC061760
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 08:42:13 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id u4so34623137lfs.0
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 08:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=dLh7+HUqBUhp2ryMuo/eGpHQcPv1fr6CG0BCxKaEW04=;
        b=eYnxDxzGAp823W4Czw+KFPXXhkWW7q/1EkR4B0E8RwJu0A6BEIyrzjvbT5XqUTAwTr
         jVhl/igiq44uY6gPBPEtwb8JBh18Nsp7UwK9Xgoi+xsXPiAuDPiyxGyuG1Iq69hEqBnp
         bchMDWanRGgSK1KT2dNymxszMYttoq9ItEVHvGG9ZlS+3n+zejZMqQyqQ13iKpXoHHQd
         O9VLxIIxpMR+R9xa0/TB/lgjlXeOglfj6zvfE1EgbmZoNnow+jBQWyhqb+CpTOb6e51V
         qEpIwhJNC5p3gy678yyrJL/RIv5Myi2gdbLZl2+jPpafAjeE3QOkK5HoX2WfOquvycHI
         uuWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=dLh7+HUqBUhp2ryMuo/eGpHQcPv1fr6CG0BCxKaEW04=;
        b=A+sEQPJPiVfMP2LWq0scwnqOzpwyXE2dalcJ2ED6Ft20+o9+JCabxOgQUFkqQ8Zxf+
         Z1G1/y4HFxxvSlSPF9nfvNytzVWtofjiinFG0QV2rZ2YFLctLIb/EyPji1jBWaVBcU4/
         JCEczI4LIZmyskOkiOa7tOi/BubUlfGGW0tIAj0BfaLCvZaCD6ciuaRU7UIjyru7KYpI
         W0MtpchuwDd+JpT2AvfsRNR2cbvOfkNdd87nTApHjc2hi7nezEWTyNbS0trLy/UQ98tx
         WuEfpTSOiowcMIUb9ggsIP9cdSb7IQn10ZGKENisIm1eQIgDSY7f3/9VCbOaQ0yEKsAC
         KgLQ==
X-Gm-Message-State: AOAM533rvuApMVMYob9ZBJVqmqNIA0Ah5BijsYgSL74TDnTDdHJZbwfs
        At79KU+mVzf/fDmXIanC13fQFPV/Mh/eFZFf
X-Google-Smtp-Source: ABdhPJy7SSB3t1A5tjOUEPKlzDOYmPbAgS04Z8scblUmx0oz/N0QdLi5e1C2LD0bpHrx7u5chu6i4w==
X-Received: by 2002:a05:6512:1086:: with SMTP id j6mr2490115lfg.96.1615394531466;
        Wed, 10 Mar 2021 08:42:11 -0800 (PST)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id e8sm3306480ljg.22.2021.03.10.08.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 08:42:10 -0800 (PST)
Message-ID: <95b1dc00ff533ce004ecc656bd130bd07e29a1f0.camel@gmail.com>
Subject: Re: [RFC v3 4/5] KVM: add ioregionfd context
From:   Elena Afanasova <eafanasova@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, mst@redhat.com, cohuck@redhat.com,
        john.levon@nutanix.com
Date:   Wed, 10 Mar 2021 08:41:53 -0800
In-Reply-To: <50823987-d285-7a18-7c46-771f08c3c0ff@redhat.com>
References: <cover.1613828726.git.eafanasova@gmail.com>
         <4436ef071e55d88ff3996b134cc2303053581242.1613828727.git.eafanasova@gmail.com>
         <2ee8cb35-3043-fc06-9973-c8bb33a90d40@redhat.com>
         <2e7dfb1c-fe13-4e6d-ae65-133116866c2a@redhat.com>
         <c9d8e6a6b533e67192b391dd902e27609121222c.camel@gmail.com>
         <50823987-d285-7a18-7c46-771f08c3c0ff@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-03-10 at 15:11 +0100, Paolo Bonzini wrote:
> On 10/03/21 14:20, Elena Afanasova wrote:
> > On Tue, 2021-03-09 at 09:01 +0100, Paolo Bonzini wrote:
> > > On 09/03/21 08:54, Jason Wang wrote:
> > > > > +        return;
> > > > > +
> > > > > +    spin_lock(&ctx->wq.lock);
> > > > > +    wait_event_interruptible_exclusive_locked(ctx->wq, !ctx-
> > > > > > busy);
> > > > 
> > > > Any reason that a simple mutex_lock_interruptible() can't work
> > > > here?
> > > 
> > > Or alternatively why can't the callers just take the spinlock.
> > > 
> > I'm not sure I understand your question. Do you mean why locked
> > version
> > of wait_event() is used?
> 
> No, I mean why do you need to use ctx->busy and wait_event, instead
> of 
> operating directly on the spinlock or on a mutex.
> 
When ioregionfd communication is interrupted by a signal ioctl(KVM_RUN)
has to return to userspace. I'm not sure it's ok to do that with the
spinlock/mutex being held.

> Paolo
> 

