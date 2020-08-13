Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3767824376F
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 11:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgHMJOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 05:14:30 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58634 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726048AbgHMJO3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 05:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597310068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Z5XW7mWY8zQjZYUVfkbmt75rJ+EgHpK68scfbUtXRs=;
        b=V4NewsJ1FgQDnnoubTrP3JBK4u8yzJ73Bf5eTNN2JuFxhXjDIKnXZ5xafoF8FbeHiNju3e
        qn9Y6pchLOJFkvj/L70IdSe2Ev8q5VQayX24e0U8UfxOvMWOdG1Sysr8XDlDLfQgb/4PBU
        waQs6OI7C68kdLtNvkmt2oOwgXVBnaQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-j--nvjLKM0uRSgYCMAAlfw-1; Thu, 13 Aug 2020 05:14:25 -0400
X-MC-Unique: j--nvjLKM0uRSgYCMAAlfw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBE46E91A;
        Thu, 13 Aug 2020 09:14:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E1F3219D7B;
        Thu, 13 Aug 2020 09:14:20 +0000 (UTC)
Date:   Thu, 13 Aug 2020 11:14:17 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peng Liang <liangpeng10@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, zhang.zhanghailiang@huawei.com,
        kvm@vger.kernel.org, maz@kernel.org, will@kernel.org
Subject: Re: [RFC 0/4] kvm: arm64: emulate ID registers
Message-ID: <20200813091417.othxkpko42y3thr4@kamzik.brq.redhat.com>
References: <20200813060517.2360048-1-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813060517.2360048-1-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 02:05:13PM +0800, Peng Liang wrote:
> In AArch64, guest will read the same values of the ID regsiters with
> host.  Both of them read the values from arm64_ftr_regs.  This patch
> series add support to emulate and configure ID registers so that we can
> control the value of ID registers that guest read.
> 
> Peng Liang (4):
>   arm64: add a helper function to traverse arm64_ftr_regs
>   kvm: arm64: emulate the ID registers
>   kvm: arm64: make ID registers configurable
>   kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension
> 
>  arch/arm64/include/asm/cpufeature.h |  2 ++
>  arch/arm64/include/asm/kvm_host.h   |  2 ++
>  arch/arm64/kernel/cpufeature.c      | 13 ++++++++
>  arch/arm64/kvm/arm.c                | 21 ++++++++++++
>  arch/arm64/kvm/sys_regs.c           | 50 ++++++++++++++++++++++-------
>  include/uapi/linux/kvm.h            | 12 +++++++
>  6 files changed, 89 insertions(+), 11 deletions(-)
> 
> -- 
> 2.18.4
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>

Hi Peng,

I'm glad to see an effort has started in trying to prepare for CPU models,
allowing migration beyond identical hosts. How have you tested this
series? I.e. what userspace did you use and with what additional patches?
KVM changes like these are also easily tested with KVM selftests[*]. Have
you considered posting a selftest?

[*] Linux repo: tools/testing/selftests/kvm/

Thanks,
drew

