Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792D8455CD3
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 14:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhKRNjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 08:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhKRNjs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 08:39:48 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016FCC061570;
        Thu, 18 Nov 2021 05:36:49 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id q17so5238190plr.11;
        Thu, 18 Nov 2021 05:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=hYYmABqzjWDvxMbK6+yRwLb5Gk30hSOmT6FVQbcyDNA=;
        b=e7d3vuc+oxjmFT6vSExtszL9Qhjgwrcm6f97X85X9UusqNM7Nnpyw8jUgUzgL6bd7Q
         LOytTHp+Khacp/IRv2eMD0hR5FsuwEmuvra5/slYnpJIknlA12qN+QIixq9Ofp6r2ytb
         fwEahEytdN+i99246w3hjmjd5Jx9eklje1TR4msqI3mMH2c4Xr9RSxuEEUOeMXILN29M
         b/zar/tsEfkUr69tDTalgUb4bXLAdwJxlToZH7oWIyfUr/UgNmRAsj89bP6RD5l+zlMJ
         eQk39C4x27U05TMp0pqy0XKGLDq6yrmkaw1r0jKmEgrgdHhOFTvl48NqX5E6FWSltO41
         G4AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=hYYmABqzjWDvxMbK6+yRwLb5Gk30hSOmT6FVQbcyDNA=;
        b=TBlCJnUc635CPY/Z4bmckutclIdm5B1lvgdJK8kfO5wFrvKX+M9gkLmoymliGbKe/t
         kzw/IoRUVOCJKV/IynwCtqq/5VtCR8YRxGHm7qczNnqvvQI6w7VbUZLDyElKbBqJ/whc
         m5sMHcoNQiMQAz8bsQ32x4WcpJvo69CzpZfjyKTPrnTP3nJOFmaby2/YgsDQo1pjXuug
         DMZ1QJryx/OAhqll/ZsnzKoP+7evpsbctiJc4OvOSAevmx8OHGBv8KuCOKz8SbPLcs9N
         jgffXMi8YWQY7iS2JbmEjAEzxzug8L37aIV6hmHDo4Z+pq5munAs4K+jUa5+mPw3cPOm
         L/IA==
X-Gm-Message-State: AOAM531EVVnWzQ8DbUA2Cye47oTaa7xiP+x4j2qzhO4xFbiut4Shx50p
        IJtWVWSkOQtON85vM2p9Av0=
X-Google-Smtp-Source: ABdhPJwtJ1fdS1vUhVZyONhsmSXYbXNS3oTy3EJM9WiWngiAAfmkYnj6kxSbYTpUzZEo4OBmWkSKSQ==
X-Received: by 2002:a17:902:e749:b0:141:edaa:fde1 with SMTP id p9-20020a170902e74900b00141edaafde1mr66857828plf.72.1637242608528;
        Thu, 18 Nov 2021 05:36:48 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w1sm3325230pfg.11.2021.11.18.05.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 05:36:48 -0800 (PST)
Message-ID: <d4b15e7d-8d53-b00a-7b53-c843edb7be70@gmail.com>
Date:   Thu, 18 Nov 2021 21:36:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH 6/7] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kbuild-all@lists.01.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Peter Zijlstra <peterz@infradead.org>,
        kernel test robot <lkp@intel.com>
References: <20211112095139.21775-7-likexu@tencent.com>
 <202111180758.nFyJUMVf-lkp@intel.com>
 <97ea49ce-2ec2-3b35-6aac-d30998b837fe@gmail.com>
Organization: Tencent
In-Reply-To: <97ea49ce-2ec2-3b35-6aac-d30998b837fe@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/11/2021 4:06 pm, Like Xu wrote:
> On 18/11/2021 7:21 am, kernel test robot wrote:
>> Hi Like,
>>
>> Thank you for the patch! Yet something to improve:
>>
>> [auto build test ERROR on kvm/queue]
>> [also build test ERROR on tip/perf/core mst-vhost/linux-next linus/master 
>> v5.16-rc1 next-20211117]
>> [If your patch is applied to the wrong git tree, kindly drop us a note.
>> And when submitting patch, we suggest to use '--base' as documented in
>> https://git-scm.com/docs/git-format-patch]
>>
> 
> ...
> 
>> vim +500 arch/x86/include/asm/perf_event.h
>>
>>     492
>>     493    #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
>>     494    extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
>>     495    extern u64 perf_get_hw_event_config(int perf_hw_id);
>>     496    extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
>>     497    #else
>>     498    struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
>>     499    u64 perf_get_hw_event_config(int perf_hw_id);
> 
> Thanks to the robot, I should have removed the ";" from this line.
> 

Sorry, my bot is shouting at me again. This part should be:

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8fc1b5003713..85fd768d49d7 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -492,9 +492,11 @@ static inline void perf_check_microcode(void) { }

  #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
  extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+extern u64 perf_get_hw_event_config(int perf_hw_id);
  extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
  #else
  struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+static u64 perf_get_hw_event_config(int perf_hw_id);
  static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
  {
         return -1;

> Awaiting further review comments.
> 
>>   > 500    {
>>     501        return 0;
>>     502    }
>>     503    static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
>>     504    {
>>     505        return -1;
>>     506    }
>>     507    #endif
>>     508
>>
>> ---
>> 0-DAY CI Kernel Test Service, Intel Corporation
>> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>>
