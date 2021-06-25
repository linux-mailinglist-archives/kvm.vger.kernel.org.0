Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEA13B4647
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 17:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhFYPHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 11:07:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230172AbhFYPHA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 11:07:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624633478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eZLBt+T7GvbfVCJSBgdkZSsH2QeulD2r/OE8GH9gQvg=;
        b=A4hgyVPpeIEAuaVSjyi2btHrPtd/zAjyFGNi6ea7sYWaDeiFny8gyHJoDqmsVzT/f9j9Uz
        pkuiJm9cTWxzWpz4hk/UKGSgXoxdfBXaH3m+e/7OGUEZXtIhjprOLFQu492ihv5I9EaTBz
        NlnZ9XEIRLR1ZIu3c1F2YsGs8avBwdU=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-DBX9FVSvPPyI0nC8ddFAnQ-1; Fri, 25 Jun 2021 11:04:37 -0400
X-MC-Unique: DBX9FVSvPPyI0nC8ddFAnQ-1
Received: by mail-il1-f197.google.com with SMTP id m15-20020a923f0f0000b02901ee102ac952so6360866ila.8
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 08:04:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=eZLBt+T7GvbfVCJSBgdkZSsH2QeulD2r/OE8GH9gQvg=;
        b=GdAsXnAk45WFi+El0YVbM4oT8MIaEPLLdqmLt2Ba0AUgpqLUwqhjYu0y+hM6w8bl9S
         twp1K3S879PxFf0TaTWZun6gHeCVhiVa3losyIgE/7kWeJQqw5vo2cBdgv8KJwpKBADA
         Iitk3MVubd6A5rKoQkxKk9+0z3cDumRfNprhWTjQbZ4o7rDRsxXFhBMl5GdiO9QiCPS6
         g6dqWgL5T6F0VviShOBKdil3EzVuRp81HOmMOf1FcUKm8EhsmZvZxw2h1kRi20ai09qi
         ctadLo2aK9TWd8xek9uVJhmjMn94UPUtMnk7zlWhZmq2v7trqe0Lvr2MtEh609NuWgjU
         nEeA==
X-Gm-Message-State: AOAM533oTRkqiKkpJXP/NbeFOGf0fLZ26z3mb6vww3TlUCth9tct9jFp
        cdhS5OWYAgHA6U2vhE2SkgYnEVOeuWf5eodoAGnTk+vLt6FozNPzXnmq6wFqkh0WU4nsVEFOLdD
        Xu1WzkCG/KhBp
X-Received: by 2002:a05:6602:2287:: with SMTP id d7mr396201iod.172.1624633476514;
        Fri, 25 Jun 2021 08:04:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykLBnseRJ8SVCOG9PNTCNmzYuFnbhdHat2QCpQc1VUeHNx8q/vYFTUcttHK5JlPW+Kds8bMw==
X-Received: by 2002:a05:6602:2287:: with SMTP id d7mr396188iod.172.1624633476337;
        Fri, 25 Jun 2021 08:04:36 -0700 (PDT)
Received: from redhat.com (c-73-14-100-188.hsd1.co.comcast.net. [73.14.100.188])
        by smtp.gmail.com with ESMTPSA id t21sm3314619ioj.10.2021.06.25.08.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 08:04:35 -0700 (PDT)
Date:   Fri, 25 Jun 2021 09:04:34 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>, <kwankhede@nvidia.com>
Subject: Re: [PATCH 1/1] vfio/iommu_type1: rename vfio_group struck to
 vfio_iommu_group
Message-ID: <20210625090434.657dbf06.alex.williamson@redhat.com>
In-Reply-To: <20210608112841.51897-1-mgurtovoy@nvidia.com>
References: <20210608112841.51897-1-mgurtovoy@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Jun 2021 14:28:41 +0300
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> The vfio_group structure is already defined in vfio module so in order
> to improve code readability and for simplicity, rename the vfio_group
> structure in vfio_iommu_type1 module to vfio_iommu_group.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 34 +++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 16 deletions(-)

Applied to vfio next branch for v5.14, sorry for the delayed notice.
Thanks,

Alex

