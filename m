Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581B11E4B6B
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 19:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgE0RIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 13:08:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:24714 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgE0RIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 13:08:17 -0400
IronPort-SDR: 4RypG239s4ykV/TPrMOD2E6bLZM6tKwPHizrqAshjKC+lYZgA/WixNZ5NaUFs9eJMK9ypgsLH8
 lkFBG0G5BNxA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 10:06:13 -0700
IronPort-SDR: eXcf5DjvIgIvmCd3FZhCi3GvS7LhmuToG8rM/iNhyd+XIRI5fZy2Bhusu9VMUX8I4fZ1d0zwiF
 tqdj7avK+8DQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,442,1583222400"; 
   d="scan'208";a="414277949"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 27 May 2020 10:06:13 -0700
Date:   Wed, 27 May 2020 10:06:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+904752567107eefb728c@syzkaller.appspotmail.com
Subject: Re: [PATCH] KVM: x86: Initialize tdp_level during vCPU creation
Message-ID: <20200527170612.GA24930@linux.intel.com>
References: <20200527085400.23759-1-sean.j.christopherson@intel.com>
 <40800163-2b28-9879-f21b-687f89070c91@redhat.com>
 <20200527162933.GE24461@linux.intel.com>
 <078365dd-64ff-4f3c-813c-3d9fc955ed1a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <078365dd-64ff-4f3c-813c-3d9fc955ed1a@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 27, 2020 at 06:56:19PM +0200, Paolo Bonzini wrote:
> On 27/05/20 18:29, Sean Christopherson wrote:
> > Ya.  syzbot is hitting a #GP due to NULL pointer during debugfs on the exact
> > same sequence.  I haven't been able to reproduce that one (have yet to try
> > syzbot's exact config), but it's another example of a "dumb" test hitting
> > meaningful bugs.
> 
> Saw that, it's mine. :)

All yours.  I as hoping it would be easily reproducible and fixable while I
was looking at the MMU BUG(), but that didn't happen.
