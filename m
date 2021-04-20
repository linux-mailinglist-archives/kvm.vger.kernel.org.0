Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299A2365AD2
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 16:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhDTOIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 10:08:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55304 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231422AbhDTOIe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 10:08:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618927682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jDVmsZT82WF5IHvcZJyjG++DF0zOp7ksAtsJgyQLwio=;
        b=Okc/riM2RA9u1XOkfuI01o1IwhSiJWmZ9fvcjUXmHkmB/OHIeQjacxzQ6r44G89itxCtCT
        6LNk6c+8g9LDLnCRRfBSuF8W/QuMnjkhfOgExUbeeusc2vOrE312Qkv04NSDKVLcluNiLJ
        qAJxNzGVdMp8D0lF52E5w/FJJZKZ2Qc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-9qXCqdz1PCqVKqSnZCWXVA-1; Tue, 20 Apr 2021 10:07:54 -0400
X-MC-Unique: 9qXCqdz1PCqVKqSnZCWXVA-1
Received: by mail-ed1-f72.google.com with SMTP id w15-20020a056402268fb02903828f878ec5so13182217edd.5
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 07:07:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jDVmsZT82WF5IHvcZJyjG++DF0zOp7ksAtsJgyQLwio=;
        b=rOhuh8lLs0b5b2BQSpxnl96fyDNYT1j+USG8bzVvkV/ksIUAIHOXS3h4spSNrZq9Yf
         YlBbL09cPlGMp2132/eyskBKhhSi6fORkW1J8mTrusmBEw2xiu4AwyyiUqiIbp5lKDNR
         wiiPrpxPHK0dJs/euJZvhKopmmCNfPC9k3gpYy8qmgrGCxk8x7u8K6hV9shJb4VQZioA
         Usatts/nEg2qhwpUw2jArOptiNNIUENRTRoBYauZ6fLj4AePcOldO6cqycrz8jmQtOuL
         pJpuvAxG/F7i6nE/BA3XrAF9OGkgCiB0vw3G8rK8gulqNBvaF9JttUtdDXD8fA8YHnPD
         EQ+g==
X-Gm-Message-State: AOAM533qfCA7XHEMqIzL0IXxsClu8oakJ/5cXnfNPw08kG/j7vIKbF4N
        2kcvZ6o9FxvYOr60i1sNraWk6LwHfQgEPEg6z8MnhjLo1WFOpMhhWkzzWgrB9BC9x4G4dfruBGU
        4A5fGzh3Dwepf
X-Received: by 2002:a05:6402:278d:: with SMTP id b13mr32202746ede.34.1618927673701;
        Tue, 20 Apr 2021 07:07:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsIyaH/fgrNE9cx6DPFnsc2ZoUIN4T+efZ+L0gcuhnjAJpXVjXgEYOrwxoSGCxE6PwPWOSAw==
X-Received: by 2002:a05:6402:278d:: with SMTP id b13mr32202719ede.34.1618927673473;
        Tue, 20 Apr 2021 07:07:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id d1sm15235952ede.31.2021.04.20.07.07.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 07:07:52 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] KVM: selftests: Sync data verify of dirty logging
 with guest sync
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210417143602.215059-1-peterx@redhat.com>
 <20210417143602.215059-2-peterx@redhat.com> <20210418124351.GW4440@xz-x1>
 <60b0c96c-161d-676d-c30a-a7ffeccab417@redhat.com>
 <20210420131041.GZ4440@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e110673a-8422-bdff-4336-bdb486842d39@redhat.com>
Date:   Tue, 20 Apr 2021 16:07:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210420131041.GZ4440@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/21 15:10, Peter Xu wrote:
> On Tue, Apr 20, 2021 at 10:07:16AM +0200, Paolo Bonzini wrote:
>> On 18/04/21 14:43, Peter Xu wrote:
>>> ----8<-----
>>> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
>>> index 25230e799bc4..d3050d1c2cd0 100644
>>> --- a/tools/testing/selftests/kvm/dirty_log_test.c
>>> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
>>> @@ -377,7 +377,7 @@ static void dirty_ring_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
>>>           /* A ucall-sync or ring-full event is allowed */
>>>           if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
>>>                   /* We should allow this to continue */
>>> -               ;
>>> +               vcpu_handle_sync_stop();
>>>           } else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL ||
>>>                      (ret == -1 && err == EINTR)) {
>>>                   /* Update the flag first before pause */
>>> ----8<-----
>>>
>>> That's my intention when I introduce vcpu_handle_sync_stop(), but forgot to
>>> add...
>>
>> And possibly even this (untested though):
>>
>> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
>> index ffa4e2791926..918954f01cef 100644
>> --- a/tools/testing/selftests/kvm/dirty_log_test.c
>> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
>> @@ -383,6 +383,7 @@ static void dirty_ring_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
>>   		/* Update the flag first before pause */
>>   		WRITE_ONCE(dirty_ring_vcpu_ring_full,
>>   			   run->exit_reason == KVM_EXIT_DIRTY_RING_FULL);
>> +		atomic_set(&vcpu_sync_stop_requested, false);
>>   		sem_post(&sem_vcpu_stop);
>>   		pr_info("vcpu stops because %s...\n",
>>   			dirty_ring_vcpu_ring_full ?
>> @@ -804,8 +805,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>>   		 * the flush of the last page, and since we handle the last
>>   		 * page specially verification will succeed anyway.
>>   		 */
>> -		assert(host_log_mode == LOG_MODE_DIRTY_RING ||
>> -		       atomic_read(&vcpu_sync_stop_requested) == false);
>> +		assert(atomic_read(&vcpu_sync_stop_requested) == false);
>>   		vm_dirty_log_verify(mode, bmap);
>>   		sem_post(&sem_vcpu_cont);
>>
>> You can submit all these as a separate patch.
> 
> But it could race, then?
> 
>          main thread                 vcpu thread
>          -----------                 -----------
>                                    ring full
>                                      vcpu_sync_stop_requested=0
>                                      sem_post(&sem_vcpu_stop)
>       vcpu_sync_stop_requested=1
>       sem_wait(&sem_vcpu_stop)
>       assert(vcpu_sync_stop_requested==0)   <----

Yes, it could indeed.

Thanks,

Paolo

