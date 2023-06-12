Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C31872BB6B
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 10:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbjFLI7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 04:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbjFLI6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 04:58:41 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5F419B4;
        Mon, 12 Jun 2023 01:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686560159; x=1718096159;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=22flWAwLQKUVCiLVo3wLZM/UdamCpYNSAYMlKHqR5Fo=;
  b=lkW+DjhM8mIOT6CeV/W1FnzCDcXfU0VO5mudjHldJ0eJvPNfyIz7VXYu
   cOV9c0oq+9SUjlT75xmVIk3zZEbfjUWKT14fCXbCUP9F6SU+bBw47KuJ3
   +UXQ4VxMecwWjPm4PZkItG9JlVtYspIpCSZsDNxhBQDOQhqj03ij3MMW8
   sdKRHVZsTjzY0EXlxKQMYE1xLyQFta0yv7+ooLt5AOUki5hmRn/IerY9B
   yeestsGOPLId5lOWrGpfvx9FACNakHdTdm53vpA419aoO6L5F72k82AvP
   D2Fs/5fosFYfzaZzwGDt9tfCEpI8edh6bK3dngUG5JjY6WU2XvgBM5/XC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="361326965"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="361326965"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 00:07:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="688510808"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="688510808"
Received: from smizr3x-mobl3.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.43.127])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 00:07:42 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id EB5A510CC1C; Mon, 12 Jun 2023 10:07:39 +0300 (+03)
Date:   Mon, 12 Jun 2023 10:07:39 +0300
From:   "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
To:     Michael Roth <michael.roth@amd.com>, bp@alien8.de
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, kai.huang@intel.com, isaku.yamahata@intel.com
Subject: Re: [PATCH RFC v9 05/51] x86/coco: move CONFIG_HAS_CC_PLATFORM check
 down into coco/Makefile
Message-ID: <20230612070739.w4myumbiomlpynuj@box.shutemov.name>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-6-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612042559.375660-6-michael.roth@amd.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 11, 2023 at 11:25:13PM -0500, Michael Roth wrote:
> Currently CONFIG_HAS_CC_PLATFORM is a prereq for building anything in
> arch/x86/coco, but that is generally only applicable for guest support.
> 
> For SEV-SNP, helpers related purely to host support will also live in
> arch/x86/coco. To allow for CoCo-related host support code in
> arch/x86/coco, move that check down into the Makefile and check for it
> specifically when needed.

Hm. TDX host support uses arch/x86/virt/vmx/tdx/. I think we need to be
consistent here.

IIRC, Borislav proposed the scheme that TDX uses.


-- 
  Kiryl Shutsemau / Kirill A. Shutemov
