Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107DC3D23E3
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 14:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhGVMNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 08:13:04 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7043 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbhGVMND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jul 2021 08:13:03 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GVsg33gLDzYdqB;
        Thu, 22 Jul 2021 20:47:43 +0800 (CST)
Received: from dggpeml500013.china.huawei.com (7.185.36.41) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Jul 2021 20:53:31 +0800
Received: from [10.174.187.161] (10.174.187.161) by
 dggpeml500013.china.huawei.com (7.185.36.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 22 Jul 2021 20:53:30 +0800
To:     <lingshan.zhu@intel.com>, <like.xu.linux@gmail.com>
References: <20210716085325.10300-1-lingshan.zhu@intel.com>
Subject: Re: [PATCH V8 00/18] KVM: x86/pmu: Add *basic* support to enable
 guest PEBS via DS
CC:     <ak@linux.intel.com>, <boris.ostrvsky@oracle.com>, <bp@alien8.de>,
        <eranian@google.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <kan.liang@linux.intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liuxiangdong5@huawei.com>,
        <pbonzini@redhat.com>, <peterz@infradead.org>, <seanjc@google.com>,
        <vkuznets@redhat.com>, <wanpengli@tencent.com>,
        <wei.w.wang@intel.com>, <x86@kernel.org>,
        Xiexiangyou <xiexiangyou@huawei.com>,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>
From:   Liuxiangdong <liuxiangdong5@huawei.com>
Message-ID: <60F96A3F.3030703@huawei.com>
Date:   Thu, 22 Jul 2021 20:53:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20210716085325.10300-1-lingshan.zhu@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.161]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggpeml500013.china.huawei.com (7.185.36.41)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi，like and lingshan.

We can use pebs on the Icelake by using "perf record -e $event:pp", but 
how can we get all the supported $event for the Icelake?
Because it seems like that all the hardware event/software event/kernel 
pmu event listed by "perf list" can use ":pp" without error.


By quering events list for Icelake("https://perfmon-events.intel.com/), 
we can use "perf record -e cpu/event=0xXX,unask=0xXX/pp"
to enable sampling. There are some events with "PEBS： 
[PreciseEventingIP]" in "Additional Info" column. Are they the only 
supported
precise events? Do those events which have "PEBS:[NonPreciseEventingIP]" 
in last column support PEBS?


Thanks,
Xiangdong Liu

