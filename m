Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BA05F774B
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 13:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiJGLRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 07:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiJGLRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 07:17:49 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C202EB1B9C
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 04:17:48 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2979ktZk019493;
        Fri, 7 Oct 2022 11:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IsLeqgR+xs6/9kVOHQyg/5M63NwlwZiLMou93Fuz8uo=;
 b=J2Q48oq+uSiz4a/ioLzy0PAKxA+zicjiOrSx4W9z3ihA9wlSW6gveSAs80K4UblsofG6
 cI10DKLISala1Krthz8CsC8N1+DBVjeJFZLxoQyOZirfoAOLkL/6yKRLY9bJhGto/r8E
 Jn66Haqlz743KUO91YbW9PeqxTJWSOnHshGtWv0QFfF3MbJDaDNcEIyU//XUS1N+KZoc
 VirKAcbN8Jm13kAcEoMVYqAd0vf4DwAvVlmxbiPNSp1s1iHY+eRKlH3KeWPAN3CuH202
 TVEf4DPwntrR0TqWzWdTjgXz2S2Ymnal4QIqGK9AH4nmVJfHOj/JHjk48GuyDd3DKyPY Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k2hsjan7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Oct 2022 11:17:40 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 297AFPTQ016477;
        Fri, 7 Oct 2022 11:17:40 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k2hsjan6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Oct 2022 11:17:40 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 297B6Ih5011205;
        Fri, 7 Oct 2022 11:17:38 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3jxd698h5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Oct 2022 11:17:38 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 297BHZ5M328426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Oct 2022 11:17:35 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A4AB11C04A;
        Fri,  7 Oct 2022 11:17:35 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91E0F11C050;
        Fri,  7 Oct 2022 11:17:34 +0000 (GMT)
Received: from [9.171.29.27] (unknown [9.171.29.27])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  7 Oct 2022 11:17:34 +0000 (GMT)
Message-ID: <c2a952be-2700-b2be-d72d-f3d74046703c@de.ibm.com>
Date:   Fri, 7 Oct 2022 13:17:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 0/3] Allow the group FD to remain open when unplugging a
 device
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Yi Liu <yi.l.liu@intel.com>
References: <0-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
 <20221006135315.3270b735.alex.williamson@redhat.com>
 <Yz9Z3um1HQHnEGVv@nvidia.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <Yz9Z3um1HQHnEGVv@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8rZfegMtQkROgVmrNrlqvR3hSgoJKeVS
X-Proofpoint-GUID: s-j5j2BdMXj1196e1D2iDFomKpJFCIl5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-06_05,2022-10-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210070067
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 07.10.22 um 00:42 schrieb Jason Gunthorpe:
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
>>>    vfio: Add vfio_file_is_group()
>>>    vfio: Hold a reference to the iommu_group in kvm for SPAPR
>>>    vfio: Make the group FD disassociate from the iommu_group
>>>
>>>   drivers/vfio/pci/vfio_pci_core.c |  2 +-
>>>   drivers/vfio/vfio.h              |  1 -
>>>   drivers/vfio/vfio_main.c         | 90 +++++++++++++++++++++-----------
>>>   include/linux/vfio.h             |  1 +
>>>   virt/kvm/vfio.c                  | 45 +++++++++++-----
>>>   5 files changed, 94 insertions(+), 45 deletions(-)
>>
>> Containers aren't getting cleaned up with this series, starting and
>> shutting down a libvirt managed VM with vfio-pci devices, an mtty mdev
>> device, and making use of hugepages, /proc/meminfo shows the hugepages
>> are not released on VM shutdown and I'm unable to subsequently restart
>> the VM. Thanks,
> 
> Oh, I'm surprised the s390 testing didn't hit this!!

I guess its because that most of our CI testcases create a new ephemeral
guest for each testcase. We do test reboot but not shutdown and restart.
Will have a look if that can be improved.
