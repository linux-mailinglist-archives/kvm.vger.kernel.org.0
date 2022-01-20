Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303E0494CB7
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 12:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiATLUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 06:20:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17758 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230429AbiATLUL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 06:20:11 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20K8wQN6013978;
        Thu, 20 Jan 2022 11:20:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=q8d+JmubsiEGkGrlJwoa+jl3OgIFkhx9mMub8kNkuwE=;
 b=crIM0taexLN+W2B7IMoHp+XMgll4k3V/oB2ffYahGgQMUDAZcsmpozh8LAPS+rjvIPcs
 738xynN6nUSukPDApbDRdOcWZl4bjRxbXVoc1WIKeM2JGBv1IC8JNRluQzJ9W6EvtlDw
 volLiN7ZEn09PvhnWEF+wNMskYBwsSl/uKbckbegP/0LSBk54fZn5T6Bx1NZpOQr9h+J
 TJIL7g4Ar4Wju7f2tmn70eAkNXtWgfmUhjLs8w4brPtXiTnCVnhqEJQweNDoeIZcHdRq
 CXI1v0IH/h4JistnUodBLllRZxTq5RqLZRD8oVXJH6fv6ceqshjvAkWO/VnEfLGdgRMo UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dq4putp9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 11:20:09 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20KA8iuL029890;
        Thu, 20 Jan 2022 11:20:09 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dq4putp94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 11:20:09 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20KB7wOt003547;
        Thu, 20 Jan 2022 11:20:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3dknhjpraf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 11:20:07 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20KBK3O639715222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 11:20:03 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45BEB11C07B;
        Thu, 20 Jan 2022 11:20:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1F6F11C04C;
        Thu, 20 Jan 2022 11:20:02 +0000 (GMT)
Received: from [9.171.13.121] (unknown [9.171.13.121])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Jan 2022 11:20:02 +0000 (GMT)
Message-ID: <6de14f3a-fd8a-49d4-3102-ca8f339d8728@linux.ibm.com>
Date:   Thu, 20 Jan 2022 12:20:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH v1 06/10] KVM: s390: Add vm IOCTL for key checked
 guest absolute memory access
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
 <20220118095210.1651483-7-scgl@linux.ibm.com>
 <069c72b6-457f-65c7-652e-e6eca7235fca@redhat.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <069c72b6-457f-65c7-652e-e6eca7235fca@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tEaNHQjN40Df7antsZ4nerz26218eQ_Y
X-Proofpoint-ORIG-GUID: fjL2rJnzhgeRNE88aRdwV5xNHiHpvwZt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-20_04,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 20.01.22 um 11:38 schrieb Thomas Huth:
> On 18/01/2022 10.52, Janis Schoetterl-Glausch wrote:
>> Channel I/O honors storage keys and is performed on absolute memory.
>> For I/O emulation user space therefore needs to be able to do key
>> checked accesses.
>> The vm IOCTL supports read/write accesses, as well as checking
>> if an access would succeed.
> ...
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index e3f450b2f346..dd04170287fd 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -572,6 +572,8 @@ struct kvm_s390_mem_op {
>>   #define KVM_S390_MEMOP_LOGICAL_WRITE    1
>>   #define KVM_S390_MEMOP_SIDA_READ    2
>>   #define KVM_S390_MEMOP_SIDA_WRITE    3
>> +#define KVM_S390_MEMOP_ABSOLUTE_READ    4
>> +#define KVM_S390_MEMOP_ABSOLUTE_WRITE    5
> 
> Not quite sure about this - maybe it is, but at least I'd like to see this discussed: Do we really want to re-use the same ioctl layout for both, the VM and the VCPU file handles? Where the userspace developer has to know that the *_ABSOLUTE_* ops only work with VM handles, and the others only work with the VCPU handles? A CPU can also address absolute memory, so why not adding the *_ABSOLUTE_* ops there, too? And if we'd do that, wouldn't it be sufficient to have the VCPU ioctls only - or do you want to call these ioctls from spots in QEMU where you do not have a VCPU handle available? (I/O instructions are triggered from a CPU, so I'd assume that you should have a VCPU handle around?)

I paritally agree. the ABSOLUTE calls should also work from a VCPU handle. But you also want to be able to call this from a different thread than the vpcu threads as you do not want to kick a CPU out of the kernel just for that. So it makes sense to have this ioctl also for the VM fd.
> 
>   Thomas
> 
> 
