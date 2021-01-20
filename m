Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DAC2FD187
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 14:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730455AbhATMwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:52:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388830AbhATMIH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 07:08:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611144361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5jvxuRn0YU0JO8tuZ8pE07JWOeovxrqrENgeb7cNLSg=;
        b=FE4VOBLaFApxc7P1WOI3y/InxDaXVHBPT8UiqGDniWwyWgZ9Z1E+PTsJXkFFsNNl9LeuoI
        rE9/WBnvMFgai1XtnTB34RLHLGJyDEvNriziG4DhYIMFycDxc+V/V1wC6t6yH8mFWb+3lG
        xn2lPV9X+rJpSESiephvZGlRrES9C80=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-l2jDMnz7OzCHwTo75B_tUw-1; Wed, 20 Jan 2021 07:02:12 -0500
X-MC-Unique: l2jDMnz7OzCHwTo75B_tUw-1
Received: by mail-ed1-f72.google.com with SMTP id x13so10996494edi.7
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 04:02:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5jvxuRn0YU0JO8tuZ8pE07JWOeovxrqrENgeb7cNLSg=;
        b=MDB23RIteyu5GDYZE/jvPptFYbyh6oMQRf3CzFokqIbbd7v6wCh/fw7vT3V05rIBlD
         wd3mGrW79judE1V0SePNKXHJVGAG+dnJIDQ8OdZZ4m0xz6LiBt+sMncHUt3lWX3K4VE7
         I0CeGlVhiwW4P/thi0yppkG90sgQJdpmOTWpPYCq9BAeI08h7fYgb2nuCmZUv9Ey0wBM
         BApSxtVYjwyMuS8ypBupvRRvmhsUzN+c6fMOotNWIxnWMz+etM+XTaOyZSyN93cV3y8z
         wpdRaAhMkfZQCJ8mvQlfLV8G3xK+5zgdTW9KZT3/FG5ir5/SyYRsZdGANkCEBjP9mvts
         ED5g==
X-Gm-Message-State: AOAM531U5f/K7c9CFrUNBPksNkinu+ENcBuyGo39osc6iNGBO9VWLO+R
        Nfo11Ki+uCg8wkKep97ofoCyS8Y6ybe3dYrT77KxCLnTVR1UfOmjfqadNZXG91EPOP/APOlTgcP
        +kJ19mmIZzhmg
X-Received: by 2002:a50:8741:: with SMTP id 1mr7136778edv.349.1611144131695;
        Wed, 20 Jan 2021 04:02:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwetmZPv/Yzf+l32kyHUa0LwOF173Aj0pARmd5lEX7ZZJ+tmpDG4EYiotb/PrgSYTg9sg5O6A==
X-Received: by 2002:a50:8741:: with SMTP id 1mr7136765edv.349.1611144131488;
        Wed, 20 Jan 2021 04:02:11 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m10sm976865edi.54.2021.01.20.04.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 04:02:10 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Igor Mammedov <imammedo@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 3/4] KVM: Define KVM_USER_MEM_SLOTS in arch-neutral
 include/linux/kvm_host.h
In-Reply-To: <20210120123400.7936e526@redhat.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
 <20210115131844.468982-4-vkuznets@redhat.com>
 <YAHLRVhevn7adhAz@google.com> <87wnwa608c.fsf@vitty.brq.redhat.com>
 <YAcU6swvNkpPffE7@google.com> <20210120123400.7936e526@redhat.com>
Date:   Wed, 20 Jan 2021 13:02:10 +0100
Message-ID: <87czxz6cl9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Igor Mammedov <imammedo@redhat.com> writes:

> On Tue, 19 Jan 2021 09:20:42 -0800
> Sean Christopherson <seanjc@google.com> wrote:
>
>> 
>> Were you planning on adding a capability to check for the new and improved
>> memslots limit, e.g. to know whether or not KVM might die on a large VM?
>> If so, requiring the VMM to call an ioctl() to set a higher (or lower?) limit
>> would be another option.  That wouldn't have the same permission requirements as
>> a module param, but it would likely be a more effective safeguard in practice,
>> e.g. use cases with a fixed number of memslots or a well-defined upper bound
>> could use the capability to limit themselves.
> Currently QEMU uses KVM_CAP_NR_MEMSLOTS to get limit, and depending on place the
> limit is reached it either fails gracefully (i.e. it checks if free slot is
> available before slot allocation) or aborts (in case where it tries to allocate
> slot without check).

FWIW, 'synic problem' causes it to abort.

> New ioctl() seems redundant as we already have upper limit check
> (unless it would allow go over that limit, which in its turn defeats purpose of
> the limit).
>

Right, I didn't plan to add any new CAP as what we already have should
be enough to query the limits. Having an ioctl to set the upper limit
seems complicated: with device and CPU hotplug it may not be easy to
guess what it should be upfront so VMMs will likely just add a call to
raise the limit in memslot modification code so it won't be providing
any new protection.


>> Thoughts?  An ioctl() feels a little over-engineered, but I suspect that adding
>> a module param that defaults to N*KVM_MAX_VPCUS will be a waste, e.g. no one
>> will ever touch the param and we'll end up with dead, rarely-tested code.

Alternatively, we can hard-code KVM_USER_MEM_SLOTS to N*KVM_MAX_VPCUS so
no new parameter is needed but personally, I'd prefer to have it
configurable (in case we decide to set it to something lower than
SHRT_MAX of course) even if it won't be altered very often (which is a
good thing for 'general purpose' usage, right?). First, it will allow
tightening the limit for some very specific deployments (e.g. FaaS/
Firecracker-style) to say '20' which should be enough. Second, we may be
overlooking some configurations where the number of memslots is actually
dependent on the number of vCPUs but nobody complained so far just
because these configutrarions use a farly small number and the ceiling
wasn't hit yet.

One more spare thought. Per-vCPU memslots may come handy if someone
decides to move some of the KVM PV features to userspace. E.g. I can
imagine an attempt to move async_pf out of kernel.

-- 
Vitaly

