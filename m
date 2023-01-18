Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9C1672482
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 18:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjARRKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 12:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbjARRJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 12:09:49 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8A458955
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:09:44 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IFUYf5026589;
        Wed, 18 Jan 2023 17:09:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CVHD7uN5kegd1v4Zh1Lrrv2xOsjFVDLOQA3MRMm00TY=;
 b=b07L5ZoqJZcGb09SQrpvcscl+/yniQ8en7S8D9pd/Y0S8hDRmI+bxwkImYjd0N2HyOwm
 7nrE6GOQkaArOXldppjjLoKfyiiwEnSYyqwOWEMpCqTzavVBuwFpLBkLveUmgM1/SIZp
 TnMKKmIDgEyDUnEEDQ7WN0IyPaYV/PGGjoGC1l1XQu9mJGwYnBZsvTmkQC26Y7uE6DbR
 u3msznHvo5f4RQjge9vEpLTML/QU/NtzXZWe7Ct7JuiI76VMqxXhKKHmExf0IYVWrIqw
 EqLEy/n5sOECztcDsUguWTyBy3QFsETIstEC3Q2owRrj9pplkfMDPkzhjyLvMS7XW0R3 IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6f921ebd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 17:09:28 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30IGXLKv008988;
        Wed, 18 Jan 2023 17:09:27 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6f921ea7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 17:09:27 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30IDr6fi004723;
        Wed, 18 Jan 2023 17:09:25 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16nk6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 17:09:25 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IH9LxC43712802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 17:09:22 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D601920040;
        Wed, 18 Jan 2023 17:09:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 976AA20043;
        Wed, 18 Jan 2023 17:09:20 +0000 (GMT)
Received: from [9.179.13.15] (unknown [9.179.13.15])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 17:09:20 +0000 (GMT)
Message-ID: <5f177a1b-90d6-7e30-5b58-cdcae7919363@linux.ibm.com>
Date:   Wed, 18 Jan 2023 18:09:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 10/11] qapi/s390/cpu topology: POLARITY_CHANGE qapi
 event
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-11-pmorel@linux.ibm.com>
 <c338245c-82c3-ed57-9c98-f4d630fa1759@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <c338245c-82c3-ed57-9c98-f4d630fa1759@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YRriPyEL2JGDXCQRcohWX2TqfoQA4L-U
X-Proofpoint-ORIG-GUID: CJjn9xIY4hvcO_S-4vVKpWpi46C5CSbQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301180143
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/12/23 12:52, Thomas Huth wrote:
> On 05/01/2023 15.53, Pierre Morel wrote:
>> When the guest asks to change the polarity this change
>> is forwarded to the admin using QAPI.
>> The admin is supposed to take according decisions concerning
>> CPU provisioning.
> 
> I somehow doubt that an average admin will monitor QEMU for such events 
> ... so this rather should be handled by upper layers like libvirt one day?

Yes.

> 
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   qapi/machine-target.json | 21 +++++++++++++++++++++
>>   hw/s390x/cpu-topology.c  |  2 ++
>>   2 files changed, 23 insertions(+)
>>
>> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
>> index 927618a78f..10235cfb45 100644
>> --- a/qapi/machine-target.json
>> +++ b/qapi/machine-target.json
>> @@ -437,3 +437,24 @@
>>     'returns': ['S390CpuTopology'],
>>     'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
>>   }
>> +
>> +##
>> +# @POLARITY_CHANGE:
> 
> I'd maybe rather call it CPU_POLARITY_CHANGE ... in case "polarity" is 
> one day also used for some other devices.

OK, right.

> 
>> +#
>> +# Emitted when the guest asks to change the polarity.
>> +#
>> +# @polarity: polarity specified by the guest
> 
> Please elaborate: Where does the value come from (the PTF instruction)? 
> Which values are possible?

Yes what about:

# @polarity: the guest can specify with the PTF instruction a horizontal
#            or a vertical polarity.
#	     On horizontal polarity the host is expected to provision
#            the vCPU equally.
#            On vertical polarity the host can provision each vCPU
#            differently
#            The guest can get information on the provisioning with
#            the STSI(15) instruction.


Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
