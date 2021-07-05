Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DCE3BBA37
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 11:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhGEJfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 05:35:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50632 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230312AbhGEJfo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Jul 2021 05:35:44 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16594HWD054200;
        Mon, 5 Jul 2021 05:33:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Km40CHlIkqByNJF9+Yx1npKzDiNmdljzWWqaG71mb54=;
 b=mjYNRuWpcSesfoeob6pcb4ttzALT4B2we4gCwuFgrFYaljuuTBYh7npoWU5LOinYd4T8
 xBK3J2Rly3THX7yY9Sz6BVxDG318tK6vdJAoD9YRi06MH82lVOTFn3afTUNIerM9+UgE
 2olQcAceGkX+8V2IjolUnRW6suO3hbNPQMjkOhZiQYlrFm0Tg0pMLX5EDYV7YCVonkyN
 HaN3dJF6q2ZwP5ZNJF2/HhW0Zfo2OdDDy07IJAqfTllRxYip3pxVg96UmK3HtpX/RQkh
 zMmlLGvawZ/CLijQkcmEqkHWn2atY3xPEsPwPodDcpbEWs+ItInrXcaKLF44m2q+KkdL 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39kwc4ks18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jul 2021 05:33:07 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16594KX6054794;
        Mon, 5 Jul 2021 05:33:06 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39kwc4ks0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jul 2021 05:33:06 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1659X5Rf019390;
        Mon, 5 Jul 2021 09:33:05 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 39jfh8rq79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jul 2021 09:33:05 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1659X2ie27328786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jul 2021 09:33:03 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2A8AA405E;
        Mon,  5 Jul 2021 09:33:02 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E957A4055;
        Mon,  5 Jul 2021 09:33:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.25.73])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jul 2021 09:33:02 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 3/5] lib: s390x: uv: Int type cleanup
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <20210629133322.19193-1-frankja@linux.ibm.com>
 <20210629133322.19193-4-frankja@linux.ibm.com>
 <d2798bf7-3018-e311-1dfb-120144fb343d@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <3876955c-24bd-2052-e634-8436f7558df4@linux.ibm.com>
Date:   Mon, 5 Jul 2021 11:33:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d2798bf7-3018-e311-1dfb-120144fb343d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fvKMn1WRjAWWV9r561XgrHzkRJvjtvA_
X-Proofpoint-ORIG-GUID: vEzGsWh5OnEmq4FWBeMIVscGUm_u41ax
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-05_04:2021-07-02,2021-07-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107050048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/4/21 9:51 AM, Thomas Huth wrote:
> On 29/06/2021 15.33, Janosch Frank wrote:
>> These structs have largely been copied from the kernel so they still
>> have the old uint short types which we want to avoid in favor of the
>> uint*_t ones.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/asm/uv.h | 142 +++++++++++++++++++++++----------------------
>>   1 file changed, 72 insertions(+), 70 deletions(-)
>>
>> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
>> index dc3e02d..96a2a7e 100644
>> --- a/lib/s390x/asm/uv.h
>> +++ b/lib/s390x/asm/uv.h
>> @@ -12,6 +12,8 @@
>>   #ifndef _ASMS390X_UV_H_
>>   #define _ASMS390X_UV_H_
>>   
>> +#include <stdint.h>
>> +
>>   #define UVC_RC_EXECUTED		0x0001
>>   #define UVC_RC_INV_CMD		0x0002
>>   #define UVC_RC_INV_STATE	0x0003
>> @@ -68,73 +70,73 @@ enum uv_cmds_inst {
>>   };
>>   
>>   struct uv_cb_header {
>> -	u16 len;
>> -	u16 cmd;	/* Command Code */
>> -	u16 rc;		/* Response Code */
>> -	u16 rrc;	/* Return Reason Code */
>> +	uint16_t len;
>> +	uint16_t cmd;	/* Command Code */
>> +	uint16_t rc;	/* Response Code */
>> +	uint16_t rrc;	/* Return Reason Code */
>>   } __attribute__((packed))  __attribute__((aligned(8)));
> 
> Hmm, for files that are more or less a copy from the corresponding kernel 
> header, I'm not sure whether it makes sense to convert them to the stdint.h 
> types? It might be better to keep the kernel types so that updates to this 
> header can be ported more easily to the kvm-unit-tests later?

sie.h contents are 90% sblk which came directly from KVM...
Do you really want to have exceptions for one file? Because if that's
the case then I see no sense in changing other things over since I
prefer using short types.


> 
>   Thomas
> 

