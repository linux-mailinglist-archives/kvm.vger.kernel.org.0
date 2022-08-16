Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445C65958B8
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 12:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbiHPKoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 06:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234896AbiHPKny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 06:43:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13A37EEF36
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 03:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660644145;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tfchwm6zPrjSwgmik9MW07uDL8hwOaly4SF6JMKfNsI=;
        b=jCOJLvsiGrdbYayjVRSZhweW0MPeph3pQT0kbc8xr8QJKNL3vqxCCPToOjFT7pZugZDYH+
        1ADp/zbr6NIdbkuZjUm8rno4IF1lgs/zg5L9vzBTmit7GdVxcKMiY55rYwrMBuMeB3sleh
        BM15cIGZGKy6+qKpKP2iNZjrLCulczU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-kEKcHHxjNfC1IMd4KtneRA-1; Tue, 16 Aug 2022 06:02:21 -0400
X-MC-Unique: kEKcHHxjNfC1IMd4KtneRA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E0AA1C05EB6;
        Tue, 16 Aug 2022 10:02:21 +0000 (UTC)
Received: from [10.64.54.16] (vpn2-54-16.bne.redhat.com [10.64.54.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7992940D2827;
        Tue, 16 Aug 2022 10:02:17 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [KVM] e923b0537d: kernel-selftests.kvm.rseq_test.fail
From:   Gavin Shan <gshan@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        kernel test robot <oliver.sang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Andrew Jones <andrew.jones@linux.dev>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com, xudong.hao@intel.com,
        regressions@lists.linux.dev
References: <Yvn60W/JpPO8URLY@xsang-OptiPlex-9020>
 <Yvq9wzXNF4ZnlCdk@google.com>
 <5034abb9-e176-d480-c577-1ec5dd47182b@redhat.com>
Message-ID: <9bfeae26-b4b1-eedb-6cbd-b4f9f1e1cc55@redhat.com>
Date:   Tue, 16 Aug 2022 20:02:14 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <5034abb9-e176-d480-c577-1ec5dd47182b@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 8/16/22 3:02 PM, Gavin Shan wrote:
> On 8/16/22 7:42 AM, Sean Christopherson wrote:
>> On Mon, Aug 15, 2022, kernel test robot wrote:
>>> commit: e923b0537d28e15c9d31ce8b38f810b325816903 ("KVM: selftests: Fix target thread to be migrated in rseq_test")
>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
>>
>> ...
>>
>>> # selftests: kvm: rseq_test
>>> # ==== Test Assertion Failure ====
>>> #   rseq_test.c:278: i > (NR_TASK_MIGRATIONS / 2)
>>> #   pid=49599 tid=49599 errno=4 - Interrupted system call
>>> #      1    0x000000000040265d: main at rseq_test.c:278
>>> #      2    0x00007fe44eed07fc: ?? ??:0
>>> #      3    0x00000000004026d9: _start at ??:?
>>> #   Only performed 23174 KVM_RUNs, task stalled too much?
>>> #
>>> not ok 56 selftests: kvm: rseq_test # exit=254
>>
>> ...
>>
>>> # Automatically generated file; DO NOT EDIT.
>>> # Linux/x86_64 5.19.0-rc6 Kernel Configuration
>>> #
>>> CONFIG_CC_VERSION_TEXT="gcc-11 (Debian 11.3.0-3) 11.3.0"
>>> CONFIG_CC_IS_GCC=y
>>> CONFIG_GCC_VERSION=110300
>>> CONFIG_CLANG_VERSION=0
>>> CONFIG_AS_IS_GNU=y
>>> CONFIG_AS_VERSION=23800
>>> CONFIG_LD_IS_BFD=y
>>> CONFIG_LD_VERSION=23800
>>> CONFIG_LLD_VERSION=0
>>
>> Assuming 23800 == 2.38, this is a known issue.
>>
>> https://lore.kernel.org/all/20220810104114.6838-1-gshan@redhat.com
>>
> 
> It's probably different story this time. The assert is triggered because
> of the following instructions. I would guess the reason is vcpu thread
> has been running on CPU where we has high CPU load. In this case, the
> vcpu thread can't be run in time. More specific, the vcpu thread can't
> be run in the 1 - 10us time window, which is specified by the migration
> worker (thread).
> 
>      TEST_ASSERT(i > (NR_TASK_MIGRATIONS / 2),
>                  "Only performed %d KVM_RUNs, task stalled too much?\n", i);
> 
> I think we need to improve the handshake mechanism between the vcpu thread
> and migration worker. In current implementation, the handshake is done through
> the atomic counter. The mechanism is simple enough, but vcpu thread can miss
> the aforementioned time window. Another issue is the test case much more time
> than expected to finish.
> 
> Sean, if you think it's reasonable, I can figure out something to do:
> 
> - Reuse the atomic counter for a full synchronization between these two
>    threads. Something like below:
> 
>    #define RSEQ_TEST_STATE_RUN_VCPU       0     // vcpu_run()
>    #define RSEQ_TEST_STATE_MIGRATE        1     // sched_setaffinity()
>    #define RSEQ_TEST_STATE_CHECK          2     // Check rseq.cpu_id and get_cpu()
> 
>    The atomic counter is reset to RSEQ_TEST_STATE_RUN_VCPU after RSEQ_TEST_STATE_RUN_VCPU
> 
> - Reduce NR_TASK_MIGRATIONS from 100000 to num_of_online_cpus(). With this,
>    less time is needed to finish the test case.
> 

I'm able to recreate the issue on my local arm64 system.

- From the source code, the iteration count is changed from 100000 to 1000
- Only CPU#0 and CPU#1 are exposed in calc_min_max_cpu, meaning other CPUs
   are cleared from @possible_mask
- Run some CPU bound task on CPU#0 and CPU#1
   # while true; do taskset -c 0 ./a; done
   # while true; do taskset -c 1 ./a; done
- Run 'rseq_test' and hit the issue
   # ./rseq_test
   calc_min_max_cpu: nproc=224
   calc_min_max_cpu: min_cpu=0, max_cpu=1
   main: Required tests: 1000   Succeeds: 1
   ==== Test Assertion Failure ====
     rseq_test.c:280: i > (NR_TASK_MIGRATIONS / 2)
     pid=9624 tid=9624 errno=4 - Interrupted system call
        1	0x0000000000401cf3: main at rseq_test.c:280
        2	0x0000ffffbc64679b: ?? ??:0
        3	0x0000ffffbc64686b: ?? ??:0
        4	0x0000000000401def: _start at ??:?
     Only performed 1 KVM_RUNs, task stalled too much?

Thanks,
Gavin


