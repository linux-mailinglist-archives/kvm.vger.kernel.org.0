Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2A519AB99
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 14:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732333AbgDAMY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 08:24:58 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22346 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726804AbgDAMY6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Apr 2020 08:24:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585743897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MC/MjZfh7TLCzD5LcVQ13kaOfc4HlhwLTdXB+ga+Cao=;
        b=CByQabd6RCTdoFMfWEY/643yvxd3KAD11VQhUE7HiAVqeCrXzOvV3AttPuGrGOlBOBvzqv
        AtYhKEe+QK585vR1GaWGxfwazwVMQL5ey7GDg+qAb+Ox+RdbIKSsmlCYMtbv7KrS7nU6fh
        CcpJX6zr1LcMxKI+TYmG0DQa4JM9838=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-NbG52YPFNSWV1xleqSh0Qw-1; Wed, 01 Apr 2020 08:24:54 -0400
X-MC-Unique: NbG52YPFNSWV1xleqSh0Qw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19DAE8017F3;
        Wed,  1 Apr 2020 12:24:53 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A198F5D9CD;
        Wed,  1 Apr 2020 12:24:50 +0000 (UTC)
Date:   Wed, 1 Apr 2020 14:24:45 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Jingyi Wang <wangjingyi11@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Subject: Re: [kvm-unit-tests PATCH 0/2] arm/arm64: Add IPI/vtimer latency
Message-ID: <20200401122445.exyobwo3a3agnuhk@kamzik.brq.redhat.com>
References: <20200401100812.27616-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401100812.27616-1-wangjingyi11@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 01, 2020 at 06:08:10PM +0800, Jingyi Wang wrote:
> With the development of arm gic architecture, we think it will be useful
> to add some simple performance test in kut to measure the cost of
> interrupts. X86 arch has implemented similar test.
> 
> Jingyi Wang (2):
>   arm/arm64: gic: Add IPI latency test
>   arm/arm64: Add vtimer latency test
> 
>  arm/gic.c   | 27 +++++++++++++++++++++++++++
>  arm/timer.c | 11 +++++++++++
>  2 files changed, 38 insertions(+)
> 
> -- 
> 2.19.1
> 
>

Hi Jingyi,

We already have an IPI latency test in arm/micro-bench.c I'd prefer that
one be used, if possible, rather than conflating the gic functional tests
with latency tests. Can you take a look at it and see if it satisfies
your needs, extending it if necessary?

Thanks,
drew

