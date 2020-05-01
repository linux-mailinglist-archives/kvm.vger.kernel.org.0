Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8BD1C1E59
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 22:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgEAUXX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 16:23:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:57920 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAUXX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 16:23:23 -0400
IronPort-SDR: eAkQ2TFQm3VaduO8aW/bPAT4ahTI6WTQUIoaELxBdWuaf7cBuE8awOi6EOtyLgg4deSg2N369b
 hlQSS5C7g0FA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 13:23:23 -0700
IronPort-SDR: zr+5mRuHVXvIcs+GkIFqJPZH9C9RNmzHSnaB1jv8+SDgfqUekCo67Dijr2/eJxjE12cpO1hvJ+
 CmpBltkdSnbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,340,1583222400"; 
   d="scan'208";a="247597633"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga007.jf.intel.com with ESMTP; 01 May 2020 13:23:22 -0700
Date:   Fri, 1 May 2020 13:23:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Forrest Yuan Yu <yuanyu@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH RFC 0/1] Hypercall UCALL for guest/userspace communication
Message-ID: <20200501202322.GC4760@linux.intel.com>
References: <20200501185147.208192-1-yuanyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501185147.208192-1-yuanyu@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 01, 2020 at 11:51:46AM -0700, Forrest Yuan Yu wrote:
> This RFC is to add a hypercall UCALL so that guest can communicate with
> the userspace hypervisor. A guest may want to do this in different
> scenarios. For example, a guest can ask the userspace hypervisor to
> harden security by setting restricted access permissions on guest SLAT
> entries.
> 
> Please note this hypercall provides the infrastructure for this type of
> communication but does not enforce the protocol. A proposal for the
> guest/userspace communication protocol will follow if this RFC is
> accepted.

It's hard to review certain aspects of the proposal without seeing the
usage of it.  Can you post the whole thing as an RFC?
