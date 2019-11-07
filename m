Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE36F2E46
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 13:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388643AbfKGMmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 07:42:11 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54952 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733250AbfKGMmL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Nov 2019 07:42:11 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA7Cc1Og137590
        for <kvm@vger.kernel.org>; Thu, 7 Nov 2019 07:42:10 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w4jw4j8fq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 07:42:09 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Thu, 7 Nov 2019 12:42:07 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 7 Nov 2019 12:42:05 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA7CfSGk42009074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Nov 2019 12:41:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A659AA405C;
        Thu,  7 Nov 2019 12:42:03 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 420CBA405B;
        Thu,  7 Nov 2019 12:42:03 +0000 (GMT)
Received: from [9.152.224.49] (unknown [9.152.224.49])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Nov 2019 12:42:03 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [RFC 13/37] KVM: s390: protvirt: Add interruption injection
 controls
To:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-14-frankja@linux.ibm.com>
 <20191105185124.495d4820.cohuck@redhat.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Thu, 7 Nov 2019 13:42:03 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191105185124.495d4820.cohuck@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19110712-4275-0000-0000-0000037BA4BE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110712-4276-0000-0000-0000388EF602
Message-Id: <ea08a16a-fd00-9335-f471-62cfd54334b0@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-07_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911070127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05.11.19 18:51, Cornelia Huck wrote:
> On Thu, 24 Oct 2019 07:40:35 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> From: Michael Mueller <mimu@linux.ibm.com>
>>
>> Define the interruption injection codes and the related fields in the
>> sie control block for PVM interruption injection.
>>
>> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_host.h | 25 +++++++++++++++++++++----
>>   1 file changed, 21 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index 6cc3b73ca904..82443236d4cc 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -215,7 +215,15 @@ struct kvm_s390_sie_block {
>>   	__u8	icptcode;		/* 0x0050 */
>>   	__u8	icptstatus;		/* 0x0051 */
>>   	__u16	ihcpu;			/* 0x0052 */
>> -	__u8	reserved54[2];		/* 0x0054 */
>> +	__u8	reserved54;		/* 0x0054 */
>> +#define IICTL_CODE_NONE		 0x00
>> +#define IICTL_CODE_MCHK		 0x01
>> +#define IICTL_CODE_EXT		 0x02
>> +#define IICTL_CODE_IO		 0x03
>> +#define IICTL_CODE_RESTART	 0x04
>> +#define IICTL_CODE_SPECIFICATION 0x10
>> +#define IICTL_CODE_OPERAND	 0x11
>> +	__u8	iictl;			/* 0x0055 */
>>   	__u16	ipa;			/* 0x0056 */
>>   	__u32	ipb;			/* 0x0058 */
>>   	__u32	scaoh;			/* 0x005c */
>> @@ -252,7 +260,8 @@ struct kvm_s390_sie_block {
>>   #define HPID_KVM	0x4
>>   #define HPID_VSIE	0x5
>>   	__u8	hpid;			/* 0x00b8 */
>> -	__u8	reservedb9[11];		/* 0x00b9 */
>> +	__u8	reservedb9[7];		/* 0x00b9 */
>> +	__u32	eiparams;		/* 0x00c0 */
>>   	__u16	extcpuaddr;		/* 0x00c4 */
>>   	__u16	eic;			/* 0x00c6 */
>>   	__u32	reservedc8;		/* 0x00c8 */
>> @@ -268,8 +277,16 @@ struct kvm_s390_sie_block {
>>   	__u8	oai;			/* 0x00e2 */
>>   	__u8	armid;			/* 0x00e3 */
>>   	__u8	reservede4[4];		/* 0x00e4 */
>> -	__u64	tecmc;			/* 0x00e8 */
>> -	__u8	reservedf0[12];		/* 0x00f0 */
>> +	union {
>> +		__u64	tecmc;		/* 0x00e8 */
>> +		struct {
>> +			__u16	subchannel_id;	/* 0x00e8 */
>> +			__u16	subchannel_nr;	/* 0x00ea */
>> +			__u32	io_int_parm;	/* 0x00ec */
>> +			__u32	io_int_word;	/* 0x00f0 */
>> +		};
>> +	} __packed;
>> +	__u8	reservedf4[8];		/* 0x00f4 */
> 
> IIUC, for protected guests, you won't get an interception for which
> tecmc would be valid anymore, but need to put the I/O interruption
> stuff at the same place, right?

Yes, the format 4 architecture defines this.

> 
> My main issue is that this makes the control block definition a bit
> ugly, since the f0 value that's unused in the non-protvirt case is not
> obvious anymore; but I don't know how to express this without making it
> even uglier :(

:)

> 
>>   #define CRYCB_FORMAT_MASK 0x00000003
>>   #define CRYCB_FORMAT0 0x00000000
>>   #define CRYCB_FORMAT1 0x00000001
> 

Thanks
Michael

