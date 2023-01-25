Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E1567A8F8
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 03:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjAYCoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 21:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjAYCoc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 21:44:32 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127182697
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 18:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674614671; x=1706150671;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8tO64Vs+yaO8vHEU/l+IJl+xZyFULPWaeOwEidd6qS4=;
  b=ffe40TeS/+WDOTdKTho5rTo0+ByQJ7zxBqDFvjbsgv8aCWCQkprZEJ+y
   eIXrj+QDAiC1dG3H8HlSzro+u3O+Ypam3R/7H09kUSpqRYRnMMFvW9nGO
   PQcuou9S25ZMXBQuJl2VzkBjhhgeRs9D7s/G0akRZUBPyr+juk5Rdg30B
   Fm7F0vl17wBtdizJoArULtBxP1DUeR5qgNXWFzOhInbDuuWF2jfMy4Yff
   2/XD7kHHAKJn/4YkcP+PoG3VwI2XISF+89H9k5g0gsHPJEnO+rSc6r08r
   QahBJ9+ciV9mk0zMvBFMBktyS3N2+c44nSTenRJuiVC3BsEQP9A4+vZqM
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="306820546"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="306820546"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 18:44:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="639785316"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="639785316"
Received: from wangbolu-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.173.33])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 18:44:28 -0800
Date:   Wed, 25 Jan 2023 10:44:26 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] KVM: MMU: Add wrapper to check whether MMU is in direct
 mode
Message-ID: <20230125024426.fdlurlafwttlmsmx@linux.intel.com>
References: <20221206073951.172450-1-yu.c.zhang@linux.intel.com>
 <Y8nr9SZAnUguf3qU@google.com>
 <CANgfPd9fLjk+H9aZfykcp31Xd-Z1Yzmd3eAC5PUGhd9za0hnfw@mail.gmail.com>
 <Y9B3BCrvbL5HoIXu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9B3BCrvbL5HoIXu@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 25, 2023 at 12:25:40AM +0000, Sean Christopherson wrote:
> Yu,
> Unless you feel strongly about this one, I'm inclined to leave things as-is.

No problem. And thanks!

B.R.
Yu
