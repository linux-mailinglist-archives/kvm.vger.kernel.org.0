Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1930E68B9DE
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 11:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjBFKUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 05:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjBFKUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 05:20:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2911E1FA
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 02:20:09 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3169HqW9019630;
        Mon, 6 Feb 2023 10:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=D50LrmJ0+QXxCB1ZCm7pg3LBGT+YIgCXvZ+3OlHSMyA=;
 b=eUdD8GVC4Dm5wYHh6Nb0N/Zgt8VOx+0zR4tDZ+rosY2p7VomncQy4gukIRi2DSulxPSo
 GgKuh9k99kpsgX0mt/rVzHLztyUbu5GTTLjNkM3DRp45Qv5yt4VTq4irhjgVzaRCYdDA
 d9DgjjmbdEWV1p5ZLgCCSQs9jxwEwTdywF4Q1D/hy1XZd3Sl6nm86LgHTVEnaW4hjyIh
 5YFx/eag0Uzjq5lv1keLNHCo8/BlCYVQRF9WJL/pCDsMKJEdq9ZArYUYuawvIs4hoCdw
 uojM702PX2PSZIYL7eLeS4Nc6hfefh+VDqYZ5b7csCf3khl5OKDnH6NeCuZbxodXWzdw EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3njxsm9h8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 10:19:57 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 316AIJFF011837;
        Mon, 6 Feb 2023 10:19:56 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3njxsm9h7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 10:19:56 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31605Na2024259;
        Mon, 6 Feb 2023 10:19:54 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06t8yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 10:19:54 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 316AJp6h19792598
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Feb 2023 10:19:51 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 218D220078;
        Mon,  6 Feb 2023 10:19:51 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF58720076;
        Mon,  6 Feb 2023 10:19:49 +0000 (GMT)
Received: from [9.171.30.242] (unknown [9.171.30.242])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Feb 2023 10:19:49 +0000 (GMT)
Message-ID: <5d87c783-beef-133f-d18a-e96d671b25a5@linux.ibm.com>
Date:   Mon, 6 Feb 2023 11:19:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v15 04/11] s390x/sclp: reporting the maximum nested
 topology entries
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
 <20230201132051.126868-5-pmorel@linux.ibm.com>
 <dc19cfad-dfbb-b81a-1341-6a60df7f4968@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <dc19cfad-dfbb-b81a-1341-6a60df7f4968@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 20jTRJz9VtO_hwxyUByOQchAWd0tI1Hx
X-Proofpoint-ORIG-GUID: JpahCH56fMOoQbAcGk9OsZNxy5n_zhyr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_05,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 mlxlogscore=976 clxscore=1015 lowpriorityscore=0 spamscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302060087
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/6/23 11:13, Thomas Huth wrote:
> On 01/02/2023 14.20, Pierre Morel wrote:
>> The maximum nested topology entries is used by the guest to
>> know how many nested topology are available on the machine.
>>
>> Let change the MNEST value from 2 to 4 in the SCLP READ INFO
>> structure now that we support books and drawers.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>> ---
>>   include/hw/s390x/sclp.h | 5 +++--
>>   hw/s390x/sclp.c         | 5 +++++
>>   2 files changed, 8 insertions(+), 2 deletions(-)
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

Thanks,

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
