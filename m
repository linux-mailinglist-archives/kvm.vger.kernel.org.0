Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBB948E9CF
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 13:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241036AbiANM2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 07:28:30 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40740 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240922AbiANM23 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 07:28:29 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20ECRgw6026732;
        Fri, 14 Jan 2022 12:28:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=h1ZWGajXCQsbNAhXJuergdZ197qyGRf2pING2zKj05M=;
 b=EJ1ahvfEdFotEsQli3Ep/axe/ab7lTWDbVWGJ4d9kCDAtLOXBBR8KOp9GyKxDJIEXrj7
 bCVRR9A1ZKLKmD4CJLbyZnLw/40/7TDiUptQWNexwv2AroLAJUgoR9DeKHNpoMxTwej9
 uQOk1+Pg3W8M7bo9IbCDepzkoJ13AMd/pZUEz44qkuuZA60DnVBV6BtP4Ys7YoGqP+dZ
 YnPbLa4E7E/bMUvWIi9x3+q7nDQ9l6ggOHFghWp3oQOLkzvkpB9imWQGqcoqnR2iwbR8
 CnH+wI62rb6cLkn2+k9U/Y9BBvH9nuKPYmJ6AbwhP8PA0XhG+7O6EpPYchSB+u4fGMb6 Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk96y00j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 12:28:28 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20ECSSX4028871;
        Fri, 14 Jan 2022 12:28:28 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dk96y00hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 12:28:28 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ECRTWL025460;
        Fri, 14 Jan 2022 12:28:26 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3df28a39a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 12:28:26 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20ECSKsl20578810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 12:28:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E36752057;
        Fri, 14 Jan 2022 12:28:20 +0000 (GMT)
Received: from [9.145.160.142] (unknown [9.145.160.142])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 51D4352052;
        Fri, 14 Jan 2022 12:28:20 +0000 (GMT)
Message-ID: <380e04e5-b487-36cf-a6f2-143b01c070ff@linux.ibm.com>
Date:   Fri, 14 Jan 2022 13:28:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH 1/5] lib: s390x: vm: Add kvm and lpar vm
 queries
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, nrb@linux.ibm.com
References: <20220114100245.8643-1-frankja@linux.ibm.com>
 <20220114100245.8643-2-frankja@linux.ibm.com>
 <20220114121830.0f6c4908@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220114121830.0f6c4908@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9xqSTZMBrFicpxcUh0PrSkxtrD-KORcZ
X-Proofpoint-ORIG-GUID: wd6_qh9XUt4cLXz7O7x-4TdPJX47J6WJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/14/22 12:18, Claudio Imbrenda wrote:
> On Fri, 14 Jan 2022 10:02:41 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> This patch will likely (in parts) be replaced by Pierre's patch from
>> his topology test series.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
> although I think there is some room for improvement, but nothing too
> serious, I'll probably fix it myself later

I think I should add this to clean up the checks in the following patches:

bool vm_is_qemu(void)
{
	return vm_is_kvm() || vm_is_tcg();
}

That of course also isn't a 100% correct, we could have KVM + non-QEMU 
but I'll cross that bridge when I get there.

And as I already mentioned in Pierre's patch, the STSI values are a bit 
of a mystery to me since AFAIK we store KVM/Linux even if we run under TCG.

> 
>> ---
>>   lib/s390x/vm.c | 39 +++++++++++++++++++++++++++++++++++++++
>>   lib/s390x/vm.h | 23 +++++++++++++++++++++++
>>   s390x/stsi.c   | 21 +--------------------
>>   3 files changed, 63 insertions(+), 20 deletions(-)
>>
>> diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
>> index a5b92863..266a81c1 100644
>> --- a/lib/s390x/vm.c
>> +++ b/lib/s390x/vm.c
>> @@ -26,6 +26,11 @@ bool vm_is_tcg(void)
>>   	if (initialized)
>>   		return is_tcg;
>>   
>> +	if (stsi_get_fc() < 3) {
>> +		initialized = true;
>> +		return false;
>> +	}
>> +
>>   	buf = alloc_page();
>>   	if (!buf)
>>   		return false;
>> @@ -43,3 +48,37 @@ out:
>>   	free_page(buf);
>>   	return is_tcg;
>>   }
>> +
>> +bool vm_is_kvm(void)
>> +{
>> +	const uint8_t cpi_kvm[] = { 0xd2, 0xe5, 0xd4, 0x61 };
>> +	struct stsi_322 *buf;
>> +	static bool initialized = false;
>> +	static bool is_kvm = false;
>> +
>> +	if (initialized)
>> +		return is_kvm;
>> +
>> +	if (stsi_get_fc() < 3) {
>> +		initialized = true;
>> +		return false;
>> +	}
>> +
>> +	buf = alloc_page();
>> +	if (!buf)
>> +		return false;
>> +
>> +	if (stsi(buf, 3, 2, 2))
>> +		goto out;
>> +
>> +	is_kvm = !(memcmp(&buf->vm[0].cpi, cpi_kvm, sizeof(cpi_kvm))) && !vm_is_tcg();
>> +	initialized = true;
>> +out:
>> +	free_page(buf);
>> +	return is_kvm;
>> +}
>> +
>> +bool vm_is_lpar(void)
>> +{
>> +	return stsi_get_fc() == 1;
>> +}
>> diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
>> index 7abba0cc..d4a82fc0 100644
>> --- a/lib/s390x/vm.h
>> +++ b/lib/s390x/vm.h
>> @@ -8,6 +8,29 @@
>>   #ifndef _S390X_VM_H_
>>   #define _S390X_VM_H_
>>   
>> +struct stsi_322 {
>> +	uint8_t reserved[31];
>> +	uint8_t count;
>> +	struct {
>> +		uint8_t reserved2[4];
>> +		uint16_t total_cpus;
>> +		uint16_t conf_cpus;
>> +		uint16_t standby_cpus;
>> +		uint16_t reserved_cpus;
>> +		uint8_t name[8];
>> +		uint32_t caf;
>> +		uint8_t cpi[16];
>> +		uint8_t reserved5[3];
>> +		uint8_t ext_name_encoding;
>> +		uint32_t reserved3;
>> +		uint8_t uuid[16];
>> +	} vm[8];
>> +	uint8_t reserved4[1504];
>> +	uint8_t ext_names[8][256];
>> +};
>> +
>>   bool vm_is_tcg(void);
>> +bool vm_is_kvm(void);
>> +bool vm_is_lpar(void);
>>   
>>   #endif  /* _S390X_VM_H_ */
>> diff --git a/s390x/stsi.c b/s390x/stsi.c
>> index 391f8849..e66d07a1 100644
>> --- a/s390x/stsi.c
>> +++ b/s390x/stsi.c
>> @@ -13,27 +13,8 @@
>>   #include <asm/asm-offsets.h>
>>   #include <asm/interrupt.h>
>>   #include <smp.h>
>> +#include <vm.h>
>>   
>> -struct stsi_322 {
>> -	uint8_t reserved[31];
>> -	uint8_t count;
>> -	struct {
>> -		uint8_t reserved2[4];
>> -		uint16_t total_cpus;
>> -		uint16_t conf_cpus;
>> -		uint16_t standby_cpus;
>> -		uint16_t reserved_cpus;
>> -		uint8_t name[8];
>> -		uint32_t caf;
>> -		uint8_t cpi[16];
>> -		uint8_t reserved5[3];
>> -		uint8_t ext_name_encoding;
>> -		uint32_t reserved3;
>> -		uint8_t uuid[16];
>> -	} vm[8];
>> -	uint8_t reserved4[1504];
>> -	uint8_t ext_names[8][256];
>> -};
>>   static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
>>   
>>   static void test_specs(void)
> 

