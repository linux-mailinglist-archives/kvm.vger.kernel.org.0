Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F245267854
	for <lists+kvm@lfdr.de>; Sat, 12 Sep 2020 08:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgILGr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Sep 2020 02:47:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52416 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725813AbgILGrv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Sep 2020 02:47:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599893270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k4tzdMPT4Ag7XjRut0d5gVcFKeBdX0XWZ6t+mUPAXZM=;
        b=bMg0zYaboiPfGwEkqqZnH2fY2xAk1HyRTPm5Rj4b1IrpcVvcfXFgQcyTknoP6vuISf+Qaq
        np/WkAPZJ0xZSaAorNANwT8JaUtu6B4Kb/iVMfpMPxigHHx8MkcdgBBNcmWpUCcqSOWqb3
        x0YRKmTA5bxbBnQ5z9xwYFo3F64zH68=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-TcUrygliOuWZK7z5_rNJPA-1; Sat, 12 Sep 2020 02:47:48 -0400
X-MC-Unique: TcUrygliOuWZK7z5_rNJPA-1
Received: by mail-wm1-f72.google.com with SMTP id m125so1699520wmm.7
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 23:47:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k4tzdMPT4Ag7XjRut0d5gVcFKeBdX0XWZ6t+mUPAXZM=;
        b=D0lf0V5d08C5zY3yaNXP9G5W2X2JXLcZSlWHzpDhZb6Sc88BXaFC2cGRfwWP4PyBp0
         CaR6b+rQ1DJ2/72IBuzo2EupgG5mI74OJf0kJdOReezMwEdgHKJu/TM7J3TY7PWmNDZ/
         W994NfHOUGQo33LXA7hBZk9UbVBiqYWLlQzL5cG2f4dknJRPzWndAirx7i7VI9UCoJJF
         yzY/DVPVDXmUHBeAXmOFj7djRF7axO//GQvfNDoPtJAsfjFJ6VoqtmwJjOTf7nJtmU+t
         VXJBcJ7jz/BFTEzgU0GKWKRO2PbncLE/OdipwwGWoil+n//2De/KPuRCqtLxxOxOsFhH
         9AIw==
X-Gm-Message-State: AOAM530t6I+65EBzTc1s4Cs7zu6vEA3B53DOqjRbhoZwwWP5HZf1BhQM
        sFJlK/plSk2r50/YF6+FhZ84/KskiVKxKwSI94QOEmtrtybxngKKoM3QQRlxQbwksd34wtZ97Bo
        MEtjWOs8Uw8O2
X-Received: by 2002:a7b:c8c9:: with SMTP id f9mr5733463wml.67.1599893267278;
        Fri, 11 Sep 2020 23:47:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxty33MEuHSQi4MTLGa4bmojFvAwBALUmBDJldvnQpqgiwbPgv10PDa1ok0MRL6H+D3faDPvA==
X-Received: by 2002:a7b:c8c9:: with SMTP id f9mr5733447wml.67.1599893267106;
        Fri, 11 Sep 2020 23:47:47 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id h186sm8739380wmf.24.2020.09.11.23.47.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 23:47:46 -0700 (PDT)
Subject: Re: [PATCH v2 0/9] KVM: collect sporadic patches
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <019b3e94-b2b2-00a6-2904-a7c4a66b73e8@redhat.com>
Date:   Sat, 12 Sep 2020 08:47:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/09/20 11:50, Wanpeng Li wrote:
> Collect sporadic patches for easy apply.
> 
> Wanpeng Li (9):
>   KVM: LAPIC: Return 0 when getting the tscdeadline timer if the lapic
>     is hw disabled
>   KVM: LAPIC: Guarantee the timer is in tsc-deadline mode when setting
>   KVM: LAPIC: Fix updating DFR missing apic map recalculation
>   KVM: VMX: Don't freeze guest when event delivery causes an APIC-access
>     exit
>   KVM: LAPIC: Narrow down the kick target vCPU
>   KVM: LAPIC: Reduce world switch latency caused by timer_advance_ns
>   KVM: SVM: Get rid of handle_fastpath_set_msr_irqoff()
>   KVM: SVM: Move svm_complete_interrupts() into svm_vcpu_run()
>   KVM: SVM: Reenable handle_fastpath_set_msr_irqoff() after
>     complete_interrupts()
> 
>  arch/x86/kvm/lapic.c   | 36 ++++++++++++++++++++----------------
>  arch/x86/kvm/svm/svm.c | 17 +++++++++--------
>  arch/x86/kvm/vmx/vmx.c |  5 ++---
>  arch/x86/kvm/x86.c     |  6 ------
>  arch/x86/kvm/x86.h     |  1 -
>  5 files changed, 31 insertions(+), 34 deletions(-)
> 

Queued what was left, thanks.

Paolo

