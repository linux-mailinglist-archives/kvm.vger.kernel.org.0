Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70EAB158E75
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 13:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgBKM1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 07:27:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27837 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727975AbgBKM1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 07:27:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581424052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ysT/sqc3he5fQb0IpIsZCQAPVEhjziWFabIs8nDoWx4=;
        b=W2FU3IlIWRXkcdp6c0wr5tHhe98+nBD7JySaSh29TxASn/Bpnqt3iRRAD3nYxBjmzkoFeY
        ydefYxbdeI1uxZ8QT8CmhPRkJAhVWPcs8hdGZpl8iABuwqwwFAo2nBR/uIkQG9xWsMVSPc
        kHRtCmNPquxhaX0HXgj3nPtwoNHZgcQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-dXMUP2FnMC-m1e7pP-SFlg-1; Tue, 11 Feb 2020 07:27:28 -0500
X-MC-Unique: dXMUP2FnMC-m1e7pP-SFlg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C1E38017CC;
        Tue, 11 Feb 2020 12:27:27 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C837560C80;
        Tue, 11 Feb 2020 12:27:25 +0000 (UTC)
Date:   Tue, 11 Feb 2020 13:27:23 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        alexandru.elisei@arm.com, wanghaibin.wang@huawei.com
Subject: Re: [kvm-unit-tests PATCH 0/3] arm64: minor cleanups for timer test
Message-ID: <20200211122723.qrnjfnrmbwwdafhc@kamzik.brq.redhat.com>
References: <20200211083901.1478-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200211083901.1478-1-yuzenghui@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 04:38:58PM +0800, Zenghui Yu wrote:
> Hi Drew,
> 
> There's some minor cleanups which based on your arm/queue branch for
> the timer test.  Please consider taking them if they make the code
> a bit better :)
> 
> Thanks
> 
> Zenghui Yu (3):
>   arm/arm64: gic: Move gic_state enumeration to asm/gic.h
>   arm64: timer: Use the proper RDist register name in GICv3
>   arm64: timer: Use existing helpers to access counter/timers
> 
>  arm/timer.c          | 27 ++++++++++-----------------
>  lib/arm/asm/gic-v3.h |  4 ++++
>  lib/arm/asm/gic.h    |  7 +++++++
>  3 files changed, 21 insertions(+), 17 deletions(-)
> 
> -- 
> 2.19.1
> 
>

Applied, thanks


Also, I noticed that the timer tests now take over 8 seconds to run.
I have a patch that speeds that up that I'll send for review in
just a second.

drew 

