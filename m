Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE57609569
	for <lists+kvm@lfdr.de>; Sun, 23 Oct 2022 20:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiJWSO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Oct 2022 14:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiJWSO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Oct 2022 14:14:56 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A1F34DDA;
        Sun, 23 Oct 2022 11:14:51 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id c3-20020a1c3503000000b003bd21e3dd7aso8573271wma.1;
        Sun, 23 Oct 2022 11:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wAEKWPZJlrfpEZ9/vlN9/0riKPaUQS9d2i2iQCHtGrs=;
        b=oGj3vCIqKxYUSyGgfQIy0qqJoLvOGIYBaCtm2nG7AbK6H84nW0R1PMrKKsWP4wStHe
         H2JKr93RGfynWLzhnjTN4QB3iBFZFrzUgCRTZGsYSUEP//C9pTcY0iFiTlL1QP26Xl2e
         k6U89yKlegoM2mfNoRvVxgHATfTUkd0GwC6W6hhZabVPeDJQ9n1q8W24rDu2baxUUHHe
         rAQ6Tos5ReKCLo5M106/nXkUZ11Xv6q3auhKQmLrLhN3SeHrMbofYv1Zj+HvkSFQFqj5
         gLMBsZ/AH3prgaVO9BezJWarnONhJi7DGFbLCrCS7PYYcTuh6fDAJ9QDqlLbXbYlf7H1
         pm5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wAEKWPZJlrfpEZ9/vlN9/0riKPaUQS9d2i2iQCHtGrs=;
        b=j1Dmv/AyZOV5Hh+ce5/AjcRX8U0H9X83DMbg+4nqoUIf2fX/Nzs89vy13kVl7NkTyr
         bYrdhidRc5DqJ+teQlXyQ3zACXmgHUEv56AvMX8wYfMxYAqk501SOWbhLLXI4anxdSgW
         zrCHr4ifRSJdtm09HQYrrMU/gBuP8CzjNNm1OL8XUiqyWS40F6EBc57Q82ZbpcCq2/vz
         BAmYV1Rqj2q3GFDsN1gKT1RPRMwtmkF+0JMtEr9lkp3xLOWjGq8E+uV4WNaNQDTZLQZR
         cn+NkYGL3lC+9D5VyMf6z1b4xba2Ax+nq5+snqXyp3WwJE3eVCVLeG4r+xaP/bhFfRIa
         jCBQ==
X-Gm-Message-State: ACrzQf0X7uSJwXdCMwcXZhWurMM2mhvADvx8/s+uCu5Agq4Px5wIyTEZ
        LENSkrpdxXGgvus3Sm4xgZKFZhJR8twYaKwF0NbfqHC6
X-Google-Smtp-Source: AMsMyM5Ffe6y2yTBG1r4UmOxy8f5kKj0k94BQpPomUD7JD6cCR2tb/Gu3OwwSntQ7NKOWOE4amDyflW1VfCXJ7f/Txc=
X-Received: by 2002:a05:600c:502c:b0:3ce:794f:d664 with SMTP id
 n44-20020a05600c502c00b003ce794fd664mr1610329wmr.33.1666548889346; Sun, 23
 Oct 2022 11:14:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAMdYzYrUOoTmBL2c_+=xLBMXg38Pp4hANnzqxoe1cVDDrFvqTA@mail.gmail.com>
 <Y0QnFHqrX2r/7oUz@rowland.harvard.edu> <CAMdYzYodS7Y4bZ+fzzAXMSiCfQHwMkmV8-C=b3FVUXDExavXgA@mail.gmail.com>
 <Y0QzrI92f9BL+91W@rowland.harvard.edu> <CAMdYzYpdLEKMSytGStvM2Gi+gkBY7GTUHZfoBt5X-2BEzLrfOw@mail.gmail.com>
 <Y0cuHHWL3r7+mpcq@rowland.harvard.edu> <CAMdYzYockLYigqgX+R28a_Xy=wGExGj-MXL79Jrc7Jv7B6Qh3w@mail.gmail.com>
 <Y0tfXv2U7Izx5boj@rowland.harvard.edu>
In-Reply-To: <Y0tfXv2U7Izx5boj@rowland.harvard.edu>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Sun, 23 Oct 2022 14:14:37 -0400
Message-ID: <CAMdYzYqDMFT2a499RDnuqak75Y4fD=ktcoCOu=8wfKbeecQhaA@mail.gmail.com>
Subject: Re: [BUG] KVM USB passthrough did not claim interface before use
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     kvm@vger.kernel.org, linux-usb@vger.kernel.org
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

On Sat, Oct 15, 2022 at 9:33 PM Alan Stern <stern@rowland.harvard.edu> wrote:
>
> On Sat, Oct 15, 2022 at 08:36:19PM -0400, Peter Geis wrote:
> > On Wed, Oct 12, 2022 at 5:14 PM Alan Stern <stern@rowland.harvard.edu> wrote:
> > >
> > > There's one other thing you might try, although I'm not sure that it
> > > will provide any useful new information.  Instead of collecting a
> > > usbmon trace, collect a usbfs snoop log.  Before starting qemu, do:
> > >
> > >         echo 1 >/sys/module/usbcore/parameters/usbfs_snoop
> > >
> > > This will cause the accesses performed via usbfs, including those
> > > performed by the qemu process, to be printed in the kernel log.  (Not
> > > all of the accesses, but the more important ones.)  Let's see what shows
> > > up.
> >
> > So I built and tested the newest version of QEMU, and it exhibits the
> > same issue. I've also captured the log as requested and attached it
> > here.
>
> Here's what appears to be the relevant parts of the log.
>
> > [93190.933026] usb 3-6.2: opened by process 149607: rpc-libvirtd
> > [93191.006429] usb 3-6.2: opened by process 149605: qemu-system-x86
>
> The device is opened by proces 194605, which is probably the main qemu
> process (or the main one in charge of USB I/O).  I assume this is the
> process which goes ahead with initialization and enumeration, because
> there are no indications of other processes opening the device.
>
> > [93195.712484] usb 3-6.2: usbdev_do_ioctl: RESET
> > [93195.892482] usb 3-6.2: reset full-speed USB device number 70 using xhci_hcd
> > [93196.095050] cdc_acm 3-6.2:1.0: ttyACM0: USB ACM device
>
> As part of initialization, qemu resets the device and its interfaces
> then get claimed by the cdc_acm driver on the host.  This may be the
> problem; there's no indication in the log that cdc_acm ever releases
> those interfaces.
>
> > [93196.482584] usb 3-6.2: usbdev_do_ioctl: SUBMITURB
> > [93196.482589] usb 3-6.2: usbfs: process 149617 (CPU 3/KVM) did not claim interface 0 before use
> > [93209.729484] usb 3-6.2: usbdev_do_ioctl: SUBMITURB
> > [93209.729489] usb 3-6.2: usbfs: process 149616 (CPU 2/KVM) did not claim interface 0 before use
> > [93209.729574] usb 3-6.2: usbdev_do_ioctl: CLEAR_HALT
> > [93209.729577] usb 3-6.2: usbfs: process 149617 (CPU 3/KVM) did not claim interface 1 before use
> > [93209.729632] usb 3-6.2: usbdev_do_ioctl: SUBMITURB
> > [93209.729635] usb 3-6.2: usbfs: process 149614 (CPU 0/KVM) did not claim interface 0 before use
>
> Unforunately these warning messages don't indicate directly whether
> the attempts to use the interfaces were successful.  But it's clear
> that something went wrong with those URB submissions because the snoop
> log doesn't include the contents of the URBs or their results.
>
> My guess is that the attempts failed because the interfaces were
> already claimed by cdc_acm in the host.  I would expect qemu to unbind
> cdc_acm when it starts up, but apparently it doesn't.  And there are
> no CLAIM_PORT messages in the log.
>
> Perhaps it will help if you do the unbind by hand before starting
> qemu.  Try doing:
>
>         echo 3-6.2:1.0 >/sys/bus/usb/drivers/cdc_acm/unbind
>         echo 3-6.2:1.1 >/sys/bus/usb/drivers/cdc_acm/unbind
>
> Or better yet, blacklist the cdc_acm driver on the host if you can.

Good Afternoon,

Thanks, blacklisting cdc_acm stopped usbfs from failing to claim it
again. Unfortunately I ran into another issue, where KVM/QEMU doesn't
claim the USB device again after the device resets. I've encountered
this before with other devices and there doesn't seem to be a way to
resolve it yet. It seems that my issue with this device was a
different manifestation of the same problem, and there currently isn't
a fix for that.

Thank you for your assistance.
Very Respectfully,
Peter

>
> Alan Stern
