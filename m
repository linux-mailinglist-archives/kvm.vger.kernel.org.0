Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5AB61640D4
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 10:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgBSJw7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 19 Feb 2020 04:52:59 -0500
Received: from mga17.intel.com ([192.55.52.151]:25065 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgBSJw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 04:52:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 01:52:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,459,1574150400"; 
   d="scan'208";a="283066758"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Feb 2020 01:52:59 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 19 Feb 2020 01:52:58 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 19 Feb 2020 01:52:56 -0800
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 19 Feb 2020 01:52:56 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.138]) with mapi id 14.03.0439.000;
 Wed, 19 Feb 2020 17:52:54 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
CC:     Chia-I Wu <olvaffe@gmail.com>, kvm list <kvm@vger.kernel.org>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>
Subject: RE: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Thread-Topic: [RFC PATCH 0/3] KVM: x86: honor guest memory type
Thread-Index: AQHV4rTrI5AbOd4/PkCv4vZnvR6EuagZISQAgAAKbYCAAMs9AIAAnj+AgAAgCACAAAK0AIAAAeyAgAXrxoCAAaZGgA==
Date:   Wed, 19 Feb 2020 09:52:53 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D78D6F4@SHSMSX104.ccr.corp.intel.com>
References: <20200213213036.207625-1-olvaffe@gmail.com>
 <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
 <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com>
 <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com>
 <20200214195229.GF20690@linux.intel.com>
 <CAPaKu7Q4gehyhEgG_Nw=tiZiTh+7A8-uuXq1w4he6knp6NWErQ@mail.gmail.com>
 <CALMp9eRwTxdqxAcobZ7sYbD=F8Kga=jR3kaz-OEYdA9fV0AoKQ@mail.gmail.com>
 <20200214220341.GJ20690@linux.intel.com>
 <d3a6fac6-3831-3b8e-09b6-bfff4592f235@redhat.com>
In-Reply-To: <d3a6fac6-3831-3b8e-09b6-bfff4592f235@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNDFhNjgyZmEtNmE0YS00YzkzLWE2NGItNzRlZGFhNGQ2ZmFmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRDhHM3RyOEF3dHhNQlFwcGRWZ1FUK1Jrb1RQNHB3SkxuTUhaS2lrUStIczlFVkEzZVJ2aHpudnQ4Z1pUVlRoSiJ9
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Paolo Bonzini
> Sent: Wednesday, February 19, 2020 12:29 AM
> 
> On 14/02/20 23:03, Sean Christopherson wrote:
> >> On Fri, Feb 14, 2020 at 1:47 PM Chia-I Wu <olvaffe@gmail.com> wrote:
> >>> AFAICT, it is currently allowed on ARM (verified) and AMD (not
> >>> verified, but svm_get_mt_mask returns 0 which supposedly means the
> NPT
> >>> does not restrict what the guest PAT can do).  This diff would do the
> >>> trick for Intel without needing any uapi change:
> >> I would be concerned about Intel CPU errata such as SKX40 and SKX59.
> > The part KVM cares about, #MC, is already addressed by forcing UC for
> MMIO.
> > The data corruption issue is on the guest kernel to correctly use WC
> > and/or non-temporal writes.
> 
> What about coherency across live migration?  The userspace process would
> use cached accesses, and also a WBINVD could potentially corrupt guest
> memory.
> 

In such case the userspace process possibly should conservatively use
UC mapping, as if for MMIO regions on a passthrough device. However
there remains a problem. the definition of KVM_MEM_DMA implies 
favoring guest setting, which could be whatever type in concept. Then
assuming UC is also problematic. I'm not sure whether inventing another
interface to query effective memory type from KVM is a good idea. There
is no guarantee that the guest will use same type for every page in the
same slot, then such interface might be messy. Alternatively, maybe
we could just have an interface for KVM userspace to force memory type
for a given slot, if it is mainly used in para-virtualized scenarios (e.g. 
virtio-gpu) where the guest is enlightened to use a forced type (e.g. WC)?

Thanks
Kevin
