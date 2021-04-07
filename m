Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156FC356A40
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 12:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbhDGKrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 06:47:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8548 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1351479AbhDGKrB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 06:47:01 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 137AZLDu181673
        for <kvm@vger.kernel.org>; Wed, 7 Apr 2021 06:46:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZF4hBNGGaRVni7FcmMLWEEc0Qq+pHbR+fAUmweHnpdo=;
 b=BX8Hn/a3hHTuX5ztRlFbwTOhiAuaTPT3lPFg5byW3saowtK8b0YCJlMtqDBFOfARpVzj
 Xi6PNJszsbMMLOjAXeU1yswWjc3SmpNk2mjhwR4JSD5DFWgfKGDk3C8G9KulLZ/gAVnS
 T9nfEPCRAfqoawQtOSwi9gImzmHiw4TfR0wTBuYuG/+IXQToAaa2Z4bdKNCXqlQgbVW8
 EHvTqetWo7KL8gXC04a1LrXtSpmhDr5DmgxfvE1En7s2vKY5AK2Vo7n+WFtO0roJ7qtA
 sEOFO+HPirE7JA3/y10LBSAK52BISMiyoNmprvHF7oOmIKd8R2O+WLGDnxxz1OPQyryw Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37rvm4deah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 06:46:38 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 137AZQk1182121
        for <kvm@vger.kernel.org>; Wed, 7 Apr 2021 06:46:38 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37rvm4dea1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 06:46:37 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 137Ag908002264;
        Wed, 7 Apr 2021 10:46:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 37rvc5gb1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 10:46:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 137AkXK661604114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Apr 2021 10:46:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37654AE055;
        Wed,  7 Apr 2021 10:46:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5FE4AE04D;
        Wed,  7 Apr 2021 10:46:32 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.144.161])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Apr 2021 10:46:32 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 14/16] s390x: css: issuing SSCH when the
 channel is status pending
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
 <1617694853-6881-15-git-send-email-pmorel@linux.ibm.com>
 <20210406173456.30d0c246.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <d8a0f781-a335-74ad-628e-5537b7c42ad9@linux.ibm.com>
Date:   Wed, 7 Apr 2021 12:46:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210406173456.30d0c246.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: llrrk5PbEbAATOwXu7cqPQx0cUFPvo6K
X-Proofpoint-ORIG-GUID: 1Zaqr8-x_k9m7lR9VaAG8hTwfSa2ZCIo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-07_07:2021-04-06,2021-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104070074
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/6/21 5:34 PM, Cornelia Huck wrote:
> On Tue,  6 Apr 2021 09:40:51 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We await CC=1 when we issue a SSCH on a channel with status pending.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h |  2 ++
>>   s390x/css.c     | 10 ++++++++++
>>   2 files changed, 12 insertions(+)
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index 08b2974..3eb6957 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -90,6 +90,8 @@ struct scsw {
>>   #define SCSW_ESW_FORMAT		0x04000000
>>   #define SCSW_SUSPEND_CTRL	0x08000000
>>   #define SCSW_KEY		0xf0000000
>> +#define SCSW_SSCH_COMPLETED	(SCSW_CCW_FORMAT | SCSW_FC_START | SCSW_SC_PENDING | SCSW_SC_SECONDARY | \
>> +				 SCSW_SC_PRIMARY)
>>   	uint32_t ctrl;
>>   	uint32_t ccw_addr;
>>   #define SCSW_DEVS_DEV_END	0x04
>> diff --git a/s390x/css.c b/s390x/css.c
>> index f8c6688..52264f2 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -258,6 +258,15 @@ static void ssch_orb_fcx(void)
>>   	orb->ctrl = tmp;
>>   }
>>   
>> +static void ssch_status_pending(void)
>> +{
>> +	assert(ssch(test_device_sid, orb) == 0);
>> +	report(ssch(test_device_sid, orb) == 1, "CC = 1");
> 
> I don't think that's correct in the general case (although it will work
> for QEMU).
> 
> The PoP has a note about some models discarding the status pending, if
> we have secondary status only (although I don't think that would happen
> with this sequence.) You might also end up with cc 2 here, I think. In
> theory, you could also get a cc 3 on real hardware, but that would be a
> real edge case, and subsequent tests would fail anyway.


OK, yes and it could also fail if we introduce asynchronousity in QEMU 
CCW too.
So I let fall all tests about starting a second instruction before 
testing the sub channel.
I have more in csch and hsch...

> 
>> +	/* now we clear the status */
>> +	assert(tsch(test_device_sid, &irb) == 0);
>> +	check_io_completion(test_device_sid, SCSW_SSCH_COMPLETED);
>> +}
>> +
>>   static struct tests ssh_tests[] = {
>>   	{ "privilege", ssch_privilege },
>>   	{ "orb cpa zero", ssch_orb_cpa_zero },
>> @@ -269,6 +278,7 @@ static struct tests ssh_tests[] = {
>>   	{ "ORB reserved CTRL bits", ssch_orb_ctrl },
>>   	{ "ORB extensions", ssch_orb_extension},
>>   	{ "FC extensions", ssch_orb_fcx},
>> +	{ "status pending before ssch", ssch_status_pending},
>>   	{ NULL, NULL }
>>   };
>>   
> 

-- 
Pierre Morel
IBM Lab Boeblingen
