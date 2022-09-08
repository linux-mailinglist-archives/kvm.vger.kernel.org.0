Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229F15B257D
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 20:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiIHSSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 14:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiIHSSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 14:18:05 -0400
Received: from mail-oa1-x49.google.com (mail-oa1-x49.google.com [IPv6:2001:4860:4864:20::49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB8DF1F22
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 11:18:03 -0700 (PDT)
Received: by mail-oa1-x49.google.com with SMTP id 586e51a60fabf-1275c2d65feso6777477fac.4
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 11:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date;
        bh=Ao/oO1ci/4vtHJ0QANtxpP7WSXi8ShDFQ+MjbHPJ47I=;
        b=Jxl56kd0YaqvhEwU4v5DrIoZ24M/fYQXNiHDZhicbixjOwGTfGLRUf7kqY2HVx7PKQ
         E5jHMCyf+R6L2PCdck3AnxAJ+YTSDFYkVIyDr9t6Ijsmvbrg8+D95xRMMBexo/+z6X9O
         xe6r5JKvLPfgTOWREzYkqhv4b7aPMCmbrpe0tfrXSUdiYQaBg9kTz4KsB3GQSHC/vr5Q
         kX7vmjfwAfmHCZO1fZynlgbTY7ySwDgul9L0JHuR633+mv2JovRoXC7gxGEthIM1WBl8
         vkmOBw9RTjRunBLvVLayl6xKVlfv92pLyHAEUB6+88XBfQ3VSTe3PS/gPW+r2xhulUzc
         kFGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Ao/oO1ci/4vtHJ0QANtxpP7WSXi8ShDFQ+MjbHPJ47I=;
        b=UGOPWE6gVHm7w0G/3A45h50gnUiLga4ZeV/XPprX1G2T4Zc3bKPjsm2u7FIvYPH4EC
         qHQcYNv6kN28XqTbpqogNW4PmeSYwgd3ZyphcDgXxhJ92LZ6j5iMFCnJfQuu8Tsw9o4V
         IMciS1mH9obJKwapeiysu9ajcTG06ggEeADpqq8POZhMzZZMmqhKr9QBVdPA685sn19B
         st9gKW5/ZjEvdsmrrKPLUUx3wWODzKXtpyFuJYnndisv1rn9wEqY+Djz3ZRd4RXz51ZV
         zqbwi1SN+RPACW8BEb10w2SiMwn2jU8w3t4NuyUIhAGabx7+9d3UzsWM1FVLOz4D56yM
         yPhQ==
X-Gm-Message-State: ACgBeo0xtDjn2iVgyHLfYAXK7TtZish/sK37ASQaji1Xx+dyCt1hghPO
        NnWq91n+DOGcZQiVXf75tPTo43WLA1u+4F2mYA==
X-Google-Smtp-Source: AA6agR6CHWrebShVQmjcMMGeluex+O/dFuJdWVkrFGFZmDDaI74Q610uFXyP31/SH0EgFJGt7kvbNPPflb6a4Awa9g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6808:8db:b0:344:fb71:2159 with
 SMTP id k27-20020a05680808db00b00344fb712159mr2038974oij.34.1662661082624;
 Thu, 08 Sep 2022 11:18:02 -0700 (PDT)
Date:   Thu, 08 Sep 2022 18:18:01 +0000
In-Reply-To: <Yxoa78p2QTXXgZej@google.com> (message from Ricardo Koller on
 Thu, 8 Sep 2022 09:40:15 -0700)
Mime-Version: 1.0
Message-ID: <gsntpmg5pw6e.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 2/3] KVM: selftests: Randomize which pages are written
 vs read.
From:   Colton Lewis <coltonlewis@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, oupton@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ricardo Koller <ricarkol@google.com> writes:

> On Thu, Sep 01, 2022 at 07:52:36PM +0000, Colton Lewis wrote:
>> Randomize which pages are written vs read using the random number
>> generator.
> nit:       ^ I haven't seen this style before (the period at the end)


I will change style in future patches, but checkpatch doesn't complain
and there are many examples in git history.

$ git log --oneline | grep '\.$' | wc -l
   43812

>> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c  
>> b/tools/testing/selftests/kvm/dirty_log_perf_test.c
>> index 2f91acd94130..c9441f8354be 100644
>> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
>> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
>> @@ -122,10 +122,10 @@ static void vcpu_worker(struct perf_test_vcpu_args  
>> *vcpu_args)
>>   struct test_params {
>>   	unsigned long iterations;
>>   	uint64_t phys_offset;
>> -	int wr_fract;
>>   	bool partition_vcpu_memory_access;
>>   	enum vm_mem_backing_src_type backing_src;
>>   	int slots;
>> +	uint32_t write_percent;

> nit: make it an int to match perf_test_args.write_percent


That inconsistency bothers me. I'll make perf_test_args.write_percent a
uint32 instead since that's what most of the code uses. Will take care
of your other nits while I'm at it.

>> @@ -413,10 +414,11 @@ int main(int argc, char *argv[])
>>   		case 'b':
>>   			guest_percpu_mem_size = parse_size(optarg);
>>   			break;
>> -		case 'f':
>> -			p.wr_fract = atoi(optarg);
>> -			TEST_ASSERT(p.wr_fract >= 1,
>> -				    "Write fraction cannot be less than one");
>> +		case 'w':
>> +			perf_test_args.write_percent = atoi(optarg);

> I'm a bit confused, where is p.write_percent being set? I later see

> 	perf_test_set_write_percent(vm, p->write_percent);

> that rewrites perf_test_args.write_percent with whatever was in
> p->write_percent.


Hmm. Thought I fixed that mistake before. Should be p.write_percent
there.
