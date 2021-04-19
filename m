Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F553646BE
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 17:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238119AbhDSPJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 11:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbhDSPJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 11:09:36 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54720C061761
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 08:09:06 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id i190so23371254pfc.12
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 08:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hANO9FC/Eqy7x+FqUY+Eg+GK+A5D7OA8qqUpVhz6pBc=;
        b=kdJeLy959fNOuKxiroQcVOpawxEafqWiFZUUkpHihGfEQxevL2br8jYADTI99Hlkt0
         pxi48YwShSMIGYOPYh19SRcKw0/qtKjHOQV5NZHG+GX3fdSH9rc/Ouut1LmJAMWfESyZ
         nSsqU7qb1XMvGLjaeScqMEfymOKRe3oFN5h9wviXivc2hQBA5q2ZPRZBFb9g2WqmQVK1
         G+Wz9+BBVFhBKwoL+EhblfYM+PcGh0+DJoIKjPWLd5d26fRiyKa1RFPaq72urIp3Mljh
         Jdv5YUWT0YTiUMer7shX5JYUHOCJczBMI1/0L4KbuH5uuYKPtWl6XvJtdLw4ASYwNnxq
         i1Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hANO9FC/Eqy7x+FqUY+Eg+GK+A5D7OA8qqUpVhz6pBc=;
        b=JFPDexq8wPMGL869OkV9KJahFvEBgQuYLNmRFEwQOUzzHrXmgEQPHEw1H0vyzUO37R
         J9j51Axx+xR2b0dnU/jU0JCVtrAMHNyDQROtmVeqyXz5/d26jVylK6HeQRuBMzj7xE10
         XNccLYSTu3ii3dVIxzrTWF8KuFLXZxFdK5Eq5lbRtndMcYt540sSLbFSyd1flWuuOHxR
         tE2Lnn9H1ysWinVM+c2txKg+pF5U+Xbw+QFM6zTQdjQYbqfPEQ6kV4XSFqKbM1y//2xV
         CsTBaOY6NMEB5f6JXOpy6X7deX+JHZaqxi/bwVZlBr+SFN5UssJkVZLPUdQ7CczY+fAM
         ESPg==
X-Gm-Message-State: AOAM533n6lBA2ciaBna63vFD82ZE6PV8nc69V/0fZJwIs2TpiEEwCB6f
        3/WdK90LESFx+jyStuermSQc7g==
X-Google-Smtp-Source: ABdhPJwnF3cebcgAyO34u1tO2FNSwVgIH4GUuQL1co2FTQ++bMbkjJe/dIdeNDuTNanEN/8E7oFanw==
X-Received: by 2002:a05:6a00:1687:b029:253:f417:4dba with SMTP id k7-20020a056a001687b0290253f4174dbamr20329863pfc.5.1618844945636;
        Mon, 19 Apr 2021 08:09:05 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id gt22sm14457236pjb.7.2021.04.19.08.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 08:09:05 -0700 (PDT)
Date:   Mon, 19 Apr 2021 15:09:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, Marc Zyngier <maz@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 09/10] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <YH2dDRBXJcbUcbLi@google.com>
References: <20210402005658.3024832-1-seanjc@google.com>
 <20210402005658.3024832-10-seanjc@google.com>
 <CANRm+Cwt9Xs=13r9E4YWOhcE6oEJXmVrkKrv_wQ5jMUkY8+Stw@mail.gmail.com>
 <2a7670e4-94c0-9f35-74de-a7d5b1504ced@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a7670e4-94c0-9f35-74de-a7d5b1504ced@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 19, 2021, Paolo Bonzini wrote:
> On 19/04/21 10:49, Wanpeng Li wrote:
> > I saw this splatting:
> > 
> >   ======================================================
> >   WARNING: possible circular locking dependency detected
> >   5.12.0-rc3+ #6 Tainted: G           OE
> >   ------------------------------------------------------
> >   qemu-system-x86/3069 is trying to acquire lock:
> >   ffffffff9c775ca0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0},
> > at: __mmu_notifier_invalidate_range_end+0x5/0x190
> > 
> >   but task is already holding lock:
> >   ffffaff7410a9160 (&kvm->mmu_notifier_slots_lock){.+.+}-{3:3}, at:
> > kvm_mmu_notifier_invalidate_range_start+0x36d/0x4f0 [kvm]
> 
> I guess it is possible to open-code the wait using a readers count and a
> spinlock (see patch after signature).  This allows including the
> rcu_assign_pointer in the same critical section that checks the number
> of readers.  Also on the plus side, the init_rwsem() is replaced by
> slightly nicer code.

Ugh, the count approach is nearly identical to Ben's original code.  Using a
rwsem seemed so clever :-/

> IIUC this could be extended to non-sleeping invalidations too, but I
> am not really sure about that.

Yes, that should be fine.

> There are some issues with the patch though:
> 
> - I am not sure if this should be a raw spin lock to avoid the same issue
> on PREEMPT_RT kernel.  That said the critical section is so tiny that using
> a raw spin lock may make sense anyway

If using spinlock_t is problematic, wouldn't mmu_lock already be an issue?  Or
am I misunderstanding your concern?

> - this loses the rwsem fairness.  On the other hand, mm/mmu_notifier.c's
> own interval-tree-based filter is also using a similar mechanism that is
> likewise not fair, so it should be okay.

The one concern I had with an unfair mechanism of this nature is that, in theory,
the memslot update could be blocked indefinitely.

> Any opinions?  For now I placed the change below in kvm/queue, but I'm
> leaning towards delaying this optimization to the next merge window.

I think delaying it makes sense.

> @@ -1333,9 +1351,22 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>  	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
>  	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
> -	down_write(&kvm->mmu_notifier_slots_lock);
> +	/*
> +	 * This cannot be an rwsem because the MMU notifier must not run
> +	 * inside the critical section.  A sleeping rwsem cannot exclude
> +	 * that.

How on earth did you decipher that from the splat?  I stared at it for a good
five minutes and was completely befuddled.

> +	 */
> +	spin_lock(&kvm->mn_invalidate_lock);
> +	prepare_to_rcuwait(&kvm->mn_memslots_update_rcuwait);
> +	while (kvm->mn_active_invalidate_count) {
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		spin_unlock(&kvm->mn_invalidate_lock);
> +		schedule();
> +		spin_lock(&kvm->mn_invalidate_lock);
> +	}
> +	finish_rcuwait(&kvm->mn_memslots_update_rcuwait);
>  	rcu_assign_pointer(kvm->memslots[as_id], slots);
> -	up_write(&kvm->mmu_notifier_slots_lock);
> +	spin_unlock(&kvm->mn_invalidate_lock);
>  	synchronize_srcu_expedited(&kvm->srcu);
> 
