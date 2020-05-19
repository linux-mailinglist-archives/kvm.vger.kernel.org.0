Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1377C1D9B51
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 17:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbgESPcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 11:32:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:52463 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728725AbgESPcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 11:32:46 -0400
IronPort-SDR: UC93HEYzRvdDZIkbrYIhRyUsFRF9Pg7bN/AwzjhKIdK3WwQibCzV9pzKzSDs+jh85+SmSDYMGX
 1lS/YJTh6jqQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 08:32:45 -0700
IronPort-SDR: avUOY8WQDBIZrziULGrq5yCY/mAWmxiDQ1LuL+8pObXXf+iea8sJYVAI8a94dC3esXL+QAlpBJ
 w2sRmTxMEpCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,410,1583222400"; 
   d="scan'208";a="253386551"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 19 May 2020 08:32:45 -0700
Date:   Tue, 19 May 2020 08:32:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: emulate reserved nops from 0f/18 to 0f/1f
Message-ID: <20200519153244.GB13603@linux.intel.com>
References: <20200515161919.29249-1-pbonzini@redhat.com>
 <20200518160720.GB3632@linux.intel.com>
 <57d9da9b-00ec-3fe0-c69a-f7f00c68a90d@redhat.com>
 <20200519060156.GB4387@linux.intel.com>
 <60c2c33c-a316-86d2-118a-96b9f4770559@redhat.com>
 <20200519075523.GE5189@linux.intel.com>
 <be7fa327-51b9-1f95-454d-f4f9c15a1b63@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be7fa327-51b9-1f95-454d-f4f9c15a1b63@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 19, 2020 at 10:06:25AM +0200, Paolo Bonzini wrote:
> On 19/05/20 09:55, Sean Christopherson wrote:
> > Tangentially related, isn't the whole fastop thing doomed once CET kernel
> > support lands?
> 
> Why?  You do need to add endbr markers and some of the fastop handlers
> won't fit in 8 bytes, but that should be it.

Never mind, had a brain fart and forgot CALL_NOSPEC shouldn't get patched
to a retpoline on CET capable CPUs.
