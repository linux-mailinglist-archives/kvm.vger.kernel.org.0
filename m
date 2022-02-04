Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD7B4A94FC
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 09:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348306AbiBDISv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 03:18:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20748 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238253AbiBDISu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 03:18:50 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2144EDkD015930;
        Fri, 4 Feb 2022 08:18:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=S7+sbT/TnIHUfxb8TaNiTMgF8snl7yReJLNTXAViIRA=;
 b=NuOev1YieHSwMNtygOtWlUai4ZouZfCdv8bg32WxLwsrJoB8pkxvKL/bLdnslgITUtYn
 c+6Zad22HM9wd9P/J7hlZYKntEbJqa9tZh73IyWNuxeBwg1C3+6uKv/MPmwMsBonSdBo
 zVO7fV5+wskOltmWEuITSV+kelKroc/+RpZUrn5M2bYR0Rr3JLShECW/Hw7fg0rlGqQy
 KptWA3fY0aK0kAvwlfCvPQdTpW7P198cAy/omYIOhoE29hHzM0M6UNIR+Fm8Pw/LP8s7
 gKYt68pnLsotVdHEcxpTD7+za10Y4GkdJyeeZ6D20YlnH6JH73xcCrKAC9yxt3ewo8G1 Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0rt57bgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 08:18:49 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2147U8Ph011360;
        Fri, 4 Feb 2022 08:18:49 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0rt57bg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 08:18:49 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2148HhTD023830;
        Fri, 4 Feb 2022 08:18:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3e0r11jgqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 08:18:47 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2148IiZ547645144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 08:18:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52ACE4C059;
        Fri,  4 Feb 2022 08:18:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E3834C04A;
        Fri,  4 Feb 2022 08:18:44 +0000 (GMT)
Received: from [9.145.42.242] (unknown [9.145.42.242])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 08:18:43 +0000 (GMT)
Message-ID: <10811f94-4b87-ca90-e81c-1bc4f00035e1@linux.ibm.com>
Date:   Fri, 4 Feb 2022 09:18:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v2 2/4] s390x: lib: Add QUI getter
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Steffen Eiden <seiden@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220203091935.2716-1-seiden@linux.ibm.com>
 <20220203091935.2716-3-seiden@linux.ibm.com>
 <20220203171255.5fce1244@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220203171255.5fce1244@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hn6rvMYv_dpUPMD7IM5EsCsin5UXpcYA
X-Proofpoint-ORIG-GUID: thkg7FwdB78-AccmAj-oGsrWZ-oS4aOU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_03,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040037
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/22 17:12, Claudio Imbrenda wrote:
> On Thu,  3 Feb 2022 09:19:33 +0000
> Steffen Eiden <seiden@linux.ibm.com> wrote:
> 
>> Some tests need the information provided by the QUI UVC and lib/s390x/uv.c
>> already has cached the qui result. Let's add a function to avoid
>> unnecessary QUI UVCs.
> 
> I'm not against this approach, but I wonder if it's not easier to just
> make the QUI buffer public?

The introduction of that function is on me and I'm not a big fan of 
global variables.


> 
>>
>> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
>> ---
>>   lib/s390x/uv.c | 8 ++++++++
>>   lib/s390x/uv.h | 1 +
>>   2 files changed, 9 insertions(+)
>>
>> diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
>> index 6fe11dff..602cbbfc 100644
>> --- a/lib/s390x/uv.c
>> +++ b/lib/s390x/uv.c
>> @@ -47,6 +47,14 @@ bool uv_query_test_call(unsigned int nr)
>>   	return test_bit_inv(nr, uvcb_qui.inst_calls_list);
>>   }
>>   
>> +const struct uv_cb_qui *uv_get_query_data(void)
>> +{
>> +	/* Query needs to be called first */
>> +	assert(uvcb_qui.header.rc);
>> +
>> +	return &uvcb_qui;
>> +}
>> +
>>   int uv_setup(void)
>>   {
>>   	if (!test_facility(158))
>> diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
>> index 8175d9c6..44264861 100644
>> --- a/lib/s390x/uv.h
>> +++ b/lib/s390x/uv.h
>> @@ -8,6 +8,7 @@
>>   bool uv_os_is_guest(void);
>>   bool uv_os_is_host(void);
>>   bool uv_query_test_call(unsigned int nr);
>> +const struct uv_cb_qui *uv_get_query_data(void);
>>   void uv_init(void);
>>   int uv_setup(void);
>>   void uv_create_guest(struct vm *vm);
> 

