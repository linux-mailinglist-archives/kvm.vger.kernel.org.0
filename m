Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3121360F631
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 13:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbiJ0L2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 07:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbiJ0L2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 07:28:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E4D10048A
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 04:28:41 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RBIShr014647;
        Thu, 27 Oct 2022 11:28:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dHihZSnzDxwsRXGBYmUblZVMuHUw0YOiNvbiRQEmgEA=;
 b=JyQ+WWKTzlF98+WblQG+wV9IU6rLCanZmpeDxLdCO1blIKIIJ2BvDDXefuE/EaRTldeV
 5HEsmRsWc35Eu2RuJhU+xXhQvM4+LrzoYFBBTJGEs6UYlv+TVYG4rvVaadqiTb1fKZr2
 YfPxz1tXP0jrLZdX89Vg/IGzUewoveGsxwIbQfzbEeCKBo1FO3RhLvqu139T5y/76M3b
 JWMgwCQqcbJNpcKL4e+rSsrABUBbgxckj31h6HuMiIaSxyAM36NMbD0P54Czur47F3Wp
 n7/QpJK3BVsj5hS2qk6tlOc8BFeuyvDMrnQLRuWmR3uCjcgjTzsBuZLMhC5XlY30jl1T uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kfs0687be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Oct 2022 11:28:26 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29RBKxd6021825;
        Thu, 27 Oct 2022 11:28:25 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kfs0687ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Oct 2022 11:28:25 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29RBL6gm016077;
        Thu, 27 Oct 2022 11:28:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3kfahp16ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Oct 2022 11:28:23 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29RBStu434079222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 11:28:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6782DA405C;
        Thu, 27 Oct 2022 11:28:20 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F0E8A4054;
        Thu, 27 Oct 2022 11:28:19 +0000 (GMT)
Received: from [9.179.10.218] (unknown [9.179.10.218])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Oct 2022 11:28:19 +0000 (GMT)
Message-ID: <b521b6fc-7e99-6595-aac9-c4ce38c3144e@linux.ibm.com>
Date:   Thu, 27 Oct 2022 13:28:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v10 7/9] s390x/cpu topology: add max_threads machine class
 attribute
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
 <20221012162107.91734-8-pmorel@linux.ibm.com>
 <910308da-1cc6-03ea-c8b4-304d90271b8d@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <910308da-1cc6-03ea-c8b4-304d90271b8d@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vyDNanVBz8KRkbBBIP_9CKAbbwxg3x7t
X-Proofpoint-ORIG-GUID: IPQJX7RhtQGBEUQdYUJQX7drrh8-Vbrt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_05,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0 mlxscore=0
 clxscore=1015 mlxlogscore=998 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210270061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/27/22 12:00, Cédric Le Goater wrote:
> Hello Pierre,
> 
> On 10/12/22 18:21, Pierre Morel wrote:
>> The S390 CPU topology accepts the smp.threads argument while
>> in reality it does not effectively allow multthreading.
>>
>> Let's keep this behavior for machines older than 7.3 and
>> refuse to use threads in newer machines until multithreading
>> is really proposed to the guest by the machine.
> 
> This change is unrelated to the rest of the series and we could merge it
> for 7.2. We still have time for it.

OK, then I send it on its own

Regards,
Pierre

...

-- 
Pierre Morel
IBM Lab Boeblingen
