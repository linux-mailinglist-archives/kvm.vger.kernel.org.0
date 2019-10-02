Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB5F7C90B5
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 20:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbfJBSVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 14:21:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbfJBSVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 14:21:21 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7677118C428B;
        Wed,  2 Oct 2019 18:21:20 +0000 (UTC)
Received: from [10.36.116.21] (ovpn-116-21.ams2.redhat.com [10.36.116.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C18071001B28;
        Wed,  2 Oct 2019 18:21:15 +0000 (UTC)
Subject: Re: [PATCH] KVM: s390: Cleanup kvm_arch_init error path
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org
References: <20191002075627.3582-1-frankja@linux.ibm.com>
 <b758d2ec-3857-9fe0-b9d3-a9b6e70b6d14@redhat.com>
 <22a388be-a1e1-e57f-1677-18470ed09f65@redhat.com>
 <48e9dab7-03be-9acc-836b-e9e2700ca260@redhat.com>
 <f48dca29-d2c1-09bd-918c-755516b2f76e@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <02b32dcf-419c-7ea6-4f77-2eaaf3838492@redhat.com>
Date:   Wed, 2 Oct 2019 20:21:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f48dca29-d2c1-09bd-918c-755516b2f76e@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Wed, 02 Oct 2019 18:21:20 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.10.19 12:45, Christian Borntraeger wrote:
> 
> 
> On 02.10.19 10:20, David Hildenbrand wrote:
>> On 02.10.19 10:07, Thomas Huth wrote:
>>> On 02/10/2019 10.01, David Hildenbrand wrote:
>>>> On 02.10.19 09:56, Janosch Frank wrote:
>>>>> Both kvm_s390_gib_destroy and debug_unregister test if the needed
>>>>> pointers are not NULL and hence can be called unconditionally.
>>>>>
>>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>>> ---
>>>>>  arch/s390/kvm/kvm-s390.c | 18 +++++++-----------
>>>>>  1 file changed, 7 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>>> index 895fb2006c0d..66720d69cd24 100644
>>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>>> @@ -458,16 +458,14 @@ static void kvm_s390_cpu_feat_init(void)
>>>>>  
>>>>>  int kvm_arch_init(void *opaque)
>>>>>  {
>>>>> -	int rc;
>>>>> +	int rc = -ENOMEM;
>>>>>  
>>>>>  	kvm_s390_dbf = debug_register("kvm-trace", 32, 1, 7 * sizeof(long));
>>>>>  	if (!kvm_s390_dbf)
>>>>>  		return -ENOMEM;
>>>>>  
>>>>> -	if (debug_register_view(kvm_s390_dbf, &debug_sprintf_view)) {
>>>>> -		rc = -ENOMEM;
>>>>> -		goto out_debug_unreg;
>>>>> -	}
>>>>> +	if (debug_register_view(kvm_s390_dbf, &debug_sprintf_view))
>>>>> +		goto out;
>>>>>  
>>>>>  	kvm_s390_cpu_feat_init();
>>>>>  
>>>>> @@ -475,19 +473,17 @@ int kvm_arch_init(void *opaque)
>>>>>  	rc = kvm_register_device_ops(&kvm_flic_ops, KVM_DEV_TYPE_FLIC);
>>>>>  	if (rc) {
>>>>>  		pr_err("A FLIC registration call failed with rc=%d\n", rc);
>>>>> -		goto out_debug_unreg;
>>>>> +		goto out;
>>>>>  	}
>>>>>  
>>>>>  	rc = kvm_s390_gib_init(GAL_ISC);
>>>>>  	if (rc)
>>>>> -		goto out_gib_destroy;
>>>>> +		goto out;
>>>>>  
>>>>>  	return 0;
>>>>>  
>>>>> -out_gib_destroy:
>>>>> -	kvm_s390_gib_destroy();
>>>>> -out_debug_unreg:
>>>>> -	debug_unregister(kvm_s390_dbf);
>>>>> +out:
>>>>> +	kvm_arch_exit();
>>>>>  	return rc;
>>>>>  }
>>>>
>>>> Wonder why "debug_info_t *kvm_s390_dbf" is not declared as static.
>>>
>>> Because it is used in the KVM_EVENT macro?
>>
>> Ah, makes sense.
>>
>>>
>>>> Instead of the two manual calls we could also call kvm_arch_exit().
>>>
>>> Huh, isn't that what this patch is doing here?
>>
>> Lol, still tired and thought only the two labels would get removed. Even
>> better :)
> 
> So I guess we should not take your Reviewed-by: then? ;-)

No, please take it. ;)


-- 

Thanks,

David / dhildenb
