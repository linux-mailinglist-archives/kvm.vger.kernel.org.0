Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263A4647532
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 18:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiLHRzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 12:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiLHRzV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 12:55:21 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEFCCAD309;
        Thu,  8 Dec 2022 09:55:19 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 130so1872999pfu.8;
        Thu, 08 Dec 2022 09:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=769zGAVQjOpYFvJq3zzw+OBZfgPTVwsEHxwFpWSlDcc=;
        b=aUYQqO2NLMfN+20mSrVNpfwSVpIeJV8sp5caCoHzflgKw1Jtdk5OCx6Eem1hMJDjcu
         ZCOsR88jGR6+XBCuK1yHvq7nkUjkXz3xfJBFuix4CGmNcGLYRavOr7/w0sEWtuGNianl
         TiN9bGFw/Zm1+RonAgGjdAsUisQJOIc5wawDVPM1fm27/7MXHQfzcwtLXBB7HFUuqKzy
         AD70/0UEj5W78YpeJBwtBQn/3ZXW9W6+VpgogN5NCcYvTh2fFxEONzwQgga3QfeBV+LP
         5FqhLYHAfJGNjb0ieF+wGoEyrsY/XYc7njDO8O9fPF2ZGC/Y2wfBBLNj0LACaSDsvkBQ
         UQOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=769zGAVQjOpYFvJq3zzw+OBZfgPTVwsEHxwFpWSlDcc=;
        b=ugvBer4iZ+EcrV4Vo74t5iLwz2elDbjJxkwz3ftyq0ZINT9k1yGtdJ6mDtc69K0eRH
         pKl319/WeUUj6OhnAHqe0z/fyTDMnPnUK9rvubG863SDMs7s0rtaUwVUaWAT++yTWJAp
         9Mz6fBP3CaYBNBT+u2e5wHvb994cbfG6NoTihVm8+f29CEQGVY4N2ilb0TITzjq209aF
         jvgDdRwL7qmiZvDEVrRSF8M/VUDQc/0t6TeCML30vf+7CQgWMu9yy+zJTnjpwVKBcDQ9
         ZhvXuyNzHCBJLRnNg4zWCdLJ6MvWAZEEpZp5ipjASpu1ClQ5iTdv7m/vPCyJ2n6kKsSV
         6bng==
X-Gm-Message-State: ANoB5plKJmdt7lm3qBvx6PMNGhXqRcM/Rmzvn2B3S5YC++JEjzLa7+Vp
        Dmel+7/M0v5Jcjqpli1O8ebIK1IdxIjcKU1sE4g=
X-Google-Smtp-Source: AA0mqf6y7ePUdWYtmd4f9jxwo0zeqQum1ruXJ7p67/wrOyXeZkzw1j2OYi7BaXVBGLnoUUIpwUG6YaSUgSGtRWScnGo=
X-Received: by 2002:a63:5b64:0:b0:478:ae53:a299 with SMTP id
 l36-20020a635b64000000b00478ae53a299mr17522023pgm.260.1670522119449; Thu, 08
 Dec 2022 09:55:19 -0800 (PST)
MIME-Version: 1.0
References: <CANBBZXPWe56VYJtzXdimEnkFgF+A=G15TXrd8Z5kBcUOGgHeRw@mail.gmail.com>
 <20221208165008.GA1547952@bhelgaas> <20221208102527.33917ff9.alex.williamson@redhat.com>
In-Reply-To: <20221208102527.33917ff9.alex.williamson@redhat.com>
From:   Major Saheb <majosaheb@gmail.com>
Date:   Thu, 8 Dec 2022 23:25:07 +0530
Message-ID: <CANBBZXPBRr6On_3q0Ac0iQtrV5Bs84=GuHNvLz527T3ohHSuCw@mail.gmail.com>
Subject: Re: vfio-pci rejects binding to devices having same pcie vendor id
 and device id
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhenzhong Duan <zhenzhong.duan@gmail.com>, kvm@vger.kernel.org,
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

Thanks Alex ,
That works for me

~$ sudo driverctl --nosave set-override 0000:00:05.0 vfio-pci
~$ sudo driverctl --nosave set-override 0000:00:06.0 vfio-pci
~$ sudo driverctl --nosave set-override 0000:00:07.0 vfio-pci
admin@node-1:~$ sudo nvme list
Node                  SN                   Model
             Namespace Usage                      Format           FW
Rev
--------------------- --------------------
---------------------------------------- ---------
-------------------------- ---------------- --------
/dev/nvme10n1         akqvf2-0_10          QEMU NVMe Ctrl
             1         274.88  GB / 274.88  GB    512   B +  0 B   1.0
/dev/nvme11n1         akqvf2-0_11          QEMU NVMe Ctrl
             1         274.88  GB / 274.88  GB    512   B +  0 B   1.0
/dev/nvme5n1          akqvf2-0_5           QEMU NVMe Ctrl
             1         274.88  GB / 274.88  GB    512   B +  0 B   1.0
/dev/nvme6n1          akqvf2-0_6           QEMU NVMe Ctrl
             1         274.88  GB / 274.88  GB    512   B +  0 B   1.0
/dev/nvme7n1          akqvf2-0_7           QEMU NVMe Ctrl
             1         274.88  GB / 274.88  GB    512   B +  0 B   1.0
/dev/nvme8n1          akqvf2-0_8           QEMU NVMe Ctrl
             1         274.88  GB / 274.88  GB    512   B +  0 B   1.0
/dev/nvme9n1          akqvf2-0_9           QEMU NVMe Ctrl
             1         274.88  GB / 274.88  GB    512   B +  0 B   1.0

I came across you blogspot after I fired the mail
http://vfio.blogspot.com/2015/05/vfio-gpu-how-to-series-part-3-host.html
Some should update https://docs.kernel.org/driver-api/vfio.html in
public interest , If I knew how to do that I would do it,
Thanks again.

On Thu, Dec 8, 2022 at 10:55 PM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Thu, 8 Dec 2022 10:50:08 -0600
> Bjorn Helgaas <helgaas@kernel.org> wrote:
>
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
> Presumably you already wrote this same ID to the dynamic ID table from
> the first device, so yes, it's going to rightfully complain that this
> ID already exists.  The new_id interface has numerous problems, which
> is why we added the driver_override interface, which is used by tools
> like libvirt and driverctl in place of this old interface.
>
> I'd recommend something like:
>
> # driverctl --nosave set-override 0000:00:03.0 vfio-pci
> # driverctl --nosave set-override 0000:00:04.0 vfio-pci
> # driverctl --nosave set-override 0000:00:05.0 vfio-pci
> ...
>
> Or if vfio-pci is generally the preferred driver for these devices, you
> could remove the --nosave option to have them automatically bound at
> boot.  You could also make use of pre-filling the vfio device table
> using vfio-pci.ids=1b36:0010 on the kernel command line and making sure
> the vfio-pci driver is loaded before the nvme driver.  In general, for
> dynamic binding of devices, driver_override is the recommended solution.
> Thanks,
>
> Alex
>
