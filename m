Return-Path: <kvm+bounces-3135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C10B800EDE
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 16:56:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 99CE0B2133A
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 15:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A38B74BA82;
	Fri,  1 Dec 2023 15:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N+fHmNuM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18531A6
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 07:56:02 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5c1b986082dso643240a12.0
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 07:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701446162; x=1702050962; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T+9aLJpGyu0Q/y7mwBTnwWcmuz7X2zXjBIdqmSWvzkk=;
        b=N+fHmNuMBdBuSJAJex97iOFcMfroAQEN/7g7vNKNXNAV0S6RUHvPifwMoN76hVOmJC
         V149BgvgugDmsGkVBQnvxBE1tSVx0MbVN925TdBNs7xG2AtbXFY0SjwVL5+cY5CExXgn
         l8iiBKXoU10Bc+e7wWl2ONL9liXD44bIU3rfkqhSWKpAzjo27dtjvYVELt44JD1VfkWP
         Q08WGTnTn8SLD62ZhO/MoBFpq/Kr3Ez/gOH0oKtimJV8J9mLTKDSmPWQJjt/EXdJnMEt
         6rnxh6QEb46atpv1qmq0+cLdNwMVvVjJc6ucVIy5sDL7m1yv9Yp2ox8gqjL9wi5r4tAT
         6txQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701446162; x=1702050962;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T+9aLJpGyu0Q/y7mwBTnwWcmuz7X2zXjBIdqmSWvzkk=;
        b=jiPsez2MphwmQpR1eNRQwYB4rQb2QPDCwKHZS9pt5BIADtT3vxSZNLpNnNDd/2Bk7s
         KqCInLeWUXbX+RGJUvkp5oCvHzJZ3C+0tgElKy4SqTFhAsSnAdj2hUK2yFxg4z0EyNfg
         yHlvFY3EhJ64Az9omtlNJMdKSWuzDotxxuncj7uLeHOR9yxst9q6UV7Jk1Y1WKnyiVxG
         ekmIKR/w/+zjDJnaKdxSEclUWvIJkoDN2XVpW2PDMyRYUCn9iRB+NBpg/ZByIBhjLGm0
         QxnOjfFB5M1UfFTTlCkcFG+ZJW0/DH0k7A5LpQHMDOxWasFbcOje+HBq7FEtiws9wLaK
         Ig8Q==
X-Gm-Message-State: AOJu0YzSBBBvSZoItmvwgIzMWL0SAxczmeuQJ5iQmYJc8k4WVTAtO6xQ
	2ngmmP+MEFh4qTVquzSydqlTZEBPzkg=
X-Google-Smtp-Source: AGHT+IEIZp/UjGQmIqcjxLcrjtAVgVHJtCowAaXJ8Z6oo7dg35tnLSRyZWGu2wbxgV7cxavSU+m4ulAH0aE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5c0f:0:b0:5c6:504:7e22 with SMTP id
 q15-20020a635c0f000000b005c605047e22mr1192330pgb.5.1701446162412; Fri, 01 Dec
 2023 07:56:02 -0800 (PST)
Date: Fri, 1 Dec 2023 07:56:01 -0800
In-Reply-To: <ZWl466DIxhF7uRnP@yujie-X299>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <202311302231.sinLrAig-lkp@intel.com> <87v89jmc3q.fsf@redhat.com>
 <ZWjLN3As3vz5lXcK@google.com> <ZWl466DIxhF7uRnP@yujie-X299>
Message-ID: <ZWoCEUvk3Nlmlb9v@google.com>
Subject: Re: arch/x86/kvm/vmx/hyperv.h:79:30: sparse: sparse: cast truncates
 bits from constant value (1b009b becomes 9b)
From: Sean Christopherson <seanjc@google.com>
To: Yujie Liu <yujie.liu@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 01, 2023, Yujie Liu wrote:
> On Thu, Nov 30, 2023 at 09:49:43AM -0800, Sean Christopherson wrote:
> > On Thu, Nov 30, 2023, Vitaly Kuznetsov wrote:
> > > kernel test robot <lkp@intel.com> writes:
> > > 
> > > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > > > head:   3b47bc037bd44f142ac09848e8d3ecccc726be99
> > > > commit: a789aeba419647c44d7e7320de20fea037c211d0 KVM: VMX: Rename "vmx/evmcs.{ch}" to "vmx/hyperv.{ch}"
> > > > date:   1 year ago
> > > > config: x86_64-randconfig-123-20231130 (https://download.01.org/0day-ci/archive/20231130/202311302231.sinLrAig-lkp@intel.com/config)
> > > > compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
> > > > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231130/202311302231.sinLrAig-lkp@intel.com/reproduce)
> > > >
> > > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > > the same patch/commit), kindly add following tags
> > > > | Reported-by: kernel test robot <lkp@intel.com>
> > > > | Closes: https://lore.kernel.org/oe-kbuild-all/202311302231.sinLrAig-lkp@intel.com/
> > > >
> > > > sparse warnings: (new ones prefixed by >>)
> > > >    arch/x86/kvm/vmx/hyperv.h:79:30: sparse: sparse: cast truncates bits from constant value (a000a becomes a)
> > > 
> > > This is what ROL16() macro does but the thing is: we actually want to
> > > truncate bits by doing an explicit (u16) cast. We can probably replace
> > > this with '& 0xffff':
> > > 
> > > #define ROL16(val, n) ((((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))) & 0xffff)
> > > 
> > > but honestly I don't see much point...
> > 
> > Yeah, just ignore 'em, we get the exact same sparse complaints in vmcs12.c and
> > have had great success ignoring those too :-)
> 
> Thanks for the information. We've disabled this warning in the bot to
> avoid sending reports against other files with similar code.

I would probably recommend keeping the sparse warning enabled, IIRC it does find
legitimate bugs from time to time.

Or are you able to disable just the ROL16() warning?  If so, super cool!

