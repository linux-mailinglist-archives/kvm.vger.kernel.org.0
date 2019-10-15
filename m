Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3862D8085
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 21:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732539AbfJOTrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 15:47:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727478AbfJOTrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 15:47:02 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 47348C04B940
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 19:47:01 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id j7so10660535wrx.14
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 12:47:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JUDMnzFf/AJg2T0GjQljTk8M2MDyg/AQ482kn8kGySo=;
        b=Z76frE8nUnZ5dHPIAfySlLjCJ3LoF9skg9kBfqOFyEOb/7uzrWKOqUF4lKZ3Mz4oqg
         Id6eXarPjn5Q3UMEmbO7wI6lJ2B32tMdAUP++swQBm5gIJT5AnIWnMM2HfRs+FlvQNEL
         KyHoiNfpyJP4IL07CaORYHQkdxIT5mMN4zPS5p9gYHgJCq5pA1XWk8UXctrFrooizKAq
         zR2tCHRS709S5MH4bccDpCH44/Y3Sbgzb+zOpHkFMfFbYGkgz6nRqiPzTsvV/CTOZ8Zu
         UD7l5x9OheOIhihyRkRpHC+gLXr7lPAmmgdS9pBXjDmpO7nTl0N/T7XFqmZm2BoclRpn
         PgFA==
X-Gm-Message-State: APjAAAXp8EsegzydTuOCP82ifFROapfAq4GwXIHCx9fyuX7RZrj1kVpu
        SEHDVtSVUeCu22H5B2xGgGZuijF+tFpbqIY8MhtemCnfSt1CcsSOhdvvdklJ2hb5mzzeH0IoufD
        GmKH/oOpmDoky
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr33243546wrw.182.1571168819888;
        Tue, 15 Oct 2019 12:46:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxKncfKk0ZDjD/mAm3dZRAQyVQ+iLyC2oCnuIGL0d4Nl3NDjg7qLC99QPB29CvDvGDpBauxtw==
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr33243530wrw.182.1571168819564;
        Tue, 15 Oct 2019 12:46:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id g13sm18499321wrm.42.2019.10.15.12.46.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2019 12:46:58 -0700 (PDT)
Subject: Re: [PATCH 12/14] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
 <20190928172323.14663-13-aarcange@redhat.com>
 <933ca564-973d-645e-fe9c-9afb64edba5b@redhat.com>
 <20191015164952.GE331@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <870aaaf3-7a52-f91a-c5f3-fd3c7276a5d9@redhat.com>
Date:   Tue, 15 Oct 2019 21:46:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015164952.GE331@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/19 18:49, Andrea Arcangeli wrote:
> On Tue, Oct 15, 2019 at 10:28:39AM +0200, Paolo Bonzini wrote:
>> If you're including EXIT_REASON_EPT_MISCONFIG (MMIO access) then you
>> should include EXIT_REASON_IO_INSTRUCTION too.  Depending on the devices
>> that are in the guest, the doorbell register might be MMIO or PIO.
> 
> The fact outb/inb devices exists isn't the question here. The question
> you should clarify is: which of the PIO devices is performance
> critical as much as MMIO with virtio/vhost?

virtio 0.9 uses PIO.

> I mean even on real hardware those devices aren't performance critical.

On virtual machines they're actually faster than MMIO because they don't
need to go through page table walks.

>> So, the difference between my suggested list (which I admit is just
>> based on conjecture, not benchmarking) is that you add
>> EXIT_REASON_PAUSE_INSTRUCTION, EXIT_REASON_PENDING_INTERRUPT,
>> EXIT_REASON_EXTERNAL_INTERRUPT, EXIT_REASON_HLT, EXIT_REASON_MSR_READ,
>> EXIT_REASON_CPUID.
>>
>> Which of these make a difference for the hrtimer testcase?  It's of
>> course totally fine to use benchmarks to prove that my intuition was
>> bad---but you must also use them to show why your intuition is right. :)
> 
> The hrtimer flood hits on this:
> 
>            MSR_WRITE     338793    56.54%     5.51%      0.33us     34.44us      0.44us ( +-   0.20% )
>    PENDING_INTERRUPT     168431    28.11%     2.52%      0.36us     32.06us      0.40us ( +-   0.28% )
>     PREEMPTION_TIMER      91723    15.31%     1.32%      0.34us     30.51us      0.39us ( +-   0.41% )
>   EXTERNAL_INTERRUPT        234     0.04%     0.00%      0.25us      5.53us      0.43us ( +-   5.67% )
>                  HLT         65     0.01%    90.64%      0.49us 319933.79us  37562.71us ( +-  21.68% )
>             MSR_READ          6     0.00%     0.00%      0.67us      1.96us      1.06us ( +-  17.97% )
>        EPT_MISCONFIG          6     0.00%     0.01%      3.09us    105.50us     26.76us ( +-  62.10% )
> 
> PENDING_INTERRUPT is the big missing thing in your list. It probably
> accounts for the bulk of slowdown from your list.

Makes sense.

> However I could imagine other loads with higher external
> interrupt/hlt/rdmsr than the hrtimer one so I didn't drop those.
External interrupts should only tick at 1 Hz on nohz_full kernels,
and even at 1000 Hz (if physical CPUs are not isolated) it should not
really matter.  We can include it since it has such a short handler so
the cost of retpolines is in % much more than other exits.

HLT is certainly a slow path, the guest only invokes if things such as
NAPI interrupt mitigation have failed.  As long as the guest stays in
halted state for a microsecond or so, the cost of retpoline will all but
disappear.

RDMSR again shouldn't be there, guests sometimes read the PMTimer (which
is an I/O port) or TSC but for example do not really ever read the APIC
TMCCT.

> I'm pretty sure HLT/EXTERNAL_INTERRUPT/PENDING_INTERRUPT should be
> included.
> I also wonder if VMCALL should be added, certain loads hit on fairly
> frequent VMCALL, but none of the one I benchmarked.

I agree for external interrupt and pending interrupt, and VMCALL is fine
too.  In addition I'd add I/O instructions which are useful for some
guests and also for benchmarking (e.g. vmexit.flat has both IN and OUT
tests).

Paolo
