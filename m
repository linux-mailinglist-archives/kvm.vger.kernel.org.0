Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A64E21098D
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 12:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbgGAKmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 06:42:02 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23657 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729180AbgGAKmC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Jul 2020 06:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593600121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m/kPRm/zKRHB19QtubNaxx70JX8VBZbCEiMqsySYO9A=;
        b=VcW4WFvEv8NoWHS0Gral2cq0Rt62lzJoyxJVQ9fVcbRLWCxRBEcsNm8G18QefAUo09AqU1
        2XMvU2uWoyzY2TqvhtjOmDEi39hTqzEpkP7hPtapeA+6RW2pB1hWORYDmymVv3+AyBoTqT
        PnMkhNIsIjOqccdt1PW1J9OiFgwzE/w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-eF9s6Ru_OmuETudaU2vnXw-1; Wed, 01 Jul 2020 06:41:58 -0400
X-MC-Unique: eF9s6Ru_OmuETudaU2vnXw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8729107B115;
        Wed,  1 Jul 2020 10:41:57 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-45.ams2.redhat.com [10.36.114.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A7ADC5C1C5;
        Wed,  1 Jul 2020 10:41:53 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci.yml: Extend the lists of tests
 that we run with TCG
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Drew Jones <drjones@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20200701100615.7975-1-thuth@redhat.com>
 <38846a44-2e55-4c5f-5846-d4bca6eda8ee@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <77190b11-4575-e59a-67e4-250e49c0a360@redhat.com>
Date:   Wed, 1 Jul 2020 12:41:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <38846a44-2e55-4c5f-5846-d4bca6eda8ee@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/2020 12.37, Paolo Bonzini wrote:
> On 01/07/20 12:06, Thomas Huth wrote:
>> Thank to the recent fixes, there are now quite a lot of additional 32-bit
>> x86 tests that we can run in the CI.
>> And thanks to the update to Fedora 32 (that introduced a newer version of
>> QEMU), there are now also some additional tests that we can run with TCG
>> for the other architectures.
>> Note that for arm/aarch64, we now also set the MAX_SMP to be able to run
>> SMP-tests with TCG in the single-threaded CI containers, too.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   Note: taskswitch2 for 32-bit x86 is still broken, and thus has not been
>>   added back again. It used to work with F30 ... maybe it's a QEMU regression?
> 
> It's on my todo list to check.  One thing (sorry about the constant
> nitpicking), should tests be listed one per line so that it's clearer
> when we add them?

I guess that's mostly a matter of taste, I think I slightly prefer the 
more condensed list to avoid that the test case definitions get too 
big... but if it bugs you, feel free to change it.

> But anyway I'm queuing this patch.

Thanks!
  Thomas

