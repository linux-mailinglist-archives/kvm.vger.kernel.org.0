Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160766E76A1
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 11:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbjDSJrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 05:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbjDSJrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 05:47:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19673C2A
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 02:47:19 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33J8nwlc003102;
        Wed, 19 Apr 2023 09:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RP2lDcaD428ljz65dkcYl2KlrQZcaxT4Re8ARQ3vcaI=;
 b=IkHZBmWfVK4yYHx0FHaSxZn9TJopOrilfGLet3IXt7AW3Lm9PH8nCiUGLmoLC1si2LAJ
 PfdWmQAqEdl/+axYTEE2/GsC03LCkKVpSD2x4t4I7t5jihFZI3uo8cG61h8yvJ+JPJbH
 64pjwPSaaGEBDoB19fhu0E1SkGAsmFggTJaU612YNaGBSHEb+iLbOQSozzKLg5+yjegB
 uoUF2FnqIck2a9PGwWip/fLYV7YdXyIyMloi5yeezmp47Wl2qkDCN5jf2gBHlV2xeB99
 L1ealYtSNiKV6x9xLdAvLZAEerCeza9U267/92v8vgwqh0X+urU8AXMTLgP1fkoygVx2 Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q20emdbt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 09:47:10 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33J8Hx93002966;
        Wed, 19 Apr 2023 09:47:09 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q20emdbrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 09:47:09 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33J7bMQh006465;
        Wed, 19 Apr 2023 09:47:07 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pykj6am3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 09:47:07 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33J9l1iW13697612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 09:47:01 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8066220043;
        Wed, 19 Apr 2023 09:47:01 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 247BD20040;
        Wed, 19 Apr 2023 09:47:00 +0000 (GMT)
Received: from [9.171.77.152] (unknown [9.171.77.152])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 19 Apr 2023 09:47:00 +0000 (GMT)
Message-ID: <268273e6-f94b-d033-fb8b-ab2acdd923b8@linux.ibm.com>
Date:   Wed, 19 Apr 2023 11:46:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v19 01/21] s390x/cpu topology: add s390 specifics to CPU
 topology
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
 <20230403162905.17703-2-pmorel@linux.ibm.com>
 <4118bb4e-0505-26d3-3ffe-49245eae5364@kaod.org>
 <bd5cc488-20a7-54d1-7c3e-86136db77f84@linux.ibm.com>
 <ZD690MgTNAxcfkKp@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <ZD690MgTNAxcfkKp@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Hwg1ghZbUX2Erx9CSEV9xMgaE5Thngi1
X-Proofpoint-ORIG-GUID: dpI9WRVrQ2kpNl9FroxG1XqXZgLX9iDW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_05,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 phishscore=0
 mlxlogscore=806 adultscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190085
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/18/23 17:57, Daniel P. Berrangé wrote:
> On Tue, Apr 04, 2023 at 02:26:05PM +0200, Pierre Morel wrote:
>> On 4/4/23 09:03, Cédric Le Goater wrote:
>>> On 4/3/23 18:28, Pierre Morel wrote:
>>>> diff --git a/include/hw/s390x/cpu-topology.h
>>>> b/include/hw/s390x/cpu-topology.h
>>>> new file mode 100644
>>>> index 0000000000..83f31604cc
>>>> --- /dev/null
>>>> +++ b/include/hw/s390x/cpu-topology.h
>>>> @@ -0,0 +1,15 @@
>>>> +/*
>>>> + * CPU Topology
>>>> + *
>>>> + * Copyright IBM Corp. 2022
>>> Shouldn't we have some range : 2022-2023 ?
>> There was a discussion on this in the first spins, I think to remember that
>> Nina wanted 22 and Thomas 23,
>>
>> now we have a third opinion :) .
>>
>> I must say that all three have their reasons and I take what the majority
>> wants.
>>
>> A vote?
> Whether or not to include a single year, or range of years in
> the copyright statement is ultimately a policy decision for the
> copyright holder to take (IBM in this case I presume), and not
> subject to community vote/preferences.
>
> I will note that some (possibly even many) organizations consider
> the year to be largely redundant and devoid of legal benefit, so
> are happy with basically any usage of dates (first year, most recent
> year, a range of years, or none at all). With this in mind, QEMU is
> willing to accept any usage wrt dates in the copyright statement.
>
> It is possible that IBM have a specific policy their employees are
> expected to follow. If so, follow that.
>
> With regards,
> Daniel


OK, thanks,

Regards,

Pierre

