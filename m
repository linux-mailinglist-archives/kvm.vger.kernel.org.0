Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4E88FD69
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 10:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfHPIN1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Aug 2019 04:13:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42789 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbfHPIN0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Aug 2019 04:13:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id b16so696367wrq.9
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2019 01:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=PKnHGuT2rnPjBkW9EQAY7K1X3DnykkhGdFcpRkIV3Ss=;
        b=MgRM3ptwT0HW7CW/o8WSA/HlABlfoIuWRo5ol1NHml1oyn8spJkDF+Zx/KpZZjUQ6m
         V9i1lSGf9lw0cjVUm5czg4LwdqFktVwL2IysPu10VmJ6KgPeGnUIQVG78CEhosliAWAO
         B58x5n+joyaieqolJVWUsGvryroQ0lDTBTIfT86u7StTT2D7dcEQ+exxOvAcRWGnrh++
         cuyJznCtjmodcGWsdUshr8Av/XkOnqSbwt5kOB1knhTTOHdENOv9sk+qswxUYknMaI2e
         2nnMMFf9Op0zMSCEK7ojU4Bmf9cim24UTQNTs3/3uueNBDg5lXwBYvKCzYb7Nl75glAx
         PKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=PKnHGuT2rnPjBkW9EQAY7K1X3DnykkhGdFcpRkIV3Ss=;
        b=kYVVqtmY7hLAxThMVocShk6xq7WIYUQHNZOEaIpCoUxubDE5Mi4c4Xir73o0yR3rul
         7KXlxABavpOqHezpwxHacmcmjmzPLhLZfwMrMHZk1UJiEGAcV95sixLAzDUGGg8Azzc+
         AYeW4Oxm341MK8PbQmr7XFG0RzImgYGbJtxS2WG1k2/srgXLSQeRJjMk7IDmJqEVGblg
         dAWDNnIbZRO+atOzpyeVbEFRGlTJ1sbTQBy/zShWZvaUejZjsuddi91WYq9T+Ro2bies
         aZXP3fV80wcGfgjfUU1DCJQ3lHB53zZJvM3BxJiwsGK3ZPVsS0z3Y5mqBdhTd+RT/XLE
         BEJg==
X-Gm-Message-State: APjAAAXXy64qNEsxjRSvTEitOsLY9NPskPOU20HPyVk4OerEd7VtEieG
        jej73hWaZNAOOa3J/iCfa+uTTS6e9jH0pDESygNFsQ==
X-Google-Smtp-Source: APXvYqyx5sQ6GAp7sKI3H3TZ1Ua/t0cwhilHhYgn7O4JO1Q+VFZmGmUSPoEKQzODPUsH1zwIGgDzkEH71dmCehkjrac=
X-Received: by 2002:a5d:52cc:: with SMTP id r12mr2435872wrv.272.1565943204672;
 Fri, 16 Aug 2019 01:13:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a1c:9e03:0:0:0:0:0 with HTTP; Fri, 16 Aug 2019 01:13:24
 -0700 (PDT)
From:   John W <jwdevel@gmail.com>
Date:   Fri, 16 Aug 2019 01:13:24 -0700
Message-ID: <CADO30sqvzGCyxsswhuEJ3qcMs_-f-aNuMiYkKyGUxCTja43yoA@mail.gmail.com>
Subject: Where to file this KVM/Qemu bug?
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I have an issue where I cannot install or run Windows XP using KVM,
but it is fine under plain QEMU (with "-no-kvm").

Details here: https://stackoverflow.com/questions/57499661/libvirt-how-to-prevent-accel-kvm

I have found some similar-sounding cases, but they are from ~10 years ago.

Assuming this is a valid bug, I am trying to find the right place to file it.
Perhaps this is the right link?  https://www.linux-kvm.org/page/Bugs

If so, then the instructions there tell me "Even if you use kvm from a
distribution ... it is important to use the latest sources."

I am indeed using a distribution (Debian 10.0), but I'm not sure what
is meant by "use the latest sources". Does it mean an up-to-date
package for my distribution? Or is it suggesting I compile KVM myself
from source?

Thanks for any advice.
-John
