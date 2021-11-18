Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBBC455640
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 09:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244199AbhKRIJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 03:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244124AbhKRIJf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 03:09:35 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4085EC061570;
        Thu, 18 Nov 2021 00:06:36 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id b11so4530924pld.12;
        Thu, 18 Nov 2021 00:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=2EY2C+KO6khqoZgf2RrCYO8HtYahXMh07WO0wbIo/XI=;
        b=Vl7ryZoQhYvWoke7q0/NYAmaCZgstW8o4sKWrObHhyQXgI7gFXXal/OSGy7LcI1VmF
         TuMFApDOWjHOc6ecvdSnOwRlwzMRRY0JGjSS/gA4r4g0y9XREJbU2YyFrbjeJUan/ldS
         AC6FfBDaAsp44JtoTTw1vojtwAkeIbybON4DwnH/SKkVmkybp+gdZRYQFYKvP77WNhNt
         CdgL7ejnXc4/55sgVlT16N8M2od5Fo6vOsie5VOnyv9LUhq48Pr6WWcJGMTU62HnojeT
         I/8EW8Bo/suip6SYTNfuRChhJupIqobNI70uztwJGhkTLqpVQ8DxK8N3Gzmrgcnc7G+y
         ktig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=2EY2C+KO6khqoZgf2RrCYO8HtYahXMh07WO0wbIo/XI=;
        b=KWBI4NEQZasiOgAm7bOIOpF8E9HGhoW4J/+a+vGjE/leh6dV6QSsH6tw5cxcgVjM9f
         dVqrT+wFL7eWoJUgAIC7YSl3oLZzx37et2obYWHjx6tjPwE4ZdB8jKxGdLi2clWt4Uke
         EvugqPQKgFNmR9yPtWSjwhlFkPBZ2vr+T+86aj1oBNDVeoJJk5bqv0C7TGbEVD7/PybD
         /AqcmjAMsxYJBiYsuhyIIwmptYvtL/ozcAGZM97G0PNJGufzS+PkrJpinVvkLjdr0PkR
         G+46suGM7cX88/okl+j6BZHKE9xqaNCwbb4z9QUYBWR9Lv5BVnqCJdc21LP/C7xjqsDH
         h2PA==
X-Gm-Message-State: AOAM532zImfxVlFXbBbGg7iTbugaNukHpzmyYBFCWBroNErvJiKyL94l
        Ss3J4d5OlTDGDDCMeQPlQ9c=
X-Google-Smtp-Source: ABdhPJzsz4o+Y+BZnKt8+tyWXhWiSmVc4KFPzWqqy8bD4IZ5NWZpQJ8JrBenYwcm0oSkNATjl0Z9Pg==
X-Received: by 2002:a17:90b:4b86:: with SMTP id lr6mr7924026pjb.98.1637222795817;
        Thu, 18 Nov 2021 00:06:35 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c5sm1805965pjm.52.2021.11.18.00.06.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 00:06:35 -0800 (PST)
Message-ID: <97ea49ce-2ec2-3b35-6aac-d30998b837fe@gmail.com>
Date:   Thu, 18 Nov 2021 16:06:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH 6/7] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20211112095139.21775-7-likexu@tencent.com>
 <202111180758.nFyJUMVf-lkp@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <202111180758.nFyJUMVf-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/11/2021 7:21 am, kernel test robot wrote:
> Hi Like,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on kvm/queue]
> [also build test ERROR on tip/perf/core mst-vhost/linux-next linus/master v5.16-rc1 next-20211117]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 

...

> vim +500 arch/x86/include/asm/perf_event.h
> 
>     492	
>     493	#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
>     494	extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
>     495	extern u64 perf_get_hw_event_config(int perf_hw_id);
>     496	extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
>     497	#else
>     498	struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
>     499	u64 perf_get_hw_event_config(int perf_hw_id);

Thanks to the robot, I should have removed the ";" from this line.

Awaiting further review comments.

>   > 500	{
>     501		return 0;
>     502	}
>     503	static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
>     504	{
>     505		return -1;
>     506	}
>     507	#endif
>     508	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 
