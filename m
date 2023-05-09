Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5554A6FC1DB
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 10:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbjEIIlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 04:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbjEIIk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 04:40:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF7A659B
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 01:40:57 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3498aPfn021851;
        Tue, 9 May 2023 08:40:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Z+Uh7SECw9VZRNN30LKnaUJm+sUdvg6NnNkJ5LVeR/M=;
 b=OHw75/S3lizZGfUCXXpa3xHZSy+qDIVR/atDF5QCZJ2asDfX1xvt5qaLzoTjsVY5uq3V
 V0boO+rd5tSSGURy/Zt+gwF38+lSFmnk2h04XB33S3GObECPbsxiHktkz7kxoCgBihTQ
 ehpeaITw5mfOnS2perK/8qjM081GlCKM+90JO93UIBWLFmJn4QoKhRTThtH0zPYr4oSB
 QBioHqt6pTn5y0yafByYmbhLwyW4nYZYH92jjGmqb6hgbli1ckZglXAqKIfR2Eal+2xs
 Es6zGPmVbKspSrLqZxPEo1YIuQypKuA7gp3BeU3dffRXhl3MGQA3K5LB5PKJ2Dd6e9xv gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfj0vhary-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 08:40:43 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3498aZMr023143;
        Tue, 9 May 2023 08:40:42 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfj0vhaqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 08:40:41 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 348LtKvM016562;
        Tue, 9 May 2023 08:40:39 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qf896r9k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 08:40:39 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3498eX9B34276030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 May 2023 08:40:33 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B68D20049;
        Tue,  9 May 2023 08:40:33 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A558C2004F;
        Tue,  9 May 2023 08:40:32 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue,  9 May 2023 08:40:32 +0000 (GMT)
Message-ID: <a177996e-60e9-00d8-a839-da9f23554440@linux.ibm.com>
Date:   Tue, 9 May 2023 10:40:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v20 10/21] machine: adding s390 topology to info
 hotpluggable-cpus
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-11-pmorel@linux.ibm.com>
 <12bcbb44bfd2b6708bc74509ec5b6053af8614bc.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <12bcbb44bfd2b6708bc74509ec5b6053af8614bc.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZkijTDr-5-e7wrgNWvJYaRltIINS6jel
X-Proofpoint-ORIG-GUID: WfLRhoCppnCoFHeWAMd9iHLCS38pt5nx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_05,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 clxscore=1015 spamscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305090065
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/8/23 21:49, Nina Schoetterl-Glausch wrote:
> On Tue, 2023-04-25 at 18:14 +0200, Pierre Morel wrote:
>> S390 topology adds books and drawers topology containers.
>> Let's add these to the HMP information for hotpluggable cpus.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>


Thanks

>
> if you fix the nits below.
>> ---
>>   hw/core/machine-hmp-cmds.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/hw/core/machine-hmp-cmds.c b/hw/core/machine-hmp-cmds.c
>> index c3e55ef9e9..971212242d 100644
>> --- a/hw/core/machine-hmp-cmds.c
>> +++ b/hw/core/machine-hmp-cmds.c
>> @@ -71,6 +71,12 @@ void hmp_hotpluggable_cpus(Monitor *mon, const QDict *qdict)
>>           if (c->has_node_id) {
>>               monitor_printf(mon, "    node-id: \"%" PRIu64 "\"\n", c->node_id);
>>           }
>> +        if (c->has_drawer_id) {
>> +            monitor_printf(mon, "    drawer_id: \"%" PRIu64 "\"\n", c->drawer_id);
>                             use - instead here ^ unless there is some reason to be inconsistent.


Oh, yes, thanks.

>> +        }
>> +        if (c->has_book_id) {
>> +            monitor_printf(mon, "      book_id: \"%" PRIu64 "\"\n", c->book_id);
> Same here.
>
>> +        }
>>           if (c->has_socket_id) {
>>               monitor_printf(mon, "    socket-id: \"%" PRIu64 "\"\n", c->socket_id);
>>           }

Regards,

Pierre


