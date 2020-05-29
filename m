Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2ACE1E8619
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 19:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgE2R7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 13:59:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:51997 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgE2R7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 13:59:41 -0400
IronPort-SDR: 6VOePsFTFcY04vNbA/f+ewOMaL98qN3aBFNsAJ1iGYJ+/ZUeRj79tRzLyiLOjGq0yMvYrxUQWm
 XobN6LW0cetg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 10:59:39 -0700
IronPort-SDR: knL032ly+qdn783WEnXn3ZozY/zzyRpbTa8wdhzis1bZflyG91WYdyMnNxcYckHuOampEK/fpI
 ilYsryIvDGmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,449,1583222400"; 
   d="scan'208";a="267637977"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 29 May 2020 10:59:39 -0700
Date:   Fri, 29 May 2020 10:59:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 00/28] KVM: nSVM: event fixes and migration support
Message-ID: <20200529175939.GC1074@linux.intel.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> [PATCH v3 00/28] KVM: nSVM: event fixes and migration support

You've got something funky going on with the way you generate cover letters,
looks like it doesn't count patches authored by someone else.  The 'v3' is
also missing from the patches, though I suppose some heathens do that on
purpose.

> Paolo Bonzini (28):
> 
> Vitaly Kuznetsov (2):
