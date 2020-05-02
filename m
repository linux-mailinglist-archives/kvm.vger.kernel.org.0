Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7ACF1C2888
	for <lists+kvm@lfdr.de>; Sun,  3 May 2020 00:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgEBWVr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 2 May 2020 18:21:47 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2147 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728530AbgEBWVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 18:21:47 -0400
Received: from lhreml714-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 2AF87D59739CFA60A635;
        Sat,  2 May 2020 23:21:45 +0100 (IST)
Received: from dggeme755-chm.china.huawei.com (10.3.19.101) by
 lhreml714-chm.china.huawei.com (10.201.108.65) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Sat, 2 May 2020 23:21:43 +0100
Received: from dggeme755-chm.china.huawei.com ([10.7.64.71]) by
 dggeme755-chm.china.huawei.com ([10.7.64.71]) with mapi id 15.01.1913.007;
 Sun, 3 May 2020 06:21:41 +0800
From:   gengdongjiu <gengdongjiu@huawei.com>
To:     Igor Mammedov <imammedo@redhat.com>
CC:     Peter Maydell <peter.maydell@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        "Xiao Guangrong" <xiaoguangrong.eric@gmail.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Linuxarm <linuxarm@huawei.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        "zhengxiang (A)" <zhengxiang9@huawei.com>,
        qemu-arm <qemu-arm@nongnu.org>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Richard Henderson" <rth@twiddle.net>
Subject: Re: [PATCH v25 00/10] Add ARMv8 RAS virtualization support in QEMU
Thread-Topic: [PATCH v25 00/10] Add ARMv8 RAS virtualization support in QEMU
Thread-Index: AdYgz//oho/0lGTqbEC6pfKPUDNKmA==
Date:   Sat, 2 May 2020 22:21:41 +0000
Message-ID: <d3ca73f6fdbf46078f68f142a4a03d26@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.46.14.22]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> On Thu, 30 Apr 2020 11:56:24 +0800
> gengdongjiu <gengdongjiu@huawei.com> wrote:
> 
> > On 2020/4/17 21:32, Peter Maydell wrote:
> > > On Fri, 10 Apr 2020 at 12:46, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> > >>
> > >> In the ARMv8 platform, the CPU error types includes synchronous
> > >> external abort(SEA) and SError Interrupt (SEI). If exception
> > >> happens in guest, host does not know the detailed information of
> > >> guest, so it is expected that guest can do the recovery. For
> > >> example, if an exception happens in a guest user-space application, host does not know which application encounters errors, only
> guest knows it.
> > >>
> > >> For the ARMv8 SEA/SEI, KVM or host kernel delivers SIGBUS to notify userspace.
> > >> After user space gets the notification, it will record the CPER
> > >> into guest GHES buffer and inject an exception or IRQ to guest.
> > >>
> > >> In the current implementation, if the type of SIGBUS is
> > >> BUS_MCEERR_AR, we will treat it as a synchronous exception, and
> > >> notify guest with ARMv8 SEA notification type after recording CPER into guest.
> > >
> > > Hi. I left a comment on patch 1. The other 3 patches unreviewed are
> > > 5, 6 and 8, which are all ACPI core code, so that's for MST, Igor or
> > > Shannon to review.
> >
> > Ping MST, Igor and Shannon, sorry for the noise.
> 
> I put it on my review queue

Igor, thank you very much in advance.

> 
> >
> > >
> > > Once those have been reviewed, please ping me if you want this to go
> > > via target-arm.next.
> > >
> > > thanks
> > > -- PMM
> > >
> > > .
> > >
> >

