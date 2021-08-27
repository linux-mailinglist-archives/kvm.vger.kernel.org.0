Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F06F3F9754
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 11:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244800AbhH0Jkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 05:40:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64624 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244851AbhH0Jki (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 05:40:38 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17R9arJJ134419
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 05:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IoCPv0M785LuAg27T7On72+jHLNyDcSPFxPdLOULCM8=;
 b=j0F3EggjZ0USkLdi22pRTpCv8YBJHmSDxIGZtkPvQCfocb43RknbNn/JaZcyCJ2VQXHE
 MMw+vZPYwRqc4rRz+zupMC2oIJJmp+8t3iCrK6GXF752hkb7wXTmznt7KeYpn/Rg2QxN
 C17banmniNKv6xeRRmbqPJr7okYPYmwVZ7m8cmWzjeeQcybfdqv42OjQIQ/VU8vVPtfM
 mFu98vY/NDsocfIXkoj9xYZvCaoUBK3Z9UheWY7IHv7m9UXrt0579NBOM8if6KSKhvY7
 RBdGJ8Jyc5X0hQgnH4WVXTNFUsrThuZJzH6eItksnbdLHiJNnmeaHwQqdgQiPaCpxCOa ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3apvt7h98a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 05:39:49 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17R9dWPS151380
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 05:39:48 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3apvt7h97m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 05:39:48 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17R9dRi0020841;
        Fri, 27 Aug 2021 09:39:47 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3ajs48sdkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Aug 2021 09:39:46 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17R9dh8b55706046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 09:39:43 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35EDD4204C;
        Fri, 27 Aug 2021 09:39:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBE8F4203F;
        Fri, 27 Aug 2021 09:39:42 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.164.230])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Aug 2021 09:39:42 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: fixing I/O memory allocation
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
References: <1629908421-8543-1-git-send-email-pmorel@linux.ibm.com>
 <1629908421-8543-3-git-send-email-pmorel@linux.ibm.com>
 <20210825183101.32d091f2@p-imbrenda>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <9b947b00-0623-cfa6-cb0b-2d0b638c0fa6@linux.ibm.com>
Date:   Fri, 27 Aug 2021 11:39:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210825183101.32d091f2@p-imbrenda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mhf4PRuN1s_8R_tD7LgxOaZUC_3hoPxT
X-Proofpoint-ORIG-GUID: Dkule6OiMvum7vWqSPtueQ-vgLegaNbR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_03:2021-08-26,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108270060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/25/21 6:31 PM, Claudio Imbrenda wrote:
> On Wed, 25 Aug 2021 18:20:21 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> The allocator allocate pages it follows the size must be rounded
>> to pages before the allocation.
>>
>> Fixes: b0fe3988 "s390x: define UV compatible I/O allocation"
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 


Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
