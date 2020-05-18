Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6813A1D7C4F
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 17:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgERPFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 11:05:05 -0400
Received: from mga12.intel.com ([192.55.52.136]:22351 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbgERPFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 11:05:04 -0400
IronPort-SDR: 305zeS+kcWD0TMHLCckGhJi8fJLXR6N/ZiFMDyfjHG4qqmzqDRKrPDqQeu61s4SqbYcoX1vc6l
 vTe25RMSqHbA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 08:05:03 -0700
IronPort-SDR: Vd9P702OhnTD65JgCyk6ybw/3fCd/mJxdm4xaT7hjG79UP3iByIu24MuLNT/WNYwW971Wpmo0Y
 KgJoXokK7tmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,407,1583222400"; 
   d="scan'208";a="252919967"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga007.jf.intel.com with ESMTP; 18 May 2020 08:05:01 -0700
Date:   Mon, 18 May 2020 08:05:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterx@redhat.com
Subject: Re: [PATCH 1/4] KVM: nSVM: fix condition for filtering async PF
Message-ID: <20200518150501.GA3632@linux.intel.com>
References: <20200516135311.704878-1-pbonzini@redhat.com>
 <20200516135311.704878-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516135311.704878-2-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 16, 2020 at 09:53:08AM -0400, Paolo Bonzini wrote:
> Async page faults have to be trapped in the host (L1 in this
> case), since the APC reason was passed from L0 to L1 and stored
> in the L1 APF data page.  This was completely reversed, as the
> page faults were passed to the guest (a L2 hypervisor).
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
