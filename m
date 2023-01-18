Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4B1672486
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 18:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjARRLH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 12:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjARRLE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 12:11:04 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA3D46089
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:11:03 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IFTLuG026711;
        Wed, 18 Jan 2023 17:10:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3OAPInVnFVZKsEiBtdIUSugEcvzC8D5M+HLlMZO9pfI=;
 b=PYjb2HmQt8ohNDHXuYEWF8AcRl+MY696aK1Y6N+TeIOqb1Wy8D3/QPs/NVlSpslfX70L
 3ULcITgcJ2XlJBD1gYTSKAnZm7HFpiOTJn0U/1PJzYSSTadfJowTQN+jAm1M37nJZ6iZ
 YlHTD8oj2dhrcG5ytuouKeCNp9FQbOEL4DReSzC5kGOcVFd/0QsarvOlY+W/egIfCfLa
 onXvnKdOPxf5HPTe6va/pxd7nZPROXNkg/MmaCDrk7YtyupAZrad4ed7ITygD2b1kn27
 0y05oouHYsSf9TN5sMgsfofEPxULGRcAJE1K6rA501LUajP6RnTw4bsEBaREah8l9vCV vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6f921fhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 17:10:57 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30IGlNeH030812;
        Wed, 18 Jan 2023 17:10:57 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6f921fgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 17:10:57 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30ICvqR9004659;
        Wed, 18 Jan 2023 17:10:55 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16nk8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 17:10:55 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IHApKA35324402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 17:10:51 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 667C52007D;
        Wed, 18 Jan 2023 17:10:51 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2696120040;
        Wed, 18 Jan 2023 17:10:50 +0000 (GMT)
Received: from [9.179.13.15] (unknown [9.179.13.15])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 17:10:50 +0000 (GMT)
Message-ID: <074a45e3-b465-f3aa-0187-57ab3f779912@linux.ibm.com>
Date:   Wed, 18 Jan 2023 18:10:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v14 11/11] docs/s390x/cpu topology: document s390x cpu
 topology
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-12-pmorel@linux.ibm.com> <Y7/17Yjblca57VT9@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <Y7/17Yjblca57VT9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -KHBjhBuOAcLX9Er-rIcLSrMNVpADD0X
X-Proofpoint-ORIG-GUID: LAn8uwC0nmOhbwiU1Y7-KRbMSl2lxm8x
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



On 1/12/23 12:58, Daniel P. Berrangé wrote:
> On Thu, Jan 05, 2023 at 03:53:13PM +0100, Pierre Morel wrote:
>> Add some basic examples for the definition of cpu topology
>> in s390x.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   docs/system/s390x/cpu-topology.rst | 292 +++++++++++++++++++++++++++++
>>   docs/system/target-s390x.rst       |   1 +
>>   2 files changed, 293 insertions(+)
>>   create mode 100644 docs/system/s390x/cpu-topology.rst
>>
>> diff --git a/docs/system/s390x/cpu-topology.rst b/docs/system/s390x/cpu-topology.rst
>> new file mode 100644
>> index 0000000000..0020b70b50
>> --- /dev/null
>> +++ b/docs/system/s390x/cpu-topology.rst
>> @@ -0,0 +1,292 @@
>> +CPU Topology on s390x
>> +=====================
>> +
>> +CPU Topology on S390x provides up to 5 levels of topology containers:
>> +nodes, drawers, books, sockets and CPUs.
> 
> The last level should be 'cores' not CPUs for QEMU terminology.

Yes, thanks.

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
