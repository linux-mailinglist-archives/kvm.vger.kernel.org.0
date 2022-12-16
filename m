Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FA364E5BE
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 02:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiLPBps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 20:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiLPBpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 20:45:44 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CA52646;
        Thu, 15 Dec 2022 17:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671155143; x=1702691143;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XidVk7e1oIaU8sSsWlZDRhszxAli6ATjq+ERwzA5CMs=;
  b=bKk+ofsbvTnCUQ5ZQxItJXY4P1FBHsAlYjjAPTBIEOt/6epL0LZCiDi0
   x6zxl8oDm7VUnDsr3Ptgsy3eggpoCBUhUkTgocxUmoGickF1gpVAaHL6K
   FV0hyetx8ro8sW3wtWBVldUm8EnH/LTudkPuL5EugzVebB+mcL0qvX+jF
   eHncgIej90czj5YSK0pvqOoK9n4XJLoZluFfWe+ePXC01Yq87tKLp0R7E
   lvBR9dLwN0m+f/bxEf0RCKvAfsz75By8Cfk6c1lYOPs4by9coU9EuFC4J
   uDo0MZz1GLVD8uQyb0lnPX1cKNdrh/E16wNBTbUdvV6dojABbi70i/QuV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="316497957"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="316497957"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 17:45:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="791887103"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="791887103"
Received: from xintongc-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.168.175])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 17:45:40 -0800
Date:   Fri, 16 Dec 2022 09:45:38 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Remove outdated comments in
 nested_vmx_setup_ctls_msrs().
Message-ID: <20221216014538.3yx5mnmwz2vaa5cy@linux.intel.com>
References: <20221215100558.1202615-1-yu.c.zhang@linux.intel.com>
 <Y5tmFKPj8ZX2GgUY@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5tmFKPj8ZX2GgUY@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> Eh, just drop the comment.  Pretty obvious this is for secondary execution controls.
Thanks Sean. Well, I agree it is obvious.

This line was kept because there are comments for other groups of
control fields(e.g., exit/entry/pin-based/cpu-based controls etc.)
in nested_vmx_setup_ctls_msrs(). If we do not keep the one for secondary
cpu-based controls, we may just delete other comments as well. But
is that really necessary? 

B.R.
Yu
