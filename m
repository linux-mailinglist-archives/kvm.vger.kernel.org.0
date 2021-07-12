Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2313C40F2
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 03:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhGLBkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jul 2021 21:40:45 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:11254 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGLBkp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jul 2021 21:40:45 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GNR8P0TNVz1CHt7;
        Mon, 12 Jul 2021 09:32:21 +0800 (CST)
Received: from dggpeml500013.china.huawei.com (7.185.36.41) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 12 Jul 2021 09:37:41 +0800
Received: from [10.174.187.161] (10.174.187.161) by
 dggpeml500013.china.huawei.com (7.185.36.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 12 Jul 2021 09:37:40 +0800
To:     <lingshan.zhu@intel.com>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
Subject: Re: [PATCH V7 00/18] KVM: x86/pmu: Add *basic* support to enable
 guest PEBS via DS
CC:     <ak@linux.intel.com>, <bp@alien8.de>, <eranian@google.com>,
        <jmattson@google.com>, <joro@8bytes.org>,
        <kan.liang@linux.intel.com>, <kvm@vger.kernel.org>,
        <like.xu.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <liuxiangdong5@huawei.com>, <pbonzini@redhat.com>,
        <peterz@infradead.org>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <wei.w.wang@intel.com>,
        <weijiang.yang@intel.com>, <x86@kernel.org>,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>
From:   Liuxiangdong <liuxiangdong5@huawei.com>
Message-ID: <60EB9CD8.6080608@huawei.com>
Date:   Mon, 12 Jul 2021 09:37:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20210622094306.8336-1-lingshan.zhu@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.161]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggpeml500013.china.huawei.com (7.185.36.41)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi， Lingshan.

We can use basic pebs for KVM Guest on ICX by this patches set. Will we 
consider supporting "perf mem" for KVM Guest?

AFAIK, the load latency facility requires processor supporting PEBS. 
Besides, it needs MSR_PEBS_LD_LAT_THRESHOLD
msr (3F6H) to specify the desired latency threshold. How about 
passthrough this msr to Guest?

Thanks!
Xiangdong Liu

