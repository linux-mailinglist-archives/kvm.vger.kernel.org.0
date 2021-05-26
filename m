Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D715391A86
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 16:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbhEZOov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 10:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234951AbhEZOov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 10:44:51 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06392C061756
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 07:43:19 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q15so1112521pgg.12
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 07:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=aLXEknxHX1fry+v1BRHRWIkWG1uersOnv4l1GCaoi1o=;
        b=bhTR+vIdT1Ck42Xd2MP3S6CdcgVG1iDOt5UULUaGYIDZT5p3c9ukWW3Lxt/mkA580Z
         B2YIr2mUG/q7T2Zd00Qnm9/dmTgu1vJEd4Lwmx/L766uhktR1bBlnj7MB9TouiGeyhYg
         NIg2YumYUriWK54ArHBhI7ng2fg6EPOlYusORqV/6BdHWdD2wVFfe2hXyhHM5n09XLqb
         z2sHBgR/ThbRJKpBKEgjTpwOHc57ReNH+926Xa/rgRYC1dPalwITkuASw8KkSXzeaFlq
         vvLcBOyHBg5JnNFnaO+GGDwGVkG22QFPBWfoofcARbmqT8tKfQoZ2WL/BrnziN3CdKmG
         AfRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=aLXEknxHX1fry+v1BRHRWIkWG1uersOnv4l1GCaoi1o=;
        b=lVF48lQN98Bc+qaXXzSknbjerddeejo9Em9qLEJeDhG/IEBpJ//fgUF5naYjgvD3Fb
         fYWFCkF+sumv5cm94Wg8qdT2x+oQrV8npoOaQf5ibIyHMTG9rORY/6fqllX/IlCXHg+3
         I+xkpDLR0tK4dDzESKdL/UkFJbUn9z7bkFmLzVP8tzzq3Vby4yo4tu4+lBlszyDa8g1f
         6SG5kCpULIr8JyYcyK1P7nuvSuJAz2U0T1VxcZa4H66jn3WNJtTx9649joWSsjmCCEGp
         O36iFY1X4ss6LVWcZSUnP3sfEHXiPcyC5JvM8c6zNe2yexwFeEqDeGg6LoG4+Ifu5JHC
         IeoQ==
X-Gm-Message-State: AOAM530IOGtJNy0fgk6A8r4Ks+SVc/Dsolbct9SQuWuS9g+4stlPmp08
        eemFJn1C5RrRmm87cWuBn9BxEA==
X-Google-Smtp-Source: ABdhPJwKBuDUdATA68/3+Ml4QROh2TxX9FfUim4U2V5A3IxPY2sIUd64iPwmjeoqlJ6f2Ohl3vX/qw==
X-Received: by 2002:a65:5305:: with SMTP id m5mr25340986pgq.155.1622040198289;
        Wed, 26 May 2021 07:43:18 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id mt24sm14871624pjb.18.2021.05.26.07.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 07:43:17 -0700 (PDT)
Date:   Wed, 26 May 2021 14:43:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Liu, Jing2" <jing2.liu@linux.intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
Subject: Re: [PATCH RFC 4/7] kvm: x86: Add new ioctls for XSAVE extension
Message-ID: <YK5egUs+Wl2d+wWz@google.com>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-5-jing2.liu@linux.intel.com>
 <YKwfsIT5DuE+L+4M@google.com>
 <920df897-56d8-1f81-7ce2-0050fb744bd7@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <920df897-56d8-1f81-7ce2-0050fb744bd7@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021, Liu, Jing2 wrote:
> 
> On 5/25/2021 5:50 AM, Sean Christopherson wrote:
> > On Sun, Feb 07, 2021, Jing Liu wrote:
> > > The static xstate buffer kvm_xsave contains the extended register
> > > states, but it is not enough for dynamic features with large state.
> > > 
> > > Introduce a new capability called KVM_CAP_X86_XSAVE_EXTENSION to
> > > detect if hardware has XSAVE extension (XFD). Meanwhile, add two
> > > new ioctl interfaces to get/set the whole xstate using struct
> > > kvm_xsave_extension buffer containing both static and dynamic
> > > xfeatures. Reuse fill_xsave and load_xsave for both cases.
> > > 
> > > Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
> > > ---
> > >   arch/x86/include/uapi/asm/kvm.h |  5 +++
> > >   arch/x86/kvm/x86.c              | 70 +++++++++++++++++++++++++--------
> > >   include/uapi/linux/kvm.h        |  8 ++++
> > >   3 files changed, 66 insertions(+), 17 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > > index 89e5f3d1bba8..bf785e89a728 100644
> > > --- a/arch/x86/include/uapi/asm/kvm.h
> > > +++ b/arch/x86/include/uapi/asm/kvm.h
> > > @@ -362,6 +362,11 @@ struct kvm_xsave {
> > >   	__u32 region[1024];

Hold up a sec.  How big is the AMX data?  The existing size is 4096 bytes, not
1024 bytes.  IIRC, AMX is >4k, so we still need a new ioctl(), but we should be
careful to mentally adjust for the __u32 when mentioning the sizes.

> > >   };
> > > +/* for KVM_CAP_XSAVE_EXTENSION */
> > > +struct kvm_xsave_extension {
> > > +	__u32 region[3072];
> > Fool me once, shame on you (Intel).  Fool me twice, shame on me (KVM).
> > 
> > As amusing as kvm_xsave_really_extended would be, the required size should be
> > discoverable, not hardcoded.
> Thanks for reviewing the patch.  When looking at current kvm_xsave structure,
> I felt confusing about the static hardcoding of 1024 bytes, but failed to
> find clue for its final decision in 2010[1].

Simplicitly and lack of foresight :-)

> So we'd prefer to changing the way right? Please correct me if I misunderstood.

Sadly, we can't fix the existing ioctl() without breaking userspace.  But for
the new ioctl(), yes, its size should not be hardcoded.

> > Nothing prevents a hardware vendor from inventing a newfangled feature that
> > requires yet more space.  As an alternative to adding a dedicated
> > capability, can we leverage GET_SUPPORTED_CPUID, leaf CPUID.0xD,
> Yes, this is a good way to avoid a dedicated capability. Thanks for the
> suggestion.  Use 0xD.1.EBX for size of enabled xcr0|xss if supposing
> kvm_xsave cares both.
> > to enumerate the minimum required size and state
> For the state, an extreme case is using an old qemu as follows, but a
> new kvm with more future_featureZ supported. If hardware vendor arranges
> one by one, it's OK to use static state like X86XSaveArea(2) and
> get/set between userspace and kvm because it's non-compacted. If not,
> the state will not correct.
> So far it is OK, so I'm wondering if this would be an issue for now?

Oh, you're saying that, because kvm_xsave is non-compacted, future features may
overflow kvm_xsave simply because the architectural offset overflows 4096 bytes.

That should be a non-issue for old KVM/kernels, since the new features shouldn't
be enabled.  For new KVM, I think the right approach is to reject KVM_GET_XSAVE
and KVM_SET_XSAVE if the required size is greater than sizeof(struct kvm_xsave).
I.e. force userspace to either hide the features from the guest, or use
KVM_{G,S}ET_XSAVE2.

> X86XSaveArea2 {
>     ...
>     XSaveAVX
>     ...
>     AMX_XTILE;
>     future_featureX;
>     future_featureY;
> }
> 
> >   that the new ioctl() is available if the min size is greater than 1024?
> > Or is that unnecessarily convoluted...
> To enable a dynamic size kvm_xsave2(Thanks Jim's name suggestion), if things
> as follows are what we might want.
> /* for xstate large than 1024 */
> struct kvm_xsave2 {
>     int size; // size of the whole xstate
>     void *ptr; // xstate pointer
> }
> #define KVM_GET_XSAVE2   _IOW(KVMIO,  0xa4, struct kvm_xsave2)
> 
> Take @size together, so KVM need not fetch 0xd.1.ebx each time or a dedicated
> variable.

Yes, userspace needs to provide the size so that KVM doesn't unintentionally
overflow the buffer provided by userspace.  We might also want to hedge by adding
a flags?  Can't think of a use for it at the moment, though.

  struct kvm_xsave2 {
  	__u32 flags;
	__u32 size;
	__u8  state[0];
  };
