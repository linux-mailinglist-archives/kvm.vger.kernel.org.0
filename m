Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A32624073
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 11:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiKJKz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 05:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiKJKzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 05:55:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4650A6A742
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 02:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668077663;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NpgGU2I/tE+Cblp78lY33qKu10Xyg6kfJBT0/tIEJsk=;
        b=SP3joMHGO969nuhErU6PU/Su6gOc6/obPoAk5L+KtAD1QMQ1R42hgPKVTPTyGYmfvXgWhk
        tnuhp3IT/cQeJrlOdEHOeHfhlIZX1ILNsknahd5ZRmJOWG4c7unvMcmps0gEkQ49Uw2YYi
        EjQhChARZoYtE++XAP4w8e5IOUrHu8w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-7OyvaXjfPfyzXgoyEastcg-1; Thu, 10 Nov 2022 05:54:22 -0500
X-MC-Unique: 7OyvaXjfPfyzXgoyEastcg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6779F833AEF;
        Thu, 10 Nov 2022 10:54:21 +0000 (UTC)
Received: from [10.64.54.49] (vpn2-54-49.bne.redhat.com [10.64.54.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 44E19C1908A;
        Thu, 10 Nov 2022 10:54:15 +0000 (UTC)
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
Message-ID: <3903eeef-e037-9651-6041-0d16c29d67b0@redhat.com>
Date:   Thu, 10 Nov 2022 18:54:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <91d563b6-5f1c-5ecc-0a40-7d8838770b22@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

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

If possible, could you please merge this series to 'next' branch either?
I hope it can be merged early because our downstream needs the fixes to
make the test case work. It's definitely fine to wait for more comments,
but I haven't receive any more comments in last month :)

Thanks,
Gavin

