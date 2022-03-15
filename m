Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81DB44D9C5E
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 14:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348800AbiCONiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 09:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348753AbiCONhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 09:37:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FBE52E30;
        Tue, 15 Mar 2022 06:36:42 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FD11ns030246;
        Tue, 15 Mar 2022 13:36:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=leBgtOc/BpHS3N7gQuH82IY5WMqgYUIxm2e3mHS2D+0=;
 b=s0UdQPKZVhxkdi58StsYbIZ1FY5vIqBltk999xWUAbsz80bO74SULLeJ2bGykgH6KTsv
 8KaE4z2Zao4wXC+G7H3TQSUBgLeaPw16h2rRF7P4DaSPIFt0vmHWyliHzt85cmpKUG+A
 jffHm25Itvmtn5v77RJCxxZTZrEdCSmhYxtmW+qGwQLBhxOnglO19pXNCksMZ6nRRVV6
 1ilkKB2HoMXp9x2hMmzLzdb28Z866U5NBPDI7jjhJuYrclW8tLfeaZGvHPb7KgX5QiOI
 XMY+c80rsWJKUpE65i2rroynbPIZR/nNC43a2hsFcsZoWyQLWoApnUhjcyajbXspu2ok aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3etuajgtab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 13:36:27 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FD1lB0030806;
        Tue, 15 Mar 2022 13:36:26 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3etuajgta2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 13:36:26 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FDUASk019596;
        Tue, 15 Mar 2022 13:36:25 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03wdc.us.ibm.com with ESMTP id 3etjmnk3y0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 13:36:25 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FDaOeH30212458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 13:36:24 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F472AC062;
        Tue, 15 Mar 2022 13:36:24 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3191AC065;
        Tue, 15 Mar 2022 13:36:10 +0000 (GMT)
Received: from [9.211.32.184] (unknown [9.211.32.184])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Mar 2022 13:36:10 +0000 (GMT)
Message-ID: <9618afae-2a91-6e4e-e8c3-cb83e2f5c3d9@linux.ibm.com>
Date:   Tue, 15 Mar 2022 09:36:08 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 15/32] vfio: introduce KVM-owned IOMMU type
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-s390@vger.kernel.org, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-doc@vger.kernel.org
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-16-mjrosato@linux.ibm.com>
 <20220314165033.6d2291a5.alex.williamson@redhat.com>
 <20220314231801.GN11336@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220314231801.GN11336@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ssit5_KaQXJf7t9EchayqlSsw0iusdnM
X-Proofpoint-GUID: G4FMJgpQ5_Oh7_ArkLgAdBmgq5It9L8e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203150089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/14/22 7:18 PM, Jason Gunthorpe wrote:
> On Mon, Mar 14, 2022 at 04:50:33PM -0600, Alex Williamson wrote:
> 
>>> +/*
>>> + * The KVM_IOMMU type implies that the hypervisor will control the mappings
>>> + * rather than userspace
>>> + */
>>> +#define VFIO_KVM_IOMMU			11
>>
>> Then why is this hosted in the type1 code that exposes a wide variety
>> of userspace interfaces?  Thanks,
> 
> It is really badly named, this is the root level of a 2 stage nested
> IO page table, and this approach needed a special flag to distinguish
> the setup from the normal iommu_domain.

^^ Yes, this.

> 
> If we do try to stick this into VFIO it should probably use the
> VFIO_TYPE1_NESTING_IOMMU instead - however, we would like to delete
> that flag entirely as it was never fully implemented, was never used,
> and isn't part of what we are proposing for IOMMU nesting on ARM
> anyhow. (So far I've found nobody to explain what the plan here was..)
> 

I'm open to suggestions on how better to tie this into vfio.  The 
scenario basically plays out that:

1) the iommu will be domain_alloc'd once VFIO_SET_IOMMU is issued -- so 
at that time (or earlier) we have to make the decision on whether to use 
the standard IOMMU or this alternate KVM/nested IOMMU.

2) At the time VFIO_SET_IOMMU is received, we have not yet associated 
the vfio group with a KVM, so we can't (today) use this as an indicator 
to guess which IOMMU strategy to use.

3) Ideally, even if we changed QEMU vfio to make the KVM association 
earlier, it would be nice to still be able to indicate that we want to 
use the standard iommu/type1 despite a KVM association existing (e.g. 
backwards compatibility with older QEMU that lacks 'interpretation' 
support, nested virtualization scenarios).

> This is why I said the second level should be an explicit iommu_domain
> all on its own that is explicitly coupled to the KVM to read the page
> tables, if necessary.

Maybe I misunderstood this.  Are you proposing 2 layers of IOMMU that
interact with each other within host kernel space?

A second level runs the guest tables, pins the appropriate pieces from 
the guest to get the resulting phys_addr(s) which are then passed via 
iommu to a first level via map (or unmap)?

> 
> But I'm not sure that reading the userspace io page tables with KVM is
> even the best thing to do - the iommu driver already has the pinned
> memory, it would be faster and more modular to traverse the io page
> tables through the pfns in the root iommu_domain than by having KVM do
> the translations. Lets see what Matthew says..

OK, you lost me a bit here.  And this may be associated with the above.

So, what the current implementation is doing is reading the guest DMA 
tables (which we must pin the first time we access them) and then map 
the PTEs of the associated guest DMA entries into the associated host 
DMA table (so, again pin and place the address, or unpin and 
invalidate).  Basically we are shadowing the first level DMA table as a 
copy of the second level DMA table with the host address(es) of the 
pinned guest page(s).

I'm unclear where you are proposing the pinning be done if not by the 
iommu domain traversing the tables to perform the 'shadow' operation.



