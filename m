Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6B045A345
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 13:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237440AbhKWMxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 07:53:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5228 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237029AbhKWMxD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 07:53:03 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANCHchS020227;
        Tue, 23 Nov 2021 12:49:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=b1QuymvdwJvKr3okmHJEqFvOOjCxOIpqWT9KROprwwg=;
 b=GjJEqkKJ0elLnurGcRjLSJMZ+CbjrdmjLNPRTJpO5QOltSR7zE4B69fjFarUzpw0HrWV
 4RjAU2Eaxwhq4H14MFwQwN2dX9y+cSPDYLAr7ki0yXtCBIXzGl1cEKVH1WV8SrEOElf8
 +9uSx9aVGHFBaTtAV4xW4s491V99Aq0ozgd+i32Ed6TNyJN3e1s3tn7xBQpjX108UHDQ
 AfoAoDmXM3IwFcsmLCYv3rfAY6MCaeKCtBOoC+dcohcCv6Jmkmy2pLKDzDJc64qy/ipD
 oq4nrRwFD33TOKwK3rY2HNTfG7NMrAHeW3zjvfMFuyUpdg+ZyrHxJDagYEX0yd9YGcw5 eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgw3gmjy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 12:49:54 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANCjMMv030776;
        Tue, 23 Nov 2021 12:49:54 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgw3gmjxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 12:49:53 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANCh6TR012965;
        Tue, 23 Nov 2021 12:49:51 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3cernaqvfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 12:49:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANCnllU9109882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 12:49:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D13FCA405F;
        Tue, 23 Nov 2021 12:49:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FB35A4054;
        Tue, 23 Nov 2021 12:49:47 +0000 (GMT)
Received: from [9.145.183.32] (unknown [9.145.183.32])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 12:49:47 +0000 (GMT)
Message-ID: <0a6f7543-0c49-e24d-777c-a5167ec494c9@linux.ibm.com>
Date:   Tue, 23 Nov 2021 13:49:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, mhartmay@linux.ibm.com
References: <20211123103956.2170-1-frankja@linux.ibm.com>
 <20211123103956.2170-4-frankja@linux.ibm.com>
 <20211123115447.25d9ab9c@p-imbrenda>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 3/8] s390x: sie: Add UV information into VM
 struct
In-Reply-To: <20211123115447.25d9ab9c@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CYjUCBemyT-1Z4HGhMaNWbmtV43_JxO9
X-Proofpoint-GUID: TOKnyC7j3-_R9V8mU7omgYuDOOaCMYVM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_04,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/23/21 11:54, Claudio Imbrenda wrote:
> On Tue, 23 Nov 2021 10:39:51 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> We need to save the handles for the VM and the VCPU so we can retrieve
>> them easily after their creation. Since the SIE lib is single guest
> 
> multiple guest CPUs will be needed for testing some functions, but I
> guess that's something for me to do :)

I would be happy if someone picks this up. Just let me know if you do so 
I can plan accordingly.

> 
>> cpu only we only save one vcpu handle.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Thanks!

> 
>> ---
>>   lib/s390x/sie.h | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
>> index c6eb6441..1a12faa7 100644
>> --- a/lib/s390x/sie.h
>> +++ b/lib/s390x/sie.h
>> @@ -200,6 +200,11 @@ union {
>>   	uint64_t	gvrd;			/* 0x01f8 */
>>   } __attribute__((packed));
>>   
>> +struct vm_uv {
>> +	uint64_t vm_handle;
>> +	uint64_t vcpu_handle;
>> +};
>> +
>>   struct vm_save_regs {
>>   	uint64_t grs[16];
>>   	uint64_t fprs[16];
>> @@ -220,6 +225,7 @@ struct vm {
>>   	struct vm_save_area save_area;
>>   	void *sca;				/* System Control Area */
>>   	uint8_t *crycb;				/* Crypto Control Block */
>> +	struct vm_uv uv;			/* PV UV information */
>>   	/* Ptr to first guest page */
>>   	uint8_t *guest_mem;
>>   };
> 

