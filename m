Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB90632E4
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 10:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfGIIiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 04:38:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49582 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfGIIiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 04:38:01 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A91D433027C;
        Tue,  9 Jul 2019 08:38:01 +0000 (UTC)
Received: from [10.36.116.46] (ovpn-116-46.ams2.redhat.com [10.36.116.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 27AAC5D70D;
        Tue,  9 Jul 2019 08:37:50 +0000 (UTC)
Subject: Re: [RFC v1 02/18] linux-headers: import vfio.h from kernel
To:     Peter Xu <zhexu@redhat.com>, Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-3-git-send-email-yi.l.liu@intel.com>
 <20190709015800.GA566@xz-x1>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <b2e9cc9b-2972-f83e-1cb1-ba292b0e99e7@redhat.com>
Date:   Tue, 9 Jul 2019 10:37:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190709015800.GA566@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 09 Jul 2019 08:38:01 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Liu,

On 7/9/19 3:58 AM, Peter Xu wrote:
> On Fri, Jul 05, 2019 at 07:01:35PM +0800, Liu Yi L wrote:
>> This patch imports the vIOMMU related definitions from kernel
>> uapi/vfio.h. e.g. pasid allocation, guest pasid bind, guest pasid
>> table bind and guest iommu cache invalidation.
>>
>> Cc: Kevin Tian <kevin.tian@intel.com>
>> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Cc: Peter Xu <peterx@redhat.com>
>> Cc: Eric Auger <eric.auger@redhat.com>
>> Cc: Yi Sun <yi.y.sun@linux.intel.com>
>> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> 
> Just a note that in the last version you can use
> scripts/update-linux-headers.sh to update the headers.  For this RFC
> it's perfectly fine.
> 

You will need to update scripts/update-linux-headers.sh to import the
new iommu.h header. See "[RFC v4 02/27] update-linux-headers: Import
iommu.h"
https://www.mail-archive.com/qemu-devel@nongnu.org/msg620098.html.

Thanks

Eric
