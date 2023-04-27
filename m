Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174056F0212
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 09:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243065AbjD0HrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 03:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242985AbjD0HrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 03:47:01 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2962698;
        Thu, 27 Apr 2023 00:46:59 -0700 (PDT)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33R6H0w8027812;
        Thu, 27 Apr 2023 07:46:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=qcppdkim1; bh=c6tPZL64LtsIrYoFQTFyNm93j7JzIUswZJcU2RAwcdw=;
 b=dBBj6bmpHubQlTesT9WoZyS0Aq5xgYypa3uQjq1N5DbkhuP1nc0kTfV/Ym1jAdzxd0tq
 88fKEFj3UNam8MAHS1xq8vPgOJUTwjwrU6nOpNq5OeC8xeoOCCeZH5FM+BtmORy/hd/h
 UDScvuo5tUY5xoltgaL+/BbCq4dHHD87dFNNAc3hDu+BIkE+U+baDssjnMPi7GhUKAzz
 5HSq/d5O2x78g+a/haNFHQscBsgqXReAat689ajWGFtxBR+g+7j1FLJZ3dhYOIZPzA4c
 pbaQMumMMTbHr/Cj4ayNUPLPxo60+eshrPg2xoy48RX+KFfYeb4LKUCQZ07B/+OnaDgX Ew== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3q79am19xa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 07:46:25 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 33R7kNgl011691
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 07:46:23 GMT
Received: from hu-pkondeti-hyd.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Thu, 27 Apr 2023 00:46:06 -0700
Date:   Thu, 27 Apr 2023 13:16:02 +0530
From:   Pavan Kondeti <quic_pkondeti@quicinc.com>
To:     David Dai <davidai@google.com>,
        Saravana Kannan <saravanak@google.com>
CC:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        <kernel-team@android.com>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>
Subject: Re: [RFC PATCH 0/6] Improve VM DVFS and task placement behavior
Message-ID: <20230427074602.GA325349@hu-pkondeti-hyd.qualcomm.com>
References: <20230330224348.1006691-1-davidai@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230330224348.1006691-1-davidai@google.com>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: k3Ws6u2M1vI32yF-_7r5Yc0Vq1RVGLo4
X-Proofpoint-ORIG-GUID: k3Ws6u2M1vI32yF-_7r5Yc0Vq1RVGLo4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_05,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 impostorscore=0 spamscore=0 adultscore=0
 clxscore=1011 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304270066
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 03:43:35PM -0700, David Dai wrote:
> Hi,
> 
> This patch series is a continuation of the talk Saravana gave at LPC 2022
> titled "CPUfreq/sched and VM guest workload problems" [1][2][3]. The gist
> of the talk is that workloads running in a guest VM get terrible task
> placement and DVFS behavior when compared to running the same workload in
> the host. Effectively, no EAS for threads inside VMs. This would make power
> and performance terrible just by running the workload in a VM even if we
> assume there is zero virtualization overhead.
> 
> We have been iterating over different options for communicating between
> guest and host, ways of applying the information coming from the
> guest/host, etc to figure out the best performance and power improvements
> we could get.
> 
> The patch series in its current state is NOT meant for landing in the
> upstream kernel. We are sending this patch series to share the current
> progress and data we have so far. The patch series is meant to be easy to
> cherry-pick and test on various devices to see what performance and power
> benefits this might give for others.
> 
> With this series, a workload running in a VM gets the same task placement
> and DVFS treatment as it would when running in the host.
> 
> As expected, we see significant performance improvement and better
> performance/power ratio. If anyone else wants to try this out for your VM
> workloads and report findings, that'd be very much appreciated.
> 
> The idea is to improve VM CPUfreq/sched behavior by:
> - Having guest kernel to do accurate load tracking by taking host CPU
>   arch/type and frequency into account.
> - Sharing vCPU run queue utilization information with the host so that the
>   host can do proper frequency scaling and task placement on the host side.
> 

[...]

> 
> Next steps:
> ===========
> We are continuing to look into communication mechanisms other than
> hypercalls that are just as/more efficient and avoid switching into the VMM
> userspace. Any inputs in this regard are greatly appreciated.
> 

I am trying to understand why virtio based cpufrq does not work here?
The VMM on host can process requests from guest VM like freq table,
current frequency and setting the min_freq. I believe Virtio backend
has mechanisms for acceleration (vhost) so that user space is not
involved for every frequency request from the guest.

It has advantages of (1) Hypervisor agnostic (virtio basically) 
(2) scheduler does not need additional input, the aggregated min_freq
requests from all guest should be sufficient.

> 
> [1] - https://lpc.events/event/16/contributions/1195/
> [2] - https://lpc.events/event/16/contributions/1195/attachments/970/1893/LPC%202022%20-%20VM%20DVFS.pdf
> [3] - https://www.youtube.com/watch?v=hIg_5bg6opU
> [4] - https://chromium-review.googlesource.com/c/crosvm/crosvm/+/4208668
> [5] - https://chromium-review.googlesource.com/c/crosvm/crosvm/+/4288027
> 
> David Dai (6):
>   sched/fair: Add util_guest for tasks
>   kvm: arm64: Add support for get_cur_cpufreq service
>   kvm: arm64: Add support for util_hint service
>   kvm: arm64: Add support for get_freqtbl service
>   dt-bindings: cpufreq: add bindings for virtual kvm cpufreq
>   cpufreq: add kvm-cpufreq driver
> 
>  .../bindings/cpufreq/cpufreq-virtual-kvm.yaml |  39 +++
>  Documentation/virt/kvm/api.rst                |  28 ++
>  .../virt/kvm/arm/get_cur_cpufreq.rst          |  21 ++
>  Documentation/virt/kvm/arm/get_freqtbl.rst    |  23 ++
>  Documentation/virt/kvm/arm/index.rst          |   3 +
>  Documentation/virt/kvm/arm/util_hint.rst      |  22 ++
>  arch/arm64/include/uapi/asm/kvm.h             |   3 +
>  arch/arm64/kvm/arm.c                          |   3 +
>  arch/arm64/kvm/hypercalls.c                   |  60 +++++
>  drivers/cpufreq/Kconfig                       |  13 +
>  drivers/cpufreq/Makefile                      |   1 +
>  drivers/cpufreq/kvm-cpufreq.c                 | 245 ++++++++++++++++++
>  include/linux/arm-smccc.h                     |  21 ++
>  include/linux/sched.h                         |  12 +
>  include/uapi/linux/kvm.h                      |   3 +
>  kernel/sched/core.c                           |  24 +-
>  kernel/sched/fair.c                           |  15 +-
>  tools/arch/arm64/include/uapi/asm/kvm.h       |   3 +
>  18 files changed, 536 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-virtual-kvm.yaml
>  create mode 100644 Documentation/virt/kvm/arm/get_cur_cpufreq.rst
>  create mode 100644 Documentation/virt/kvm/arm/get_freqtbl.rst
>  create mode 100644 Documentation/virt/kvm/arm/util_hint.rst
>  create mode 100644 drivers/cpufreq/kvm-cpufreq.c

Thanks,
Pavan
