Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10703464A0E
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 09:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241974AbhLAItT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 03:49:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42000 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231397AbhLAItS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Dec 2021 03:49:18 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B18ICQd013840;
        Wed, 1 Dec 2021 08:45:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=I+sGg/VdPgJ7aMEo6GW8MJglfDFgVcm6SN2xhuLvAj4=;
 b=kxR+VrQyrJl2iKfJ11/B0msDV9O6VkzofLa2BjFkaEGC97Cl5iQnLxEDJvSP0EdzZAj+
 Cxk7ea9Y3NtSUh8abQzH5IRvBjch9QAO7sxOvGUu3JH6cH3M34gSgATlu7gzASDO+GWN
 oEHXcw8wdvEOFcZWEBg3WstwmFfIIUoM1uj2ljMKs4bQW5vj5BG7vZv4kXHrVjwVAVYJ
 RGfUeyGqhT82YYh0tq8RWsvwLHcFbZQuBppdGSIuNl5fy1E4EMkjRpYebVOx0fWebbGX
 oL5P/NzKwjOCpuJG4QfeRUIWn8hLJUE/8pcFXUTmPZjZm4t4xeCuXqbFR3tBF7woviVL pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cp5dqgkkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Dec 2021 08:45:55 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B18jtE6017131;
        Wed, 1 Dec 2021 08:45:55 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cp5dqgkjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Dec 2021 08:45:55 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B18fhSh008040;
        Wed, 1 Dec 2021 08:45:53 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3ckbxk7h97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Dec 2021 08:45:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B18cNlR23134716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Dec 2021 08:38:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AF81A4068;
        Wed,  1 Dec 2021 08:45:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 322F4A405F;
        Wed,  1 Dec 2021 08:45:49 +0000 (GMT)
Received: from [9.145.42.85] (unknown [9.145.42.85])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  1 Dec 2021 08:45:49 +0000 (GMT)
Message-ID: <6b781b76-28a9-c375-30cb-ee6764ecd7c8@linux.ibm.com>
Date:   Wed, 1 Dec 2021 09:45:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] KVM: s390: Fix names of skey constants in api
 documentation
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211118102522.569660-1-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211118102522.569660-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ca5KCzTII-m_H1mWHoHJJpJ2rAEemIsK
X-Proofpoint-ORIG-GUID: 7YdmZGa1hZsUCd0VZoCfFqUoefehnIPv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 clxscore=1011 priorityscore=1501 impostorscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112010049
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/21 11:25, Janis Schoetterl-Glausch wrote:
> The are defined in include/uapi/linux/kvm.h as

s/The/They/

I can fix that up when picking if you want.

> KVM_S390_GET_SKEYS_NONE and KVM_S390_SKEYS_MAX, but the
> api documetation talks of KVM_S390_GET_KEYS_NONE and
> KVM_S390_SKEYS_ALLOC_MAX respectively.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Thanks for fixing this up.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   Documentation/virt/kvm/api.rst | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index aeeb071c7688..b86c7edae888 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -3701,7 +3701,7 @@ KVM with the currently defined set of flags.
>   :Architectures: s390
>   :Type: vm ioctl
>   :Parameters: struct kvm_s390_skeys
> -:Returns: 0 on success, KVM_S390_GET_KEYS_NONE if guest is not using storage
> +:Returns: 0 on success, KVM_S390_GET_SKEYS_NONE if guest is not using storage
>             keys, negative value on error
>   
>   This ioctl is used to get guest storage key values on the s390
> @@ -3720,7 +3720,7 @@ you want to get.
>   
>   The count field is the number of consecutive frames (starting from start_gfn)
>   whose storage keys to get. The count field must be at least 1 and the maximum
> -allowed value is defined as KVM_S390_SKEYS_ALLOC_MAX. Values outside this range
> +allowed value is defined as KVM_S390_SKEYS_MAX. Values outside this range
>   will cause the ioctl to return -EINVAL.
>   
>   The skeydata_addr field is the address to a buffer large enough to hold count
> @@ -3744,7 +3744,7 @@ you want to set.
>   
>   The count field is the number of consecutive frames (starting from start_gfn)
>   whose storage keys to get. The count field must be at least 1 and the maximum
> -allowed value is defined as KVM_S390_SKEYS_ALLOC_MAX. Values outside this range
> +allowed value is defined as KVM_S390_SKEYS_MAX. Values outside this range
>   will cause the ioctl to return -EINVAL.
>   
>   The skeydata_addr field is the address to a buffer containing count bytes of
> 

