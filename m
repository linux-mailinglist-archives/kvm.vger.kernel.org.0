Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0453649B1D
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 10:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiLLJ1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 04:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiLLJ1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 04:27:06 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE962DE7;
        Mon, 12 Dec 2022 01:27:02 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id f13-20020a1cc90d000000b003d08c4cf679so4548723wmb.5;
        Mon, 12 Dec 2022 01:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hYeFLqG4pHv8y/20FrGwxB4161wxtR+/j0ajQK4rwC4=;
        b=WBHXRgQQGVGKje6yT/RHEB/8XZ1CqsSFoECA+ylZcDDrMG/V5aNrJHW2uMZ1ce07fk
         sXMS5+U24WcexDYmpdtNNxaV8XDMW1OKNwVlJD5FioJVRMeYnsQ3dRHsP90FjkaIenUa
         8zUdVYpfEoUM/0bVJkk4i1+RTpuU/4+/xhX8+O3S6p4KfvqU0haPfeH4vcZZtDt5l1Sl
         8rORQWADxyAdhAJiv7/jWgrlmlnL30imcYIrd4Yoj5xrhd5dasse9m0uNLrs6kPqgddp
         /DnDbBjwM670mrydTCwDaWgFhvDLp6F+HPE30vmLeMCirJBhqBRADR//Y4dbLR6lHKjo
         zgww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hYeFLqG4pHv8y/20FrGwxB4161wxtR+/j0ajQK4rwC4=;
        b=xP0YtfGz/hGwhYtMpNkFi/nJNF9Wr7IQlPoCUlgWaAVSrOOgPoIkEPLogtf8eZiXjs
         LfcfSo+JOkHwEpJOviAlbaA3xHYpJ2c75K77OamQUMusbQMjJXqcGG7aJnewhaop1Opj
         zLdBCwNt9LPQXR8cs9T/QwlIczmWeYdR4pODF/eVtO7G8ypPguXZo/r4Qhkh8qI8bqOH
         T9tLIdwFJ6kEG/N7zLotl3P+4DjbcUaIA06LGkNYqRe4ejE3Cv04bI3VKzk3DG/y8qAo
         ylbus5hrhCQQFHoOPeTNqMhSZwGxIVNX7e2ehpVzHbOyQtqgv8Cept807AD7dLO9Hc+4
         yoXQ==
X-Gm-Message-State: ANoB5pkQ6SWoh1P1i9EQcZbIuLZn32TWccgmGTbpup8X26n8lsAY5Vq5
        +xxlI+GkwpVmIL7Y/BXKpj7QLBpx0rT+VxzAbWmWADoU
X-Google-Smtp-Source: AA0mqf7ZqE4uArp0gaEgsOt21mawd2IdZbwzCvh4talM/NK+EgVsnHVTAEKvC+QvXpIU+ZiUCyGC/MlhYCoFnaSVfVI=
X-Received: by 2002:a05:600c:6888:b0:3d0:7513:d149 with SMTP id
 fn8-20020a05600c688800b003d07513d149mr26613941wmb.156.1670837221215; Mon, 12
 Dec 2022 01:27:01 -0800 (PST)
MIME-Version: 1.0
References: <CANBBZXPWe56VYJtzXdimEnkFgF+A=G15TXrd8Z5kBcUOGgHeRw@mail.gmail.com>
 <20221208165008.GA1547952@bhelgaas> <CAFH1YnOs9B0KecpaS36D1apwydHmg8ca3vHqTJk0xTw=vrLcSA@mail.gmail.com>
In-Reply-To: <CAFH1YnOs9B0KecpaS36D1apwydHmg8ca3vHqTJk0xTw=vrLcSA@mail.gmail.com>
From:   Major Saheb <majosaheb@gmail.com>
Date:   Mon, 12 Dec 2022 14:56:49 +0530
Message-ID: <CANBBZXO363zYMTtDtLFgLNV9LxU7B5hMH5qs-=1kQLAv0QQVaA@mail.gmail.com>
Subject: Re: vfio-pci rejects binding to devices having same pcie vendor id
 and device id
To:     Zhenzhong Duan <zhenzhong.duan@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ok, thanks.

On Mon, Dec 12, 2022 at 10:14 AM Zhenzhong Duan
<zhenzhong.duan@gmail.com> wrote:
>
> On Fri, Dec 9, 2022 at 12:50 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> >
> > [+cc VFIO folks and Zhenzhong (author of the commit you mention)]
> >
> > On Thu, Dec 08, 2022 at 09:24:31PM +0530, Major Saheb wrote:
> > > I have a linux system running in kvm, with 6 qemu emulated NVMe
> > > drives, as expected all of them have the same PCIe Vendor ID and
> > > Device ID(VID: 0x1b36 DID: 0x0010).
> > >
> > > When I try to unbind them from the kernel NVMe driver and bind it to
> > > vfio-pci one by one, I am getting "write error: File exists" when I
> > > try to bind the 2nd(and other) drive to vfio-pci.
> > >
> > > Kernel version
> > >
> > > 5.15.0-56-generic #62-Ubuntu SMP Tue Nov 22 19:54:14 UTC 2022 x86_64
> > > x86_64 x86_64 GNU/Linux
> > >
> > > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme0n1 -> ../devices/pci0000:00/0000:00:03.0/nvme/nvme0/nvme0n1
> > > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme1n1 -> ../devices/pci0000:00/0000:00:04.0/nvme/nvme1/nvme1n1
> > > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme2n1 -> ../devices/pci0000:00/0000:00:05.0/nvme/nvme2/nvme2n1
> > > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme3n1 -> ../devices/pci0000:00/0000:00:06.0/nvme/nvme3/nvme3n1
> > > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme4n1 -> ../devices/pci0000:00/0000:00:07.0/nvme/nvme4/nvme4n1
> > > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme5n1 -> ../devices/pci0000:00/0000:00:08.0/nvme/nvme5/nvme5n1
> > >
> > > Steps for repro
> > > ubind nvme2 from kernel NVMe driver and bind it to vfio
> > > $ ls -l /sys/bus/pci/drivers/vfio-pci/
> > > lrwxrwxrwx 1 root root    0 Dec  8 13:04 0000:00:05.0 -> ../../../../devices/pci0000:00/0000:00:05.0
> > > --w------- 1 root root 4096 Dec  8 13:07 bind
> > > lrwxrwxrwx 1 root root    0 Dec  8 13:07 module -> ../../../../module/vfio_pci
> > > --w------- 1 root root 4096 Dec  8 13:04 new_id
> > > --w------- 1 root root 4096 Dec  8 13:07 remove_id
> > > --w------- 1 root root 4096 Dec  8 11:32 uevent
> > > --w------- 1 root root 4096 Dec  8 13:07 unbind
> > >
> > > Unbind nvme3 from  kernel NVMe driver
> > > Try binding to vfio-pci
> > > # echo "0x1b36  0x0010" >  /sys/bus/pci/drivers/vfio-pci/new_id
> > > -bash: echo: write error: File exists
>
> Above operation added new id to vfio-pci, it will trigger scanning of
> unbind devices once by default.
> To bind other devices of same id, besides what Alex suggested, I think you can
> also use /sys/bus/pci/drivers/vfio-pci/bind interface.
>
> Thanks
> Zhenzhong
>
> > >
> > > Not sure but this seems interesting
> > > https://github.com/torvalds/linux/commit/3853f9123c185eb4018f5ccd3cdda5968efb5e10#diff-625d2827bff96bb3a019fa705d99f0b89ec32f281c38a844457b3413d9172007
> > >
> > > Can some help ?
