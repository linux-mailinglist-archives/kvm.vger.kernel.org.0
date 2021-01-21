Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0DA2FEDF7
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 16:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732512AbhAUPEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 10:04:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28596 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731975AbhAUN03 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 08:26:29 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LDCfGZ149123;
        Thu, 21 Jan 2021 08:25:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lOKWevt9on+hGR6/Rj1EXdMkTa0I4LDirTwGBP87EzQ=;
 b=i+/PTJfyO4jEVOS60eb/IAyB7CX1Me01/BeKwKHObs+mHL8rVGzthz6RQNvXusPk0ArO
 HD0H0b3nro6FxaGQa+6hSiUy1K/ggA7FBZf3FjwtMnzuU35E/HNeDVNSvv4gKJHDeZPk
 LIwYkUgugTQUgHUgTlqcwefbsYXzvOOBHhikMO6FeZsrZk/+HjaqgmbGK4UuaqnFG7t0
 vdLBVRU9MR/wseb6RY0LTUkBhKAlMtR4Ptj437OoImu4ODEW2T1FptV0HXs4h3WCIaV2
 At5nxsAeVyC4UzGbeTI+nTAitTP1rGZABGKTScU1YIY7pqkTFcwVxtMIV0N7S6OpXXg4 rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367a9x0bj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 08:25:48 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LDDn3P151283;
        Thu, 21 Jan 2021 08:25:47 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367a9x0bhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 08:25:47 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LDPjhx017633;
        Thu, 21 Jan 2021 13:25:45 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3668p4gv8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 13:25:45 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LDPgT036307262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 13:25:42 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A34B7A4055;
        Thu, 21 Jan 2021 13:25:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D5F5A4040;
        Thu, 21 Jan 2021 13:25:42 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.36.14])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 13:25:42 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 3/3] s390x: css: pv: css test adaptation
 for PV
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        drjones@redhat.com, pbonzini@redhat.com
References: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
 <1611220392-22628-4-git-send-email-pmorel@linux.ibm.com>
 <15b91686-97a0-5811-914c-a805dda58f57@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <cc0e5de8-f860-c333-690d-452731e871e7@linux.ibm.com>
Date:   Thu, 21 Jan 2021 14:25:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <15b91686-97a0-5811-914c-a805dda58f57@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_06:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/21/21 10:35 AM, Thomas Huth wrote:
> On 21/01/2021 10.13, Pierre Morel wrote:
>> We want the tests to automatically work with or without protected
>> virtualisation.
>> To do this we need to share the I/O memory with the host.
>>
>> Let's replace all static allocations with dynamic allocations
>> to clearly separate shared and private memory.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     |  3 +--
>>   lib/s390x/css_lib.c | 28 ++++++++--------------------
>>   s390x/css.c         | 43 +++++++++++++++++++++++++++++++------------
>>   3 files changed, 40 insertions(+), 34 deletions(-)
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
