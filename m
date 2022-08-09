Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5688A58D484
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 09:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238144AbiHIH1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 03:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237496AbiHIH1C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 03:27:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A37AF20F61
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 00:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660030020;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=58ycySmE5DZLA6nFa+M3yTmfckqgxGPNOPL3Wz/hH9I=;
        b=eWDcQlx/TwE5DuAUj5ipHX3ZRpNsLlbn3aXdscU9mFBiUcL2xeQvKj9o1sr4O9nr3y7z7O
        fc0p2nQOartzo/BvopfxRM6XdCy6+1znAKH9MScbBZNzCDxzKPdsx9UagQCpEsWKeGgDwU
        vP6pXzJYZ3wrRLR/U8fhL6hqpMcoDL0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-bNGKTN3lOaC_mqGjTKJ4WA-1; Tue, 09 Aug 2022 03:26:56 -0400
X-MC-Unique: bNGKTN3lOaC_mqGjTKJ4WA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16E1A8039A6;
        Tue,  9 Aug 2022 07:26:56 +0000 (UTC)
Received: from [10.64.54.189] (vpn2-54-189.bne.redhat.com [10.64.54.189])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ADF60492C3B;
        Tue,  9 Aug 2022 07:26:51 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 1/2] KVM: selftests: Make rseq compatible with glibc-2.35
To:     Florian Weimer <fweimer@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        andrew.jones@linux.dev, seanjc@google.com,
        mathieu.desnoyers@efficios.com, yihyu@redhat.com,
        shan.gavin@gmail.com
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-2-gshan@redhat.com>
 <8735e6ncxw.fsf@oldenburg.str.redhat.com>
 <7844e3fa-e49e-de75-e424-e82d3a023dd6@redhat.com>
 <87o7wtnay6.fsf@oldenburg.str.redhat.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <616d4de6-81f6-9d14-4e57-4a79fec45690@redhat.com>
Date:   Tue, 9 Aug 2022 19:27:44 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87o7wtnay6.fsf@oldenburg.str.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Florian,

On 8/9/22 5:16 PM, Florian Weimer wrote:
>>> __builtin_thread_pointer doesn't work on all architectures/GCC
>>> versions.
>>> Is this a problem for selftests?
>>>
>>
>> It's a problem as the test case is running on all architectures. I think I
>> need introduce our own __builtin_thread_pointer() for where it's not
>> supported: (1) PowerPC  (2) x86 without GCC 11
>>
>> Please let me know if I still have missed cases where
>> __buitin_thread_pointer() isn't supported?
> 
> As far as I know, these are the two outliers that also have rseq
> support.  The list is a bit longer if we also consider non-rseq
> architectures (csky, hppa, ia64, m68k, microblaze, sparc, don't know
> about the Linux architectures without glibc support).
> 

For kvm/selftests, there are 3 architectures involved actually. So we
just need consider 4 cases: aarch64, x86, s390 and other. For other
case, we just use __builtin_thread_pointer() to maintain code's
integrity, but it's not called at all.

I think kvm/selftest is always relying on glibc if I'm correct.

Thanks,
Gavin

