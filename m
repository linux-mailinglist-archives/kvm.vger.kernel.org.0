Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9602704FB2
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 15:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbjEPNox convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 16 May 2023 09:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232378AbjEPNop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 09:44:45 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDAA527B
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 06:44:43 -0700 (PDT)
Received: from lhrpeml500001.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4QLHWc6fdWz686w8;
        Tue, 16 May 2023 21:43:40 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500001.china.huawei.com (7.191.163.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 14:44:40 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.023;
 Tue, 16 May 2023 14:44:40 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, Cornelia Huck <cohuck@redhat.com>
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
Thread-Index: AQHZfeMKF5dz+QbHTkGBOtd/Pa2Gla9cxFkw///6lICAABESsP///gMAgAAVTwCAABcHYA==
Date:   Tue, 16 May 2023 13:44:40 +0000
Message-ID: <bb1e038f0bf04d62beda15d0830920ee@huawei.com>
References: <20230503171618.2020461-1-jingzhangos@google.com>
        <2ef9208dabe44f5db445a1061a0d5918@huawei.com>   <868rdomtfo.wl-maz@kernel.org>
        <1a96a72e87684e2fb3f8c77e32516d04@huawei.com>   <87cz30h4nx.fsf@redhat.com>
 <867ct8mnel.wl-maz@kernel.org>
In-Reply-To: <867ct8mnel.wl-maz@kernel.org>
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Marc Zyngier [mailto:maz@kernel.org]
> Sent: 16 May 2023 14:12
> To: Cornelia Huck <cohuck@redhat.com>
> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> Jing Zhang <jingzhangos@google.com>; KVM <kvm@vger.kernel.org>;
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
> On Tue, 16 May 2023 12:55:14 +0100,
> Cornelia Huck <cohuck@redhat.com> wrote:
> >
> > Do you have more concrete ideas for QEMU CPU models already? Asking
> > because I wanted to talk about this at KVM Forum, so collecting what
> > others would like to do seems like a good idea :)
> 
> I'm not being asked, but I'll share my thoughts anyway! ;-)
> 
> I don't think CPU models are necessarily the most important thing.
> Specially when you look at the diversity of the ecosystem (and even
> the same CPU can be configured in different ways at integration
> time). Case in point, Neoverse N1 which can have its I/D caches made
> coherent or not. And the guest really wants to know which one it is
> (you can only lie in one direction).
> 
> But being able to control the feature set exposed to the guest from
> userspace is a huge benefit in terms of migration.

Yes, this is what we also need and was thinking of adding a named CPU with
common min feature set exposed to Guest. There were some previous
attempts to add the basic support in Qemu here,

https://lists.gnu.org/archive/html/qemu-devel/2020-11/msg00087.html

> Now, this is only half of the problem (and we're back to the CPU
> model): most of these CPUs have various degrees of brokenness. Most of
> the workarounds have to be implemented by the guest, and are keyed on
> the MIDR values. So somehow, you need to be able to expose *all* the
> possible MIDR values that a guest can observe in its lifetime.

Ok. This will be a problem and I am not sure this has an impact on our 
platforms or not.

Thanks,
Shameer

> I have a vague prototype for that that I'd need to dust off and
> finish, because that's also needed for this very silly construct
> called big-little...
> 
> Thanks,
> 
> 	M.
> 
> --
> Without deviation from the norm, progress is not possible.

