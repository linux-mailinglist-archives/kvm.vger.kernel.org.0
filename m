Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4E17C66F5
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 09:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343665AbjJLHv1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 12 Oct 2023 03:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343618AbjJLHvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 03:51:25 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990ECB7
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 00:51:23 -0700 (PDT)
Received: from lhrpeml500006.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S5hbx03fdz6K6nT;
        Thu, 12 Oct 2023 15:49:16 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500006.china.huawei.com (7.191.161.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 12 Oct 2023 08:51:20 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.031;
 Thu, 12 Oct 2023 08:51:20 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Oliver Upton <oliver.upton@linux.dev>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        yuzenghui <yuzenghui@huawei.com>,
        zhukeqian <zhukeqian1@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [RFC PATCH v2 0/8] KVM: arm64: Implement SW/HW combined dirty log
Thread-Topic: [RFC PATCH v2 0/8] KVM: arm64: Implement SW/HW combined dirty
 log
Thread-Index: AQHZ1zeYniphcsNMdESdQqigwTISA7AZEKiAgAEU5SCAAPR6AIAFYYpQgCWUqmA=
Date:   Thu, 12 Oct 2023 07:51:19 +0000
Message-ID: <4396b28a9a0a41adbb70f94d98be73ae@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <ZQHxm+L890yTpY91@linux.dev> <14eb2648eb594dd9a46a179733cee0df@huawei.com>
 <ZQOm9gUo8un+claf@linux.dev> <853b333084c4462a870bb2a37ec65935@huawei.com>
In-Reply-To: <853b333084c4462a870bb2a37ec65935@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

> -----Original Message-----
> From: linux-arm-kernel
> [mailto:linux-arm-kernel-bounces@lists.infradead.org] On Behalf Of
> Shameerali Kolothum Thodi
> Sent: 18 September 2023 10:55
> To: Oliver Upton <oliver.upton@linux.dev>
> Cc: kvmarm@lists.linux.dev; kvm@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; maz@kernel.org; will@kernel.org;
> catalin.marinas@arm.com; james.morse@arm.com;
> suzuki.poulose@arm.com; yuzenghui <yuzenghui@huawei.com>; zhukeqian
> <zhukeqian1@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Linuxarm <linuxarm@huawei.com>
> Subject: RE: [RFC PATCH v2 0/8] KVM: arm64: Implement SW/HW combined
> dirty log
 
[...]

> > > Please let me know if there is a specific workload you have in mind.
> >
> > No objection to the workload you've chosen, I'm more concerned about
> the
> > benchmark finishing before live migration completes.
> >
> > What I'm looking for is something like this:
> >
> >  - Calculate the ops/sec your benchmark completes in steady state
> >
> >  - Do a live migration and sample the rate throughout the benchmark,
> >    accounting for VM blackout time
> >
> >  - Calculate the area under the curve of:
> >
> >      y = steady_state_rate - live_migration_rate(t)
> >
> >  - Compare the area under the curve for write-protection and your DBM
> >    approach.
> 
> Ok. Got it.

I attempted to benchmark the performance of this series better as suggested above.

Used memcached/memaslap instead of redis-benchmark as this tool seems to dirty
memory at a faster rate than redis-benchmark in my setup.

./memaslap -s 127.0.0.1:11211 -S 1s  -F ./memslap.cnf -T 96 -c 96 -t 20m

Please find the google sheet link below for the charts that compare the average
throughput rates during the migration time window for 6.5-org and
6.5-kvm-dbm branch.

https://docs.google.com/spreadsheets/d/1T2F94Lsjpx080hW8OSxwbTJXihbXDNlTE1HjWCC0J_4/edit?usp=sharing

Sheet #1 : is with autoconverge=on with default settings(initial-throttle 20 & increment 10).

As you can see from the charts, if you compare the kvm-dbm branch throughput
during the migration window of original branch, it is considerably higher.
But the convergence time to finish migration increases almost at the same
rate for KVM-DBM. This in effect results in a decreased overall avg. 
throughput if we compare with the same time window of original branch.

Sheet #2: is with autoconverge=on with throttle-increment set to 15 for kvm-dbm branch run.

However, if we increase the migration throttling rate for kvm-dbm branch, 
it looks to me we can still have better throughput during the migration
window time and also an overall higher throughput rate with KVM-DBM solution.
 
Sheet: #3. Captures the dirty_log_perf_test times vs memory per vCPU. 

This is also in line with the above results. KVM-DBM has better/constant-ish
dirty memory time compared to linear increase noted for original. 
But it is just the opposite for Get Dirty log time. 

From the above, it looks to me there is a value addition in using HW DBM
for write intensive workloads if we adjust the CPU throttling in the user space.

Please take a look and let me know your feedback/thoughts.

Thanks,
Shameer
