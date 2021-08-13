Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01A43EBB82
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 19:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhHMRd1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 13:33:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229654AbhHMRdR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 13:33:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628875970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6lKHlbsNZBkOx5VcAhf5vJ7K+O7Q4ZdoYWJvgYdgjQM=;
        b=IG0ggmF5Ig+4aLBd/XylAHB35hYQgJ80EsF8azEABNyO0U1cwlb841qxrWCJKTWtNxXrio
        ggtXpl9GsQPsjmBtZNMF9rsYXdzr4TCxAhsLqdqf+QDrP48gUfkgLEqlbgVk+xmH+9WYgX
        hNmpI8q+S7PDK/gg/tYjINK0VeVXdFA=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-0Hf4rpnsOyeOpMYI5_4DiA-1; Fri, 13 Aug 2021 13:32:48 -0400
X-MC-Unique: 0Hf4rpnsOyeOpMYI5_4DiA-1
Received: by mail-oo1-f72.google.com with SMTP id b32-20020a4a98e30000b029026222bb0380so3582779ooj.23
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 10:32:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6lKHlbsNZBkOx5VcAhf5vJ7K+O7Q4ZdoYWJvgYdgjQM=;
        b=pLWDmbVR255NzxzdEi7DqvA0uztnG/1zMMULJYY9lGEgi+zeJESagGbxHRG6p73WEw
         BJ4x4swFankrYDLr6WkXZh9ivletzNZDaqMWnuD5gbMXvnDYxm0yWSh9v++JBhLEnCL+
         PIbmGkavzku4BVADIUSTPLMo7V14Ug9Zn5lEbtSuJ7lN39LYLhBwyeqxqmBwyfn+4LHN
         Y8gr2BgxtPYG1QjSxR/J4simRxAXztcpY8sOrnbKc8kNzFIcqxoLSDW4rHOwdm4Zm887
         N3I+GhZZLjdI8xf8MTs749hDHn+TCGjEdabsCB/+vTXmO4nt1OVcMHeDRG2+8jFYcCLR
         3rKQ==
X-Gm-Message-State: AOAM5337lgvwBqbZf5rPPQLuzd6subEujqjpUxoB35k3xXKJ6hSvIFQZ
        v78tGh2CE8Kg1VJgzb/3JVRFQy2yEcC5B86UHOf5AVRzCtRTgIUIz2HjZ3wQdKjyL0uPR9wweHd
        Wmtky/Z38sFY9
X-Received: by 2002:a4a:3f01:: with SMTP id e1mr2637372ooa.86.1628875966761;
        Fri, 13 Aug 2021 10:32:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhm72Z1z/LOGlXolrexxrrQ0+Hc3IxVMnVUi3hCBmaCacwZJo6/itaUOXumsnkndATj3EqDA==
X-Received: by 2002:a4a:3f01:: with SMTP id e1mr2637060ooa.86.1628875961685;
        Fri, 13 Aug 2021 10:32:41 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id q3sm235503ooa.13.2021.08.13.10.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 10:32:41 -0700 (PDT)
Date:   Fri, 13 Aug 2021 11:32:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Idar Lund <idarlund@gmail.com>, bjorn@helgaas.com,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: vfio-pci problem
Message-ID: <20210813113240.0e9ab116.alex.williamson@redhat.com>
In-Reply-To: <20210813165307.GA2587844@bjorn-Precision-5520>
References: <CA+enFJkL5AWjehFAHTMG5-+9zyR2eVxqFJ-9MoaJkavjwV+MfA@mail.gmail.com>
        <20210813165307.GA2587844@bjorn-Precision-5520>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Aug 2021 11:53:07 -0500
Bjorn Helgaas <helgaas@kernel.org> wrote:

> [+cc Alex, kvm, linux-pci]
> 
> On Fri, Aug 13, 2021 at 09:43:39AM +0200, Idar Lund wrote:
> > Hi,
> > 
> > I've been struggling with an error in linux since 5.11. Please find my bug
> > report here:
> > https://bugzilla.redhat.com/show_bug.cgi?id=1945565
> > 
> > Then I stumbled upon this mail thread:
> > https://www.spinics.net/lists/linux-pci/msg102243.html which seems related.
> > 
> > Is there another way to do this in 5.11+ or is this an unintentionally bug
> > that got introduced in 5.11?  
> 
> Hi Idar, sorry for the trouble and thanks for the report!  I cc'd some
> VFIO experts who know more than I do about this.
> 
> If I understand correctly, you have a PCI XHCI controller:
> 
>   pci 0000:06:00.0: [1b73:1100] type 00 class 0x0c0330
>   xhci_hcd 0000:06:00.0: xHCI Host Controller
> 
> and you want to unbind the xhci_hcd driver and bind vfio-pci instead:
> 
>   # echo '0000:06:00.0' > /sys/bus/pci/devices/0000\:06\:00.0/driver/unbind
>   # echo 0x1b73 0x1100 > /sys/bus/pci/drivers/vfio-pci/new_id
> 
> In v5.10 (5.10.17-200.fc33.x86_64) this worked fine, but in v5.11
> (5.11.9-200.fc33.x86_64) the "new_id" write returns -EEXIST and
> binding to vfio-pci fails.
> 
> The patch you pointed out appeared in v5.11 as 3853f9123c18 ("PCI:
> Avoid duplicate IDs in driver dynamic IDs list") [1], and I agree it
> looks suspicious.  There haven't been any significant changes to
> pci-driver.c since then.
> 
> Have you added "0x1b73 0x1100" to vfio-pci/new_id previously?  I think
> in v5.10, that would silently work (possibly adding duplicate entries
> to the dynamic ID list) and every write to vfio-pci/new_id would make
> vfio-pci try to bind to the device.
> 
> In v5.11, if you write a duplicate ID to vfio-pci/new_id, you would
> get -EEXIST and no attempt to bind.  As far as I know, the dynamic ID
> list is not visible in sysfs, so it might be hard to avoid writing a
> duplicate.
> 
> But if the vfio-pci dynamic ID list already contains "0x1b73 0x1100",
> you should be able to ask vfio-pci to bind to the device like this:
> 
>   # echo 0000:06:00.0 > /sys/bus/pci/drivers/virtio-pci/bind
> 
> I don't know if that's a solution, but would be useful to know whether
> it's a workaround.

[root@x1 vfio-pci]# echo 0x1b73 0x1100 > new_id 
[root@x1 vfio-pci]# echo 0x1b73 0x1100 > new_id 
bash: echo: write error: File exists
[root@x1 vfio-pci]# uname -r
5.12.15-200.fc33.x86_64

Seems like it behaves as expected now.  The new_id interface has some
inherit issues, essentially all vfio-pci dynamic binding cases should
instead be using the driver_override interface.  The driverctl utility
already makes use of this and will make your life a tiny bit easier.
Thanks,

Alex

