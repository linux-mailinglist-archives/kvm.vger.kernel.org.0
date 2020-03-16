Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB51F1869C1
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 12:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbgCPLIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 07:08:04 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55484 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730645AbgCPLIE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 07:08:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584356883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oLnbFyB1eV6nEdIYefNiKAvHZQY1co2NQx+tEzEcItA=;
        b=AabPCIiJuWMaO5o8c8XI0Eg6gVDpiwMSfhuRIJjtbbY4LWyre6QGM7OOORcvBpu2cP7rNE
        YUp8qlUc0MwnRR/YkMhQecEVq2xp3MdXZOO8SjRWF2sjCAuTCiKPXvKCUxN6+78KlTqyR+
        7B7IrmxUDw5bFV3DAlxyhx3WVbGqjZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-nUx1xulgPcSEsQGuTikr8g-1; Mon, 16 Mar 2020 07:08:01 -0400
X-MC-Unique: nUx1xulgPcSEsQGuTikr8g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6171F801E70;
        Mon, 16 Mar 2020 11:08:00 +0000 (UTC)
Received: from gondolin (ovpn-117-70.ams2.redhat.com [10.36.117.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBAA85C1B2;
        Mon, 16 Mar 2020 11:07:52 +0000 (UTC)
Date:   Mon, 16 Mar 2020 12:07:50 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jay Zhou <jianjay.zhou@huawei.com>
Cc:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <mst@redhat.com>, <peterx@redhat.com>,
        <wangxinxin.wang@huawei.com>, <weidong.huang@huawei.com>,
        <liu.jinsong@huawei.com>
Subject: Re: [PATCH] kvm: support to get/set dirty log initial-all-set
 capability
Message-ID: <20200316120750.509149ab.cohuck@redhat.com>
In-Reply-To: <20200304025554.2159-1-jianjay.zhou@huawei.com>
References: <20200304025554.2159-1-jianjay.zhou@huawei.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 4 Mar 2020 10:55:54 +0800
Jay Zhou <jianjay.zhou@huawei.com> wrote:

> Since the new capability KVM_DIRTY_LOG_INITIALLY_SET of
> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 has been introduced in the
> kernel, tweak the userspace side to detect and enable this
> capability.
> 
> Signed-off-by: Jay Zhou <jianjay.zhou@huawei.com>
> ---
>  accel/kvm/kvm-all.c       | 21 ++++++++++++++-------
>  linux-headers/linux/kvm.h |  3 +++
>  2 files changed, 17 insertions(+), 7 deletions(-)

<standard message>
Please do any linux-headers updates in a separate patch; that makes it
easy to replace the manual update with a complete headers update.
</standard message>

:)

