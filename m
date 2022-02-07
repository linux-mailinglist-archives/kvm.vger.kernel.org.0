Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65784AC422
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 16:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238113AbiBGPo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 10:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384530AbiBGPnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 10:43:41 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2FEC0401C1;
        Mon,  7 Feb 2022 07:43:41 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217F4F8r019786;
        Mon, 7 Feb 2022 15:43:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GY/qxCBOtnM10f+Y/FEZFQS14z6BzRd4HNAeuIMFpaI=;
 b=s+NORjrMNaWNjg7eeW2DkCRj9Mw6gVATcGhgrkO1rMIqE71aetO4Kykf6HiewaCGeGmG
 JWB3KKH0OqNBMu052Yv68UMIx/4Jdas+MEpsYLWfjHHZyAy7jJJoLgvvBChjBGzn/cO2
 ieF80nnID7vThyphLoKt+dqx7EFxHbrP5Usu9X4fxSHy7naGV5VjUxvrRYYWfEmSm3yV
 wBYaQcpk/6S3r8f6fFIuOCY141y/0BnOLlzdnDprEfMWajpRPBvG1QVXLY1vmpZzhTxN
 tAZ7Ej59nIU7EIKHsqy0lsTZihq8XFqdwFywj8x6t0+nX95MdspeZoUmnjq3TwoOPbxn 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22kq03ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 15:43:40 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217F8bWe019937;
        Mon, 7 Feb 2022 15:43:39 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22kq03u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 15:43:39 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217FXfse008368;
        Mon, 7 Feb 2022 15:43:39 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 3e1gv9r5pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 15:43:38 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217Fhbwx17891674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 15:43:37 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60B1F6A051;
        Mon,  7 Feb 2022 15:43:37 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69B516A054;
        Mon,  7 Feb 2022 15:43:35 +0000 (GMT)
Received: from [9.211.136.120] (unknown [9.211.136.120])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 15:43:35 +0000 (GMT)
Message-ID: <1ff6e06c-e563-2b9c-3196-542fed7df0f9@linux.ibm.com>
Date:   Mon, 7 Feb 2022 10:43:34 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 14/30] vfio/pci: re-introduce CONFIG_VFIO_PCI_ZDEV
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-15-mjrosato@linux.ibm.com> <87czjzvztw.fsf@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <87czjzvztw.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NZsE0Lv1I4b2ew2YEwRoh9neRiXU6OrX
X-Proofpoint-ORIG-GUID: RPEb0Y0ii7lfDXM54cp9IFrLoluoTyzO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/7/22 3:35 AM, Cornelia Huck wrote:
> On Fri, Feb 04 2022, Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> This was previously removed as unnecessary; while that was true, subsequent
>> changes will make KVM an additional required component for vfio-pci-zdev.
>> Let's re-introduce CONFIG_VFIO_PCI_ZDEV as now there is actually a reason
>> to say 'n' for it (when not planning to CONFIG_KVM).
> 
> Hm... can the file be split into parts that depend on KVM and parts that
> don't? Does anybody ever use vfio-pci on a non-kvm s390 system?
> 

It is possible to split out most of the prior CLP/ vfio capability work 
(but it would not be a totally clean split, zpci_group_cap for example 
would need to have an inline ifdef since it references a KVM structure) 
-- I suspect we'll see more of that in the future.
I'm not totally sure if there's value in the information being provided 
today -- this CLP information was all added specifically with 
userspace->guest delivery in mind.  And to answer your other question, 
I'm not directly aware of non-kvm vfio-pci usage on s390 today; but that 
doesn't mean there isn't any or won't be in the future of course.  With 
this series, you could CONFIG_KVM=n + CONFIG_VFIO_PCI=y|m and you'll get 
the standard vfio-pci support but never any vfio-pci-zdev extension.

If we wanted to provide everything we can where KVM isn't strictly 
required, then let's look at what a split would look like:

With or without KVM:
zcpi_base_cap
zpci_group_cap (with an inline ifdef for KVM [1])
zpci_util_cap
zpci_pfip_cap
vfio_pci_info_zdev_add_caps	
vfio_pci_zdev_open (ifdef, just return when !KVM  [1])
vfio_pci_zdev_release (ifdef, just return when !KVM [1])

KVM only:
vfio_pci_zdev_feat_interp
vfio_pci_zdev_feat_aif
vfio_pci_zdev_feat_ioat
vfio_pci_zdev_group_notifier

I suppose such a split has the benefit of flexibility / 
future-proofing...  should a non-kvm use case arrive in the future for 
s390 and we find we need some s390-specific handling, we're still 
building vfio-pci-zdev into vfio-pci by default and can just extend that.

[1] In this case I would propose renaming CONFIG_VFIO_PCI_ZDEV as we 
would once again always be building some part of vfio-pci-zdev with 
vfio-pci on s390 -- maybe something like CONFIG_VFIO_PCI_ZDEV_KVM (wow 
that's a mouthful) and then use this setting to check "KVM" in my above 
split.  Since this setting will imply PCI, VFIO_PCI and KVM, we can then 
s/CONFIG_VFIO_PCI_ZDEV/CONFIG_VFIO_PCI_ZDEV_KVM/ for the rest of the 
series (to continue covering cases like we build KVM but not pci, or not 
vfio-pci)

How does that sound?



