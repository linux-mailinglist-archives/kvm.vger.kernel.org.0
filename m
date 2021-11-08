Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5313447F6D
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238245AbhKHMXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:23:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1444 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237354AbhKHMXa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 07:23:30 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8BjW6t022989
        for <kvm@vger.kernel.org>; Mon, 8 Nov 2021 12:20:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PV6kfkJ1zfuFFlUZk36VmMiqGPqPB2bguGLt16c39bo=;
 b=JpiY84mZXftuocO8Fg+YJnLnKR/yGgGEABJVR+33Tj7g+n8W8KJdMnsonnXunTFPoHE2
 vLT7qTZjZosc5ySYG4q108PPPxvNvBzoYbwMCiaO322cao5G1axU/IX+aHDW2lbnIq8a
 r+1/EQiU+UVSY+Vi3GbiM/Zn/ovRns//+GDlwJdgD0l3FghvXhqhKk3G3z5XHeWJ+xfQ
 4gFOHkJg1qboR7bV+bb53qkwrnIgT47wXZw4Vz6t5x4dm5YTr91WP6Y6riZvW3UXzu3A
 VBg1G3YuNqf1gfjyQMaKryEjLsNdnttnhUTIvlZKyhWrq7kvDjZjMqFymhcbQXRx9IU2 UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c66ayx10e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 12:20:44 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A8BxfJW010752
        for <kvm@vger.kernel.org>; Mon, 8 Nov 2021 12:20:44 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c66ayx0yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:20:44 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8C9l1A010073;
        Mon, 8 Nov 2021 12:20:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3c5hb9ws46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:20:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8CKdgj53477852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 12:20:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26AEF42056;
        Mon,  8 Nov 2021 12:20:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 980B34204C;
        Mon,  8 Nov 2021 12:20:37 +0000 (GMT)
Received: from [9.171.49.228] (unknown [9.171.49.228])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Nov 2021 12:20:37 +0000 (GMT)
Message-ID: <e2087e3d-2b0c-a513-15f0-88052f612722@linux.ibm.com>
Date:   Mon, 8 Nov 2021 13:21:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 2/7] s390x: css: add callback for
 emnumeration
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-3-git-send-email-pmorel@linux.ibm.com>
 <e880646b-4fba-c363-7387-b96b3acdf13d@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <e880646b-4fba-c363-7387-b96b3acdf13d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FQlkNXDtowatNF3nF1wovRHzCQLrmuEE
X-Proofpoint-GUID: Z5_Rd_PL5ty9EGJpDR3e_aO6_oUxfPah
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_03,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 phishscore=0 clxscore=1015 adultscore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/3/21 08:29, Thomas Huth wrote:
> On 27/08/2021 12.17, Pierre Morel wrote:
>> We will need to look for a device inside the channel subsystem
>> based upon device specificities.
>>
>> Let's provide a callback for an upper layer to be called during
>> the enumeration of the channel subsystem.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     | 3 ++-
>>   lib/s390x/css_lib.c | 4 +++-
>>   s390x/css.c         | 2 +-
>>   3 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>> index d644971f..2005f4d7 100644
>> --- a/lib/s390x/css.h
>> +++ b/lib/s390x/css.h
>> @@ -278,7 +278,8 @@ void dump_irb(struct irb *irbp);
>>   void dump_pmcw(struct pmcw *p);
>>   void dump_orb(struct orb *op);
>> -int css_enumerate(void);
>> +typedef int (enumerate_cb_t)(int);
>> +int css_enumerate(enumerate_cb_t *f);
>>   #define MAX_ENABLE_RETRIES      5
>>   #define IO_SCH_ISC      3
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index efc70576..484f9c41 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -117,7 +117,7 @@ bool get_chsc_scsc(void)
>>    * On success return the first subchannel ID found.
>>    * On error return an invalid subchannel ID containing cc
>>    */
>> -int css_enumerate(void)
>> +int css_enumerate(enumerate_cb_t *f)
> 
> I'd maybe call it "cb" instead of "f" ... but that's just my personal 
> taste, I guess.

I can use cb, looks better.

> 
>>   {
>>       struct pmcw *pmcw = &schib.pmcw;
>>       int scn_found = 0;
>> @@ -153,6 +153,8 @@ int css_enumerate(void)
>>               schid = scn | SCHID_ONE;
>>           report_info("Found subchannel %08x", scn | SCHID_ONE);
>>           dev_found++;
>> +        if (f)
>> +            f(scn | SCHID_ONE);
>>       }
>>   out:
>> diff --git a/s390x/css.c b/s390x/css.c
>> index c340c539..b50fbc67 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -29,7 +29,7 @@ struct ccw1 *ccw;
>>   static void test_enumerate(void)
>>   {
>> -    test_device_sid = css_enumerate();
>> +    test_device_sid = css_enumerate(NULL);
>>       if (test_device_sid & SCHID_ONE) {
>>           report(1, "Schid of first I/O device: 0x%08x", 
>> test_device_sid);
>>           return;
>>
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
