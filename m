Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C238E742A
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2019 15:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390470AbfJ1O4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Oct 2019 10:56:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40442 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390448AbfJ1O4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Oct 2019 10:56:51 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ACF7681F0D
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2019 14:56:50 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id m189so10560753qkc.7
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2019 07:56:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QtNd0UMqofsV+XZWmGpconlIFxP5DQnlNLXPHI1qYVA=;
        b=SLUG3ZSSkEW/7hdVLAlDKwEiiVeOBvfXbYk1Kig6OfsBxSsKgCutJKF/0jFejylkbN
         rYSyxPRw5HJVBuc5i2r9Q6Ed6EMDNjQmypfjMQEYAu/ZzG8hT7KgCHU1q4FwYTDLDYdC
         CiAxgJpj48gj0/l4oDNdf1X05zBfZEE3gXbB1kt17xq+TSLbQnLF9uBSfDOXIY43X/jr
         TcX9BN4xDRDbK1xOrOendo3GOiREKwKI5kWvk2VzlO/Ly5A9WFJObhbEuHxF+2m6o5rE
         3V58ljlY2REvzHE2W+oVHghbOGaDGNUOv8ZrPBMmHwv9sqQTkY4fA1zhJoYjxe+y3fZr
         hkHg==
X-Gm-Message-State: APjAAAXWYxGM/ZLtAuMnZS78q88RT8t4v349tMrCGlMVoJqAlr+kWaFe
        CXul1R/P9bv0hjcjTgWgTgqgN+piQHnJOxwj0LuqPtkuQ2J0wmexPdVYHbbHpTF0mKujtpoWWCC
        +P4aoKavf+b9+
X-Received: by 2002:a37:610f:: with SMTP id v15mr15487586qkb.98.1572274609945;
        Mon, 28 Oct 2019 07:56:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwVqh1AavhfAL3N/XFU4xnwB0M3GWSLGvejcePz3nI6KDoPRMDZQjnEw5dr2p7IfEnb9i2/Zg==
X-Received: by 2002:a37:610f:: with SMTP id v15mr15487560qkb.98.1572274609617;
        Mon, 28 Oct 2019 07:56:49 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id p17sm5696481qkm.135.2019.10.28.07.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 07:56:48 -0700 (PDT)
Date:   Mon, 28 Oct 2019 10:56:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     gengdongjiu <gengdongjiu@huawei.com>
Cc:     peter.maydell@linaro.org, ehabkost@redhat.com, kvm@vger.kernel.org,
        wanghaibin.wang@huawei.com, mtosatti@redhat.com,
        qemu-devel@nongnu.org, linuxarm@huawei.com,
        shannon.zhaosl@gmail.com, Xiang Zheng <zhengxiang9@huawei.com>,
        qemu-arm@nongnu.org, james.morse@arm.com,
        jonathan.cameron@huawei.com, imammedo@redhat.com,
        pbonzini@redhat.com, xuwei5@huawei.com, lersek@redhat.com,
        rth@twiddle.net
Subject: Re: [PATCH v20 0/5] Add ARMv8 RAS virtualization support in QEMU
Message-ID: <20191028104834-mutt-send-email-mst@kernel.org>
References: <20191026032447.20088-1-zhengxiang9@huawei.com>
 <20191027061450-mutt-send-email-mst@kernel.org>
 <6c44268a-2676-3fa1-226d-29877b21dbea@huawei.com>
 <20191028042645-mutt-send-email-mst@kernel.org>
 <1edda59a-8b3d-1eec-659a-05356d55ed22@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1edda59a-8b3d-1eec-659a-05356d55ed22@huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 28, 2019 at 09:50:21PM +0800, gengdongjiu wrote:
> Hi Michael,
> 
> On 2019/10/28 16:28, Michael S. Tsirkin wrote:
> >>> gets some testing.  I'll leave this decision to the ARM maintainer.  For
> >>> ACPI parts:
> >>>
> >>> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> >> Got it, Thanks for the Reviewed-by from Michael.
> >>
> >> Hi Michael,
> >>   According to discussion with QEMU community, I finished and developed the whole ARM RAS virtualization solution, and introduce the ARM APEI table in the first time.
> >> For the newly created files, which are mainly about ARM APEI/GHES part,I would like to maintain them. If you agree it, whether I can add new maintainers[1]? thanks a lot.
> >>
> >>
> >> [1]:
> >> +ARM APEI Subsystem
> >> +M: Dongjiu Geng <gengdongjiu@huawei.com>
> >> +M: Xiang zheng <zhengxiang9@huawei.com>
> >> +L: qemu-arm@nongnu.org
> >> +S: Maintained
> >> +F: hw/acpi/acpi_ghes.c
> >> +F: include/hw/acpi/acpi_ghes.h
> >> +F: docs/specs/acpi_hest_ghes.rst
> >>
> > I think for now you want to be a designated reviewer.  So I'd use an R:
> > tag.
> 
>  Thanks for the reply.
>  I want to be a maintainer for my newly created files, so whether I can use M: tag. I would like to contribute some time to maintain that, thanks a lot.

This will fundamentally be up to Peter.

Reviewing patches is generally the best way to become a maintainer,
that's why I suggested the R: tag.


> > 
> >>>
> >>>> ---
