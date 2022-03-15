Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6EA4D9D34
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349067AbiCOOSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbiCOOSs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:18:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532CE50047;
        Tue, 15 Mar 2022 07:17:36 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FD12oq030252;
        Tue, 15 Mar 2022 14:17:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IVfChuQuBl9tidWv81ZwzKVdCtqrR9qE7AtHlAOFUrU=;
 b=F9reZYG83UJO0xE59n2cUUgogCErizwga/uM10Fm4cd/leVgELNNLsgWWTpgAxQ3Mae3
 bmpY8b2gVj/bYtyC/+XJVmZ353WDRLZosX+/moacNtpOPJNiQ9KnbkamfSvegELY12Y9
 u3C8XGU4Qt6jdt/Qmwvc7Mmh3WU7Z4sI3+Rmj2iL3aHLJURgPNA+t/yhzJgLswuxoL/0
 VrbhlVN5hxGlbCrRtA85AY0Yo/vog6g6koi0xAhQfHPDvQa/4tJqrGuwjq1hGgzNGHMb
 Qu4UFuZv00VC0pX7KYzqcgkeLo9fGIePkfiO/FFOfbIix7B92OHi55YIkPxTOoNGuh6u iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3etuajhv1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:17:24 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FDf7LA014460;
        Tue, 15 Mar 2022 14:17:24 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3etuajhv14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:17:24 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FE98qY023423;
        Tue, 15 Mar 2022 14:17:23 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02wdc.us.ibm.com with ESMTP id 3erk59npvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:17:23 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FEHMqk49545516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 14:17:22 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 557D9AC059;
        Tue, 15 Mar 2022 14:17:22 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E727AC065;
        Tue, 15 Mar 2022 14:17:09 +0000 (GMT)
Received: from [9.211.32.184] (unknown [9.211.32.184])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Mar 2022 14:17:09 +0000 (GMT)
Message-ID: <72dd168c-dd40-356c-1fe5-02bdfca57d73@linux.ibm.com>
Date:   Tue, 15 Mar 2022 10:17:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 15/32] vfio: introduce KVM-owned IOMMU type
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "schnelle@linux.ibm.com" <schnelle@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "vneethv@linux.ibm.com" <vneethv@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-16-mjrosato@linux.ibm.com>
 <20220314165033.6d2291a5.alex.williamson@redhat.com>
 <20220314231801.GN11336@nvidia.com>
 <BL1PR11MB5271DE700698C5FB11F5EEE78C109@BL1PR11MB5271.namprd11.prod.outlook.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <BL1PR11MB5271DE700698C5FB11F5EEE78C109@BL1PR11MB5271.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: J982lXTGru7znHLoUNVPj9khaDwswGhb
X-Proofpoint-GUID: UK70Moee3Tu1hHGpP4w5h9IJVUljqARl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 clxscore=1011 mlxscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203150092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/15/22 3:57 AM, Tian, Kevin wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Tuesday, March 15, 2022 7:18 AM
>>
>> On Mon, Mar 14, 2022 at 04:50:33PM -0600, Alex Williamson wrote:
>>
>>>> +/*
>>>> + * The KVM_IOMMU type implies that the hypervisor will control the
>> mappings
>>>> + * rather than userspace
>>>> + */
>>>> +#define VFIO_KVM_IOMMU			11
>>>
>>> Then why is this hosted in the type1 code that exposes a wide variety
>>> of userspace interfaces?  Thanks,
>>
>> It is really badly named, this is the root level of a 2 stage nested
>> IO page table, and this approach needed a special flag to distinguish
>> the setup from the normal iommu_domain.
>>
>> If we do try to stick this into VFIO it should probably use the
>> VFIO_TYPE1_NESTING_IOMMU instead - however, we would like to delete
>> that flag entirely as it was never fully implemented, was never used,
>> and isn't part of what we are proposing for IOMMU nesting on ARM
>> anyhow. (So far I've found nobody to explain what the plan here was..)
>>
>> This is why I said the second level should be an explicit iommu_domain
>> all on its own that is explicitly coupled to the KVM to read the page
>> tables, if necessary.
>>
>> But I'm not sure that reading the userspace io page tables with KVM is
>> even the best thing to do - the iommu driver already has the pinned
>> memory, it would be faster and more modular to traverse the io page
>> tables through the pfns in the root iommu_domain than by having KVM do
>> the translations. Lets see what Matthew says..
>>
> 
> Reading this thread it's sort of like an optimization to software nesting.

Yes, we want to avoid breaking to userspace for a very frequent 
operation (RPCIT / updating shadow mappings)

> If that is the case does it make more sense to complete the basic form
> of software nesting first and then adds this optimization?
> 
> The basic form would allow the userspace to create a special domain
> type which points to a user/guest page table (like hardware nesting)
> but doesn't install the user page table to the IOMMU hardware (unlike
> hardware nesting). When receiving invalidate cmd from userspace > the iommu driver walks the user page table (1st-level) and the parent
> page table (2nd-level) to generate a shadow mapping for the
> invalidated range in the non-nested hardware page table of this
> special domain type.
> 
> Once that works what this series does just changes the matter of
> how the invalidate cmd is triggered. Previously iommu driver receives
> invalidate cmd from Qemu (via iommufd uAPI) while now receiving
> the cmd from kvm (via iommufd kAPI) upon interception of RPCIT.
>  From this angle once the connection between iommufd and kvm fd
> is established there is even no direct talk between iommu driver and
> kvm.

But something somewhere still needs to be responsible for 
pinning/unpinning of the guest table entries upon each RPCIT 
interception.  e.g. the RPCIT intercept can happen because the guest 
wants to invalidate some old mappings or has generated some new mappings 
over a range, so we must shadow the new mappings (by pinning the guest 
entries and placing them in the host hardware table / unpinning 
invalidated ones and clearing their entry in the host hardware table).


