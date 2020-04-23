Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DB11B616C
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 18:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbgDWQ6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 12:58:13 -0400
Received: from mga07.intel.com ([134.134.136.100]:29937 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729674AbgDWQ6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 12:58:13 -0400
IronPort-SDR: uczyJBIVWGe3w7T57uI6CV5S2+Fqu4T90msaLkgqCk8Uj2tnlMjrJAt5LCWGaawwT0TL7LD2ld
 Hbcdaz0QYi/Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 09:58:12 -0700
IronPort-SDR: qjpDu3ONHas76ce28A93Rb7S1EH0sU89fRTYk9Dckw1XsVWHZFoWom3tTqGLmt0fqTQNd0rqB0
 Q5Sir5BTrXjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="259488743"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 23 Apr 2020 09:58:12 -0700
Date:   Thu, 23 Apr 2020 09:58:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 9/9] KVM: X86: Set CET feature bits for CPUID
 enumeration
Message-ID: <20200423165812.GC25564@linux.intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-10-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326081847.5870-10-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the shortlog, use something like

  KVM: x86: Enable CET virtualization and advertise CET to userspace

It took me a while to find the patch that actually allowed setting CR4.CET
because I was only scanning the shortlogs :-)
