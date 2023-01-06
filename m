Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381BB6606E4
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 20:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjAFTE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 14:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbjAFTE5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 14:04:57 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65211F3;
        Fri,  6 Jan 2023 11:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673031896; x=1704567896;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=U0B3FcIGKcygAKtvShqUhbCH3EMjINmxqyyYU8bpZpU=;
  b=nu+b9gXIqQ5UbIMk4Ytl06yo8Taudh6z4WGu4/3BoPX3UadunuhutbXU
   l/QxX5Ia/xN8TC9kHS7cHIaImfieudh10VDlS02hVt+V+RH/WsS8HKwVj
   Dy6OoCnBMnf2rcFFYbwzRXqdnis+uPop6iZIJ5RU58MQ8fTOy+CrPSoUy
   z4lF1Wkk9ZC2Gh2D3+vj22obJ7qhis7mztRRHI5JjnAvTNXPWnJHyXS9T
   ukPdgBckQhEmmqfQezc9dKvJd4VmCIPvYxtQK5Y0l8YEfZbXE0G1Ch7FS
   ccVpFR2TZK30C6cmLFdEcFE3c/26mw1nvGzLkUGIOEPJp0YeM851cUp8k
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="323786390"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="323786390"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 11:04:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="656020455"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="656020455"
Received: from xiangyuy-mobl.amr.corp.intel.com (HELO [10.212.251.186]) ([10.212.251.186])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 11:04:55 -0800
Message-ID: <44161611-67f9-f5cf-0827-6dd8839a1871@intel.com>
Date:   Fri, 6 Jan 2023 11:04:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 03/16] x86/virt/tdx: Make INTEL_TDX_HOST depend on
 X86_X2APIC
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
 <514a6c330ef5fc214d32bcbcc7a77dc825e857df.1670566861.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <514a6c330ef5fc214d32bcbcc7a77dc825e857df.1670566861.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/22 22:52, Kai Huang wrote:
> TDX capable platforms are locked to X2APIC mode and cannot fall back to
> the legacy xAPIC mode when TDX is enabled by the BIOS.  TDX host support
> requires x2APIC.  Make INTEL_TDX_HOST depend on X86_X2APIC.

Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>

