Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D885704C12
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 13:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbjEPLNv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 16 May 2023 07:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbjEPLNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 07:13:34 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C99F6EBA
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 04:12:28 -0700 (PDT)
Received: from lhrpeml100005.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QLD603RYRz67b1p;
        Tue, 16 May 2023 19:09:44 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100005.china.huawei.com (7.191.160.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 12:11:31 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.023;
 Tue, 16 May 2023 12:11:31 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Alexandru Elisei" <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Subject: RE: [PATCH v8 0/6] Support writable CPU ID registers from userspace
Thread-Topic: [PATCH v8 0/6] Support writable CPU ID registers from userspace
Thread-Index: AQHZfeMKF5dz+QbHTkGBOtd/Pa2Gla9cxFkw///6lICAABESsA==
Date:   Tue, 16 May 2023 11:11:31 +0000
Message-ID: <1a96a72e87684e2fb3f8c77e32516d04@huawei.com>
References: <20230503171618.2020461-1-jingzhangos@google.com>
        <2ef9208dabe44f5db445a1061a0d5918@huawei.com> <868rdomtfo.wl-maz@kernel.org>
In-Reply-To: <868rdomtfo.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Marc Zyngier [mailto:maz@kernel.org]
> Sent: 16 May 2023 12:01
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: Jing Zhang <jingzhangos@google.com>; KVM <kvm@vger.kernel.org>;
> KVMARM <kvmarm@lists.linux.dev>; ARMLinux
> <linux-arm-kernel@lists.infradead.org>; Oliver Upton <oupton@google.com>;
> Will Deacon <will@kernel.org>; Paolo Bonzini <pbonzini@redhat.com>;
> James Morse <james.morse@arm.com>; Alexandru Elisei
> <alexandru.elisei@arm.com>; Suzuki K Poulose <suzuki.poulose@arm.com>;
> Fuad Tabba <tabba@google.com>; Reiji Watanabe <reijiw@google.com>;
> Raghavendra Rao Ananta <rananta@google.com>
> Subject: Re: [PATCH v8 0/6] Support writable CPU ID registers from
> userspace
> 
> On Tue, 16 May 2023 11:37:20 +0100,
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> wrote:
> >
> > > -----Original Message-----
> > > From: Jing Zhang [mailto:jingzhangos@google.com]
> > > Sent: 03 May 2023 18:16
> > > To: KVM <kvm@vger.kernel.org>; KVMARM <kvmarm@lists.linux.dev>;
> > > ARMLinux <linux-arm-kernel@lists.infradead.org>; Marc Zyngier
> > > <maz@kernel.org>; Oliver Upton <oupton@google.com>
> > > Cc: Will Deacon <will@kernel.org>; Paolo Bonzini
> <pbonzini@redhat.com>;
> > > James Morse <james.morse@arm.com>; Alexandru Elisei
> > > <alexandru.elisei@arm.com>; Suzuki K Poulose
> <suzuki.poulose@arm.com>;
> > > Fuad Tabba <tabba@google.com>; Reiji Watanabe <reijiw@google.com>;
> > > Raghavendra Rao Ananta <rananta@google.com>; Jing Zhang
> > > <jingzhangos@google.com>
> > > Subject: [PATCH v8 0/6] Support writable CPU ID registers from
> userspace
> > >
> > > This patchset refactors/adds code to support writable per guest CPU ID
> > > feature
> > > registers. Part of the code/ideas are from
> > >
> https://lore.kernel.org/all/20220419065544.3616948-1-reijiw@google.com
> >
> > Hi Jing/Reiji,
> >
> > Just to check the status on the above mentioned series "KVM: arm64: Make
> CPU
> > ID registers writable by userspace". Is there any plan to respin that one
> soon?
> > (Sorry, not sure there is any other series in progress for that support
> currently)
> 
> I think this still is the latest, which I'm about to review again. I'd
> appreciate if you could have a look to!

Thanks Marc for confirming. Will go through. We do have some requirement to
add support for Qemu CPU models/migration between different hosts.

Thanks,
Shameer
 
> 
> Thanks,
> 
> 	M.
> 
> --
> Without deviation from the norm, progress is not possible.
