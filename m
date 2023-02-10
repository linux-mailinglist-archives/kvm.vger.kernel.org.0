Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C645691A28
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 09:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjBJIlk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 03:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbjBJIlj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 03:41:39 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40885D3EA
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 00:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676018497; x=1707554497;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lWgY8rhc69legxd7PC2bs8oScnh31bFdZ/CKbmm+udI=;
  b=mcwePUXX0Zrr5NbWthWJ5azJvXxNQEpOdTIO3aattU1dejdHgzP7sXQF
   /aIDEOst+B47WWqwTM+8atIz3kdDEV1gDlBQF3eK9CiPB/afLDP0jWlq+
   bcz1yIUoc8aN77C5oocKfMldCGNeTtWseIlbQu2PyrkZdsnax+Y/I+WaD
   g7EP97q68iAdvVz3jFgtiERtMfliIHwlnPVC5RnpSVE45DRvI4VU+H+HX
   jfMdHqb0A8n/0/rvay4B14aZceq+p5f94lUjkXLFJjcibTKiwvaLRKxYr
   0wcgvmu0kTfwougB9Iw+t3TZ53hsQcLoMv0LPMdHLQREohzGK3q/DDIei
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="331672958"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="331672958"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 00:41:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="669925998"
X-IronPort-AV: E=Sophos;i="5.97,286,1669104000"; 
   d="scan'208";a="669925998"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga007.fm.intel.com with ESMTP; 10 Feb 2023 00:41:31 -0800
Message-ID: <8d7e2c0f25c8fcb2c16633b74c0fade6ba145b08.camel@linux.intel.com>
Subject: Re: [PATCH v4 0/9] Linear Address Masking (LAM) KVM Enabling
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        yu.c.zhang@linux.intel.com, yuan.yao@linux.intel.com,
        jingqi.liu@intel.com, weijiang.yang@intel.com,
        isaku.yamahata@intel.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org
Date:   Fri, 10 Feb 2023 16:41:30 +0800
In-Reply-To: <Y+W3W0f9YXfGeSDY@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <Y+SPjkY87zzFqHLj@gao-cwp>
         <5884e0cb15f7f904728fa31bb571218aec31087c.camel@linux.intel.com>
         <Y+UtDxPqIEeZ0sYH@google.com>
         <abbb29911d4517d87c0694db8d51b7935fd977bd.camel@linux.intel.com>
         <Y+W3W0f9YXfGeSDY@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-02-10 at 11:17 +0800, Chao Gao wrote:
> 
> Alternatively, add another kselftest for LAM under kselftests/kvm.
> 
Let me explore.

