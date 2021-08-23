Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CC13F4E4C
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 18:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhHWQVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 12:21:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229622AbhHWQVn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 12:21:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629735660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=71l7HuQPH09rcwEW7WJrnA99Ea0t1Z3460JPOoHmvwU=;
        b=WlxqKwu8galleVdPbvukqbfif94qvIjuZ+sRDoZaYzoAMwfzveVpBbhps/6NJ6QkKTxkG5
        PuoNfgh15J+nhBTxvIx/Xs/xLMIZLE9Q8VtFgGUPcFP+dqN6XsZwTW1+E2ZXHctTWOYiWe
        bd3en75LqN5r9E185zevS2rMsZKeAPU=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-FbwfYeoLMeOtO8epRBgDCA-1; Mon, 23 Aug 2021 12:20:58 -0400
X-MC-Unique: FbwfYeoLMeOtO8epRBgDCA-1
Received: by mail-ot1-f71.google.com with SMTP id c21-20020a0568301af500b0051af51e2a5bso7224457otd.10
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 09:20:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=71l7HuQPH09rcwEW7WJrnA99Ea0t1Z3460JPOoHmvwU=;
        b=pKD2e/wX4qCBxjZFQNIEHpDd3CqV/Eksv0MibNN3JrUpN5J1flklz5MBVDDvJ+SN6/
         zNLnBOlpfVHBTebckhEMXzEp0L25hDOWq9ledRoD4dz5axpjGJ3J23quDZ2JVQG7WikU
         tJddKjzlJtZwVI54a/g2Xcp1nEF0qYmwSN4VI4FYcNts0DJ3s3fhzXiw1ZOdkuGNjExk
         SoTcPa5IZzUcihpIu2oAohoU/emnxyCJRqpbXAyz4gL9+GHdax/r6BXBmvM73hoTpCyw
         /i6EsWNJ0VS0nAiZXdbPEdgX3Miz2g3Em2BvqPkakKjAG91ZFUREgWo6FbHh8waspMDP
         Okrw==
X-Gm-Message-State: AOAM531OfONOvG9D0ioc7Fu61i0vWULGRXoLZ2zT2CZvgwM6sFTM5LWZ
        /kr+gmTSdScG0x3+MCYbXbNxy+rlYnzUeFArLlry/hyaF52qPH1vmNYkkElUkSzpWopVrRqaT4k
        0j/qkbuvG/poj
X-Received: by 2002:a4a:2c49:: with SMTP id o70mr26027957ooo.71.1629735658101;
        Mon, 23 Aug 2021 09:20:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytJtuQ3SpG7msNN3C4qxLKEw23HYYuXZy4UzrQ7Bc4P8QrmE1aecpbhTM4xCuxYHj1l1ui4w==
X-Received: by 2002:a4a:2c49:: with SMTP id o70mr26027942ooo.71.1629735657918;
        Mon, 23 Aug 2021 09:20:57 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id x8sm3448488oof.27.2021.08.23.09.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 09:20:57 -0700 (PDT)
Date:   Mon, 23 Aug 2021 10:20:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     <mjrosato@linux.ibm.com>, <farman@linux.ibm.com>,
        <cohuck@redhat.com>, <linux-s390@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio-pci/zdev: Remove repeated verbose license text
Message-ID: <20210823102056.49daf260.alex.williamson@redhat.com>
In-Reply-To: <20210822043500.561-1-caihuoqing@baidu.com>
References: <20210822043500.561-1-caihuoqing@baidu.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 22 Aug 2021 12:35:00 +0800
Cai Huoqing <caihuoqing@baidu.com> wrote:

> remove it because SPDX-License-Identifier is already used
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/vfio/pci/vfio_pci_zdev.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index 7b011b62c766..dfd8d826223d 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -5,11 +5,6 @@
>   * Copyright (C) IBM Corp. 2020.  All rights reserved.
>   *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
>   *                 Matthew Rosato <mjrosato@linux.ibm.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - *
>   */
>  #include <linux/io.h>
>  #include <linux/pci.h>

The SPDX license for this file is actually GPL-2.0+ but the text here
matches the more restrictive GPL-2.0.  I'm not a lawyer, but I'd expect
the more restrictive license holds, so removing this text might
actually change the license.  Should this also correct the SPDX
license?  Perhaps we need clarification from the authors.  Thanks,

Alex

