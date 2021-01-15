Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058642F742E
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 09:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732207AbhAOIT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 03:19:56 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:38489 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726375AbhAOIT4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 03:19:56 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0ULnMmPw_1610698747;
Received: from IT-FVFX43SYHV2H.local(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0ULnMmPw_1610698747)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 15 Jan 2021 16:19:09 +0800
Subject: Re: [RESEND v13 00/10] KVM: x86/pmu: Guest Last Branch Recording
 Enabling
To:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210108013704.134985-1-like.xu@linux.intel.com>
From:   Alex Shi <alex.shi@linux.alibaba.com>
Message-ID: <3deac361-05fa-60a5-0d88-4f6b968f10bf@linux.alibaba.com>
Date:   Fri, 15 Jan 2021 16:19:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.0; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210108013704.134985-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



ÔÚ 2021/1/8 ÉÏÎç9:36, Like Xu Ð´µÀ:
> Because saving/restoring tens of LBR MSRs (e.g. 32 LBR stack entries) in
> VMX transition brings too excessive overhead to frequent vmx transition
> itself, the guest LBR event would help save/restore the LBR stack msrs
> during the context switching with the help of native LBR event callstack
> mechanism, including LBR_SELECT msr.
> 

Sounds the feature is much helpful for VMM guest performance tunning.
Good job!

Thanks
Alex
