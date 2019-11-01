Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFFEEC2D6
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 13:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730491AbfKAMjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 08:39:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18870 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727329AbfKAMjX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Nov 2019 08:39:23 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA1CbUnD054749
        for <kvm@vger.kernel.org>; Fri, 1 Nov 2019 08:39:22 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w050yahp6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 08:39:20 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 1 Nov 2019 12:39:18 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 1 Nov 2019 12:39:15 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA1CcdHc8847690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Nov 2019 12:38:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 562B4A4055;
        Fri,  1 Nov 2019 12:39:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 033FBA4051;
        Fri,  1 Nov 2019 12:39:13 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.72.197])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Nov 2019 12:39:12 +0000 (GMT)
Subject: Re: [RFC 06/37] s390: UV: Add import and export to UV library
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com, mihajlov@linux.ibm.com, mimu@linux.ibm.com,
        cohuck@redhat.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-7-frankja@linux.ibm.com>
 <b7126f40-ff10-0123-4c5e-37f57d63c3cd@de.ibm.com>
 <49b75b9c-9baa-40fd-c555-100c5afef0cd@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 syiRa+UVlsKmx1hsEg==
Date:   Fri, 1 Nov 2019 13:39:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <49b75b9c-9baa-40fd-c555-100c5afef0cd@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19110112-0016-0000-0000-000002BFD120
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110112-0017-0000-0000-0000332139AC
Message-Id: <e3064fd4-3bc3-5f59-e1e7-c80b7ca26e29@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-01_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911010126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 01.11.19 13:25, Janosch Frank wrote:
> On 11/1/19 12:26 PM, Christian Borntraeger wrote:
>>
>>
>> On 24.10.19 13:40, Janosch Frank wrote:
>>> The convert to/from secure (or also "import/export") ultravisor calls
>>> are need for page management, i.e. paging, of secure execution VM.
>>>
>>> Export encrypts a secure guest's page and makes it accessible to the
>>> guest for paging.
>>>
>>> Import makes a page accessible to a secure guest.
>>> On the first import of that page, the page will be cleared by the
>>> Ultravisor before it is given to the guest.
>>>
>>> All following imports will decrypt a exported page and verify
>>> integrity before giving the page to the guest.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>  arch/s390/include/asm/uv.h | 51 ++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 51 insertions(+)
>>>
>>> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
>>> index 0bfbafcca136..99cdd2034503 100644
>>> --- a/arch/s390/include/asm/uv.h
>>> +++ b/arch/s390/include/asm/uv.h
>>> @@ -15,6 +15,7 @@
>>>  #include <linux/errno.h>
>>>  #include <linux/bug.h>
>>>  #include <asm/page.h>
>>> +#include <asm/gmap.h>
>>>  
>>>  #define UVC_RC_EXECUTED		0x0001
>>>  #define UVC_RC_INV_CMD		0x0002
>>> @@ -279,6 +280,54 @@ static inline int uv_cmd_nodata(u64 handle, u16 cmd, u32 *ret)
>>>  	return rc ? -EINVAL : 0;
>>>  }
>>>  
>>> +/*
>>> + * Requests the Ultravisor to encrypt a guest page and make it
>>> + * accessible to the host for paging (export).
>>> + *
>>> + * @paddr: Absolute host address of page to be exported
>>> + */
>>> +static inline int uv_convert_from_secure(unsigned long paddr)
>>> +{
>>> +	struct uv_cb_cfs uvcb = {
>>> +		.header.cmd = UVC_CMD_CONV_FROM_SEC_STOR,
>>> +		.header.len = sizeof(uvcb),
>>> +		.paddr = paddr
>>> +	};
>>> +	if (!uv_call(0, (u64)&uvcb))
>>> +		return 0;
>>
>> As discussed on the KVM forum. We should also check for
>> uvcb.header.rc != UVC_RC_EXECUTED
>> I know, we cant really do much if this fails, but we certainly want to know.
>>
>>
>>
>>
>>
>>
>>> +	return -EINVAL;
>>> +}
>>> +
>>> +/*
>>> + * Requests the Ultravisor to make a page accessible to a guest
>>> + * (import). If it's brought in the first time, it will be cleared. If
>>> + * it has been exported before, it will be decrypted and integrity
>>> + * checked.
>>> + *
>>> + * @handle: Ultravisor guest handle
>>> + * @gaddr: Guest 2 absolute address to be imported
>>> + */
>>> +static inline int uv_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
>>> +{
>>> +	int cc;
>>> +	struct uv_cb_cts uvcb = {
>>> +		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
>>> +		.header.len = sizeof(uvcb),
>>> +		.guest_handle = gmap->se_handle,
>>> +		.gaddr = gaddr
>>> +	};
>>> +
>>> +	cc = uv_call(0, (u64)&uvcb);
>>> +
>>> +	if (!cc)
>>> +		return 0;
>>> +	if (uvcb.header.rc == 0x104)
>>> +		return -EEXIST;
>>> +	if (uvcb.header.rc == 0x10a)
>>> +		return -EFAULT;
>>
>> again, we should probably check for rc != UVC_RC_EXECUTED to detect any other problem.
> 
> That's handled by the CC and the return below.
> CC == 1 means error
> cc == 0 is success, that's why we return erly on cc == 0

Right, uv_call return depends on CC. Nevermind.

