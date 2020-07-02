Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E2B212EE6
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 23:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgGBVdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 17:33:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47334 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725954AbgGBVde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 17:33:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593725613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0h1v1gqoiYvmFvRrxXEUuS8DGV7OpPpVRJ2+qA494c0=;
        b=ZFfexb1qFilaCVfqFB802qRTvGANiQQk38WOYY3HSN7V3oBdWJDCZZSQ2JXmsnkj3JlzmM
        OX0tQaO2u66owtjQdoKmv0svSrKramdRhfLQ5zeRwomd3eOjVuHrzFWrW6DSIKHW8L4jiP
        pURxTjJLFTrQyKZS9jFhs51qzd/Y4xo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-sOPfLPf9ON2iAjzy-rk44A-1; Thu, 02 Jul 2020 17:33:29 -0400
X-MC-Unique: sOPfLPf9ON2iAjzy-rk44A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 556CD186A200;
        Thu,  2 Jul 2020 21:33:28 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 497047610C;
        Thu,  2 Jul 2020 21:33:23 +0000 (UTC)
Date:   Thu, 2 Jul 2020 23:33:20 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Jingyi Wang <wangjingyi11@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add
 gicv4.1 support for ipi latency test.
Message-ID: <20200702213320.6okdtuesqkpz3c3t@kamzik.brq.redhat.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
 <087ef371-5e7b-e0b2-900f-67b2eacb4e0f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <087ef371-5e7b-e0b2-900f-67b2eacb4e0f@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 02, 2020 at 02:57:56PM +0200, Auger Eric wrote:
> Hi Jingyi,
> 
> On 7/2/20 5:01 AM, Jingyi Wang wrote:
> > If gicv4.1(sgi hardware injection) supported, we test ipi injection
> > via hw/sw way separately.
> > 
> > Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> > ---
> >  arm/micro-bench.c    | 45 +++++++++++++++++++++++++++++++++++++++-----
> >  lib/arm/asm/gic-v3.h |  3 +++
> >  lib/arm/asm/gic.h    |  1 +
> >  3 files changed, 44 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> > index fc4d356..80d8db3 100644
> > --- a/arm/micro-bench.c
> > +++ b/arm/micro-bench.c
> > @@ -91,9 +91,40 @@ static void gic_prep_common(void)
> >  	assert(irq_ready);
> >  }
> >  
> > -static void ipi_prep(void)
> > +static bool ipi_prep(void)
> Any reason why the bool returned value is preferred over the standard int?

Why would an int be preferred over bool if the return is boolean?

Thanks,
drew

