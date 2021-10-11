Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889CB4286B8
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 08:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbhJKGVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 02:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbhJKGVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 02:21:45 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3901C061570;
        Sun, 10 Oct 2021 23:19:45 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id e63so2684942oif.8;
        Sun, 10 Oct 2021 23:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NQrmWWl63A33R8Wd94dEHY3g+CGyCI+tb3fF7nKj8Tk=;
        b=Qr6rXhVxFmYhsK8m4vTD/HFq5b9rd47q4NAYOYhjdVQNA8cQrFbwvZp3iL3nB7Brir
         4fx5ahVzODwaRFvhWN0Nl5VnyQ+5/W16F98AdIFeCrSyPX+6/MosKvLbRaDFVAhPEKsm
         tjtUheEKRh7wNasOZIMdAhpkBjsaGmyOW8nrm7BMFd+1awDUYWD97reFJ8UrV15rd+E8
         j4Owtm7OF/39OTog+A+t2JruMREZSDTRJ7qhPgaY60yjXFcOJMZdC+OboDtlyXLBfI67
         aure4EGxvPLok7eHkLVaA1M1J0Dai7Y8hLzUspPsYKUnQszLklVDipUNuIlyEHZWCMA2
         5X1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NQrmWWl63A33R8Wd94dEHY3g+CGyCI+tb3fF7nKj8Tk=;
        b=X5zL/P4QgQi8dDvEc4NgoFzD4IdrlBw7Cl9zORZIvyJH/kNVe24uYa6r8LdexVMpSy
         8+PU66i8RjSUuiXdGE0nOdOaKKjgBlUMY2+6UUvrhFbwiODvxohM7l46ViDssE1ijGT6
         +IxOZoA+1xp1zruXXHunPlZRYSmSD/sqGL5QJ90B5q+mYNzMV1XWkQ2W0t5r6/ZSbLo0
         9kl59fTr6NJGyIoRXsWO0otoR/RHIe2wVy8nQqSofixAGsfrL0/uQpNaQXxo6/DIaWvb
         zabIwirwGkMpGZwMiPNzI1SP/dGlQvtf1Pgidb+yh4Qlr6gbvDYcf1YOdmNAlMdrXigm
         VEWA==
X-Gm-Message-State: AOAM530t76T28BFlKK8zMTwkDFGqtObDJPvctaXiB00pEE1KfwgL1PEv
        99BrB0jMp8e8JzNzkrI0kILnWAn61uXz5mssnGM=
X-Google-Smtp-Source: ABdhPJwpC0UYINOki3htK4lif6uPz1mOCm8+UV47WtM2pOR+74uBDeBfpzt/VFYoVXyDSYXd6Us5FtsJmWt3/Ym5bxU=
X-Received: by 2002:a05:6808:1211:: with SMTP id a17mr16766331oil.91.1633933185323;
 Sun, 10 Oct 2021 23:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211002124012.18186-1-ajaygargnsit@gmail.com>
 <b9afdade-b121-cc9e-ce85-6e4ff3724ed9@linux.intel.com> <CAHP4M8Us753hAeoXL7E-4d29rD9+FzUwAqU6gKNmgd8G0CaQQw@mail.gmail.com>
 <20211004163146.6b34936b.alex.williamson@redhat.com> <CAHP4M8UeGRSqHBV+wDPZ=TMYzio0wYzHPzq2Y+JCY0uzZgBkmA@mail.gmail.com>
 <CAHP4M8UD-k76cg0JmeZAwaWh1deSP82RCE=VC1zHQEYQmX6N9A@mail.gmail.com>
In-Reply-To: <CAHP4M8UD-k76cg0JmeZAwaWh1deSP82RCE=VC1zHQEYQmX6N9A@mail.gmail.com>
From:   Ajay Garg <ajaygargnsit@gmail.com>
Date:   Mon, 11 Oct 2021 11:49:33 +0530
Message-ID: <CAHP4M8VPem7xEtx3vQPm3bzCQif7JZFiXgiUGZVErTt5vhOF8A@mail.gmail.com>
Subject: Re: [PATCH] iommu: intel: remove flooding of non-error logs, when
 new-DMA-PTE is the same as old-DMA-PTE.
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The flooding was seen today again, after I booted the host-machine in
the morning.
Need to look what the heck is going on ...

On Sun, Oct 10, 2021 at 11:45 AM Ajay Garg <ajaygargnsit@gmail.com> wrote:
>
> > I'll try and backtrack to the userspace process that is sending these ioctls.
> >
>
> The userspace process is qemu.
>
> I compiled qemu from latest source, installed via "sudo make install"
> on host-machine, rebooted the host-machine, and booted up the
> guest-machine on the host-machine. Now, no kernel-flooding is seen on
> the host-machine.
>
> For me, the issue is thus closed-invalid; admins may take the
> necessary action to officially mark ;)
>
>
> Thanks and Regards,
> Ajay
