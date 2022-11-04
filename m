Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17FE761A628
	for <lists+kvm@lfdr.de>; Sat,  5 Nov 2022 00:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiKDX6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 19:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKDX6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 19:58:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207CD419B6
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 16:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667606278;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZnzJmimE900iiRy7VTWPGN9EpNmm/Y1LD4I/QC6tB0Q=;
        b=JPAcdJx6TKr3yek8G/LwnDJQQZDMOgViSG17nENe6z1o9mRj3pfVYEBzDZu1NTwe21dz2N
        MB0WUnv5V5mZZyjqUTK80vsWABDrhQHZ1eyO//SPsPodnifv4rumDi/nwsd6UwNILcWpNs
        y7vgwtUwVBYIU3EN9z+jAMOwf+HR5Ts=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-T678CyveNP-D_kNb-7hxrA-1; Fri, 04 Nov 2022 19:57:57 -0400
X-MC-Unique: T678CyveNP-D_kNb-7hxrA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20CF785A583;
        Fri,  4 Nov 2022 23:57:46 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 343EFC16932;
        Fri,  4 Nov 2022 23:57:26 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 0/6] KVM: selftests: memslot_perf_test: aarch64
 cleanup/fixes
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
        ajones@ventanamicro.com, kvmarm@lists.linux.dev, shuah@kernel.org,
        peterx@redhat.com, oliver.upton@linux.dev, seanjc@google.com,
        ricarkol@google.com, zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221020071209.559062-1-gshan@redhat.com>
 <91d563b6-5f1c-5ecc-0a40-7d8838770b22@maciej.szmigiero.name>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <ee1167f3-5b43-55a9-c815-b759d243dc4e@redhat.com>
Date:   Sat, 5 Nov 2022 07:57:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <91d563b6-5f1c-5ecc-0a40-7d8838770b22@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/25/22 7:18 AM, Maciej S. Szmigiero wrote:
> On 20.10.2022 09:12, Gavin Shan wrote:
>> kvm/selftests/memslots_perf_test doesn't work with 64KB-page-size-host
>> and 4KB-page-size-guest on aarch64. In the implementation, the host and
>> guest page size have been hardcoded to 4KB. It's ovbiously not working
>> on aarch64 which supports 4KB, 16KB, 64KB individually on host and guest.
>>
>> This series tries to fix it. After the series is applied, the test runs
>> successfully with 64KB-page-size-host and 4KB-page-size-guest.
>>
>>     # ./memslots_perf_tests -v -s 512
>>
>> Since we're here, the code is cleaned up a bit as PATCH[1-3] do. The
>> other patches are fixes to handle the mismatched host/guest page
>> sized.
>>
>> v1: https://lore.kernel.org/kvmarm/20221014071914.227134-1-gshan@redhat.com/T/#t
>> v2: https://lore.kernel.org/kvmarm/20221018040454.405719-1-gshan@redhat.com/T/#t
>>
>> Changelog
>> =========
>> v3:
>>    * Improved comments about MEM_TEST_MOVE_SIZE, which is set
>>      to 64KB in PATCH[v3 4/6] and finally fixed to 192KB in
>>      PATCH[v3 5/6].                                              (Maciej)
>>    * Use size instead of pages to do the comparison in
>>      test_memslot_move_prepare()                                 (Maciej)
>>    * Use tools/include/linux/sizes.h instead of inventing
>>      our own macros.                                             (Oliver)
>> v2:
>>    * Pick the smaller value between the ones specified by
>>      user or probed from KVM_CAP_NR_MEMSLOTS in PATCH[v2 3/6]    (Maciej)
>>    * Improved comments about MEM_TEST_MOVE_SIZE in
>>      PATCH[v2 4/6]                                               (Maciej)
>>    * Avoid mismatched guest page size after VM is started in
>>      prepare_vm() in PATCH[v2 4/6]                               (Maciej)
>>    * Fix condition to check MEM_TEST_{UNMAP, UNMAP_CHUNK}_SIZE
>>      in check_memory_size() in PATCH[v2 4/6]                     (Maciej)
>>    * Define base and huge page size in kvm_util_base.h in
>>      PATCH[v2 5/6]                                               (Sean)
>>    * Add checks on host/guest page size in check_memory_size()
>>      and fail early if any of them exceeds 64KB in PATCH[v2 5/6] (Maciej)
>>
>>
>> Gavin Shan (6):
>>    KVM: selftests: memslot_perf_test: Use data->nslots in prepare_vm()
>>    KVM: selftests: memslot_perf_test: Consolidate loop conditions in
>>      prepare_vm()
>>    KVM: selftests: memslot_perf_test: Probe memory slots for once
>>    KVM: selftests: memslot_perf_test: Support variable guest page size
>>    KVM: selftests: memslot_perf_test: Consolidate memory
>>    KVM: selftests: memslot_perf_test: Report optimal memory slots
>>
> 
> This patch set now looks good to me, so for the whole series:
> Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> 

Thanks for your time on reviews, Maciej. The broken test case was reported
in our downstream Linux, which means our downstream linux needs the improvements
and fixes to make the test case working.

Thanks,
Gavin

