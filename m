Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 240F71565B
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 01:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfEFXfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 19:35:40 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:40248 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEFXfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 19:35:40 -0400
Received: by mail-ed1-f52.google.com with SMTP id e56so16947821ede.7
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 16:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=VCqVxw+mJgUMWWGo5wYdP4j9HPNycm1tU/ihoffmxz8=;
        b=RNFqj1t2s8H7Q5wKzFwA5bl0b5ccasg3E5KCojct0jEVY2TrL1QELktp7lyMNx8AJA
         gQnL0zmaR4LMasvY6G0MOWhplM3J0nnVpRRy0Ei6KtVUb9fJ6b+6YXFEQyZd3jLjk+Si
         Y4r41K+/m3VUXqBbIkcvuX0LIPFbYx+InTNWs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VCqVxw+mJgUMWWGo5wYdP4j9HPNycm1tU/ihoffmxz8=;
        b=oRQINzzlyTaiT0NWDJe6VdAqvHUQToIwYIDz/7kXTTvzOYfvR4FHWpg8FyVas9zRiX
         Cyo+bJwoNkUaQqM5qrpf1et+yQxXogu+yIX9nkCEEZrzCyv/h6e+/u33W+prjv+lLVY8
         npT6RG+O7IIKDjFXrigHFCZMen9j523UcIYZNedFqI/vrrGajhtpBKNjw8ZQ1gWN2uDY
         om+IkOgaAQOhKP/CB2xgJeFMIFbxXrkziGy64He801FeMX07/33JH2/ipWfZ2tk4SUHI
         DDDig67kg7Yl87iaCYXpRoVtoMl7ilXgkcWahrgISC3IJsrVW5O52NE27mzNYnO/uRqj
         sGgw==
X-Gm-Message-State: APjAAAUOP+/WADAwRzoRma1OY+JJMdJzQLpjrlzIVOFXlMe19R/7SfBG
        hc+y0N4ufQFUnMWSTjfYf96S3sr579U=
X-Google-Smtp-Source: APXvYqwDTAxe9y7O6xjJVHzC7SolV7/VDGxe1FJ3/c7c0Ls5MC/cc1O4Cr0IUMzBef7iV9kQfOQBew==
X-Received: by 2002:a50:8818:: with SMTP id b24mr29528510edb.28.1557185738578;
        Mon, 06 May 2019 16:35:38 -0700 (PDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id h27sm1551377edb.66.2019.05.06.16.35.37
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 16:35:37 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id o189so6964391wmb.1
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 16:35:37 -0700 (PDT)
X-Received: by 2002:a1c:5f42:: with SMTP id t63mr17348072wmb.94.1557185736818;
 Mon, 06 May 2019 16:35:36 -0700 (PDT)
MIME-Version: 1.0
From:   Hyunwook Baek <wooky@chromium.org>
Date:   Mon, 6 May 2019 16:35:26 -0700
X-Gmail-Original-Message-ID: <CABMWKFDiMWOX67Gr2PYChMCjFcpNqkQcyXt_+uk+wOSR-0ukoA@mail.gmail.com>
Message-ID: <CABMWKFDiMWOX67Gr2PYChMCjFcpNqkQcyXt_+uk+wOSR-0ukoA@mail.gmail.com>
Subject: kvm-unit-tests with UEFI (OVMF)
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Has anyone tried running kvm-unit-tests with QEMU OVMF?

I could successfully run kvm unit tests with QEMU with '-kernel' option
(e.g., qemu-system-x86_64 -enable-kvm -device pc-testdev -serial stdio -device \
 isa-debug-exit,iobase=0xf4,iosize=0x4  -kernel ./x86/msr.flat),
but it wasn't successful under OVMF UEFI setup (i.e., using -bios OVMF.fd).

OVMF supports "-kernel" option since r13923
(https://sourceforge.net/p/edk2/code/13923)
but simply passing a kvm-unit-tests kernel image using "-kernel"
option doesn't work
(probably because it does not support multiboot format).

So I just wonder what would be a right way to run kvm-unit-tests under
an UEFI environment..

Regards,
Wooky
