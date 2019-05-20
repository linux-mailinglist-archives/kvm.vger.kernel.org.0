Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A86323B53
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 16:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392108AbfETO4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 10:56:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:40049 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731455AbfETO4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 10:56:24 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 07:56:23 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga008.fm.intel.com with ESMTP; 20 May 2019 07:56:22 -0700
Date:   Mon, 20 May 2019 07:56:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v3 4/5] KVM: LAPIC: Delay trace advance expire delta
Message-ID: <20190520145621.GA28482@linux.intel.com>
References: <1557975980-9875-1-git-send-email-wanpengli@tencent.com>
 <1557975980-9875-5-git-send-email-wanpengli@tencent.com>
 <20190517194450.GH15006@linux.intel.com>
 <CANRm+Cz1kVkPQwDB3s_kD1ewdgUWaB4kQNZj_FqACPKk032Mgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+Cz1kVkPQwDB3s_kD1ewdgUWaB4kQNZj_FqACPKk032Mgw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 20, 2019 at 02:38:44PM +0800, Wanpeng Li wrote:
> On Sat, 18 May 2019 at 03:44, Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > This needs to be guarded with lapic_in_kernel(vcpu).  But, since this is
> > all in the same flow, a better approach would be to return the delta from
> > wait_lapic_expire().  That saves 8 bytes in struct kvm_timer and avoids
> > additional checks for tracing the delta.
> 
> As you know, the function wait_lapic_expire() will be moved to vmx.c
> and svm.c, so this is not suitable any more.

Doh, I was too excited about my cleverness and completely forgot why you
were moving the tracepoint in the first place.
