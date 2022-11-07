Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C1B61FD3A
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbiKGSTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:19:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiKGSTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:19:06 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722B9248D9
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:18:03 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c188-20020a25c0c5000000b006d8eba07513so862897ybf.17
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 10:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SVpJ7aIaCnc27Nai+tOQ95kOWQRaCZF+MoF86rbtvzo=;
        b=gZWeOac7wLd9R+5qZZfAryw6P7TtiwppmzSb2swP+iB/1ToMUgSClD7sfhJuf3ALAk
         HlT/7jgxACseqkXHRNzdW9vZHUGzDc1MephGBc4VHgaX5qcxY0EKXKJ55oHKbXnlbK/U
         ZuTe5m8Lvsh967hU9cAVQuY9uuHIXyiQIppzpLdGA3itno6e2J1g3E4hn92zv0T/qVP9
         vEalTBDokVWZ5mAKD0KysLYvWvK1JpzylZOc1rHrJc/dyxG3n5qVe78VZc8YD5Vr5kkA
         tD8w8WRrG2amRPCr2dKMWqMHOR4TjfknHHdgnYK8S/+aNw5D0z8cDguZEdnBqFbMqk2Y
         hr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SVpJ7aIaCnc27Nai+tOQ95kOWQRaCZF+MoF86rbtvzo=;
        b=fH7UyG3aV77Iz+g1iBoGBd/BFCScKiw7pw+7kItMOqJpwMOMSA13z/6hreZqIdVcIR
         OKJ+Il+vgsu6Kzg/cYu6YmW2WAB8sbRPy5gO6nKf23gLx7mUvLIAf1YHMbKLO0oxISMB
         USRoq3YkZfNJQiRxOdL23/akTPu93s00mgzCJIaqx+rqmT6BqMqUhZ6HWx8HkheMCb6w
         w+toVeQVNG2vxc+uqO7q9IFtfdULXTGlvrv/bF+3AsFSh1RfC48Vd2LDKx6wdAFEVo8O
         Ub/kMBMZKmnqi1LsXOPgObwrL5XZXyFppZsRe4uYCZACut+N6DS/T5oe70U+jZztRgBI
         pbSA==
X-Gm-Message-State: ANoB5pk8JvKfdA7nKqzDtE2PFs0MiDuzuAWez9UeFCCMgLXXp4HzFP5w
        qOtmtRZRiW/ffLkBmLzc/nW9SGVGznzIgRMYZA==
X-Google-Smtp-Source: AA0mqf6BhOmNbpecyx5hygRjdl3Vj/zQDs60nUh89NoOI0HdckPtnaXbFX0YpmuZ4KdyPyVHsSbe9fs6ExwXmAoQhg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:7386:0:b0:6d3:1b77:58ea with SMTP
 id o128-20020a257386000000b006d31b7758eamr18164590ybc.445.1667845082783; Mon,
 07 Nov 2022 10:18:02 -0800 (PST)
Date:   Mon, 07 Nov 2022 18:18:02 +0000
In-Reply-To: <Y2PsAAmRX78Dky2l@google.com> (message from David Matlack on Thu,
 3 Nov 2022 09:27:44 -0700)
Mime-Version: 1.0
Message-ID: <gsnt5yfqtyqt.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v9 2/4] KVM: selftests: create -r argument to specify
 random seed
From:   Colton Lewis <coltonlewis@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Matlack <dmatlack@google.com> writes:

> On Wed, Nov 02, 2022 at 04:00:05PM +0000, Colton Lewis wrote:
>> Create a -r argument to specify a random seed. If no argument is
>> provided, the seed defaults to 1. The random seed is set with
>> perf_test_set_random_seed() and must be set before guest_code runs to
>> apply.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   tools/testing/selftests/kvm/dirty_log_perf_test.c    | 12 ++++++++++--
>>   tools/testing/selftests/kvm/include/perf_test_util.h |  2 ++
>>   tools/testing/selftests/kvm/lib/perf_test_util.c     |  6 ++++++
>>   3 files changed, 18 insertions(+), 2 deletions(-)

>> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c  
>> b/tools/testing/selftests/kvm/dirty_log_perf_test.c
>> index f99e39a672d3..c97a5e455699 100644
>> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
>> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
>> @@ -132,6 +132,7 @@ struct test_params {
>>   	bool partition_vcpu_memory_access;
>>   	enum vm_mem_backing_src_type backing_src;
>>   	int slots;
>> +	uint32_t random_seed;
>>   };

>>   static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool  
>> enable)
>> @@ -225,6 +226,9 @@ static void run_test(enum vm_guest_mode mode, void  
>> *arg)
>>   				 p->slots, p->backing_src,
>>   				 p->partition_vcpu_memory_access);

>> +	/* If no argument provided, random seed will be 1. */
>> +	pr_info("Random seed: %u\n", p->random_seed);
>> +	perf_test_set_random_seed(vm, p->random_seed ? p->random_seed : 1);

> If the user passes `-r 0` or does not pass `-r` at all, this will print
> "Random seed: 0" and then proceed to use 1 as the random seed, which
> seems unnecessarily misleading.


Fair point, forgot to change the print statement when I made that
change.

> If you want the default random seed to be 1, you can initialize
> p.random_seed to 1 before argument parsing (where all the other
> test_params are default initialized), then the value you print here will
> be accurate and you don't need the comment or ternary operator.


Will do. This also need a argument parsing check to specifically prevent
0 since my reason for changing in the first place is realizing 0 is not
a valid input to the pRNG I chose. Anything multiplied by 0 is 0 so a 0
seed produces a string of 0s. libc random also chooses 1 if seed is not
specified.
