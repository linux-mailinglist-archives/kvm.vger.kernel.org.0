Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999255F71C8
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 01:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiJFX3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 19:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiJFX3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 19:29:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649E3EB7E9
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 16:29:07 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 296MrHAs028200;
        Thu, 6 Oct 2022 23:29:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ap6MBRhSre3EnJQB3cFJAHPpAo6iYmvpfvWprNdlH/A=;
 b=h2MyGlOra2gpbj4Ez2ZYuvXFQA86nAJe6IbsKQqRsO9rkfaAjnC5suKD1W2xqclQEOeH
 2YUS5vHY4Dz5ZD7gts4upu7rqc3MEsnot6bA/1+Cp+l4nsoR+eKS3AwZm9qpPipJXcLn
 BA4Nfq+eqCBxnpXuLMx3Rt85HEM/CNggOKWGGTBpGqt8sKAuW9Ndv/Hv5c+UddwMX4La
 d26ffwCnTi+9+QMM5hDypXUfXYxWFqf+x5Iljj8G/BLsxpYk06q0m/YLEz9XFBHvlSAB
 /QJFhgpqd0Z1Ab81Ro5pPQ/H6iQopkXdO097+WHQPWlLpKOx7c1nh3ZMhccYwl+eyQ4p tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k286w8tj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 23:29:00 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 296NQmm5013969;
        Thu, 6 Oct 2022 23:28:59 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k286w8tht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 23:28:59 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 296N5qxO022407;
        Thu, 6 Oct 2022 23:28:58 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 3jxd6aes2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 23:28:58 +0000
Received: from smtpav06.wdc07v.mail.ibm.com ([9.208.128.115])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 296NSvmq64029072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Oct 2022 23:28:57 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEE9E58054;
        Thu,  6 Oct 2022 23:28:56 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABE515804E;
        Thu,  6 Oct 2022 23:28:54 +0000 (GMT)
Received: from [9.160.70.216] (unknown [9.160.70.216])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  6 Oct 2022 23:28:54 +0000 (GMT)
Message-ID: <2a61068b-3645-27d0-5fae-65a6e1113a8d@linux.ibm.com>
Date:   Thu, 6 Oct 2022 19:28:53 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 0/3] Allow the group FD to remain open when unplugging a
 device
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
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
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <Yz9Z3um1HQHnEGVv@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Pob0ignhfLtolPZ_rqpDnifd9vWZAF4s
X-Proofpoint-GUID: V71yMeVVSD3SaoOHWai--p5mySVfBVm4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-06_05,2022-10-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 impostorscore=0 bulkscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210060137
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/6/22 6:42 PM, Jason Gunthorpe wrote:
> On Thu, Oct 06, 2022 at 01:53:15PM -0600, Alex Williamson wrote:
>> On Thu,  6 Oct 2022 09:40:35 -0300
>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>
>>> Testing has shown that virtnodedevd will leave the group FD open for long
>>> periods, even after all the cdevs have been destroyed. This blocks
>>> destruction of the VFIO device and is undesirable.
>>>
>>> That approach was selected to accomodate SPAPR which has an broken
>>> lifecyle model for the iommu_group. However, we can accomodate SPAPR by
>>> realizing that it doesn't use the iommu core at all, so rules about
>>> iommu_group lifetime do not apply to it.
>>>
>>> Giving the KVM code its own kref on the iommu_group allows the VFIO core
>>> code to release its iommu_group reference earlier and we can remove the
>>> sleep that only existed for SPAPR.
>>>
>>> Jason Gunthorpe (3):
>>>   vfio: Add vfio_file_is_group()
>>>   vfio: Hold a reference to the iommu_group in kvm for SPAPR
>>>   vfio: Make the group FD disassociate from the iommu_group
>>>
>>>  drivers/vfio/pci/vfio_pci_core.c |  2 +-
>>>  drivers/vfio/vfio.h              |  1 -
>>>  drivers/vfio/vfio_main.c         | 90 +++++++++++++++++++++-----------
>>>  include/linux/vfio.h             |  1 +
>>>  virt/kvm/vfio.c                  | 45 +++++++++++-----
>>>  5 files changed, 94 insertions(+), 45 deletions(-)
>>
>> Containers aren't getting cleaned up with this series, starting and
>> shutting down a libvirt managed VM with vfio-pci devices, an mtty mdev
>> device, and making use of hugepages, /proc/meminfo shows the hugepages
>> are not released on VM shutdown and I'm unable to subsequently restart
>> the VM. Thanks,
> 
> Oh, I'm surprised the s390 testing didn't hit this!!

Huh, me too, at least eventually - I think it's because we aren't pinning everything upfront but rather on-demand so the missing the type1 release / vfio_iommu_unmap_unpin_all wouldn't be so obvious.  I definitely did multiple VM (re)starts and hot (un)plugs.  But while my test workloads did some I/O, the long-running one was focused on the plug/unplug scenarios to recreate the initial issue so the I/O (and thus pinning) done would have been minimal.

-ap and -ccw also don't pin everything upfront (and I did far less testing with those).

Ugh.  Moving forward, might be worth seeing how I can loop in some non-s390-specific vfio testing into my routine.

> 
> This hunk should remain since not all cases are closures due to device
> hot unplug
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index f9cb734d3991b3..62aba3a128fb8d 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -954,6 +954,13 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
>  	filep->private_data = NULL;
>  
>  	mutex_lock(&group->group_lock);
> +	/*
> +	 * Device FDs hold a group file reference, therefore the group release
> +	 * is only called when there are no open devices.
> +	 */
> +	WARN_ON(group->notifier.head);
> +	if (group->container)
> +		vfio_group_detach_container(group);
>  	group->opened_file = NULL;
>  	mutex_unlock(&group->group_lock);
>  	return 0;

Anyway, FWIW, I folded this in and re-ran a brief series of -pci, -ccw and -ap tests on s390 and things still look good.  For completeness I'll start some longer-running pci tests next but I expect this will still be fine as well.
