Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3F731A1D4
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 16:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhBLPhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 10:37:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57808 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232270AbhBLPgs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 10:36:48 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11CFWqmJ054076;
        Fri, 12 Feb 2021 10:36:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2+MJ1aifH0AIkWi44awmMTcsfJsB9GzF7HrkFjxThSc=;
 b=Q91x1cuLtz6FGY5w1h6OT+3YxgKHzvkkb6Huek1P1vMK/RpOCFd46iyhuQ0LT5hIpCrE
 VWkkKFDATzVHoQ978h7OrSv8QK3kH6YGl8+hLcSl5W90nxLh4kJ3KzTgMJg85+HTA0Fy
 B5+pZi216SxnNJKQRNOVwl3iqxyo/eDzZng3KEDp/1bzk4ywftZb5ZjaaUd+pGBRMT0O
 Q3biwvlhJlCSTpHh/n+5AFg4GzDYgpXsWG2Gx6CuMZxpIbEoHmi+fd4SCaSC1YKb4a+z
 Ov+i0c4BXFyo3V5K1aRMw6SR4qbdz21UMc7sDWW711kNR7TOnlYfU2eIr9NfgqSdrmu4 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36nvcc88gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 10:36:03 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11CFXoLB060669;
        Fri, 12 Feb 2021 10:36:03 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36nvcc88e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 10:36:03 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11CFGqhc015524;
        Fri, 12 Feb 2021 15:36:01 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 36m1m2tyyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 15:36:01 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11CFZw6H65274280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 15:35:58 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A12542042;
        Fri, 12 Feb 2021 15:35:58 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE75D42049;
        Fri, 12 Feb 2021 15:35:57 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.28.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Feb 2021 15:35:57 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 1/5] s390x: css: Store CSS
 Characteristics
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
References: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
 <1612963214-30397-2-git-send-email-pmorel@linux.ibm.com>
 <20210212113259.32fe6906.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <b22c3d02-6762-b78c-9746-8442ce956995@linux.ibm.com>
Date:   Fri, 12 Feb 2021 16:35:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210212113259.32fe6906.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_05:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120121
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/12/21 11:32 AM, Cornelia Huck wrote:
> On Wed, 10 Feb 2021 14:20:10 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> CSS characteristics exposes the features of the Channel SubSystem.
>> Let's use Store Channel Subsystem Characteristics to retrieve
>> the features of the CSS.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  69 +++++++++++++++++++++++++++
>>   lib/s390x/css_lib.c | 112 +++++++++++++++++++++++++++++++++++++++++++-
>>   s390x/css.c         |  12 +++++
>>   3 files changed, 192 insertions(+), 1 deletion(-)
>>
> 
> (...)
> 
>> +static const char *chsc_rsp_description[] = {
>> +	"CHSC unknown error",
>> +	"Command executed",
>> +	"Invalid command",
>> +	"Request-block error",
>> +	"Command not installed",
>> +	"Data not available",
>> +		"Absolute address of channel-subsystem"
>> +	"communication block exceeds 2 - 1.",
> 
> "2G - 1", I think?

:) yes

> 
>> +	"Invalid command format",
>> +	"Invalid channel-subsystem identification (CSSID)",
>> +	"The command-request block specified an invalid format"
>> +		"for the command response block.",
>> +	"Invalid subchannel-set identification (SSID)",
>> +	"A busy condition precludes execution.",
>> +};
> 
> (...)
> 
> This matches both the Linux implementation and my memories, so
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
