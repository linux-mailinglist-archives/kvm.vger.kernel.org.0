Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796A72FDEF3
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 02:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392282AbhAUBmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 20:42:44 -0500
Received: from mga17.intel.com ([192.55.52.151]:21564 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731094AbhAUBgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 20:36:19 -0500
IronPort-SDR: kH1BGHfvFepryiFGoKgjAtYlEv8BLZ/mwTGJDZo0FsNtaTXYXyu1A4WW6IZP9A4OetWIHrLto9
 OmEWtvq2uTKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="158977927"
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="158977927"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 17:29:03 -0800
IronPort-SDR: nYFb+7rKVaq2wI4tWIpigR5i37aF+Cmbt96IJG40qsmct+ssyL6XwYxIku13mfGu1Xkx5fFJvw
 Je7IWIUyyFnA==
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="427109106"
Received: from gapoveda-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.79.186])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 17:28:58 -0800
Date:   Thu, 21 Jan 2021 14:28:56 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Subject: Re: [RFC PATCH v2 00/26] KVM SGX virtualization support
Message-Id: <20210121142856.c4f0ef1cbde3332edbd1820e@intel.com>
In-Reply-To: <7cd130cc-cda5-97d5-7c25-99fe813de824@redhat.com>
References: <cover.1610935432.git.kai.huang@intel.com>
        <YAaW5FIkRrLGncT5@kernel.org>
        <0adf45fae5207ed3d788bbb7260425f8da7aff43.camel@intel.com>
        <YAhb1mYB3ajc2/n9@google.com>
        <7cd130cc-cda5-97d5-7c25-99fe813de824@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Jan 2021 17:39:13 +0100 Paolo Bonzini wrote:
> On 20/01/21 17:35, Sean Christopherson wrote:
> > On Wed, Jan 20, 2021, Kai Huang wrote:
> >> I'd like to take this chance to ask: when this series is ready to be merged, what is
> >> the properly way to merge? This series has x86 non-sgx (cpufeature, feat_ctl) and sgx
> >> changes, and it obviously has KVM changes too. So instance, who should be the one to
> >> take this series? And which tree and branch should I rebase to in next version?
> > The path of least resistance is likely to get acks for the x86 and sgx changes,
> > and let Paolo take it through the KVM tree.  The KVM changes are much more
> > likely to have non-trivial conflicts, e.g. making exit_reason a union touches a
> > ton of code; getting and carrying acked-by for those will be tough sledding.
> > 
> 
> Yes, the best way is to get a topic branch from Thomas or Borislav.

Thanks Paolo. I'll rebase against tip/x86/sgx for future versions.

> 
> Paolo
> 
