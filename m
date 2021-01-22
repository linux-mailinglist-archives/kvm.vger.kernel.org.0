Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F7A301009
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 23:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbhAVTws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 14:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730704AbhAVTbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 14:31:43 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7EBBC061797
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 11:30:11 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 30so4483390pgr.6
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 11:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Utt5iy2TzAUJ/756XPWC+D3jaxir23eilVEX8ks83/0=;
        b=BrtPgIquyOW8LybrzVpeRvOnH8V9jJrMvM7XdFJlSoeVfToMWjUdBZyxYdkaqd6kPo
         6dqv+z6nUtDKbJZVkoQ4ig/Lm2kh+tZuUgkQs7Nmm9wbVlQwa8uF1AITyEeChd21blr9
         KferVuY882YisHGoQIcLxqcUDYmDt+MODm/KM0y43rZB+KWcnl6+FdefB/gfeFkozZaN
         NOWVjecmz7N8fjwrQyVmFnF8JZSfiGYGJQXYYASQ3TiQF1X5g0kp3XvnkxCn04Gu0cip
         pWWvf3CKCPBr3UuNFe21nAWJ+Tn8KjO8ACytCsuwJ1ATizlo/JMXyw68N2B0hISD/OFh
         3dCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Utt5iy2TzAUJ/756XPWC+D3jaxir23eilVEX8ks83/0=;
        b=clu8WkwRrXaRwmmt1iu4YSMxI8XPjTMbmmA1h38lUy2ZDkjGTBGfO1RVEUizzLOzAB
         /v0vxzPoCRn1aRMnx15Ire/Vehfo2xn/1XyvLQSfToMEV4nGNlqLrgeiqzURzCfv52rb
         eYhFdLaRVouKIbprtN8ZRgNryGc8YYxhGQnUL7yCDbhsuOvjspIGcAqWbU6zmqQ39ycx
         0UNLZre4yXuMz5WGpyI6fIvbwhgKXIarmGc5XNcmGaq7NrDwhmDfIPgYGvlGb5SbyW2x
         qtYmyNyBQ5/lkvk0dNcwaXrjx0TnCsM2A7FukmemPQs5TEzh3X2jB+XlUJMpQlc3yptu
         Yf4g==
X-Gm-Message-State: AOAM531NIjTI7qrzY53n9/hm4eOwRs/zUPDUWdpjKDNqK0Jd1UmrfDiT
        URfJGwwaL+re8bf3rjGVUt+BPg==
X-Google-Smtp-Source: ABdhPJwn9+1DI6LEvfbdjtI1i5qr0yavW53mXGU2t6h6IJ3mnYOVHlO12ZIzEntdHsfEY5M8B0zXQQ==
X-Received: by 2002:aa7:8815:0:b029:1bc:93cc:d6fa with SMTP id c21-20020aa788150000b02901bc93ccd6famr6535574pfo.26.1611343811249;
        Fri, 22 Jan 2021 11:30:11 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id ga4sm10108831pjb.53.2021.01.22.11.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 11:30:10 -0800 (PST)
Date:   Fri, 22 Jan 2021 11:30:04 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Alex Shi <alex.shi@linux.alibaba.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, yj226063@alibaba-inc.com
Subject: Re: 3 preempted variables in kvm
Message-ID: <YAsnvA1Q5AlXLd1W@google.com>
References: <b6398228-31b9-ca84-873b-4febbd37c87d@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6398228-31b9-ca84-873b-4febbd37c87d@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 22, 2021, Alex Shi wrote:
> Hi All,
> 
> I am newbie on KVM side, so probably I am wrong on the following.
> Please correct me if it is.
> 
> There are 3 preempted variables in kvm:
>      1, kvm_vcpu.preempted  in include/linux/kvm_host.h
>      2, kvm_steal_time.preempted
>      3, kvm_vcpu_arch.st.preempted in arch/x86
> Seems all of them are set or cleared at the same time. Like,

Not quite.  kvm_vcpu.preempted is set only in kvm_sched_out(), i.e. when the
vCPU was running and preempted by the host scheduler.  This is used by KVM when
KVM detects that a guest task appears to be waiting on a lock, in which case KVM
will bump the priority of preempted guest kernel threads in the hope that
scheduling in the preempted vCPU will release the lock.

kvm_steal_time.preempted is a paravirt struct that is shared with the guest.  It
is set on any call to kvm_arch_vcpu_put(), which covers kvm_sched_out() and adds
the case where the vCPU exits to userspace, e.g. for IO.  KVM itself hasn't been
preempted, but from the guest's perspective the CPU has been "preempted" in the
sense that CPU (from the guest's perspective) is not executing guest code.
Similar to KVM's vCPU scheduling heuristics, the guest kernel uses this info to
inform its scheduling, e.g. to avoid waiting on a lock owner to drop the lock
since the lock owner is not actively running.

kvm_vcpu_arch.st.preempted is effectively a host-side cache of
kvm_steal_time.preempted that's used to optimize kvm_arch_vcpu_put() by avoiding
the moderately costly mapping of guest.  It could be dropped, but it's a single
byte per vCPU so worth keeping even if the performance benefits are modest.

> vcpu_put:
>         kvm_sched_out()-> set 3 preempted
>                 kvm_arch_vcpu_put():
>                         kvm_steal_time_set_preempted
> 
> vcpu_load:
>         kvm_sched_in() : clear above 3 preempted
>                 kvm_arch_vcpu_load() -> kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
>                 request dealed in vcpu_enter_guest() -> record_steal_time
> 
> Except the 2nd one reuse with KVM_FEATURE_PV_TLB_FLUSH bit which could be used
> separately, Could we combine them into one, like just bool kvm_vcpu.preempted? and 
> move out the KVM_FEATURE_PV_TLB_FLUSH. Believe all arch need this for a vcpu overcommit.

Moving KVM_VCPU_FLUSH_TLB out of kvm_steal_time.preempted isn't viable. The
guest kernel is only allowed to rely on the host to flush the vCPU's TLB if it
knows the vCPU is preempted (from its perspective), as that's the only way it
can guarantee that KVM will observe the TLB flush request before enterring the
vCPU.  KVM_VCPU_FLUSH_TLB and KVM_VCPU_PREEMPTED need to be in the same word so
KVM can read and clear them atomically, otherwise there would be a window where
KVM would miss the flush request.
