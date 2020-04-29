Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9051BE068
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 16:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgD2ONm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 10:13:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51455 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726883AbgD2ONl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 10:13:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588169620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z5KJj0/IEeIDfSeMUgMfCAULVkkEU1Ysj/D3ASB/G5k=;
        b=WNuX2fxAzU/di6jkyHj9GIO2EyzAzIulW6ybhUgDORSOSQzNAN5sI8Cxcyc57lpLeYbTC6
        hroV9+oWRo04SpJK4uHKHZinjgER0TsB8h1vyO7dxcgMcaAugcaa+ldlJCdK+yy5xszQQ+
        hHXlWGku8A9no/ppeM3p2K25E4r9GA0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-eJjW36AfMLWIeaVqCQ_XUQ-1; Wed, 29 Apr 2020 10:13:23 -0400
X-MC-Unique: eJjW36AfMLWIeaVqCQ_XUQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C31EF108BD0F;
        Wed, 29 Apr 2020 14:13:19 +0000 (UTC)
Received: from [10.10.116.80] (ovpn-116-80.rdu2.redhat.com [10.10.116.80])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 998945D9E5;
        Wed, 29 Apr 2020 14:13:02 +0000 (UTC)
Subject: Re: [PATCH v5 0/4] introduction of migration_version attribute for
 VFIO live migration
To:     Yan Zhao <yan.y.zhao@intel.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Zeng, Xin" <xin.zeng@intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
References: <20200421023718.GA12111@joy-OptiPlex-7040>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D86DF06@SHSMSX104.ccr.corp.intel.com>
 <20200422073628.GA12879@joy-OptiPlex-7040> <20200424191049.GU3106@work-vm>
 <20200426013628.GC12879@joy-OptiPlex-7040> <20200427153743.GK2923@work-vm>
 <20200428005429.GJ12879@joy-OptiPlex-7040> <20200428141437.GG2794@work-vm>
 <20200429072616.GL12879@joy-OptiPlex-7040> <20200429082201.GA2834@work-vm>
 <20200429093555.GM12879@joy-OptiPlex-7040>
From:   Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
Message-ID: <94cd58d2-0580-53cd-6ca2-2c33146e0f2c@redhat.com>
Date:   Wed, 29 Apr 2020 09:13:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200429093555.GM12879@joy-OptiPlex-7040>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[meta-comment]

On 4/29/20 4:35 AM, Yan Zhao wrote:
> On Wed, Apr 29, 2020 at 04:22:01PM +0800, Dr. David Alan Gilbert wrote:
[...]
>>>>>>>>>>>>>>>>> This patchset introduces a migration_version attribute under sysfs
>>>>>>>>>>> of VFIO
>>>>>>>>>>>>>>>>> Mediated devices.

Hmm, several pages with up to 16 levels of quoting, with editors making 
the lines ragged, all before I get to the real meat of the email. 
Remember, it's okay to trim content,...

>> So why don't we split the difference; lets say that it should start with
>> the hex PCI Vendor ID.
>>
> The problem is for mdev devices, if the parent devices are not PCI devices,
> they don't have PCI vendor IDs.

...to just what you are replying to.

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org

