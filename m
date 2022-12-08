Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58F16475CA
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 19:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiLHStE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 13:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiLHStA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 13:49:00 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948B08BD15;
        Thu,  8 Dec 2022 10:48:59 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id h33so1875449pgm.9;
        Thu, 08 Dec 2022 10:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=weEZOEnZa0pdtpaJMp87RdmAilln7Cqu31ebVo2xgNk=;
        b=pxoM8Y0EeyyGqEukVegcbFJYlyBqqzZp2AuYYzAewbIj/3QH1ynhAqG7gDtgZP5SRR
         JmOqlR55lWyDb2Ygjp/iYvEDaZ9l0l8tNjMlWFgqvXSEi8ZBZbv/twfmxThHRKWffpzV
         qlBGx2/fR3u72h4d51TG2dT2BIUtsCTMxpZUsqskhDGg1oiJb6vtS+sTDe5rpP9xJVke
         xlHMOBSSplkyq5y2GTShXVxCgZHeYc11JpbIAZOZpAUIY/3yw0Dw2LX01cDCFMrFtANw
         N2Fu99eJ1ErO3/kw4Hq3x59SxG67Q4w6UekPH+hdsDoNe4vPcoWFqWBcx083iO+VajsC
         d42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=weEZOEnZa0pdtpaJMp87RdmAilln7Cqu31ebVo2xgNk=;
        b=3M3iyDGUBWjr5MqIcUP4VMyBC6McKA8TXM9ytuw8+Fj82aronCG27ixqeHWqdiyit5
         kAkQ6dyrKsW7qQWy1/0BrWQF5NMB64O0/Fe5YG/cwpytrO39HbMZSyQ0dDv3qWQ4bHAS
         w4CsLI93pMn33Qmc7lfjUvRuopy81R18qecLVVpioj5+KszWhPvV1ZCEwGyuYNrH4069
         3YjNO3MHp+V0iDSZwm/ZLUputsox/m1Wp/a8p4/K/AhUqXf3eCnT07TUC6+cXtRXAV2W
         Lhael+g2/hWILY/y+J518iI+SSrn0ZGVNEPuLkNrn3f1+Xfu27jc8gOMniL0BExisaid
         6S5A==
X-Gm-Message-State: ANoB5pkJMdR7XGUrTEPnHRRort7Y0DOiiae5swMp4OEs4U57iNz8YubQ
        psc137n/j3eZlAkgb1a51Uy5OqrFdL2NvSyWdj8=
X-Google-Smtp-Source: AA0mqf7YsKCYXQfcFSpcyTBM0eDMDVY+aTSsVSAUeUxBWThPcQ3A4H+jN0RQkvzTX7fIRQcxQ2uUTeGOaBi2yDq3+VM=
X-Received: by 2002:a63:5b64:0:b0:478:ae53:a299 with SMTP id
 l36-20020a635b64000000b00478ae53a299mr17576140pgm.260.1670525339058; Thu, 08
 Dec 2022 10:48:59 -0800 (PST)
MIME-Version: 1.0
References: <CANBBZXPWe56VYJtzXdimEnkFgF+A=G15TXrd8Z5kBcUOGgHeRw@mail.gmail.com>
 <20221208165008.GA1547952@bhelgaas> <20221208102527.33917ff9.alex.williamson@redhat.com>
 <CANBBZXPBRr6On_3q0Ac0iQtrV5Bs84=GuHNvLz527T3ohHSuCw@mail.gmail.com> <20221208112133.36efe5ff.alex.williamson@redhat.com>
In-Reply-To: <20221208112133.36efe5ff.alex.williamson@redhat.com>
From:   Major Saheb <majosaheb@gmail.com>
Date:   Fri, 9 Dec 2022 00:18:46 +0530
Message-ID: <CANBBZXPCvY_ePdOA02NcTc2omM0oEBB5=KWv5LFVD-tWvtE0WA@mail.gmail.com>
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

Sure , I will read the process and try to submit the patch.
Thanks.

On Thu, Dec 8, 2022 at 11:51 PM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Thu, 8 Dec 2022 23:25:07 +0530
> Major Saheb <majosaheb@gmail.com> wrote:
>
> > Thanks Alex ,
> > That works for me
> >
> > ~$ sudo driverctl --nosave set-override 0000:00:05.0 vfio-pci
> > ~$ sudo driverctl --nosave set-override 0000:00:06.0 vfio-pci
> > ~$ sudo driverctl --nosave set-override 0000:00:07.0 vfio-pci
> > admin@node-1:~$ sudo nvme list
> > Node                  SN                   Model
> >              Namespace Usage                      Format           FW
> > Rev
> > --------------------- --------------------
> > ---------------------------------------- ---------
> > -------------------------- ---------------- --------
> > /dev/nvme10n1         akqvf2-0_10          QEMU NVMe Ctrl
> >              1         274.88  GB / 274.88  GB    512   B +  0 B   1.0
> > /dev/nvme11n1         akqvf2-0_11          QEMU NVMe Ctrl
> >              1         274.88  GB / 274.88  GB    512   B +  0 B   1.0
> > /dev/nvme5n1          akqvf2-0_5           QEMU NVMe Ctrl
> >              1         274.88  GB / 274.88  GB    512   B +  0 B   1.0
> > /dev/nvme6n1          akqvf2-0_6           QEMU NVMe Ctrl
> >              1         274.88  GB / 274.88  GB    512   B +  0 B   1.0
> > /dev/nvme7n1          akqvf2-0_7           QEMU NVMe Ctrl
> >              1         274.88  GB / 274.88  GB    512   B +  0 B   1.0
> > /dev/nvme8n1          akqvf2-0_8           QEMU NVMe Ctrl
> >              1         274.88  GB / 274.88  GB    512   B +  0 B   1.0
> > /dev/nvme9n1          akqvf2-0_9           QEMU NVMe Ctrl
> >              1         274.88  GB / 274.88  GB    512   B +  0 B   1.0
> >
> > I came across you blogspot after I fired the mail
> > http://vfio.blogspot.com/2015/05/vfio-gpu-how-to-series-part-3-host.html
> > Some should update https://docs.kernel.org/driver-api/vfio.html in
> > public interest , If I knew how to do that I would do it,
>
> Yes, that documentation is from before the driver_override method was
> introduced.  There's some non vfio specific documentation of
> driver_override here:
>
> https://docs.kernel.org/admin-guide/abi-testing.html?highlight=driver_override#abi-sys-bus-pci-devices-driver-override
>
> Otherwise, documentation updates gladly accepted.  This documentation
> is part of the kernel source tree and follows the same process as
> submitting code changes, outlined here:
>
> https://docs.kernel.org/process/submitting-patches.html
>
> The kvm@vger.kernel.org mailing list handles patches for vfio, but
> please keep me in Cc if you submit something.  Thanks,
>
> Alex
>
