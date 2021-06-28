Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746183B5A06
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 09:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhF1HwI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 28 Jun 2021 03:52:08 -0400
Received: from mga18.intel.com ([134.134.136.126]:13892 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229911AbhF1HwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 03:52:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10028"; a="195201585"
X-IronPort-AV: E=Sophos;i="5.83,305,1616482800"; 
   d="scan'208";a="195201585"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2021 00:49:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,305,1616482800"; 
   d="scan'208";a="643249871"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jun 2021 00:49:41 -0700
Received: from shsmsx602.ccr.corp.intel.com (10.109.6.142) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 28 Jun 2021 00:49:40 -0700
Received: from shsmsx601.ccr.corp.intel.com (10.109.6.141) by
 SHSMSX602.ccr.corp.intel.com (10.109.6.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 28 Jun 2021 15:49:39 +0800
Received: from shsmsx601.ccr.corp.intel.com ([10.109.6.141]) by
 SHSMSX601.ccr.corp.intel.com ([10.109.6.141]) with mapi id 15.01.2242.008;
 Mon, 28 Jun 2021 15:49:39 +0800
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "bp@alien8.de" <bp@alien8.de>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>
Subject: RE: [PATCH V7 00/18] KVM: x86/pmu: Add *basic* support to enable
 guest PEBS via DS
Thread-Topic: [PATCH V7 00/18] KVM: x86/pmu: Add *basic* support to enable
 guest PEBS via DS
Thread-Index: AQHXZ0sJOaQRU0kevEaMGb3MISkcPqsj94qAgAABoACABRh78A==
Date:   Mon, 28 Jun 2021 07:49:38 +0000
Message-ID: <81530ac3ebe74ada9b5d1dc8092c1a31@intel.com>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <60D5A487.8020507@huawei.com>
 <37832cc0-788d-91b9-dc95-147eca133842@intel.com>
In-Reply-To: <37832cc0-788d-91b9-dc95-147eca133842@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday, June 25, 2021 5:46 PM, Zhu, Lingshan wrote:
> > Only on the host?
> > I cannot use pebs unless try with "echo 0 > /proc/sys/kernel/watchdog"
> > both on the host and guest on ICX.
> Hi Xiangdong
> 
> I guess you may run into the "cross-map" case(slow path below), so I think you
> can disable them both in host and guest to make PEBS work.
> 

Hi Lingshan, could we also reproduce this issue?

If the guest's watchdog takes away the virtual fixed counter, this will schedule the guest PEBS to use virtual PMC0. With the fast path (1:1 mapping), I think physical PMC0 is likely to be available for the guest PEBS emulation if no other host perf events are running.

Best,
Wei
