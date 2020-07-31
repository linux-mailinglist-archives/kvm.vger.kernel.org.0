Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AB223450B
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 14:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732859AbgGaMBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 08:01:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54034 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732771AbgGaMBc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 08:01:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596196891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1lZyrqI3xLbFTyVC9E3z5frdUks/QZNq3MxuxGz/sbI=;
        b=L8vKXBi5C/hwbTaL2Ma76FqkhB4+o/nQKzxUArw5W4waD5Y4S+FaH+HmjfDjYaoN4EjdWU
        t4x5li+4KwxshppcFjhJ0A4r6QkFMurZHRo1LPWJ0Kin0tnCqajZAGR4YnGUajT24nHYiI
        q5mI3HCcVTdPM7zb4TfxVb0Iyg0J04E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-bPznMw3cPcSTHCPxHfRF7g-1; Fri, 31 Jul 2020 08:01:24 -0400
X-MC-Unique: bPznMw3cPcSTHCPxHfRF7g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EEA0102C84B;
        Fri, 31 Jul 2020 12:01:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.209])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C57619C58;
        Fri, 31 Jul 2020 12:01:20 +0000 (UTC)
Date:   Fri, 31 Jul 2020 14:01:17 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Jingyi Wang <wangjingyi11@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com,
        eric.auger@redhat.com, prime.zeng@hisilicon.com
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm/arm64: Add IPI/LPI/vtimer
 latency test
Message-ID: <20200731120117.5kk22hx2wpbt6kpz@kamzik.brq.redhat.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731074244.20432-1-wangjingyi11@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 31, 2020 at 03:42:34PM +0800, Jingyi Wang wrote:
> With the development of arm gic architecture, we think it will be useful
> to add some performance test in kut to measure the cost of interrupts.
> In this series, we add GICv4.1 support for ipi latency test and
> implement LPI/vtimer latency test.
> 
> This series of patches has been tested on GICv4.1 supported hardware.
> 
> Note:
> Based on patch "arm/arm64: timer: Extract irqs at setup time",
> https://www.spinics.net/lists/kvm-arm/msg41425.html
> 
> * From v2:
>   - Code and commit message cleanup
>   - Clear nr_ipi_received before ipi_exec() thanks for Tao Zeng's review
>   - rebase the patch "Add vtimer latency test" on Andrew's patch

It'd be good if you'd reposted my patch along with this series, since we
didn't merge mine yet either. Don't worry about now, though, I'll pick it
up the same time I pick up this series, which I plan to do later today
or tomorrow.

Getting this series applied will allow me to try out our new and shiny
gitlab repo :-)

Thanks,
drew

>   - Add test->post() to get actual PPI latency
> 
> * From v1:
>   - Fix spelling mistake
>   - Use the existing interface to inject hw sgi to simply the logic
>   - Add two separate patches to limit the running times and time cost
>     of each individual micro-bench test
> 
> Jingyi Wang (10):
>   arm64: microbench: get correct ipi received num
>   arm64: microbench: Generalize ipi test names
>   arm64: microbench: gic: Add ipi latency test for gicv4.1 support kvm
>   arm64: its: Handle its command queue wrapping
>   arm64: microbench: its: Add LPI latency test
>   arm64: microbench: Allow each test to specify its running times
>   arm64: microbench: Add time limit for each individual test
>   arm64: microbench: Add vtimer latency test
>   arm64: microbench: Add test->post() to further process test results
>   arm64: microbench: Add timer_post() to get actual PPI latency
> 
>  arm/micro-bench.c          | 256 ++++++++++++++++++++++++++++++-------
>  lib/arm/asm/gic-v3.h       |   3 +
>  lib/arm/asm/gic.h          |   1 +
>  lib/arm64/gic-v3-its-cmd.c |   3 +-
>  4 files changed, 219 insertions(+), 44 deletions(-)
> 
> -- 
> 2.19.1
> 
> 

