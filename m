Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF266CAB76
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 19:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbjC0REt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 13:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbjC0REZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 13:04:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5454EDD;
        Mon, 27 Mar 2023 10:03:05 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32RGXlOt027487;
        Mon, 27 Mar 2023 17:02:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=39nUZoNj6O6EPcS8uOpK6NKOvJfcEEWIpB5tm/VgX5s=;
 b=NXjVWL40NMWySHHq9xXys61BPL92YaYLn2WR0KZR4dCUgLfsboK57pWB9r5zKADe0mso
 VI0Rsw2HSf7k7h/M7cClN5gTZhaR45xP+o6OlPVJpdvnFpsia5KwkUsMPcryA6v6oktG
 zKLXVtzDLWATFKQRLq6pNheTV53EKW/GZA/1Sg9SjB10Bud1bBHLw61WzUSjNz8xDMkS
 UlYcXirkAnWOOtXXk7522ZSQaVJpH+OTrDUy1UV97E0whdJH4EEmy+jNhB5QmY9ZMHEE
 G9K3C1EcVzTE4zB48x4FgtpyGw0PfFLshcJIm2tcCRSlvawG5An2lvsBNrfcVH3phHSu pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pkes88k7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 17:02:48 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32RGlCPr026309;
        Mon, 27 Mar 2023 17:02:48 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pkes88k77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 17:02:47 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32RCK3f8017796;
        Mon, 27 Mar 2023 17:02:46 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3phrk6jmb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Mar 2023 17:02:46 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32RH2g9H24445440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 17:02:42 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7262020043;
        Mon, 27 Mar 2023 17:02:42 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02A5D20040;
        Mon, 27 Mar 2023 17:02:42 +0000 (GMT)
Received: from [9.171.92.86] (unknown [9.171.92.86])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon, 27 Mar 2023 17:02:41 +0000 (GMT)
Message-ID: <a690162f-75cc-5476-da58-eb746522ee24@linux.ibm.com>
Date:   Mon, 27 Mar 2023 19:02:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v7 2/2] s390x: topology: Checking
 Configuration Topology Information
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
References: <20230320085642.12251-1-pmorel@linux.ibm.com>
 <20230320085642.12251-3-pmorel@linux.ibm.com>
 <167965555147.41638.10047922188597254104@t14-nrb>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <167965555147.41638.10047922188597254104@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Yc-knorfrmp3e-MkEW_Y76NeoXNKfTkT
X-Proofpoint-GUID: K2txiyhX-FxrDojLAzMkEHClqdYGieP1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303270133
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/24/23 11:59, Nico Boehr wrote:
> Quoting Pierre Morel (2023-03-20 09:56:42)

[...]


>
>> + * check_tle:
>> + * @tc: pointer to first TLE
>> + *
>> + * Recursively check the containers TLEs until we
>> + * find a CPU TLE.
>> + */
>> +static uint8_t *check_tle(void *tc)
>> +{
> [...]
>> +       report(!cpus->d || (cpus->pp == 3 || cpus->pp == 0),
>> +              "Dedication versus entitlement");
> Maybe skip here if the CPU is not dedicated? With shared CPUs we really can't check much here.

Thinking more about this I think I will not change this but I better will
make two check one for horizontal and once for vertical polarization.



