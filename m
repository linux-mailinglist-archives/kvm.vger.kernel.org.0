Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7BC16BF1E
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 11:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbgBYKxh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 05:53:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36104 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730186AbgBYKxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 05:53:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582628015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FwVgg6pAG24Nwzl8TwwXLB6A8KzRtLr0RkxRfKsg1kI=;
        b=NQr81VA8vRQacj/VdqeZOB1ZF4B8AeNgkmY0dl+1v7f5CPI2Ob3Cgz9IuXryW6NhmpYdpV
        s5EjmgT3KfdAir7NpvD3/F5P+SVRqdhf15cp63+hvY7aR6pN4kXqPTVT9HP7+PYojGe9Th
        0bhLoSrjUuR/jzBVA+Rvot/xgMi32Zk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-XXhlPeqeO82GNhTF5Lcy4Q-1; Tue, 25 Feb 2020 05:53:33 -0500
X-MC-Unique: XXhlPeqeO82GNhTF5Lcy4Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94D2D477;
        Tue, 25 Feb 2020 10:53:31 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B74EA1001902;
        Tue, 25 Feb 2020 10:53:24 +0000 (UTC)
Date:   Tue, 25 Feb 2020 11:53:22 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Dongjiu Geng <gengdongjiu@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Fam Zheng <fam@euphon.net>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Zheng Xiang <zhengxiang9@huawei.com>
Subject: Re: [PATCH v24 02/10] hw/arm/virt: Introduce a RAS machine option
Message-ID: <20200225115322.4344e589@redhat.com>
In-Reply-To: <CAFEAcA9zjoa48Mth5aaOnhjDyY_qyrg9Nz5=0YEa2aE_aFcCug@mail.gmail.com>
References: <20200217131248.28273-1-gengdongjiu@huawei.com>
        <20200217131248.28273-3-gengdongjiu@huawei.com>
        <20200225093404.0ee40224@redhat.com>
        <CAFEAcA9zjoa48Mth5aaOnhjDyY_qyrg9Nz5=0YEa2aE_aFcCug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Feb 2020 08:54:07 +0000
Peter Maydell <peter.maydell@linaro.org> wrote:

> On Tue, 25 Feb 2020 at 08:34, Igor Mammedov <imammedo@redhat.com> wrote:
> >
> > On Mon, 17 Feb 2020 21:12:40 +0800
> > Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> >  
> > > RAS Virtualization feature is not supported now, so add a RAS machine  
> >  
> > > option and disable it by default.  
> >              ^^^^
> >
> > this doesn't match the patch.  
> 
> Hmm? It seems right to me -- the patch adds a machine option
> and makes it disabled-by-default, doesn't it?

Right, I misread 'and' as 'to' somehow.
My apologies

> 
> thanks
> -- PMM
> 

