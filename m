Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8506641D182
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 04:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347866AbhI3CjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 22:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347849AbhI3CjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 22:39:08 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2481EC06161C
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 19:37:26 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id d12-20020a05683025cc00b0054d8486c6b8so5519874otu.0
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 19:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=QRO8bGloYSGiZ/lsyrnp0N1/zZRlhpKBzkIva9dTW6I=;
        b=Q/VNJVh+EJdMmOBeNrshol+RBCs9t0ygQwYA5sRhkyQydlAWPiP95WZYai2o8PYLBI
         GCRoemv+MEgW56mcrnJwh6joU7aKNDm2bhvPl5l+JN5QKneESbxSpSfunJDRgx6V/VEo
         TEpLa0GcIZqcUrYsTxw6+lKMz/gRq6otqN+WKgt8q0zwjAykutTCJLHxg6NDk0Kq8xDJ
         iGVhpaDdFO+CEloNEvaUrZGMILsP2nudkT39qKvie2EHv8OeKwG6srQzAZTpfRpjBDds
         LfjpWRoibaWsTvOX2DAucEjScdztCRPI9VWaRXlVimsbNNMQl86UwyV3urGmqhTVY4GC
         bQSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=QRO8bGloYSGiZ/lsyrnp0N1/zZRlhpKBzkIva9dTW6I=;
        b=XaGvWFZ8Lu+XRDOYPZqCdS3dH8VOk/lMwkI7dONe+TwP7+3P1wE3YOEPvMXZJHPWZD
         Js5jDmQstp+EvKYElvFhH2b0zbS5v8RgL09kZE0NH8EgX+oUo8TtInafk2kqD1K2Z+UT
         edFvf5qfzHMlgDc2k/szipCFqDYKzpef7r0oAEY/iko++0lcCizQwXstCdS0ijEqMdkK
         VjAiP3Z9FyFrfQU7vpfbwP1XVJlmH97p45jyWOShNC2px6jdUiIbWVg/NruOtPbBp69h
         nSHRuUqQECGs/7HI/GUU/p6XtnKSq/olULN2q0qnhexT1zeluQ8lrOmmnKlxEORWpM8u
         v74A==
X-Gm-Message-State: AOAM531FSIUhTN4X8J9ZuHOP1X6GvaxwouuRNzbbEF6CLZuwE8DZRMka
        ErZaKTSu0FGuGOn3cfSR+MU0qRhpkT/tahBAL6/+j7px6rk=
X-Google-Smtp-Source: ABdhPJwyNI3sy6O8Wn2hSJoJAXJC4jfLTUrVAJcHKSybBVNpyLDa99+OJKGXHBeSXCdTtk6f8Z0OaR2bL57FTj5hywU=
X-Received: by 2002:a05:6830:2816:: with SMTP id w22mr2990521otu.351.1632969445217;
 Wed, 29 Sep 2021 19:37:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAHP4M8V=tpLaUYidAJLi8U+p-VvKrK2qR97pebqec29r60jrFg@mail.gmail.com>
 <CAHP4M8XoFjNqp=0u9D-OLNATRQo+JD8Ri5kZf0DNzqC_BKue4g@mail.gmail.com>
In-Reply-To: <CAHP4M8XoFjNqp=0u9D-OLNATRQo+JD8Ri5kZf0DNzqC_BKue4g@mail.gmail.com>
From:   Ajay Garg <ajaygargnsit@gmail.com>
Date:   Thu, 30 Sep 2021 08:07:13 +0530
Message-ID: <CAHP4M8Wa8UtY4BWc4cknzutOF6HUcJx-6Hv5s7Zrf7oKE+D7yA@mail.gmail.com>
Subject: Re: Generically, how to see a host-pci-device on guest?
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi everyone.

I got it working, now I am learning/reading how things fit/work :)

For other newbies's benefit, here is what was required :

a)
On the host machine, ensured that virtualization is supported via
hardware/CPU/chipset.

b)
If a) is applicable, then, on the host machine, enabled IOMMU in the
kernel (via kernel command-line argument intel_iommu=on), and then
booted the host machine with this kernel.

c)
Then, attached a pci-device on to a KVM guest machine.

d)
After the guest machine finished booting, *lspci* showed the device
both on the host, as well as the guest.



Thanks and Regards,
Ajay


On Tue, Sep 28, 2021 at 8:24 PM Ajay Garg <ajaygargnsit@gmail.com> wrote:
>
> Hi All.
>
> I made some progress, but still pci-passthrough is not enabled.
>
>
> Following are the bullet-points :
>
> a)
> On host, /proc/cpuinfo shows the following :
>
> ########################################
> ajay@ajay-Latitude-E6320:~$ cat /proc/cpuinfo | grep vmx | wc -l
> 4
> ########################################
>
>
> b)
> On guest, /proc/cpuinfo shows the following :
>
> ########################################
> ajay@ajay-Standard-PC-i440FX-PIIX-1996:~$ cat /proc/cpuinfo | grep vmx | wc -l
> 0
> ########################################
>
>
>
> c)
> Guest has been booted with intel_iommu on, as confirmed by the following logs :
>
> ########################################
> Sep 28 20:05:46 ajay-Standard-PC-i440FX-PIIX-1996 kernel: [
> 0.025210] Kernel command line:
> BOOT_IMAGE=/boot/vmlinuz-5.11.0-37-generic
> root=UUID=a32e7e30-7796-464b-9efc-720eb4fc7706 ro quiet splash
> intel_iommu=on vt.handoff=7
> Sep 28 20:05:46 ajay-Standard-PC-i440FX-PIIX-1996 kernel: [
> 0.025301] DMAR: IOMMU enabled
> ########################################
>
>
> Note that just one DMAR log is seen.
>
>
> d)
> On guest, following are the outputs, when trying to observe virtual
> iommu devices/groups etc :
>
> ########################################
> ajay@ajay-Standard-PC-i440FX-PIIX-1996:~$ ls -lrth /sys/kernel/iommu_groups/
> total 0
>
> ajay@ajay-Standard-PC-i440FX-PIIX-1996:~$ ls -lrth /sys/devices/virtual/iommu
> ls: cannot access '/sys/devices/virtual/iommu': No such file or directory
> ########################################
>
>
> What am I missing?
>
>
>
>
> On Tue, Sep 28, 2021 at 1:03 PM Ajay Garg <ajaygargnsit@gmail.com> wrote:
> >
> > Hi All.
> >
> > I have the following set up:
> >
> > * Host : Ubuntu-16, on a amd64 hardware
> > * Guest : Ubuntu-21, as a VM on QEMU/KVM.
> >
> >
> > Now, I have a SD-MMC card-reader attached physically on the host,
> > which is listed as expected if I do lspci on the host :
> >
> > ############################################
> > ajay@ajay-Latitude-E6320:~/ldd3$ lspci
> > ....
> > ....
> > 0a:00.0 SD Host controller: O2 Micro, Inc. OZ600FJ0/OZ900FJ0/OZ600FJS
> > SD/MMC Card Reader Controller (rev 05)
> > ....
> > ############################################
> >
> >
> > However, if I try doing lspci on the guest, this pci-device is not listed.
> >
> >
> >
> >
> > So, I have the following queries :
> >
> > * Would it require enabling pci-passthrough (if not already) in the
> > guest-kernel, on a global basis?
> > * Does having raw-physical-access on the guest, require support from
> > the pci-device itself?
> >
> >
> > My ultimate aim is to get the sd-mmc-driver that I wrote for the
> > host-machine, to run unmodified on the guest-machine (obviously after
> > the sd-card-reader is detected on the guest, and the code recompiled
> > on the guest).
> >
> >
> > Will be grateful for any pointers.
> >
> >
> > Thanks and Regards,
> > Ajay
