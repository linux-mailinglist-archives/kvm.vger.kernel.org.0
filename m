Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75CC338FA8
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 15:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhCLORy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 09:17:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231416AbhCLORl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 09:17:41 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12CEF0Fs132016
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 09:17:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fup/ukSrk61MyOON86dti+w76iTu9GSvQzp96yDASEk=;
 b=BLcisFPd7nmpiLBm/AHW6kQyPNk7LiXnGu+/tK/WcU9+xYBgrBzOvXURWH2+5wyebXia
 aGJvCkfOXdmVccF5uDNmbjhrHFmwipN+drybFfmR3H/AiYsnJ6Bge1V/fD1F6C8X5uNM
 PMJV/9pUSk9rfG9h7HreKJSBOjKjldeNrmSgvNIKmCp2ymoEzigQ7nt7g82HyF/S5lDl
 j3FH6Qfr5yeBm4cUDAAP4iKWUiUjd+Y1gFV34dS/2/ohCmBpaJmWDKCAvIXiHaIzuuOi
 I81Wl4y08LUQGZkiGPejs02ywiy5U4XyYM07yyUnKgqwg8pii073UQhM2t+BVOl+lBTf Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3787pr3vhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 09:17:41 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12CEF3Hs132440
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 09:17:41 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3787pr3vg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 09:17:41 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12CEHdCP015027;
        Fri, 12 Mar 2021 14:17:39 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3768urtxg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 14:17:38 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12CEHZGS16056606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 14:17:36 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3507AE05F;
        Fri, 12 Mar 2021 14:17:35 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AF23AE061;
        Fri, 12 Mar 2021 14:17:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.26.86])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Mar 2021 14:17:35 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 0/6] CSS Mesurement Block
To:     Cornelia Huck <cohuck@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
References: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
 <20210312121805.4fab030c.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <3e422288-77d5-3869-ba21-64b4fe2f2551@linux.ibm.com>
Date:   Fri, 12 Mar 2021 15:17:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210312121805.4fab030c.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-12_03:2021-03-10,2021-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103120101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/12/21 12:18 PM, Cornelia Huck wrote:
> On Fri, 12 Mar 2021 11:41:48 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We tests the update of the Mesurement Block (MB) format 0
>> and format 1 using a serie of senseid requests.
>>
>> *Warning*: One of the tests for format-1 will unexpectedly fail for QEMU elf
>> unless the QEMU patch "css: SCHIB measurement block origin must be aligned"
>> is applied.
>> This patch has recently hit QEMU master ...
>> With Protected Virtualization, the PGM is correctly recognized.
>>
>> The MB format 1 is only provided if the Extended mesurement Block
>> feature is available.
>>
>> This feature is exposed by the CSS characteristics general features
>> stored by the Store Channel Subsystem Characteristics CHSC command,
>> consequently, we implement the CHSC instruction call and the SCSC CHSC
>> command.
>>
>> In order to ease the writing of new tests using:
>> - interrupt
>> - enablement of a subchannel
>> - multiple I/O on a subchannel
>>
>> We do the following simplifications:
>> - we create a CSS initialization routine
>> - we register the I/O interrupt handler on CSS initialization
>> - we do not enable or disable a subchannel in the senseid test,
>>   assuming this test is done after the enable test, this allows
>>   to create traffic using the SSCH used by senseid.
>> - failures not part of the feature under test will stop the tests.
>> - we add a css_enabled() function to test if a subchannel is enabled.
>>
>> *note*:
>>     I rearranged the use of the senseid for the tests, by not modifying
>>     the existing test and having a dedicated senseid() function for
>>     the purpose of the tests.
>>     I think that it is in the rigght way so I kept the RB and ACK on
>>     the simplification, there are less changes, if it is wrong from me
>>     I suppose I will see this in the comments.
>>     Since the changed are moved inside the fmt0 test which is not approved
>>     for now I hope it is OK.
>>
>> Regards,
>> Pierre
>>
>> Pierre Morel (6):
>>   s390x: css: Store CSS Characteristics
>>   s390x: css: simplifications of the tests
>>   s390x: css: extending the subchannel modifying functions
>>   s390x: css: implementing Set CHannel Monitor
>>   s390x: css: testing measurement block format 0
>>   s390x: css: testing measurement block format 1
>>
>>  lib/s390x/css.h     | 115 ++++++++++++++++++++-
>>  lib/s390x/css_lib.c | 236 ++++++++++++++++++++++++++++++++++++++++----
>>  s390x/css.c         | 216 ++++++++++++++++++++++++++++++++++++++--
>>  3 files changed, 539 insertions(+), 28 deletions(-)
>>
> 
> Series looks good to me.
> 

@Pierre: Could you please push to devel?

Let's give it a whirl on the CI over the weekend and I'll have another
look at the patches at Monday before picking.
