Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E4B42A6A9
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 16:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbhJLOEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 10:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhJLOEg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 10:04:36 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C287CC061570;
        Tue, 12 Oct 2021 07:02:34 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id s18-20020a0568301e1200b0054e77a16651so9255436otr.7;
        Tue, 12 Oct 2021 07:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Q0Hb9oHK4KcWY8R31erb4VAXs7l6Pn0D6RYKuAbMqo=;
        b=Yq0ybx5oUO6KRl2BgdyTUebTMHE0V1N6SUlOeLzmooYLbULfQ5zR20IIY87NnYijQh
         X5EqrMG7H0ofNUv6kbg1+DfDEBeQr+h4fZX7umN12dSHqHbgLcDiJBXbA9gFGY3ZD9s/
         JAhYNYBygHFReTI2G1t3CqAbsy4WMjGQQ6IkftLfOOYT5Wcq6mXFhczS+NuXJH8SZqiM
         gyNOefmWCD19W3LLPgZl0A+ya1Mn9YvSVRAA5aphUWTgIKFiURHSZ+Lx95W/ACie4pP+
         91Bm8NyOFOZNQX7gSNNWShqXCKWRfB12NaxsTeySZCzgNwwelb1mj4hZNk7AX7BYxe0g
         TrBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Q0Hb9oHK4KcWY8R31erb4VAXs7l6Pn0D6RYKuAbMqo=;
        b=kAEDP50CjGWzPGgpVXBdyX7XKwQtaRAG1+TTM+cBhsS116+DNpfx3gb9ZpjiMJgOmL
         +zipwq0gZJoFUGeBzfoyTasVGUl4XIVfyCrnG2dh3doaz/VgENP1BlBMrZ0JMBJ5Tqmz
         Rq2VXyy0mhFYMV63DzVpkqxFwNyluQGutc90dUWylgMe1Sqz3/ugrSrTZ9/VdFwY1w59
         d7sUCPbXC//WCE/qrgN660o13K9QA12dcrBgLqEjglnuTt7AdjVTVnYWz8ufNE7b2kxN
         VDtt+ZBaE3Dk8Eo9MF2LFOrvE2bCneNYrpfpdb6R0bJ7BjII3ERA4/Iq0t6X/07b/A2u
         5Nww==
X-Gm-Message-State: AOAM533guAteQWt+wtfLJ6Fs8l2Hd1z1OHcdkpwI4pc2Hqh2C+vZIsQc
        w5J8tHnnqtElMChJd00x/tRUCO6sTIshgoUWT38B2eK/MsJ5VA==
X-Google-Smtp-Source: ABdhPJzCeultU29FTm/JBZilW5VAVm32j0fgdcu8Mvi1xP1XUxDRD2qYdD/eLWbeM65K6kc+s7uW063PChXvmPzgNW0=
X-Received: by 2002:a05:6830:1653:: with SMTP id h19mr27310330otr.162.1634047354154;
 Tue, 12 Oct 2021 07:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <20211002124012.18186-1-ajaygargnsit@gmail.com>
 <b9afdade-b121-cc9e-ce85-6e4ff3724ed9@linux.intel.com> <CAHP4M8Us753hAeoXL7E-4d29rD9+FzUwAqU6gKNmgd8G0CaQQw@mail.gmail.com>
 <20211004163146.6b34936b.alex.williamson@redhat.com> <CAHP4M8UeGRSqHBV+wDPZ=TMYzio0wYzHPzq2Y+JCY0uzZgBkmA@mail.gmail.com>
 <CAHP4M8UD-k76cg0JmeZAwaWh1deSP82RCE=VC1zHQEYQmX6N9A@mail.gmail.com>
 <CAHP4M8VPem7xEtx3vQPm3bzCQif7JZFiXgiUGZVErTt5vhOF8A@mail.gmail.com>
 <20211011085247.7f887b12.alex.williamson@redhat.com> <CAHP4M8UmnBH58H3qqba1p3kyEiPUk9xTp063yJr8RFduUNjgbg@mail.gmail.com>
In-Reply-To: <CAHP4M8UmnBH58H3qqba1p3kyEiPUk9xTp063yJr8RFduUNjgbg@mail.gmail.com>
From:   Ajay Garg <ajaygargnsit@gmail.com>
Date:   Tue, 12 Oct 2021 19:32:21 +0530
Message-ID: <CAHP4M8Wyh92T3KBkpknkY+3gnN_ir-dfnLLf=D3_yUN0jj6Qxw@mail.gmail.com>
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

Hi Alex, Lu.

Posted v2 patch, as per
https://lists.linuxfoundation.org/pipermail/iommu/2021-October/059955.html


Kindly review, and let's continue on that thread now.


Thanks and Regards,
Ajay

On Mon, Oct 11, 2021 at 11:43 PM Ajay Garg <ajaygargnsit@gmail.com> wrote:
>
> Thanks Alex for your time.
>
> I think I may have found the issue. Right now, when doing a
> dma-unmapping, we do a "soft-unmapping" only, as the pte-values
> themselves are not cleared in the unlinked pagetable-frame.
>
> I have made the (simple) changes, and things are looking good as of
> now (almost an hour now).
> However, this time I will give it a day ;)
>
> If there is not a single-flooding observed in the next 24 hours, I
> would float the v2 patch for review.
>
>
> Thanks again for your time and patience.
>
>
> Thanks and Regards,
> Ajay
>
>
> >
> > Even this QEMU explanation doesn't make a lot of sense, vfio tracks
> > userspace mappings and will return an -EEXIST error for duplicate or
> > overlapping IOVA entries.  We expect to have an entirely empty IOMMU
> > domain when a device is assigned, but it seems the only way userspace
> > can trigger duplicate PTEs would be if mappings already exist, or we
> > have a bug somewhere.
> >
> > If the most recent instance is purely on bare metal, then it seems the
> > host itself has conflicting mappings.  I can only speculate with the
> > limited data presented, but I'm suspicious there's something happening
> > with RMRRs here (but that should also entirely preclude assignment).
> > dmesg, lspci -vvv, and VM configuration would be useful.  Thanks,
> >
> > Alex
> >
