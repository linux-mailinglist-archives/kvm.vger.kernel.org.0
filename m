Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9961E4B15AF
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 20:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbiBJS7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 13:59:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiBJS7q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 13:59:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9344810B7;
        Thu, 10 Feb 2022 10:59:47 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21AItClD018471;
        Thu, 10 Feb 2022 18:59:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=hHlY7zZWj3WOoFOG4AKZPifEscrBwE3mTuEfJ++rVMk=;
 b=SC92xEiOKHp8B/YQDhMHHkhi33I4XuvkfhWePkR76TZzfiovy3/7bRNeLWZxVOmoiezX
 HPtbNbxsukoB2BoIMxEQYtfBJ9c4ebM54+2aGlZ63AfHkPXIaBflO4FREqXzq9CJhP8D
 g3aN89aZZuRZ5PGPS8YsYzAQee2+WbLSA+yb/00cdeeWxbdS+wTc2kM4OfKZnBe1l4AD
 eQpNDbnY2qrTTd7kkOpP46P86l81dFEGrjBP/FDxzgjgXLCGK3YZCkLnmLDzdlew9qMG
 hXUZ9aYrZ2SaM16yPyd7eudwkMc2hFF2mAiLQJYqXjLkrTc5Hnf8YGuX+L7QG2/ywm5i Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e54ggxg6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 18:59:45 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21AI6KTN022279;
        Thu, 10 Feb 2022 18:59:45 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e54ggxg65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 18:59:45 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21AIvsUg016343;
        Thu, 10 Feb 2022 18:59:43 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03wdc.us.ibm.com with ESMTP id 3e1gvcf838-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 18:59:43 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21AIxgaR29688126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 18:59:42 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E754712405A;
        Thu, 10 Feb 2022 18:59:41 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09E46124058;
        Thu, 10 Feb 2022 18:59:37 +0000 (GMT)
Received: from [9.211.136.120] (unknown [9.211.136.120])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 10 Feb 2022 18:59:36 +0000 (GMT)
Message-ID: <bcf04ad2-848b-de03-5610-d99e3b761b10@linux.ibm.com>
Date:   Thu, 10 Feb 2022 13:59:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 24/30] vfio-pci/zdev: wire up group notifier
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        linux-s390@vger.kernel.org, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-25-mjrosato@linux.ibm.com>
 <20220208104319.4861fb22.alex.williamson@redhat.com>
 <20220208185141.GH4160@nvidia.com>
 <20220208122624.43ad52ef.alex.williamson@redhat.com>
 <438d8b1e-e149-35f1-a8c9-ed338eb97430@linux.ibm.com>
 <20220208204041.GK4160@nvidia.com>
 <13cf51210d125d48a47d55d9c6a20c93f5a2b78b.camel@linux.ibm.com>
 <20220210130150.GF4160@nvidia.com>
 <fc5cce270dc01d46a6a42f2d268166a0a952fcb3.camel@linux.ibm.com>
 <20220210152305.GG4160@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220210152305.GG4160@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mSVcAdQvMYmEVZgt5jUhdLQtSwl9xMSc
X-Proofpoint-GUID: lZGjfsQLjweW4qSGxxYfqx1mrVIAbaNs
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_08,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 suspectscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202100097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/10/22 10:23 AM, Jason Gunthorpe wrote:
> On Thu, Feb 10, 2022 at 03:06:35PM +0100, Niklas Schnelle wrote:
> 
>>> How does the page pinning work?
>>
>> The pinning is done directly in the RPCIT interception handler pinning
>> both the IOMMU tables and the guest pages mapped for DMA.
> 
> And if pinning fails?

The RPCIT instruction is goes back to the guest with an indication that 
informs it the operation failed / gives it impetus to kick off a guest 
DMA refresh and clear up space (unpin).

>   
>>> Then the
>>> magic kernel code you describe can operate on its own domain without
>>> becoming confused with a normal map/unmap domain.
>>
>> This sounds like an interesting idea. Looking at
>> drivers/iommu/s390_iommu.c most of that is pretty trivial domain
>> handling. I wonder if we could share this by marking the existing
>> s390_iommu_domain type with kind of a "lent out to KVM" flag.
> 
> Lu has posted a series here:
> 
> https://lore.kernel.org/linux-iommu/20220208012559.1121729-1-baolu.lu@linux.intel.com
> 
> Which allows the iommu driver to create a domain with unique ops, so
> you'd just fork the entire thing, have your own struct
> s390_kvm_iommu_domain and related ops.
> 

OK, looking into this, thanks for the pointer...  Sounds to me like we 
then want to make the determination upfront and then ensure the right 
iommu domain ops are registered for the device sometime before creation, 
based upon the usecase -- general userspace: s390_iommu_ops (existing), 
kvm: s390_kvm_iommu_domain (new).

> When the special creation flow is triggered you'd just create one of
> these with the proper ops already setup. >
> We are imagining a special ioctl to create these things and each IOMMU
> HW driver can supply a unique implementation suited to their HW
> design.

But I haven't connected the dots on this part -- At the end of the day 
for this 'special creation flow' I need the kvm + starting point of the 
guest table + format before we let the new s390_kvm_iommu_domain start 
doing automatic map/unmap during RPCIT intercept -- This initial setup 
has to come from a special ioctl as you say, but where do you see it 
living?  I could certainly roll my own via a KVM ioctl or whatever, but 
it sounds like you're also referring to a general-purpose ioctl to 
encompass each of the different unique implementations, with this s390 
kvm approach being one.

