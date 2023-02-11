Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A0E692EA1
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 07:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjBKG3W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Feb 2023 01:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjBKG3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Feb 2023 01:29:20 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8329D7B179
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 22:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676096958; x=1707632958;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=blXKS1BqUcrN79cpC/uMLIL7c7nvnGo84XElx9Cfo54=;
  b=ggWOpP2qfd0TxnJB/m7ZecboIY3HjESTpxGni9n3sMQvWXH0wip75nxk
   VF04/yJE2vZSHqTLn0Mw+pnsz8Rv8qpJaDpeQ9I8zrLwQSiYuA0TcIGre
   JHtBXg2aWkeAkpoRhFmXgCn1SrUYmuSYkLRqC3gp5jk1VQ0s9yq0bNStk
   +IsEzfRamB0QFx1YPvWuyNbUeKrxvznqqBGGP71SGr+qk08kCMopYd7c+
   7LfmM3hoVSBWah4LQfJQtP5M8TfqsuusBX4YQEPybLoQHWneGBvlMiCyJ
   STtwNRWKnoK16utdfncIYOeZZf2YTL+IhRQiUzVxOY5+HsfJp6ZUjJTab
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="416814109"
X-IronPort-AV: E=Sophos;i="5.97,289,1669104000"; 
   d="scan'208";a="416814109"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 22:29:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="777185285"
X-IronPort-AV: E=Sophos;i="5.97,289,1669104000"; 
   d="scan'208";a="777185285"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 10 Feb 2023 22:29:15 -0800
Message-ID: <8ad6df9827f58daa216f4f750dd5fe26b1b65a40.camel@linux.intel.com>
Subject: Re: [PATCH v4 4/9] KVM: x86: MMU: Integrate LAM bits when build
 guest CR3
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, isaku.yamahata@intel.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Sat, 11 Feb 2023 14:29:15 +0800
In-Reply-To: <9d144ccf640ca7a429df1e7f9e1fe42e8fd8c164.camel@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-5-robert.hu@linux.intel.com>
         <Y+ZPBxFBJTsItzeE@gao-cwp>
         <9d144ccf640ca7a429df1e7f9e1fe42e8fd8c164.camel@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2023-02-11 at 14:24 +0800, Robert Hoo wrote:
> In v1, Kirill and I discussed about this. He lean toward being
> conservative on TLB flush.
> > 
https://lore.kernel.org/kvm/20221103024001.wtrj77ekycleq4vc@box.shutemov.name/

