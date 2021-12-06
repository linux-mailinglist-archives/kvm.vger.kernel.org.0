Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6E846A2A3
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 18:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbhLFRXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 12:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234757AbhLFRXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 12:23:49 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C367C061746
        for <kvm@vger.kernel.org>; Mon,  6 Dec 2021 09:20:20 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id i63so22347979lji.3
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 09:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iXeiRDIeMgIJ3QlhrfyzJaMD9KCCg6J0jEvMuAkTCAg=;
        b=n6yX3UhTRXg3b9lGwvVCVX4rn2Y6gvzc/AoDJs9+sgugPe/JXs4OpPp1GudS6nytij
         fLoyqjh76fPUmbGUOkCJMRlTpFfgIDjFqPi7picSW4qdW82cvPggGlXv/KiaJAjlJrUX
         LxhQaNhV5DRaK6se7Fsi0nYb2/PccqcjGSxZCGoJGQse01NiU8HfhB0gpPBgZP8SABIg
         /RIK2uIhy0Dtcy/wP5D01hs0BdQSmlGABjOGQmYW/UbTwdQ5AquO2Ufi8PG9s225e0Gi
         B7GhtOG01IVw6IUNsPcY71WSBOFBZSiYjMJV4L/mjgdLvb0ppAUd7pUhCjdQFe8tceRy
         MUEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iXeiRDIeMgIJ3QlhrfyzJaMD9KCCg6J0jEvMuAkTCAg=;
        b=2qPrP4vgeL9OkL52gICSMh1wrnMaRMCO4wly6XRCb+oj37o4vW/OGufCB5d3nh9wFD
         sRM2GC8C5W5hLEbYqlBw07XfGJCxx0J4ba0etXBFeKxTkwEN2fEy1/lOVn4GkKHzm29q
         ErhQcZ5MJYb05ENtpWxR27Lw4pKB9obAzfGTD6R8lrTmjW3XpRS0+isSaNZZ8sh6KqQv
         z4yhAQo0ljn32XP7EF7vl/zSS3LBmN/XQrYVU41rVUeKoOgz2orePRxzm02PU9+mo4Of
         9TNMDUIBxMfglZDxFIqPdBiLpbDurYyPk3by3Il1SfniMwYzkXuKJkf8BNX6ELygJInD
         afQw==
X-Gm-Message-State: AOAM530Gc8RX9+QdbDiWJ/RC4QrMUxS32Nqu3QKdGs8vCcI5eJndMZvD
        q7SNRYdvGIrWPpqdaHxeQoyOVf10e36Fcqz5ljquWA==
X-Google-Smtp-Source: ABdhPJwr5SZss80JbNUaIvuyOAY6SnFRgmU3B+jxsFytYHzPF9bHy4+u8p0cy9CqbtwHcy6LSwVIIt3HFULJoDOtdPk=
X-Received: by 2002:a2e:8895:: with SMTP id k21mr37790527lji.331.1638811218648;
 Mon, 06 Dec 2021 09:20:18 -0800 (PST)
MIME-Version: 1.0
References: <20211205133039.GD33002@xsang-OptiPlex-9020> <56b9d000-8743-52cb-4f10-4d3fa2b30f29@redhat.com>
In-Reply-To: <56b9d000-8743-52cb-4f10-4d3fa2b30f29@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 6 Dec 2021 09:19:52 -0800
Message-ID: <CALzav=dn-Oe1v9qTp=ag92Kn96JOb3AX9JJA4P5VcLksV8-vLw@mail.gmail.com>
Subject: Re: [KVM] d3750a0923: WARNING:possible_circular_locking_dependency_detected
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kernel test robot <oliver.sang@intel.com>,
        0day robot <lkp@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 5, 2021 at 10:55 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/5/21 14:30, kernel test robot wrote:
> >
> > Chain exists of:
> >   fs_reclaim --> mmu_notifier_invalidate_range_start --> &(kvm)->mmu_lock
> >
> >  Possible unsafe locking scenario:
> >
> >        CPU0                    CPU1
> >        ----                    ----
> >   lock(&(kvm)->mmu_lock);
> >                                lock(mmu_notifier_invalidate_range_start);
> >                                lock(&(kvm)->mmu_lock);
> >   lock(fs_reclaim);
> >
>
> David, this is yours; basically, kvm_mmu_topup_memory_cache must be
> called outside the mmu_lock.

Ah, I see. kvm_arch_mmu_enable_log_dirty_pt_masked is called with
mmu_lock already held. I'll make sure to address this in v1. In theory
this should just go away when I switch away from using split_caches to
Sean's suggestion of allocating under the mmu_lock with reclaim
disabled.
