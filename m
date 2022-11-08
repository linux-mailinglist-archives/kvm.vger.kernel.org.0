Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C8E62138E
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 14:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbiKHNve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 08:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbiKHNvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 08:51:22 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980B560EB5;
        Tue,  8 Nov 2022 05:51:16 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A8D16Za009658;
        Tue, 8 Nov 2022 13:50:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=uP4Y/yDPhOKJEQ20tkHx+KIyFrfiSyOWW4zDghEM2sE=;
 b=aRLjotHNafp95Gsum6cYuNf+Oevtc+NnovQSOlDI4CEtr92RxWdd76xlBrcogzCRqfjz
 GT6DWnfOQoevEsEuxB6CBWS8QiN9JOGU9V0J0sYcAeXg4WaszOSA/SdgO+/QAISXmFPo
 F2mWAnaM7dcPTDPGjcgt+uWMpyhneziBtFHeRRDzb40QL97JQkiid10ceeDD0UiccAo+
 946VIHYI61JWMSQTpp+B2/HTZwPm+bT8UCVhwmVJ83PfbfsDqFumjfSsK+zIIkx/s5Vd
 F5Thz/FmibhrJeG+Tt5LxFa8XSBt/MO+ELDaUI4NDLHYM5vvkPS7CJiZi0ujwU/rqw14 sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kqcpvv36r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 13:50:59 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A8DO3Mc021918;
        Tue, 8 Nov 2022 13:50:58 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kqcpvv367-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 13:50:58 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A8DZ3aU010374;
        Tue, 8 Nov 2022 13:50:57 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 3kngmt4gyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 13:50:57 +0000
Received: from smtpav06.wdc07v.mail.ibm.com ([9.208.128.115])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A8DouQN25035066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Nov 2022 13:50:56 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7DA958066;
        Tue,  8 Nov 2022 13:50:55 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EEB85804E;
        Tue,  8 Nov 2022 13:50:54 +0000 (GMT)
Received: from [9.160.191.98] (unknown [9.160.191.98])
        by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  8 Nov 2022 13:50:54 +0000 (GMT)
Message-ID: <c32829c8-1259-7441-f6df-04f44a39ab2f@linux.ibm.com>
Date:   Tue, 8 Nov 2022 08:50:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: S390 testing for IOMMUFD
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
 <Y2msLjrbvG5XPeNm@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <Y2msLjrbvG5XPeNm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ahw-AsG31tlN-zoB6D2ZMeo0NyX1xL31
X-Proofpoint-GUID: Tr2Yi4qgkWOi-Zoke6xbIdACyFsGLLRG
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211080080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/7/22 8:09 PM, Jason Gunthorpe wrote:
> On Mon, Nov 07, 2022 at 08:48:53PM -0400, Jason Gunthorpe wrote:
>> [
>> This has been in linux-next for a little while now, and we've completed
>> the syzkaller run. 1300 hours of CPU time have been invested since the
>> last report with no improvement in coverage or new detections. syzkaller
>> coverage reached 69%(75%), and review of the misses show substantial
>> amounts are WARN_ON's and other debugging which are not expected to be
>> covered.
>> ]
>>
>> iommufd is the user API to control the IOMMU subsystem as it relates to
>> managing IO page tables that point at user space memory.
> 
> [chop cc list]
> 
> s390 mdev maintainers,
> 
> Can I ask your help to test this with the two S390 mdev drivers? Now
> that gvt is passing and we've covered alot of the QA ground it is a
> good time to run it.
> 
> Take the branch from here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/log/?h=for-next
> 
> And build the kernel with 
> 
> CONFIG_VFIO_CONTAINER=n
> CONFIG_IOMMUFD=y
> CONFIG_IOMMUFD_VFIO_CONTAINER=y
> 
> And your existing stuff should work with iommufd providing the iommu
> support to vfio. There will be a dmesg confirming this.
> 
> Let me know if there are any problems!

FWIW, vfio-pci via s390 is working fine so far, though I'll put it through more paces over the next few weeks and report if I find anything.

As far as mdev drivers...  

-ccw: Sounds like Eric is already aware there is an issue and is investigating (I see errors as well).

-ap: I see the exact same issue that Christian mentioned...  I'll talk to Tony & Jason about it.

> 
> If I recall there was some desire from the S390 platform team to start
> building on iommufd to create some vIOMMU acceleration for S390
> guests, this is a necessary first step.

There's probably something here for -ccw in the future, but you might be thinking of s390 vfio-pci e.g. to implement the in-kernel handling of nested mappings on s390 -- yep, work in in progress here, not ready for sharing yet but I have been most recently basing my work on top of the nesting series https://github.com/yiliu1765/iommufd/tree/iommufd-v6.0-rc3-nesting

Matt


