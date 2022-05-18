Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3BF52C049
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240577AbiERQvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240551AbiERQvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:51:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCEF9E9F2;
        Wed, 18 May 2022 09:51:44 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IGO5D7019721;
        Wed, 18 May 2022 16:51:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kZmuOQk3nB0k0QQUHtuVyv6VXcOPkjCgoM1V8L0+TvY=;
 b=PrksPn0W3hOiWQTtNYA6q3tuCzNvWy5D0jfh5fXMu7Lw3RdQI5p8BxL5W8Xq7isn0B5O
 8xWPymE9J0ZU81db+pokLEG6ZLRSoep41GmDsvD0eGHw3DVdzLt7ukj+YKMRlhh5EqJ7
 7hGjOrhH8mE3oc1OzuJB+M5URxLWSt/GwA2fuS/jRbnYCFtn5zxYFG9PHlZd3XsZxhqH
 qS1Pp7hQOTuyXXqv6RGQ3v1rd3dbI2RbATgPVTDksouB2k2zotnr0q3I1pR9X7PNxHwg
 43QUrXe9LcfbDE2lpDJCQfbd/ShyPIPRGxROmU2tVMFJWrYY1+47+otEO4sEnJF8xUXq xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g549rrrxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 16:51:43 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24IGSPfm008382;
        Wed, 18 May 2022 16:51:43 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g549rrrx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 16:51:43 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24IGXFdl022179;
        Wed, 18 May 2022 16:51:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3g2428vv5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 16:51:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24IGpbSS46858650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 16:51:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E476542041;
        Wed, 18 May 2022 16:51:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30A314203F;
        Wed, 18 May 2022 16:51:37 +0000 (GMT)
Received: from [9.171.6.188] (unknown [9.171.6.188])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 May 2022 16:51:37 +0000 (GMT)
Message-ID: <5de8d8c2-100d-f935-667c-1090ee31277d@linux.ibm.com>
Date:   Wed, 18 May 2022 18:55:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v9 3/3] s390x: KVM: resetting the Topology-Change-Report
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, thuth@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com, wintera@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
 <20220506092403.47406-4-pmorel@linux.ibm.com>
 <76fd0c11-5b9b-0032-183b-54db650f13b1@redhat.com>
 <20220512115250.2e20bfdf@p-imbrenda>
 <70a7d93c-c1b1-fa72-0eb4-02e3e2235f94@redhat.com>
 <bae4e416-b0e9-31c6-c9d0-df6b5a5fd46f@linux.ibm.com>
 <cfe448f7-0b4e-680d-46a7-33ad25a4c09b@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <cfe448f7-0b4e-680d-46a7-33ad25a4c09b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: W5fS3N71cLrX1I_e6-quxj7Z0L_xZDmt
X-Proofpoint-GUID: uu-AwpmzG2aQew89jZnaju95wJ-pORKx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=792 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205180099
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/18/22 16:33, David Hildenbrand wrote:
> On 16.05.22 16:21, Pierre Morel wrote:
>>
>>
>> On 5/12/22 12:01, David Hildenbrand wrote:
>>>>>
>>>>> I think we prefer something like u16 when copying to user space.
>>>>
>>>> but then userspace also has to expect a u16, right?
>>>
>>> Yep.
>>>
>>
>> Yes but in fact, inspired by previous discussion I had on the VFIO
>> interface, that is the reason why I did prefer an int.
>> It is much simpler than a u16 and the definition of a bit.
>>
>> Despite a bit in a u16 is what the s3990 achitecture proposes I thought
>> we could make it easier on the KVM/QEMU interface.
>>
>> But if the discussion stops here, I will do as you both propose change
>> to u16 in KVM and userland and add the documentation for the interface.
> 
> In general, we pass via the ABI fixed-sized values -- u8, u16, u32, u64
> ... instead of int. Simply because sizeof(int) is in theory variable
> (e.g., 32bit vs 64bit).
> 
> Take a look at arch/s390/include/uapi/asm/kvm.h and you won't find any
> usage of int or bool.
> 
> Having that said, I'll let the maintainers decide. Using e.g., u8 is
> just the natural thing to do on a Linux ABI, but we don't really support
> 32 bit ... maybe we'll support 128bit at one point? ;)
> 

OK then I use u16 with a flag in case we get something in the utilities 
which is related to the topology in the future.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
