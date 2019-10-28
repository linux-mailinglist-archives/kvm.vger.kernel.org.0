Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0BBE6E36
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 09:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387452AbfJ1I2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Oct 2019 04:28:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387412AbfJ1I2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Oct 2019 04:28:44 -0400
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B87BC85360
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2019 08:28:43 +0000 (UTC)
Received: by mail-qt1-f197.google.com with SMTP id k9so5010647qtg.2
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2019 01:28:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0d6tHsZ6xj7MncVChi2UMTdxKJ1Dhsfr4PdJX86n9PE=;
        b=gQqTvs4KRHpGD+nwu02ozyrGd+73pamdv2OuPmP0S/7jsE/S0xo+ESIoQhq03IoxzG
         7GJR3Ilaq1ZW/NkWXrUocyYndxURcZs6CmOU0Njc2r6wyMv3pZWRCihXw9yYVyZq/1d5
         VCSlYKpbd/RNGzCFLovxgZ0Y/OkZmLo4TPP5ci+wggKDqmThdM5QtdukKQVhejC+nkob
         K6dBkB5z6ybjkn5nueHdMGweUxRQdH2iPgCevkXQw9opY1hLZlIKUwoPSGu/ykCqOc/I
         ex3hhcF2OS/HbKrRrfwVs1f3698oaD314hmgz8gQDKA5ZCOI4rYwHmDMGgXm4aydI68l
         3BFg==
X-Gm-Message-State: APjAAAXm8PCbFUYmAzPVT+dodcB/dpfAkcm6KKr0v2q/FeAnZjdCuAyn
        1yvpXsCjjuOO60Z1ubIwFfNd9WiBat2FZKrZT2ndL4CzcCh1u8lG5/NPCkOkvI55bUTz9ceuePJ
        HVAXhaJ2Yn/Ls
X-Received: by 2002:a0c:eda9:: with SMTP id h9mr1914664qvr.41.1572251322985;
        Mon, 28 Oct 2019 01:28:42 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzKICV1hgQVg6QMNOdCvcA3eRj2FfsiWKX8EXyv4rbgWqrjHUMNvsCmeXLdzvuC5cD6QpBC8g==
X-Received: by 2002:a0c:eda9:: with SMTP id h9mr1914644qvr.41.1572251322701;
        Mon, 28 Oct 2019 01:28:42 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id x26sm5104286qto.21.2019.10.28.01.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 01:28:41 -0700 (PDT)
Date:   Mon, 28 Oct 2019 04:28:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     gengdongjiu <gengdongjiu@huawei.com>
Cc:     Xiang Zheng <zhengxiang9@huawei.com>, pbonzini@redhat.com,
        imammedo@redhat.com, shannon.zhaosl@gmail.com,
        peter.maydell@linaro.org, lersek@redhat.com, james.morse@arm.com,
        mtosatti@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        jonathan.cameron@huawei.com, xuwei5@huawei.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        linuxarm@huawei.com, wanghaibin.wang@huawei.com
Subject: Re: [PATCH v20 0/5] Add ARMv8 RAS virtualization support in QEMU
Message-ID: <20191028042645-mutt-send-email-mst@kernel.org>
References: <20191026032447.20088-1-zhengxiang9@huawei.com>
 <20191027061450-mutt-send-email-mst@kernel.org>
 <6c44268a-2676-3fa1-226d-29877b21dbea@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c44268a-2676-3fa1-226d-29877b21dbea@huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 28, 2019 at 12:01:34PM +0800, gengdongjiu wrote:
> Hi Michael/All
> 
> On 2019/10/27 18:17, Michael S. Tsirkin wrote:
> > On Sat, Oct 26, 2019 at 11:24:42AM +0800, Xiang Zheng wrote:
> >> In the ARMv8 platform, the CPU error types are synchronous external abort(SEA)
> >> and SError Interrupt (SEI). If exception happens in guest, sometimes it's better
> >> for guest to perform the recovery, because host does not know the detailed
> >> information of guest. For example, if an exception happens in a user-space
> >> application within guest, host does not know which application encounters
> >> errors.
> >>
> >> For the ARMv8 SEA/SEI, KVM or host kernel delivers SIGBUS to notify userspace.
> >> After user space gets the notification, it will record the CPER into guest GHES
> >> buffer and inject an exception or IRQ into guest.
> >>
> >> In the current implementation, if the type of SIGBUS is BUS_MCEERR_AR, we will
> >> treat it as a synchronous exception, and notify guest with ARMv8 SEA
> >> notification type after recording CPER into guest.
> >>
> >> This series of patches are based on Qemu 4.1, which include two parts:
> >> 1. Generate APEI/GHES table.
> >> 2. Handle the SIGBUS signal, record the CPER in runtime and fill it into guest
> >>    memory, then notify guest according to the type of SIGBUS.
> >>
> >> The whole solution was suggested by James(james.morse@arm.com); The solution of
> >> APEI section was suggested by Laszlo(lersek@redhat.com).
> >> Show some discussions in [1].
> >>
> >> This series of patches have already been tested on ARM64 platform with RAS
> >> feature enabled:
> >> Show the APEI part verification result in [2].
> >> Show the BUS_MCEERR_AR SIGBUS handling verification result in [3].
> > 
> > This looks mostly OK to me.  I sent some minor style comments but they
> > can be addressed by follow up patches.
> > 
> > Maybe it's a good idea to merge this before soft freeze to make sure it
> > gets some testing.  I'll leave this decision to the ARM maintainer.  For
> > ACPI parts:
> > 
> > Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Got it, Thanks for the Reviewed-by from Michael.
> 
> Hi Michael,
>   According to discussion with QEMU community, I finished and developed the whole ARM RAS virtualization solution, and introduce the ARM APEI table in the first time.
> For the newly created files, which are mainly about ARM APEI/GHES part,I would like to maintain them. If you agree it, whether I can add new maintainers[1]? thanks a lot.
> 
> 
> [1]:
> +ARM APEI Subsystem
> +M: Dongjiu Geng <gengdongjiu@huawei.com>
> +M: Xiang zheng <zhengxiang9@huawei.com>
> +L: qemu-arm@nongnu.org
> +S: Maintained
> +F: hw/acpi/acpi_ghes.c
> +F: include/hw/acpi/acpi_ghes.h
> +F: docs/specs/acpi_hest_ghes.rst
> 

I think for now you want to be a designated reviewer.  So I'd use an R:
tag.

> > 
> > 
> >> ---
