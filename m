Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97209427F4F
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 08:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhJJGSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 02:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhJJGSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Oct 2021 02:18:01 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1680C061570;
        Sat,  9 Oct 2021 23:16:03 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id u69so7352330oie.3;
        Sat, 09 Oct 2021 23:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=daGz2AT73lBTk8Kwa51aEbShQGQTIG56i4A/DTDNGls=;
        b=NkoxlVp2Rqq5UujnoattJyVeQp2F1MUegHUfmIvgsFN+40WFpv4prdvKoA04A1n/ey
         XQb/slzFfy1RUGI+/YACt7ZzVratNKCbKVJEBK96IYTK5JhkIo+lv5Lfj0nBdLKaU6Dx
         71pwMD0x5iFlsDujAyRGEEuf1CcGjEQdjnICWDjuNpQRTWGh7WtJYoJGC0BTJnREsErB
         iwqZGoTezVVCXv5sB/zQGIbhX3vMTLm2/OS5BvJxlp4AuW7Am/D2L5dZ+phOebm9nfl/
         InGp4ths5vXQhdStstgiMRDXXS+WTMq4/Mu7QpLjSH4oVQLLNPi7b8FpCn+aizM2PzOA
         pj3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=daGz2AT73lBTk8Kwa51aEbShQGQTIG56i4A/DTDNGls=;
        b=SlNcYHfV2/54pbGfoOeb6vWBHLby1968AA4oyPxq/+DO265OKnbytqlu3HWZ4sDf7W
         6sARpMZ1QjitgvBWPaMYcxG2UHF+RAwrvE7hHFBuhEV8qO7OH8VnMtC/CzThbgqgV7Hi
         SBdSYY+x6KdJomyoAaPN/h2JWTKDNVp2Y5U0fTfzBZnUpCNbyOcedA78MZ2JM8lznPDt
         Au4t2cjXnlU0aT/JsFCa+8vxr2U3tO1qMS1ZuhZl/mRftoVa0vY38Av4ocWV5bILLDGh
         UWpFazp3vY5EdJqBZBw3zKpiuTLvA65JbWhJP6F3Ex+txyGsgsuPZWT+AMswvPnUZgJr
         mgTw==
X-Gm-Message-State: AOAM530Hx0Ia7xeRLOnfOHYrkYLM/unhDQUAeA5jBusWMhnuUNvjRNIE
        WCJ4T+TfH+nYk3kVo4k9Lv5MUwB1Awg+9wzglxk=
X-Google-Smtp-Source: ABdhPJyox2l8PWkPoFePfCgzA59pr9CmTFfHHRqaIWZGx+rM7po4EY/EvcI/dNlmGXfXn73zQ+sECUXJg+jObwtS4HY=
X-Received: by 2002:a05:6808:1912:: with SMTP id bf18mr14334736oib.118.1633846562381;
 Sat, 09 Oct 2021 23:16:02 -0700 (PDT)
MIME-Version: 1.0
References: <20211002124012.18186-1-ajaygargnsit@gmail.com>
 <b9afdade-b121-cc9e-ce85-6e4ff3724ed9@linux.intel.com> <CAHP4M8Us753hAeoXL7E-4d29rD9+FzUwAqU6gKNmgd8G0CaQQw@mail.gmail.com>
 <20211004163146.6b34936b.alex.williamson@redhat.com> <CAHP4M8UeGRSqHBV+wDPZ=TMYzio0wYzHPzq2Y+JCY0uzZgBkmA@mail.gmail.com>
In-Reply-To: <CAHP4M8UeGRSqHBV+wDPZ=TMYzio0wYzHPzq2Y+JCY0uzZgBkmA@mail.gmail.com>
From:   Ajay Garg <ajaygargnsit@gmail.com>
Date:   Sun, 10 Oct 2021 11:45:50 +0530
Message-ID: <CAHP4M8UD-k76cg0JmeZAwaWh1deSP82RCE=VC1zHQEYQmX6N9A@mail.gmail.com>
Subject: Re: [PATCH] iommu: intel: remove flooding of non-error logs, when
 new-DMA-PTE is the same as old-DMA-PTE.
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> I'll try and backtrack to the userspace process that is sending these ioctls.
>

The userspace process is qemu.

I compiled qemu from latest source, installed via "sudo make install"
on host-machine, rebooted the host-machine, and booted up the
guest-machine on the host-machine. Now, no kernel-flooding is seen on
the host-machine.

For me, the issue is thus closed-invalid; admins may take the
necessary action to officially mark ;)


Thanks and Regards,
Ajay
