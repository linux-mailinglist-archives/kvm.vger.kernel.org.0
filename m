Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3524F6A43E5
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 15:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjB0OMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 09:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjB0OMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 09:12:49 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150CC1F5F3
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 06:12:47 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31RCp0xS015357;
        Mon, 27 Feb 2023 14:12:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RecC7rHyv3OaSHBoK001Oi7WNgz22tN0XMpLt2V2JR8=;
 b=d7lYa0v2V07tMlzpn9hjGPjvf5UK9hLyFVUPiA8uHxbfchihfZsLrYkq25Ie0bsxVbId
 +g/EF+wOLkm6VATO/peWKHIjsSFjauRkyodG9C7KJ08I05TvAbSBnOeEBk6VzWD5L1Vv
 itlmpzJWp6ENF+w0COYwHQ1OI1s7YkG0VYFr8v/F3lXSvuuGw3jNVtjd8JLDR9NZ1nV7
 fSXfe/Pc+YgP/swWr89yf8Fcr0kVF5SqKIUi2z1osjK9AG4pUWNgcE/v3IJWAOZyefZJ
 HASm4oLpEtcA6p11h0+9EWm/xWFzPlzHU9o8jLJmcw7qPIJhUHnvxEsepQIOkwzLOFqh 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0vvqj5wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:12:34 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31RCrNU3025428;
        Mon, 27 Feb 2023 14:12:34 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p0vvqj5w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:12:33 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31R0jfRN004195;
        Mon, 27 Feb 2023 14:12:31 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3nybe2hg7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Feb 2023 14:12:31 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31RECSIZ55443858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 14:12:28 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E92CC20049;
        Mon, 27 Feb 2023 14:12:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDD1B20043;
        Mon, 27 Feb 2023 14:12:25 +0000 (GMT)
Received: from [9.171.14.212] (unknown [9.171.14.212])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon, 27 Feb 2023 14:12:25 +0000 (GMT)
Message-ID: <56044278-4d12-189d-1793-ef242df39df6@linux.ibm.com>
Date:   Mon, 27 Feb 2023 15:12:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v16 06/11] s390x/cpu topology: interception of PTF
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
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <20230222142105.84700-7-pmorel@linux.ibm.com>
 <f6854f27-2c32-dc07-883d-9cbfc9d49c48@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <f6854f27-2c32-dc07-883d-9cbfc9d49c48@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: S7FLmMw3jGGzpAkeScim73wLYJZqwyVp
X-Proofpoint-GUID: UfEJlwSrEX1CXyk12BnhSdShu1nmFHGM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_10,2023-02-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 clxscore=1015 suspectscore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302270109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/27/23 13:39, Thomas Huth wrote:
> On 22/02/2023 15.21, Pierre Morel wrote:
>> When the host supports the CPU topology facility, the PTF
>> instruction with function code 2 is interpreted by the SIE,
>> provided that the userland hypervisor activates the interpretation
>> by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.
>>
>> The PTF instructions with function code 0 and 1 are intercepted
>> and must be emulated by the userland hypervisor.
>>
>> During RESET all CPU of the configuration are placed in
>> horizontal polarity.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   include/hw/s390x/s390-virtio-ccw.h |  6 +++
>>   hw/s390x/cpu-topology.c            | 85 ++++++++++++++++++++++++++++++
>>   target/s390x/kvm/kvm.c             | 11 ++++
>>   3 files changed, 102 insertions(+)
>>
>> diff --git a/include/hw/s390x/s390-virtio-ccw.h 
>> b/include/hw/s390x/s390-virtio-ccw.h
>> index 9bba21a916..c1d46e78af 100644
>> --- a/include/hw/s390x/s390-virtio-ccw.h
>> +++ b/include/hw/s390x/s390-virtio-ccw.h
>> @@ -30,6 +30,12 @@ struct S390CcwMachineState {
>>       uint8_t loadparm[8];
>>   };
>>   +#define S390_PTF_REASON_NONE (0x00 << 8)
>> +#define S390_PTF_REASON_DONE (0x01 << 8)
>> +#define S390_PTF_REASON_BUSY (0x02 << 8)
>> +#define S390_TOPO_FC_MASK 0xffUL
>> +void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra);
>> +
>>   struct S390CcwMachineClass {
>>       /*< private >*/
>>       MachineClass parent_class;
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> index 08642e0e04..40253a2444 100644
>> --- a/hw/s390x/cpu-topology.c
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -87,6 +87,89 @@ static void s390_topology_init(MachineState *ms)
>>       QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
>>   }
>>   +/**
>> + * s390_topology_set_cpus_entitlement:
>> + * @polarization: polarization requested by the caller
>> + *
>> + * Set all CPU entitlement according to polarization and
>> + * dedication.
>> + * Default vertical entitlement is S390_CPU_ENTITLEMENT_MEDIUM as
>> + * it does not require host modification of the CPU provisioning
>> + * until the host decide to modify individual CPU provisioning
>> + * using QAPI interface.
>> + * However a dedicated vCPU will have a S390_CPU_ENTITLEMENT_HIGH
>> + * entitlement.
>> + */
>> +static void s390_topology_set_cpus_entitlement(int polarization)
>> +{
>> +    CPUState *cs;
>> +
>> +    CPU_FOREACH(cs) {
>> +        if (polarization == S390_CPU_POLARIZATION_HORIZONTAL) {
>> +            S390_CPU(cs)->env.entitlement = 0;
>
> Maybe use S390_CPU_ENTITLEMENT_HORIZONTAL instead of "0" ?


OK


>
>> +        } else if (S390_CPU(cs)->env.dedicated) {
>> +            S390_CPU(cs)->env.entitlement = S390_CPU_ENTITLEMENT_HIGH;
>> +        } else {
>> +            S390_CPU(cs)->env.entitlement = 
>> S390_CPU_ENTITLEMENT_MEDIUM;
>> +        }
>> +    }
>> +}
>
> With the nit above fixed:
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>
Thanks,

Pierre


