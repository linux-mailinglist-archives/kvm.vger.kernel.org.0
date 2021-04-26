Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B144E36B4F5
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 16:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbhDZOeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 10:34:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231862AbhDZOeh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 10:34:37 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13QEWfup155246;
        Mon, 26 Apr 2021 10:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XeYqaKeaXScgxu/SeXV/Suyol2R7Pny2Z2VXEkdISc0=;
 b=A7R3AiqPbiehpihZ+6aGyGis5C+ih2uzd7TRosHa2GDZ1bFWx45hZW9+7VAiaswGUxSx
 IRdwHdUp0f7apLNRQUclrBBSf4bR3CACmFIm7LUTz4PrvhNXINUc0cY7/DYSSO24Eujs
 MuI/vQ5sHuELsd9iT0TRr5l18Y8FFzGzdQv2EtttBEBgu9OFly+Cg/JsVNk3qofg4vk5
 qDZRkLfeiAxYYtr22mC9gHRT++3on6mWjm74B8Bpq2mSHHYVEIOuzCFg6a9DwlBcULsC
 4meImVc7059jaKuYOj++RYP3j9W//2Y2Kdgahc1kdPdxGrWjQqR0fJcPrZgxTaLewkEW iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 385xg128e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Apr 2021 10:33:55 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13QEXLr3160103;
        Mon, 26 Apr 2021 10:33:55 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 385xg128dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Apr 2021 10:33:54 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13QEX1tV022658;
        Mon, 26 Apr 2021 14:33:53 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 384ay8gv3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Apr 2021 14:33:53 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13QEXo2Q45351354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Apr 2021 14:33:50 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3183152054;
        Mon, 26 Apr 2021 14:33:50 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.12.8])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C88DB5204F;
        Mon, 26 Apr 2021 14:33:49 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 2/6] s390x: Add more Ultravisor command
 structure definitions
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, imbrenda@linux.ibm.com
References: <20210316091654.1646-1-frankja@linux.ibm.com>
 <20210316091654.1646-3-frankja@linux.ibm.com>
 <20210421131335.31a2bf47.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <d3f47425-213e-a3b2-f120-da6c2cb01dd1@linux.ibm.com>
Date:   Mon, 26 Apr 2021 16:33:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210421131335.31a2bf47.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qvmPcoDZKj8VEsme1ah2NjPDyTIUJcR4
X-Proofpoint-ORIG-GUID: kgzXRoshGs0U4j01squGGKQyeAH3EEBH
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-26_07:2021-04-26,2021-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104260114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/21 1:13 PM, Cornelia Huck wrote:
> On Tue, 16 Mar 2021 09:16:50 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> They are needed in the new UV tests.
>>
>> As we now extend the size of the query struct, we need to set the
>> length in the UV guest query test to a constant instead of using
>> sizeof.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/asm/uv.h | 148 ++++++++++++++++++++++++++++++++++++++++++++-
>>  s390x/uv-guest.c   |   2 +-
>>  2 files changed, 148 insertions(+), 2 deletions(-)
>>
> 
> (...)
> 
>>  struct uv_cb_qui {
>>  	struct uv_cb_header header;
>>  	u64 reserved08;
>>  	u64 inst_calls_list[4];
>> -	u64 reserved30[15];
>> +	u64 reserved30[2];
>> +	u64 uv_base_stor_len;
>> +	u64 reserved48;
>> +	u64 conf_base_phys_stor_len;
>> +	u64 conf_base_virt_stor_len;
>> +	u64 conf_virt_var_stor_len;
>> +	u64 cpu_stor_len;
>> +	u32 reserved70[3];
>> +	u32 max_num_sec_conf;
>> +	u64 max_guest_stor_addr;
>> +	u8  reserved88[158 - 136];
>> +	u16 max_guest_cpus;
>> +	u8  reserveda0[200 - 160];
>> +}  __attribute__((packed))  __attribute__((aligned(8)));
> 
> (...)
> 
>> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
>> index a13669ab..95a968c5 100644
>> --- a/s390x/uv-guest.c
>> +++ b/s390x/uv-guest.c
>> @@ -59,7 +59,7 @@ static void test_query(void)
>>  {
>>  	struct uv_cb_qui uvcb = {
>>  		.header.cmd = UVC_CMD_QUI,
>> -		.header.len = sizeof(uvcb) - 8,
>> +		.header.len = 0xa0,
> 
> This is a magic constant coming out of nowhere. Could you please at
> least add a comment to make clear what you are testing?

Added:
/* A dword below the minimum length */

> 
>>  	};
>>  	int cc;
>>  
> 

