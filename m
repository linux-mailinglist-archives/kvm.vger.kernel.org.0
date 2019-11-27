Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4FB10AB7D
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 09:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfK0IMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 03:12:50 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43876 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726125AbfK0IMu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Nov 2019 03:12:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574842368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4GO5cDJE1Bxb5yiz/pxJvWOQ/f85zWGdpqW4AA0SXEI=;
        b=YY5cs0wgAXXuK8L2ppnnZr2pQz4c9LQXd5Zs+F/6Od+ktK9x0JfjeJB2zG0WLNe1nYdI63
        MXfo6A/JgXfr9CF854f63oXJWzLoc9Gw8USwxqMj29tAJM7bL6wv0C6vs/DBCqjKL6x78e
        T6ev21xqZVvJO8JfWzUQwk7XPJJGKt4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-_0e5tcQZNBa4qCcYFu_HSA-1; Wed, 27 Nov 2019 03:12:47 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 325C1800D54;
        Wed, 27 Nov 2019 08:12:45 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1E5119C69;
        Wed, 27 Nov 2019 08:12:38 +0000 (UTC)
Date:   Wed, 27 Nov 2019 09:12:37 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Xiang Zheng <zhengxiang9@huawei.com>
Cc:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>,
        <gengdongjiu@huawei.com>, <mtosatti@redhat.com>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <jonathan.cameron@huawei.com>,
        <xuwei5@huawei.com>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
        <linuxarm@huawei.com>, <wanghaibin.wang@huawei.com>
Subject: Re: [RESEND PATCH v21 2/6] docs: APEI GHES generation and CPER
 record description
Message-ID: <20191127091237.7bd64bbf@redhat.com>
In-Reply-To: <05d2ba81-501f-bd7e-8da4-73e413169688@huawei.com>
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
        <20191111014048.21296-3-zhengxiang9@huawei.com>
        <20191115104458.200a6231@redhat.com>
        <05d2ba81-501f-bd7e-8da4-73e413169688@huawei.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: _0e5tcQZNBa4qCcYFu_HSA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Nov 2019 09:37:57 +0800
Xiang Zheng <zhengxiang9@huawei.com> wrote:

> Hi Igor,
> 
> Thanks for your review!
> Since the series of patches are going to be merged, we will address your comments by follow up patches.

Yes, I know it's quite frustrating to respin series multiple times,
but on the other hand it's more frustrating later on when reader
tries to figure out mess caused by a bunch of fixups in commit
history.

With amount of issues spotted during review, which also requires
rewriting some patches. I don't see big vXX as a valid reason
to merge without other compelling reason, especially at
the beginning of merge window.
(it might be fine right before soft-freeze if issues are minor
but is not the case here)

If I were you, I'd just respin v22 with comments addressed.
(from my side I can promise to review it shortly after that,
while I still remember how it works)

[...]

