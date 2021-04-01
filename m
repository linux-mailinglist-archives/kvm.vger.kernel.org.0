Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E613517B4
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbhDARmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:42:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54332 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234606AbhDARiW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:38:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617298702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lOIr1o35ulSBWubdx/QPT+kMf1fQWz0YQbH/YEA+9Lw=;
        b=VV51kv1viqFx890/hiPrpHoEJ3Gu6Te1y7NNZFj+y9WPU5qdwkcsuBoe53tS9vNuJAwDaH
        o6Pw+E3cmLd2OQARCNAQMEo/h4cDw6pt+HwpGPuAHnowVGHNpu8pVg+iIFtETVSjEy50EL
        h1H8tKyVGywJtajhQX8C6qJllhh6Pg0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-LROeo2l7PuinspaW24tXlQ-1; Thu, 01 Apr 2021 13:32:10 -0400
X-MC-Unique: LROeo2l7PuinspaW24tXlQ-1
Received: by mail-ed1-f72.google.com with SMTP id t27so3193387edi.2
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 10:32:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lOIr1o35ulSBWubdx/QPT+kMf1fQWz0YQbH/YEA+9Lw=;
        b=s+klZOmlN360Qks8nSWshWkTsmJmnlqBPKIHqK518aIO9xJ4X+ZfbUdjwv918Zd8gv
         dRg5E81/NeeUSPi0NEDt4vTjHgt555KWO8cGp3BLBdhsyLjXo4AUkM/vv3MSDhABSGAV
         Pys5cftjr2FPyePOUBaQ96vkC0NjF3D8qrAUZpO31s0rfk3a9eZTNFFjUMZY3V0i/lBQ
         ANbkzHNL1m20fdhNEdqJznTlloTQ++NBD2NvlL6cVyAGwfX8uRUeIh5ZhwnK/HsEXsr1
         R8/+gtV04LWIS8P/sIIXFoxCFRO1RPWQ0toYs7idUZeNz6Qz8GaaEWgY6U6on4BDi9mi
         n7TA==
X-Gm-Message-State: AOAM5334m2IWapL97HD/RMcQprPmR6RP9mFZM+vcggUTSRZcTaNhU8In
        o8Pju9V0atmI1NI/vwtZBd6ZTBYIdvH70gb1tPwai6qo/+K8uI1biB3TIPePBAnlH/9VZjbjxLW
        ttNYl4IWh2bY4
X-Received: by 2002:a17:906:4705:: with SMTP id y5mr10388397ejq.119.1617298329201;
        Thu, 01 Apr 2021 10:32:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLAa9FWEdvYEX4U6/FyjsHeW/LVAdCKVbvQp8KG1+EKu1oB4EIcgUYT6s9DDMcUswckmd8iw==
X-Received: by 2002:a17:906:4705:: with SMTP id y5mr10388383ejq.119.1617298329041;
        Thu, 01 Apr 2021 10:32:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c20sm3056119eja.22.2021.04.01.10.32.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 10:32:08 -0700 (PDT)
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-21-bgardon@google.com>
 <f4fca4d7-8795-533e-d2d9-89a73e1a9004@redhat.com>
 <CANgfPd85U_YwDdXc1Dkn-UzKpae5FRzYshLFABAU_xHTs0i3Hg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 20/28] KVM: x86/mmu: Use atomic ops to set SPTEs in TDP
 MMU map
Message-ID: <e94bc2f3-b948-0176-0253-b487bf2aa787@redhat.com>
Date:   Thu, 1 Apr 2021 19:32:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd85U_YwDdXc1Dkn-UzKpae5FRzYshLFABAU_xHTs0i3Hg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/21 18:50, Ben Gardon wrote:
>> retry:
>>                   if (is_shadow_present_pte(iter.old_spte)) {
>>                          if (is_large_pte(iter.old_spte)) {
>>                                  if (!tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
>>                                          break;
>>
>>                                  /*
>>                                   * The iter must explicitly re-read the SPTE because
>>                                   * the atomic cmpxchg failed.
>>                                   */
>>                                  iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
>>                                  goto retry;
>>                          }
>>                   } else {
>>                          ...
>>                  }
>>
>> ?
> To be honest, that feels less readable to me. For me retry implies
> that we failed to make progress and need to repeat an operation, but
> the reality is that we did make progress and there are just multiple
> steps to replace the large SPTE with a child PT.

You're right, it's makes no sense---I misremembered the direction of
tdp_mmu_zap_spte_atomic's return value.  I was actually thinking of this:

> Another option which could improve readability and performance would
> be to use the retry to repeat failed cmpxchgs instead of breaking out
> of the loop. Then we could avoid retrying the page fault each time a
> cmpxchg failed, which may happen a lot as vCPUs allocate intermediate
> page tables on boot. (Probably less common for leaf entries, but
> possibly useful there too.)

which would be

retry:
                  if (is_shadow_present_pte(iter.old_spte)) {
                        if (is_large_pte(iter.old_spte) &&
                            !tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter)) {
                                 /*
                                  * The iter must explicitly re-read the SPTE because
                                  * the atomic cmpxchg failed.
                                  */
                                 iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
                                 goto retry;
                             }
                             /* XXX move this to tdp_mmu_zap_spte_atomic? */
                             iter.old_spte = 0;
                        } else {
                             continue;
                        }
                  }
                  sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level);
                  child_pt = sp->spt;

                  new_spte = make_nonleaf_spte(child_pt,
                                               !shadow_accessed_mask);

                  if (!tdp_mmu_set_spte_atomic(vcpu->kvm, &iter,
                                              new_spte)) {
                       tdp_mmu_free_sp(sp);
                       /*
                        * The iter must explicitly re-read the SPTE because
                        * the atomic cmpxchg failed.
                        */
                       iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
                       goto retry;
                  }
                  tdp_mmu_link_page(vcpu->kvm, sp, true,
                                    huge_page_disallowed &&
                                    req_level >= iter.level);

                  trace_kvm_mmu_get_page(sp, true);

which survives at least a quick smoke test of booting a 20-vCPU Windows
guest.  If you agree I'll turn this into an actual patch.

