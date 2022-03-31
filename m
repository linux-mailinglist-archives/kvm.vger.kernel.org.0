Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849C44EE4DB
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 01:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243125AbiCaXnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 19:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243114AbiCaXnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 19:43:04 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10B01AECB9;
        Thu, 31 Mar 2022 16:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648770076; x=1680306076;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VF/NN9r92wUVinR+mO2GEHDVkuJEklr84R2QBIjD3NQ=;
  b=V1mTgb3+YFgpUulzF9jwtCrznJ0oWop9X+2kCeDICdhQE7Hu9tUe2XIT
   PSCcl0sXznGGsN4grDp8LTd899l2aswFq4gKiHVSWSGQRqN90DzlwXoCb
   UgV8vLYqQof+4BhF8ALDAY6FUvd3ms1kBEz/5OMLdjeXrn6aqKKZAdX8w
   ZwbGPnKQ1Ptu0aKpUV6vPw8oKUwhxsI+rWYsRsQ60S+f2Pe+KF+1Zqgf0
   PZiRr8iqYHGMmyzIUwYiaH8IUJVDpH1442CEF6p9nZMt6PczQQAr7V5Bf
   LxrB1S62uy8kr9PpKC0zeOBI3OHy5ObXoj7d6FmJz4JptcEI+cDjzq6qP
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="257570444"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="257570444"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 16:41:16 -0700
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="650494426"
Received: from fpaolini-mobl2.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.53.114])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 16:41:14 -0700
Message-ID: <945248cc85926fdbee65a2ad9165d86205973340.camel@intel.com>
Subject: Re: [RFC PATCH v5 024/104] KVM: TDX: create/destroy VM structure
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Fri, 01 Apr 2022 12:41:12 +1300
In-Reply-To: <20220331221207.GD2084469@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <36805b6b6b668669d5205183c338a4020df584dd.1646422845.git.isaku.yamahata@intel.com>
         <fedfdfbc26965145dcbf4aa893328cce172f2f3b.camel@intel.com>
         <20220331221207.GD2084469@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-31 at 15:12 -0700, Isaku Yamahata wrote:
> > It's really not clear why you need to know tdx_global_keyid in the context
> > of
> > creating/destroying a TD.
> 
> TDX module mpas TDR with TDX global key id. This page includes key id assigned
> to this TD.  Then, TDX modules maps other TD-related pages with the HKID.
> TDR requires the TDX global key id for cache flush unlike other TD-related
> pages.
> I'll add a comment.

Sorry I forgot this. Thanks.

-- 
Thanks,
-Kai


