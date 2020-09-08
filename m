Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6453260F7A
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 12:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgIHKQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 06:16:05 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27452 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728828AbgIHKQC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 06:16:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599560161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mv11ZJIjPR3ewQkRWE9R7NV/KCoGwIh6nFYREmaN9/I=;
        b=FXUe6XjO3KDamf0sUj+1cCERtSINFf9Nln7vsEMIKEwkeuRhKBK7MJLokoLkblffNsRe6I
        vvSJQuEdUhyJqciYqq/5N6iXlqg49lzhmvdDx/7x+bMPPCKzWDEH1n8lbAHK+yzW133Vx/
        cifdQ6566LTin3KJX0KqhXmlQoVHhs4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-rCxIOhvXMwWqo_LAgRoOTQ-1; Tue, 08 Sep 2020 06:15:57 -0400
X-MC-Unique: rCxIOhvXMwWqo_LAgRoOTQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EE24802B60;
        Tue,  8 Sep 2020 10:15:55 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CF7675D9E2;
        Tue,  8 Sep 2020 10:15:53 +0000 (UTC)
Date:   Tue, 8 Sep 2020 12:15:50 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com, graf@amazon.com,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 3/5] KVM: arm64: Add PMU event filtering infrastructure
Message-ID: <20200908101550.mve4ibscf2rvam6t@kamzik.brq.redhat.com>
References: <20200908075830.1161921-1-maz@kernel.org>
 <20200908075830.1161921-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908075830.1161921-4-maz@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 08, 2020 at 08:58:28AM +0100, Marc Zyngier wrote:
> It can be desirable to expose a PMU to a guest, and yet not want the
> guest to be able to count some of the implemented events (because this
> would give information on shared resources, for example.
> 
> For this, let's extend the PMUv3 device API, and offer a way to setup a
> bitmap of the allowed events (the default being no bitmap, and thus no
> filtering).
> 
> Userspace can thus allow/deny ranges of event. The default policy
> depends on the "polarity" of the first filter setup (default deny if the
> filter allows events, and default allow if the filter denies events).
> This allows to setup exactly what is allowed for a given guest.
> 
> Note that although the ioctl is per-vcpu, the map of allowed events is
> global to the VM (it can be setup from any vcpu until the vcpu PMU is
> initialized).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  5 +++
>  arch/arm64/include/uapi/asm/kvm.h | 16 +++++++
>  arch/arm64/kvm/arm.c              |  2 +
>  arch/arm64/kvm/pmu-emul.c         | 70 ++++++++++++++++++++++++++++---
>  4 files changed, 87 insertions(+), 6 deletions(-)
> 

Reviewed-by: Andrew Jones <drjones@redhat.com>

