Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223D25FA01F
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 16:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiJJOXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 10:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJJOXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 10:23:10 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B157E73334;
        Mon, 10 Oct 2022 07:23:08 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id bk15so17252513wrb.13;
        Mon, 10 Oct 2022 07:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TahS+pInlUSQRZ8Rm+e9KVPB/oIUr10xMPSI7jd51lo=;
        b=g/fB6ohtI5z5Ub/Iab9A1xL2IO2ox+7dEIL9uRQwQZWhuw98OuyqT8hOYC4z1DjDoz
         wZbS1TXxBTL5Zl85t3WSkII5NtT7Eq5b5jLOuM4Y2OUDrz2CC4kMgk5a5UAXHlb+uCCl
         QS4/K8ok2iajnUoRcHd6Ad6SG3RBS7Lqsjhsk+DrWEvppwtqTGOL7qiIN1B1TMIigjpd
         bEiPZrO8/h8nzmGSPdsTATrSUzDDJD5vBzXqzMcxmOZ+grvT7aqzRdY2hSP9hir3Owfw
         IpD/EsTSFDZP4LnDxeYrfG4H6faTw6XrLBkIJUy5CKCYJzTk6DVs1Ln7dbEOklzpwVCs
         z1DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TahS+pInlUSQRZ8Rm+e9KVPB/oIUr10xMPSI7jd51lo=;
        b=JYdcIHNUBGFT9wcKzkUEZEdQ2y0KjrTuF8b7sd6ueU8W4vkHtvXc1nd03/CM+T/mHP
         I8J3WxDjPxdNOm8ayrJWwxZk5hxDMOIx10XtMTCiRtOQ28miR1UJhXUL43cUccb74i+1
         MGQIN6hN6PL4QCesMqULoPnWwcu+H/AtexMdMlUqA7/UMyVoI8GMZJid6FFUfWN00i5w
         J8muWJnMImeURepjte5TNR220deWnTdCWXkS9AmolIW7bRsOWkjRtm8mAHJI3mVm1V/0
         +BluHf2fTSTNQbgbe053acBopBYI9wReWHlewVc6zldlvyIeOIr6EEFe4DKgkIM+iUWS
         G1YQ==
X-Gm-Message-State: ACrzQf3lS8xrPXz98j8dF3J6zcV3pYiSkLa3HGSAjbJ6FW1AlI0Pr5sc
        qB+MtGRGGC3k4jDmdu0QZHUf1eog8NB4yDozK/X+GpoL
X-Google-Smtp-Source: AMsMyM7+XyzfWxUOKvsoWLI8TNFb4gbgScfxqcUjkOer7pGXREtwJmb6W0h27PdSj2zVq1ZUlsNNWkhSvJJmpBljuDM=
X-Received: by 2002:a05:6000:1562:b0:231:1b02:3dbb with SMTP id
 2-20020a056000156200b002311b023dbbmr987314wrz.685.1665411787059; Mon, 10 Oct
 2022 07:23:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAMdYzYrUOoTmBL2c_+=xLBMXg38Pp4hANnzqxoe1cVDDrFvqTA@mail.gmail.com>
 <Y0QnFHqrX2r/7oUz@rowland.harvard.edu>
In-Reply-To: <Y0QnFHqrX2r/7oUz@rowland.harvard.edu>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Mon, 10 Oct 2022 10:22:55 -0400
Message-ID: <CAMdYzYodS7Y4bZ+fzzAXMSiCfQHwMkmV8-C=b3FVUXDExavXgA@mail.gmail.com>
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

On Mon, Oct 10, 2022 at 10:07 AM Alan Stern <stern@rowland.harvard.edu> wrote:
>
> On Mon, Oct 10, 2022 at 09:56:53AM -0400, Peter Geis wrote:
> > Good Morning,
> >
> > I've run into a bug with a new usb device when attempting to pass
> > through using qemu-kvm. Another device is passed through without
> > issue, and qemu spice passthrough does not exhibit the issue. The usb
> > device shows up in the KVM machine, but is unusable. I'm unsure if
> > this is a usbfs bug, a qemu bug, or a bug in the device driver.
> >
> > usb 3-6.2: usbfs: process 365671 (CPU 2/KVM) did not claim interface 0
> > before use
> > usb 3-6.2: usbfs: process 365671 (CPU 2/KVM) did not claim interface 0
> > before use
> > usb 3-6.2: usbfs: process 365672 (CPU 3/KVM) did not claim interface 1
> > before use
> > usb 3-6.2: usbfs: process 365671 (CPU 2/KVM) did not claim interface 0
> > before use
> > usb 3-6.2: usbfs: process 365672 (CPU 3/KVM) did not claim interface 0
> > before use
> > usb 3-6.2: usbfs: process 365672 (CPU 3/KVM) did not claim interface 0
> > before use
>
> These are warnings, not bugs, although one could claim that the warnings
> are caused by a bug in qemu-kvm.

The bug is the device is unusable in passthrough, this is the only
direction as to why. The question is which piece of software is
causing it. I figure qemu is the most likely suspect, but they request
bugs that are possibly in kvm start here. The cdc-acm driver is the
least likely in my mind, as the other device that works also uses it.
I just tested removing the other working device and only passing
through the suspect device, and it still triggers the bug. So whatever
the problem is, it's specific to this one device.

>
> > The host system is Ubuntu 22.04.
> > The qemu version is as shipped: QEMU emulator version 6.2.0 (Debian
> > 1:6.2+dfsg-2ubuntu6.3)
> > The host kernel version is: 5.15.0-48-generic #54-Ubuntu SMP Fri Aug
> > 26 13:26:29 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
> >
> > The VM is HomeAssistant, running kernel 5.15.67. Issue was also
> > observed on kernel version 5.10.
>
> Does the device work if your virtual machine has only one CPU?

Just tested, this doesn't make a difference.

>
> Alan Stern

Thanks,
Peter
