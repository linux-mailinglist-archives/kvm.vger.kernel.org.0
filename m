Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204D268E841
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 07:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjBHG3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 01:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjBHG3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 01:29:00 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1391BAC0;
        Tue,  7 Feb 2023 22:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675837730; x=1707373730;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GUwdAymke70lWquX9/URDnniCW3T9Sn4HLCvziI9OX8=;
  b=OKlwiNqqUPaf7yq/r3oKgvo2M52QetQnCFvh4COmi3Yf08XQV5bRPNtL
   uzzNY540vBYawhTSpWQmDQ1Ti3Bgss8EO604t7i2+HDfJeCNlDc+PTVCY
   AkuJLqvA69RT6933959zLrMlAQHB/mp70tbdmbsp83jBhNMd9C+PJL8Al
   YWaZtcF58c4DZi4kYdwyqnTS2CkwR73d4E0ZgziRrkzYZPFEXV9cQdEtL
   VVecpvcnKX/KOuMHl5PWZ3ehioMpfoInq6qXBePbwCOZrakUuNftOOrKk
   Q9DooTURj6duVAgZZwY28pq4mMk7QgQ6EWIgYh5uAazwzIejqqwRtQWK/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="328378655"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="328378655"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 22:28:50 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="755925892"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="755925892"
Received: from twang11-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.210.195])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 22:28:48 -0800
Date:   Wed, 8 Feb 2023 14:28:48 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Cleanup VMFUNC handling in KVM.
Message-ID: <20230208062848.myhma46kfq6dv4e6@linux.intel.com>
References: <20221109075413.1405803-1-yu.c.zhang@linux.intel.com>
 <167573583777.163276.8920768819160007143.b4-ty@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167573583777.163276.8920768819160007143.b4-ty@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> After much waffling, applied to kvm-x86 vmx.  I ended up keeping the logic to
> inject #UD on now-unexpected VMFUNC exits from L1, i.e. patch one does nothing
> more than clear the control bit.  I like the idea of clearing the control bit as
> it more explicitly documents what's going on, but killing the VM on an unexpected
> exit that KVM can gracefully handle seemed unnecessary.

Glad to know that. Thanks!

B.R.
Yu
