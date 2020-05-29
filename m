Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141D91E8613
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 19:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgE2R6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 13:58:13 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5391 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbgE2R6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 13:58:12 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed14d280001>; Fri, 29 May 2020 10:58:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 29 May 2020 10:58:12 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 29 May 2020 10:58:12 -0700
Received: from [10.40.100.117] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 29 May
 2020 17:57:57 +0000
Subject: Re: [PATCH Kernel v22 0/8] Add UAPIs to support migration for VFIO
 devices
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
CC:     Yan Zhao <yan.y.zhao@intel.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <jonathan.davies@nutanix.com>, <eauger@redhat.com>,
        <aik@ozlabs.ru>, <pasic@linux.ibm.com>, <felipe@nutanix.com>,
        <Zhengxiao.zx@alibaba-inc.com>, <shuangtai.tst@alibaba-inc.com>,
        <Ken.Xue@amd.com>, <zhi.a.wang@intel.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
 <20200519105804.02f3cae8@x1.home> <20200525065925.GA698@joy-OptiPlex-7040>
 <426a5314-6d67-7cbe-bad0-e32f11d304ea@nvidia.com>
 <20200526141939.2632f100@x1.home> <20200527062358.GD19560@joy-OptiPlex-7040>
 <20200527084822.GC3001@work-vm> <20200528165906.7d03f689@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <b6d78fd3-d2d7-91c9-5f5d-a76ebe5a7a5e@nvidia.com>
Date:   Fri, 29 May 2020 23:27:53 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200528165906.7d03f689@x1.home>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590775080; bh=9rTtu3kf9bEqSZ338TiGiLKhOLfMIwfqgDH96m+5MN0=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Bi3iZMPRJkmpjpq4uCCp3csVA1rvg7ZAooXAbf73Z5wpp6GqG5UlV+dgG5faUiSJK
         /yJWHLGfqUOR7J0AB+ts4MWUeVF2yyzyB5c5eNsswzJ/9aBbgif4+VdnQlymTNaQli
         SToQlEnwJHQ9t5iGeOm5l9m3BRx2Yskol1AOY57tt7H7iXnVtk1MXGtk2aSnr3rSCg
         lgCxbsxLxyPPDr4A4xchIphUrNM0jelpn536XpUgSs+r84gS79kC3WcRKLsLlRfZrl
         VhwQexmuvf8rKvmy1F5NQM2xjVp+fLAtezFTrlMGGMjKVm6ZgpJC7XhLy9IlxIQxQR
         IR6TwBLCqeyqA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/29/2020 4:29 AM, Alex Williamson wrote:
> On Wed, 27 May 2020 09:48:22 +0100
> "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
>> * Yan Zhao (yan.y.zhao@intel.com) wrote:
>>> BTW, for viommu, the downtime data is as below. under the same network
>>> condition and guest memory size, and no running dirty data/memory produced
>>> by device.
>>> (1) viommu off
>>> single-round dirty query: downtime ~100ms
>>
>> Fine.
>>
>>> (2) viommu on
>>> single-round dirty query: downtime 58s
>>
>> Youch.
> 
> Double Youch!  But we believe this is because we're getting the dirty
> bitmap one IOMMU leaf page at a time, right?  We've enable the kernel
> to get a dirty bitmap across multiple mappings, but QEMU isn't yet
> taking advantage of it.  Do I have this correct?  Thanks,
> 

That's correct.

Thanks,
Kirti
