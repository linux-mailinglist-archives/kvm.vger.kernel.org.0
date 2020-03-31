Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D765619967D
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 14:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730810AbgCaM12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 08:27:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53128 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730343AbgCaM12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 08:27:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585657646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+uwrvoeVxT29TBWalu2R/n+g95+vkG1UR1mvyvUSmtE=;
        b=ce+0BpcbR9HkjvENUPBZWrCKCACZgP0G4pL0sW/pRMT9NKk0XnKSixDj0ZXkd9KeoAPS15
        x7tcbxMuga6poG7j8rowb357KLhuy+ec3vdyGhm6PVQgCu/akmLazFKkUnabDv0qZY9aQB
        sOLgPvcqJ1QqT2hPtnA1WDF5DSYoHT4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-Hmw76hB9Op2qOl9hNnscSg-1; Tue, 31 Mar 2020 08:27:23 -0400
X-MC-Unique: Hmw76hB9Op2qOl9hNnscSg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FA16DB85;
        Tue, 31 Mar 2020 12:27:22 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-15.gru2.redhat.com [10.97.116.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33D3B96F85;
        Tue, 31 Mar 2020 12:27:18 +0000 (UTC)
Subject: Re: [PATCH] selftests: kvm: Update .gitignore with missing binaries
To:     Andrew Jones <drjones@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org
References: <20200330211922.24290-1-wainersm@redhat.com>
 <49982d4c-ab12-28e6-d0f2-695c8781b26d@linux.ibm.com>
 <20200331074903.lwqjkwyinfw2avzg@kamzik.brq.redhat.com>
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
Message-ID: <6f6a9c8f-8d10-c7be-0397-8f0a6df1422f@redhat.com>
Date:   Tue, 31 Mar 2020 09:27:17 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200331074903.lwqjkwyinfw2avzg@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/31/20 4:49 AM, Andrew Jones wrote:
> On Tue, Mar 31, 2020 at 09:09:17AM +0200, Janosch Frank wrote:
>> On 3/30/20 11:19 PM, Wainer dos Santos Moschetta wrote:
>>> Updated .gitignore to ignore x86_64/svm_vmcall_test and
>>> s390x/resets test binaries.
>>>
>>> Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
>> Oh, didn't know I needed to do that...
>> Thanks for fixing this up.
> I've already sent these, and they've been merged to kvm/queue.


Sorry, before sending mine I searched in the mailing list but did not 
find any fix. Next time I look at queued patches as well.

Thanks!

>
>> Acked-by: Janosch Frank <frankja@linux.ibm.com>
>>
>>> ---
>>>   tools/testing/selftests/kvm/.gitignore | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
>>> index 30072c3f52fb..489b9cf9eed5 100644
>>> --- a/tools/testing/selftests/kvm/.gitignore
>>> +++ b/tools/testing/selftests/kvm/.gitignore
>>> @@ -1,3 +1,4 @@
>>> +/s390x/resets
>>>   /s390x/sync_regs_test
>>>   /s390x/memop
>>>   /x86_64/cr4_cpuid_sync_test
>>> @@ -8,6 +9,7 @@
>>>   /x86_64/set_sregs_test
>>>   /x86_64/smm_test
>>>   /x86_64/state_test
>>> +/x86_64/svm_vmcall_test
>>>   /x86_64/sync_regs_test
>>>   /x86_64/vmx_close_while_nested_test
>>>   /x86_64/vmx_dirty_log_test
>>>
>>
>
>

