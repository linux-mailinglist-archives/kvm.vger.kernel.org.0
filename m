Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4A76ECB1D
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 13:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbjDXLP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 07:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjDXLPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 07:15:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5291E30D5
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 04:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682334878;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PWrCJMrvslxtx+4S715HvGi2nPbXA+BOmSMzUbP88XQ=;
        b=OZ9K77Q7GcTHikhwcwfJrf2aLPByfmqdzcGGiN6J80WjT+ZPjahUESx45Q98BEsjQza3y1
        3ATMrY6BmXKSXUe4fCE/P/KPMdcuJZx5SzrF6/iwNAyRScmlYfQppiT3cz52hl8dVVErJK
        7et/eDmhuoVsuW+UuA5HQh+LTT1x2OY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-Jk-P9MJ8Nuy18hkCT35kZw-1; Mon, 24 Apr 2023 07:14:35 -0400
X-MC-Unique: Jk-P9MJ8Nuy18hkCT35kZw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 064DF185A78F;
        Mon, 24 Apr 2023 11:14:34 +0000 (UTC)
Received: from [10.72.12.189] (ovpn-12-189.pek2.redhat.com [10.72.12.189])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B602949AF0;
        Mon, 24 Apr 2023 11:14:25 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 08/12] KVM: arm64: Add
 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
To:     Ricardo Koller <ricarkol@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com,
        Oliver Upton <oliver.upton@linux.dev>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-10-ricarkol@google.com>
 <58664917-edfa-8c7a-2833-0664d83277d6@redhat.com>
 <ZEWUvTmdfSOwOPOz@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <e3b0baba-dc0d-f634-e53f-59cc0fd99973@redhat.com>
Date:   Mon, 24 Apr 2023 19:14:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <ZEWUvTmdfSOwOPOz@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/24/23 4:27 AM, Ricardo Koller wrote:
> On Mon, Apr 17, 2023 at 03:04:47PM +0800, Gavin Shan wrote:
>> On 4/9/23 2:29 PM, Ricardo Koller wrote:
>>> Add a capability for userspace to specify the eager split chunk size.
>>> The chunk size specifies how many pages to break at a time, using a
>>> single allocation. Bigger the chunk size, more pages need to be
>>> allocated ahead of time.
>>>
>>> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
>>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
>>> ---
>>>    Documentation/virt/kvm/api.rst       | 28 ++++++++++++++++++++++++++
>>>    arch/arm64/include/asm/kvm_host.h    | 15 ++++++++++++++
>>>    arch/arm64/include/asm/kvm_pgtable.h | 18 +++++++++++++++++
>>>    arch/arm64/kvm/arm.c                 | 30 ++++++++++++++++++++++++++++
>>>    arch/arm64/kvm/mmu.c                 |  3 +++
>>>    include/uapi/linux/kvm.h             |  2 ++
>>>    6 files changed, 96 insertions(+)
>>>
>>
>> With the following comments addressed:
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>

[...]

>>
>>> +static inline bool kvm_is_block_size_supported(u64 size)
>>> +{
>>> +	bool is_power_of_two = !((size) & ((size)-1));
>>> +
>>> +	return is_power_of_two && (size & kvm_supported_block_sizes());
>>> +}
>>> +
>>
>> IS_ALIGNED() maybe used here.
> 
> I've been trying to reuse some bitmap related function in the kernel,
> like IS_ALIGNED(), but can't find anything. Or at least it doesn't occur
> to me how.
> 
> kvm_is_block_size_supported() returns true if @size matches only one of
> the bits set in kvm_supported_block_sizes(). For example, given these
> supported sizes: 10000100001000.
> 
> kvm_is_block_size_supported(100000000) => true
> kvm_is_block_size_supported(1100) => false
> 

I was actually thinking of @is_power_of_two is replaced by IS_ALIGNED(),
For example:

static inline bool kvm_is_block_size_supported(u64 size)
{
     return IS_ALIGNED(size, size) && (size & kvm_supported_block_sizes());
}

IS_ALIGNED() is defined in include/linux/align.h, as below. It's almost
similar to '((size) & ((size)-1))'

#define IS_ALIGNED(x, a)                (((x) & ((typeof(x))(a) - 1)) == 0)

Thanks,
Gavin

