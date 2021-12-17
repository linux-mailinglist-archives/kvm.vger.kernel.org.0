Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AF44787E1
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 10:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbhLQJjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 04:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbhLQJjg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 04:39:36 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8453DC061574;
        Fri, 17 Dec 2021 01:39:36 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id a1so1963860qtx.11;
        Fri, 17 Dec 2021 01:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OOpMd3X90BKP/ZtpWdIPJ8+M8gFN2Ocwe7sVB2q7Hdg=;
        b=oqHzW8ok9MXgfVqWgJtQoyP1zGXQyUcr52i1nAze3/tkFU3J9b6+Pexe67OPGPrWjd
         Okk+Wq48KlWuMLahdqMYwp6BVo0wsJdGZ0xqgQI3qOc91uRMgby4gU82h+ND543NJbRz
         ExTytbVigqbOXZ5C4TUiFEWWI2k6OEMORGbTA5NeX6ba/EDv8XXHjgQ51AOD575qFDge
         rOXimWuWUr9nUB3S75gmzKzmZ2o1WoMFkia6YpLteorH8Qj4rcCkV4yohsZIaDmq1U8L
         ZM7VuE57a4nO57SLhZIWNi12kiDpmF4w6Q9auqavFcrGjdxgwCEgdd3gxGv67ATEzLS6
         JBOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OOpMd3X90BKP/ZtpWdIPJ8+M8gFN2Ocwe7sVB2q7Hdg=;
        b=wTfTxyTTTJw4MMEaW/qnrFsrr4EUimA1kA1FCwG78BnR1Zi7JyXj9SamtA9FfdikNm
         QoPTYROE4Y7j4Y3QzTlCMgA1IGX10mDiudB2djg7loxL99eq93yTQPWRAk76re0UFvol
         iuCb3pLQcSP7anVCImRZO1Rqbqd/vwpskwPoE7MzFxUuLA52doyUtRwSx5mWYzEQKh68
         aZUj6Rr8UVaePVyWQqkdmUW3B9FvzDffLo1c6FHUDZoE2cqCzwuvzirgvmC9+JM6d0rE
         B5YiHmeBWAAFZ9PmWNIROZ+Du3e/vGb7m+ct66zvkc1ELz9JAZ6F9Z2/8375ue8DAxOM
         nkzA==
X-Gm-Message-State: AOAM530tPrTg0ZRnuXF8toppFi1asxN2g+VwHxJWcwNF3EZZION43/Hl
        pnBXHUby3NklzkXQhG7VaJkbQSTNAUS7/Yh8+I/K0YKI3RI=
X-Google-Smtp-Source: ABdhPJxe372TIjyCLCQN3sud3qhRo8J8K4VhlXHjIz3adiVNBhdQvfz3QA5Aq6AoPcDiQMQyOLG1sRbHISnmI0FWHIQ=
X-Received: by 2002:a05:622a:c8:: with SMTP id p8mr1583216qtw.52.1639733975443;
 Fri, 17 Dec 2021 01:39:35 -0800 (PST)
MIME-Version: 1.0
References: <20210831015919.13006-1-skyele@sjtu.edu.cn>
In-Reply-To: <20210831015919.13006-1-skyele@sjtu.edu.cn>
From:   Jinrong Liang <ljr.kernel@gmail.com>
Date:   Fri, 17 Dec 2021 17:39:24 +0800
Message-ID: <CAFg_LQWV56zok563F8WbPEuUiJeeEhfUK3ua+tcm8ChZETWKWg@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: x86: Introduce .pcpu_is_idle() stub infrastructure
To:     Tianqiang Xu <skyele@sjtu.edu.cn>
Cc:     x86@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, kvm@vger.kernel.org, hpa@zytor.com,
        jarkko@kernel.org, dave.hansen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tianqiang,
Tianqiang Xu <skyele@sjtu.edu.cn> =E4=BA=8E2021=E5=B9=B412=E6=9C=8817=E6=97=
=A5=E5=91=A8=E4=BA=94 15:55=E5=86=99=E9=81=93=EF=BC=9A
>
> This patch series aims to fix performance issue caused by current
> para-virtualized scheduling design.
>
> The current para-virtualized scheduling design uses 'preempted' field of
> kvm_steal_time to avoid scheduling task on the preempted vCPU.
> However, when the pCPU where the preempted vCPU most recently run is idle=
,
> it will result in low cpu utilization, and consequently poor performance.
>
> The new field: 'is_idle' of kvm_steal_time can precisely reveal
> the status of pCPU where preempted vCPU most recently run, and
> then improve cpu utilization.
>
> pcpu_is_idle() is used to get the value of 'is_idle' of kvm_steal_time.
>
> Experiments on a VM with 16 vCPUs show that the patch can reduce around
> 50% to 80% execution time for most PARSEC benchmarks.
> This also holds true for a VM with 112 vCPUs.
>
> Experiments on 2 VMs with 112 vCPUs show that the patch can reduce around
> 20% to 80% execution time for most PARSEC benchmarks.
>
> Test environment:
> -- PowerEdge R740
> -- 56C-112T CPU Intel(R) Xeon(R) Gold 6238R CPU
> -- Host 190G DRAM
> -- QEMU 5.0.0
> -- PARSEC 3.0 Native Inputs
> -- Host is idle during the test
> -- Host and Guest kernel are both kernel-5.14.0
>
> Results:
> 1. 1 VM, 16 VCPU, 16 THREAD.
>    Host Topology: sockets=3D2 cores=3D28 threads=3D2
>    VM Topology:   sockets=3D1 cores=3D16 threads=3D1
>    Command: <path to parsec>/bin/parsecmgmt -a run -p <benchmark> -i nati=
ve -n 16
>    Statistics below are the real time of running each benchmark.(lower is=
 better)
>
>                         before patch    after patch     improvements
> bodytrack               52.866s         22.619s         57.21%
> fluidanimate            84.009s         38.148s         54.59%
> streamcluster           270.17s         42.726s         84.19%
> splash2x.ocean_cp       31.932s         9.539s          70.13%
> splash2x.ocean_ncp      36.063s         14.189s         60.65%
> splash2x.volrend        134.587s        21.79s          83.81%
>
> 2. 1VM, 112 VCPU. Some benchmarks require the number of threads to be the=
 power of 2,
> so we run them with 64 threads and 128 threads.
>    Host Topology: sockets=3D2 cores=3D28 threads=3D2
>    VM Topology:   sockets=3D1 cores=3D112 threads=3D1
>    Command: <path to parsec>/bin/parsecmgmt -a run -p <benchmark> -i nati=
ve -n <64,112,128>
>    Statistics below are the real time of running each benchmark.(lower is=
 better)
>
>                                         before patch    after patch     i=
mprovements
> fluidanimate(64 thread)                 124.235s        27.924s         7=
7.52%
> fluidanimate(128 thread)                169.127s        64.541s         6=
1.84%
> streamcluster(112 thread)               861.879s        496.66s         4=
2.37%
> splash2x.ocean_cp(64 thread)            46.415s         18.527s         6=
0.08%
> splash2x.ocean_cp(128 thread)           53.647s         28.929s         4=
6.08%
> splash2x.ocean_ncp(64 thread)           47.613s         19.576s         5=
8.89%
> splash2x.ocean_ncp(128 thread)          54.94s          29.199s         4=
6.85%
> splash2x.volrend(112 thread)            801.384s        144.824s        8=
1.93%
>
> 3. 2VM, each VM: 112 VCPU. Some benchmarks require the number of threads =
to
> be the power of 2, so we run them with 64 threads and 128 threads.
>    Host Topology: sockets=3D2 cores=3D28 threads=3D2
>    VM Topology:   sockets=3D1 cores=3D112 threads=3D1
>    Command: <path to parsec>/bin/parsecmgmt -a run -p <benchmark> -i nati=
ve -n <64,112,128>
>    Statistics below are the average real time of running each benchmark i=
n 2 VMs.(lower is better)
>
>                                         before patch    after patch     i=
mprovements
> fluidanimate(64 thread)                 135.2125s       49.827s         6=
3.15%
> fluidanimate(128 thread)                178.309s        86.964s         5=
1.23%
> splash2x.ocean_cp(64 thread)            47.4505s        20.314s         5=
7.19%
> splash2x.ocean_cp(128 thread)           55.5645s        30.6515s        4=
4.84%
> splash2x.ocean_ncp(64 thread)           49.9775s        23.489s         5=
3.00%
> splash2x.ocean_ncp(128 thread)          56.847s         28.545s         4=
9.79%
> splash2x.volrend(112 thread)            838.939s        239.632s        7=
1.44%
>
> For space limit, we list representative statistics here.

I did a performance test according to the description in the patch,
but did not get the performance improvement described in the description.

I suspect that the big difference between my kernel configuration
and yours has caused this problem. Can you please provide more detailed
test information, such as kernel configuration that must be turned on or of=
f ?

Regards,
Jinrong Liang
