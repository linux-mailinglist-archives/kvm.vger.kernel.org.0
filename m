Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADDD490B13
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 16:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240329AbiAQPD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 10:03:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50018 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240304AbiAQPD4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 10:03:56 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HEK3Co010380;
        Mon, 17 Jan 2022 15:03:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/E3Goe4+VaKpv1ylPScDepE8ToBPeMKqZspQF6YeMjc=;
 b=JvBrdhnyrxcwzRiVxzZHOPDX+fxA1GSEoNV2wU044H22POzkyE6K2jTTHarz10qGcCnD
 bUKTeJfiG9347qSs4w4tpUVmhWzGDndHeDk/malc25i3Q33bhcVEpoc4N2A4pKe/K0N8
 9c8V8n+ulNfT7Ja5IL0VdLEYWeiIR56iceQUjQD6zaHgBRt766BdBleXIUNcjXlbAIKK
 VxYq97GivP+Z9oF9aUZyMPOxAVWX9DoEFU+s43bIgKHieyVxV1y4wGirYExCIg8dhcH/
 krQ0AN3pAI+voS9Vm8HZQYgOqnvHCgKEdWHUZTCVq4YR5drQm5YICvt/HkUosJJMIs3d Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dn7krv5sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 15:03:53 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HEbn0g030404;
        Mon, 17 Jan 2022 15:03:53 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dn7krv5rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 15:03:53 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HF2rVR007232;
        Mon, 17 Jan 2022 15:03:51 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3dknw94d7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 15:03:51 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HF3iwm40960420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 15:03:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D6244C04A;
        Mon, 17 Jan 2022 15:03:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 166D74C040;
        Mon, 17 Jan 2022 15:03:44 +0000 (GMT)
Received: from [9.171.80.201] (unknown [9.171.80.201])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 15:03:43 +0000 (GMT)
Message-ID: <cc221aec-838c-c710-fe41-c523cc2fd787@linux.ibm.com>
Date:   Mon, 17 Jan 2022 16:05:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v3 2/4] s390x: stsi: Define vm_is_kvm to be
 used in different tests
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        david@redhat.com
References: <20220110133755.22238-1-pmorel@linux.ibm.com>
 <20220110133755.22238-3-pmorel@linux.ibm.com>
 <20220111140811.2a7f49c2@p-imbrenda>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220111140811.2a7f49c2@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uU5GboWXR-BVwC8rI-EW_l5k1hYzorf2
X-Proofpoint-GUID: NIhH5VKaF1fs684XYLKT1xlz6AvmgLxF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 spamscore=0 impostorscore=0 bulkscore=0 mlxscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201170093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/11/22 14:08, Claudio Imbrenda wrote:
> On Mon, 10 Jan 2022 14:37:53 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We need in several tests to check if the VM we are running in
>> is KVM.
>> Let's add the test.
>>
>> To check the VM type we use the STSI 3.2.2 instruction, let's
>> define it's response structure in a central header.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/stsi.h | 32 ++++++++++++++++++++++++++++++++
>>   lib/s390x/vm.c   | 39 +++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/vm.h   |  1 +
>>   s390x/stsi.c     | 23 ++---------------------
>>   4 files changed, 74 insertions(+), 21 deletions(-)
>>   create mode 100644 lib/s390x/stsi.h
>>
>> diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
>> new file mode 100644
>> index 00000000..02cc94a6
>> --- /dev/null
>> +++ b/lib/s390x/stsi.h
>> @@ -0,0 +1,32 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +/*
>> + * Structures used to Store System Information
>> + *
>> + * Copyright (c) 2021 IBM Inc
> 
> Copyright IBM Corp. 2021

OK

> 
>> + */
>> +
>> +#ifndef _S390X_STSI_H_
>> +#define _S390X_STSI_H_
> 
> [...]
> 
>> +
>> +/**
>> + * Detect whether we are running with KVM
>> + */
>> +
>> +bool vm_is_kvm(void)
>> +{
>> +	/* EBCDIC for "KVM/" */
>> +	const uint8_t kvm_ebcdic[] = { 0xd2, 0xe5, 0xd4, 0x61 };
>> +	static bool initialized;
>> +	static bool is_kvm;
>> +	struct sysinfo_3_2_2 *stsi_322;
>> +
>> +	if (initialized)
>> +		return is_kvm;
>> +
>> +	if (stsi_get_fc() < 3) {
>> +		initialized = true;
>> +		return is_kvm;
>> +	}
>> +
>> +	stsi_322 = alloc_page();
>> +	if (!stsi_322)
>> +		return false;
> 
> I don't like returning false if the allocation fails.
> The allocation should not fail: assert(stsi_322);

OK, right.

> 
>> +
>> +	if (stsi(stsi_322, 3, 2, 2))
>> +		goto out;
>> +

Thanks for the review,

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
