Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB5D15FD41
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2020 08:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgBOHBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Feb 2020 02:01:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32344 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725799AbgBOHBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Feb 2020 02:01:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581750111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l7wUMy9Egruu5qJqfOZtroUm6Z8sbzo1YYRQ0H1qgcw=;
        b=dxhSJ61uPOhswIDuCj9oRvseVKf/3eueuVDVo8L+r+l4w7XduJeyvQwtEfSHwLCIsRUM3a
        RhdVY4YjZv1jzqqZpsYRmbUOZpPpOgFkbcctx6osxvFWv56JMuUGQyJtWnHPaQs1xCEqFx
        SXS7Hj5BQ4iInJtGHfV72gOeUaHF1cw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-k7BnYw-COzCDfMOmSNeV9A-1; Sat, 15 Feb 2020 02:01:49 -0500
X-MC-Unique: k7BnYw-COzCDfMOmSNeV9A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C83D818A5505;
        Sat, 15 Feb 2020 07:01:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A5D5C1001B2D;
        Sat, 15 Feb 2020 07:01:43 +0000 (UTC)
Date:   Sat, 15 Feb 2020 08:01:40 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        alexandru.elisei@arm.com, andre.przywara@arm.com,
        eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests v3] arm64: timer: Speed up gic-timer-state
 check
Message-ID: <20200215070140.k4h3yki46rhsjdbj@kamzik.brq.redhat.com>
References: <20200213093257.23367-1-drjones@redhat.com>
 <cb4b85c1-7b25-f930-f09d-3ef86bc33930@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb4b85c1-7b25-f930-f09d-3ef86bc33930@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 15, 2020 at 11:41:46AM +0800, Zenghui Yu wrote:
> Hi Drew,
> 
> On 2020/2/13 17:32, Andrew Jones wrote:
> > Let's bail out of the wait loop if we see the expected state
> > to save over six seconds of run time. Make sure we wait a bit
> > before reading the registers and double check again after,
> > though, to somewhat mitigate the chance of seeing the expected
> > state by accident.
> > 
> > We also take this opportunity to push more IRQ state code to
> > the library.
> > 
> > Cc: Zenghui Yu <yuzenghui@huawei.com>
> 
> Please feel free to replace this with:
> 
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> Tested-by: Zenghui Yu <yuzenghui@huawei.com>

Done. Thanks!

drew

> 
> > Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> 
> Thanks
> 

