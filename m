Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9243FCE30
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 19:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfKNSz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 13:55:56 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12152 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfKNSz4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 13:55:56 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcda3030000>; Thu, 14 Nov 2019 10:54:59 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 14 Nov 2019 10:55:55 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 14 Nov 2019 10:55:55 -0800
Received: from [10.25.73.195] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 14 Nov
 2019 18:55:47 +0000
Subject: Re: [PATCH v9 Kernel 1/5] vfio: KABI for migration interface for
 device state
To:     Yan Zhao <yan.y.zhao@intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
 <1573578220-7530-2-git-send-email-kwankhede@nvidia.com>
 <20191112153005.53bf324c@x1.home> <20191113032332.GB18001@joy-OptiPlex-7040>
 <d0be166b-9ffe-645d-de74-b48855995326@nvidia.com>
 <20191114003615.GD18001@joy-OptiPlex-7040>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <5592adf5-7df8-6e1a-b178-87aeee427a6a@nvidia.com>
Date:   Fri, 15 Nov 2019 00:25:42 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191114003615.GD18001@joy-OptiPlex-7040>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573757700; bh=XrShVMnf9uJujHfUuS2c47K8whoPmvpawwcuMHNBAMA=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=GgpM7ZNnGmkiiTETY4CU47H+NR9yvfnU2hqriOTZFg4RwYBO1KKT7iuKy+ccw/oXQ
         tZOTLVY3BijIPIwP2QbDNAyTD45RN/UPtFvQARmraSoz9FcLYmRMIzmahSDjxDCJXz
         6vuFGGM0leGf6IA8AEjds8vEzZvJwR6nIt4p1QSrGqZOG/rM3Jeo+XgG824EuqJBPZ
         rnLntl4olnWaiO8UWSb/c2B5qzocf0Ub64CjQkYll2Dy6KgYwPwwztRbHHoOa5LyS9
         aEi0wOuPlmYlcieHtx8BulUtmh954b7PlQDur5wXHha8NY8cTemIgnFRFlZV5cjPqw
         zkc1Yhr1xyRUQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


>>>>> + * Vendor driver should decide whether to partition data section and how to
>>>>> + * partition the data section. Vendor driver should return data_offset
>>>>> + * accordingly.
>>>>> + *
>>>>> + * Sequence to be followed for _SAVING|_RUNNING device state or pre-copy phase
>>>>> + * and for _SAVING device state or stop-and-copy phase:
>>>>> + * a. read pending_bytes. If pending_bytes > 0, go through below steps.
>>>>> + * b. read data_offset, indicates kernel driver to write data to staging buffer.
>>>>> + *    Kernel driver should return this read operation only after writing data to
>>>>> + *    staging buffer is done.
>>> May I know under what condition this data_offset will be changed per
>>> each iteration from a-f ?
>>>
>>
>> Its upto vendor driver, if vendor driver maintains multiple partitions
>> in data section.
>>
> So, do you mean each time before doing b (reading data_offset), step a
> (reading pending_bytes) is mandatory, otherwise the vendor driver does
> not know which data_offset is?

pending_bytes will only tell bytes remaining to transfer from vendor 
driver. On read operation on data_offset, vendor driver should decide 
what to send depending on where he is making data available to userspace.

> Then, any lock to wrap step a and b to ensure atomic?

With current QEMU implementation, where migration is single thread, 
there is not need of lock yet. But when we add multi-threaded support 
may be in future then locks will be required in userspace side.

Thanks,
Kirti
