Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0249C494DD5
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 13:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241524AbiATMXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 07:23:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57570 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241517AbiATMXN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 07:23:13 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20KBEk8q030809;
        Thu, 20 Jan 2022 12:23:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gdfraUqe7O/sEr0YUMnn0FtEk5QXT9TtM5k5fPBmDac=;
 b=EJk2cLSHLzJ8v/MifcUtOBX/QEyBpa1VxzDSmy9MTZdNB4l364pB0x1TsJlARClAVN2t
 M/e4r5nnqwWQ4tR9BsAtgusnRgUAz0DTk2E5N0h9w6HKrzuJ0QWhYprTntOz0XZ06eZY
 63f+9BMqYwCgrlS33Wfz3RwQfFqN0G3UY9ag88Rcr7KFZLlxdZSs8JTi7xUehJ8LhDC9
 lh7WoNLky6wLbbFFO47kcbZanDbEFHPw6ElGJUPmEaW/8kkZgY5nE+V0SduID5x5joOE
 bzZUjoIGLBxeitORVhJqfMqj5Uk87NSSpDHMGh4VZeYHRAWC+EZ41NFBU3uUSs52brI1 Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dq0re0b6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 12:23:12 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20KBvkRN025452;
        Thu, 20 Jan 2022 12:23:12 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dq0re0b5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 12:23:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20KCI7oC011901;
        Thu, 20 Jan 2022 12:23:10 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3dknwa99wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 12:23:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20KCDj4g16843184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 12:13:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBEA5AE058;
        Thu, 20 Jan 2022 12:23:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 458F7AE045;
        Thu, 20 Jan 2022 12:23:06 +0000 (GMT)
Received: from [9.171.39.5] (unknown [9.171.39.5])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Jan 2022 12:23:06 +0000 (GMT)
Message-ID: <8647fcaf-6d8a-4678-0695-4b1cc797b3b1@linux.ibm.com>
Date:   Thu, 20 Jan 2022 13:23:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH v1 06/10] KVM: s390: Add vm IOCTL for key checked
 guest absolute memory access
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
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
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <069c72b6-457f-65c7-652e-e6eca7235fca@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: y5WmcWTMmONw2_MuTtiJ7-Qj7v8TpxAK
X-Proofpoint-ORIG-GUID: nKscVOzIFJRqtOETdf0qOSSahSegn1nP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-20_04,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 phishscore=0 suspectscore=0
 spamscore=0 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/22 11:38, Thomas Huth wrote:
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

There are some differences between the vm and the vcpu memops.
No storage or fetch protection overrides apply to IO/vm memops, after all there is no control register to enable them.
Additionally, quiescing is not required for IO, tho in practice we use the same code path for the vcpu and the vm here.
Allowing absolute accesses with a vcpu is doable, but I'm not sure what the use case for it would be, I'm not aware of
a precedence in the architecture. Of course the vcpu memop already supports logical=real accesses.
> 
>  Thomas
> 
> 

