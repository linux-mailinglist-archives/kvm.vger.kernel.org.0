Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDFF7D0AF0
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 11:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbfJIJVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 05:21:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56572 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfJIJVl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 05:21:41 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 76BD683F40
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 09:21:40 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id k9so780364wmb.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 02:21:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wmh8kF+ZSO74rIYqKCGxHJ7ZgVRAS1bRORozmupO6pw=;
        b=RPJsMPd96Ma47pzaq/2+gIs6OhzM7B08bvtIhylop7KNqu99DvRGfSdcCbHTfY2Vco
         M5G5mAIMdYRF4Mlz3E/KFSIC56JH9ByauD/902cJvBMLIevi+1yZ9hUsuD86cJmqT/Wn
         tZVQnSMynOBl1XrzjErU0t1yk/ukZ7dz6WWkKlhTTwyaejImdfTaNT8/WN5zncyZpvER
         We28LIynYq6T3a1V+9j/cVkVoHa+Lwyt71NdxZDebTJtdz0UcGrWhxpRN3S2NlehwyMP
         pTQie2D/fF8U4sYKyg7UGwHLyKPEY3cW1C246AeIcb9/N/IZD6LVmkwKdv34hB1mFDMM
         Mq8g==
X-Gm-Message-State: APjAAAVURiZ5xHR69hDIknjLhnWMNU3UWVW/wPMJt12t3VmtiHbkPCuh
        0w+1kpM9x9LG75bcQyC4oFbY7tVfdmhAGtHKVwmWI1vVYup6JKcTW66vT0y2o5f3efenEnmvC6f
        iHtoXJpCh6PWl
X-Received: by 2002:adf:e688:: with SMTP id r8mr2165405wrm.342.1570612899008;
        Wed, 09 Oct 2019 02:21:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwyvhRg9BMB0ZmISW8Ai9x41OUuFCoFZf6QA+0g0V5R11eVr9+qf87atDtSlr/y8loEdjkjAg==
X-Received: by 2002:adf:e688:: with SMTP id r8mr2165382wrm.342.1570612898713;
        Wed, 09 Oct 2019 02:21:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f4b0:55d4:57da:3527? ([2001:b07:6468:f312:f4b0:55d4:57da:3527])
        by smtp.gmail.com with ESMTPSA id z5sm2610467wrs.54.2019.10.09.02.21.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 02:21:38 -0700 (PDT)
Subject: Re: [PATCH 3/3] KVM: x86/vPMU: Add lazy mechanism to release
 perf_event per vPMC
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
References: <20190930072257.43352-1-like.xu@linux.intel.com>
 <20190930072257.43352-4-like.xu@linux.intel.com>
 <20191001082321.GL4519@hirez.programming.kicks-ass.net>
 <e77fe471-1c65-571d-2b9e-d97c2ee0706f@linux.intel.com>
 <20191008121140.GN2294@hirez.programming.kicks-ass.net>
 <d492e08e-bf14-0a8b-bc8c-397f8893ddb5@linux.intel.com>
 <bfd23868-064e-4bf5-4dfb-211d36c409c1@redhat.com>
 <20191009081602.GI2328@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <795f5e36-0211-154f-fcf0-f2f1771bf724@redhat.com>
Date:   Wed, 9 Oct 2019 11:21:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191009081602.GI2328@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/19 10:16, Peter Zijlstra wrote:
> On Wed, Oct 09, 2019 at 09:15:03AM +0200, Paolo Bonzini wrote:
>> For stuff like hardware registers, bitfields are probably a bad idea
>> anyway, so let's only consider the case of space optimization.
> 
> Except for hardware registers? I actually like bitfields to describe
> hardware registers.

In theory yes, in practice for MMIO it's a problem that you're not able
to see the exact compiler reads or writes.  Of course you can do:

	union {
		struct {
			/* some bitfields here
		} u;
		u32 val;
	}

and only use the bitfields after reading/writing from the register.

> But worse, as used in the parent thread:
> 
> 	u8	count:7;
> 	bool	flag:1;
> 
> Who says the @flag thing will even be the msb of the initial u8 and not
> a whole new variable due to change in base type?

Good point.

>> bool bitfields preserve the magic behavior where something like this:
>>
>>   foo->x = y;
>>
>> (x is a bool bitfield) would be compiled as
>>
>>   foo->x = (y != 0);
> 
> This is confusion; if y is a single bit bitfield, then there is
> absolutely _NO_ difference between these two expressions.

y is not in a struct so it cannot be a single bit bitfield. :) If y is
an int and foo->x is a bool bitfield, you get the following:

	foo->x = 6;	/* foo->x is 1, it would be 0 for int:1 */
	foo->x = 7;	/* foo->x is 1, it would be 1 for int:1 */

Anyway it's good that we agree on the important thing about the patch!

Paolo

> The _only_ thing about _Bool is that it magically casts values to 0,1.
> Single bit bitfield variables have no choice but to already be in that
> range.

