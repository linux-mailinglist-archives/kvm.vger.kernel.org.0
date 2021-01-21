Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C972FEF78
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 16:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387471AbhAUPuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 10:50:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387569AbhAUPsb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 10:48:31 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LFVOxY101187;
        Thu, 21 Jan 2021 10:47:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3Dec8wLOx/92MhKjbVUcL1uNc/roAsWSahXYpVevpRk=;
 b=GXu3gItna+LrtM2ScHQD3Klpo0xod1o5FTBRpowUYWzPTDC1fjtX1VZu7CNkjhxAxW/V
 9PYPwqUV0sC4KoDYPu9wmE1yX9EljZUMPvYhajvwi6XNIGZKTBG3RH/7Kx5sqEwb1SWX
 q8nptn5Kj3BazVFLJqHY7wqMlWtcIwn0Tid1Npc+0cAgsaeWXb3yjZnj/OVIAYVtxOqe
 1+mlyNXoQmOunCxCb/xwrDtRuuRqP/xeWfvbnRwZsdU8mI6CbUv7+/XqE4LhGTXS9qKZ
 QE9DrC8orouHO7kF6EVCmMm05fedP/P/KsVjiSEJRq+tnaNN4yyO0NAUGtDcRJFfq8Sf Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 367btaa5b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 10:47:50 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LFVrnQ104471;
        Thu, 21 Jan 2021 10:47:50 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 367btaa5a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 10:47:50 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LFVlpR022303;
        Thu, 21 Jan 2021 15:47:48 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3668passxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 15:47:48 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LFljhT34603502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 15:47:45 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FD66A405B;
        Thu, 21 Jan 2021 15:47:45 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 119E1A4040;
        Thu, 21 Jan 2021 15:47:45 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.36.14])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 15:47:44 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 2/3] s390x: define UV compatible I/O
 allocation
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com, pbonzini@redhat.com
References: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
 <1611220392-22628-3-git-send-email-pmorel@linux.ibm.com>
 <6c232520-dbd1-80e4-e3a3-949964df7403@linux.ibm.com>
 <3bce47db-c58c-6a2e-be72-9953f16a2dd4@linux.ibm.com>
 <0a46a299-c52d-2c7f-bb38-8d58afe053e0@redhat.com>
 <ab6a5d6d-29e1-4ccd-64dd-6e39888cb439@linux.ibm.com>
 <e32a6fba-0d93-3468-e180-f9b157146daf@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <c6fce8e1-80a0-4484-7812-b6f31c2c073a@linux.ibm.com>
Date:   Thu, 21 Jan 2021 16:47:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <e32a6fba-0d93-3468-e180-f9b157146daf@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_08:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 suspectscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210085
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/21/21 2:56 PM, Thomas Huth wrote:
> On 21/01/2021 14.47, Pierre Morel wrote:
> [...]
>> For MAINTAINERS, the Linux kernel checkpatch warns that we should use
>> TABS instead of SPACES between item and names.
> 
> Interesting, I wasn't aware of that. I guess it's simply because the 
> MAINTAINERS file in kvm-unit-tests is older than the patch that changed 
> the checkpatch script in the kernel, and updates to the MAINTAINRS file 
> in k-u-t are so seldom that nobody really noticed afterwards.
> 
> If it bothers you, feel free to send a patch to fix k-u-t's MAINTAINERS 
> file, it might be nice indeed to be aligned with the kernel here again.
> 
>   Thomas
> 
> 

OK, I will do,
Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
