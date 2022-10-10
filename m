Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFB55F9FCB
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 16:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiJJOHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 10:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJJOHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 10:07:18 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 9909C6E8B4
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 07:07:17 -0700 (PDT)
Received: (qmail 920064 invoked by uid 1000); 10 Oct 2022 10:07:16 -0400
Date:   Mon, 10 Oct 2022 10:07:16 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     kvm@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [BUG] KVM USB passthrough did not claim interface before use
Message-ID: <Y0QnFHqrX2r/7oUz@rowland.harvard.edu>
References: <CAMdYzYrUOoTmBL2c_+=xLBMXg38Pp4hANnzqxoe1cVDDrFvqTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMdYzYrUOoTmBL2c_+=xLBMXg38Pp4hANnzqxoe1cVDDrFvqTA@mail.gmail.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 10, 2022 at 09:56:53AM -0400, Peter Geis wrote:
> Good Morning,
> 
> I've run into a bug with a new usb device when attempting to pass
> through using qemu-kvm. Another device is passed through without
> issue, and qemu spice passthrough does not exhibit the issue. The usb
> device shows up in the KVM machine, but is unusable. I'm unsure if
> this is a usbfs bug, a qemu bug, or a bug in the device driver.
> 
> usb 3-6.2: usbfs: process 365671 (CPU 2/KVM) did not claim interface 0
> before use
> usb 3-6.2: usbfs: process 365671 (CPU 2/KVM) did not claim interface 0
> before use
> usb 3-6.2: usbfs: process 365672 (CPU 3/KVM) did not claim interface 1
> before use
> usb 3-6.2: usbfs: process 365671 (CPU 2/KVM) did not claim interface 0
> before use
> usb 3-6.2: usbfs: process 365672 (CPU 3/KVM) did not claim interface 0
> before use
> usb 3-6.2: usbfs: process 365672 (CPU 3/KVM) did not claim interface 0
> before use

These are warnings, not bugs, although one could claim that the warnings 
are caused by a bug in qemu-kvm.

> The host system is Ubuntu 22.04.
> The qemu version is as shipped: QEMU emulator version 6.2.0 (Debian
> 1:6.2+dfsg-2ubuntu6.3)
> The host kernel version is: 5.15.0-48-generic #54-Ubuntu SMP Fri Aug
> 26 13:26:29 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
> 
> The VM is HomeAssistant, running kernel 5.15.67. Issue was also
> observed on kernel version 5.10.

Does the device work if your virtual machine has only one CPU?

Alan Stern
