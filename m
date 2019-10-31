Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52AC6EABC2
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 09:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfJaIsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 04:48:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60504 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726774AbfJaIsb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 31 Oct 2019 04:48:31 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9V8lwWv136152
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2019 04:48:29 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vyt99v8jp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2019 04:48:29 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Thu, 31 Oct 2019 08:48:27 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 31 Oct 2019 08:48:24 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9V8mMR721561470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Oct 2019 08:48:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BFCBA4060;
        Thu, 31 Oct 2019 08:48:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26B8FA405C;
        Thu, 31 Oct 2019 08:48:22 +0000 (GMT)
Received: from [9.152.96.213] (unknown [9.152.96.213])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Oct 2019 08:48:22 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [RFC 13/37] KVM: s390: protvirt: Add interruption injection
 controls
To:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, cohuck@redhat.com, gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-14-frankja@linux.ibm.com>
 <c09046eb-380f-d930-8e99-42b9cc8a62ae@redhat.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Thu, 31 Oct 2019 09:48:21 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c09046eb-380f-d930-8e99-42b9cc8a62ae@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19103108-0028-0000-0000-000003B16433
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19103108-0029-0000-0000-00002473AD04
Message-Id: <26dfdefa-edbe-40e5-5b41-a4de86d47d15@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-31_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=968 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910310088
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 30.10.19 16:53, David Hildenbrand wrote:
>> @@ -268,8 +277,16 @@ struct kvm_s390_sie_block {
>>       __u8    oai;            /* 0x00e2 */
>>       __u8    armid;            /* 0x00e3 */
>>       __u8    reservede4[4];        /* 0x00e4 */
>> -    __u64    tecmc;            /* 0x00e8 */
>> -    __u8    reservedf0[12];        /* 0x00f0 */
>> +    union {
>> +        __u64    tecmc;        /* 0x00e8 */
>> +        struct {
>> +            __u16    subchannel_id;    /* 0x00e8 */
>> +            __u16    subchannel_nr;    /* 0x00ea */
>> +            __u32    io_int_parm;    /* 0x00ec */
>> +            __u32    io_int_word;    /* 0x00f0 */
>> +        };
> 
> I only wonder if we should give this member a fitting name, e.g., 
> "ioparams"

Do you see a real gain for that? We have a lot of other unnamed structs
defined here as well.


> 
>> +    } __packed;
>> +    __u8    reservedf4[8];        /* 0x00f4 */
>>   #define CRYCB_FORMAT_MASK 0x00000003
>>   #define CRYCB_FORMAT0 0x00000000
>>   #define CRYCB_FORMAT1 0x00000001
>>

Thanks,
Michael

