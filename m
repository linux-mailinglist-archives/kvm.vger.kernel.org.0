Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC7441B26B
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 16:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241295AbhI1O4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 10:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241279AbhI1O4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 10:56:05 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A833C061745
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 07:54:25 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id a3so30277053oid.6
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 07:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=Kb0csDlehFtzIo9tqP4aUU1QB/FyDohsCjmEHmhqvTo=;
        b=PKkdtyUkiUDRbtKRymJwv5mYZFw8qBhAuci3FDH33ARvLdcVLFcR7fE6kYMLyqO5Au
         29RMfbc11wNwAyFG45IGLiLerWp9wNA7Ah+qeTjUPTMAGXcnl/LHa8V/CXd9e3CK7Bkt
         potccmQHON/ZoiiypcQhdSUWZS9jfJfRsImBmejUOeCOKahjp3aKqtWFyssXD99kfo+a
         v1zHiaomzTwq2p3MTuP2JO9kftGXeAF6ICNF4izZvqiP15a1xDr0TUASZE+INmj59QJ9
         U2CtHVqntn9epqd0eYBu6ToH0xOmmqE1MyRMItLW55RF0HvYkz/qnn473Gsh91v/f9yV
         Pbyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=Kb0csDlehFtzIo9tqP4aUU1QB/FyDohsCjmEHmhqvTo=;
        b=uyfgtistT19j973G5uS4njiS/eW/wozg1wyyduyoVaKWLBObgt4e63j0laOcmE3NI0
         wVbG3ojVKATPKNorZ/AXJ9LG7F40nCh04wXUzblm85+cSn0uMCLj85Zrd/fwZImDO6FG
         JiLClqk+GVL6OT4gJZFvfSzbfCymhM0DrD3YXHt0TGMNzI0MJ4dLHIU0r14R/6Ui6HDC
         NpjiZ0QffOnIPd8ELnLZp0ss1rtOUs9dO6kKk7rRqr65fmAxvTFM1Up52YtRzuziOBcf
         vn2ilLQxGftxzOhiTC7MiXYLI5zcuc79d5t9nF5UDn/adxz7Nyat+9OTN59ZAlges9+l
         +pMQ==
X-Gm-Message-State: AOAM530+o7Zq7npXSk3eSxE4hdvpONSAVHrVqTizT952vSI6E62xIb51
        xfOycM1y0ewMESnigehWLrmxUwhHVvMIH3SIjmNFjvZl133XRg==
X-Google-Smtp-Source: ABdhPJxclr+G1X+K6u9L7E7MoMxgz/p846u/x+qCCw/z+dq5O0vSVACHC7Q/+lx2RJYkDUC3ZANZa/rxK6sr2RCyHZM=
X-Received: by 2002:a05:6808:1912:: with SMTP id bf18mr3926222oib.118.1632840864050;
 Tue, 28 Sep 2021 07:54:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAHP4M8V=tpLaUYidAJLi8U+p-VvKrK2qR97pebqec29r60jrFg@mail.gmail.com>
In-Reply-To: <CAHP4M8V=tpLaUYidAJLi8U+p-VvKrK2qR97pebqec29r60jrFg@mail.gmail.com>
From:   Ajay Garg <ajaygargnsit@gmail.com>
Date:   Tue, 28 Sep 2021 20:24:11 +0530
Message-ID: <CAHP4M8XoFjNqp=0u9D-OLNATRQo+JD8Ri5kZf0DNzqC_BKue4g@mail.gmail.com>
Subject: Re: Generically, how to see a host-pci-device on guest?
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All.

I made some progress, but still pci-passthrough is not enabled.


Following are the bullet-points :

a)
On host, /proc/cpuinfo shows the following :

########################################
ajay@ajay-Latitude-E6320:~$ cat /proc/cpuinfo | grep vmx | wc -l
4
########################################


b)
On guest, /proc/cpuinfo shows the following :

########################################
ajay@ajay-Standard-PC-i440FX-PIIX-1996:~$ cat /proc/cpuinfo | grep vmx | wc -l
0
########################################



c)
Guest has been booted with intel_iommu on, as confirmed by the following logs :

########################################
Sep 28 20:05:46 ajay-Standard-PC-i440FX-PIIX-1996 kernel: [
0.025210] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-5.11.0-37-generic
root=UUID=a32e7e30-7796-464b-9efc-720eb4fc7706 ro quiet splash
intel_iommu=on vt.handoff=7
Sep 28 20:05:46 ajay-Standard-PC-i440FX-PIIX-1996 kernel: [
0.025301] DMAR: IOMMU enabled
########################################


Note that just one DMAR log is seen.


d)
On guest, following are the outputs, when trying to observe virtual
iommu devices/groups etc :

########################################
ajay@ajay-Standard-PC-i440FX-PIIX-1996:~$ ls -lrth /sys/kernel/iommu_groups/
total 0

ajay@ajay-Standard-PC-i440FX-PIIX-1996:~$ ls -lrth /sys/devices/virtual/iommu
ls: cannot access '/sys/devices/virtual/iommu': No such file or directory
########################################


What am I missing?




On Tue, Sep 28, 2021 at 1:03 PM Ajay Garg <ajaygargnsit@gmail.com> wrote:
>
> Hi All.
>
> I have the following set up:
>
> * Host : Ubuntu-16, on a amd64 hardware
> * Guest : Ubuntu-21, as a VM on QEMU/KVM.
>
>
> Now, I have a SD-MMC card-reader attached physically on the host,
> which is listed as expected if I do lspci on the host :
>
> ############################################
> ajay@ajay-Latitude-E6320:~/ldd3$ lspci
> ....
> ....
> 0a:00.0 SD Host controller: O2 Micro, Inc. OZ600FJ0/OZ900FJ0/OZ600FJS
> SD/MMC Card Reader Controller (rev 05)
> ....
> ############################################
>
>
> However, if I try doing lspci on the guest, this pci-device is not listed.
>
>
>
>
> So, I have the following queries :
>
> * Would it require enabling pci-passthrough (if not already) in the
> guest-kernel, on a global basis?
> * Does having raw-physical-access on the guest, require support from
> the pci-device itself?
>
>
> My ultimate aim is to get the sd-mmc-driver that I wrote for the
> host-machine, to run unmodified on the guest-machine (obviously after
> the sd-card-reader is detected on the guest, and the code recompiled
> on the guest).
>
>
> Will be grateful for any pointers.
>
>
> Thanks and Regards,
> Ajay
