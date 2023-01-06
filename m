Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C516605B5
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 18:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbjAFR3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 12:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234866AbjAFR3h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 12:29:37 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF10A7D1E5;
        Fri,  6 Jan 2023 09:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673026175; x=1704562175;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Bk36Bjlg11pHfC2kVVC8AHsa8BkcjI7RwNUEFj2ZCuM=;
  b=UfeQb14Zptg6yqXSuH6IA18ZfobrLRYLYmJ8iAZ5iPtgf7KDuUYZ3Hxd
   amVZIxAVo2WCx3DDNGP31FEA35YmiHtv3udbsGgZbwsB0lyYyGymP5Iih
   8bJZ459iaddKKk9GG1eu+1GUW7FCBmJh1v3xQYJPDUg+ZFgLm+4eW8Glp
   VDVc/Cr7ehoW9s3xFhJsFvITDQIqhvJzMsRXkz0aAFhXYlslcamovaOWZ
   P42v9B9E4sQy5VN0LN1gbphZdVqSzxVw1pUYZQDpOoLMR0c3DPhrj4twV
   JxOFJ3ki3Cf1+NqEU3C9LiFF2PyDlnmsOORKE62XeJ6+/APKepqglS680
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="306036983"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="306036983"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 09:29:35 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="984734060"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="984734060"
Received: from xiangyuy-mobl.amr.corp.intel.com (HELO [10.212.251.186]) ([10.212.251.186])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 09:29:34 -0800
Message-ID: <61b9cc00-d514-df77-0a31-88ec35d73456@intel.com>
Date:   Fri, 6 Jan 2023 09:29:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 05/16] x86/virt/tdx: Implement functions to make
 SEAMCALL
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1670566861.git.kai.huang@intel.com>
 <d74565e3f71b6e5e5183f3b736222ec42b6e0b81.1670566861.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <d74565e3f71b6e5e5183f3b736222ec42b6e0b81.1670566861.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The subject here is a bit too specific.  This patch isn't just
"implementing functions".  There are more than just functions here.  The
best subject is probably:

	Add SEAMCALL infrastructure

But that's rather generic by necessity because this patch does several
_different_ logical things:

 * Wrap TDX_MODULE_CALL so it can be used for SEAMCALLs with host=1
 * Add handling to TDX_MODULE_CALL to allow it to handle specifically
   host-side error conditions
 * Add high-level seamcall() function with actual error handling

It's probably also worth noting that the code that allows "host=1" to be
passed to TDX_MODULE_CALL is dead code in mainline right now.  It
probably shouldn't have been merged this way, but oh well.

I don't know that you really _need_ to split this up, but I'm just
pointing out that mashing three different logical things together makes
it hard to write a coherent Subject.  But, I've seen worse.
