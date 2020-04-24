Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1779C1B6E35
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 08:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgDXGcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 02:32:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52287 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725967AbgDXGcM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 02:32:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587709930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Br99cdVjmyMMmE/vnpE4Kpx523ywPgMa8SOIrrQl4mQ=;
        b=KJe2frUxZz5wysffWwDZtlt04cNIMSxzV5NTejiRBfha0R7BJ2yW8ymNvLG0nSr0qaIoqv
        9Z4nmWmqMM/OkvxbRzPlsC8xh6bo1cO/LqrGhgPE0DOh12CfsFnwOZQwHhSOPN2rrYV7dN
        8hpeD2AJthDFKmBLsIB6d/65N971vHs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-3lI3ysjhOsOdV7hKIARvLQ-1; Fri, 24 Apr 2020 02:32:06 -0400
X-MC-Unique: 3lI3ysjhOsOdV7hKIARvLQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 633C880B70A;
        Fri, 24 Apr 2020 06:32:02 +0000 (UTC)
Received: from [10.72.13.62] (ovpn-13-62.pek2.redhat.com [10.72.13.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF0DD60605;
        Fri, 24 Apr 2020 06:31:42 +0000 (UTC)
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
To:     Jason Gunthorpe <jgg@mellanox.com>,
        Dave Jiang <dave.jiang@intel.com>
Cc:     vkoul@kernel.org, megha.dey@linux.intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zha Bin <zhabin@linux.alibaba.com>,
        "Liu, Jing2" <jing2.liu@linux.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c5e3320c-24b6-37d9-92cc-aa0a1bb5367f@redhat.com>
Date:   Fri, 24 Apr 2020 14:31:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200421235442.GO11945@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/4/22 =E4=B8=8A=E5=8D=887:54, Jason Gunthorpe wrote:
>> The mdev utilizes Interrupt Message Store or IMS[3] instead of MSIX fo=
r
>> interrupts for the guest. This preserves MSIX for host usages and also=
 allows a
>> significantly larger number of interrupt vectors for guest usage.
> I never did get a reply to my earlier remarks on the IMS patches.
>
> The concept of a device specific addr/data table format for MSI is not
> Intel specific. This should be general code. We have a device that can
> use this kind of kernel capability today.
>
> Jason
>

+1.

Another example is to extend virtio MMIO to support MSI[1].

Thanks

[1] https://lkml.org/lkml/2020/2/10/127


