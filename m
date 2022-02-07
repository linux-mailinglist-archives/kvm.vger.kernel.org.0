Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1932C4ACA31
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 21:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240756AbiBGULh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 15:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241254AbiBGUJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 15:09:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C78C0401DA;
        Mon,  7 Feb 2022 12:09:31 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217JQC35008105;
        Mon, 7 Feb 2022 20:09:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FBUo4/4YFT6ZNxsYuzTtgK1zATL2fDUgCgTHjU0XPAg=;
 b=QWgYmBFhGDjg/bn24e1PfbIesN9CUzAueDSgqD2+zLl52gJyrHJmq1+F0Mkb76ZTVwpO
 srFJfie3N7a7yfGrz6bF3G0OdE6plMbPYnXvMt544H+a+52JJPZQOxdl8mcdD192P9OR
 Qln0/S35M5t4PkKyK+Jm1g54iBgwLDJNV9vriQuBrnhi6oZPll+TVD+hXJhVSc/pWPSQ
 HivMhQkU7bl/pTV0AfP9WT3hpXVHCc/TalVopluRiK4e26uqccDFqyxJXwKB/QScjb+3
 kmnjc42yvRuoSry383v7D/Qo6dW+sk5Cp9oU63tl3uClHTPRG+dIuy/bDi0cdE0Z06UP rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22stde2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 20:09:30 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217K8ddV010235;
        Mon, 7 Feb 2022 20:09:30 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22stde25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 20:09:30 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217JvPaO012521;
        Mon, 7 Feb 2022 20:09:28 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 3e1gvanua9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 20:09:28 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217K9RDq28377574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 20:09:27 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA4146A063;
        Mon,  7 Feb 2022 20:09:26 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36A496A054;
        Mon,  7 Feb 2022 20:09:25 +0000 (GMT)
Received: from [9.211.136.120] (unknown [9.211.136.120])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 20:09:25 +0000 (GMT)
Message-ID: <68c2e4f0-1375-cd17-c056-3fa58dcbd72f@linux.ibm.com>
Date:   Mon, 7 Feb 2022 15:09:24 -0500
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
 <1ff6e06c-e563-2b9c-3196-542fed7df0f9@linux.ibm.com>
 <87sfsuv9qg.fsf@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <87sfsuv9qg.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GsSU14gUSLp4EDlh1HvsiF2YmUBz6bgU
X-Proofpoint-ORIG-GUID: EDtCNeB5zbZWxKLIqHO3PKaCzRbJipod
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 malwarescore=0 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070118
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/7/22 12:59 PM, Cornelia Huck wrote:
> On Mon, Feb 07 2022, Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> On 2/7/22 3:35 AM, Cornelia Huck wrote:
>>> On Fri, Feb 04 2022, Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>>
>>>> This was previously removed as unnecessary; while that was true, subsequent
>>>> changes will make KVM an additional required component for vfio-pci-zdev.
>>>> Let's re-introduce CONFIG_VFIO_PCI_ZDEV as now there is actually a reason
>>>> to say 'n' for it (when not planning to CONFIG_KVM).
>>>
>>> Hm... can the file be split into parts that depend on KVM and parts that
>>> don't? Does anybody ever use vfio-pci on a non-kvm s390 system?
>>>
>>
>> It is possible to split out most of the prior CLP/ vfio capability work
>> (but it would not be a totally clean split, zpci_group_cap for example
>> would need to have an inline ifdef since it references a KVM structure)
>> -- I suspect we'll see more of that in the future.
>> I'm not totally sure if there's value in the information being provided
>> today -- this CLP information was all added specifically with
>> userspace->guest delivery in mind.  And to answer your other question,
>> I'm not directly aware of non-kvm vfio-pci usage on s390 today; but that
>> doesn't mean there isn't any or won't be in the future of course.  With
>> this series, you could CONFIG_KVM=n + CONFIG_VFIO_PCI=y|m and you'll get
>> the standard vfio-pci support but never any vfio-pci-zdev extension.
> 
> Yes. Remind me again: if you do standard vfio-pci without the extensions
> grabbing some card-specific information and making them available to the
> guest, you get a working setup, it just always looks like a specific
> card, right?
> 

That's how QEMU treats it anyway, yes.  Standard PCI aspects (e.g. 
config space) are fine, but for the s390-specific bits we end up making 
generalizations / using hard-coded values that are subsequently shared 
with the guest when it issues a CLP -- these bits are used to identify 
various s390-specific capabilities of the device (an example: based upon 
the function type, the guest could derive what format of the function 
measurement block can be used.  The hard-coded value is otherwise 
effectively 'generic device' so use the basic format for this block).

Basically, we are using vfio to transmit information owned by the host 
s390 PCI layer to, ultimately, the guest s390 PCI layer (modified to 
reflect what kvm+QEMU supports), so that the guest can treat the device 
the same way that the host does.  Anything else in between isn't going 
to be interested in that information unless it wants to do something 
very s390-specific.

>>
>> If we wanted to provide everything we can where KVM isn't strictly
>> required, then let's look at what a split would look like:
>>
>> With or without KVM:
>> zcpi_base_cap
>> zpci_group_cap (with an inline ifdef for KVM [1])
>> zpci_util_cap
>> zpci_pfip_cap
>> vfio_pci_info_zdev_add_caps	
>> vfio_pci_zdev_open (ifdef, just return when !KVM  [1])
>> vfio_pci_zdev_release (ifdef, just return when !KVM [1])
>>
>> KVM only:
>> vfio_pci_zdev_feat_interp
>> vfio_pci_zdev_feat_aif
>> vfio_pci_zdev_feat_ioat
>> vfio_pci_zdev_group_notifier
>>
>> I suppose such a split has the benefit of flexibility /
>> future-proofing...  should a non-kvm use case arrive in the future for
>> s390 and we find we need some s390-specific handling, we're still
>> building vfio-pci-zdev into vfio-pci by default and can just extend that.
>>
>> [1] In this case I would propose renaming CONFIG_VFIO_PCI_ZDEV as we
>> would once again always be building some part of vfio-pci-zdev with
>> vfio-pci on s390 -- maybe something like CONFIG_VFIO_PCI_ZDEV_KVM (wow
>> that's a mouthful) and then use this setting to check "KVM" in my above
>> split.  Since this setting will imply PCI, VFIO_PCI and KVM, we can then
>> s/CONFIG_VFIO_PCI_ZDEV/CONFIG_VFIO_PCI_ZDEV_KVM/ for the rest of the
>> series (to continue covering cases like we build KVM but not pci, or not
>> vfio-pci)
>>
>> How does that sound?
> 
> Complex :)
> 
> I'm not really sure whether it's worth the hassle on an odd chance that
> we may want it for a !KVM usecase in the future (that goes beyond the
> "base" vfio-pci support.) OTOH, it would be cleaner. I'm a bit torn on
> this one.
> 

Well, another option would be to move ahead with this patch as-is, 
except to rename s/CONFIG_VFIO_PCI_ZDEV/CONFIG_VFIO_PCI_ZDEV_KVM/ or 
something like that (and naturally tweak the title and commit message a 
bit).  Basically, don't have the name imply a 1:1 relationship with all 
of vfio-pci-zdev, even if it will have that effect in practice for now.

Net result with this series would be we stop building vfio-pci-zdev 
without KVM, which means we remove the zdev CLP capabilities when !KVM. 
And then if we have a !KVM usecase in the future that needs something 
non-standard for s390 (either this CLP info or more likely some other 
s390-specific tweak) we can then perform the split, perhaps just as I 
describe above.  In this way we punt the need for complexity until a 
point when (if) we need it, without backing ourselves into a weird case 
where we must rename the config parameter (or live with the fact that we 
always build some part of vfio-pci-zdev even when CONFIG_VFIO_PCI_ZDEV=n)

