Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0329A336FBB
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 11:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhCKKTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 05:19:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48532 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232213AbhCKKTj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Mar 2021 05:19:39 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12BA3qn3062514
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 05:19:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Jsc8ii+lmBdflKLVjVEim3z5AVMlc5GFl51hE/fMqpQ=;
 b=CQhUJ90m8dowERT0krV3264pflrpzJjn29DHeX3DAa5nJ1UZg/ywzx7in0yNtMslY9us
 qtl//81DJXCCWfXvC1C0SiC1JVf0qN5N+g3xSDyEFXe4kcE9vrG8eeshpwb1VxrZHu3l
 qBhBGXCfusMIq+dTQIVUfmCgTZDZwh5tjmMlsdcTbgyHuTl/HL49JI7xxzfHkc94ALGq
 BQE2/wPCTZysmR5njlAkyUoyJTEJDgrGXQI1M0NVYyKwTf8smYZrsbG0i4cBAcr5QUcK
 zn90gqJ5y74d2/MXAIIkHNCe4RWHJm/j9C/KxRZTbS/KgAFTrwXW/W8/Vi5DV7kznaZ4 LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774m2ten3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 05:19:39 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12BA6Tfe074553
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 05:19:38 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774m2temc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 05:19:38 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12BAFBKN013177;
        Thu, 11 Mar 2021 10:19:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3768urssxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 10:19:36 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12BAJXpQ58065358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 10:19:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C9A711C058;
        Thu, 11 Mar 2021 10:19:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07D2611C050;
        Thu, 11 Mar 2021 10:19:33 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.87.106])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Mar 2021 10:19:32 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 0/6] CSS Mesurement Block
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
 <20210309175401.6302833e.cohuck@redhat.com>
 <20210309180834.14945da1.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <a9d290eb-cc81-1e1e-ae38-8e2aa6307b68@linux.ibm.com>
Date:   Thu, 11 Mar 2021 11:19:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210309180834.14945da1.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_04:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 clxscore=1015 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103110053
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/9/21 6:08 PM, Cornelia Huck wrote:
> On Tue, 9 Mar 2021 17:54:01 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
>> On Tue,  9 Mar 2021 13:51:11 +0100
>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>
>>> We tests the update of the Mesurement Block (MB) format 0
>>> and format 1 using a serie of senseid requests.
>>>
>>> *Warning*: One of the tests for format-1 will unexpectedly fail for QEMU elf
>>> unless the QEMU patch "css: SCHIB measurement block origin must be aligned"
>>> is applied.
>>
>> That one has hit QEMU master by now.
>>
>>> With Protected Virtualization, the PGM is correctly recognized.
>>>
>>> The MB format 1 is only provided if the Extended mesurement Block
>>> feature is available.
>>>
>>> This feature is exposed by the CSS characteristics general features
>>> stored by the Store Channel Subsystem Characteristics CHSC command,
>>> consequently, we implement the CHSC instruction call and the SCSC CHSC
>>> command.
>>>
>>> In order to ease the writing of new tests using:
>>> - interrupt
>>> - enablement of a subchannel
>>> - multiple I/O on a subchannel
>>>
>>> We do the following simplifications:
>>> - we create a CSS initialization routine
>>> - we register the I/O interrupt handler on CSS initialization
>>> - we do not enable or disable a subchannel in the senseid test,
>>>    assuming this test is done after the enable test, this allows
>>>    to create traffic using the SSCH used by senseid.
>>> - failures not part of the feature under test will stop the tests.
>>> - we add a css_enabled() function to test if a subchannel is enabled.
>>>
>>> *note*:
>>>      I rearranged the use of the senseid for the tests, by not modifying
>>>      the existing test and having a dedicated senseid() function for
>>>      the purpose of the tests.
>>>      I think that it is in the rigght way so I kept the RB and ACK on
>>>      the simplification, there are less changes, if it is wrong from me
>>>      I suppose I will see this in the comments.
>>>      Since the changed are moved inside the fmt0 test which is not approved
>>>      for now I hope it is OK.
>>
>> I'll double-check, but I think it should be ok.
> 
> ...that said, I found some reordering issues, but nothing major;
> generally, it looks good to me.


Thanks,
so I do the reordering and respin for hopefully the right series :)

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
