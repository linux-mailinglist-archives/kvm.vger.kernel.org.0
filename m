Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CE34044CD
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 07:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350616AbhIIFOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 01:14:19 -0400
Received: from mga06.intel.com ([134.134.136.31]:46566 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350556AbhIIFOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 01:14:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="281696117"
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="281696117"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:13:09 -0700
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="539264067"
Received: from gchen28-mobl2.ccr.corp.intel.com (HELO localhost) ([10.255.31.74])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:13:05 -0700
Date:   Thu, 9 Sep 2021 13:13:03 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH] KVM: nVMX: fix comments of handle_vmon()
Message-ID: <20210909051303.yqsrs32pxvkkoh3n@linux.intel.com>
References: <20210908171731.18885-1-yu.c.zhang@linux.intel.com>
 <87lf474ci8.fsf@vitty.brq.redhat.com>
 <20210908130145.3uwmywgjaahyb6iw@linux.intel.com>
 <87ilzb4216.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilzb4216.fsf@vitty.brq.redhat.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 08, 2021 at 03:42:13PM +0200, Vitaly Kuznetsov wrote:
> 
> Sure, this is rather a separate patch. Thanks!

Oh, right. Just sent out a seperate patch. :)

@Paolo Any comment on this one? Thanks!

B.R.
Yu
