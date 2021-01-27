Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223A6305BCD
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 13:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhA0Mn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 07:43:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52328 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237143AbhA0Ml0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 07:41:26 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10RC4tAR049520;
        Wed, 27 Jan 2021 07:40:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2cSXyj4fDwzmy6RsBcc8uulqfiOIY/ec/6zq2NYUAGI=;
 b=G3F7xCXNRxqfVFp70FAwE91MV+dopeJ07lfgtEh+SB6HyvXkfQMbpFzpzXfnIUDZCOpn
 F5ZB6/LThX96JaB13nwQuBiDKERAJXOM3HpEJ1ZvdOf17A26b/bDvToz6Zs/5xpTFHAT
 yA5zf9WsxLg2SNODYp6xOSSReF4YsIJo/B5TQ09jQ/y0/CyPpG9gEaD7s5ELgcv+NA66
 8Jt73yiQ6OQxtmNKgeymNRfRYPSXoVkjefqdOizTLEcj+Dioji/o+A14VTi2z8KVW7Hq
 mak33hY3qdOTfMZmcX17DlmtTwOydoSapptBzDgz3lA7sYpFz2ziIZ8nYwvkaoSrhJ9d 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36b5tcvg7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 07:40:46 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10RC5cPg053736;
        Wed, 27 Jan 2021 07:40:45 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36b5tcvg6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 07:40:45 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10RCW6Ls012855;
        Wed, 27 Jan 2021 12:40:43 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 368be7ut89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 12:40:43 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10RCeeFE36962756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 12:40:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D369A4057;
        Wed, 27 Jan 2021 12:40:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0D49A404D;
        Wed, 27 Jan 2021 12:40:39 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.51.19])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Jan 2021 12:40:39 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 0/3] s390x: css: pv: css test adaptation
 for PV
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, drjones@redhat.com,
        pbonzini@redhat.com
References: <1611322060-1972-1-git-send-email-pmorel@linux.ibm.com>
 <6c141deb-819a-ef03-f44c-bd61561a2087@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <6e253468-160c-fc5b-65fc-56e8a8c67758@linux.ibm.com>
Date:   Wed, 27 Jan 2021 13:40:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6c141deb-819a-ef03-f44c-bd61561a2087@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_05:2021-01-27,2021-01-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 clxscore=1015 mlxscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/27/21 1:37 PM, Janosch Frank wrote:
> On 1/22/21 2:27 PM, Pierre Morel wrote:
>> Hi all,
>>    
>> To adapt the CSS I/O tests to protected virtualisation we need
>> utilities to:
>>
>> 1- allocate the I/O buffers in a private page using (patch 2)
>>     It must be in a dedicated page to avoid exporting code or
>>     guest private data to the host.
>>     We accept a size in byte and flags and allocate page integral
>>     memory to handle the Protected Virtualization.
>>   
>> 2- share the I/O buffers with the host (patch 1)
>>     This patch uses the page allocator reworked by Claudio.
>>   
>> The 2 first patches are the implementation of the tools,
>> patch 3 is the modification of the css.c test for PV.
>>
>> The checkpatch always asked me to modify MAINTAINERS,
>> so I added me as reviewer to be in copy for CSS at least.
>> May be we could create a finer grain MAINTAINERS in the
>> future.
>>
>> regards,
>> Pierre
> 
> Thanks, picked.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
