Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71851170279
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 16:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgBZPah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 10:30:37 -0500
Received: from mga04.intel.com ([192.55.52.120]:32395 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728221AbgBZPag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 10:30:36 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Feb 2020 07:30:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,488,1574150400"; 
   d="scan'208";a="271772074"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 26 Feb 2020 07:30:35 -0800
Date:   Wed, 26 Feb 2020 07:30:35 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: Fix some obsolete comments
Message-ID: <20200226153035.GB9940@linux.intel.com>
References: <3e25a121a6754020ac3a1eda9fb7fad6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e25a121a6754020ac3a1eda9fb7fad6@huawei.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 26, 2020 at 01:48:28AM +0000, linmiaohe wrote:
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> >linmiaohe <linmiaohe@huawei.com> writes:
> >> throws
> >> - * #UD or #GP.
> >> + * #UD, #GP or #SS.
> >
> >Oxford comma, anyone? :-)))
> 
> I have no strong preference. ^_^

I'm also a fan of the Oxford comma when it comes to describing code.
