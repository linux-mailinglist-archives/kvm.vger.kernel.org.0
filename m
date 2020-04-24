Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488E01B7CC0
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 19:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgDXR3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 13:29:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:62634 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728912AbgDXR3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 13:29:03 -0400
IronPort-SDR: Gdtgb+u+mQoOJCJqOg74fMfiegzu1gOrk+MmqBG55wEqFj0nzBsNVxNDPlVcq3EQUHa6b7t4CO
 qZTKL0x5hF1g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 10:29:03 -0700
IronPort-SDR: iroeJR4h38q6n21knyLtBKTiIZSYZcde9zT3qKDqytuAABqzmsRmlca8sHgthWSoDbFwbOOkqK
 za6AQS1aPvUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="457991000"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 24 Apr 2020 10:29:03 -0700
Date:   Fri, 24 Apr 2020 10:29:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 00/22] KVM: Event fixes and cleanup
Message-ID: <20200424172902.GF30013@linux.intel.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424172416.243870-1-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 01:23:54PM -0400, Paolo Bonzini wrote:
> Because of this, I added a bool argument to interrupt_allowed, nmi_allowed
> and smi_allowed instead of adding a fourth hook.

Ha, I had this as the original implementation for interrupts, and then
switched to a separate hook at the 11th hour to minimize churn.
