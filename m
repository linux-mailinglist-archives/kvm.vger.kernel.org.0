Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C13C333D8D
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 14:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhCJNUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 08:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbhCJNUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 08:20:44 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A7DC061760
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 05:20:43 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id i26so13921102ljn.1
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 05:20:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=NMosJyq91//hbqE/k92YM4iDUxJauiW8vJsPHjg/oTY=;
        b=MRpWwe4B74HIvmCTCjfjKSkd0Qp/J9vhWnpGKiT7sPczaL4betuJmfum7mJ2ov/rcw
         B+3F/HOsMx2ve9f0sJy9U60Igq1P6HTShw8XXkjxU4ZcdceLu537SjT+kiJvJf9ZN6fx
         T2m0FglcOwr9Ee9WJ6eCl1Okt4tbHVq/OIqfkuIqKmsdZuIn+6qU97i4OF6J4by8z/C3
         cIn88QLDDIieeogboEuvpdpQeWzc+Hjk+d7fJUs9WjfbM6OFgqKbDK3vqJB6tIXiwY2g
         FTcoaIlQcMHkT3pfyAr3uvh/q1tME71ZocwY8KkVw6Jyr3oSDlEi07a8axd5Bd20Pp8H
         ZxbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NMosJyq91//hbqE/k92YM4iDUxJauiW8vJsPHjg/oTY=;
        b=jhOePMcp01qhkp85pgWaikJKM9N7/zG4z9C30p9EyZPXFNrch+Zz0uPGfXOmvY/uyV
         QudWUBSB0bCqdEHFOlospTnmZ4ZimRlcLXC0yyXPvZhhcfa972Tu5Q2uQXos5UyCuNY0
         UQpqtkZ9exXCOJzxL75LbXQLInNjZAAYKweUQ7uZ8tegEJM5wytG4izm5eBkxY9t2cHo
         8Y1ckLBJEVjh3lbYMf9eIwN2MNcSl4TvEyM56Z2PjNYb5x4/YoI0bNuLIL1ciIkcvYG/
         v1JpyGoq5GnMgnq2VTYGXrm76t9Qkrg/oWdWvHj/IngAeNinyDxW6dVoRSHTCmoymCIl
         J9+g==
X-Gm-Message-State: AOAM531g0J7IPaCWyMFVgwpfzy5dJrcaA7C24nJbfUagr5Opu+ML49MM
        Muy9lsJzDl3b7dn2qmlPhgjV18xBuy36Vrw6
X-Google-Smtp-Source: ABdhPJx4uPFeOnlRzdGvysndsIN7SbH03zTQm/0Ow1rd+TnuB+ZUO4XbAI36aS+jdMNXMmuxOzKNGA==
X-Received: by 2002:a2e:b168:: with SMTP id a8mr1824308ljm.16.1615382441953;
        Wed, 10 Mar 2021 05:20:41 -0800 (PST)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id 197sm3168198ljf.70.2021.03.10.05.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 05:20:41 -0800 (PST)
Message-ID: <c9d8e6a6b533e67192b391dd902e27609121222c.camel@gmail.com>
Subject: Re: [RFC v3 4/5] KVM: add ioregionfd context
From:   Elena Afanasova <eafanasova@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, mst@redhat.com, cohuck@redhat.com,
        john.levon@nutanix.com
Date:   Wed, 10 Mar 2021 05:20:30 -0800
In-Reply-To: <2e7dfb1c-fe13-4e6d-ae65-133116866c2a@redhat.com>
References: <cover.1613828726.git.eafanasova@gmail.com>
         <4436ef071e55d88ff3996b134cc2303053581242.1613828727.git.eafanasova@gmail.com>
         <2ee8cb35-3043-fc06-9973-c8bb33a90d40@redhat.com>
         <2e7dfb1c-fe13-4e6d-ae65-133116866c2a@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-03-09 at 09:01 +0100, Paolo Bonzini wrote:
> On 09/03/21 08:54, Jason Wang wrote:
> > > +        return;
> > > +
> > > +    spin_lock(&ctx->wq.lock);
> > > +    wait_event_interruptible_exclusive_locked(ctx->wq, !ctx-
> > > >busy);
> > 
> > Any reason that a simple mutex_lock_interruptible() can't work
> > here?
> 
> Or alternatively why can't the callers just take the spinlock.
> 
I'm not sure I understand your question. Do you mean why locked version
of wait_event() is used?

> Paolo
> 
> > Thanks
> > 
> > 
> > > +    ctx->busy = true;
> > > +    spin_unlock(&ctx->wq.lock); 

