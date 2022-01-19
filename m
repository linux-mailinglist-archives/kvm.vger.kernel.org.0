Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A404932B1
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 03:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350849AbiASCHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 21:07:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:62800 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350649AbiASCHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 21:07:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642558033; x=1674094033;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F0+pkOx4V5wfN8kLp3xR9+q4JYFOKOQE36Te1j+ae+4=;
  b=B3y+8g10jdW+mnheOOxpe+aOg9OyC5DUhKmcBJ9Q/0brE12Oonv2/1eK
   UUD5efm8G9vxvKDt/yfyNofzpgFeh1TOImH2Pp1/Gknyu1idYW3nzRm5a
   k6FxQaz5l/+gEkVA7YyOhnz9HP1sglt/ofbUsj8O7IsABWQWT2k3OUmzY
   VNVbW34Ki8Ohjn25DCN+gSI1n04Cx8BGRjSsUq7U16I6MUWcb6s3LA/6H
   woJFJ+fOL/Ce0+rJ4wWFst+tWS2qtmJRxOeiqFt2pxtJ3NtUFM+WQMpLq
   cBOvkaoN7qdA6UcSOJ2lM3WmsBS3VjGmrc0PpBxgb9PXOSmu9phGP92q/
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="242524685"
X-IronPort-AV: E=Sophos;i="5.88,298,1635231600"; 
   d="scan'208";a="242524685"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 18:07:12 -0800
X-IronPort-AV: E=Sophos;i="5.88,298,1635231600"; 
   d="scan'208";a="532050616"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.145.56])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 18 Jan 2022 18:07:11 -0800
Date:   Wed, 19 Jan 2022 09:51:53 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, yang.zhong@intel.com
Subject: Re: [PATCH 1/2] kvm: selftests: Sync KVM_CAP_XSAVE2 from linux header
Message-ID: <20220119015153.GA24086@yangzhon-Virtual>
References: <20220118140144.58855-1-yang.zhong@intel.com>
 <20220118140144.58855-2-yang.zhong@intel.com>
 <Yebw2wQu4OuS0CB2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yebw2wQu4OuS0CB2@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18, 2022 at 04:54:51PM +0000, Sean Christopherson wrote:
> On Tue, Jan 18, 2022, Yang Zhong wrote:
> > Need sync KVM_CAP_XSAVE2 from linux header to here.
> > 
> > Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> > ---
> >  tools/include/uapi/linux/kvm.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> > index f066637ee206..63b96839186c 100644
> > --- a/tools/include/uapi/linux/kvm.h
> > +++ b/tools/include/uapi/linux/kvm.h
> > @@ -1131,7 +1131,7 @@ struct kvm_ppc_resize_hpt {
> >  #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
> >  #define KVM_CAP_ARM_MTE 205
> >  #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
> > -#define KVM_CAP_XSAVE2 207
> > +#define KVM_CAP_XSAVE2 208
> 
> Any reason not to opportunistically sync the entire file?  E.g. this diff looks
> rather confusing without pulling in KVM_CAP_VM_GPA_BITS (that consumes "207").
> 

  Thanks Sean, I checked this file history, Arnaldo Carvalho de Melo <acme@redhat.com>,
  who always sync this header with kernel source, so maybe much better if he can do this.

  Please ignore this patch and help review patch 2, thanks!

  Yang
   


> >  
> >  #ifdef KVM_CAP_IRQ_ROUTING
> >  
