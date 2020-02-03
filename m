Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 279A115021F
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 08:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgBCHzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 02:55:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47503 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727489AbgBCHzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 02:55:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580716512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dboh0QVxXtI2PvjSsCAnC9KkJagQEfb/i+ydQ8g4GXY=;
        b=B8ltmJRvDaVsPbXZNXDfYs5feptBzq3hUKqkz4ycPnrZlUBGR399YQemGQ0VkeWhISgjsb
        qAuwYYrr6uEwP72iX0p+UQMvhnXkYZ4WjT//NuXQatTzFvMxJumSWUvJmV00jV/VfuRPAO
        0U0DvAdpJosR0MQq0Gemg2J/aNGIpUc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-ziPYIh3SP6WXYH8YYFr7Yg-1; Mon, 03 Feb 2020 02:55:10 -0500
X-MC-Unique: ziPYIh3SP6WXYH8YYFr7Yg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DBB4107ACCD;
        Mon,  3 Feb 2020 07:55:08 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C280171D6;
        Mon,  3 Feb 2020 07:55:02 +0000 (UTC)
Date:   Mon, 3 Feb 2020 08:55:01 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     gengdongjiu <gengdongjiu@huawei.com>
Cc:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <xuwei5@huawei.com>,
        <jonathan.cameron@huawei.com>, <james.morse@arm.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <qemu-arm@nongnu.org>, <zhengxiang9@huawei.com>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH v22 7/9] ACPI: Record Generic Error Status Block(GESB)
 table
Message-ID: <20200203085501.499e3a83@redhat.com>
In-Reply-To: <a9f46632-0766-7e82-7dc4-752d00b4a0a1@huawei.com>
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
        <1578483143-14905-8-git-send-email-gengdongjiu@huawei.com>
        <20200128162938.18bd0e95@redhat.com>
        <a9f46632-0766-7e82-7dc4-752d00b4a0a1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2 Feb 2020 21:42:23 +0800
gengdongjiu <gengdongjiu@huawei.com> wrote:

> On 2020/1/28 23:29, Igor Mammedov wrote:
> > On Wed, 8 Jan 2020 19:32:21 +0800
> > Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> >   
> >> kvm_arch_on_sigbus_vcpu() error injection uses source_id as
> >> index in etc/hardware_errors to find out Error Status Data
> >> Block entry corresponding to error source. So supported source_id
> >> values should be assigned here and not be changed afterwards to
> >> make sure that guest will write error into expected Error Status
> >> Data Block even if guest was migrated to a newer QEMU.
> >>
> >> Before QEMU writes a new error to ACPI table, it will check whether
> >> previous error has been acknowledged. Otherwise it will ignore the new
> >> error. For the errors section type, QEMU simulate it to memory section
> >> error.
> >>
> >> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> >> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> >> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

btw:
when you are changing patch and it's not a trivial change,
you are supposed to drop Reviewed-by/Acked-by tags.

[...]
> >> diff --git a/include/qemu/uuid.h b/include/qemu/uuid.h
> >> index 129c45f..b35e294 100644
> >> --- a/include/qemu/uuid.h
> >> +++ b/include/qemu/uuid.h
> >> @@ -34,6 +34,11 @@ typedef struct {
> >>      };
> >>  } QemuUUID;
> >>  
> >> +#define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)             \
> >> +  {{{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
> >> +     (b) & 0xff, ((b) >> 8) & 0xff, (c) & 0xff, ((c) >> 8) & 0xff,          \
> >> +     (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) } } }  
> > 
> > since you are adding generalizing macro, take of NVDIMM_UUID_LE which served as model  
> 
> do you mean use this generalizing macro to replace NVDIMM_UUID_LE, right?

yes, and preferably do that in a separate patch

> 
> > 
> >   
> >>  #define UUID_FMT "%02hhx%02hhx%02hhx%02hhx-" \
> >>                   "%02hhx%02hhx-%02hhx%02hhx-" \
> >>                   "%02hhx%02hhx-" \  
> > 
> > .
> >   
> 

