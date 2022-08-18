Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB29F597E4A
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 07:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243211AbiHRF6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 01:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240278AbiHRF6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 01:58:14 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D55863B5;
        Wed, 17 Aug 2022 22:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660802293; x=1692338293;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=ayXhzx7phdjdWwBWkrOP9ZynJg1vUAEUWGeJ5K7wi9A=;
  b=B9h/Virt3BVP8jaMjgwN3uEeVpcfaaauQASjhjCxDt82n1wkYofmjBxO
   BNTeCYQutCORp6Yrrbr1mW5uzDYy5qyw54dnqCmSkMZ/56bUJCmh1BVnL
   VZDCyOp3MSBSqaWNTG9F6A0wMmtVEn3nvrN8Az4G9b6w0mmV7imi9btzt
   C4W1Us4rLrtHASt8nt2yThSma3ZqxGdr5NVCbQTUl4PrwmklL9qrQlOa5
   dTK3smNLIPHW99vDOU/MBpHiltTaprKMy9E1iK8My9btoP+ANbd22NBdv
   iB2wfjFiLENiyzOBCw7P5iF7/YkJi/fIw0jj3d76VQYLAD5U46ZuUbM+T
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="275722333"
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="275722333"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 22:58:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="667947862"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.193.75])
  by fmsmga008.fm.intel.com with ESMTP; 17 Aug 2022 22:58:11 -0700
Date:   Thu, 18 Aug 2022 13:53:27 +0800
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: Rename KVM_PRIVATE_MEM_SLOTS to
 KVM_INTERNAL_MEM_SLOTS
Message-ID: <20220818055327.GB1166236@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <20220816125322.1110439-1-chao.p.peng@linux.intel.com>
 <20220816125322.1110439-2-chao.p.peng@linux.intel.com>
 <8e675228-b140-08c8-e8d4-2bd0d1121911@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e675228-b140-08c8-e8d4-2bd0d1121911@redhat.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 01:05:30PM +0200, Paolo Bonzini wrote:
> On 8/16/22 14:53, Chao Peng wrote:
> >   #define KVM_MAX_VCPUS		16
> >   /* memory slots that does not exposed to userspace */
> > -#define KVM_PRIVATE_MEM_SLOTS	0
> > +#define KVM_INTERNAL_MEM_SLOTS	0
> 
> This line can be removed altogether.

Right, it's totally unnecessary for arch header.

Chao
> 
> Paolo
