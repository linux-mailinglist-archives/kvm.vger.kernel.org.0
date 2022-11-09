Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF82622E57
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 15:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiKIOt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 09:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiKIOt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 09:49:26 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34D9116C;
        Wed,  9 Nov 2022 06:49:25 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9EdGA9026409;
        Wed, 9 Nov 2022 14:49:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ni/BG7gnOiqmRl9kheWYoxiUHrqf0PqdIfCsUfmenQ0=;
 b=HPLJ6dfc5ctDIWPoNKoFU16g9vul+tO3IISY4yDQ0lPsYmdAzvYgvzznr+qB9cTb+CDT
 rpfqCHGki7BwPLC39OwRwNE2oJnu2LQOFlYsHuXqw7CtL6tgjHbMCaesof/uT2EaBgPI
 HVluPdDjWmpOakiavPHCjgVKI1r8U3yqN2zTGBxPeg+VGbZHAG5PKaBCNTw/2khVmECU
 ta4mN8sZ++7vd47A5x5pc9A2CJuUW/AeDMODqMJNf8qdfIB3cEDLgkImfKTeRHVLJWxs
 3PEfqUqvns3jOtn0paDSdjebrJ1Cxfxpa+EB4Smn8vuREefRM0BD4v5oQ80snKpRNJ0l Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3krdtd10n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 14:49:06 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A9EdL6l027041;
        Wed, 9 Nov 2022 14:49:05 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3krdtd10mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 14:49:05 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A9Ea0Jj009869;
        Wed, 9 Nov 2022 14:49:04 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 3kngs7e9ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 14:49:04 +0000
Received: from smtpav05.dal12v.mail.ibm.com ([9.208.128.132])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A9En7Q47602746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Nov 2022 14:49:07 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 285CD58052;
        Wed,  9 Nov 2022 14:49:03 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF1BE5804C;
        Wed,  9 Nov 2022 14:49:01 +0000 (GMT)
Received: from [9.160.53.158] (unknown [9.160.53.158])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  9 Nov 2022 14:49:01 +0000 (GMT)
Message-ID: <73dd6b0e-35c7-bb5d-b392-a9de012d4f92@linux.ibm.com>
Date:   Wed, 9 Nov 2022 09:49:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: S390 testing for IOMMUFD
Content-Language: en-US
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
 <Y2msLjrbvG5XPeNm@nvidia.com>
 <fbb84105-cc6e-59bd-b09c-0ea4353d7605@linux.ibm.com>
 <d814e245-2255-15ce-cf3d-65788aa61689@linux.ibm.com>
In-Reply-To: <d814e245-2255-15ce-cf3d-65788aa61689@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vFMHgU3Okx5cKYLnBTGlNT2ab1WWRkFn
X-Proofpoint-GUID: Nx0QGFwXOP3HzOJOKKP58wxdf8oGkskU
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211090110
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/8/22 9:04 AM, Anthony Krowiak wrote:
>
> On 11/8/22 5:12 AM, Christian Borntraeger wrote:
>>
>>
>> Am 08.11.22 um 02:09 schrieb Jason Gunthorpe:
>>> On Mon, Nov 07, 2022 at 08:48:53PM -0400, Jason Gunthorpe wrote:
>>>> [
>>>> This has been in linux-next for a little while now, and we've 
>>>> completed
>>>> the syzkaller run. 1300 hours of CPU time have been invested since the
>>>> last report with no improvement in coverage or new detections. 
>>>> syzkaller
>>>> coverage reached 69%(75%), and review of the misses show substantial
>>>> amounts are WARN_ON's and other debugging which are not expected to be
>>>> covered.
>>>> ]
>>>>
>>>> iommufd is the user API to control the IOMMU subsystem as it 
>>>> relates to
>>>> managing IO page tables that point at user space memory.
>>>
>>> [chop cc list]
>>>
>>> s390 mdev maintainers,
>>>
>>> Can I ask your help to test this with the two S390 mdev drivers? Now
>>> that gvt is passing and we've covered alot of the QA ground it is a
>>> good time to run it.
>>>
>>> Take the branch from here:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/log/?h=for-next 
>>>
>>
>>>
>>> And build the kernel with
>>>
>>> CONFIG_VFIO_CONTAINER=n
>>> CONFIG_IOMMUFD=y
>>> CONFIG_IOMMUFD_VFIO_CONTAINER=y
>>>
>>> And your existing stuff should work with iommufd providing the iommu
>>> support to vfio. There will be a dmesg confirming this.
>>
>> Gave it a quick spin with vfio_ap:
>> [  401.679199] vfio_ap_mdev b01a7c33-9696-48b2-9a98-050e8e17c69a: 
>> Adding to iommu group 1
>> [  402.085386] iommufd: IOMMUFD is providing /dev/vfio/vfio, not VFIO.
>>
>> Some tests seem to work, but others dont (running into timeouts). I 
>> need to look
>> into that (or ideally Tony will have a look, FWIW 
>> tests.test_vfio_ap.VfioAPAssignMdevToGuestTest
>> fails for me.
>
>
> I'm looking into it.


I cloned the 
https://lore.kernel.org/kvm/Y2q3nFXwOk9jul5u@nvidia.com/T/#m76a9c609c5ccd1494c05c6f598f9c8e75b7c9888 
repo and ran the vfio_ap test cases. The tests ran without encountering 
the errors related to the vfio_pin_pages() function, but I did see two 
tests fail attempting to run crypto tests on the guest. I also saw a 
WARN_ON stack trace in the dmesg output indicating a timeout occurred 
trying to verify the completion of a queue reset. The reset problem has 
reared its ugly head in our CI, so this may be a good thing as it will 
allow me to debug why its happening.


>
>
>>
>>
>> The same kernel tree with defconfig (instead of 
>> CONFIG_IOMMUFD_VFIO_CONTAINER=y) works fine.
>>>
>>> Let me know if there are any problems!
>>>
>>> If I recall there was some desire from the S390 platform team to start
>>> building on iommufd to create some vIOMMU acceleration for S390
>>> guests, this is a necessary first step.
>>>
>>> Thanks,
>>> Jason
