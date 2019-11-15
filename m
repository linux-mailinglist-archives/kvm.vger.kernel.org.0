Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA64FE47B
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 19:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfKOSBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 13:01:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:37139 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbfKOSBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 13:01:23 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Nov 2019 10:01:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,309,1569308400"; 
   d="scan'208";a="406744746"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 15 Nov 2019 10:01:22 -0800
Date:   Fri, 15 Nov 2019 10:01:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
Subject: Re: KVM_GET_SUPPORTED_CPUID
Message-ID: <20191115180122.GB6055@linux.intel.com>
References: <CALMp9eQ3NcXOJ9MDMBhm2Fi2cvMW7X5GxVgDw97zS=H5vOMvgw@mail.gmail.com>
 <a5845d60-fe38-afc6-e433-4c5a12813026@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5845d60-fe38-afc6-e433-4c5a12813026@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 15, 2019 at 12:42:17PM +0100, Paolo Bonzini wrote:
> On 14/11/19 21:09, Jim Mattson wrote:
> > If I see "AuthenticAMD" in EBX/EDX/ECX,
> > does that mean that "GenuineIntel" is *not* supported? I thought
> > people were having reasonable success with cross-vendor migration.
> 
> This is (2).  But in general passing the host value is the safe choice,
> everything else has reasonable success but it's not something I would
> recommend in production (and it's something I wouldn't mind removing,
> really).

Maybe keep it but add a pr_warn_once() to inform the user that exposions
are likely?  Or make it opt-in via a module param?  I've found this useful
for smoke testing patches that touch AMD/Hygon/Zhaoxin/Centaur code.
