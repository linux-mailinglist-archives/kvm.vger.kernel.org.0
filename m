Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8982619CE34
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 03:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390198AbgDCBic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 21:38:32 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32499 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389171AbgDCBic (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 21:38:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585877911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sxKKBZOSjS4SdoY0/0z3b/PmUuVXiHXvMP0+Tr+BScs=;
        b=b39jap70qI69lNa9rEFB9cQXC2mYmULAhQnSw3knntpcLy411xzrk2elgWT+Cn9JSea+zA
        Hh+E1q29+QLtiT4tqZQoWq2BMUFhG7y70U5MseFueeqaFUTjcgaJ8M0eXKJadRJ5LrzPql
        bnga8MnSW555S/42i/BmD/TdfUaqKw4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-a4PVFsVwOPqZ0ekjeyc6JQ-1; Thu, 02 Apr 2020 21:38:28 -0400
X-MC-Unique: a4PVFsVwOPqZ0ekjeyc6JQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 901EE477;
        Fri,  3 Apr 2020 01:38:26 +0000 (UTC)
Received: from [10.72.13.110] (ovpn-13-110.pek2.redhat.com [10.72.13.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDFA160BF1;
        Fri,  3 Apr 2020 01:38:06 +0000 (UTC)
Subject: Re: [PATCH v2 00/22] intel_iommu: expose Shared Virtual Addressing to
 VMs
To:     Peter Xu <peterx@redhat.com>
Cc:     jean-philippe@linaro.org, kevin.tian@intel.com,
        Liu Yi L <yi.l.liu@intel.com>, kvm@vger.kernel.org,
        mst@redhat.com, jun.j.tian@intel.com, qemu-devel@nongnu.org,
        eric.auger@redhat.com, alex.williamson@redhat.com,
        pbonzini@redhat.com, david@gibson.dropbear.id.au,
        yi.y.sun@intel.com, hao.wu@intel.com
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <984e6f47-2717-44fb-7ff2-95ca61d1858f@redhat.com>
 <20200402134601.GJ7174@xz-x1>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <02544abd-17d8-e5e1-788c-b4a5ddd3a382@redhat.com>
Date:   Fri, 3 Apr 2020 09:38:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200402134601.GJ7174@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/4/2 =E4=B8=8B=E5=8D=889:46, Peter Xu wrote:
> On Thu, Apr 02, 2020 at 04:33:02PM +0800, Jason Wang wrote:
>>> The complete QEMU set can be found in below link:
>>> https://github.com/luxis1999/qemu.git: sva_vtd_v10_v2
>>
>> Hi Yi:
>>
>> I could not find the branch there.
> Jason,
>
> He typed wrong... It's actually (I found it myself):
>
> https://github.com/luxis1999/qemu/tree/sva_vtd_v10_qemu_v2


Aha, I see.

Thanks


>

