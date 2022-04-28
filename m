Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1AFC513AD8
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 19:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348407AbiD1R2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 13:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244596AbiD1R2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 13:28:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA38A2A272;
        Thu, 28 Apr 2022 10:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651166731; x=1682702731;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DYG9Rn3kLiVzbYKPE5ieeehd4+ubv2m1EeKlPf4Sh2Q=;
  b=koiSeosoEK/WAY2R+xeazVi621ruDH3yTi/kw41XEvsQwVJmlJpOAyzP
   s8WM6gJ0VZJJiOmzXirA8BZuGx6oLdbeqRKan0PEjdPIGc39+krk8zhs6
   goyDE1452vL/sFtOj07urmL6t22uAaAPsA7RrIwQZvlxAAvueIev8+p3G
   BCrAnBOrWiffHrTlW5vmmXMRX9uOz1E0onkmJUqn1n8lpSxJyQs5P5fuU
   O+wMTbJx7ln5m/UpsPBvSpHKqej+rwwy2gfwZu7fKJylKjjT57nafDw1f
   vURkeRI4OzR8hLrDZv/aru5chxhrxQAt6eN1hBOgdQZ+0bLvR04uBx3W1
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="246917809"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="246917809"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 10:25:28 -0700
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="559784532"
Received: from mpoursae-mobl2.amr.corp.intel.com (HELO [10.212.0.84]) ([10.212.0.84])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 10:25:27 -0700
Message-ID: <7e63912a-895f-d3b3-3173-336beaa86d08@intel.com>
Date:   Thu, 28 Apr 2022 10:25:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 20/21] x86/virt/tdx: Add kernel command line to opt-in
 TDX host support
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <0d50d13e5f9bd590ee97ff150f1393c4d99a8fa0.1649219184.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <0d50d13e5f9bd590ee97ff150f1393c4d99a8fa0.1649219184.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/22 21:49, Kai Huang wrote:
> Enabling TDX consumes additional memory (used by TDX as metadata) and
> additional initialization time.  Introduce a kernel command line to
> allow to opt-in TDX host kernel support when user truly wants to use
> TDX.

From the cover letter:

	"This series doesn't initialize TDX at boot time"

Could you please square that circle for me?  How does a feature that
doesn't get initialized a boot time need a boot-time command line opt-in?
