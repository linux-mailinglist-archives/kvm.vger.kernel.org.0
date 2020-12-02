Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4092CBF67
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 15:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgLBOSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 09:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgLBOSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 09:18:32 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A440C0613CF
        for <kvm@vger.kernel.org>; Wed,  2 Dec 2020 06:17:46 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id a9so5034035lfh.2
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 06:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=38dF8iyFYT3yxRjkM6xKaLvtB9vgl5ckqP99Ym+tor4=;
        b=N60VJHz/4C/MlYGmuvnF85/+MccM2ZvnH8DNspYE7oAWhgxzp5opcBhzBHohlASpHt
         2+Z5VuU5pmP3114c2a2kg/DKLxIzZhNSvzv//NyfNf51pk2HUi2SzkNemCz4t7yrGUT6
         sqczG8Q0wHYTo6UAcIRk3BUKyEUlteCh8nGxXKTsloP9khTjgL4CUkU+qppEtFRbEqAg
         5L82hglxblUIaKM+zyid669V9js7lgVAdiHDEszyXTAZfzRzge8mju7QVVkZVxnWrzmh
         terYUIfUpt4QuShuRoREJaa08FR3fme1IhxHlEg6LI/lvbf5IHHurc57F257fpEeQmHP
         XUzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=38dF8iyFYT3yxRjkM6xKaLvtB9vgl5ckqP99Ym+tor4=;
        b=Slcrf2dyfUvmBMrip0PpLFM1Dnz3eKF8mAuKdPH52tiSPlpI55ok07MoNFtRFsK1b7
         YSH6DW6AKj1ru/ZDj6pNb7Ix6HIDOkeUxZXVtowSGk8yi3OykEUCLR4eTgZEB5MK1QwP
         gxziPo0vQ4v+zvMhgdWLuWFsTIWjAHnaJNdZT64nlTHQo22uv3epYXGheIjShmin2xJG
         +FkQ4RVGD1n+IMAqhhuHejEhOSFOjyunw0FMtDPZV8vv8mRA8O1M/YJkIKK6oUgFWOVs
         plLQ1Y+L33Dw8YZgIpsOiqmpxxhlfyxEYKsNRpCI89bYWGTI8b12uy6Km3Nl3EET+pQ2
         yCWw==
X-Gm-Message-State: AOAM532Wyjx68+pJM1k6QJoub7UglOk1QJF2oF2gQG+uFdVS0Y1rapr+
        aqJ8imFgNZx2N/KSXP4DlXQ=
X-Google-Smtp-Source: ABdhPJwCyd9K3DnbQzo0PmcK9MTHcuzxTt66WDmBL+GEpPDgLgDzdeGh9rmfHugV/7/Dmaflc1aq4w==
X-Received: by 2002:a19:7ec3:: with SMTP id z186mr1388965lfc.164.1606918664508;
        Wed, 02 Dec 2020 06:17:44 -0800 (PST)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id q13sm480619lfk.147.2020.12.02.06.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 06:17:43 -0800 (PST)
Message-ID: <bdc21df41102ac658442786b08766cfc6bd51b99.camel@gmail.com>
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design
 discussion
From:   Elena Afanasova <eafanasova@gmail.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, mst@redhat.com, john.g.johnson@oracle.com,
        dinechin@redhat.com, cohuck@redhat.com, felipe@nutanix.com,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
Date:   Wed, 02 Dec 2020 06:17:32 -0800
In-Reply-To: <20201201103516.GD567514@stefanha-x1.localdomain>
References: <CAFO2pHzmVf7g3z0RikQbYnejwcWRtHKV=npALs49eRDJdt4mJQ@mail.gmail.com>
         <0447ec50-6fe8-4f10-73db-e3feec2da61c@redhat.com>
         <20201126123659.GC1180457@stefanha-x1.localdomain>
         <c9f926fb-438c-9588-f018-dd040935e5e5@redhat.com>
         <20201127134403.GB46707@stefanha-x1.localdomain>
         <6001ed07-5823-365e-5235-8bfea0e72c7f@redhat.com>
         <20201130124702.GB422962@stefanha-x1.localdomain>
         <4c1af937-a176-be67-fbcc-2bcf965e0bbc@redhat.com>
         <20201201103516.GD567514@stefanha-x1.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-12-01 at 10:35 +0000, Stefan Hajnoczi wrote:
> On Tue, Dec 01, 2020 at 12:05:04PM +0800, Jason Wang wrote:
> > On 2020/11/30 下午8:47, Stefan Hajnoczi wrote:
> > > On Mon, Nov 30, 2020 at 10:14:15AM +0800, Jason Wang wrote:
> > > > On 2020/11/27 下午9:44, Stefan Hajnoczi wrote:
> > > > > On Fri, Nov 27, 2020 at 11:39:23AM +0800, Jason Wang wrote:
> > > > > > On 2020/11/26 下午8:36, Stefan Hajnoczi wrote:
> > > > > > > On Thu, Nov 26, 2020 at 11:37:30AM +0800, Jason Wang
> > > > > > > wrote:
> > > > > > > > On 2020/11/26 上午3:21, Elena Afanasova wrote:
> > > > > > Or I wonder whether we can attach an eBPF program when
> > > > > > trapping MMIO/PIO and
> > > > > > allow it to decide how to proceed?
> > > > > The eBPF program approach is interesting, but it would
> > > > > probably require
> > > > > access to guest RAM and additional userspace state (e.g.
> > > > > device-specific
> > > > > register values). I don't know the current status of Linux
> > > > > eBPF - is it
> > > > > possible to access user memory (it could be swapped out)?
> > > > 
> > > > AFAIK it doesn't, but just to make sure I understand, any
> > > > reason that eBPF
> > > > need to access userspace memory here?
> > > Maybe we're thinking of different things. In the past I've
> > > thought about
> > > using eBPF to avoid a trip to userspace for request submission
> > > and
> > > completion, but that requires virtqueue parsing from eBPF and
> > > guest RAM
> > > access.
> > 
> > I see. I've  considered something similar. e.g using eBPF dataplane
> > in
> > vhost, but it requires a lot of work. For guest RAM access, we
> > probably can
> > provide some eBPF helpers to do that but we need strong point to
> > convince
> > eBPF guys.
> > 
> > 
> > > Are you thinking about replacing ioctl(KVM_SET_IOREGION) and all
> > > the
> > > necessary kvm.ko code with an ioctl(KVM_SET_IO_PROGRAM), where
> > > userspace
> > > can load an eBPF program into kvm.ko that gets executed when an
> > > MMIO/PIO
> > > accesses occur?
> > 
> > Yes.
> > 
> > 
> > >   Wouldn't it need to write to userspace memory to store
> > > the ring index that was written to the doorbell register, for
> > > example?
> > 
> > The proram itself can choose want to do:
> > 
> > 1) do datamatch and write/wakeup eventfd
> > 
> > or
> > 
> > 2) transport the write via an arbitrary fd as what has been done in
> > this
> > proposal, but the protocol is userspace defined
> > 
> > > How would the program communicate with userspace (eventfd isn't
> > > enough)
> > > and how can it handle synchronous I/O accesses like reads?
> > 
> > I may miss something, but it can behave exactly as what has been
> > proposed in
> > this patch?
> 
> I see. This seems to have two possible advantages:
> 1. Pushing the kvm.ko code into userspace thanks to eBPF. Less kernel
>    code.
> 2. Allowing more flexibile I/O dispatch logic (e.g. ioeventfd-style
>    datamatch) and communication protocols.
> 
> I think #1 is minor because the communication protocol is trivial,
> struct kvm_io_device can be reused for dispatch, and eBPF will
> introduce
> some complexity itself.
> 
> #2 is more interesting but I'm not sure how to use this extra
> flexibility to get a big advantage. Maybe vfio-user applications
> could
> install an eBPF program that speaks the vfio-user protocol instead of
> the ioregionfd protocol, making it easier to integrate ioregionfd
> into
> vfio-user programs?
> 
> My opinion is that eBPF complicates things and since we lack a strong
> use case for that extra flexibility, I would stick to the ioregionfd
> proposal.
> 
I agree with this point.

> Elena, Jason: Do you have any opinions on this?
> 
> Stefan

