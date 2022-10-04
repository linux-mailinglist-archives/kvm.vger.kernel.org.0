Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0C25F48A4
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 19:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiJDRiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 13:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiJDRhk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 13:37:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FD413EA3;
        Tue,  4 Oct 2022 10:36:20 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 294HVsP7011608;
        Tue, 4 Oct 2022 17:36:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Kc2zwy1co+LzvVZtJmajl52Azihg5WzNVjpZHh5pmgA=;
 b=XJTmkVXjHutMO5a9LVxxkvJx0gXSsXIXU/PnQ4Sx6kf+kK0k6nvbxrjsGNOK+/hr5d9X
 AJhoMfFps37v5vp26AMQB9A37LmjddHg6RtC9HmVbbdBNADM3FUTuLNlk8sbNPfwNKAX
 MRvY9IFWOEbnkXsHE2A3h8c+Oyd7pxzqaiGVJRyXAjl3kngHL55d3WGOdQIGPmKMrosh
 4jmFUzU08wKXO5SbMN+pFjIIdIvexvrfVJgpZzCVgW1YyzUW8d/vVSB8a+Nq+fckhT72
 ACQYnASLaIg+PeOE3cBOllelQbLoOnEBPbQKMGiG6Qr1G8wTNvxpX9dU2jlIa/xXYzvk VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0fsn2r1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 17:36:11 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 294HKogn014298;
        Tue, 4 Oct 2022 17:36:10 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k0fsn2qys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 17:36:10 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 294HZobO015177;
        Tue, 4 Oct 2022 17:36:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3jxd68kadf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Oct 2022 17:36:07 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 294HVZMl49414550
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Oct 2022 17:31:35 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 865275204E;
        Tue,  4 Oct 2022 17:36:04 +0000 (GMT)
Received: from [9.171.7.248] (unknown [9.171.7.248])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 000AF5204F;
        Tue,  4 Oct 2022 17:36:03 +0000 (GMT)
Message-ID: <0a0d7937-316a-a0e2-9d7d-df8f3f8a38e3@linux.ibm.com>
Date:   Tue, 4 Oct 2022 19:36:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
 <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
 <20220927140541.6f727b01.alex.williamson@redhat.com>
 <52545d8b-956b-8934-8a7e-212729ea2855@linux.ibm.com>
 <YzxT6Suu+272gDvP@nvidia.com>
 <1aebfa84-8310-5dff-1862-3d143878d9dd@linux.ibm.com>
 <YzxfK/e14Bx9yNyo@nvidia.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <YzxfK/e14Bx9yNyo@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cILruUdYkI_oPhckABTW5SEmp72UqCeI
X-Proofpoint-GUID: _uHifdwBwLfUG7zv6R7ikSflK_F84d8j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_08,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 suspectscore=0 phishscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=689 impostorscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210040114
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 04.10.22 um 18:28 schrieb Jason Gunthorpe:
> On Tue, Oct 04, 2022 at 05:44:53PM +0200, Christian Borntraeger wrote:
> 
>>> Does some userspace have the group FD open when it stucks like this,
>>> eg what does fuser say?
>>
>> /proc/<virtnodedevd>/fd
>> 51480 0 dr-x------. 2 root root  0  4. Okt 17:16 .
>> 43593 0 dr-xr-xr-x. 9 root root  0  4. Okt 17:16 ..
>> 65252 0 lr-x------. 1 root root 64  4. Okt 17:42 0 -> /dev/null
>> 65253 0 lrwx------. 1 root root 64  4. Okt 17:42 1 -> 'socket:[51479]'
>> 65261 0 lrwx------. 1 root root 64  4. Okt 17:42 10 -> 'anon_inode:[eventfd]'
>> 65262 0 lrwx------. 1 root root 64  4. Okt 17:42 11 -> 'socket:[51485]'
>> 65263 0 lrwx------. 1 root root 64  4. Okt 17:42 12 -> 'socket:[51487]'
>> 65264 0 lrwx------. 1 root root 64  4. Okt 17:42 13 -> 'socket:[51486]'
>> 65265 0 lrwx------. 1 root root 64  4. Okt 17:42 14 -> 'anon_inode:[eventfd]'
>> 65266 0 lrwx------. 1 root root 64  4. Okt 17:42 15 -> 'socket:[60421]'
>> 65267 0 lrwx------. 1 root root 64  4. Okt 17:42 16 -> 'anon_inode:[eventfd]'
>> 65268 0 lrwx------. 1 root root 64  4. Okt 17:42 17 -> 'socket:[28008]'
>> 65269 0 l-wx------. 1 root root 64  4. Okt 17:42 18 -> /run/libvirt/nodedev/driver.pid
>> 65270 0 lrwx------. 1 root root 64  4. Okt 17:42 19 -> 'socket:[28818]'
>> 65254 0 lrwx------. 1 root root 64  4. Okt 17:42 2 -> 'socket:[51479]'
>> 65271 0 lr-x------. 1 root root 64  4. Okt 17:42 20 -> '/dev/vfio/3 (deleted)'
> 
> Seems like a userspace bug to keep the group FD open after the /dev/
> file has been deleted :|
> 
> What do you think about this?
> 
> commit a54a852b1484b1605917a8f4d80691db333b25ed
> Author: Jason Gunthorpe <jgg@ziepe.ca>
> Date:   Tue Oct 4 13:14:37 2022 -0300
> 
>      vfio: Make the group FD disassociate from the iommu_group
>      
>      Allow the vfio_group struct to exist with a NULL iommu_group pointer. When
>      the pointer is NULL the vfio_group users promise not to touch the
>      iommu_group. This allows a driver to be hot unplugged while userspace is
>      keeping the group FD open.
>      
>      SPAPR mode is excluded from this behavior because of how it wrongly hacks
>      part of its iommu interface through KVM. Due to this we loose control over
>      what it is doing and cannot revoke the iommu_group usage in the IOMMU
>      layer via vfio_group_detach_container().
>      
>      Thus, for SPAPR the group FDs must still be closed before a device can be
>      hot unplugged.
>      
>      This fixes a userspace regression where we learned that virtnodedevd
>      leaves a group FD open even though the /dev/ node for it has been deleted
>      and all the drivers for it unplugged.
>      
>      Fixes: ca5f21b25749 ("vfio: Follow a strict lifetime for struct iommu_group")
>      Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>      Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Almost :-)

drivers/vfio/vfio_main.c: In function 'vfio_file_is_group':
drivers/vfio/vfio_main.c:1606:47: error: expected ')' before ';' token
  1606 |         return (file->f_op == &vfio_group_fops;
       |                ~                              ^
       |                                               )
drivers/vfio/vfio_main.c:1606:48: error: expected ';' before '}' token
  1606 |         return (file->f_op == &vfio_group_fops;
       |                                                ^
       |                                                ;
  1607 | }
       | ~


With that fixed I get:

ERROR: modpost: "vfio_file_is_group" [drivers/vfio/pci/vfio-pci-core.ko] undefined!

With that worked around (m -> y)


Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>

At least the vfio-ap part
