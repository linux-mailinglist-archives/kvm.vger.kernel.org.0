Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6D4E3D18
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 22:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfJXUVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 16:21:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:5516 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbfJXUVh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 16:21:37 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 13:21:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,226,1569308400"; 
   d="scan'208";a="202408345"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 24 Oct 2019 13:21:36 -0700
Date:   Thu, 24 Oct 2019 13:21:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ken Hofsass <hofsass@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2] kvm: x86: Add cr3 to struct kvm_debug_exit_arch
Message-ID: <20191024202136.GC28043@linux.intel.com>
References: <20191024195431.183667-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024195431.183667-1-jmattson@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 12:54:31PM -0700, Jim Mattson wrote:
> From: Ken Hofsass <hofsass@google.com>
> 
> A userspace agent can use cr3 to quickly determine whether a
> KVM_EXIT_DEBUG is associated with a guest process of interest.
> 
> KVM_CAP_DEBUG_EVENT_PDBR indicates support for the extension.

Isn't PDBR x86-specific terminology?  If we're going to use something that
is x86-specific then just call it GUEST_CR3.  If there's a chance that
this is useful on other architectures then it'd probably be better to go
with Linux's own terminology, e.g. KVM_CAP_DEBUG_EVENT_GUEST_PGD.

> Signed-off-by: Ken Hofsass <hofsass@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Cc: Peter Shier <pshier@google.com>
> ---
> v1 -> v2: Changed KVM_CAP_DEBUG_EVENT_PG_BASE_ADDR to KVM_CAP_DEBUG_EVENT_PDBR
>           Set debug.arch.cr3 in kvm_vcpu_do_singlestep and
> 	                        kvm_vcpu_check_breakpoint
>           Added svm support

Heh, I wonder what the record is for longest time between legitimate
versions of a single patch.
