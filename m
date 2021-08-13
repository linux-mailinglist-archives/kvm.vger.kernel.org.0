Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592113EBB8C
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 19:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhHMRir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 13:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhHMRiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 13:38:46 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD42C061756;
        Fri, 13 Aug 2021 10:38:19 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id y34so21168511lfa.8;
        Fri, 13 Aug 2021 10:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X82TF293OjZ/KJsRk5++L79a0qP7TiWBwXkmb5RLf9E=;
        b=Lh2FAOI4aZZiyMeIZTTLeIbgJk4V8R4tYZGKURlB4qkagDs7Pk8AWQ/klK0D0aFeJq
         mdJaT0mxCBAI78X1I5sG+OKtdUlu2SvfV0DlSGaQX6a/askwGCO05iUbt0V5KBJTRrZV
         bkMVP3jid+0qPBKwBIm+IqjgsYZgeD8+RYoSAI1+yoBoJPycA2ldBlVMD+HOi1Qr/RRW
         69DTtyXVkLmt5toj1wZ5PLaHJVYZJ+AXiWiNdhCxKStlhvbDVEDJENCBrBbTDgqQuBgq
         26XnZtFQ5BpVWqczDNsU6YJTDDcIrtyd4u/6qbPS+nsXyaAg/Ph3+jqmbx22mTFcCpZI
         2gsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X82TF293OjZ/KJsRk5++L79a0qP7TiWBwXkmb5RLf9E=;
        b=msEYt50lEQ3svWNrEjMSkoVSKpeOrjf59YlMiOoG8U8Z2412c22LSBXeoVURo+y1dO
         UnbYJZ2j+Un3YJMqXh+MwQLovCMt+HBtLLrjfdh+l2GMAyX0Petlvuf391HcNwBRlL9P
         PKYmosa6dltmOd+coHe3UCn5/M9hOMjUq73ajL+MU7AhphYFVS51D2BJ4uBGOvnjfSmd
         kU6KJeLaf8QRXfxgDdlXPTI2PV0ifZ8OnR5p61/WV00i+ayGcP9Yd+1ONMj880jGewCp
         GLOzHGGFDgjqy31PwQ/ttr93S1sDqrFjO+WHpW1i4OabRxU5lwqtMN7cbB3gpchz6SGU
         Inxg==
X-Gm-Message-State: AOAM532//U2nc2lFgXNFEfNT7nK1iJ2jSzRUhKaCxrlf/cYQD3OphlzR
        +OfzvW8yz+1xHZH5axnXC9J9CsUJVGjautiK4kA=
X-Google-Smtp-Source: ABdhPJywIa8UC7iK8kwdXMmMLho7Ei5NJ9v7JwttJMDsvm7ei63YXsxl3d4GqEbriApyzwEIPSpjzQCPo3CvD+MClUw=
X-Received: by 2002:a05:6512:98d:: with SMTP id w13mr2450412lft.91.1628876297612;
 Fri, 13 Aug 2021 10:38:17 -0700 (PDT)
MIME-Version: 1.0
References: <CA+enFJkL5AWjehFAHTMG5-+9zyR2eVxqFJ-9MoaJkavjwV+MfA@mail.gmail.com>
 <20210813165307.GA2587844@bjorn-Precision-5520> <20210813113240.0e9ab116.alex.williamson@redhat.com>
In-Reply-To: <20210813113240.0e9ab116.alex.williamson@redhat.com>
From:   Idar Lund <idarlund@gmail.com>
Date:   Fri, 13 Aug 2021 19:38:06 +0200
Message-ID: <CA+enFJ=JX34ePMVObcumi-exVfvaQapMLKHKKNXBNEsX5PwLrA@mail.gmail.com>
Subject: Re: vfio-pci problem
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, bjorn@helgaas.com,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

Thanks for the reply Bjorn!

Got a Mail Delivery system message back on this e-mail because it
contained HTML. Gawd dammit gmail! Sorry to all of you that are
getting this 2 times.
Also; Alex' comment got in between here. So I'll answer that one here
too (at the bottom).

Yes, you understand correctly. The issue here is that I have a PCI
XHCI controller that I want to bind to the vfio-pci instead of the
xhci_hcd. The reason is that I want to be able to pass through this
device to a virtual machine.

I'm not sure if I understand your question 'Have you added "0x1b73
0x1100" to vfio-pci/new_id previously', but I'll try to answer; no, I
don't add it during the 5.11 (and newer kernels) boot process or
anything like that, I only add it manually like the commands in the
bugzilla bug report when starting the virtual machine. And I also do
it only once. If someone is interested in the source on why I'm doing
it like this, check out
https://www.heiko-sieger.info/running-windows-10-on-linux-using-kvm-with-vga-passthrough/#Part_14_-_Passing_more_PCI_devices_to_guest

Unfortunately the workaround don't seem to be working:
[root@silje ~]# echo '0000:06:00.0' > /sys/bus/pci/drivers/virtio-pci/bind
-bash: echo: write error: No such device

Alex;
Yes, the patch works as expected for (errorusly) double adding to
new_id, the problem here is that this is the first time echoing to
new_id.

-Idar

On Fri, Aug 13, 2021 at 7:32 PM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Fri, 13 Aug 2021 11:53:07 -0500
> Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> > [+cc Alex, kvm, linux-pci]
> >
> > On Fri, Aug 13, 2021 at 09:43:39AM +0200, Idar Lund wrote:
> > > Hi,
> > >
> > > I've been struggling with an error in linux since 5.11. Please find my bug
> > > report here:
> > > https://bugzilla.redhat.com/show_bug.cgi?id=1945565
> > >
> > > Then I stumbled upon this mail thread:
> > > https://www.spinics.net/lists/linux-pci/msg102243.html which seems related.
> > >
> > > Is there another way to do this in 5.11+ or is this an unintentionally bug
> > > that got introduced in 5.11?
> >
> > Hi Idar, sorry for the trouble and thanks for the report!  I cc'd some
> > VFIO experts who know more than I do about this.
> >
> > If I understand correctly, you have a PCI XHCI controller:
> >
> >   pci 0000:06:00.0: [1b73:1100] type 00 class 0x0c0330
> >   xhci_hcd 0000:06:00.0: xHCI Host Controller
> >
> > and you want to unbind the xhci_hcd driver and bind vfio-pci instead:
> >
> >   # echo '0000:06:00.0' > /sys/bus/pci/devices/0000\:06\:00.0/driver/unbind
> >   # echo 0x1b73 0x1100 > /sys/bus/pci/drivers/vfio-pci/new_id
> >
> > In v5.10 (5.10.17-200.fc33.x86_64) this worked fine, but in v5.11
> > (5.11.9-200.fc33.x86_64) the "new_id" write returns -EEXIST and
> > binding to vfio-pci fails.
> >
> > The patch you pointed out appeared in v5.11 as 3853f9123c18 ("PCI:
> > Avoid duplicate IDs in driver dynamic IDs list") [1], and I agree it
> > looks suspicious.  There haven't been any significant changes to
> > pci-driver.c since then.
> >
> > Have you added "0x1b73 0x1100" to vfio-pci/new_id previously?  I think
> > in v5.10, that would silently work (possibly adding duplicate entries
> > to the dynamic ID list) and every write to vfio-pci/new_id would make
> > vfio-pci try to bind to the device.
> >
> > In v5.11, if you write a duplicate ID to vfio-pci/new_id, you would
> > get -EEXIST and no attempt to bind.  As far as I know, the dynamic ID
> > list is not visible in sysfs, so it might be hard to avoid writing a
> > duplicate.
> >
> > But if the vfio-pci dynamic ID list already contains "0x1b73 0x1100",
> > you should be able to ask vfio-pci to bind to the device like this:
> >
> >   # echo 0000:06:00.0 > /sys/bus/pci/drivers/virtio-pci/bind
> >
> > I don't know if that's a solution, but would be useful to know whether
> > it's a workaround.
>
> [root@x1 vfio-pci]# echo 0x1b73 0x1100 > new_id
> [root@x1 vfio-pci]# echo 0x1b73 0x1100 > new_id
> bash: echo: write error: File exists
> [root@x1 vfio-pci]# uname -r
> 5.12.15-200.fc33.x86_64
>
> Seems like it behaves as expected now.  The new_id interface has some
> inherit issues, essentially all vfio-pci dynamic binding cases should
> instead be using the driver_override interface.  The driverctl utility
> already makes use of this and will make your life a tiny bit easier.
> Thanks,
>
> Alex
>
