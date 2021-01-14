Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34CC2F5D56
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 10:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbhANJ0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 04:26:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37572 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727174AbhANJ0G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Jan 2021 04:26:06 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10E93vqH040811;
        Thu, 14 Jan 2021 04:25:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aPMBM+XkQVCnTPiepVHmk0qTRFDy1OOcgjKfpH+1GSY=;
 b=VrK/GF7inTMWfHDVoJY3emGt/lVN8Ak57S3IBQhJhM1lRq0ljlD+aM98gP6NulWSI/ri
 iXdtjENQsyZr4p6b4jBPvmvxp59TKC3P75neuPDZjpSTVUHmUmMrIM2I0ySeyIsrn/1Q
 /FBhVR1ByjeniLvWzgCJQoI6obyx1WovGnajA1MBCO0VpIHjxlIg9N42SuzBZiAV8wv6
 AvsY/z8diFEgXOV/OD8IjXlJq4TvRssWIHSfAUskmy1hGDbTVNYLH/2/1RMFciJ0dLP1
 ZZphTQOelZ2+HBfwZ3+v9kf8UP3YtbK4pmlJRNbBRAsP+DOSYDkOIaKTvnHh0xkvb9uW 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362jr6rw7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 04:25:11 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10E94Nk8041748;
        Thu, 14 Jan 2021 04:25:08 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 362jr6rw4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 04:25:07 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10E9D9AH022830;
        Thu, 14 Jan 2021 09:25:02 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 35y448b75r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 09:25:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10E9Ox0o43909382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 09:24:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F24304C04A;
        Thu, 14 Jan 2021 09:24:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E53224C046;
        Thu, 14 Jan 2021 09:24:57 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.19.194])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 09:24:57 +0000 (GMT)
Subject: Re: [PATCH v7 13/13] s390: Recognize confidential-guest-support
 option
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>, brijesh.singh@amd.com,
        pair@us.ibm.com, dgilbert@redhat.com, pasic@linux.ibm.com,
        qemu-devel@nongnu.org
Cc:     cohuck@redhat.com,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        berrange@redhat.com, andi.kleen@intel.com
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
 <20210113235811.1909610-14-david@gibson.dropbear.id.au>
 <ba08f5da-e31f-7ae2-898d-a090c5c1b1cf@de.ibm.com>
 <aa72b499-1b84-54a3-fd06-2fec4402b699@de.ibm.com>
Message-ID: <471babb9-9d5a-a2fa-7d90-f14a7d289b8d@de.ibm.com>
Date:   Thu, 14 Jan 2021 10:24:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <aa72b499-1b84-54a3-fd06-2fec4402b699@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_03:2021-01-13,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 mlxscore=0 clxscore=1015
 spamscore=0 suspectscore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.01.21 10:19, Christian Borntraeger wrote:
> 
> 
> On 14.01.21 10:10, Christian Borntraeger wrote:
>>
>>
>> On 14.01.21 00:58, David Gibson wrote:
>> [...]
>>> +int s390_pv_init(ConfidentialGuestSupport *cgs, Error **errp)
>>> +{
>>> +    if (!object_dynamic_cast(OBJECT(cgs), TYPE_S390_PV_GUEST)) {
>>> +        return 0;
>>> +    }
>>> +
>>> +    if (!s390_has_feat(S390_FEAT_UNPACK)) {
>>> +        error_setg(errp,
>>> +                   "CPU model does not support Protected Virtualization");
>>> +        return -1;
>>> +    }
>>
>> I am triggering this and I guess this is because the cpu model is not yet initialized at
>> this point in time.
>>
> When I remove the check, things seems to work though ( I can access virtio-blk devices without
> specifying iommu for example)

Maybe we can turn things around and check in apply_cpu_model if the object exists but
unpack was not specified?
