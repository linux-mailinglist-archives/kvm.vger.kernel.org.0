Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB981D7BB0
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 16:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgEROqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 10:46:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44617 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgEROqc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 10:46:32 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04IEjhUj014889;
        Mon, 18 May 2020 10:46:31 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312cqm3eqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 10:46:31 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04IEjnxP015522;
        Mon, 18 May 2020 10:46:31 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 312cqm3eq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 10:46:31 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04IEG0HI017533;
        Mon, 18 May 2020 14:46:30 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 3127t6cd8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 May 2020 14:46:30 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04IEkQwx49676720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 14:46:26 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72BED6E04E;
        Mon, 18 May 2020 14:46:26 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A2376E04C;
        Mon, 18 May 2020 14:46:25 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.206.55])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon, 18 May 2020 14:46:25 +0000 (GMT)
Subject: Re: [PATCH v7 2/3] s390: keep diag 318 variables consistent with the
 rest
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <20200515221935.18775-1-walling@linux.ibm.com>
 <20200515221935.18775-3-walling@linux.ibm.com>
 <6f910102-c729-6605-39f7-d22ee8b40b4c@redhat.com>
From:   Collin Walling <walling@linux.ibm.com>
Message-ID: <36ceecf8-a1cd-3592-362b-53d6c57722be@linux.ibm.com>
Date:   Mon, 18 May 2020 10:46:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <6f910102-c729-6605-39f7-d22ee8b40b4c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 cotscore=-2147483648
 spamscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005180129
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/18/20 2:30 AM, Thomas Huth wrote:
> On 16/05/2020 00.19, Collin Walling wrote:
>> Rename diag318 to diag_318 and byte_134 to fac134 in order to keep
>> naming schemes consistent with other diags and the read info struct
>> and make grepping easier.
>>
>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>> ---
>>  arch/s390/include/asm/diag.h   | 2 +-
>>  arch/s390/include/asm/sclp.h   | 2 +-
>>  arch/s390/kernel/setup.c       | 6 +++---
>>  drivers/s390/char/sclp.h       | 2 +-
>>  drivers/s390/char/sclp_early.c | 2 +-
>>  5 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/diag.h b/arch/s390/include/asm/diag.h
>> index ca8f85b53a90..19da822e494c 100644
>> --- a/arch/s390/include/asm/diag.h
>> +++ b/arch/s390/include/asm/diag.h
>> @@ -295,7 +295,7 @@ struct diag26c_mac_resp {
>>  } __aligned(8);
>>  
>>  #define CPNC_LINUX		0x4
>> -union diag318_info {
>> +union diag_318_info {
> 
> $ grep -r diag.*info arch/s390/include/asm/diag.h
> struct diag204_info_blk_hdr {
> struct diag204_x_info_blk_hdr {
> struct diag204_cpu_info {
> struct diag204_x_cpu_info {
> 	struct diag204_x_cpu_info cpus[];
> union diag318_info {
> 
> ... none of these seem to use an underscore between the "diag" and the
> number ... so this seems unnecessary to me ... or what do I miss?
> 
>  Thomas
> 

I could have sworn I saw more cases with the underscore. I think I was
honing-in on a few cases in QEMU for whatever reason.

Let's just forget this patch was posted :)

-- 
--
Regards,
Collin

Stay safe and stay healthy
