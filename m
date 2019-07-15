Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9549F69AFA
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 20:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbfGOSoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 14:44:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:18063 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729503AbfGOSon (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 14:44:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 11:44:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,493,1557212400"; 
   d="scan'208";a="365953330"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga005.fm.intel.com with ESMTP; 15 Jul 2019 11:44:42 -0700
Date:   Mon, 15 Jul 2019 11:44:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, max@m00nbsd.net,
        Joao Martins <joao.m.martins@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Ignore segment base for VMX memory operand
 when segment not FS or GS
Message-ID: <20190715184441.GD789@linux.intel.com>
References: <20190715154744.36134-1-liran.alon@oracle.com>
 <87r26rw9lv.fsf@vitty.brq.redhat.com>
 <20190715172139.GB789@linux.intel.com>
 <801988b0-b5c0-011e-5775-cb9e22f5d5c2@redhat.com>
 <C000BFA0-5FE2-4AD4-B3F5-079AFE3005A2@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C000BFA0-5FE2-4AD4-B3F5-079AFE3005A2@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 15, 2019 at 09:30:48PM +0300, Liran Alon wrote:
> I like parentheses as it makes ordering of expression a no-brainer.

Matching parantheses is not my forte :-)
