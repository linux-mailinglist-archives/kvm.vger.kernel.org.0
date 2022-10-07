Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0901B5F79E8
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 16:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiJGOrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 10:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJGOq7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 10:46:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFF692595
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 07:46:58 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 297EfeQ4030796;
        Fri, 7 Oct 2022 14:46:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=H+SVr0bavP6qe+kYNXgJV47669l6DjidwDvkBau7NqY=;
 b=gVJJc9iVWqzia4cNXRz3cnnvZrpqE3tkc72BhPCy1uSOk7gqRbk+PW7KE/b+g2r7/lKp
 YWaW9dOn8XTq+juCLhOZGWVh1vZ8gTG2ni08yHAinPxE8KcNk9flf3iDIO+l7wNwy+PC
 j+uLM5L3Ch1/qO/2RPi4gz92GqllHiMp/4j6zCAuANN5Sbo4lh6rd4+tfk3J3JoQAJCO
 UGJuqzTdS+3jasCb77ZsYpNMf8iolsUiaA9HDQVQ05gG6+MEssc0dxN50rQf9BoRyLPY
 Pz+ygcEcvDrYb9HF93RR62O6zNLaUqM/E+nrV6OvAy5UWUUHiJ8qb/lKJ/JWlF/L8M4t nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k2p3m06v4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Oct 2022 14:46:51 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 297Eg8U9002174;
        Fri, 7 Oct 2022 14:46:50 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k2p3m06uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Oct 2022 14:46:50 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 297Earkw018515;
        Fri, 7 Oct 2022 14:46:49 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 3jxd6aupe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Oct 2022 14:46:49 +0000
Received: from smtpav04.wdc07v.mail.ibm.com ([9.208.128.116])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 297EkmtP131714
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Oct 2022 14:46:48 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D00758045;
        Fri,  7 Oct 2022 14:46:48 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59F0458056;
        Fri,  7 Oct 2022 14:46:46 +0000 (GMT)
Received: from [9.160.126.121] (unknown [9.160.126.121])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  7 Oct 2022 14:46:46 +0000 (GMT)
Message-ID: <d3df30ac-6bf5-4565-15f7-49c4c282742c@linux.ibm.com>
Date:   Fri, 7 Oct 2022 10:46:45 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 0/3] Allow the group FD to remain open when unplugging a
 device
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Yi Liu <yi.l.liu@intel.com>
References: <0-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
 <20221006135315.3270b735.alex.williamson@redhat.com>
 <Yz9Z3um1HQHnEGVv@nvidia.com>
 <2a61068b-3645-27d0-5fae-65a6e1113a8d@linux.ibm.com>
 <Y0ArhhCOXEYQMC1q@nvidia.com>
 <b04ce2fd-2c68-7b0f-ec43-3f0c27d35c0e@linux.ibm.com>
 <Y0A6MH0Espv2JFWu@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <Y0A6MH0Espv2JFWu@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kSoAoA0ejpqMuphLvrxv8BO-B-cc9ezy
X-Proofpoint-GUID: erSgNwzvLJGsfFGLdwbKkDW9ufp_GfRI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-06_05,2022-10-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1015 mlxscore=0 adultscore=0 impostorscore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210070087
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/7/22 10:39 AM, Jason Gunthorpe wrote:
> On Fri, Oct 07, 2022 at 10:37:11AM -0400, Matthew Rosato wrote:
>> On 10/7/22 9:37 AM, Jason Gunthorpe wrote:
>>> On Thu, Oct 06, 2022 at 07:28:53PM -0400, Matthew Rosato wrote:
>>>
>>>>> Oh, I'm surprised the s390 testing didn't hit this!!
>>>>
>>>> Huh, me too, at least eventually - I think it's because we aren't
>>>> pinning everything upfront but rather on-demand so the missing the
>>>> type1 release / vfio_iommu_unmap_unpin_all wouldn't be so obvious.
>>>> I definitely did multiple VM (re)starts and hot (un)plugs.  But
>>>> while my test workloads did some I/O, the long-running one was
>>>> focused on the plug/unplug scenarios to recreate the initial issue
>>>> so the I/O (and thus pinning) done would have been minimal.
>>>
>>> That explains ccw/ap a bit but for PCI the iommu ownership wasn't
>>> released so it becomes impossible to re-attach a container to the
>>> group. eg a 2nd VM can never be started
>>>
>>> Ah well, thanks!
>>>
>>> Jason
>>
>> Well, this bugged me enough that I traced the v1 series without fixup and vfio-pci on s390 was OK because it was still calling detach_container on vm shutdown via this chain:
>>
>> vfio_pci_remove
>>  vfio_pci_core_unregister_device
>>   vfio_unregister_group_dev
>>    vfio_device_remove_group
>>     vfio_group_detach_container
>>
>> I'd guess non-s390 vfio-pci would do the same.  Alex also had the mtty mdev, maybe that's relevant.
> 
> As long as you are unplugging a driver the v1 series would work. The
> failure mode is when you don't unplug the driver and just run a VM
> twice in a row.
> 
> Jason

Oh, duh - And yep all of my tests are using managed libvirt so its unbinding from vfio-pci back to the default host driver on VM shutdown.

OK, if I force the point and leave vfio-pci bound the 2nd guest boot indeed fails setting up the container with unmodified v1.  I'll try again with the new v2 now

