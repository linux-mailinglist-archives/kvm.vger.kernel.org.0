Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAE968BD6F
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 14:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjBFNCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 08:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBFNCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 08:02:41 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1399323326
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 05:02:40 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 316D0qCA025061;
        Mon, 6 Feb 2023 13:02:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BhLI7FcTDjadHxnMvPsM3UVArQEhPdX7T+OjtiOG8Dw=;
 b=EetWxw7xmdYdFeEOzOM0NB+9ywmyNDwQ/IJf+wcTr+DGclnDm+xa1x8Bib+yu1W664PO
 1gunMM4vJDp/72PlzjN6eYdLX0NohBMB5mrSltq7yXfv8roOSQgj/ak1naQmGVGGvqRa
 cZCZlpFpNRJlnC+Otw99STZjWA4BBsJv80jFKjYYId/VNmqL5UGIijRA/FHE8/6UivYf
 pmITYcHRWC99fBlflzN0zeMF4Ts8fcDreGoM/Ce5d9535ctdhv1F7/GBwI4Wv2ZyKs39
 AAolLahbo1yIjiBccD5+eFQKK2alALFCvgcN1OlKF3m8xfP9uKv+dFec9d1vM+RiJ3qX mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk22681yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 13:02:27 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 316D1IkZ027920;
        Mon, 6 Feb 2023 13:02:27 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nk22681sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 13:02:27 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 315N0mZc022560;
        Mon, 6 Feb 2023 13:02:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3nhemfje3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 13:02:16 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 316D2CkA39715108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Feb 2023 13:02:12 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63E7B20043;
        Mon,  6 Feb 2023 13:02:12 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DC1720040;
        Mon,  6 Feb 2023 13:02:11 +0000 (GMT)
Received: from [9.171.30.242] (unknown [9.171.30.242])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Feb 2023 13:02:11 +0000 (GMT)
Message-ID: <ffdc5108-b362-8373-f3c6-fc572d0b8f1a@linux.ibm.com>
Date:   Mon, 6 Feb 2023 14:02:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v15 06/11] s390x/cpu topology: interception of PTF
 instruction
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-7-pmorel@linux.ibm.com>
 <92533b03-f07e-736a-4e29-bcdf883f7ec4@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <92533b03-f07e-736a-4e29-bcdf883f7ec4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7qa0IDZ0-C72yDzK7A0YxqOadoa5jwG8
X-Proofpoint-ORIG-GUID: SQf9uUKTd32VF4eoGW6F7Z2It97lRmNz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_06,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302060111
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/6/23 12:38, Thomas Huth wrote:
> On 01/02/2023 14.20, Pierre Morel wrote:
>> When the host supports the CPU topology facility, the PTF
>> instruction with function code 2 is interpreted by the SIE,
>> provided that the userland hypervizor activates the interpretation
> 
> s/hypervizor/hypervisor/

grr, I was pretty sure you already said that to me and I did change 
it... seems I did not.

done now.

> 
>> by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.
>>
>> The PTF instructions with function code 0 and 1 are intercepted
>> and must be emulated by the userland hypervizor.
> 
> dito

yes, thx.

> 
>> During RESET all CPU of the configuration are placed in
>> horizontal polarity.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
> ...
>>   /**
>>    * s390_topology_reset:
>>    *
>>    * Generic reset for CPU topology, calls s390_topology_reset()
>>    * s390_topology_reset() to reset the kernel Modified Topology
>>    * change record.
>> + * Then set global and all CPUs polarity to POLARITY_HORIZONTAL.
> 
> You describe here already what's going to happen...
> 
>>    */
>>   void s390_topology_reset(void)
>>   {
>>       s390_cpu_topology_reset();
>> +    /* Set global polarity to POLARITY_HORIZONTAL */
> 
> ... then here again ...
> 
>> +    s390_topology.polarity = POLARITY_HORIZONTAL;
> 
> ... and the code is (fortunately) also very self-exaplaining...
> 
>> +    /* Set all CPU polarity to POLARITY_HORIZONTAL */
>> +    s390_topology_set_cpus_polarity(POLARITY_HORIZONTAL);
> 
> ... so I'd rather drop the two comments within the function body.

OK

> 
>>   }
> 
> (rest of the patch looks fine to me)
> 
>   Thomas
> 

Thanks.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
