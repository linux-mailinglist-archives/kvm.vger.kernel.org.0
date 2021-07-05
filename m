Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7EC3BBAAA
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 11:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhGEKCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 06:02:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3080 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230050AbhGEKCB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 06:02:01 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1659Y75T130601;
        Mon, 5 Jul 2021 05:59:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1/PxTBfyA70het22KvEXDUU1kkRFw6abe+yL6bxElqE=;
 b=AoAkXhkN92BBmq0FvAEpDpl26lnxK+PRCQ2pdIUY/h13W+sUdDDrk6xcrhU3CaPM5KUQ
 4HD9b+2mSvz/c+6pkAPP9E939Nk8hZkiZy4z/x+oj6enIzNqokgWYRN0r/pnxTizo9lG
 7rc3WyZPjup73qRrVfY5WMxUaQxicHWyYBAJ5Kvo2VUVktR6ext8KiEGhulh9X53XO5F
 YmoYvwfzNJfobO9IcXPOFmMqb6w3ODZuoZu5d0UgbvBHPQ61y3nzK9V5eBUZq8spkfeR
 S52ufO4Nrqeb3VlKUTdeOIdhVyZKM511e6KYj6TwQola8PQZFgjS52Wu8MMh/c/QcHNK lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39kww83fgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jul 2021 05:59:23 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1659Z1DH133389;
        Mon, 5 Jul 2021 05:59:23 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39kww83fge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jul 2021 05:59:23 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1659vNM4028875;
        Mon, 5 Jul 2021 09:59:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 39jfh8gcvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jul 2021 09:59:21 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1659vW8k34865458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jul 2021 09:57:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15BE452054;
        Mon,  5 Jul 2021 09:59:19 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.49.175])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id AD2AF52051;
        Mon,  5 Jul 2021 09:59:18 +0000 (GMT)
Subject: Re: [PATCH/RFC] KVM: selftests: introduce P44V64 for z196 and EC12
To:     David Hildenbrand <david@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20210701153853.33063-1-borntraeger@de.ibm.com>
 <bc025447-db53-5472-76b0-0cfa2c3ae996@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <390803e9-a713-c9e7-cda8-ee822e5c1c40@de.ibm.com>
Date:   Mon, 5 Jul 2021 11:59:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <bc025447-db53-5472-76b0-0cfa2c3ae996@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ugFMm7HpFgYiwUeV-i7XSeD44y6bv814
X-Proofpoint-ORIG-GUID: SnBiiw3iDORkgIEss6sfwSA7T1bj16bI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-05_05:2021-07-02,2021-07-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 bulkscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=836 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107050048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.07.21 11:53, David Hildenbrand wrote:
> On 01.07.21 17:38, Christian Borntraeger wrote:
>> Older machines likes z196 and zEC12 do only support 44 bits of physical
>> addresses. Make this the default and check via IBC if we are on a later
>> machine. We then add P47V64 as an additional model.
>>
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> Fixes: 1bc603af73dd ("KVM: selftests: introduce P47V64 for s390x")
> 
> [...]
> 
>> +#ifdef __s390x__
>> +    {
>> +        int kvm_fd, vm_fd;
>> +        struct kvm_s390_vm_cpu_processor info;
>> +
>> +        kvm_fd = open_kvm_dev_path_or_exit();
>> +        vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);
>> +        kvm_device_access(vm_fd, KVM_S390_VM_CPU_MODEL,
>> +                  KVM_S390_VM_CPU_PROCESSOR, &info, false);
> 
> Can we always assume to run on a kernel where this won't fail?

As far as I can tell, the selftests are bundled with a given kernel (and
there it should not fail). I guess most selftests will fail with a 3.x
kernel and we do not care?
> 
>> +        close(vm_fd);
>> +        close(kvm_fd);
>> +        /* Starting with z13 we have 47bits of physical address */
> 
> This matches the definition in the QEMU cpu models.
> 
>> +        if (info.ibc >= 0x30)
>> +            guest_mode_append(VM_MODE_P47V64_4K, true, true);
>> +    }
>> +#endif
> 
> 
> In general, LGTM
> 
> 
