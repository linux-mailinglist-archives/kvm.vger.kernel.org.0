Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02E9719CB5
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 14:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbjFAMzw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 08:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbjFAMzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 08:55:50 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126D9124;
        Thu,  1 Jun 2023 05:55:50 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351Ci90n012529;
        Thu, 1 Jun 2023 12:55:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=C6egMF+mMhH3bZjfGqBXjcTsk+9UgAOzyJwA8fzZ0RY=;
 b=ALoVdtYDQbU88wwmLIPPorZwc0WBMXgzRGdc/uwvCNJdyTTR9zY2ha+av+WVwAOamSW3
 6CPV+EiMxOOEczyPXDWJ5dlpa85TjcJFj2bFXlTfR8ipfKLLIA4usE71e7iuaw2XCrIs
 XUHjm86pZrUlmhvBJ0Coi8Mv2lrMF141Du2dvJVy0VL2SOKPjs/ftsvxJROiYRpBeEjD
 glFA+TJYGW/scQtsrP3IF2XP752r95aOgwmoJjCWfqN82mNL8dIo/1Y5vsW80Wu8jOix
 4vYIqY5Swoi9iJ+IS8ie8gej8Rq2IO7HDb3tRse+dJX8ZktjqRE06Wa1ybUsH5l98I14 tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxukd0cau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 12:55:49 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 351Cic2M013624;
        Thu, 1 Jun 2023 12:55:48 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxukd0c9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 12:55:48 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3514pPsf022818;
        Thu, 1 Jun 2023 12:55:46 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qu9g52hqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 12:55:46 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351Cth4Q19727050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 12:55:43 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0458920049;
        Thu,  1 Jun 2023 12:55:43 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 679A920040;
        Thu,  1 Jun 2023 12:55:42 +0000 (GMT)
Received: from [9.171.12.131] (unknown [9.171.12.131])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu,  1 Jun 2023 12:55:42 +0000 (GMT)
Message-ID: <5d0ddebd-22ab-f916-2339-5edc880e5001@linux.ibm.com>
Date:   Thu, 1 Jun 2023 14:55:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v3 2/2] s390x: sclp: Implement
 SCLP_RC_INSUFFICIENT_SCCB_LENGTH
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nsg@linux.ibm.com, cohuck@redhat.com
References: <20230530124056.18332-1-pmorel@linux.ibm.com>
 <20230530124056.18332-3-pmorel@linux.ibm.com>
 <3dc8e019-a3c1-8446-08ed-f76a9064f954@linux.ibm.com>
 <168562078341.164254.16306908045401776634@t14-nrb>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <168562078341.164254.16306908045401776634@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Q6rw-BdDljJ73KytWc12BhoEjTiQl0z9
X-Proofpoint-GUID: 4RIcQeOfppvNst0McMFk_tUTUeN-y-s5
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 impostorscore=0 suspectscore=0 mlxscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010111
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/1/23 13:59, Nico Boehr wrote:
> Quoting Janosch Frank (2023-06-01 10:03:06)
>> On 5/30/23 14:40, Pierre Morel wrote:
>>> If SCLP_CMDW_READ_SCP_INFO fails due to a short buffer, retry
>>> with a greater buffer.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Janosch, I think it makes sense if Pierre picks up Claudios suggestion from here:
> https://lore.kernel.org/all/20230530173544.378a63c6@p-imbrenda/
>
> Do you agree?

from my side:

It simplifies greatly the code and tested without problem.

The documentation says the SCCB length is "at least"... so we can use a 
greater size from the beginning.


