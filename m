Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C590D192D3D
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 16:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgCYPsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 11:48:13 -0400
Received: from mga03.intel.com ([134.134.136.65]:41526 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727488AbgCYPsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 11:48:12 -0400
IronPort-SDR: H7QHC5JvcRqbdIxTOlGsqRWkg5rV+ZM8TKJjwjweEte28FiRCDtHFPN3/HjRTvdRhm93nSc4NZ
 iIC83QxYrHwQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 08:48:12 -0700
IronPort-SDR: cueDm/sOY9PGMvf3GoIW8dpFzWxkHFbyNLfYb/y86MuDHH4bAV7S6l6IHqmSdsP3daRE039x/X
 +IWa1pi/7NNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,304,1580803200"; 
   d="scan'208";a="446660860"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 25 Mar 2020 08:48:10 -0700
Date:   Wed, 25 Mar 2020 08:48:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [PATCH v3 14/37] KVM: x86: Move "flush guest's TLB" logic to
 separate kvm_x86_ops hook
Message-ID: <20200325154810.GE14294@linux.intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-15-sean.j.christopherson@intel.com>
 <87369w7mxe.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87369w7mxe.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 25, 2020 at 11:23:41AM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> I *think* I've commented on the previous version that we also have
> hyperv-style PV TLB flush and this will likely need to be switched to
> tlb_flush_guest().

Oh, you most definitely commented about HyperV's PV TLB flush, looking at
that code is what led me down this rabbit hole :-)
