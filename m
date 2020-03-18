Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE9D218A034
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 17:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgCRQJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 12:09:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:46855 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgCRQJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Mar 2020 12:09:38 -0400
IronPort-SDR: VeoafylxGTkLVVfFk08tt1gbYEePF0CiKWknQMPjHgG8A+B9D39KDkVy2VJdepqj5sak38gZS3
 lnGHapkRt6wA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 09:09:38 -0700
IronPort-SDR: Hpmo2mv5SFsFQ+EzPVzAI1bd6Z4/F0fM4KK6OGaY49neFNwf+8E0Zhk6tHTCaMZoeEMqjx7upZ
 QhcsxzA12QQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,568,1574150400"; 
   d="scan'208";a="291357231"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Mar 2020 09:09:37 -0700
Date:   Wed, 18 Mar 2020 09:09:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 23/32] KVM: nVMX: Add helper to handle TLB flushes on
 nested VM-Enter/VM-Exit
Message-ID: <20200318160937.GH24357@linux.intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
 <20200317045238.30434-24-sean.j.christopherson@intel.com>
 <0975d43f-42b6-74db-f916-b0995115d726@redhat.com>
 <20200317181832.GC12959@linux.intel.com>
 <f4850521-29fe-51ff-05e7-76cef1fa0fd9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4850521-29fe-51ff-05e7-76cef1fa0fd9@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 18, 2020 at 11:45:57AM +0100, Paolo Bonzini wrote:
> Perhaps nested_vmx_transition_tlb_flush could grow a vmentry/vmexit bool
> argument instead?

I'll give that a shot.
