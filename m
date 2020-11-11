Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558382AEFCF
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 12:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgKKLkd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 06:40:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43190 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726200AbgKKLkc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Nov 2020 06:40:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605094831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I/wpgYWhpH7GPsEBZsn8FF2DzrE1Wh34I4AjHUEjxTw=;
        b=HhM/ZA1XFiPk2U8xIArAWzlEvy3HuBuWnksDq8lYWhkJ2oA0tH96rVSlzUV1WFGsWCPAGK
        PbGEoEzKiOst7w9I8YGjU4y6cjcVpnccyBJgq8XXgtrUhGdbX+LNnrYhPJyG2cEe14YvnN
        7Jj2JlInKM9dWCFB9askMez/xGP9L5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-Xjd614ydMhSD_QwH-Bddvw-1; Wed, 11 Nov 2020 06:40:24 -0500
X-MC-Unique: Xjd614ydMhSD_QwH-Bddvw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B51B10074B1;
        Wed, 11 Nov 2020 11:40:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.216])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A5C75B4D4;
        Wed, 11 Nov 2020 11:40:21 +0000 (UTC)
Date:   Wed, 11 Nov 2020 12:40:18 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, mark.rutland@arm.com, jade.alglave@arm.com,
        luc.maranget@inria.fr, andre.przywara@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 0/2] arm: MMU extentions to enable
 litmus7
Message-ID: <20201111114018.6qinxxvez2nclh7z@kamzik.brq.redhat.com>
References: <20201110180924.95106-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110180924.95106-1-nikos.nikoleris@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 10, 2020 at 06:09:22PM +0000, Nikos Nikoleris wrote:
> Hi all,
> 
> litmus7 [1][2], a tool that we develop and use to test the memory
> model on hardware, is building on kvm-unit-tests to encapsulate full
> system tests and control address translation. This series extends the
> kvm-unit-tests arm MMU API and adds two memory attributes to MAIR_EL1
> to make them available to the litmus tests.
> 
> [1]: http://diy.inria.fr/doc/litmus.html
> [2]: https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/expanding-memory-model-tools-system-level-architecture
> 
> v1: https://lore.kernel.org/kvm/20201102115311.103750-1-nikos.nikoleris@arm.com/T/
> v2: https://lore.kernel.org/kvm/20201110144207.90693-1-nikos.nikoleris@arm.com/T/#u
> 
> Changes in v3:
>   - Moved comment on break-before make
> 
> Changes in v2:
>   - Add comment on break-before-make in get_mmu_pte()
>   - Signed-off-by tag from all co-authors
>   - Minor formatting changes
> 
> Thanks,
> 
> Nikos
> 
> Luc Maranget (1):
>   arm: Add mmu_get_pte() to the MMU API
> 
> Nikos Nikoleris (1):
>   arm: Add support for the DEVICE_nGRE and NORMAL_WT memory types
> 
>  lib/arm/asm/mmu-api.h         |  1 +
>  lib/arm64/asm/pgtable-hwdef.h |  2 ++
>  lib/arm/mmu.c                 | 32 +++++++++++++++++++++-----------
>  arm/cstart64.S                |  6 +++++-
>  4 files changed, 29 insertions(+), 12 deletions(-)
> 
> -- 
> 2.17.1
>

Applied, thanks. 

