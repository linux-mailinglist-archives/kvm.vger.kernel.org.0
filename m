Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE8E28D453
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 21:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732445AbgJMTVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 15:21:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726279AbgJMTVH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Oct 2020 15:21:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602616866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8nvgtXTquS8dzOFxzvVIFZBcvvmF0cQfNkdQi9WaUQQ=;
        b=VkhqX+b44kLWCXlvfiuVgrh+rYWOK/hd5Bm9//p9V/75EAVK50uXKBSV8aYWNLjtwCOhUE
        adBaP6jaWPK8hJjXvqCZKp1CUXwwICNrqpJjvoPuBhA57uxpb7g+z000uqPza5aEs6lU/k
        AnWvCNNfB+bxAEPD4P2qjUKBKkRhEME=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-zsrMlvLSP-e-lM1eucPdmg-1; Tue, 13 Oct 2020 15:21:04 -0400
X-MC-Unique: zsrMlvLSP-e-lM1eucPdmg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12F01802B7C;
        Tue, 13 Oct 2020 19:21:03 +0000 (UTC)
Received: from w520.home (ovpn-113-35.phx2.redhat.com [10.3.113.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B486127C21;
        Tue, 13 Oct 2020 19:21:02 +0000 (UTC)
Date:   Tue, 13 Oct 2020 13:21:02 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurentiu.tudor@nxp.com
Subject: Re: [PATCH v2] vfio/fsl-mc: Fixed vfio-fsl-mc driver compilation on
 32 bit
Message-ID: <20201013132102.57e431ba@w520.home>
In-Reply-To: <20201013150651.12808-1-diana.craciun@oss.nxp.com>
References: <20201013150651.12808-1-diana.craciun@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Oct 2020 18:06:51 +0300
Diana Craciun <diana.craciun@oss.nxp.com> wrote:

> The FSL_MC_BUS on which the VFIO-FSL-MC driver is dependent on
> can be compiled on other architectures as well (not only ARM64)
> including 32 bit architectures.
> Include linux/io-64-nonatomic-hi-lo.h to make writeq/readq used
> in the driver available on 32bit platforms.
> 
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---
> v1 --> v2
>  - Added prefix to patch description
> 
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index d009f873578c..80fc7f4ed343 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -13,6 +13,7 @@
>  #include <linux/vfio.h>
>  #include <linux/fsl/mc.h>
>  #include <linux/delay.h>
> +#include <linux/io-64-nonatomic-hi-lo.h>
>  
>  #include "vfio_fsl_mc_private.h"
>  

Thanks, applied and pushed to next.  Hopefully it's either this or the
merge ordering biting us with linux-next.  Thanks,

Alex

