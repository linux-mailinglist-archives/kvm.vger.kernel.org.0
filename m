Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC0329D5AF
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 23:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbgJ1WH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 18:07:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:9420 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730357AbgJ1WHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Oct 2020 18:07:54 -0400
IronPort-SDR: 40FHPcWqQj1zxW/9cQqRsalTkTN8+904YEC5PXmBkLXB00Ob4qcHRmK1QaHzHqiKw7hzTkifXK
 H3lQQaixz6sQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9788"; a="164795977"
X-IronPort-AV: E=Sophos;i="5.77,427,1596524400"; 
   d="scan'208";a="164795977"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2020 10:04:33 -0700
IronPort-SDR: Wk+cwQAX4UPPu1+Li/FegkOVOmBdRomPZlJPiY7KK86Ir7CYzhZssJFvA7qlf0OpQ6e3vs4Slo
 YNNYDIsRR5Eg==
X-IronPort-AV: E=Sophos;i="5.77,427,1596524400"; 
   d="scan'208";a="351078828"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2020 10:04:33 -0700
Date:   Wed, 28 Oct 2020 10:04:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: kvm: avoid -Wshadow warning in header
Message-ID: <20201028170430.GC7584@linux.intel.com>
References: <20201026161512.3708919-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026161512.3708919-1-arnd@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 26, 2020 at 05:14:39PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> There are hundreds of warnings in a W=2 build about a local
> variable shadowing the global 'apic' definition:
> 
> arch/x86/kvm/lapic.h:149:65: warning: declaration of 'apic' shadows a global declaration [-Wshadow]
> 
> Avoid this by renaming the local in the kvm/lapic.h header

Rather than change KVM, and presumably other files as well, e.g. kvm/lapic.c and
apic/io_apic.c also shadow 'apic' all over the place, what about renaming the
global 'apic' to something more unique?  KVM aside, using such a common name for
a global variable has always struck me as a bit odd/dangerous/confusing.
