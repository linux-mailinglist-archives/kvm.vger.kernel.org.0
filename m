Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F8842969B
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 20:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbhJKSQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 14:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234320AbhJKSQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 14:16:14 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260EBC061570;
        Mon, 11 Oct 2021 11:14:14 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id l16-20020a9d6a90000000b0054e7ab56f27so5445564otq.12;
        Mon, 11 Oct 2021 11:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=so5v8xcVc8H+6uvaMOS818TeIXcZqDh/c1PHeEhQkb0=;
        b=dJS2ociZaxImnyy/ctc1JFg0DxR9n+uzK2WvywdKtbLnpKPJ+o6XQ5Vh/f7E2cRZEC
         /LXvgT39HtTQRqr+UxRHCJbfeAsrSCcmGNnu8EXR9tRAl3ppEvWeLIkqHSG2FiqWYkPZ
         Sy4HRmErsTzwR9S0HnxF6U+dIBtVCGsPWWyQrk8v90VV0Zw0YlpcPvO18Pi3AzB2fPDW
         SG71nGm9fSvU+4NWtI5cWNkBywG90U2UVgLlHF0gPUjgLal+ff+XjaqaeUMYz1wAjyJY
         TmTc5bAyh43f0fkN6KJJvkaEYzdMeDcj1wQzX6MdHcTSct7SK439M0Nbn1R8LDzEX1PO
         08mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=so5v8xcVc8H+6uvaMOS818TeIXcZqDh/c1PHeEhQkb0=;
        b=wDnkStO4Kdkk9b61eYeMX/NVKJAjf5vCARqiK1tF0mJcHK1r/u1eSmrr7ULXpyeSmR
         RY5D/SqTowPntOg1jPsjcUx9Lb54fjMmIdiaiqM793lee4HowEuB0LS6obA8cwuL/Yh5
         tLcpi2KMMpR+xenu87VpXW7vNK93jdA3TVV84NOrqqQb4XZQnI/sRUOQhEcMM5hO4Fvq
         kNCyxoajVkmZVh3LGR+KfQcQ1osRB+PBGqBaXW6Chei1MkricF6mOUI+2xKFH4HL4WsV
         NvMZaM8SYJz8SxdM0a/24LawmU96uMJdGldA9neOfDunuhrSnkESMbMT2KNT7RqIaTWK
         kUrg==
X-Gm-Message-State: AOAM5313936SDn2kQvsktVdOC3vmIbFpfnsbSzFouDC/A7fAJ+j5GYuA
        dNpbuic60Dbn+EeAwBfgvoNL/lB3vPJLmp/vhgUZO16uWk4=
X-Google-Smtp-Source: ABdhPJxo7Lkg+QlgZlHkpUhc9g80AxNDDCis6WeGaKpbzXyEpPer0n7rrlVxTEMErsvMZrye4BUylFm5IgjzpQASsDw=
X-Received: by 2002:a05:6830:2816:: with SMTP id w22mr21954487otu.351.1633976053471;
 Mon, 11 Oct 2021 11:14:13 -0700 (PDT)
MIME-Version: 1.0
References: <20211002124012.18186-1-ajaygargnsit@gmail.com>
 <b9afdade-b121-cc9e-ce85-6e4ff3724ed9@linux.intel.com> <CAHP4M8Us753hAeoXL7E-4d29rD9+FzUwAqU6gKNmgd8G0CaQQw@mail.gmail.com>
 <20211004163146.6b34936b.alex.williamson@redhat.com> <CAHP4M8UeGRSqHBV+wDPZ=TMYzio0wYzHPzq2Y+JCY0uzZgBkmA@mail.gmail.com>
 <CAHP4M8UD-k76cg0JmeZAwaWh1deSP82RCE=VC1zHQEYQmX6N9A@mail.gmail.com>
 <CAHP4M8VPem7xEtx3vQPm3bzCQif7JZFiXgiUGZVErTt5vhOF8A@mail.gmail.com> <20211011085247.7f887b12.alex.williamson@redhat.com>
In-Reply-To: <20211011085247.7f887b12.alex.williamson@redhat.com>
From:   Ajay Garg <ajaygargnsit@gmail.com>
Date:   Mon, 11 Oct 2021 23:43:29 +0530
Message-ID: <CAHP4M8UmnBH58H3qqba1p3kyEiPUk9xTp063yJr8RFduUNjgbg@mail.gmail.com>
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

Thanks Alex for your time.

I think I may have found the issue. Right now, when doing a
dma-unmapping, we do a "soft-unmapping" only, as the pte-values
themselves are not cleared in the unlinked pagetable-frame.

I have made the (simple) changes, and things are looking good as of
now (almost an hour now).
However, this time I will give it a day ;)

If there is not a single-flooding observed in the next 24 hours, I
would float the v2 patch for review.


Thanks again for your time and patience.


Thanks and Regards,
Ajay


>
> Even this QEMU explanation doesn't make a lot of sense, vfio tracks
> userspace mappings and will return an -EEXIST error for duplicate or
> overlapping IOVA entries.  We expect to have an entirely empty IOMMU
> domain when a device is assigned, but it seems the only way userspace
> can trigger duplicate PTEs would be if mappings already exist, or we
> have a bug somewhere.
>
> If the most recent instance is purely on bare metal, then it seems the
> host itself has conflicting mappings.  I can only speculate with the
> limited data presented, but I'm suspicious there's something happening
> with RMRRs here (but that should also entirely preclude assignment).
> dmesg, lspci -vvv, and VM configuration would be useful.  Thanks,
>
> Alex
>
