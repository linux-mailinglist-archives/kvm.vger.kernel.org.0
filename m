Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B66490B24
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 16:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240430AbiAQPGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 10:06:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4032 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240401AbiAQPGE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 10:06:04 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HDw1Fi028630;
        Mon, 17 Jan 2022 15:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/M3GOBw3RpA4RhYZMHohcKKbS0ryG2KKvwytJ6MHYIA=;
 b=PoOHwnPm3XeZK416fqNUFjOHFBdgZKazoA8Z3c+v2hQWSNiWrNTQpwfdDh49dqvRxaQp
 IkBoxDpqA/vgA1wq5sldTeJq0QXNvhee7wNFLQ0F02MhzpGIrP59eu+d+OI3H+cfM7NL
 8puXR00G3i7fKyClpeHUuaKxPEGXa/Q0IujfsI+62YTMiDGMXlgwlQsBotTMa7byHjpg
 5ImiZ2ccFai0bIGJFqn+7HMtjnw9osK45MOvJIfHpeQWwGsKc/pMEGB4BtrEVA4PeXAw
 mJsoEsmTOFx3Et5sRKr5ulFd5vbv0xYoGBMwIgPpWfcxmplJ6xpsAdB5rzz77mwiBojJ WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dn9t41bjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 15:06:02 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HEtmYY025711;
        Mon, 17 Jan 2022 15:06:01 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dn9t41bhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 15:06:01 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HF3k58017917;
        Mon, 17 Jan 2022 15:05:59 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3dknw94cfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 15:05:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HF5vu030867922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 15:05:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE92A4C050;
        Mon, 17 Jan 2022 15:05:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AFA54C044;
        Mon, 17 Jan 2022 15:05:56 +0000 (GMT)
Received: from [9.171.80.201] (unknown [9.171.80.201])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 15:05:56 +0000 (GMT)
Message-ID: <32ac01d4-a662-57bd-42ce-5feba4e03ede@linux.ibm.com>
Date:   Mon, 17 Jan 2022 16:07:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v3 3/4] s390x: topology: Check the Perform
 Topology Function
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        david@redhat.com
References: <20220110133755.22238-1-pmorel@linux.ibm.com>
 <20220110133755.22238-4-pmorel@linux.ibm.com>
 <20220111122526.60e31b38@p-imbrenda>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220111122526.60e31b38@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wc-MBZZlcl_q-EP-BgGLnr7pwRg7lzkh
X-Proofpoint-ORIG-GUID: y0MpG6dQvC0tzp9A8uSmFe2opSAIEAaL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201170093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/11/22 12:25, Claudio Imbrenda wrote:
> On Mon, 10 Jan 2022 14:37:54 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We check the PTF instruction.
>>
>> - We do not expect to support vertical polarization.
>>
>> - We do not expect the Modified Topology Change Report to be
>> pending or not at the moment the first PTF instruction with
>> PTF_CHECK function code is done as some code already did run
>> a polarization change may have occur.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/Makefile      |   1 +
>>   s390x/topology.c    | 115 ++++++++++++++++++++++++++++++++++++++++++++
>>   s390x/unittests.cfg |   3 ++
>>   3 files changed, 119 insertions(+)
>>   create mode 100644 s390x/topology.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 1e567c11..fa21a882 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -26,6 +26,7 @@ tests += $(TEST_DIR)/edat.elf
>>   tests += $(TEST_DIR)/mvpg-sie.elf
>>   tests += $(TEST_DIR)/spec_ex-sie.elf
>>   tests += $(TEST_DIR)/firq.elf
>> +tests += $(TEST_DIR)/topology.elf
>>   
>>   tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>   ifneq ($(HOST_KEY_DOCUMENT),)
>> diff --git a/s390x/topology.c b/s390x/topology.c
>> new file mode 100644
>> index 00000000..a227555e
>> --- /dev/null
>> +++ b/s390x/topology.c
>> @@ -0,0 +1,115 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * CPU Topology
>> + *
>> + * Copyright (c) 2021 IBM Corp
> 
> Copyright IBM Corp. 2021

Yes thanks
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
