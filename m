Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 994B9FE9F9
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2019 01:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfKPA7E convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 15 Nov 2019 19:59:04 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2104 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727128AbfKPA7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 19:59:04 -0500
Received: from lhreml708-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 2BCFE9E064E08B3D09D5;
        Sat, 16 Nov 2019 00:59:02 +0000 (GMT)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml708-cah.china.huawei.com (10.201.108.49) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Sat, 16 Nov 2019 00:59:01 +0000
Received: from dggeme755-chm.china.huawei.com (10.3.19.101) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1713.5; Sat, 16 Nov 2019 00:59:00 +0000
Received: from dggeme755-chm.china.huawei.com ([10.7.64.71]) by
 dggeme755-chm.china.huawei.com ([10.7.64.71]) with mapi id 15.01.1713.004;
 Sat, 16 Nov 2019 08:58:58 +0800
From:   gengdongjiu <gengdongjiu@huawei.com>
To:     Igor Mammedov <imammedo@redhat.com>
CC:     "zhengxiang (A)" <zhengxiang9@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "shannon.zhaosl@gmail.com" <shannon.zhaosl@gmail.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "lersek@redhat.com" <lersek@redhat.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        Linuxarm <linuxarm@huawei.com>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
Subject: Re: [RESEND PATCH v21 3/6] ACPI: Add APEI GHES table generation
 support
Thread-Topic: [RESEND PATCH v21 3/6] ACPI: Add APEI GHES table generation
 support
Thread-Index: AdWbyMkE/1gyxkpeREeYn2g+7NgH+g==
Date:   Sat, 16 Nov 2019 00:58:58 +0000
Message-ID: <99a06454b0fa4eac9116af9ec978aaea@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.148.208.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Fri, 15 Nov 2019 14:32:47 +0000
> gengdongjiu <gengdongjiu@huawei.com> wrote:
> 
> > > > + */
> > > > +static void acpi_ghes_build_notify(GArray *table, const uint8_t
> > > > +type)
> > >
> > > typically format should be build_WHAT(), so
> > >  build_ghes_hw_error_notification()
> > >
> > > And I'd move this out into its own patch.
> > > this applies to other trivial in-depended sub-tables, that take all data needed to construct them from supplied arguments.
> >
> > I very used your suggested method in previous series[1], but other
> > maintainer suggested to move this function to this file, because he
> > think only GHES used it
> 
> Using this file is ok, what I've meant for you to split function from this patch into a separate smaller patch.
> 
> With the way code split now I have to review 2 big complex patches at the same which makes reviewing hard and I have a hard time
> convincing myself that code it correct.
> 
> Moving small self-contained chunks of code in to separate smaller patches makes review easier.

Ok, got it. Thanks very much for the explanations
