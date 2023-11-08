Return-Path: <kvm+bounces-1273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF6B27E5F0D
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 21:20:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C2751C20BA6
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E5E137178;
	Wed,  8 Nov 2023 20:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M5R77RaM"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0173716F
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 20:19:59 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F7D212D
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 12:19:58 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da04776a869so144885276.0
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 12:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699474798; x=1700079598; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+MAkWUu4DkxSH5sUyb3Xf/vPz8zbhDyNKMdscALbnD8=;
        b=M5R77RaMAMr56n4FGbC4LVm8L1RdIOR73eDD9Nc6cAf1vRd45fN32DYWLaBbTlBe/4
         Y6p70SLq7em5swD2/FB6hSbUHgcDDHW82HHSVdSNNkqFmN9r1DRmApx+w6UgwpfdY2HL
         inEKNV6DBgJuhg0zpZ1HA0Uq6v8PsNVpsXc1Uk3n8opRZ7fPrfobnIwSJY93zpx1Zpk8
         Bw9uo040q4iVM4TvMLxoBdjn9IA0EXKlj1QeNuo1fmcMZ/8K+sRw3MhcDo+bPBBZ7GFD
         6Ppq4vSP4wOoZYf2OesOBNW1S6l//Rxnrm+kfGAqwSrPeCDQDoJPI2usjplU6LO5D0pz
         ftMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699474798; x=1700079598;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+MAkWUu4DkxSH5sUyb3Xf/vPz8zbhDyNKMdscALbnD8=;
        b=YoHHJ1Vlg2bYb1r56T7U6GFAmjkUT1sdJm3ljMse1eZzeTC58egoE5TZvln4ErFL0A
         NEloAQHQK6CxZjs01msyGagtB6jby7kg/LjXXN7ai/hshPTSj86qW0CUlFwjaUJ7hAIB
         IlD7XopBlWG2rLkUBmfZwuq/aCq+2n20GzE+AYm9brr1EEyLP3Mq4GXNmiYmgqfQkRHd
         Pd/DxJqYlg0phCkKWXl+DG0uhAybfVbvKUsI9NQS7mtlhkvi/mFEd7kGdtdDyHPE/kQn
         lekS+YIUvLeYnnxavL5yLNUdVNgt2z5f0HvTwA8HfQpjdNkl8HrkKDH2/QZZ0AIR9MVc
         G1Jg==
X-Gm-Message-State: AOJu0Yzy/BQFbM3pSuJp6TSZ/wvz2R7pXnfAzNfQgDONeQnDTU9FzF8I
	GRcCBt9mpprH+/BBVwmy2ZF7E6XNK08=
X-Google-Smtp-Source: AGHT+IFNi4wgSYIGZFNuhbyheKWePNoC3fS8qVwIG8FGIrV7Od6wpxbQ/4tz+xriKX2AsSmGDSLi9zJ5OnY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:102:b0:da3:723b:b2a4 with SMTP id
 o2-20020a056902010200b00da3723bb2a4mr57302ybh.7.1699474797990; Wed, 08 Nov
 2023 12:19:57 -0800 (PST)
Date: Wed, 8 Nov 2023 12:19:56 -0800
In-Reply-To: <202311090100.Zt0adRi9-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <202311090100.Zt0adRi9-lkp@intel.com>
Message-ID: <ZUvtbInra7-Nypgq@google.com>
Subject: Re: [kvm:guestmemfd 59/59] arch/s390/kvm/../../../virt/kvm/kvm_main.c:5517:14:
 error: 'KVM_TRACE_ENABLE' undeclared; did you mean 'KVM_PV_ENABLE'?
From: Sean Christopherson <seanjc@google.com>
To: kernel test robot <lkp@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org, 
	Robert Hu <robert.hu@intel.com>, Farrah Chen <farrah.chen@intel.com>, 
	Danmei Wei <danmei.wei@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 09, 2023, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git guestmemfd
> head:   cd689ddd5c93ea177b28029d57c13e18b160875b
> commit: cd689ddd5c93ea177b28029d57c13e18b160875b [59/59] KVM: remove deprecated UAPIs

Paolo, I assume you force pushed to guestmemfd at some point at that this is no
longer an issue?  I can't find the above object, and given the shortlog I'm guessing
it was a WIP thing unrelated to guest_memfd.

> config: s390-defconfig (https://download.01.org/0day-ci/archive/20231109/202311090100.Zt0adRi9-lkp@intel.com/config)
> compiler: s390-linux-gcc (GCC) 13.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231109/202311090100.Zt0adRi9-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202311090100.Zt0adRi9-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    arch/s390/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_dev_ioctl':
> >> arch/s390/kvm/../../../virt/kvm/kvm_main.c:5517:14: error: 'KVM_TRACE_ENABLE' undeclared (first use in this function); did you mean 'KVM_PV_ENABLE'?
>     5517 |         case KVM_TRACE_ENABLE:
>          |              ^~~~~~~~~~~~~~~~
>          |              KVM_PV_ENABLE
>    arch/s390/kvm/../../../virt/kvm/kvm_main.c:5517:14: note: each undeclared identifier is reported only once for each function it appears in
> >> arch/s390/kvm/../../../virt/kvm/kvm_main.c:5518:14: error: 'KVM_TRACE_PAUSE' undeclared (first use in this function)
>     5518 |         case KVM_TRACE_PAUSE:
>          |              ^~~~~~~~~~~~~~~
> >> arch/s390/kvm/../../../virt/kvm/kvm_main.c:5519:14: error: 'KVM_TRACE_DISABLE' undeclared (first use in this function); did you mean 'KVM_PV_DISABLE'?
>     5519 |         case KVM_TRACE_DISABLE:
>          |              ^~~~~~~~~~~~~~~~~
>          |              KVM_PV_DISABLE
> 
> 
> vim +5517 arch/s390/kvm/../../../virt/kvm/kvm_main.c

