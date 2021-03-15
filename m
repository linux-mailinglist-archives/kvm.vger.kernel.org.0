Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D8633C4FC
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 18:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbhCOR5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 13:57:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34192 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233192AbhCOR50 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 13:57:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615831046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h+y0usr72Ee/zjTmbgFGxyDSJMLMasj+Kgfz5NATV/w=;
        b=ZwVfuCJYF4Jn4N8xU6jYIbU88LIpZyXGfGphunCLbsUZjVvPvXG9ONtxDm/8gdhfs4tYts
        p1MgEY1qoDZ6wNYZvTKNsU8k5mA9dJ0yqbYzqziPMohw5L/8/OKhmu5BCd35TtV47MrfJv
        /JO1yRuFmNjiQlJ/2XGapEZNI6iioog=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-2PQ3uPSWOJ2pTIZ1PdP8Qw-1; Mon, 15 Mar 2021 13:57:24 -0400
X-MC-Unique: 2PQ3uPSWOJ2pTIZ1PdP8Qw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37066881282;
        Mon, 15 Mar 2021 17:57:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.195.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 006295D9C0;
        Mon, 15 Mar 2021 17:57:14 +0000 (UTC)
Date:   Mon, 15 Mar 2021 18:57:11 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 00/11] GIC fixes and improvements
Message-ID: <20210315175711.qs3ksosr7smtjgs6@kamzik.brq.redhat.com>
References: <20210219121337.76533-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219121337.76533-1-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 19, 2021 at 12:13:26PM +0000, Alexandru Elisei wrote:
> What started this series is Andre's SPI and group interrupts tests [1],
> which prompted me to attempt to rewrite check_acked() so it's more flexible
> and not so complicated to review. When I was doing that I noticed that the
> message passing pattern for accesses to the acked, bad_irq and bad_sender
> arrays didn't look quite right, and that turned into the first 7 patches of
> the series. Even though the diffs are relatively small, they are not
> trivial and the reviewer can skip them for the more palatable patches that
> follow. I would still appreciate someone having a look at the memory
> ordering fixes.
> 
> Patch #8 ("Split check_acked() into two functions") is where check_acked()
> is reworked with an eye towards supporting different timeout values or
> silent reporting without adding too many arguments to check_acked().
> 
> After changing the IPI tests, I turned my attention to the LPI tests, which
> followed the same memory synchronization patterns, but invented their own
> interrupt handler and testing functions. Instead of redoing the work that I
> did for the IPI tests, I decided to convert the LPI tests to use the same
> infrastructure.
>

Applied to arm/queue

https://gitlab.com/rhdrjones/kvm-unit-tests/-/tree/arm/queue

Thanks,
drew

