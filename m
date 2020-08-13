Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED00424334D
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 06:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbgHMEZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 00:25:15 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50563 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725298AbgHMEZP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 00:25:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597292714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5PPbrW4CSztn1ObcO69vjUZRVg4SYJU7VAI203g9mjo=;
        b=V/oQmgxAQ4bKpLike9JZ5IyBH+VTlZe5YxHVZ1ZVsVPfTO4ExhlstHDRPsU9eB2B3VR18+
        RDXtEWvuUYn2pCFWmlsAx2guz2jsf1r0PLHWKRG6yVdEkKoFFhMPKUWwO4+9M4D4INv1p7
        PsheV82zCVihjqlxZsNpDqvqMfkWeuM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-vb4WYu46NBKDrN8lTjFs7w-1; Thu, 13 Aug 2020 00:25:12 -0400
X-MC-Unique: vb4WYu46NBKDrN8lTjFs7w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8811C107ACCA;
        Thu, 13 Aug 2020 04:25:09 +0000 (UTC)
Received: from [10.72.13.44] (ovpn-13-44.pek2.redhat.com [10.72.13.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B8B919D7B;
        Thu, 13 Aug 2020 04:24:52 +0000 (UTC)
Subject: Re: device compatibility interface for live migration with assigned
 devices
To:     Yan Zhao <yan.y.zhao@intel.com>, Jiri Pirko <jiri@mellanox.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        eskultet@redhat.com, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Parav Pandit <parav@mellanox.com>, jian-feng.ding@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, hejie.xu@intel.com,
        bao.yumeng@zte.com.cn,
        Alex Williamson <alex.williamson@redhat.com>,
        smooney@redhat.com, intel-gvt-dev@lists.freedesktop.org,
        berrange@redhat.com, corbet@lwn.net, dinechin@redhat.com,
        devel@ovirt.org
References: <20200727162321.7097070e@x1.home>
 <20200729080503.GB28676@joy-OptiPlex-7040>
 <20200804183503.39f56516.cohuck@redhat.com>
 <c178a0d3-269d-1620-22b1-9010f602d8ff@redhat.com>
 <20200805021654.GB30485@joy-OptiPlex-7040>
 <2624b12f-3788-7e2b-2cb7-93534960bcb7@redhat.com>
 <20200805075647.GB2177@nanopsycho>
 <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
 <20200805093338.GC30485@joy-OptiPlex-7040> <20200805105319.GF2177@nanopsycho>
 <20200810074631.GA29059@joy-OptiPlex-7040>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e6e75807-0614-bd75-aeb6-64d643e029d3@redhat.com>
Date:   Thu, 13 Aug 2020 12:24:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200810074631.GA29059@joy-OptiPlex-7040>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/8/10 下午3:46, Yan Zhao wrote:
>> driver is it handled by?
> It looks that the devlink is for network device specific, and in
> devlink.h, it says
> include/uapi/linux/devlink.h - Network physical device Netlink
> interface,


Actually not, I think there used to have some discussion last year and 
the conclusion is to remove this comment.

It supports IB and probably vDPA in the future.


>   I feel like it's not very appropriate for a GPU driver to use
> this interface. Is that right?


I think not though most of the users are switch or ethernet devices. It 
doesn't prevent you from inventing new abstractions.

Note that devlink is based on netlink, netlink has been widely used by 
various subsystems other than networking.

Thanks


>
> Thanks
> Yan
>   
>

