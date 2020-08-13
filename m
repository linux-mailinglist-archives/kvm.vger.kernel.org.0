Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59641243824
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 12:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHMKAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 06:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbgHMKAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 06:00:08 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40323C061757;
        Thu, 13 Aug 2020 03:00:08 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id p13so5051676ilh.4;
        Thu, 13 Aug 2020 03:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HBBtCO4sYM5cGR1OJM1rAIGM4XRmcSnzOKplJZRaOEc=;
        b=Xe+P9dZ0OSVuCym8sAxPQNreP5MjursDti/gFYeaftd5qnAd6Izt9VC+6bixwPH+pv
         WxzgGszSAp1+JVOTYygBvRvTfPXfVeH7BvOsgua8WFWP7gxiFq6yUFNye6tPXa6LJYd8
         xZtWUurhXUagXKlmKNSyLG2E2wbNBaQG8wfES3yYNLqlWlMwbv1Xm6HhqSVbfXxTCas2
         l8YndA9nsuJ69i8eJHq6Yv5g4tO+8OSg3LvQapOGcDpQ7/6aXjWEU7oELCHeUClUN3Zy
         H4aaDimtP0/uG2xaHn4OhukVIEeb1SkQK89TQjXvIp11Aa4Lj/C8JPXkhZSOmRohjb8P
         FxAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HBBtCO4sYM5cGR1OJM1rAIGM4XRmcSnzOKplJZRaOEc=;
        b=TSbkyh9eyGUMJO215Dj9KYDuOyK4/Umrmh8OzJ0MAash/5Wt3QwyswqExymvtG5zrG
         QY2v9PswHunSfuNQlR1+vM3UD4OfDrRViTvHtUDjV/Bit58+nrCZwKoPuVomtSPMzlz8
         wVF3ZDtN85YLgOQW6DulyJTV8k/TUWbeWVfpczOyp1jPfVx1tiVLTvN/NcwBg6jb9QL+
         NFM5um62LcQi83fpG7Y0j1+WesbCp4S7DOzRpEXbk92M3fXVOVXCzz1ymXSHysjRkLZw
         kXvDVCSk/PVwTC4uxlBXE4Xe9e96KCvh+I0Jigk12IpGKJ4WnPiClc+ZhZZ5wSGuNbCv
         Azhg==
X-Gm-Message-State: AOAM531ds8nsczKKoWNFk+MEccAImUqE8q/nYtS2AYl6oUBq7EwFOkoR
        N/+GawOrUsjya/LxuTU0I3GkFp9RMih+pThfC/g=
X-Google-Smtp-Source: ABdhPJyt8lWpNkTHkUK9B0ljcj5r7jnaP8ULbYH0x7eFYLRekeCXt/sOJIy9rXNdFS4t8tfgET7/n+I6kpIRkxRD+w8=
X-Received: by 2002:a92:4a02:: with SMTP id m2mr4077272ilf.258.1597312807549;
 Thu, 13 Aug 2020 03:00:07 -0700 (PDT)
MIME-Version: 1.0
References: <1597260071-2219-1-git-send-email-mjrosato@linux.ibm.com>
 <1597260071-2219-2-git-send-email-mjrosato@linux.ibm.com> <CAOSf1CFjaVoeTyk=cLmWhBB6YQrHQkcD8Aj=ZYrB4kYc-rqLiw@mail.gmail.com>
 <2a862199-16c8-2141-d27f-79761c1b1b25@linux.ibm.com>
In-Reply-To: <2a862199-16c8-2141-d27f-79761c1b1b25@linux.ibm.com>
From:   "Oliver O'Halloran" <oohall@gmail.com>
Date:   Thu, 13 Aug 2020 19:59:56 +1000
Message-ID: <CAOSf1CE6UyL9P31S=rAG=VZKs-JL4Kbq3VMZNhyojHbkPHSw0Q@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: Introduce flag for detached virtual functions
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, pmorel@linux.ibm.com,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-s390@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 7:00 PM Niklas Schnelle <schnelle@linux.ibm.com> wrote:
>
>
> On 8/13/20 3:55 AM, Oliver O'Halloran wrote:
> > On Thu, Aug 13, 2020 at 5:21 AM Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> >> *snip*
> >> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> >> index 3902c9f..04ac76d 100644
> >> --- a/arch/s390/pci/pci.c
> >> +++ b/arch/s390/pci/pci.c
> >> @@ -581,6 +581,14 @@ int pcibios_enable_device(struct pci_dev *pdev, int mask)
> >>  {
> >>         struct zpci_dev *zdev = to_zpci(pdev);
> >>
> >> +       /*
> >> +        * If we have a VF on a non-multifunction bus, it must be a VF that is
> >> +        * detached from its parent PF.  We rely on firmware emulation to
> >> +        * provide underlying PF details.
> >> +        */
> >> +       if (zdev->vfn && !zdev->zbus->multifunction)
> >> +               pdev->detached_vf = 1;
> >
> > The enable hook seems like it's a bit too late for this sort of
> > screwing around with the pci_dev. Anything in the setup path that
> > looks at ->detached_vf would see it cleared while anything that looks
> > after the device is enabled will see it set. Can this go into
> > pcibios_add_device() or a fixup instead?
> >
>
> This particular check could go into pcibios_add_device() yes.
> We're also currently working on a slight rework of how
> we establish the VF to parent PF linking including the sysfs
> part of that. The latter sadly can only go after the sysfs
> for the virtfn has been created and that only happens
> after all fixups. We would like to do both together because
> the latter sets pdev->is_virtfn which I think is closely related.
>
> I was thinking of starting another discussion
> about adding a hook that is executed just after the sysfs entries
> for the PCI device are created but haven't yet.

if all you need is sysfs then pcibios_bus_add_device() or a bus
notifier should work

> That said pcibios_enable_device() is called before drivers
> like vfio-pci are enabled

Hmm, is that an s390 thing? I was under the impression that drivers
handled enabling the device rather than assuming the platform did it
for them. Granted it's usually one of the first things a driver does,
but there's still scope for surprising behaviour.

> and so as long as all uses of pdev->detached_vf
> are in drivers it should be early enough. AFAIK almost everything
> dealing with VFs before that is already skipped with pdev->no_vf_scan
> though.

I'm sure it works fine in your particular case. My main gripe is that
you're adding a flag in a generic structure so people reading the code
without that context may make assumptions about when it's valid to
use. The number of pcibios_* hooks we have means that working out when
and where something happens in the pci setup path usually involves
going on a ~magical journey~ through generic and arch specific code.
It's not *that* bad once you've worked out how it all fits together,
but it's still a pain. If we can initialise stuff before the pci_dev
is added to the bus it's usually for the better.

Oliver
