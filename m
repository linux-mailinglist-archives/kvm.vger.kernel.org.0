Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBE9367C62
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 10:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbhDVIUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 04:20:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22728 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235385AbhDVIUf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 04:20:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619079579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xHywtxI3pNGHCs9NAnF/msLigH9rjPmkvDS5057lzus=;
        b=h6OOLa6NZk/88hiS/Bka4H/otRFOjw6yv1LWrytYy2+BGIfxcqY6FxhWCio/upAlrVfdsl
        xQ1CqkcN/yEZ0aTqG/kykKwxrDFxcFcWQLd8EI/nNqfe01RMJKBkcWDuVOyp88mSKn7+93
        qsgLRGhna0c9RzcKg31t0NGoxwZ4b34=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-yyTTz9KuMi29o3s8dGVJbQ-1; Thu, 22 Apr 2021 04:19:30 -0400
X-MC-Unique: yyTTz9KuMi29o3s8dGVJbQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5692107ACC7;
        Thu, 22 Apr 2021 08:19:28 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-214.pek2.redhat.com [10.72.13.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95228100AE2C;
        Thu, 22 Apr 2021 08:19:18 +0000 (UTC)
Subject: Re: [RFC PATCH 0/7] Untrusted device support for virtio
To:     Christoph Hellwig <hch@infradead.org>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        martin.radev@aisec.fraunhofer.de, konrad.wilk@oracle.com,
        kvm@vger.kernel.org
References: <20210421032117.5177-1-jasowang@redhat.com>
 <20210422063128.GB4176641@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0c61dcbb-ac5b-9815-a4a1-5f93ae640011@redhat.com>
Date:   Thu, 22 Apr 2021 16:19:16 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210422063128.GB4176641@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/4/22 ÏÂÎç2:31, Christoph Hellwig Ð´µÀ:
> On Wed, Apr 21, 2021 at 11:21:10AM +0800, Jason Wang wrote:
>> The behaivor for non DMA API is kept for minimizing the performance
>> impact.
> NAK.  Everyone should be using the DMA API in a modern world.  So
> treating the DMA API path worse than the broken legacy path does not
> make any sense whatsoever.


I think the goal is not treat DMA API path worse than legacy. The issue 
is that the management layer should guarantee that ACCESS_PLATFORM is 
set so DMA API is guaranteed to be used by the driver. So I'm not sure 
how much value we can gain from trying to 'fix' the legacy path. But I 
can change the behavior of legacy path to match DMA API path.

Thanks

