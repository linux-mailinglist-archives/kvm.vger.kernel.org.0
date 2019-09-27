Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAC1DC0A30
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 19:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfI0RTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 13:19:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53338 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfI0RTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 13:19:20 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 04A5E7CB80
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 17:19:20 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id r187so5505455wme.0
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 10:19:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MLj0Ds0fMGlvN3qqug5k1W4pQwj/b2b7ywaePtYozL4=;
        b=VFDE9taqb8XsZRx2Oqo7nkr1hcUTpKL9vS9har+UAhzxaDrLLEQOEijtHvfscHkZkr
         LhrYygdshfSGQOfvcf0V7dsUfqPSiQ2rNIjBxId/DsO8n38vIpYRYNH/Pvih9BEFlDTo
         zbbDAG/EaTws1LKQR6niAvHf4xa5ohtlXr0DukYDZ/wojzN/SeUZUuleoE1hJopxQvLN
         1fQza4lkTvedZ3Po+vCaEC4wyVBezzcPioausqoMCwnkiyFnjV5G1PLg3kxUSxU3Cpeo
         oKVmlK0bPDVTUE8VkAULgzAVIwxO/pOQkUur7NLD+PoevlbBzhEb2xEE72xnoHAEH/J6
         mwYQ==
X-Gm-Message-State: APjAAAUo2N3JaGTa+s8p6B2V6FZfGrVJkJEGMD5muHOpuZIUDv/84j2z
        I0epX7psUN6zlhbcMNLxxe2yGf8Ny+zVcQEz4imKL3m5RVqJ+vZrlrlARHIcXLfmNHFKOioGbM3
        O+iwnHiQ9n4zP
X-Received: by 2002:a1c:9ec9:: with SMTP id h192mr8271629wme.105.1569604758673;
        Fri, 27 Sep 2019 10:19:18 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzR0qylPwQ0Q3+h4mWlp4TwEkYTe6GvUhXma45KRseO6dN6sgQevHBu/q2zOvg/r2ArQcYeBA==
X-Received: by 2002:a1c:9ec9:: with SMTP id h192mr8271610wme.105.1569604758419;
        Fri, 27 Sep 2019 10:19:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id a14sm8649719wmm.44.2019.09.27.10.19.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 10:19:17 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <87ftkh6e19.fsf@vitty.brq.redhat.com>
 <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com>
 <87d0fl6bv4.fsf@vitty.brq.redhat.com>
 <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com>
 <20190927152608.GC25513@linux.intel.com>
 <87a7ap68st.fsf@vitty.brq.redhat.com>
 <59934fa75540d493dabade5a3e66b7ed159c4aae.camel@intel.com>
 <e4a17cfb-8172-9ad8-7010-ee860c4898bf@redhat.com>
 <CALMp9eQcHbm6nLAQ_o8dS4B+2k6B0eHxuGvv6Ls_-HL9PC4mhQ@mail.gmail.com>
 <11f63bd6-50cc-a6ce-7a36-a6e1a4d8c5e9@redhat.com>
 <20190927171405.GD25513@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7a12a208-4969-e3fe-4a42-b432b91599d8@redhat.com>
Date:   Fri, 27 Sep 2019 19:19:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190927171405.GD25513@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/19 19:14, Sean Christopherson wrote:
>>
>> Perhaps we can make all MSRs supported unconditionally if
>> host_initiated.  For unsupported performance counters it's easy to make
>> them return 0, and allow setting them to 0, if host_initiated 
> I don't think we need to go that far.  Allowing any ol' MSR access seems
> like it would cause more problems than it would solve, e.g. userspace
> could completely botch something and never know.

Well, I didn't mean really _all_ MSRs, only those returned by
KVM_GET_MSR_INDEX_LIST.

> For the perf MSRs, could we enumerate all arch perf MSRs that are supported
> by hardware?  That would also be the list of MSRs that host_initiated MSR
> accesses can touch regardless of guest support.

Yes, that is easy indeed.  Any ideas about VMX?

Paolo
