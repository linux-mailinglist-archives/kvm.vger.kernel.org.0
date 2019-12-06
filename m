Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6A2115986
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfLFXNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:13:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27130 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726374AbfLFXNm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:13:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575674022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c2liiLua+vDGh/gfnmWAijNKZrk6v9hVwlYubgc588Q=;
        b=AD/oX91nydqNI+O+z/3l9rl4Hvw1LrV9CdULFjYoNEHtvcd4miRAW3TjTrRKhib2dCecUC
        +0Z3a9Xb1B5IgaS/7ETV4yrslD6tlxWM8WP8DQsiwRhAVgrwnXZ8ogqX/G0z4zdbRaJzma
        hzGzv6EkKQ6GkW7sIqh7ybTqh3b40q4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-ke8FPo4OP5W046Jk9LX56w-1; Fri, 06 Dec 2019 18:13:38 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4919107ACC7;
        Fri,  6 Dec 2019 23:13:36 +0000 (UTC)
Received: from [10.3.116.171] (ovpn-116-171.phx2.redhat.com [10.3.116.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C3D65D6BB;
        Fri,  6 Dec 2019 23:13:31 +0000 (UTC)
Subject: Re: [RFC PATCH 1/9] vfio/pci: introduce mediate ops to intercept
 vfio-pci ops
To:     Yan Zhao <yan.y.zhao@intel.com>, alex.williamson@redhat.com
Cc:     kevin.tian@intel.com, kvm@vger.kernel.org, libvir-list@redhat.com,
        cohuck@redhat.com, linux-kernel@vger.kernel.org,
        zhenyuw@linux.intel.com, qemu-devel@nongnu.org,
        shaopeng.he@intel.com, zhi.a.wang@intel.com
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
 <20191205032536.29653-1-yan.y.zhao@intel.com>
From:   Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
Message-ID: <9461f821-73fd-a66f-e142-c1a55e38e7a0@redhat.com>
Date:   Fri, 6 Dec 2019 17:13:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191205032536.29653-1-yan.y.zhao@intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: ke8FPo4OP5W046Jk9LX56w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/4/19 9:25 PM, Yan Zhao wrote:
> when vfio-pci is bound to a physical device, almost all the hardware
> resources are passthroughed.

The intent is obvious, but it sounds awkward to a native speaker.
s/passthroughed/passed through/

> Sometimes, vendor driver of this physcial device may want to mediate some

physical

> hardware resource access for a short period of time, e.g. dirty page
> tracking during live migration.
> 
> Here we introduce mediate ops in vfio-pci for this purpose.
> 
> Vendor driver can register a mediate ops to vfio-pci.
> But rather than directly bind to the passthroughed device, the

passed-through

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org

