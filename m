Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD30492972
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 16:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344317AbiARPMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 10:12:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38150 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233331AbiARPMn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 10:12:43 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IExPcf006029;
        Tue, 18 Jan 2022 15:12:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Bje9CMfcuP7HbnfuChGhxkVv3srCh/t1cZHjbHU4SMM=;
 b=i9i3YA7zLR2/y+l9atKsvSPCdNRsFyFMc4aMMrCLENKvEEgwJY8StcrOB5YQ6HSNePgb
 mYq1eYC+2mjKcax6FZ+JwoM8bWkuYkQbKDGsSV8jWHcR0dVVxfJ4rpj3dcGuG5qwjubK
 hRwJPrLxsgA5TapAwy+kFu8knJmxVNrFw+Cy8fBRCaXKguocROE81ZPz4ZGCJ+wmTsNQ
 /5CIc4yQ1t8jIF1wu+Vq2/g8oN/dwaoUlXV7WbLEYjTJQ21c4BmmsebxJUPoWGCUg//o
 SCRrYadXAHYz9KYTFIk4SXKTWVR3lgkDqWfKD9Ye4xSnu+6Ychos+p0RA0NrnctoOGMS FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dnvpmpxqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 15:12:42 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IExt1w008614;
        Tue, 18 Jan 2022 15:12:41 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dnvpmpxps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 15:12:41 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IF7Z9q022507;
        Tue, 18 Jan 2022 15:12:40 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3dknw9cdpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 15:12:39 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IFCY1h42533156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 15:12:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40E94AE058;
        Tue, 18 Jan 2022 15:12:34 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64CAAAE056;
        Tue, 18 Jan 2022 15:12:32 +0000 (GMT)
Received: from [9.171.19.84] (unknown [9.171.19.84])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 15:12:32 +0000 (GMT)
Message-ID: <721c824f-c61d-6859-e583-acc7809a0ec5@linux.ibm.com>
Date:   Tue, 18 Jan 2022 16:12:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH v1 09/10] KVM: s390: Add capability for storage key
 extension of MEM_OP IOCTL
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
 <20220118095210.1651483-10-scgl@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220118095210.1651483-10-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: C6Uv9_TICVhYqYcbVNxzayipcf1_ihrL
X-Proofpoint-GUID: sOTj2FKG5Tp6avS4u-1qclGyAzojxU0n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_04,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 phishscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 18.01.22 um 10:52 schrieb Janis Schoetterl-Glausch:
> Availability of the KVM_CAP_S390_MEM_OP_SKEY capability signals that:
> * The vcpu MEM_OP IOCTL supports storage key checking.
> * The vm MEM_OP IOCTL exists.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
> Maybe this should be redesigned. As is, the capability mixes
> support of storage keys for the vcpu ioctl with the availability
> of the vm ioctl (which always supports storage keys).
> 
> We could have two capabilities, one to indicate the availability
> of the vm memop and another used to derive the available functionality.
> Janosch suggested that the second capability indicates the availability
> of a "query" memop operation.

I think one capability covering both changes is totally fine as long as we document
that in api.rst.

> 
>   arch/s390/kvm/kvm-s390.c | 1 +
>   include/uapi/linux/kvm.h | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index ab07389fb4d9..3c6517ad43a3 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -565,6 +565,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_S390_VCPU_RESETS:
>   	case KVM_CAP_SET_GUEST_DEBUG:
>   	case KVM_CAP_S390_DIAG318:
> +	case KVM_CAP_S390_MEM_OP_SKEY:
>   		r = 1;
>   		break;
>   	case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index dd04170287fd..1bb38efd1156 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1134,6 +1134,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
>   #define KVM_CAP_ARM_MTE 205
>   #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
> +#define KVM_CAP_S390_MEM_OP_SKEY 209
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
