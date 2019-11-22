Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2460F10759D
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 17:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfKVQS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 11:18:28 -0500
Received: from mga12.intel.com ([192.55.52.136]:37087 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbfKVQS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 11:18:27 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 08:18:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,230,1571727600"; 
   d="scan'208";a="232707099"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 22 Nov 2019 08:18:25 -0800
Date:   Sat, 23 Nov 2019 00:20:20 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [PATCH v7 5/9] x86: spp: Introduce user-space SPP IOCTLs
Message-ID: <20191122162020.GB10458@local-michael-cet-test>
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-6-weijiang.yang@intel.com>
 <f8cd7d7c-7ffd-3ee4-bf5f-203f9a030fef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8cd7d7c-7ffd-3ee4-bf5f-203f9a030fef@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 11:03:52AM +0100, Paolo Bonzini wrote:
> On 19/11/19 09:49, Yang Weijiang wrote:
> > +	case KVM_INIT_SPP: {
> > +		r = kvm_vm_ioctl_init_spp(kvm);
> > +		break;
> > +	}
> >  	default:
> >  		r = -ENOTTY;
> >  	}
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 9460830de536..700f0825336d 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1257,6 +1257,9 @@ struct kvm_vfio_spapr_tce {
> >  					struct kvm_userspace_memory_region)
> >  #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
> >  #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
> > +#define KVM_SUBPAGES_GET_ACCESS   _IOR(KVMIO,  0x49, __u64)
> > +#define KVM_SUBPAGES_SET_ACCESS   _IOW(KVMIO,  0x4a, __u64)
> > +#define KVM_INIT_SPP              _IOW(KVMIO,  0x4b, __u64)
> 
> You also need to define a capability and return a value for it in
> kvm_vm_ioctl_check_extension.  We could return SUBPAGE_MAX_BITMAP (now
> KVM_SUBPAGE_MAX_PAGES).  And instead of introducing KVM_INIT_SPP, you
> can then use KVM_ENABLE_CAP on the new capability.
>
Yep, will change these stuffs, thanks.

> Paolo
