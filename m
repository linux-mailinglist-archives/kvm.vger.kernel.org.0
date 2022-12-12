Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F49B64986F
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 05:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiLLEom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Dec 2022 23:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiLLEok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Dec 2022 23:44:40 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C96A64E9;
        Sun, 11 Dec 2022 20:44:39 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id gt4so9064452pjb.1;
        Sun, 11 Dec 2022 20:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iFw+MOtsT8E8Ps+nXfhU3Y9/OqTr3f1kbtW7LiAC5uc=;
        b=f9jWZPUryKLffdlqrTdWZZBE0KScl7DpfNTmIVnuTm0cWm3PYGutB4cLXXHfSsFvx3
         xsKPAVr4YSfUI5WWPRVgUUbm4ja07wRenk99hJy8Zy5wWVS5zNrOj+Y57mysLagH+gbg
         b2IgPfXD0j4oEk+4JHCcWI0HWcrtztyiMT8VytxzUA140iBA4nsqhLSnc0vvfOWhJgNi
         UWPgmg6ekCpgWS7Jh2Ly9kRkhMnJWf8DfZj6dWfYR5J6WhpDW+fPTiahGKKG0C/oZJCG
         qLtl8z9UHH9zQn4xPT8KMx2LDlRpDso/JbxXDMPYAEWhbCLK3Yt0guHQi2IlImxVbw0k
         cs7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iFw+MOtsT8E8Ps+nXfhU3Y9/OqTr3f1kbtW7LiAC5uc=;
        b=Ac+hyvJKpdGj6QEIYMrnDJrVIs6M6UHa3/O3891zioKfaQFM+jqaEPrWB5kQWbUrZ2
         NuySiWk4Dq+VGmGGZZm8tT55MWNvSA1M9vEHTpjbd2T1CTeCISp83ddyMF27JZ1sU7Pq
         rpubKvjfO1rczvzUC6gmfOyEqzgrsjcE0zEk/7sAa1YKnlZ7MfyC7P6W0A7FYwB5fM1R
         QFwCzGWZD2XdRavMput9jb20GnaFLNsU8wSFDpff6fQUC9JZf976VQtoljH3NkxRhJXf
         L1hfJuVzZnB/9k14JNP7CLYZr2fEYoKtwYriopulBeJxKaq5/3jLztscwfv0FeTsKNqG
         jRvw==
X-Gm-Message-State: ANoB5pkYTmq2BZQtUWMZPOzyqI3tUNPeQcaYDFLjXDOHzYdAvlJJ+Ngg
        1E4K7jFvSMYB0OtrJXqdX9/srtDV0UyQd1soLh7+CQG1uxo9P0A0fyM=
X-Google-Smtp-Source: AA0mqf4kdKpcqjDNNYZcV99X/nYIw3t4w571tyJCsVLMXDVQDQpya/UgL7tB59yTd000S5Oq1+dLpH6tozjZgVhU6xI=
X-Received: by 2002:a17:90a:f104:b0:218:bd1d:37ad with SMTP id
 cc4-20020a17090af10400b00218bd1d37admr85880276pjb.39.1670820279078; Sun, 11
 Dec 2022 20:44:39 -0800 (PST)
MIME-Version: 1.0
References: <CANBBZXPWe56VYJtzXdimEnkFgF+A=G15TXrd8Z5kBcUOGgHeRw@mail.gmail.com>
 <20221208165008.GA1547952@bhelgaas>
In-Reply-To: <20221208165008.GA1547952@bhelgaas>
From:   Zhenzhong Duan <zhenzhong.duan@gmail.com>
Date:   Mon, 12 Dec 2022 12:44:28 +0800
Message-ID: <CAFH1YnOs9B0KecpaS36D1apwydHmg8ca3vHqTJk0xTw=vrLcSA@mail.gmail.com>
Subject: Re: vfio-pci rejects binding to devices having same pcie vendor id
 and device id
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Major Saheb <majosaheb@gmail.com>,
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

On Fri, Dec 9, 2022 at 12:50 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> [+cc VFIO folks and Zhenzhong (author of the commit you mention)]
>
> On Thu, Dec 08, 2022 at 09:24:31PM +0530, Major Saheb wrote:
> > I have a linux system running in kvm, with 6 qemu emulated NVMe
> > drives, as expected all of them have the same PCIe Vendor ID and
> > Device ID(VID: 0x1b36 DID: 0x0010).
> >
> > When I try to unbind them from the kernel NVMe driver and bind it to
> > vfio-pci one by one, I am getting "write error: File exists" when I
> > try to bind the 2nd(and other) drive to vfio-pci.
> >
> > Kernel version
> >
> > 5.15.0-56-generic #62-Ubuntu SMP Tue Nov 22 19:54:14 UTC 2022 x86_64
> > x86_64 x86_64 GNU/Linux
> >
> > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme0n1 -> ../devices/pci0000:00/0000:00:03.0/nvme/nvme0/nvme0n1
> > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme1n1 -> ../devices/pci0000:00/0000:00:04.0/nvme/nvme1/nvme1n1
> > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme2n1 -> ../devices/pci0000:00/0000:00:05.0/nvme/nvme2/nvme2n1
> > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme3n1 -> ../devices/pci0000:00/0000:00:06.0/nvme/nvme3/nvme3n1
> > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme4n1 -> ../devices/pci0000:00/0000:00:07.0/nvme/nvme4/nvme4n1
> > lrwxrwxrwx 1 root root 0 Dec  8 11:32 /sys/block/nvme5n1 -> ../devices/pci0000:00/0000:00:08.0/nvme/nvme5/nvme5n1
> >
> > Steps for repro
> > ubind nvme2 from kernel NVMe driver and bind it to vfio
> > $ ls -l /sys/bus/pci/drivers/vfio-pci/
> > lrwxrwxrwx 1 root root    0 Dec  8 13:04 0000:00:05.0 -> ../../../../devices/pci0000:00/0000:00:05.0
> > --w------- 1 root root 4096 Dec  8 13:07 bind
> > lrwxrwxrwx 1 root root    0 Dec  8 13:07 module -> ../../../../module/vfio_pci
> > --w------- 1 root root 4096 Dec  8 13:04 new_id
> > --w------- 1 root root 4096 Dec  8 13:07 remove_id
> > --w------- 1 root root 4096 Dec  8 11:32 uevent
> > --w------- 1 root root 4096 Dec  8 13:07 unbind
> >
> > Unbind nvme3 from  kernel NVMe driver
> > Try binding to vfio-pci
> > # echo "0x1b36  0x0010" >  /sys/bus/pci/drivers/vfio-pci/new_id
> > -bash: echo: write error: File exists

Above operation added new id to vfio-pci, it will trigger scanning of
unbind devices once by default.
To bind other devices of same id, besides what Alex suggested, I think you can
also use /sys/bus/pci/drivers/vfio-pci/bind interface.

Thanks
Zhenzhong

> >
> > Not sure but this seems interesting
> > https://github.com/torvalds/linux/commit/3853f9123c185eb4018f5ccd3cdda5968efb5e10#diff-625d2827bff96bb3a019fa705d99f0b89ec32f281c38a844457b3413d9172007
> >
> > Can some help ?
