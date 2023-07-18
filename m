Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D2A757BF2
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 14:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbjGRMfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 08:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbjGRMe7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 08:34:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2924EE56
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 05:34:59 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36ICQwHj007372;
        Tue, 18 Jul 2023 12:34:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VnbZDPxqB4yd1kRMw9aX83N9UFX0C0DmsMABUvisgK0=;
 b=VOA9i/ZKk5EX7MzNKRuznzfLxRmXOsUJ7BzCUP6fyCdfIrZlfsPDiUTz5u6AAV4mw32M
 aAV1IEwIzaxIGo8wsqGg6JdUor33puGNSGd6FcBaZNj5f03IegwUqWfkrh1p3lPkA2Of
 9D3HsDAI6dek4jHAOR/qE0bb7N3QJKSbBbh9CYryH3oewfM1eBMy8JVjT0kli6S7w14o
 sDOTSeRDfnik8qm5MRNTL9G8IyPaPeg2lVj61W88tn7oVUz8jXZXEJ6aIfSuoYVnjZlU
 dvk3VONhw/POxKvXEBEbCHooi2H0k4AMtX3EUoIgY54/oxT/dI/nwiWx0mEudQoriI2v rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rwtrc05g4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 12:34:49 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36ICT2k8014408;
        Tue, 18 Jul 2023 12:34:48 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rwtrc05eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 12:34:48 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36ICLxXE030687;
        Tue, 18 Jul 2023 12:34:46 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3rv79jjnxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 12:34:46 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36ICYgZs23659046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 12:34:42 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21C022004B;
        Tue, 18 Jul 2023 12:34:42 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D43EF20040;
        Tue, 18 Jul 2023 12:34:40 +0000 (GMT)
Received: from [9.171.12.30] (unknown [9.171.12.30])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 18 Jul 2023 12:34:40 +0000 (GMT)
Message-ID: <4876348b-b540-6d3b-18ae-c8b8894662ce@linux.ibm.com>
Date:   Tue, 18 Jul 2023 14:34:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v21 11/20] qapi/s390x/cpu topology:
 CPU_POLARIZATION_CHANGE qapi event
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-12-pmorel@linux.ibm.com>
 <94f9f61ac3503bed380ce232ca0f5885982ee6e4.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <94f9f61ac3503bed380ce232ca0f5885982ee6e4.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5HNMjQtUR1WGbl3dWfATuBZmjhhsVQTe
X-Proofpoint-ORIG-GUID: urCQxyxCpKCh7hLMBVd2SwSXAwr5FNwn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-18_09,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 adultscore=0 malwarescore=0 mlxlogscore=975 mlxscore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307180115
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/18/23 09:59, Nina Schoetterl-Glausch wrote:
> On Fri, 2023-06-30 at 11:17 +0200, Pierre Morel wrote:
>> When the guest asks to change the polarization this change
>> is forwarded to the upper layer using QAPI.
>> The upper layer is supposed to take according decisions concerning
>> CPU provisioning.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>
Thanks,

Pierre

