Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57530750B44
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 16:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjGLOpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 10:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjGLOps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 10:45:48 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFF1BB
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 07:45:47 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CEdGp7007244;
        Wed, 12 Jul 2023 14:45:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=g7eTTMWc5xtUFMle4KyiSsTOmZcnDzyBnyqqowTWkaI=;
 b=QSw0nWNyXItx2BatK6mvCBA2UZZ8NHsNsDoTqTKc45Z0CiMBzn99oyy/CgCLR6fa0opb
 2gmM42Pe+tU8AUQH/WLvz9Da2i27XoOdalxBQeSjvCFB+N5BdkpuSeAU3PIC9oymjy41
 8AmRDjyXc2OUpLcPqA9Oq6kyzfFrjv+CSbQrDrxIgv1qu+VUw97mGdCBfG9cRG+xtwfX
 CzBLlXc7bwmXnwqaJeo+1uNjfeQjL0VhYZ/O9FhGla5sddsVoxUESFh3f+eOBjLHYngn
 dxws61Nzf4jToFHIstBn9r4gk/Z34m7dYpUNKjJLAmCf0QJ+x7xytqbXX6bBPTYag7Ex ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rswv30pur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 14:45:34 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36CEdZqV009990;
        Wed, 12 Jul 2023 14:45:32 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rswv30psx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 14:45:31 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36C4dLOI017376;
        Wed, 12 Jul 2023 14:45:25 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3rpye5apqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 14:45:25 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36CEjJ1s21627400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 14:45:19 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B932820043;
        Wed, 12 Jul 2023 14:45:19 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3920720040;
        Wed, 12 Jul 2023 14:45:19 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 12 Jul 2023 14:45:19 +0000 (GMT)
Message-ID: <ef63c32b-7054-b00f-63dc-a95f02eb4ba2@linux.ibm.com>
Date:   Wed, 12 Jul 2023 16:45:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v21 08/20] qapi/s390x/cpu topology: set-cpu-topology qmp
 command
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-9-pmorel@linux.ibm.com>
 <7d1797ba-7e19-2fc8-535f-66f3d3aaaa75@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <7d1797ba-7e19-2fc8-535f-66f3d3aaaa75@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RH3zG5LJo6FCJetz8sSwa-U6qiVfO37K
X-Proofpoint-ORIG-GUID: Gi-niht-gMSh6DNzw1YYPDCpDLATMlQf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_09,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999
 phishscore=0 spamscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307120131
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/4/23 14:53, Thomas Huth wrote:
> On 30/06/2023 11.17, Pierre Morel wrote:
>> The modification of the CPU attributes are done through a monitor
>> command.
>>
>> It allows to move the core inside the topology tree to optimize
>> the cache usage in the case the host's hypervisor previously
>> moved the CPU.
>>
>> The same command allows to modify the CPU attributes modifiers
>> like polarization entitlement and the dedicated attribute to notify
>> the guest if the host admin modified scheduling or dedication of a vCPU.
>>
>> With this knowledge the guest has the possibility to optimize the
>> usage of the vCPUs.
>>
>> The command has a feature unstable for the moment.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
> ...
>> diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
>> index 1af70a5049..dfc4cb42a4 100644
>> --- a/hw/s390x/cpu-topology.c
>> +++ b/hw/s390x/cpu-topology.c
>> @@ -23,6 +23,7 @@
>>   #include "target/s390x/cpu.h"
>>   #include "hw/s390x/s390-virtio-ccw.h"
>>   #include "hw/s390x/cpu-topology.h"
>> +#include "qapi/qapi-commands-machine-target.h"
>>     /*
>>    * s390_topology is used to keep the topology information.
>> @@ -260,6 +261,29 @@ static bool s390_topology_check(uint16_t 
>> socket_id, uint16_t book_id,
>>       return true;
>>   }
>>   +/**
>> + * s390_topology_need_report
>> + * @cpu: Current cpu
>> + * @drawer_id: future drawer ID
>> + * @book_id: future book ID
>> + * @socket_id: future socket ID
>> + * @entitlement: future entitlement
>> + * @dedicated: future dedicated
>> + *
>> + * A modified topology change report is needed if the topology
>> + * tree or the topology attributes change.
>> + */
>> +static bool s390_topology_need_report(S390CPU *cpu, int drawer_id,
>> +                                   int book_id, int socket_id,
>> +                                   uint16_t entitlement, bool 
>> dedicated)
>> +{
>> +    return cpu->env.drawer_id != drawer_id ||
>> +           cpu->env.book_id != book_id ||
>> +           cpu->env.socket_id != socket_id ||
>> +           cpu->env.entitlement != entitlement ||
>> +           cpu->env.dedicated != dedicated;
>> +}
>> +
>>   /**
>>    * s390_update_cpu_props:
>>    * @ms: the machine state
>> @@ -329,3 +353,113 @@ void s390_topology_setup_cpu(MachineState *ms, 
>> S390CPU *cpu, Error **errp)
>>       /* topology tree is reflected in props */
>>       s390_update_cpu_props(ms, cpu);
>>   }
>> +
>> +static void s390_change_topology(uint16_t core_id,
>> +                                 bool has_socket_id, uint16_t 
>> socket_id,
>> +                                 bool has_book_id, uint16_t book_id,
>> +                                 bool has_drawer_id, uint16_t 
>> drawer_id,
>> +                                 bool has_entitlement,
>> +                                 CpuS390Entitlement entitlement,
>> +                                 bool has_dedicated, bool dedicated,
>> +                                 Error **errp)
>> +{
>> +    MachineState *ms = current_machine;
>> +    int old_socket_entry;
>> +    int new_socket_entry;
>> +    bool report_needed;
>> +    S390CPU *cpu;
>> +    ERRP_GUARD();
>> +
>> +    cpu = s390_cpu_addr2state(core_id);
>> +    if (!cpu) {
>> +        error_setg(errp, "Core-id %d does not exist!", core_id);
>> +        return;
>> +    }
>> +
>> +    /* Get attributes not provided from cpu and verify the new 
>> topology */
>> +    if (!has_socket_id) {
>> +        socket_id = cpu->env.socket_id;
>> +    }
>> +    if (!has_book_id) {
>> +        book_id = cpu->env.book_id;
>> +    }
>> +    if (!has_drawer_id) {
>> +        drawer_id = cpu->env.drawer_id;
>> +    }
>> +    if (!has_dedicated) {
>> +        dedicated = cpu->env.dedicated;
>> +    }
>> +
>> +    /*
>> +     * When the user specifies the entitlement as 'auto' on the 
>> command line,
>> +     * qemu will set the entitlement as:
>> +     * Medium when the CPU is not dedicated.
>> +     * High when dedicated is true.
>> +     */
>> +    if (!has_entitlement || (entitlement == 
>> S390_CPU_ENTITLEMENT_AUTO)) {
>> +        if (dedicated) {
>> +            entitlement = S390_CPU_ENTITLEMENT_HIGH;
>> +        } else {
>> +            entitlement = S390_CPU_ENTITLEMENT_MEDIUM;
>> +        }
>> +    }
>> +
>> +    if (!s390_topology_check(socket_id, book_id, drawer_id,
>> +                             entitlement, dedicated, errp))
>> +        return;
>
> Missing curly braces here.
> Not sure why this isn't caught by checkpatch.pl properly :-(
>
>  Thomas
>
Yes indeed.

I add the curly braces.

Thanks

Pierre

