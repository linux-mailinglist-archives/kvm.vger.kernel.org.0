Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3CB2C843F
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 13:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgK3Mnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 07:43:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10902 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbgK3Mnb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 07:43:31 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUCZmpT066079;
        Mon, 30 Nov 2020 07:42:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ei39xPZEfz2zjIdgNxAJpidokXFvDuN5d2aF4wQPKU0=;
 b=DsBeDtpJzLE1jyr1JcYalZ/cLXT4VbGfdBks8aBGbvqPGW1dUp2scuxYaxOaiwvM4Fpj
 jfq4edBCA9TiPzVa2fjWVJzXvqwj9EwaAa7sTD6zRzuTIoJIxJFdDJGk7tKLhXIJ2EK+
 TTUcaIFV8Z4CwH3wiPUbWSFi//pHFhJ00qAfMnVoTdr7idIAIp/p53V+5VZ2pe1dE48l
 X32Taa4qlysrysF4jmnL0tFmyl0YXmIy8jetRgSa0Jr06C9s8/2FTzOfQXR6ETJFo18g
 359W7pAXIx3SP+FO6ih7qITR85WdaqxPOCUFDSF87ie2QDzXPj710/w1qGzMz8RhW5kZ dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 354xctcufu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 07:42:51 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AUCZsb5066473;
        Mon, 30 Nov 2020 07:42:50 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 354xctcuf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 07:42:50 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AUCXDRx008063;
        Mon, 30 Nov 2020 12:42:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 353e6891ks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 12:42:48 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AUCgjSs55050694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 12:42:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66250A405C;
        Mon, 30 Nov 2020 12:42:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07727A405B;
        Mon, 30 Nov 2020 12:42:45 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.29.252])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 Nov 2020 12:42:44 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 5/7] s390x: sie: Add first SIE test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org
References: <20201127130629.120469-1-frankja@linux.ibm.com>
 <20201127130629.120469-6-frankja@linux.ibm.com>
 <20201130114532.6fea10ac.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <e312e141-5cee-9e4d-9e2c-d4770e77473d@linux.ibm.com>
Date:   Mon, 30 Nov 2020 13:42:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201130114532.6fea10ac.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_03:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/20 11:45 AM, Cornelia Huck wrote:
> On Fri, 27 Nov 2020 08:06:27 -0500
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Let's check if we get the correct interception data on a few
>> diags. This commit is more of an addition of boilerplate code than a
>> real test.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/Makefile      |   1 +
>>  s390x/sie.c         | 125 ++++++++++++++++++++++++++++++++++++++++++++
>>  s390x/unittests.cfg |   3 ++
>>  3 files changed, 129 insertions(+)
>>  create mode 100644 s390x/sie.c
>>
> 
> (...)
> 
>> +static void sie(struct vm *vm)
>> +{
>> +	while (vm->sblk->icptcode == 0) {
>> +		sie64a(vm->sblk, &vm->save_area);
>> +		if (vm->sblk->icptcode == 32)
> 
> Can you maybe add #defines for the intercept codes you're checking for?

Sure ICTP_VALIDITY and ICPT_INSTRUCTION would make sense.

> 
>> +		    handle_validity(vm);
>> +	}
>> +	vm->save_area.guest.grs[14] = vm->sblk->gg14;
>> +	vm->save_area.guest.grs[15] = vm->sblk->gg15;
>> +}
>> +
>> +static void sblk_cleanup(struct vm *vm)
>> +{
>> +	vm->sblk->icptcode = 0;
>> +}
>> +
>> +static void intercept_diag_10(void)
>> +{
>> +	u32 instr = 0x83020010;
>> +
>> +	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
>> +	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
>> +
>> +	memset(guest_instr, 0, PAGE_SIZE);
>> +	memcpy(guest_instr, &instr, 4);
>> +	sie(&vm);
>> +	report(vm.sblk->icptcode == 4 && vm.sblk->ipa == 0x8302 && vm.sblk->ipb == 0x100000,
> 
> Again, some #defines might help here, making clear that 0x8302 means
> diag. (The ipb value is clear enough :) Maybe you can also assemble
> instr out of pre-made pieces? Or factor out some code to a common
> function?

Yes, a diag test function that has the code as a parameter would make
this look nicer and I could also test ipa against the first 16bits of instr.

> 
>> +	       "Diag 10 intercept");
>> +	sblk_cleanup(&vm);
>> +}
>> +
>> +static void intercept_diag_44(void)
>> +{
>> +	u32 instr = 0x83020044;
>> +
>> +	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
>> +	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
>> +
>> +	memset(guest_instr, 0, PAGE_SIZE);
>> +	memcpy(guest_instr, &instr, 4);
>> +	sie(&vm);
>> +	report(vm.sblk->icptcode == 4 && vm.sblk->ipa == 0x8302 && vm.sblk->ipb == 0x440000,
>> +	       "Diag 44 intercept");
>> +	sblk_cleanup(&vm);
>> +}
>> +
>> +static void intercept_diag_9c(void)
>> +{
>> +	u32 instr = 0x8302009c;
>> +
>> +	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
>> +	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
>> +
>> +	memset(guest_instr, 0, PAGE_SIZE);
>> +	memcpy(guest_instr, &instr, 4);
>> +	sie(&vm);
>> +	report(vm.sblk->icptcode == 4 && vm.sblk->ipa == 0x8302 && vm.sblk->ipb == 0x9c0000,
>> +	       "Diag 9c intercept");
>> +	sblk_cleanup(&vm);
>> +}
> 
> (...)
> 

