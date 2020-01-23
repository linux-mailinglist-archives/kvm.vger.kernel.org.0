Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4676146D2E
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 16:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgAWPp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 10:45:28 -0500
Received: from mga04.intel.com ([192.55.52.120]:29414 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbgAWPp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 10:45:28 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 07:45:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,354,1574150400"; 
   d="scan'208";a="222375221"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 23 Jan 2020 07:45:27 -0800
Date:   Thu, 23 Jan 2020 07:45:27 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tao Xu <tao3.xu@intel.com>, Jingqi Liu <jingqi.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND] Atomic switch of MSR_IA32_UMWAIT_CONTROL
Message-ID: <20200123154526.GC13178@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cc'ing KVM and LKML this time...

Why does KVM use the atomic load/store lists to load MSR_IA32_UMWAIT_CONTROL
on VM-Enter/VM-Exit?  Unless the host kernel is doing UWMAIT, which it
really shouldn't and AFAICT doesn't, isn't it better to use the shared MSR
mechanism to load the host value only when returning to userspace, and
reload the guest value on demand?
