Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2AD86A84C4
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 16:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjCBPAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 10:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjCBPAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 10:00:34 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691DC3C793
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 07:00:33 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 322EfQOC004783;
        Thu, 2 Mar 2023 15:00:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=K6prRmps7HVclrcnV6JjrV3tda4XiHMo7MzUZmflhQI=;
 b=OCpCxvV/9SaUKFscXokIdTx9eoRge+4EopaB9UAOMcns7uUHY1H8VXUww8jD7lUkU3zr
 eNhb2nLZABey51bBC6oWJR9368sqGsyjJ45KHARAOCucwSVgo75x9TI6cVG1IweXqdcw
 aTUINCoG9uy5pwgD0vxvngbwRE3X6shRaVNFhSyNu7zpVCGj9PN3VALjBYBWbFRxSyhH
 FZiYgjrvOGRg+v0xmpaA30MqtGGeFDFcE/QhBvK3I0jXljfMV2i87Wi98V/awSWs0IYV
 y2EnMiZFqCuVCYwUdKypuJP6SUvbwEtrw/2+KausTRZc2tNNPZu88cErwAuwqK3vZjtP DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p2ukbcuq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Mar 2023 15:00:24 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 322EhFoJ011046;
        Thu, 2 Mar 2023 15:00:23 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p2ukbcunh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Mar 2023 15:00:23 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 321LqGor016783;
        Thu, 2 Mar 2023 15:00:20 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3nybbdmcm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Mar 2023 15:00:20 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 322F0HaA22413832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Mar 2023 15:00:17 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03CF92004D;
        Thu,  2 Mar 2023 15:00:17 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E2E120040;
        Thu,  2 Mar 2023 15:00:15 +0000 (GMT)
Received: from [9.171.4.190] (unknown [9.171.4.190])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu,  2 Mar 2023 15:00:15 +0000 (GMT)
Message-ID: <bb77d684-272b-06eb-6ed8-c7f2b610d6e4@linux.ibm.com>
Date:   Thu, 2 Mar 2023 16:00:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v16 08/11] qapi/s390x/cpu topology: set-cpu-topology
 monitor command
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <20230222142105.84700-9-pmorel@linux.ibm.com>
 <aaf4aa7b7350e88f65fc03f148146e38fe4f7fdb.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <aaf4aa7b7350e88f65fc03f148146e38fe4f7fdb.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ttoWjoeuu77gVDOYs8Dffc0Ow6Mh-RNC
X-Proofpoint-GUID: GFZaH6sKuIAKe8eFT-NGcqWBb4Bp8hWf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-02_08,2023-03-02_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 impostorscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303020126
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/24/23 18:15, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-02-22 at 15:21 +0100, Pierre Morel wrote:
[...]
>> diff --git a/hmp-commands.hx b/hmp-commands.hx
>> index fbb5daf09b..d8c37808c7 100644
>> --- a/hmp-commands.hx
>> +++ b/hmp-commands.hx
>> @@ -1815,3 +1815,20 @@ SRST
>>     Dump the FDT in dtb format to *filename*.
>>   ERST
>>   #endif
>> +
>> +#if defined(TARGET_S390X)
>> +    {
>> +        .name       = "set-cpu-topology",
>> +        .args_type  = "core:l,socket:l?,book:l?,drawer:l?,entitlement:s?,dedicated:b?",
> Can you use ":O" for the ids? It would allow for some more flexibility.


I think it is better if let fall the hmp interface for the moment and 
will send it later in another series.

Regards,

Pierre



