Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE3554315F
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 15:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240121AbiFHNb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 09:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239983AbiFHNbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 09:31:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F664C9EC0;
        Wed,  8 Jun 2022 06:31:53 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258CqAet018265;
        Wed, 8 Jun 2022 13:31:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tbUoJADDfy69tOLB5oIBIp2mPffNhGp0fJvy4h43UCM=;
 b=eCd5WUFsd3ynHYKoY28p32KjL3IK+IWshKurZpMZLW2R3aT7Q7/w66f+i80MhmnL2KPt
 ayBNp4kxYLsBSjaeOQd0S0EDsFlfKg08m76hPPUQjpOi8JLILrf6IphlVIgOVb7yyZey
 iicvw6vzE4gYnh+Afxal17C3LD/0StM89V6g5IbqS1S1Rk0/ZwRiNMflbb+OQ/CVDIkn
 UwAPGAUH/6ID0DSBjMlR0PZEHZl6aJdSkZ4y9EuBt0yXp9KZD6C2ClVFY/uxah1w5vQA
 2t7EzN7z0oNvZgyqrY9d2Sy6ilEJvckAp60R92hTfp1GvwJZw4rOMjoYwWNJ/BYqRxrd jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjv5cgxf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:31:50 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258DPw01016869;
        Wed, 8 Jun 2022 13:31:50 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjv5cgxeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:31:49 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258DKMJ7006054;
        Wed, 8 Jun 2022 13:31:48 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 3gfy19uhua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:31:48 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258DVlt830736866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 13:31:47 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86748BE053;
        Wed,  8 Jun 2022 13:31:47 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 857F6BE04F;
        Wed,  8 Jun 2022 13:31:46 +0000 (GMT)
Received: from [9.160.55.57] (unknown [9.160.55.57])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jun 2022 13:31:46 +0000 (GMT)
Message-ID: <db3bc9c5-8f65-0507-2453-ccee41e10127@linux.ibm.com>
Date:   Wed, 8 Jun 2022 09:31:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v19 11/20] s390/vfio-ap: prepare for dynamic update of
 guest's APCB on queue probe/remove
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-12-akrowiak@linux.ibm.com>
 <9364a1b7-9060-20aa-b0d6-88c41a30e7d4@linux.ibm.com>
 <f838f274-ff4d-496d-2393-14423117ff7e@linux.ibm.com>
 <20220607140544.32d33f3d.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220607140544.32d33f3d.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xOfdXdbKMTdautt6Ps_qr1bprHaB9I8i
X-Proofpoint-ORIG-GUID: ELQ7UXCaAOPiI9u170yr3ccxVjU7AFxA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_04,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 malwarescore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080058
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/7/22 8:05 AM, Halil Pasic wrote:
> On Tue, 31 May 2022 06:44:46 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>> vfio_ap_mdev_get_update_locks_for_apqn is "crazy long".
>>> How about:
>>>    get_mdev_for_apqn()
>>>
>>> This function is static and the terms mdev and apqn are specific
>>> enough that I
>>> don't think it needs to start with vfio_ap. And there is no need to
>>> state in
>>> the function name that locks are acquired. That point will be obvious
>>> to anyone
>>> reading the prologue or the code.
>> The primary purpose of the function is to acquire the locks in the
>> proper order, so
>> I think the name should state that purpose. It may be obvious to someone
>> reading
>> the prologue or this function, but not so obvious in the context of the
>> calling function.
> I agree with Tony. To me get_mdev_for_apqn() sounds like getting a
> reference to a matrix_mdev object (and incrementing its refcount) or
> something similar. BTW some more bike shedding: I prefer by_apqn instead
> of for_apqn, because the set of locks we need to take is determined _by_
> the apqn parameter, but it ain't semantically the set of locks we need
> to perform an update operation on the apqn or on the queue associated
> with the apqn. No strong opinion though -- I'm no native speaker and
> prepositions are difficult for me.

I am a native speaker and I had to review prepositions. I learned
grammar in elementary school (grades 1-6) and have forgotten
much of the terminology as it relates to sentence structure. Anyway,
I digress. I'm okay with 'by_apqn'.

>
> Regards,
> Halil

