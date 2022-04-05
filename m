Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD874F4993
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442836AbiDEWTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454194AbiDEP6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 11:58:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC2B169B2F;
        Tue,  5 Apr 2022 08:03:30 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235DWSsS015100;
        Tue, 5 Apr 2022 15:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kWjQMYfk1AG+xyWV+LOmEg/Nsxt7nzoqkaOys+fqmaI=;
 b=Ox2JSU3zeaNG8Q6/LL1VQ58mhM27hRLVD5FXxgT5WgHuXw3ON0ebnQL0Slaygi3GmqiG
 6wCJd4FiM6aMrbKRGjvAaB/Apm/l3iJsPJV+27CITNSAqrc2EaCl60b+0bOPvBe/fiFJ
 AD4/0QZTFpfRzh0hnwvcqEBmMZAdVV4+lEnAEN4IdQksY8RPsShsdRU1MeN2CWpVElyN
 UA8afs4jnR4Kbl61KG2uzfuDKuEKOienpYBwRBr7TPxxGI5tJ4Cxyun9zWMjjNQqyMgx
 CLtZd4erinolr5wL0FOajZuIrNLkdKgEmlZztRfBcUvWMGBNXsjU/WCxJ5ADJHm68SJs Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f8n6qmeyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 15:03:29 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 235DWXQc015608;
        Tue, 5 Apr 2022 15:03:29 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f8n6qmexq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 15:03:29 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 235F3CCP009010;
        Tue, 5 Apr 2022 15:03:27 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3f6e48x10y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 15:03:26 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 235F3Nok38207980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 15:03:23 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F437A4040;
        Tue,  5 Apr 2022 15:03:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57A37A404D;
        Tue,  5 Apr 2022 15:03:22 +0000 (GMT)
Received: from [9.171.66.169] (unknown [9.171.66.169])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 15:03:22 +0000 (GMT)
Message-ID: <2978f1c7-e299-a385-9ef3-5ee796b134e4@linux.ibm.com>
Date:   Tue, 5 Apr 2022 17:06:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 14/21] KVM: s390: pci: provide routines for
 enabling/disabling interrupt forwarding
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
 <20220404174349.58530-15-mjrosato@linux.ibm.com>
 <9a551f04c3878ecb3a26fed6aff2834fbfe41f18.camel@linux.ibm.com>
 <7196af99-fcfa-c9a6-a245-c15268c6851b@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <7196af99-fcfa-c9a6-a245-c15268c6851b@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ch0IAO81t8SfZ7nOV3dnHL24lRQ8XSIM
X-Proofpoint-GUID: bAcl5T6iJp8Wwm6dPQSQjmGwA7Wo8-7X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-05_04,2022-04-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204050084
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/5/22 15:48, Matthew Rosato wrote:
> On 4/5/22 9:39 AM, Niklas Schnelle wrote:
>> On Mon, 2022-04-04 at 13:43 -0400, Matthew Rosato wrote:
>>> These routines will be wired into a kvm ioctl in order to respond to
>>> requests to enable / disable a device for Adapter Event Notifications /
>>> Adapter Interuption Forwarding.
>>>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>>>   arch/s390/kvm/pci.c      | 247 +++++++++++++++++++++++++++++++++++++++
>>>   arch/s390/kvm/pci.h      |   1 +
>>>   arch/s390/pci/pci_insn.c |   1 +
>>>   3 files changed, 249 insertions(+)
>>>
>>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
>>> index 01bd8a2f503b..f0fd68569a9d 100644
>>> --- a/arch/s390/kvm/pci.c
>>> +++ b/arch/s390/kvm/pci.c
>>> @@ -11,6 +11,7 @@
>>>   #include <linux/pci.h>
>>>   #include <asm/pci.h>
>>>   #include <asm/pci_insn.h>
>>> +#include <asm/pci_io.h>
>>>   #include "pci.h"
>>>   struct zpci_aift *aift;
>>> @@ -152,6 +153,252 @@ int kvm_s390_pci_aen_init(u8 nisc)
>>>       return rc;
>>>   }
>>> +/* Modify PCI: Register floating adapter interruption forwarding */
>>> +static int kvm_zpci_set_airq(struct zpci_dev *zdev)
>>> +{
>>> +    u64 req = ZPCI_CREATE_REQ(zdev->fh, 0, ZPCI_MOD_FC_REG_INT);
>>> +    struct zpci_fib fib = {};
>>
>> Hmm this one uses '{}' as initializer while all current callers of
>> zpci_mod_fc() use '{0}'. As far as I know the empty braces are a GNU
>> extension so should work for the kernel but for consistency I'd go with
>> '{0}' or possibly '{.foo = bar, ...}' where that is more readable.
>> There too uninitialized fields will be set to 0. Unless of course there
>> is a conflicting KVM convention that I don't know about.
> 
> No convention that I'm aware of, I previously had fib = {0} based on the 
> same rationale you describe and changed to fib = {} per review request 
> from Pierre a few versions back.  I don't have a strong preference, but 
> I did not note any functional difference between the two and see a bunch 
> of examples of both methods throughout the kernel.
> 

Was stupid of me to comment that, as you said there are no difference, 
so do as you want.


-- 
Pierre Morel
IBM Lab Boeblingen
