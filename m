Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9FFC16C167
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 13:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbgBYMv0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 25 Feb 2020 07:51:26 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2461 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729525AbgBYMvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 07:51:25 -0500
Received: from lhreml709-cah.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 6BD4368E743091D9D629;
        Tue, 25 Feb 2020 12:51:22 +0000 (GMT)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml709-cah.china.huawei.com (10.201.108.32) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 25 Feb 2020 12:51:21 +0000
Received: from dggeme755-chm.china.huawei.com (10.3.19.101) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1713.5; Tue, 25 Feb 2020 12:51:20 +0000
Received: from dggeme755-chm.china.huawei.com ([10.7.64.71]) by
 dggeme755-chm.china.huawei.com ([10.7.64.71]) with mapi id 15.01.1713.004;
 Tue, 25 Feb 2020 20:51:18 +0800
From:   gengdongjiu <gengdongjiu@huawei.com>
To:     Igor Mammedov <imammedo@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
CC:     "Michael S. Tsirkin" <mst@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        "Fam Zheng" <fam@euphon.net>, Richard Henderson <rth@twiddle.net>,
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
        "zhengxiang (A)" <zhengxiang9@huawei.com>
Subject: Re: [PATCH v24 02/10] hw/arm/virt: Introduce a RAS machine option
Thread-Topic: [PATCH v24 02/10] hw/arm/virt: Introduce a RAS machine option
Thread-Index: AdXr2h074nYmm7QuZEuiffKA50KyvQ==
Date:   Tue, 25 Feb 2020 12:51:18 +0000
Message-ID: <e1177221d01442c29b03f551a625a7d2@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.45.185.193]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> On Tue, 25 Feb 2020 08:54:07 +0000
> Peter Maydell <peter.maydell@linaro.org> wrote:
> 
> > On Tue, 25 Feb 2020 at 08:34, Igor Mammedov <imammedo@redhat.com> wrote:
> > >
> > > On Mon, 17 Feb 2020 21:12:40 +0800
> > > Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> > >
> > > > RAS Virtualization feature is not supported now, so add a RAS
> > > > machine
> > >
> > > > option and disable it by default.
> > >              ^^^^
> > >
> > > this doesn't match the patch.
> >
> > Hmm? It seems right to me -- the patch adds a machine option and makes
> > it disabled-by-default, doesn't it?
> 
> Right, I misread 'and' as 'to' somehow.
> My apologies

Thanks Peter and Igor's clarification.

> 
> >
> > thanks
> > -- PMM
> >

