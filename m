Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7FB5ED865
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 11:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbiI1JGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 05:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbiI1JFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 05:05:48 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E12B1AF02
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 02:05:12 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28S8lZoh007633;
        Wed, 28 Sep 2022 09:05:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mOWQIBzUMWGS2vEJI1vSlEYeBFZsn68gjHfZuTclrUE=;
 b=f6PwKfaOoD6jvV0a8O3dEBo4GNw8J5fNwjF74hHDRoiveMEQl1WkaLNd5ZBJ2cNkMgOd
 5a61kDK5VrBgVhF1U8ngnWAFWZM5daaSX2CcDEkPZMiIesASDTwvDhVQal4mcZ4V+CO2
 HehtlOyHeAlvZnBw3R1j6DVU3PlJ4wNRkHLKzAkT7BZ+i4HQ6gtTVKjoqfmqsxTKWtJX
 fhipuJOMrIwHpN3hBAzZhwgOk5yxlLxMSCysbl5l+TuRtvfNujR3a/j4I11P+4dbp4dD
 kK5v7r3+W5wD7nQC0h8qfOf6p3n/Vo9FWzl65ACBOx3XqOJYqGJgSa7v3eebZlxuXABt hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvf8rf4h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 09:05:03 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28S8o7SU013365;
        Wed, 28 Sep 2022 09:05:02 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jvf8rf4fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 09:05:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28S8qSsp015006;
        Wed, 28 Sep 2022 09:05:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3jss5j501w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 09:05:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28S95Pev51904772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 09:05:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F5A54C040;
        Wed, 28 Sep 2022 09:04:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 194FC4C044;
        Wed, 28 Sep 2022 09:04:56 +0000 (GMT)
Received: from [9.171.31.212] (unknown [9.171.31.212])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Sep 2022 09:04:56 +0000 (GMT)
Message-ID: <c5f28aa1-bc09-d193-a402-132949a95b32@linux.ibm.com>
Date:   Wed, 28 Sep 2022 11:04:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v9 04/10] hw/core: introducing drawer and books for s390x
Content-Language: en-US
To:     Markus Armbruster <armbru@redhat.com>
Cc:     qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <20220902075531.188916-5-pmorel@linux.ibm.com> <87ilm03mkl.fsf@pond.sub.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <87ilm03mkl.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 86m8N50ZMLclAOAlZXpWdD2YSQSYCWhJ
X-Proofpoint-GUID: 8DlWo8xff9iwHynR2Gp_OLpx3B37je31
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_03,2022-09-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209280055
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/6/22 10:59, Markus Armbruster wrote:
> Pierre Morel <pmorel@linux.ibm.com> writes:
> 
>> S390x defines two topology levels above sockets: nbooks and drawers.
> 
> nbooks or books?
> 
>> Let's add these two levels inside the CPU topology implementation.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
> 
> [...]
> 
>> diff --git a/qapi/machine.json b/qapi/machine.json
>> index 6afd1936b0..bdd92e3cb1 100644
>> --- a/qapi/machine.json
>> +++ b/qapi/machine.json
>> @@ -900,13 +900,15 @@
>>   # a CPU is being hotplugged.
>>   #
>>   # @node-id: NUMA node ID the CPU belongs to
>> -# @socket-id: socket number within node/board the CPU belongs to
>> +# @drawer-id: drawer number within node/board the CPU belongs to
>> +# @book-id: book number within drawer/node/board the CPU belongs to
>> +# @socket-id: socket number within book/node/board the CPU belongs to
>>   # @die-id: die number within socket the CPU belongs to (since 4.1)
>>   # @cluster-id: cluster number within die the CPU belongs to (since 7.1)
>>   # @core-id: core number within cluster the CPU belongs to
>>   # @thread-id: thread number within core the CPU belongs to
>>   #
>> -# Note: currently there are 6 properties that could be present
>> +# Note: currently there are 7 properties that could be present
> 
> Should this be 8?

when one can count .. yes :)

Thanks, I will update in next spin

> 
>>   #       but management should be prepared to pass through other
>>   #       properties with device_add command to allow for future
>>   #       interface extension. This also requires the filed names to be kept in
>     #       sync with the properties passed to -device/device_add.
> 
> Not your patch's fault, but the second sentence is less than clear.
> What are "the filed names"?  A typo perhaps?

I understood that it means the names in the structure here under which 
are filed inside the single quotes.


In this case, may be "filed names" should be replaced by
"names in the CpuInstanceProperties structure"


> 
>> @@ -916,6 +918,8 @@
>>   ##
>>   { 'struct': 'CpuInstanceProperties',
>>     'data': { '*node-id': 'int',
>> +            '*drawer-id': 'int',
>> +            '*book-id': 'int',
>>               '*socket-id': 'int',
>>               '*die-id': 'int',
>>               '*cluster-id': 'int',
>> @@ -1465,6 +1469,10 @@
>>   #

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
