Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F45C490509
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 10:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235822AbiAQJj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 04:39:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55552 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233505AbiAQJj0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 04:39:26 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20H8ST2T009218;
        Mon, 17 Jan 2022 09:39:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7AtWFSkraXq7ydvQ6tEoJAZ04E5ViY5tC2GnCJ4my24=;
 b=ZZf0NX0EDmSFomLQZYQxuIe/qJy4BCxEA2KVsg8ldumSnfs4eAKMq/ER4lnUKdp7SmyY
 TpNszwslYY4dUFcLc4WSPWLew0h8KVk8bm04QVXAZo99SKxyahSo8veyIDd1QDirJsht
 C7e+qALEsMk2RSkFR5t8wicLo9cySdhltxTaJJkfWvSHfDZ9dNhw3F4ttD9OpwkbchcL
 4FHEljTvSD6adgm2xd6EtCEcBZU9En3pAqUVb+Dcagd/7+TwxY38i2u8VqzDna6hoR31
 FIGR8/fY0TMNxdEitm65QFfrnZ4nmxyxgL+4Zmt4Q9CwBeC+XxL1ENUyEGsZh/lrcVcg 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dn4yt98mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 09:39:26 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20H9Rx7G015108;
        Mon, 17 Jan 2022 09:39:26 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dn4yt98m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 09:39:25 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20H9YtDb004106;
        Mon, 17 Jan 2022 09:39:23 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3dknw91j4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 09:39:23 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20H9dJdF46989746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 09:39:19 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E490CA4066;
        Mon, 17 Jan 2022 09:39:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54AF1A405B;
        Mon, 17 Jan 2022 09:39:18 +0000 (GMT)
Received: from [9.145.19.65] (unknown [9.145.19.65])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 09:39:18 +0000 (GMT)
Message-ID: <600f34b9-83c2-7096-d268-33953b0a4324@linux.ibm.com>
Date:   Mon, 17 Jan 2022 10:39:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH 3/5] s390x: diag308: Only test subcode 2
 under QEMU
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, nrb@linux.ibm.com
References: <20220114100245.8643-1-frankja@linux.ibm.com>
 <20220114100245.8643-4-frankja@linux.ibm.com>
 <999498b3-6b1d-69ae-c80f-2a10102d95bd@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <999498b3-6b1d-69ae-c80f-2a10102d95bd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8IBgrzJy3D0Umykowa3r7yLfhe3StvpM
X-Proofpoint-ORIG-GUID: nnrNU9WzAvh4kiBWnqpI-iAeKSdXWyuS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_03,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201170061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/17/22 08:04, Thomas Huth wrote:
> On 14/01/2022 11.02, Janosch Frank wrote:
>> Other hypervisors might implement it and therefore not send a
>> specification exception.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>    s390x/diag308.c | 15 ++++++++++++++-
>>    1 file changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/s390x/diag308.c b/s390x/diag308.c
>> index c9d6c499..414dbdf4 100644
>> --- a/s390x/diag308.c
>> +++ b/s390x/diag308.c
>> @@ -8,6 +8,7 @@
>>    #include <libcflat.h>
>>    #include <asm/asm-offsets.h>
>>    #include <asm/interrupt.h>
>> +#include <vm.h>
>>    
>>    /* The diagnose calls should be blocked in problem state */
>>    static void test_priv(void)
>> @@ -75,7 +76,7 @@ static void test_subcode6(void)
>>    /* Unsupported subcodes should generate a specification exception */
>>    static void test_unsupported_subcode(void)
>>    {
>> -	int subcodes[] = { 2, 0x101, 0xffff, 0x10001, -1 };
>> +	int subcodes[] = { 0x101, 0xffff, 0x10001, -1 };
>>    	int idx;
>>    
>>    	for (idx = 0; idx < ARRAY_SIZE(subcodes); idx++) {
>> @@ -85,6 +86,18 @@ static void test_unsupported_subcode(void)
>>    		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>>    		report_prefix_pop();
>>    	}
>> +
>> +	/*
>> +	 * Subcode 2 is not available under QEMU but might be on other
>> +	 * hypervisors.
>> +	 */
>> +	if (vm_is_tcg() || vm_is_kvm()) {
>> +		report_prefix_pushf("0x%04x", 2);
> 
> Maybe replace the format string with "0002" and drop the "2" parameter?

Sure

> 
>> +		expect_pgm_int();
>> +		asm volatile ("diag %0,%1,0x308" :: "d"(0), "d"(2));
>> +		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +		report_prefix_pop();
>> +	}
>>    }
>>    
>>    static struct {
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Thanks

