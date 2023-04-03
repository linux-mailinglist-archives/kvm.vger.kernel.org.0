Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8841A6D3FA6
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 11:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbjDCJCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 05:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbjDCJB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 05:01:59 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4974F764
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 02:01:51 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id l37so16623941wms.2
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 02:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680512510;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FX/AfOVGgB5vKM+l6LZVqChpbR1t60Tg7VDJDBy7XEs=;
        b=v11Mkl+Ploh/P7GDl98DZB30uy5WXLmJXSuMS8jOipmOo1w9B4hIUEUkg5+pfSeyw1
         Fy2vU7pp3bqHQznD/Dpq4OYuU1g6ALwD7/LdjOpW5zFTs08gKG7y5yVu9QTiKymEkOax
         nVWunr4y7rao/JxmL6DENthGgJGGczirf+Uq5e/cHHI4953e+uiSLwRouMiY11KldmY/
         GXYYsd+8JR/2DPeaWFcTa68mADpa3fohwrWWTrPPdTqfJgT4z8y3/U2a3YdisB1qj2MM
         LZ7KTN2M7y1JTGwypJoEaacA0wWUN4m9x5dlC97VU0BtlbxuDST19Rh9RdWOuabtZRB1
         bdkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680512510;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FX/AfOVGgB5vKM+l6LZVqChpbR1t60Tg7VDJDBy7XEs=;
        b=vbvJlBfR+uphpaOPD5En7ujOyCf88GZ0Z3bglM/wSo9kYv88fxPw71a1M/KrVxG/98
         wBdDnr9p+MYZABVjfmvEvt3ma2AgC4gtwkEtN2ZPSc2hEKkwDPUm0sGB7X8FDRNXmSPZ
         0NDPwoDa3nDx7NF6LWUAdpWpJ0A23XCmTVNUPBJ+2cOD8aAx075YnqM3GB5TtGWH1b9A
         8iWnYl2Wbm5kerOVT01sVAfIQqCXxEa5sLd+VqMfFHl3yHaP2nnwEzTRfPENUrvImP4K
         5UqTXUtLVfO4liu4eBW8oZvgW2H8HOyWj1taddEgxyGw2izvzP0VXTcFmHAfpyXMM8b0
         adBw==
X-Gm-Message-State: AO0yUKV534SWMpDOCutMpkEvkPVBbSF8lJvo2P1ODhlXVIy5G0hkZ4/P
        Pu/q/+tv4+PeYa9GAcRrix+/axlSZOKfujVyfrK/Qg==
X-Google-Smtp-Source: AK7set+FvfLqPGgg5fUO5/IsWraC13Evhv/Voch39MT4WzbUJrmwDOopsVLpXIM/9DDUf/ss0FH+OQ==
X-Received: by 2002:a7b:c44b:0:b0:3ed:301c:375c with SMTP id l11-20020a7bc44b000000b003ed301c375cmr26847010wmi.21.1680512510236;
        Mon, 03 Apr 2023 02:01:50 -0700 (PDT)
Received: from ?IPV6:2003:f6:af22:1600:2f4c:bf50:182f:1b04? (p200300f6af2216002f4cbf50182f1b04.dip0.t-ipconnect.de. [2003:f6:af22:1600:2f4c:bf50:182f:1b04])
        by smtp.gmail.com with ESMTPSA id y22-20020a7bcd96000000b003ee42696acesm11391277wmj.16.2023.04.03.02.01.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 02:01:49 -0700 (PDT)
Message-ID: <3255e2f7-432c-32a7-9e28-0752516a5377@grsecurity.net>
Date:   Mon, 3 Apr 2023 11:01:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH v2 2/4] x86/access: CR0.WP toggling write
 to r/o data test
Content-Language: en-US, de-DE
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20230331135709.132713-1-minipli@grsecurity.net>
 <20230331135709.132713-3-minipli@grsecurity.net>
 <ZCcIYMYeDpE8nYm/@google.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZCcIYMYeDpE8nYm/@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31.03.23 18:20, Sean Christopherson wrote:
> On Fri, Mar 31, 2023, Mathias Krause wrote:
>> We already have tests that verify a write access to an r/o page is
> 
> "supervisor write access"
> 
>> successful when CR0.WP=0, but we lack a test that explicitly verifies
>> that the same access will fail after we set CR0.WP=1 without flushing
> 
> s/fail/fault to be more precise about the expected behavior.
> 
>> any associated TLB entries either explicitly (INVLPG) or implicitly
>> (write to CR3). Add such a test.
> 
> Without pronouns:
> 
>     KUT has tests that verify a supervisor write access to an r/o page is
>     successful when CR0.WP=0, but lacks a test that explicitly verifies that
>     the same access faults after setting CR0.WP=1 without flushing any
>     associated TLB entries, either explicitly (INVLPG) or implicitly (write
>     to CR3). Add such a test.

Ok.

>>
>> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
>> ---
>>  x86/access.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 54 insertions(+), 2 deletions(-)
>>
>> diff --git a/x86/access.c b/x86/access.c
>> index 203353a3f74f..d1ec99b4fa73 100644
>> --- a/x86/access.c
>> +++ b/x86/access.c
>> @@ -575,9 +575,10 @@ fault:
>>  		at->expected_error &= ~PFERR_FETCH_MASK;
>>  }
>>  
>> -static void ac_set_expected_status(ac_test_t *at)
>> +static void __ac_set_expected_status(ac_test_t *at, bool flush)
>>  {
>> -	invlpg(at->virt);
>> +	if (flush)
>> +		invlpg(at->virt);
>>  
>>  	if (at->ptep)
>>  		at->expected_pte = *at->ptep;
>> @@ -599,6 +600,11 @@ static void ac_set_expected_status(ac_test_t *at)
>>  	ac_emulate_access(at, at->flags);
>>  }
>>  
>> +static void ac_set_expected_status(ac_test_t *at)
>> +{
>> +	__ac_set_expected_status(at, true);
>> +}
>> +
>>  static pt_element_t ac_get_pt(ac_test_t *at, int i, pt_element_t *ptep)
>>  {
>>  	pt_element_t pte;
>> @@ -1061,6 +1067,51 @@ err:
>>  	return 0;
>>  }
>>  
>> +static int check_write_cr0wp(ac_pt_env_t *pt_env)
> 
> How about check_toggle_cr0_wp() so that it's (hopefully) obvious that the testcase
> does more than just check writes to CR0.WP?  Ah, or maybe the "write" is 

That last sentence lacks a few words. But yeah, the test is about
verifying access permissions of a write operation to a read-only page
wrt toggling CR0.WP.

> 
>> +{
>> +	ac_test_t at;
>> +	int err = 0;
>> +
>> +	ac_test_init(&at, 0xffff923042007000ul, pt_env);
>> +	at.flags = AC_PDE_PRESENT_MASK | AC_PTE_PRESENT_MASK |
>> +		   AC_PDE_ACCESSED_MASK | AC_PTE_ACCESSED_MASK |
>> +		   AC_ACCESS_WRITE_MASK;
>> +	ac_test_setup_ptes(&at);
>> +
>> +	/*
>> +	 * Under VMX the guest might own the CR0.WP bit, requiring KVM to
>> +	 * manually keep track of its state where needed, e.g. in the guest
>> +	 * page table walker.
>> +	 *
>> +	 * We load CR0.WP with the inverse value of what would be used during
> 
> Avoid pronouns in comments too.  If the immediate code is doing something, phrase
> the comment as a command (same "rule" as changelogs), e.g.

Ok, will try to pay more attention to the wording in the future!

> 
> 	/*
> 	 * Load CR0.WP with the inverse value of what will be used during the
> 	 * access test, and toggle EFER.NX to coerce KVM into rebuilding the
> 	 * current MMU context based on the soon-to-be-stale CR0.WP.
> 	 */
> 
>> +	 * the access test and toggle EFER.NX to flush and rebuild the current
>> +	 * MMU context based on that value.
>> +	 */
>> +
>> +	set_cr0_wp(1);
>> +	set_efer_nx(1);
>> +	set_efer_nx(0);
> 
> Rather than copy+paste and end up with a superfluous for-loop, through the guts
> of the test into a separate inner function, e.g.
> 
>   static int __check_toggle_cr0_wp(ac_test_t *at, bool cr0_wp_initially_set)
> 
> and then use @cr0_wp_initially_set to set/clear AC_CPU_CR0_WP_MASK.  And for the
> printf(), check "at.flags & AC_CPU_CR0_WP_MASK" to determine whether the access
> was expected to fault or succeed.  That should make it easy to test all the
> combinations.

Well, I thought of a helper function too and folding the value of CR0.WP
into the error message. But looking at other tests I got the impression,
it's more important to make the test conditions more obvious than it is
to write compact code. This not only makes it easier to see what gets
tested but also shows what the test was intended to do. If, instead, the
error message is based on the value of AC_CPU_CR0_WP_MASK, one not only
has to check what value it was set to but also look up what its meaning
really is, like if set, does it mean CR0.WP=0 or 1?

That said, your below changes make it more obvious, so the helper might
not be such a bad idea in the end.

> 
> And then when FEP comes along, add that as a param too.  FEP is probably better
> off passing the flag instead of a bool, e.g.
> 
>   static int __check_toggle_cr0_wp(ac_test_t *at, bool cr0_wp_initially_set,
> 				   int fep_flag)
> 
> Ah, a better approach would be to capture the flags in a global macro:
> 
>   #define TOGGLE_CR0_WP_BASE_FLAGS (base flags without CR0_WP_MASK or FEP_MASK)
> 
> and then take the "extra" flags as a param
> 
>   static int __check_toggle_cr0_wp(ac_test_t *at, int flags)
> 
> which will yield simple code in the helper
> 
>   ac->flags = TOGGLE_CR0_WP_BASE_FLAGS | flags;
> 
> and somewhat self-documenting code in the caller:
> 
>   ret = __check_toggle_cr0_wp(&at, AC_CPU_CR0_WP_MASK);
> 
>   ret = __check_toggle_cr0_wp(&at, 0);
> 
>   ret = __check_toggle_cr0_wp(&at, AC_CPU_CR0_WP_MASK | FEP_MASK);
> 
>   ...

Yeah, looks good indeed. Will change!

> 
>> +
>> +	if (!ac_test_do_access(&at)) {
>> +		printf("%s: CR0.WP=0 r/o write fail\n", __FUNCTION__);
> 
> "fail" is ambiguous.  Did the access fault, or did the test fail?  Better would
> be something like (in the inner helper):
> 
> 		printf("%s: supervisor write with CR0.WP=%d did not %S as expected\n",
> 		       __FUNCTION__, !!(at->flags & AC_CPU_CR0_WP_MASK),
> 		       (at->flags & AC_CPU_CR0_WP_MASK) ? "FAULT" : "SUCCEED");

Thanks,
Mathias
