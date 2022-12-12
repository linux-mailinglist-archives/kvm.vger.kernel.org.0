Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBA8649AD6
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 10:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbiLLJOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 04:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiLLJOV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 04:14:21 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BEEBC7
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 01:14:21 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BC8aObn011919;
        Mon, 12 Dec 2022 09:14:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=V+9NWyHp0YR7Vft4N598qp4U5k4jJ2MbDcKXiy+CeIA=;
 b=rYJzUj+8aRxmZ+vHfSQ3cDD6xUuAKcBRsozmxJTriRFwXseL48I4iYUpCmGo7O4N3nY3
 pWKU7GMVCfea4mnx8ElJ4lYCWDzDXSXZyW2QRu+nb95ZduicBgqAj8oDNdNUnVZ5BU4B
 Gp5ls2OHSl480wCUI7o7Ub64IkQvu0wIysVDXh8gj04i10k79F0wf9OpmAT/8iRrbIMS
 ek51JWjTCfhSsF5y1OU68E9QV8c5lOv5+KpIulIkmDU6i5QdqQvWJyuwstaHyGuNn7by
 VTgouOS8zmzvySfZbn4Njduv+e8SGAqqUrYeWnRnjKlUjjQxDErETvbmTcSm64gsVGaD sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md3vcc7u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 09:14:09 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BC8i30F010721;
        Mon, 12 Dec 2022 09:14:08 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md3vcc7t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 09:14:08 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BBA1mcA018218;
        Mon, 12 Dec 2022 09:14:06 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3mchr61q79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Dec 2022 09:14:05 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BC9E2O844958092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 09:14:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 478E920040;
        Mon, 12 Dec 2022 09:14:02 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE3D32004B;
        Mon, 12 Dec 2022 09:14:00 +0000 (GMT)
Received: from [9.171.10.222] (unknown [9.171.10.222])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 12 Dec 2022 09:14:00 +0000 (GMT)
Message-ID: <68f2cc41-49d8-495c-f738-6bf87290eedb@linux.ibm.com>
Date:   Mon, 12 Dec 2022 10:14:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v13 4/7] s390x/cpu_topology: CPU topology migration
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
 <20221208094432.9732-5-pmorel@linux.ibm.com>
 <69575e36-224a-c611-d446-fc7133586505@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <69575e36-224a-c611-d446-fc7133586505@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rw48KHsmZGGidP36HahiUML_LAp1SNtO
X-Proofpoint-ORIG-GUID: dVPBnUERJUD8ReyYUj6ez5nrLZ-UVMoU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 phishscore=0 suspectscore=0 mlxlogscore=866 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212120084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/9/22 15:56, Cédric Le Goater wrote:
> On 12/8/22 10:44, Pierre Morel wrote:
>> The migration can only take place if both source and destination
>> of the migration both use or both do not use the CPU topology
>> facility.
>>
>> We indicate a change in topology during migration postload for the
>> case the topology changed between source and destination.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>


>> +
>> +const VMStateDescription vmstate_cpu_topology = {
>> +    .name = "cpu_topology",
>> +    .version_id = 1,
>> +    .post_load = cpu_topology_postload,
> 
> Please use 'cpu_topology_post_load', it is easier to catch with a grep.
> 

OK

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
