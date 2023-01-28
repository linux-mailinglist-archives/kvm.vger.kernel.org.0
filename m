Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1639767F319
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 01:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbjA1AWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 19:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233604AbjA1AVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 19:21:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD808E4B3
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 16:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674865102;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UFSxdYO5nDtftBiB4L6W7S5MGdfu2Qx9OX4YoB+ycGk=;
        b=ZfwbvQjjVvuwFsXgfM05sz81SZ57/TDX0C4n2cP5CbIlKUjWNpQd0KxNIMgRlrxB/z7z3u
        2P3KrClRVSDqEl+6vBBLsH0JEaWGhoqXYHQHS6LmTmYmCc1S6/2E99mCqXH2jKmVLChLc5
        NIs/bzLkm3hMz60wBMPaF/LSCIePHvI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-vEU1w1AuP9u29RJkzCLK-A-1; Fri, 27 Jan 2023 19:18:16 -0500
X-MC-Unique: vEU1w1AuP9u29RJkzCLK-A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A839858F0E;
        Sat, 28 Jan 2023 00:18:15 +0000 (UTC)
Received: from [10.64.54.64] (vpn2-54-64.bne.redhat.com [10.64.54.64])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E0A67492C18;
        Sat, 28 Jan 2023 00:18:07 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 1/4] KVM: arm64: Include kvm_mmu.h from vgic.h
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, corbet@lwn.net, maz@kernel.org,
        james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, yuzhe@nfschina.com,
        seanjc@google.com, isaku.yamahata@intel.com, ricarkol@google.com,
        eric.auger@redhat.com, renzhengeek@gmail.com, reijiw@google.com,
        shan.gavin@gmail.com
References: <20230127235150.17025-1-gshan@redhat.com>
 <20230127235150.17025-2-gshan@redhat.com> <Y9Ro6IEjPVeQfmUQ@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <be359c63-fbbb-0ced-d023-0df9dc6b3527@redhat.com>
Date:   Sat, 28 Jan 2023 11:18:05 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y9Ro6IEjPVeQfmUQ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On 1/28/23 11:14 AM, Oliver Upton wrote:
> On Sat, Jan 28, 2023 at 07:51:47AM +0800, Gavin Shan wrote:
>> We need a unified helper in 'kvm/vgic/vgic.h' to write guest memory. In
>> the helper, the check of no-running-vcpu context for dirty ring will be
>> applied. kvm_write_guest_lock(), defined in 'include/asm/kvm_mmu.h', is
>> going to be dereferenced by the unified helper.
>>
>> Include 'include/asm/kvm_mmu.h' to 'kvm/vgic/vgic.h' to avoid including
>> the former header file when the later one is needed. With the change,
>> the duplicate inclusions of 'include/asm/kvm_mmu.h' are removed.
>>
>> No functional change intended.
>>
>> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> 
> No, I did not suggest for you to do this. I had suggested you just
> include asm/kvm_mmu.h from the vgic header, not to go and remove it from
> all the files that include vgic.h.
> 
> Who cares if kvm_mmu.h gets included twice? Include guards exist for this
> exact reason.
> 

Ok, I misundertood your suggestion. Could you drop PATCH[v4 1/4] and include
'kvm_mmu.h' to 'vgic.h'? Otherwise, I need to respin for v5. Please let me
know your preference.

Thanks,
Gavin

