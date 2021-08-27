Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8158B3F94DE
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 09:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244387AbhH0HHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 03:07:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42330 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231739AbhH0HHt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 03:07:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630048020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8Funzvyr+wIWwolEPcNKEQ65EHp690MIRc/WKaoLb0E=;
        b=WIMis5axLo9b5v2jgH2DMxMhw1XdeI/gNvtDR7dG6E8/ICaMIopGg3OkchBuU/filfZn7/
        ukujKbsrnO6LCaYXrcJz+Be/hqi1YPy6joabEftPlRu/yIdMnA5rgoFwL/KU+jCrSCLFwP
        J9SKGVmjK7Mk5G9m067e8CHyN84dOgs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-5Dk8RARKNASg-qE3q6x4ng-1; Fri, 27 Aug 2021 03:06:58 -0400
X-MC-Unique: 5Dk8RARKNASg-qE3q6x4ng-1
Received: by mail-ej1-f69.google.com with SMTP id gg1-20020a170906e281b029053d0856c4cdso2226694ejb.15
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 00:06:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8Funzvyr+wIWwolEPcNKEQ65EHp690MIRc/WKaoLb0E=;
        b=i1HCfP/SolwZ7gYD5P8tI5u4q1LIb5bAPBw8eOhwk7hpEbs83tbzfGd0l16UdMQPxo
         aKWR1rXGrNLucRSpdQ7rHnaWPCTVDJn97QgSRuRE0RaFrffoG3vH3Ph9Rwz0o+yTn+r2
         pnz+EjJVr0YOgXDrA37lLS8RGVLbZKkZXhtgibyFiyspAIOL1GpPl2Doziv+kwu+wqoz
         aGOvgISR9G0XKucgqXAukVL8YEAXec+7FRuLTVVcjXMotwzxvnakvzhpMmDMGoN35KrF
         zCSLEr9gCisy/kAqVFRK6Ilk9fWOskiMlMCdC7OLogTClve8ROPLA2p2Z99/t6uW0inY
         lQ1A==
X-Gm-Message-State: AOAM531h8h8UOw/uyq24Yyeaj7/e1oCWvHROoWI/2gIgYXF2OpbGM+Bk
        iUtMpCL2HQKmvN06EN2/EID5H2N9++Mkk4ZF8YFhY+1FmM4f/rN1E7urc2519X9d5MWUJiR0omJ
        66d/8lg+XGcfk
X-Received: by 2002:a05:6402:3485:: with SMTP id v5mr8249489edc.205.1630048017597;
        Fri, 27 Aug 2021 00:06:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygFuPcv9ecqs0S04GYbyelxqZmwGCgRnmyx6su6blF+pUQqxUmpSh1/ic6mddd1NYY3u3xuw==
X-Received: by 2002:a05:6402:3485:: with SMTP id v5mr8249468edc.205.1630048017468;
        Fri, 27 Aug 2021 00:06:57 -0700 (PDT)
Received: from steredhat (host-79-36-51-142.retail.telecomitalia.it. [79.36.51.142])
        by smtp.gmail.com with ESMTPSA id q21sm2325001ejs.43.2021.08.27.00.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 00:06:57 -0700 (PDT)
Date:   Fri, 27 Aug 2021 09:06:55 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
Subject: Re: [PATCH v1 1/3] nitro_enclaves: Enable Arm support
Message-ID: <20210827070655.inocrxzs4hix4anv@steredhat>
References: <20210826173451.93165-1-andraprs@amazon.com>
 <20210826173451.93165-2-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210826173451.93165-2-andraprs@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 08:34:49PM +0300, Andra Paraschiv wrote:
>Update the kernel config to enable the Nitro Enclaves kernel driver for
>Arm support.
>
>Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>---
> drivers/virt/nitro_enclaves/Kconfig | 8 ++------
> 1 file changed, 2 insertions(+), 6 deletions(-)

Acked-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/drivers/virt/nitro_enclaves/Kconfig b/drivers/virt/nitro_enclaves/Kconfig
>index 8c9387a232df8..f53740b941c0f 100644
>--- a/drivers/virt/nitro_enclaves/Kconfig
>+++ b/drivers/virt/nitro_enclaves/Kconfig
>@@ -1,17 +1,13 @@
> # SPDX-License-Identifier: GPL-2.0
> #
>-# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
>+# Copyright 2020-2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
>
> # Amazon Nitro Enclaves (NE) support.
> # Nitro is a hypervisor that has been developed by Amazon.
>
>-# TODO: Add dependency for ARM64 once NE is supported on Arm platforms. For now,
>-# the NE kernel driver can be built for aarch64 arch.
>-# depends on (ARM64 || X86) && HOTPLUG_CPU && PCI && SMP
>-
> config NITRO_ENCLAVES
> 	tristate "Nitro Enclaves Support"
>-	depends on X86 && HOTPLUG_CPU && PCI && SMP
>+	depends on (ARM64 || X86) && HOTPLUG_CPU && PCI && SMP
> 	help
> 	  This driver consists of support for enclave lifetime management
> 	  for Nitro Enclaves (NE).
>-- 
>2.20.1 (Apple Git-117)
>
>
>
>
>Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.
>

