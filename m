Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC9419C4B7
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 16:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388239AbgDBOuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 10:50:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27353 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729549AbgDBOuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 10:50:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585839038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LXeAIFchhmL4/ru7L0y4E++LQmFqG0pq5fk9R9Cim7M=;
        b=Lzx20GymC+T2GrFwv4ps91nwP1/ZS3hsJuqxYFATo+KTCSbhQJtcwLQ5LZ5Yxydujb2ACz
        jkplpT7L8PwKhemPscgCwMxA1cFXb8g/ye+xkzLP+018eDgjC1zwNF9gtGYGNQ21GMb7P8
        K9YKaH6eGJbyjAf1vfxfhgDn6oezXhs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-9b33VLRaPM-MiGo3zfhLQQ-1; Thu, 02 Apr 2020 10:50:35 -0400
X-MC-Unique: 9b33VLRaPM-MiGo3zfhLQQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC446108838C;
        Thu,  2 Apr 2020 14:50:33 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BE3425D9C9;
        Thu,  2 Apr 2020 14:50:31 +0000 (UTC)
Date:   Thu, 2 Apr 2020 16:50:28 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     Jingyi Wang <wangjingyi11@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, wanghaibin.wang@huawei.com
Subject: Re: [kvm-unit-tests PATCH 0/2] arm/arm64: Add IPI/vtimer latency
Message-ID: <20200402145028.oma67w5tbjd44h2w@kamzik.brq.redhat.com>
References: <20200401100812.27616-1-wangjingyi11@huawei.com>
 <20200401122445.exyobwo3a3agnuhk@kamzik.brq.redhat.com>
 <bbcd3dc4-79c1-7ba2-ea54-96d083dfcef9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbcd3dc4-79c1-7ba2-ea54-96d083dfcef9@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 02, 2020 at 07:52:43PM +0800, Zenghui Yu wrote:
>   But what I'm actually interested in is the latency of the new GICv4.1
>   vSGIs (which will be directly injected through ITS).  To measure it,
>   we should first make KUT be GICv4.1-awareness, see [1] for details.
>   (This way, we can even have a look at the interrupt latency in HW
>   level. Is it possible to have this in kvm-unit-tests, Drew?)

I would certainly welcome gicv4 support in kvm-unit-tests. Let's get
Eric's ITS series merged first, but then patches welcome :-)

Thanks,
drew

