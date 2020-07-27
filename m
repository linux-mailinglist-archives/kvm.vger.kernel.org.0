Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A676422EAA1
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 13:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgG0LCf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 07:02:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59101 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727971AbgG0LCf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 07:02:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595847754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bhjm+k3ZKFy4jBT6oOZ6KaNSYOxpyHTbPoNoFYayimA=;
        b=iNk1DF57/z4nOOwknsqw0krE9LakSkllT9S1B/CkV3z3i5RuS5Tc7bzpjXjAdV0w+ryDgb
        kNoabom4Gk3icpntp4ob/xO/H8FFLMZgJn8P1MiU8lRF5FzqqaGAJBtRLVt/soVI7D8+hA
        gw9tI6FbyPKrn6w3w71iKop6iHiKuts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-LAev5u0sNhCroDOd5CsXbw-1; Mon, 27 Jul 2020 07:02:30 -0400
X-MC-Unique: LAev5u0sNhCroDOd5CsXbw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C917800597;
        Mon, 27 Jul 2020 11:02:29 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5361719C66;
        Mon, 27 Jul 2020 11:02:27 +0000 (UTC)
Date:   Mon, 27 Jul 2020 13:02:24 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, steven.price@arm.com
Subject: Re: [PATCH 0/5] KVM: arm64: pvtime: Fixes and a new cap
Message-ID: <20200727110224.vpsakrqaj2vm7g66@kamzik.brq.redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200711100434.46660-1-drjones@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Marc,

Ping?

Thanks,
drew


On Sat, Jul 11, 2020 at 12:04:29PM +0200, Andrew Jones wrote:
> The first three patches in the series are fixes that come from testing
> and reviewing pvtime code while writing the QEMU support (I'll reply
> to this mail with a link to the QEMU patches after posting - which I'll
> do shortly). The last patch is only a convenience for userspace, and I
> wouldn't be heartbroken if it wasn't deemed worth it. The QEMU patches
> I'll be posting are currently written without the cap. However, if the
> cap is accepted, then I'll change the QEMU code to use it.
> 
> Thanks,
> drew
> 
> Andrew Jones (5):
>   KVM: arm64: pvtime: steal-time is only supported when configured
>   KVM: arm64: pvtime: Fix potential loss of stolen time
>   KVM: arm64: pvtime: Fix stolen time accounting across migration
>   KVM: Documentation minor fixups
>   arm64/x86: KVM: Introduce steal-time cap
> 
>  Documentation/virt/kvm/api.rst    | 20 ++++++++++++++++----
>  arch/arm64/include/asm/kvm_host.h |  2 +-
>  arch/arm64/kvm/arm.c              |  3 +++
>  arch/arm64/kvm/pvtime.c           | 31 +++++++++++++++----------------
>  arch/x86/kvm/x86.c                |  3 +++
>  include/linux/kvm_host.h          | 19 +++++++++++++++++++
>  include/uapi/linux/kvm.h          |  1 +
>  7 files changed, 58 insertions(+), 21 deletions(-)
> 
> -- 
> 2.25.4
> 

