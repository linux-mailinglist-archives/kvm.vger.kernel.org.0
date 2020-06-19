Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA24A201B8F
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 21:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390220AbgFSTqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 15:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389005AbgFSTqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 15:46:16 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86ED8C06174E;
        Fri, 19 Jun 2020 12:46:15 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id j1so4864107pfe.4;
        Fri, 19 Jun 2020 12:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=uycxWZsh8kXOgvUY6V8WFigSegpe6Uug5YxuPV8BuXw=;
        b=dvwgYKtbAHl6Wc3/JNJoE3RFqqWkwatSlAw/rZFBzbnISjQeYP3Co/8xtuY+5ahqmS
         2H1IADoCCxh9rg7MYrFMQyz1A9Q5NmUFgQDY8a6ihSfXJ3sT3z3/h5XRuCMIEnQG6l+f
         fHlkHNq4/pauNltTFnfQdA/GPKQ9jxAVzDsXfmH45M/XdiGP8DpmSZzoZJkOyhI5APSp
         MIqeyuMsuCps7d/uIJffsQE3Yzp/VYuF4R6Kr2DGeVj25qMamp94LcorliCDXNeuJXkA
         ENjDud1Iw8HDBj7pvRtfGSjwFJcuQRTX4TeBO+vA9Y74zteAaw+prREFYP9sLTPKh5Qy
         G/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=uycxWZsh8kXOgvUY6V8WFigSegpe6Uug5YxuPV8BuXw=;
        b=EE5DP9r7a2nyPdH9S8QA9sEZ7evFRkfrdhWHTHEtjxtEdSUvWFaFENItha9mqjyPY7
         5FT3P+nXGkG+tkK2+gFOm5oLU+mhzee4KAXfmw4IDmArQXcLffxWuItG92IFeayHGa8T
         bUPZ9h2iOA0cL5E1CZxoE3d4bBtvePxeyJgaYrh2RbaXQv/uyb6KvAxHjie2794Uq7hd
         UVJGvzbCekemrroTM127DEh4eAQDP3OPchiEvepUeNzgzRsQBAeBAS5rlyDlBpRzaamw
         etDfmJtuUP3q6/z2H5kI/vfJGH6a91ADYvvLRRHCTylS1lh1+ar1CYiJ4bi7Cnb+1zVG
         QdDg==
X-Gm-Message-State: AOAM532sjmM50OaZFOGx6KlYRVhjxvMGTYjcH0KIHelwRkDl7VNb/YBZ
        jopN75spZWum/CK3I6pZEis=
X-Google-Smtp-Source: ABdhPJzGkWDxM2It2kwRNz1bHPQlJQm0CGjM9y0/T9u/T3f48GJqwbp8RSzphbVHaQrw5MFbYyh3MQ==
X-Received: by 2002:a62:ed02:: with SMTP id u2mr9259644pfh.283.1592595974783;
        Fri, 19 Jun 2020 12:46:14 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:f471:e6bc:7ad4:bb29? ([2601:647:4700:9b2:f471:e6bc:7ad4:bb29])
        by smtp.gmail.com with ESMTPSA id y10sm6933627pfq.34.2020.06.19.12.46.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jun 2020 12:46:13 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [kvm-unit-tests PATCH] x86: pmu: Test full-width counter writes
 support
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <1272fbd7-3ff1-5eac-e9e2-78b824fbc4e0@redhat.com>
Date:   Fri, 19 Jun 2020 12:46:12 -0700
Cc:     Thomas Huth <thuth@redhat.com>, Like Xu <like.xu@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <A2E707BF-BF31-4B96-9181-881B5E496938@gmail.com>
References: <20200529074347.124619-1-like.xu@linux.intel.com>
 <20200529074347.124619-4-like.xu@linux.intel.com>
 <b1a5472b-f7d0-82b0-e753-dabf81254488@redhat.com>
 <1272fbd7-3ff1-5eac-e9e2-78b824fbc4e0@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 16, 2020, at 5:28 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> On 16/06/20 12:49, Thomas Huth wrote:
>> On 29/05/2020 09.43, Like Xu wrote:
>>> When the full-width writes capability is set, use the alternative MSR
>>> range to write larger sign counter values (up to GP counter width).
>>> 
>>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>>> ---
>>> lib/x86/msr.h |   1 +
>>> x86/pmu.c     | 125 ++++++++++++++++++++++++++++++++++++++++----------
>>> 2 files changed, 102 insertions(+), 24 deletions(-)
>> [...]
>>> @@ -452,6 +468,66 @@ static void check_running_counter_wrmsr(void)
>>> 	report_prefix_pop();
>>> }
>>> 
>>> +static void check_counters(void)
>>> +{
>>> +	check_gp_counters();
>>> +	check_fixed_counters();
>>> +	check_rdpmc();
>>> +	check_counters_many();
>>> +	check_counter_overflow();
>>> +	check_gp_counter_cmask();
>>> +	check_running_counter_wrmsr();
>>> +}
>>> +
>>> +static void do_unsupported_width_counter_write(void *index)
>>> +{
>>> +	wrmsr(MSR_IA32_PMC0 + *((int *) index), 0xffffff0123456789ull);
>>> +}
>>> +
>>> +static void  check_gp_counters_write_width(void)
>>> +{
>>> +	u64 val_64 = 0xffffff0123456789ull;
>>> +	u64 val_32 = val_64 & ((1ul << 32) - 1);
>> Hi,
>> 
>> this broke compilation on 32-bit hosts:
>> 
>> https://travis-ci.com/github/huth/kvm-unit-tests/jobs/349654654#L710
>> 
>> Fix should be easy, I guess - either use 1ull or specify the mask
>> 0xffffffff directly.
> 
> Or
> 
> u64 val_32 = (u64)(u32) val_64;
> 
> I'll send a patch.

I missed this correspondence, but while running the tests on 32-bit I
encountered two additional cases of wrong masks that caused failures.

I have sent a separate patch for your consideration.

