Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90DA37B62F
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 08:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhELGe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 02:34:57 -0400
Received: from mga03.intel.com ([134.134.136.65]:50318 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229580AbhELGe5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 02:34:57 -0400
IronPort-SDR: AIvBH+p0FwgO1Db34YUXolYcJqzjgUlL/PmCv3vZVKjqRnbWxqQ4f8JpIJvvUl+mlbSg5aYnPJ
 a0PBCaQRmG3A==
X-IronPort-AV: E=McAfee;i="6200,9189,9981"; a="199680549"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="199680549"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2021 23:33:48 -0700
IronPort-SDR: sf0ON/yVTei43URmDwlcK7aD6Qo9w14AKOXW9R0yfaAc/z4+YHvHz2iMC89ipSguUim/ein8Ak
 WOIQYx134Z3Q==
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="437047272"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2021 23:33:46 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: pmu: Test full-width counter writes
 support
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <20200529074347.124619-1-like.xu@linux.intel.com>
 <20200529074347.124619-4-like.xu@linux.intel.com>
 <CALMp9eQNZsk-odGHNkLkkakk+Y01qqY5Mzm3x8n0A3YizfUJ7Q@mail.gmail.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <7c44617d-39f5-4e82-ee45-f0d142ba0dbc@linux.intel.com>
Date:   Wed, 12 May 2021 14:33:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eQNZsk-odGHNkLkkakk+Y01qqY5Mzm3x8n0A3YizfUJ7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/12 5:27, Jim Mattson wrote:
> On Fri, May 29, 2020 at 12:44 AM Like Xu <like.xu@linux.intel.com> wrote:
>>
>> When the full-width writes capability is set, use the alternative MSR
>> range to write larger sign counter values (up to GP counter width).
>>
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> ---
> 
>> +       /*
>> +        * MSR_IA32_PMCn supports writing values â€‹â€‹up to GP counter width,
>> +        * and only the lowest bits of GP counter width are valid.
>> +        */
> 
> Could you rewrite this comment in ASCII, please? I would do it, but
> I'm not sure what the correct translation is.
> 

My first submitted patch says that
they are just Unicode "ZERO WIDTH SPACE".

https://lore.kernel.org/kvm/20200508083218.120559-2-like.xu@linux.intel.com/

Here you go:

---

 From 1b058846aabcd7a85b5c5f41cb2b63b6a348bdc4 Mon Sep 17 00:00:00 2001
From: Like Xu <like.xu@linux.intel.com>
Date: Wed, 12 May 2021 14:26:40 +0800
Subject: [PATCH] x86: pmu: Fix a comment about full-width counter writes
  support

Remove two Unicode characters 'ZERO WIDTH SPACE' (U+200B).

Fixes: 22f2901a0e ("x86: pmu: Test full-width counter writes support")
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
  x86/pmu.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 5a3d55b..6cb3506 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -510,7 +510,7 @@ static void  check_gp_counters_write_width(void)
         }

         /*
-        * MSR_IA32_PMCn supports writing values Ã¢â‚¬â€¹Ã¢â‚¬â€¹up to GP 
counter width,
+        * MSR_IA32_PMCn supports writing values up to GP counter width,
          * and only the lowest bits of GP counter width are valid.
          */
         for (i = 0; i < num_counters; i++) {
--
2.31.1
