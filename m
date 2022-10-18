Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E747B602040
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 03:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiJRBNg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 21:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiJRBNa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 21:13:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24EC491E3
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 18:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666055609;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PsBDvbs2M4mxVb7McFh5IYYbPQ7mymshNGX5zOJy4Eg=;
        b=NVPVr9iAc8G4oiTCz0trTevtliQ+NqLUXUK5Gnst6ogK47kVQlMuUVeEnLp8sj1GPtoHSQ
        MHZ+5DNDOIlRBpZrLVBk0V1KTB1uwu9lDMDDzf/LxrPunNTnxetkGTX1/hR5EPamNubqDC
        6Kkus7/OYMlgqRbCdjTHryIlbao1zb8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-sHvPlOf4OcC8k6B_KEyumA-1; Mon, 17 Oct 2022 21:13:24 -0400
X-MC-Unique: sHvPlOf4OcC8k6B_KEyumA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6ACE833AEC;
        Tue, 18 Oct 2022 01:13:23 +0000 (UTC)
Received: from [10.64.54.70] (vpn2-54-70.bne.redhat.com [10.64.54.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F5BC14657C6;
        Tue, 18 Oct 2022 01:13:18 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate memory
 sizes
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ajones@ventanamicro.com, pbonzini@redhat.com, maz@kernel.org,
        shuah@kernel.org, oliver.upton@linux.dev, seanjc@google.com,
        peterx@redhat.com, ricarkol@google.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <ac09476d-da8d-db0f-1af2-93dc41251bb0@redhat.com>
Date:   Tue, 18 Oct 2022 09:13:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/18/22 5:36 AM, Maciej S. Szmigiero wrote:
> On 14.10.2022 09:19, Gavin Shan wrote:
>> The addresses and sizes passed to madvise() and vm_userspace_mem_region_add()
>> should be aligned to host page size, which can be 64KB on aarch64. So it's
>> wrong by passing additional fixed 4KB memory area to various tests.
>>
>> Fix it by passing additional fixed 64KB memory area to various tests. After
>> it's applied, the following command works fine on 64KB-page-size-host and
>> 4KB-page-size-guest.
>>
>>    # ./memslot_perf_test -v -s 512
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   .../testing/selftests/kvm/memslot_perf_test.c  | 18 ++++++++++--------
>>   1 file changed, 10 insertions(+), 8 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
>> index d587bd952ff9..e6d34744b45d 100644
>> --- a/tools/testing/selftests/kvm/memslot_perf_test.c
>> +++ b/tools/testing/selftests/kvm/memslot_perf_test.c
>> @@ -25,12 +25,14 @@
>>   #include <kvm_util.h>
>>   #include <processor.h>
>> -#define MEM_SIZE        ((512U << 20) + 4096)
>> -#define MEM_GPA        0x10000000UL
>> +#define MEM_EXTRA_SIZE        0x10000
> 
> So the biggest page size supported right now is 64 KiB - it would be
> good to have an assert somewhere to explicitly check for this
> (regardless of implicit checks present in other calculations).
> 
> Also, an expression like "(64 << 10)" is more readable than a "1"
> with a tail of zeroes (it's easy to add one zero too many or be one
> zero short).
> 

Yes, it makes sense to me. Lets add check in check_memory_sizes(), which
was added in the previous patch, to fail early if host/guest page size
exceeds 64KB.

    if (host_page_size > SIZE_64KiB || guest_page_size > SIZE_64KiB) {
       pr_info("Unsupported page size on host (0x%x) or guest (0x%x)\n",
               host_page_size, guest_page_size);
    }


For the macros, I think all of us agree on KiB, MiB, GiB, TiB and
their variants :)

Thanks,
Gavin

