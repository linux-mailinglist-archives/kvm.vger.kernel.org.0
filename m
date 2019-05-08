Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFC11857E
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 08:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfEIGp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 02:45:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34966 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbfEIGp5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 May 2019 02:45:57 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x496aaRM118187
        for <kvm@vger.kernel.org>; Thu, 9 May 2019 02:45:56 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2scej19n7n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 02:45:56 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <fiuczy@linux.ibm.com>;
        Thu, 9 May 2019 07:45:53 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 9 May 2019 07:45:45 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x496jhIf55050456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 May 2019 06:45:43 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F056A4065;
        Thu,  9 May 2019 06:45:43 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 534D2A4054;
        Thu,  9 May 2019 06:45:42 +0000 (GMT)
Received: from [10.0.2.15] (unknown [9.152.222.56])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 May 2019 06:45:42 +0000 (GMT)
Subject: Re: [libvirt] [PATCH v2 1/2] vfio/mdev: add version attribute for
 mdev device
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Cc:     "cjia@nvidia.com" <cjia@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "arei.gonglei@huawei.com" <arei.gonglei@huawei.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
References: <20190506014514.3555-1-yan.y.zhao@intel.com>
 <20190506014904.3621-1-yan.y.zhao@intel.com>
 <20190507151826.502be009@x1.home> <20190508112740.GA24397@joy-OptiPlex-7040>
 <20190508152242.4b54a5e7@x1.home>
From:   Boris Fiuczynski <fiuczy@linux.ibm.com>
Date:   Wed, 8 May 2019 17:27:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190508152242.4b54a5e7@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050906-0008-0000-0000-000002E4CB1B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050906-0009-0000-0000-000022514FBA
Message-Id: <5eac912c-e753-b5f6-83a4-b646f991d858@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905090043
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/8/19 11:22 PM, Alex Williamson wrote:
>>> I thought there was a request to make this more specific to migration
>>> by renaming it to something like migration_version.  Also, as an
>>>   
>> so this attribute may not only include a mdev device's parent device info and
>> mdev type, but also include numeric software version of vendor specific
>> migration code, right?
> It's a vendor defined string, it should be considered opaque to the
> user, the vendor can include whatever they feel is relevant.
> 
Would a vendor also be allowed to provide a string expressing required 
features as well as containing backend resource requirements which need 
to be compatible for a successful migration? Somehow a bit like a cpu 
model... maybe even as json or xml...
I am asking this with vfio-ap in mind. In that context checking 
compatibility of two vfio-ap mdev devices is not as simple as checking 
if version A is smaller or equal to version B.

-- 
Mit freundlichen Grüßen/Kind regards
    Boris Fiuczynski

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

