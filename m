Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17FF5507206
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 17:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353968AbiDSPoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 11:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiDSPoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 11:44:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872CF17E36
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 08:41:36 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JDxdRM022409;
        Tue, 19 Apr 2022 15:41:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=CDgpDWylpxfB/DnjSv4bCSomF1sVUlxIC/2CRNvHI8Y=;
 b=onFhzAm5UgY+dKGJO+9S/eLI84pKPAk3pUbUTy2Nz4csWEMQuFwuDXThiWYCWbRYt0Cd
 iQi3XBEvI2G3aa5B4TMpPmXnap8y0WBorhdbHVgNzL5ckyRAVYKZ7B22MhuMpinlWG21
 AqWc2ItYFkvNR/uz6YzjbU47rT+NJSP45M+HRFekAKSlr0rJx4bAF8CW53KXzDhnkwjj
 JJ9sclesbmGmu+2Qqu5b1ALpEiEnGKFkpRrXxrShj1L+z7Nn/JGhXO5C1nxD0NaWMtHG
 To4cd65rsMcRiQh/Zkt78KtNyD9tTFSCCJ9iuuL4iMaCdaLkOgFMnpsKpFIIywY0vD2O lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fg75qkth5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 15:41:30 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23JFcEej021128;
        Tue, 19 Apr 2022 15:41:30 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fg75qktg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 15:41:30 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23JFVoPk030649;
        Tue, 19 Apr 2022 15:41:28 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3ffvt9bb7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 15:41:28 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23JFfPDf28836288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 15:41:25 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26A8C4204C;
        Tue, 19 Apr 2022 15:41:25 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C6F84203F;
        Tue, 19 Apr 2022 15:41:24 +0000 (GMT)
Received: from [9.171.88.57] (unknown [9.171.88.57])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Apr 2022 15:41:24 +0000 (GMT)
Message-ID: <42de52f6-e6b0-7461-74c5-f371d5af93a1@linux.ibm.com>
Date:   Tue, 19 Apr 2022 17:44:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 2/9] vfio: tolerate migration protocol v1 uapi renames
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     farman@linux.ibm.com, kvm@vger.kernel.org, schnelle@linux.ibm.com,
        cohuck@redhat.com, richard.henderson@linaro.org, thuth@redhat.com,
        qemu-devel@nongnu.org, pasic@linux.ibm.com,
        alex.williamson@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        david@redhat.com, borntraeger@linux.ibm.com
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-3-mjrosato@linux.ibm.com>
 <ed4889b8-28c4-a3ed-b5ef-add3999023d4@linux.ibm.com>
 <791ee8c8-a2f4-6644-7155-3bacdb3c4074@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <791ee8c8-a2f4-6644-7155-3bacdb3c4074@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Omn3-pYB5R2Jh2chb-qt9E3DETsbxMiU
X-Proofpoint-GUID: MMDybLp6y6R3X4mHDrUbMi4Tbw0KYy27
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-19_05,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 mlxlogscore=993 spamscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204190088
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/12/22 18:07, Matthew Rosato wrote:
> On 4/12/22 11:50 AM, Pierre Morel wrote:
>>
>>
>> On 4/4/22 20:17, Matthew Rosato wrote:
>>> The v1 uapi is deprecated and will be replaced by v2 at some point;
>>> this patch just tolerates the renaming of uapi fields to reflect
>>> v1 / deprecated status.
>>>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>>>   hw/vfio/common.c    |  2 +-
>>>   hw/vfio/migration.c | 19 +++++++++++--------
>>>   2 files changed, 12 insertions(+), 9 deletions(-)
>>
>>
>> I do not understand why you need this patch in this series.
>> Shouldn't it be separate?
> 
> This patch is included because of the patch 1 kernel header sync, which 
> pulls in uapi headers from kernel version 5.18-rc1 + my unmerged kernel 
> uapi changes.
> 
> This patch is unnecessary without a header sync (and in fact would break 
> QEMU compile), and is unrelated to the rest of the series -- but QEMU 
> will not compile without it once you update linux uapi headers to 
> 5.18-rc1 (or greater) due to the v1 uapi for vfio migration being 
> deprecated [1].  This means that ANY series that does a linux header 
> sync starting from here on will need something like this patch to go 
> along with the header sync (or a series that replaces v1 usage with v2?).
> 
> If this patch looks good it could be included whenever a header sync is 
> next needed, doesn't necessarily have to be with this series.
> 
> [1] https://www.spinics.net/lists/kernel/msg4288200.html
> 

arrg, seems I will need it too then.
Thanks,

Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
