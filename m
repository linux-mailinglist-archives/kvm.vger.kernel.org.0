Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DBA54AC99
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 10:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356094AbiFNIxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 04:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355948AbiFNIwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 04:52:55 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9F9F4C;
        Tue, 14 Jun 2022 01:52:42 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25E7sKMB028296;
        Tue, 14 Jun 2022 08:52:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=gyfDtNZz1cmWrxBXHGNepl/UxgVnK4jomTFCZjnc4dc=;
 b=HpDw6kfIM0irn+zMgd2gnZhv/0EHn2vHwqz0gFrjSwL58MztnsZ0PGYQs29FGrPpJ2QS
 bOs2w46m9XMKzpkz76L73tdm8v3yqfLKDzg9HOv1k723L7K/NFOkZ6luYE8wFV7salN5
 upBrNK4ZKdIiTivaKodzh1tDshugF6zbasx/1WfaKhKf/BJ52eO7fLfoN0iAnWC8fCCs
 d1dy3JzUklUWz5c0W7xCaZF3mjOXpGjVWCQCIZ+ZaI2M8kSyCXt+axHxpMhh/cVFDLXi
 Ghb1MUZQv7g3KsBr3AgPjEJgip263Of+lIzzhbaLKODBadd/ShIDlbqlFFtrhI87q9+Q kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gppbqsens-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 08:52:39 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25E8nQUu022648;
        Tue, 14 Jun 2022 08:52:39 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gppbqsen6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 08:52:39 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25E8oRfb023979;
        Tue, 14 Jun 2022 08:52:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3gmjp934mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 08:52:37 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25E8qXKB22675716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 08:52:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A05DCAE051;
        Tue, 14 Jun 2022 08:52:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6720CAE04D;
        Tue, 14 Jun 2022 08:52:32 +0000 (GMT)
Received: from [9.171.87.27] (unknown [9.171.87.27])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jun 2022 08:52:32 +0000 (GMT)
Message-ID: <69ec8abd-c579-46d0-08cd-2714de91b6cb@linux.ibm.com>
Date:   Tue, 14 Jun 2022 10:56:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v9 10/21] vfio/pci: introduce CONFIG_VFIO_PCI_ZDEV_KVM
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
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
 <ac5cd90a-c92b-1bad-fbec-d1ca6287e826@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <ac5cd90a-c92b-1bad-fbec-d1ca6287e826@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZsTgDjDy4c79eKKmtexsZutRAXlU9BZm
X-Proofpoint-ORIG-GUID: kMmIYTe2BBcz5s1DeyMpSniHFDveLBEC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_02,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 impostorscore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206140033
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/8/22 15:15, Matthew Rosato wrote:
> On 6/8/22 2:19 AM, Thomas Huth wrote:
>> On 06/06/2022 22.33, Matthew Rosato wrote:
>>> The current contents of vfio-pci-zdev are today only useful in a KVM
>>> environment; let's tie everything currently under vfio-pci-zdev to
>>> this Kconfig statement and require KVM in this case, reducing complexity
>>> (e.g. symbol lookups).
>>>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>


>>> ---
>>>   drivers/vfio/pci/Kconfig      | 11 +++++++++++
>>>   drivers/vfio/pci/Makefile     |  2 +-
>>>   include/linux/vfio_pci_core.h |  2 +-
>>>   3 files changed, 13 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
>>> index 4da1914425e1..f9d0c908e738 100644
>>> --- a/drivers/vfio/pci/Kconfig
>>> +++ b/drivers/vfio/pci/Kconfig
>>> @@ -44,6 +44,17 @@ config VFIO_PCI_IGD
>>>         To enable Intel IGD assignment through vfio-pci, say Y.
>>>   endif
>>> +config VFIO_PCI_ZDEV_KVM
>>> +    bool "VFIO PCI extensions for s390x KVM passthrough"
>>> +    depends on S390 && KVM
>>> +    default y
>>> +    help
>>> +      Support s390x-specific extensions to enable support for 
>>> enhancements
>>> +      to KVM passthrough capabilities, such as interpretive 
>>> execution of
>>> +      zPCI instructions.
>>> +
>>> +      To enable s390x KVM vfio-pci extensions, say Y.
>>
>> Is it still possible to disable CONFIG_VFIO_PCI_ZDEV_KVM ? Looking at 
>> the later patches (e.g. 20/21 where you call kvm_s390_pci_zpci_op() 
>> from kvm-s390.c), it rather seems to me that it currently cannot be 
>> disabled independently (as long as KVM is enabled).
> 
> Yes, you can build with, for example, CONFIG_VFIO_PCI_ZDEV_KVM=n and 
> CONFIG_KVM=m -- I tested it again just now.  The result is kvm and 
> vfio-pci are built and vfio-pci works, but none of the vfio-pci-zdev 
> extensions are available (including zPCI interpretation).
> 
> This is accomplished via the placement of some IS_ENABLED checks.  Some 
> calls (e.g. AEN init) are fenced by 
> IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM).  There are also some areas that 
> are fenced off via a call to kvm_s390_pci_interp_allowed() which also 
> includes an IS_ENABLED check along with checks for facility and cpu id.
> 
> Using patch 20 as an example, KVM_CAP_S390_ZPCI_OP will always be 
> reported as unavailable to userspace if CONFIG_VFIO_PCI_ZDEV_KVM=n due 
> to the call to kvm_s390_pci_interp_allowed().  If userspace sends us the 
> ioctl anyway, we will return -EINVAL because there is again a 
> IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) check before we read the ioctl args 
> from userspace.

Yes and the code will not be generated by the compiler in patch 20 after 
the break if CONFIG_VFIO_PCI_ZDEV_KVM is not enabled.

+	case KVM_S390_ZPCI_OP: {
+		struct kvm_s390_zpci_op args;
+
+		r = -EINVAL;
+		if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
+			break;

Code not generated----v

+		if (copy_from_user(&args, argp, sizeof(args))) {
+			r = -EFAULT;
+			break;
+		}
+		r = kvm_s390_pci_zpci_op(kvm, &args);
+		break;

----------^

+	}
> 
>>
>> So if you want to make this selectable by the user, I think you have 
>> to put some more #ifdefs in the following patches.
>> But if this was not meant to be selectable by the user, I think it 
>> should not get a help text and rather be selected by the KVM switch in 
>> arch/s390/kvm/Kconfig instead of having a "default y".
>>
>>   Thomas
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
