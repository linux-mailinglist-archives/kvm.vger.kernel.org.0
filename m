Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB49E65F807
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 01:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbjAFAQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 19:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbjAFAQz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 19:16:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1343D5C6;
        Thu,  5 Jan 2023 16:16:54 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305NrhdD009127;
        Fri, 6 Jan 2023 00:16:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0txPS+Fe0isHMMMFB0nqnr3ibkapoxzfGBRriG2Fuvk=;
 b=Uih3Yx6jybaiL7rHKpItc8pwIG2PQps4Q/ip2lgwGXT5cWjUk8IY7W+5MXr/UOl8Jd4l
 KxbeuuOwhpPwnl4nheUkK4FScIomRN1J9l1nj6RLcQmJHay63m70D065EI9OJxR+1Ow4
 kHP+bH6VJXg8FeX/47mFR2WvHQPTZhwC2MdvAiXu0znTSfbkQCZDAofiJUeKNW22VMSq
 t9DySDUXp4hWXHyo5MKL70Ry756UK+7iGmWp+3EAp2YJvoYYHFb86bvijLay6BCQz/WN
 sIIAlwIiCmuIo9p+YAMv8uxU1b7w+1aCO8+8nJZyGz2DOIw+/QU+3urDNWMdoevQmirW rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx8mgremj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Jan 2023 00:16:43 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3060Fp7a021830;
        Fri, 6 Jan 2023 00:16:42 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx8mgrem0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Jan 2023 00:16:42 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 305NgNCn026033;
        Fri, 6 Jan 2023 00:16:41 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3mtcq80q65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Jan 2023 00:16:41 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3060Gdvj38732206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Jan 2023 00:16:39 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 554A65803F;
        Fri,  6 Jan 2023 00:16:39 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 030FC5805A;
        Fri,  6 Jan 2023 00:16:38 +0000 (GMT)
Received: from [9.160.126.91] (unknown [9.160.126.91])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  6 Jan 2023 00:16:37 +0000 (GMT)
Message-ID: <5e17a35d-2a94-f482-c466-521afcab80b8@linux.ibm.com>
Date:   Thu, 5 Jan 2023 19:16:37 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, borntraeger@linux.ibm.com,
        jjherne@linux.ibm.com, akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>
References: <20220519183311.582380-1-mjrosato@linux.ibm.com>
 <20220519183311.582380-2-mjrosato@linux.ibm.com>
 <20230105150930.6ee65182.alex.williamson@redhat.com>
 <Y7dehnZSC6ukNxKU@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <Y7dehnZSC6ukNxKU@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pCL2byT9YMSbrJE2QEZagmKhcozVLM0p
X-Proofpoint-GUID: aib17-pDe8mHzMc8KvnEyz30qyj7uOqn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_13,2023-01-05_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 impostorscore=0 phishscore=0 mlxlogscore=999 clxscore=1011 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050189
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/23 6:34 PM, Jason Gunthorpe wrote:
> On Thu, Jan 05, 2023 at 03:09:30PM -0700, Alex Williamson wrote:
>> On Thu, 19 May 2022 14:33:11 -0400
>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>
>>> Rather than relying on a notifier for associating the KVM with
>>> the group, let's assume that the association has already been
>>> made prior to device_open.  The first time a device is opened
>>> associate the group KVM with the device.
>>>
>>> This fixes a user-triggerable oops in GVT.
>>
>> It seems this has traded an oops for a deadlock, which still exists
>> today in both GVT-g and vfio-ap.  These are the only vfio drivers that
>> care about kvm, so they make use of kvm_{get,put}_kvm(), where the

vfio-pci-zdev also

>> latter is called by their .close_device() callbacks.

Huh, I've never seen this deadlock with vfio-pci-zdev or vfio-ap, but I see what you're saying...  I guess it's not seen under typical circumstances with QEMU because kvm_vfio_group_del would have already been triggered via KVM_DEV_VFIO_GROUP_DEL by the time we close the device, such that the group would not be found during the kvm_vfio_destroy call?  (I'm not at all suggesting that we should rely on userspace behaving in this order, just wondering why I never saw it while testing)

> 
> Bleck
> 
> It is pretty common to run the final part of 'put' from a workqueue
> specifically to avoid stuff like this, eg fput does it
> 
> Maybe that is the simplest?

Yeah, this is also what I was thinking, replace the direct kvm_put_kvm calls with, say, schedule_delayed_work in each driver, where the delayed task just does the kvm_put_kvm (along with a brief comment explaining why we handle the put asynchronously).

Other than that..  The goal of this patch originally was to get the kvm reference at first open_device and release it with the very last close_device, so the only other option I could think of would be to take the responsibility back from the vfio drivers and do the kvm_get_kvm and kvm_put_kvm directly in vfio_main after dropping the  (but that would result in some ugly symbol linkage and would acquire kvm references that a driver maybe does not care about so I don't really like that idea)

