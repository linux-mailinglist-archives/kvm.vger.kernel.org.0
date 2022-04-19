Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74713506FC7
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 16:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353004AbiDSOKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 10:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352983AbiDSOKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 10:10:33 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664DB2AC4F;
        Tue, 19 Apr 2022 07:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650377271; x=1681913271;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+7O+UQ3D7o5J+XgvqciNrRwiHvMtxbrVEPEXk4mInmY=;
  b=KuIwo9e/1kjD1YBMrAO+CdXUI90kNQxPsJz1gfll/isVLECn13I7baoW
   VG/UaizlkH/BTlpU7QLpONnEGJKPAwwMtn0i8Ak0RFFWyTLZCtmJzcKGB
   F5WzeD0VGCVYJVz7HxanwgTWhTp56WhX5biHmfewYiZxDBKpc/aMaYsO1
   mf9ev3txTin0xbva/LuzKbJ1q23W0i5IZ41bffPn5ENRjYAH/sXp9ioXW
   lIZuq49sb9y2UsCoOFn7qs/Fs4f/1DobTrFg6uZoMNdb9jEulSADKWLPp
   zDvP8Wwm1ODZA/APMKnXIVoyfFx3Z2ULToqX3eqvERLY0qPH/aTnxeOwV
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="243705047"
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="243705047"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 07:07:51 -0700
X-IronPort-AV: E=Sophos;i="5.90,272,1643702400"; 
   d="scan'208";a="554743115"
Received: from chferrer-mobl.amr.corp.intel.com (HELO [10.209.37.31]) ([10.209.37.31])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 07:07:50 -0700
Message-ID: <dd9d6f7d-5cec-e6b7-2fa0-5bf1fdcb79b5@linux.intel.com>
Date:   Tue, 19 Apr 2022 07:07:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v3 03/21] x86/virt/tdx: Implement the SEAMCALL base
 function
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <1c3f555934c73301a9cbf10232500f3d15efe3cc.1649219184.git.kai.huang@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <1c3f555934c73301a9cbf10232500f3d15efe3cc.1649219184.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/5/22 9:49 PM, Kai Huang wrote:
> SEAMCALL leaf functions use an ABI different from the x86-64 system-v
> ABI.  Instead, they share the same ABI with the TDCALL leaf functions.

TDCALL is a new term for this patch set. Maybe add some detail about
it in ()?.

> %rax is used to carry both the SEAMCALL leaf function number (input) and
> the completion status code (output).  Additional GPRs (%rcx, %rdx,
> %r8->%r11) may be further used as both input and output operands in
> individual leaf functions.



-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
