Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B61A4AD67E
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 12:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355874AbiBHL0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 06:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbiBHJug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 04:50:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B518DC03FEC0;
        Tue,  8 Feb 2022 01:50:34 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2187AnVY025367;
        Tue, 8 Feb 2022 09:50:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bvBPatwKzWC6UPWT0saj5Bx5S7Zm4GijtmNgr01Gu+w=;
 b=bOinkWdr0iRLCZNiy3P0TeP9KcXjnoCD5+sHS09GFwMNlVx49w/8QH4018RSEe5DzvDN
 bK1f6OuahwIM7s8tfS/1l5uDe56eNK9+4Wz2tsJAZhn86I4EBWcff3zY1HOREhbSyMsI
 wk/bawwQjghhpT2xIwPQnETBgEukD40c4MC+DhJw7QqtpGcT9uyLSP7mO7DUfxZfARNL
 tcrvbxbG0nXVPU1HFp34gMP3ZmoDEC5GI7D9uO6+1tgoeWEhqTQWAydG6VWrUfmfeYVG
 zi1Ug/YuDinYaoeT1azUbPfbXMH6/teXvPhmr4T3sOifn+N3FG2nTYBeKNJfAcQ3B1uK 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22trd08e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 09:50:34 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2189i44p027111;
        Tue, 8 Feb 2022 09:50:33 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22trd076-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 09:50:33 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2189j9an003440;
        Tue, 8 Feb 2022 09:50:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3e1gva36ks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 09:50:28 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2189eK3g49873392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 09:40:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED06F42056;
        Tue,  8 Feb 2022 09:50:24 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57B8842049;
        Tue,  8 Feb 2022 09:50:24 +0000 (GMT)
Received: from [9.145.150.231] (unknown [9.145.150.231])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 09:50:24 +0000 (GMT)
Message-ID: <f61b1d7e-37bb-6072-a855-e7fc9ed72dfb@linux.ibm.com>
Date:   Tue, 8 Feb 2022 10:50:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 09/11] KVM: s390: Add capability for storage key
 extension of MEM_OP IOCTL
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20220207165930.1608621-1-scgl@linux.ibm.com>
 <20220207165930.1608621-10-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220207165930.1608621-10-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5nqXMOn9Czai8q5P-LBtZGn6ua4G3OoO
X-Proofpoint-GUID: IhxVdyjuoACnrXZ5D1cEB6OGbHYWI6fy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_02,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/7/22 17:59, Janis Schoetterl-Glausch wrote:
> Availability of the KVM_CAP_S390_MEM_OP_EXTENSION capability signals that:
> * The vcpu MEM_OP IOCTL supports storage key checking.
> * The vm MEM_OP IOCTL exists.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>   arch/s390/kvm/kvm-s390.c | 1 +
>   include/uapi/linux/kvm.h | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index befb30923c0e..4a502cac068c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -565,6 +565,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_S390_VCPU_RESETS:
>   	case KVM_CAP_SET_GUEST_DEBUG:
>   	case KVM_CAP_S390_DIAG318:
> +	case KVM_CAP_S390_MEM_OP_EXTENSION:
>   		r = 1;
>   		break;
>   	case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index ea81132a1cb1..50ce814267b3 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1140,6 +1140,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_VM_GPA_BITS 207
>   #define KVM_CAP_XSAVE2 208
>   #define KVM_CAP_SYS_ATTRIBUTES 209
> +#define KVM_CAP_S390_MEM_OP_EXTENSION 210
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   

