Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D467F3EA3E5
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 13:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbhHLLkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 07:40:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58246 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231467AbhHLLkf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 07:40:35 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17CBY8YJ184343;
        Thu, 12 Aug 2021 07:40:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ETmmV3/MeYC1T4rSYRlZzKKPb8AAdyfEXyTbV5sWD/s=;
 b=V6/qPqyxsXRWNnZJ4tHu5thnlkmP9UcsCo7fwYhQxOV69MXMqr9T79XITONeAW0NS391
 JCeRlOI64Cny8igBt592LE1XZwV90VaJUNA+NfGi2vgIboW7IpiWoxCP2cn8OR+PWbLm
 0G0SJK/8x8qYJ39ZvlIbMegViU9+wRSNe8++7MYGLhxidQxBZkSprkSwFrUv649dCT/v
 7BFhJWNZ0HbHG+L3m+oG9sKSyZCciakJAXRTXMu9Q1qcSf3g2mEud3BTvxHW8BooilT4
 X4dXIAFrFlyDFAH1WSIu3lxnd5cDozmZFOMkdhcTRUDV2q/qT9LivQXfEb3oQ90h7m9B qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad06gdppt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 07:40:09 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17CBYNKJ185408;
        Thu, 12 Aug 2021 07:40:09 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad06gdpp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 07:40:09 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17CBcPfO025038;
        Thu, 12 Aug 2021 11:40:07 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3acfpg99ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 11:40:07 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17CBe3X655509336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 11:40:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A08C4C063;
        Thu, 12 Aug 2021 11:40:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF77E4C052;
        Thu, 12 Aug 2021 11:40:02 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.85.233])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Aug 2021 11:40:02 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 3/4] s390x: topology: Check the Perform
 Topology Function
To:     Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
 <1628612544-25130-4-git-send-email-pmorel@linux.ibm.com>
 <ae1eb2bc-8570-d114-9f45-4aaf40d23d3f@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <d346d79c-4f72-cbcf-7aef-9c9a03cd61ec@linux.ibm.com>
Date:   Thu, 12 Aug 2021 13:40:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <ae1eb2bc-8570-d114-9f45-4aaf40d23d3f@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GcHn7TEP8aWoEMfaWweJe1EM62K_h4DO
X-Proofpoint-GUID: F3tuGSV69I0JipEFdPiaKbXvpugI7GpN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-12_04:2021-08-12,2021-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108120075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/12/21 11:38 AM, Janosch Frank wrote:
> On 8/10/21 6:22 PM, Pierre Morel wrote:
>> We check the PTF instruction.
>>
>> - We do not expect to support vertical polarization.
> 
> KVM does not support vertical polarization and we don't expect it to be
> added in the future?

OK

> 
>>
>> - We do not expect the Modified Topology Change Report to be
>> pending or not at the moment the first PTF instruction with
>> PTF_CHECK function code is done as some code already did run
>> a polarization change may have occur.
> 
> ENOPARSE

OK I find another way to explain:

"
The Topology changes if the topology of the real CPUs backing the vCPUs 
changes.
This can happen between the initialization of the VM and the start of 
the guest.
As a consequence we can not expect the result of the first PTF instruction.
"
...
>> +	/*
>> +	 * In the LPAR we can not assume the state of the polarizatiom
> 
> polarization

yes

> 
>> +	 * at this moment.
>> +	 * Let's skip the tests for LPAR.
>> +	 */
> 
> Any idea what happens on z/VM?
> We don't necessarily need to support z/VM but we at least need to skip
> like we do on lpar :-)

No, I do not know.
Then OK we skip the test for zVM too

> 
> Maybe also add a TODO, so we know we could improve the test?
> 
>> +	if (machine_level < 3)
>> +		goto end;
>> +
> 
> Add comments:
> We're always horizontally polarized in KVM.

OK

> 
>> +	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
>> +	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
>> +	       "PTF horizontal already configured");
>> +
> 
> KVM doesn't support vertical polarization.

OK too

> 
>> +	cc = ptf(PTF_REQ_VERTICAL, &rc);
>> +	report(cc == 2 && rc == PTF_ERR_NO_REASON,
>> +	       "PTF vertical non possible");
> 
> s/non/not/

yes, seems I forgot to change this.

...


Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
