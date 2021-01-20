Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641542FD720
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 18:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390623AbhATRdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 12:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728916AbhATR0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 12:26:04 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836BBC061575
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 09:25:21 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id j12so7759360pfj.12
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 09:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KEV7urkYywFz30FuSgPUexQkm0SddOC5wU2ZuJdovsU=;
        b=sr57Q262PncLhufam68Q0mV8eOPQ7ExS79JYjI+ZHriGoUATbSv/9nDq90xpK18aNf
         pCxA/BpoIyTFMKEMgeMaqxfykjcIfhDhyU+Lqq1rB9oHYW6hrQ3YgQsCGntE736yOoHJ
         aFV4CqtHbOUYY9WlD8psu6AqRHWQpMwEQbSFaXU2E5Z5OOyh1LXkp6tX8Fod3j7dJ8bg
         CFXSO6AiWTHqBAVuvXdpaZ3gv51iLaz1EtHGKdrGeHojP/Ca7LTJjAp4EGT0MtubT489
         crLCZiynhhULSVZyhmZsOIVF4vFtpNYrjnicg8Ywm4PPV/Uk6g1WQEn7h1rfeXQt7XuW
         WlMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KEV7urkYywFz30FuSgPUexQkm0SddOC5wU2ZuJdovsU=;
        b=GqbR/AsJJtirtk3jeefc1ee/QVLJsRPzHHpAVuahOLAL+CeknVDdm7Km85uW249Afm
         L2mMeW4TOYkqhEmdAhCkHXriYwVlMftvqX8r6rYs3R9pPG8b4rGveKsuJlh3QqOx9EtZ
         MLLTM83EH4LZOaCmo0B8r50GjHJxjKwHH65BOEJ6yu23w55HIHuLR8xU1uvJfvk0WQFl
         1CGzC9FvB5oIfD5QzvhHTTemEDjZiui8WMltpggzWL5wjQEvCY/v2UEifQSCjHbKmC8A
         HXfxvMTnAZtXfz9o2Y8WW6qYub6cUp3TTrFX36ObKpgp5rGEKt7dVwc/2tdfhfFOmM6c
         rOGA==
X-Gm-Message-State: AOAM531ltJuUp9dnMTPGGjWE/d8bNFUZ1WbhkQRLi9WRsr2Y+NiSxnBE
        f8nrIC792wu77nrB3SD5DNAqSd/5vav9MQ==
X-Google-Smtp-Source: ABdhPJyaLaEMz2h2kWJp0ZmiSxK3MBhqFbwJH1F8FXwtvkqOtwIB3I4cS5CAg+2WK3VRtFsr4QZJvA==
X-Received: by 2002:a63:3088:: with SMTP id w130mr10411646pgw.210.1611163520746;
        Wed, 20 Jan 2021 09:25:20 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id u4sm3010029pjv.22.2021.01.20.09.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 09:25:19 -0800 (PST)
Date:   Wed, 20 Jan 2021 09:25:13 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 3/4] KVM: Define KVM_USER_MEM_SLOTS in arch-neutral
 include/linux/kvm_host.h
Message-ID: <YAhnebWjQCOfLtJ0@google.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
 <20210115131844.468982-4-vkuznets@redhat.com>
 <YAHLRVhevn7adhAz@google.com>
 <87wnwa608c.fsf@vitty.brq.redhat.com>
 <YAcU6swvNkpPffE7@google.com>
 <20210120123400.7936e526@redhat.com>
 <87czxz6cl9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czxz6cl9.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 20, 2021, Vitaly Kuznetsov wrote:
> Igor Mammedov <imammedo@redhat.com> writes:
> 
> > On Tue, 19 Jan 2021 09:20:42 -0800
> > Sean Christopherson <seanjc@google.com> wrote:
> >
> >> 
> >> Were you planning on adding a capability to check for the new and improved
> >> memslots limit, e.g. to know whether or not KVM might die on a large VM?
> >> If so, requiring the VMM to call an ioctl() to set a higher (or lower?) limit
> >> would be another option.  That wouldn't have the same permission requirements as
> >> a module param, but it would likely be a more effective safeguard in practice,
> >> e.g. use cases with a fixed number of memslots or a well-defined upper bound
> >> could use the capability to limit themselves.
> > Currently QEMU uses KVM_CAP_NR_MEMSLOTS to get limit, and depending on place the
> > limit is reached it either fails gracefully (i.e. it checks if free slot is
> > available before slot allocation) or aborts (in case where it tries to allocate
> > slot without check).
> 
> FWIW, 'synic problem' causes it to abort.
> 
> > New ioctl() seems redundant as we already have upper limit check
> > (unless it would allow go over that limit, which in its turn defeats purpose of
> > the limit).

Gah, and I even looked for an ioctl().  No idea how I didn't find NR_MEMSLOTS.

> Right, I didn't plan to add any new CAP as what we already have should
> be enough to query the limits. Having an ioctl to set the upper limit
> seems complicated: with device and CPU hotplug it may not be easy to
> guess what it should be upfront so VMMs will likely just add a call to
> raise the limit in memslot modification code so it won't be providing
> any new protection.

True.  Maybe the best approach, if we want to make the limit configurable, would
be to make a lower limit opt-in.  I.e. default=KVM_CAP_NR_MEMSLOTS=SHRT_MAX,
with an ioctl() to set a lower limit.  That would also allow us to defer adding
a new ioctl() until someone actually plans on using it.

> >> Thoughts?  An ioctl() feels a little over-engineered, but I suspect that adding
> >> a module param that defaults to N*KVM_MAX_VPCUS will be a waste, e.g. no one
> >> will ever touch the param and we'll end up with dead, rarely-tested code.
> 
> Alternatively, we can hard-code KVM_USER_MEM_SLOTS to N*KVM_MAX_VPCUS so
> no new parameter is needed but personally, I'd prefer to have it
> configurable (in case we decide to set it to something lower than
> SHRT_MAX of course) even if it won't be altered very often (which is a
> good thing for 'general purpose' usage, right?).
>
> First, it will allow tightening the limit for some very specific deployments
> (e.g. FaaS/ Firecracker-style) to say '20' which should be enough.

A module param likely isn't usable for many such deployments though, as it would
require a completely isolated pool of systems.  That's why an ioctl() is
appealing; the expected number of memslots is a property of the VM, not of the
platform.

> Second, we may be overlooking some configurations where the number of
> memslots is actually dependent on the number of vCPUs but nobody complained
> so far just because these configutrarions use a farly small number and the
> ceiling wasn't hit yet.
> 
> One more spare thought. Per-vCPU memslots may come handy if someone
> decides to move some of the KVM PV features to userspace. E.g. I can
> imagine an attempt to move async_pf out of kernel.

Memslots aren't per-vCPU though, any userspace feature that tries to treat them
as such will be flawed in some way.  Practically speaking, per-vCPU memslots
just aren't feasible, at least not without KVM changes that are likely
unpalatable, e.g. KVM would need to incorporate the existence of a vCPU specific
memslot into the MMU role.
