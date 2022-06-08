Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D0554312B
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 15:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239971AbiFHNQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 09:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239852AbiFHNP6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 09:15:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDD6220C5;
        Wed,  8 Jun 2022 06:15:57 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258CFwq2017941;
        Wed, 8 Jun 2022 13:15:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=yxIq4JKxKZh9YG+pXpusvvjdP7ynYnDFZXORb16tXik=;
 b=lIOhuNeYHniLCDjW9Tl9xLm4qL1QohBVqgdnbvDZ+4sKavNZXgA+1KUk47bR+qR5+pFb
 Gnmg/HIT1xjqE814MDZSEgl7rY+iDMAgIgEAePjD/tvmETke/gZf67MwK/5yNHuz5FzB
 XOQKznqYQJgjEDBnUe35kQlTS9BcbIPfF+7SX7j07+eW0XyP1egJLiBI1RpbqyhO5F7c
 yCQT9Rz7GlheYZgISgm7WKMloatmfo3FhVeZk8gub5FwdzqfXqr/9r/P6bbaWgxCUQ4S
 1dGHnxOpkPHYvYlQSyuoWQ+ROM8MmMfVRYLYPpzW1AgFAMdrfCh859hDt8G0mXz/eueS VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjum699yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:15:52 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258CGn13019849;
        Wed, 8 Jun 2022 13:15:52 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjum699y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:15:51 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258D5Nrr006325;
        Wed, 8 Jun 2022 13:15:51 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 3gfy1at693-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:15:51 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258DFnZx32244096
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 13:15:49 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5539BE051;
        Wed,  8 Jun 2022 13:15:49 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC503BE04F;
        Wed,  8 Jun 2022 13:15:47 +0000 (GMT)
Received: from [9.163.20.188] (unknown [9.163.20.188])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jun 2022 13:15:47 +0000 (GMT)
Message-ID: <ac5cd90a-c92b-1bad-fbec-d1ca6287e826@linux.ibm.com>
Date:   Wed, 8 Jun 2022 09:15:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v9 10/21] vfio/pci: introduce CONFIG_VFIO_PCI_ZDEV_KVM
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
 <20220606203325.110625-11-mjrosato@linux.ibm.com>
 <025699e6-b870-2648-d4a4-ffbc5fff22e8@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <025699e6-b870-2648-d4a4-ffbc5fff22e8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: v-6SOwnMCNAsHTL-AduCL7y1U5-h_YeS
X-Proofpoint-ORIG-GUID: 8HuHCNlCigvg6ddKUBqWfahKcMburMh-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_04,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 mlxscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206080056
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/22 2:19 AM, Thomas Huth wrote:
> On 06/06/2022 22.33, Matthew Rosato wrote:
>> The current contents of vfio-pci-zdev are today only useful in a KVM
>> environment; let's tie everything currently under vfio-pci-zdev to
>> this Kconfig statement and require KVM in this case, reducing complexity
>> (e.g. symbol lookups).
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   drivers/vfio/pci/Kconfig      | 11 +++++++++++
>>   drivers/vfio/pci/Makefile     |  2 +-
>>   include/linux/vfio_pci_core.h |  2 +-
>>   3 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>> index 4da1914425e1..f9d0c908e738 100644
>> --- a/drivers/vfio/pci/Kconfig
>> +++ b/drivers/vfio/pci/Kconfig
>> @@ -44,6 +44,17 @@ config VFIO_PCI_IGD
>>         To enable Intel IGD assignment through vfio-pci, say Y.
>>   endif
>> +config VFIO_PCI_ZDEV_KVM
>> +    bool "VFIO PCI extensions for s390x KVM passthrough"
>> +    depends on S390 && KVM
>> +    default y
>> +    help
>> +      Support s390x-specific extensions to enable support for 
>> enhancements
>> +      to KVM passthrough capabilities, such as interpretive execution of
>> +      zPCI instructions.
>> +
>> +      To enable s390x KVM vfio-pci extensions, say Y.
> 
> Is it still possible to disable CONFIG_VFIO_PCI_ZDEV_KVM ? Looking at 
> the later patches (e.g. 20/21 where you call kvm_s390_pci_zpci_op() from 
> kvm-s390.c), it rather seems to me that it currently cannot be disabled 
> independently (as long as KVM is enabled).

Yes, you can build with, for example, CONFIG_VFIO_PCI_ZDEV_KVM=n and 
CONFIG_KVM=m -- I tested it again just now.  The result is kvm and 
vfio-pci are built and vfio-pci works, but none of the vfio-pci-zdev 
extensions are available (including zPCI interpretation).

This is accomplished via the placement of some IS_ENABLED checks.  Some 
calls (e.g. AEN init) are fenced by 
IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM).  There are also some areas that 
are fenced off via a call to kvm_s390_pci_interp_allowed() which also 
includes an IS_ENABLED check along with checks for facility and cpu id.

Using patch 20 as an example, KVM_CAP_S390_ZPCI_OP will always be 
reported as unavailable to userspace if CONFIG_VFIO_PCI_ZDEV_KVM=n due 
to the call to kvm_s390_pci_interp_allowed().  If userspace sends us the 
ioctl anyway, we will return -EINVAL because there is again a 
IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) check before we read the ioctl args 
from userspace.

> 
> So if you want to make this selectable by the user, I think you have to 
> put some more #ifdefs in the following patches.
> But if this was not meant to be selectable by the user, I think it 
> should not get a help text and rather be selected by the KVM switch in 
> arch/s390/kvm/Kconfig instead of having a "default y".
> 
>   Thomas
> 

