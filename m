Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 023DD14EE11
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 14:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbgAaN7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 08:59:10 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55826 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728719AbgAaN7K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 08:59:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580479149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hNUw6IPOMIG9KQCYecqbcrytZM2fmwuWhPjigAsREIk=;
        b=aVb8MSEHuCoDbdMtlMsRsLP/beBJtQB5WU5Hmyz6GvLUXmOGQVKCwgte6Id+cobLvcvv7d
        FfgOD2146ZItf3oiDjzvaWhhug/mV7/8CzQducW2AhiwVniEGD9M/Vd+cYl0JIFyFaUUrt
        /S4XRy5fR/lwWo76fBCGlcavdvve3fo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-BZzrYi48M5q1Mp2Uh8_ngg-1; Fri, 31 Jan 2020 08:59:07 -0500
X-MC-Unique: BZzrYi48M5q1Mp2Uh8_ngg-1
Received: by mail-wr1-f69.google.com with SMTP id j13so3372137wrr.20
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 05:59:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hNUw6IPOMIG9KQCYecqbcrytZM2fmwuWhPjigAsREIk=;
        b=ZXdjVi35ho7wp1U/hfnOk31mt1z+jYnVTNivJsc9s7LiIWyJvJihRQZDrPvda1dThO
         Kln58GVM67QgX1wYdmR0rUYCi5DYZJrCYyIMs2ph9tpTbUumB/Ud59lMJkEhbJdtpcQE
         keOsYjzvWj1VgrtY6vfyN23OZ+NbjxlPJFDR9Z2wMkMIKwZIctauilMUDCYk4opvdyRL
         KbP6NrNn07p0UDzZPrVuRnsPscUpMsjmXHFr1ABsgFNnn+SlSJcCdP4uZF652/hkeVn0
         0OJfc8lUVVs/wpZ8lwOI+CuQrhiETQlNQRBah0MDFfKOYu7RFj9Lu9NTHz2K742U65eq
         mZCQ==
X-Gm-Message-State: APjAAAV+omZmlYG+Q0X5v+Tjrxi8BFRwH7n2pnQTMyLuQgnLq8rFJdnj
        50u21wP/eRd9+nlIqdQoZv82yRXwNvcnHLwi/BuhHWGEulkUznoPmy2H2xkvdr3UPbPm8PyO041
        yFow2fXfGVs0e
X-Received: by 2002:a5d:52c4:: with SMTP id r4mr12340678wrv.368.1580479145891;
        Fri, 31 Jan 2020 05:59:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqwq6gOWcudtpzerMxP8Ia/73h2By2Dmg/cNUGGxc6rZe83zEVp6sBSb5DIRUdVUqL6tDXWh3w==
X-Received: by 2002:a5d:52c4:: with SMTP id r4mr12340659wrv.368.1580479145631;
        Fri, 31 Jan 2020 05:59:05 -0800 (PST)
Received: from [192.168.43.81] (93-33-14-103.ip42.fastwebnet.it. [93.33.14.103])
        by smtp.gmail.com with ESMTPSA id b18sm12162460wru.50.2020.01.31.05.59.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 05:59:05 -0800 (PST)
Subject: Re: [PATCH v10 4/6] selftests: KVM: Add fpu and one reg set/get
 library functions
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20200131100205.74720-1-frankja@linux.ibm.com>
 <20200131100205.74720-5-frankja@linux.ibm.com>
 <6a990f23-832b-86f7-28bf-761e84fd33fb@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <75bddb63-fb5a-90b0-64bf-2de1d53f2b82@redhat.com>
Date:   Fri, 31 Jan 2020 14:59:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <6a990f23-832b-86f7-28bf-761e84fd33fb@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/01/20 12:43, Christian Borntraeger wrote:
> Paolo,
> 
> are you ok with me taking this patch for my s390 pull request to you?
> Ideally still for 5.6?

Yes to both questions, of course.

Paolo

> On 31.01.20 11:02, Janosch Frank wrote:
>> Add library access to more registers.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  .../testing/selftests/kvm/include/kvm_util.h  |  6 ++++
>>  tools/testing/selftests/kvm/lib/kvm_util.c    | 36 +++++++++++++++++++
>>  2 files changed, 42 insertions(+)
>>
>> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
>> index 29cccaf96baf..ae0d14c2540a 100644
>> --- a/tools/testing/selftests/kvm/include/kvm_util.h
>> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
>> @@ -125,6 +125,12 @@ void vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
>>  		    struct kvm_sregs *sregs);
>>  int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
>>  		    struct kvm_sregs *sregs);
>> +void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid,
>> +		  struct kvm_fpu *fpu);
>> +void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid,
>> +		  struct kvm_fpu *fpu);
>> +void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
>> +void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
>>  #ifdef __KVM_HAVE_VCPU_EVENTS
>>  void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
>>  		     struct kvm_vcpu_events *events);
>> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
>> index 41cf45416060..a6dd0401eb50 100644
>> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
>> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
>> @@ -1373,6 +1373,42 @@ int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_sregs *sregs)
>>  	return ioctl(vcpu->fd, KVM_SET_SREGS, sregs);
>>  }
>>
>> +void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
>> +{
>> +	int ret;
>> +
>> +	ret = _vcpu_ioctl(vm, vcpuid, KVM_GET_FPU, fpu);
>> +	TEST_ASSERT(ret == 0, "KVM_GET_FPU failed, rc: %i errno: %i (%s)",
>> +		    ret, errno, strerror(errno));
>> +}
>> +
>> +void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
>> +{
>> +	int ret;
>> +
>> +	ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_FPU, fpu);
>> +	TEST_ASSERT(ret == 0, "KVM_SET_FPU failed, rc: %i errno: %i (%s)",
>> +		    ret, errno, strerror(errno));
>> +}
>> +
>> +void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
>> +{
>> +	int ret;
>> +
>> +	ret = _vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, reg);
>> +	TEST_ASSERT(ret == 0, "KVM_GET_ONE_REG failed, rc: %i errno: %i (%s)",
>> +		    ret, errno, strerror(errno));
>> +}
>> +
>> +void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
>> +{
>> +	int ret;
>> +
>> +	ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, reg);
>> +	TEST_ASSERT(ret == 0, "KVM_SET_ONE_REG failed, rc: %i errno: %i (%s)",
>> +		    ret, errno, strerror(errno));
>> +}
>> +
>>  /*
>>   * VCPU Ioctl
>>   *
>>
> 

