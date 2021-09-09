Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D9B40460F
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 09:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352493AbhIIHXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 03:23:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:1613 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232549AbhIIHXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 03:23:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="220740051"
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="220740051"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 00:22:40 -0700
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="539452379"
Received: from gchen28-mobl2.ccr.corp.intel.com (HELO localhost) ([10.255.31.74])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 00:22:37 -0700
Date:   Thu, 9 Sep 2021 15:22:35 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH] KVM: nVMX: Reset vmxon_ptr upon VMXOFF emulation.
Message-ID: <20210909072235.vw7mf7cmrzfe2ejo@linux.intel.com>
References: <20210909124846.13854-1-yu.c.zhang@linux.intel.com>
 <874kau496u.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kau496u.fsf@vitty.brq.redhat.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 07:19:53AM +0200, Vitaly Kuznetsov wrote:
> 
> Thanks but even Suggested-by: would be enough :-)
> 

I just copied your code. And actually I should be the one to say thanks. :)

B.R.
Yu

