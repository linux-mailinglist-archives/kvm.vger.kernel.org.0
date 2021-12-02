Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3435A466183
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 11:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357023AbhLBKfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 05:35:39 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11438 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345364AbhLBKfj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 05:35:39 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B29qWYK004013;
        Thu, 2 Dec 2021 10:32:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JHgA82d8aX/0qd2SxViMuY3g9qvqlI2nqIoM1UnKb3U=;
 b=A7tV1uoEgz5qCvS2oDm0NGaJUJ7uX/YKtb7IxlQwK2g0rNcdvwiltnhj+n0HrlM3bNFp
 cC5r+5NvKKmq6rlYxZgzz2FXnl3aFmg7f49Otrt6S39fhqAbRhNbq7l9a8ZJyZ4SaVza
 4OX46OJlRnZljIpsNonOPw1fQKy2oxp0yE4RXqkd0NeDaZ31BYU1zlTsPXfOEw/ETadz
 X3bWCpdmcBayfi3sn7dJ14ZoxgWvCvqASQ+yje/dSWvat0afUWWl4jGb3Y6c7OjDgIgg
 Urgq46BegCRpptdD7KWWPUudFEzEZLu9Ahv/YwnU1Wgk6KAOdwkT+91P2pNTAW8kQeHe ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpuw70q4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 10:32:16 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B2AAVZG024073;
        Thu, 2 Dec 2021 10:32:15 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpuw70q3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 10:32:15 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2ARQKa014086;
        Thu, 2 Dec 2021 10:32:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3ckcaa8mec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 10:32:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2AV8Tf25624996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 10:31:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EE774C072;
        Thu,  2 Dec 2021 10:31:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAB3E4C074;
        Thu,  2 Dec 2021 10:31:07 +0000 (GMT)
Received: from [9.155.196.57] (unknown [9.155.196.57])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Dec 2021 10:31:07 +0000 (GMT)
Message-ID: <fd0aa191-4b43-76a1-cb0c-7ed4298ffecb@linux.vnet.ibm.com>
Date:   Thu, 2 Dec 2021 11:31:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] KVM: s390: Fix names of skey constants in api
 documentation
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211118102522.569660-1-scgl@linux.ibm.com>
 <6b781b76-28a9-c375-30cb-ee6764ecd7c8@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
In-Reply-To: <6b781b76-28a9-c375-30cb-ee6764ecd7c8@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cZADdvT36I83K5svFRQ9dDjMMGWmqNE3
X-Proofpoint-ORIG-GUID: Tc29EWqo4u4JKsSCFakOxb9jH6z-nN5p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-12-02_05,2021-12-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 clxscore=1011 mlxlogscore=999 suspectscore=0
 impostorscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112020065
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/1/21 09:45, Janosch Frank wrote:
> On 11/18/21 11:25, Janis Schoetterl-Glausch wrote:
>> The are defined in include/uapi/linux/kvm.h as
> 
> s/The/They/
> 
> I can fix that up when picking if you want.

Thanks, please do.
> 
>> KVM_S390_GET_SKEYS_NONE and KVM_S390_SKEYS_MAX, but the
>> api documetation talks of KVM_S390_GET_KEYS_NONE and
>> KVM_S390_SKEYS_ALLOC_MAX respectively.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> 
> Thanks for fixing this up.
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 
>> ---
>>   Documentation/virt/kvm/api.rst | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index aeeb071c7688..b86c7edae888 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -3701,7 +3701,7 @@ KVM with the currently defined set of flags.
>>   :Architectures: s390
>>   :Type: vm ioctl
>>   :Parameters: struct kvm_s390_skeys
>> -:Returns: 0 on success, KVM_S390_GET_KEYS_NONE if guest is not using storage
>> +:Returns: 0 on success, KVM_S390_GET_SKEYS_NONE if guest is not using storage
>>             keys, negative value on error
>>     This ioctl is used to get guest storage key values on the s390
>> @@ -3720,7 +3720,7 @@ you want to get.
>>     The count field is the number of consecutive frames (starting from start_gfn)
>>   whose storage keys to get. The count field must be at least 1 and the maximum
>> -allowed value is defined as KVM_S390_SKEYS_ALLOC_MAX. Values outside this range
>> +allowed value is defined as KVM_S390_SKEYS_MAX. Values outside this range
>>   will cause the ioctl to return -EINVAL.
>>     The skeydata_addr field is the address to a buffer large enough to hold count
>> @@ -3744,7 +3744,7 @@ you want to set.
>>     The count field is the number of consecutive frames (starting from start_gfn)
>>   whose storage keys to get. The count field must be at least 1 and the maximum
>> -allowed value is defined as KVM_S390_SKEYS_ALLOC_MAX. Values outside this range
>> +allowed value is defined as KVM_S390_SKEYS_MAX. Values outside this range
>>   will cause the ioctl to return -EINVAL.
>>     The skeydata_addr field is the address to a buffer containing count bytes of
>>
> 

