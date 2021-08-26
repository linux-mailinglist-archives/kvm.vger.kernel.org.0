Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5F83F90A0
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243700AbhHZWVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:21:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35658 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230397AbhHZWVb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 18:21:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630016443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MAcQxNjZy0LhG3pBa6b4m8E/gXaMvjIjgc9wYJuGhlI=;
        b=WE7mKI7m8lWPDmjQIrmpLSX89aHZ2HQso2/yhTnA0o94UJLUToPpFOOeEm+lZszqgzLn+k
        vAqZLINid4tsg6xAyTgAl9btezgbqVKBOSy+C3GuLEdVbcgtb/cVYZis5Maetv97u6kEV8
        EOQPntadgT2aolWq2vlmbqurJgRHe0w=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-vZqHQJIWPneyLuXe1ulOBw-1; Thu, 26 Aug 2021 18:20:40 -0400
X-MC-Unique: vZqHQJIWPneyLuXe1ulOBw-1
Received: by mail-oo1-f72.google.com with SMTP id b24-20020a4ac2980000b0290269ebe9b797so2040932ooq.18
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 15:20:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MAcQxNjZy0LhG3pBa6b4m8E/gXaMvjIjgc9wYJuGhlI=;
        b=GsyGXhAHjoMd6Lmxfr3L/YIZc9EOyTpqrFp7C1IOOMWFDPXxJNLeZcraYxBjTelJQE
         OT2SJhd4pvymYnnZpke2Jei/cpK0eD4BFfy08oOAvEyCcwtzL0Dk95XQXI3fbiSpuAkV
         NuwEXFVUlU7gZeDG4neIQ+Vb3ey1Ji/eP4itF3hQbgI8sw6kpLFruKaPmhi2e/CJEAn/
         OoE6tDYToT04asj/b6vdxrWtvVXCZehVjImIGaM6WZoTRlS4r9PWBJxpekRjr60Fwglq
         DqPY3RIylKxsCC7rUZS7KZYTJ04cRbqmEGYRu6k+7/wtiJ7qn28rKxrmIHAgUs698Au+
         fYhQ==
X-Gm-Message-State: AOAM533TvGRVl5FSpuHiyGFgVbq+24UHdpCwOPS3Xsg8eVBG4CVjpxbp
        HEy7w/7fMMmEBzXBs9xDJ16OGrpSS2IlkgK71rGOdE7LPKWvkdaDAtqbtRNCKSc3icboIKHJBh1
        4J7WzFwdVHzTi
X-Received: by 2002:a4a:e3cf:: with SMTP id m15mr5141469oov.21.1630016439945;
        Thu, 26 Aug 2021 15:20:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyddZGt1SZd/QwahY9dV4amjuNgFeMZnNAfeP+OEJRcwrdDOSPiFfspzfF4NR6Y1rRD/5+pVg==
X-Received: by 2002:a4a:e3cf:: with SMTP id m15mr5141462oov.21.1630016439717;
        Thu, 26 Aug 2021 15:20:39 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id t1sm841245otp.9.2021.08.26.15.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 15:20:39 -0700 (PDT)
Date:   Thu, 26 Aug 2021 16:20:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     <eric.auger@redhat.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio: platform: reset: Convert to SPDX identifier
Message-ID: <20210826162037.4d152e83.alex.williamson@redhat.com>
In-Reply-To: <20210822043643.2040-1-caihuoqing@baidu.com>
References: <20210822043643.2040-1-caihuoqing@baidu.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 22 Aug 2021 12:36:43 +0800
Cai Huoqing <caihuoqing@baidu.com> wrote:

> use SPDX-License-Identifier instead of a verbose license text
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)

Applied to vfio next branch for v5.15.  Thanks,

Alex

