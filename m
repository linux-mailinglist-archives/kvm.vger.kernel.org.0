Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EA42FBD74
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 18:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbhASRWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 12:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391204AbhASRVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 12:21:33 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69407C061573
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 09:20:50 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id n25so13379584pgb.0
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 09:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J0uSoN1AfaAsXJhMy1zQ5aoXw+M+V0sWoxE6+SmahqM=;
        b=uvEe7xNzGxYdp2sJTqM0H7Sg6a/lFkvDkHwVo0Wz+we54kC+3wi5RwCiVZLmfBBxAT
         jzD3v+F+sDTP9O/XeynK3QQ2woidOXj23AADel77V7McK3ezKRjH/j0DRWxKa965vYjI
         bqHV3tqo2hq0A6kTHA2VMPeCcSev+CiDuUcfrb0eXMgKlt1MPEz6rRSLgti0JJ0wjssf
         qKXt30hHuHii2kih1ej0Cs3Vmb/mZh5bv0gPRFSSORjYSceAdg0KKDKCSxjgaZan4kHN
         u3OxUuniuOHhb0xybMcOuU7WGVcLB9hDDPM3BPGKEBI1cGl6oZtZLBgII4O5pkts1YdI
         uVng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J0uSoN1AfaAsXJhMy1zQ5aoXw+M+V0sWoxE6+SmahqM=;
        b=JuuiMMnyNUxQelp51WkpSNePpXJgZXl8yrwGgM6KaSVZd79dNgvZ0Jwqxs8Il9YPj0
         Uzzd/LUH+xbMumWl9BAwtJL2M3VJDQp32+kGobv0ZWC3nL2K3va1mWsiqT5E1Dioa6hj
         qHIcH+5nvto78VGJfUXuoEBo7HLOHX5IeQR9bQfLwzFA+8QFLcTpbsEpnYmPK8PzmhhB
         mBFV5+k2zN1bFcZCffzMfIwOqM2N8az7Ah3tEL7jCuTcmcOF5WENKRm+ONOSvs6Ndv47
         j0RSvdUvAh5i3so0xP3ADH0SQG0xkZCwgZiAQbaNKOkn/j6YNfOcObRdXtCxxyHBNoRq
         0WUw==
X-Gm-Message-State: AOAM53085yRMdjXegOtMBCys8P+pB+1HFILr7NNS+slpnIuyJY7KaKbn
        KYNzPwQYWBDiymLGh5t5bxhORA==
X-Google-Smtp-Source: ABdhPJz1W8nBYwqvF1FKrvCsRUGFRoVfg9OzhA5Ub4+ApV0M6NvZDLkVZcTpc+xdQFkBzrBEfFxy5g==
X-Received: by 2002:a63:e049:: with SMTP id n9mr5309464pgj.339.1611076849830;
        Tue, 19 Jan 2021 09:20:49 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id q2sm5574995pfg.190.2021.01.19.09.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 09:20:49 -0800 (PST)
Date:   Tue, 19 Jan 2021 09:20:42 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 3/4] KVM: Define KVM_USER_MEM_SLOTS in arch-neutral
 include/linux/kvm_host.h
Message-ID: <YAcU6swvNkpPffE7@google.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
 <20210115131844.468982-4-vkuznets@redhat.com>
 <YAHLRVhevn7adhAz@google.com>
 <87wnwa608c.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wnwa608c.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Fri, Jan 15, 2021, Vitaly Kuznetsov wrote:
> >> Memory slots are allocated dynamically when added so the only real
> >> limitation in KVM is 'id_to_index' array which is 'short'. Define
> >> KVM_USER_MEM_SLOTS to the maximum possible value in the arch-neutral
> >> include/linux/kvm_host.h, architectures can still overtide the setting
> >> if needed.
> >
> > Leaving the max number of slots nearly unbounded is probably a bad idea.  If my
> > math is not completely wrong, this would let userspace allocate 6mb of kernel
> > memory per VM.  Actually, worst case scenario would be 12mb since modifying
> > memslots temporarily has two allocations.
> 
> Yea I had thought too but on the other hand, if your VMM went rogue and
> and is trying to eat all your memory, how is allocating 32k memslots
> different from e.g. creating 64 VMs with 512 slots each? We use
> GFP_KERNEL_ACCOUNT to allocate memslots (and other per-VM stuff) so
> e.g. cgroup limits should work ...

I see it as an easy way to mitigate the damage.  E.g. if a containers use case
is spinning up hundreds of VMs and something goes awry in the config, it would
be the difference between consuming tens of MBs and hundreds of MBs.  Cgroup
limits should also be in play, but defense in depth and all that. 

> > If we remove the arbitrary limit, maybe replace it with a module param with a
> > sane default?
> 
> This can be a good solution indeed. The only question then is what should
> we pick as the default? It seems to me this can be KVM_MAX_VCPUS
> dependent, e.g. 4 x KVM_MAX_VCPUS would suffice.

Hrm, I don't love tying it to KVM_MAX_VPUCS.  Other than SynIC, are there any
other features/modes/configuration that cause the number of memslots to grop
with the number of vCPUs?  But, limiting via a module param does effectively
require using KVM_MAX_VCPUS, otherwise everyone that might run Windows guests
would have to override the default and thereby defeat the purpose of limiting by
default.

Were you planning on adding a capability to check for the new and improved
memslots limit, e.g. to know whether or not KVM might die on a large VM?
If so, requiring the VMM to call an ioctl() to set a higher (or lower?) limit
would be another option.  That wouldn't have the same permission requirements as
a module param, but it would likely be a more effective safeguard in practice,
e.g. use cases with a fixed number of memslots or a well-defined upper bound
could use the capability to limit themselves.

Thoughts?  An ioctl() feels a little over-engineered, but I suspect that adding
a module param that defaults to N*KVM_MAX_VPCUS will be a waste, e.g. no one
will ever touch the param and we'll end up with dead, rarely-tested code.
