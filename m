Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4AE336FFB
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 11:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbhCKK1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 05:27:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22946 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232254AbhCKK0p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Mar 2021 05:26:45 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12BA57Kn158053
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 05:26:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vJt86cW6sNaCtfgAaQ8N5FGliw1/2LAVGdGGzX+Oahk=;
 b=LtcML58gqJn/HxRo9PMoK2rlagyI8uuqemoGehxMPqPA2apLfmDkpxScNvdtG/PcEWng
 u7J5deCVLd03dK26adeDMonZSpgm8GExfJsTuJzkM3pSoWI3XYfYzNiR0td3R3oJFO0x
 mxLnO6aHhSBUOzRfJoRnqjPnT0M3njTutqE0IddI1fNZL4TW8S6bsfP94+Ea2JBIZvnZ
 ubqXOz7rY6pzDx4MPo6dJctzCetTn5WH25xHtXd4cXn3MpMBRq+FL6KGmHMCgrBVNNLO
 Gt9HVCC1xgOTsYnzCTLLvogLvu6I5V34/J0jfxrUo8v/Hm6Cx73WnJmleo+75vNGxKLZ KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3774m8tqxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 05:26:44 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12BA55Mg157930
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 05:26:44 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3774m8tqxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 05:26:44 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12BAMJVt006623;
        Thu, 11 Mar 2021 10:26:42 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 376mb0s94h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 10:26:42 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12BAQd8P45154712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 10:26:39 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4C0E11C052;
        Thu, 11 Mar 2021 10:26:39 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6642E11C04C;
        Thu, 11 Mar 2021 10:26:39 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.87.106])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Mar 2021 10:26:39 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 6/6] s390x: css: testing measurement
 block format 1
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
 <1615294277-7332-7-git-send-email-pmorel@linux.ibm.com>
 <20210309180726.29e4784e.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <079ba886-c32a-bc3f-fdb0-b15fca940fb5@linux.ibm.com>
Date:   Thu, 11 Mar 2021 11:26:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210309180726.29e4784e.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_04:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103110053
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/9/21 6:07 PM, Cornelia Huck wrote:
> On Tue,  9 Mar 2021 13:51:17 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> Measurement block format 1 is made available by the extended
>> measurement block facility and is indicated in the SCHIB by
>> the bit in the PMCW.
>>
>> The MBO is specified in the SCHIB of each channel and the MBO
>> defined by the SCHM instruction is ignored.
>>
>> The test of the MB format 1 is just skipped if the feature is
>> not available.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     | 15 +++++++++
>>   lib/s390x/css_lib.c |  2 +-
>>   s390x/css.c         | 75 +++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 91 insertions(+), 1 deletion(-)
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
