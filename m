Return-Path: <kvm+bounces-2977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 441217FF778
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 17:57:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F27B2281842
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 16:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 272E055C34;
	Thu, 30 Nov 2023 16:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MIWhQZhE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3890F10E2
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 08:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701363430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wI81TszQ+HavXeXDYPqPnC9zC5eJQkah0vJVVXbWL9Q=;
	b=MIWhQZhEzsjmqfukyT3XbU6bQSPjsD8vHba8ilkAb3pb3UB3+sRJ4rcNcCLHychCQfMa7m
	W1PPnGxCp7CChVjqsrg1oNAsL/3hfjbn4Mkvh3SuToKNPVOep78Rr3xP6gETU7r0df/izJ
	jDoSqznX/cC6tmdVAcKbtB6GAPTqgeA=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-Ke33ZFctMV-qBBTRsDTXaA-1; Thu, 30 Nov 2023 11:57:09 -0500
X-MC-Unique: Ke33ZFctMV-qBBTRsDTXaA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-50bb8fa7c45so1392024e87.3
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 08:57:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701363427; x=1701968227;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wI81TszQ+HavXeXDYPqPnC9zC5eJQkah0vJVVXbWL9Q=;
        b=GqSEtsA7WXrPSfWuJnMNsNXnxGZMd6HhMyvUL6nqk6SPsiBTgeznSmkcH8TWxrgWFw
         uB6GM83+hevC+4FWJMbl6Vq4as4PkS1nh91FXHtDXHQX3aww05AdiBIoMnQaIb1OjoJ4
         jUZ/LQeIsqJW4xsJqj75n/QyTO1d4X1jlO9BJLZzXSamxKT7kxDnNHSg2j2QMZ7JkKGQ
         RhnRENe1avstw2X7ENZ7LveMx1E4MjwAgxvHW4H+dlCKofNwerSvfWJt6UKeNraE65iN
         sUv6/949MiJRFoDcrq2kDeEpKp8idTsW1XDVv3Tv2tzbfUFs3t5ps4ghXd+YLkhrf7JA
         qNRg==
X-Gm-Message-State: AOJu0YzlEB9ALxAV1+2izkGRfIAANGcpFM8d32ub+ngAiJDTWbGmOAy5
	Sh6SVwiiasqHcKmSZwwem2nuFXcBZQp626EhfLX4ExOZmyydt6AHRh0U8uFdkR1gg3QfYUn75Wg
	VGo8MS81xGp8aPmn/Ew0gU5K6klS1xSH6Gs6fIlWpt5M8JaCdr2Ax8qZG1wwPTZYymC9WiuMo
X-Received: by 2002:a05:651c:22c:b0:2c9:b8ad:648a with SMTP id z12-20020a05651c022c00b002c9b8ad648amr6427ljn.6.1701362565496;
        Thu, 30 Nov 2023 08:42:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFt5VLzdRHMWwfoz78n79Jjv1J/ksnTUOcY2uHEfV5/oooNR24dio4f81xNIhQQUnzfLiBQEg==
X-Received: by 2002:a2e:9784:0:b0:2c9:c192:43a9 with SMTP id y4-20020a2e9784000000b002c9c19243a9mr3511lji.28.1701362235390;
        Thu, 30 Nov 2023 08:37:15 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id j11-20020a05600c190b00b0040b4c26d2dasm2536292wmq.32.2023.11.30.08.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 08:37:14 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org, Paolo
 Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>,
 kvm@vger.kernel.org
Subject: Re: arch/x86/kvm/vmx/hyperv.h:79:30: sparse: sparse: cast truncates
 bits from constant value (1b009b becomes 9b)
In-Reply-To: <202311302231.sinLrAig-lkp@intel.com>
References: <202311302231.sinLrAig-lkp@intel.com>
Date: Thu, 30 Nov 2023 17:37:13 +0100
Message-ID: <87v89jmc3q.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

kernel test robot <lkp@intel.com> writes:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   3b47bc037bd44f142ac09848e8d3ecccc726be99
> commit: a789aeba419647c44d7e7320de20fea037c211d0 KVM: VMX: Rename "vmx/evmcs.{ch}" to "vmx/hyperv.{ch}"
> date:   1 year ago
> config: x86_64-randconfig-123-20231130 (https://download.01.org/0day-ci/archive/20231130/202311302231.sinLrAig-lkp@intel.com/config)
> compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231130/202311302231.sinLrAig-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202311302231.sinLrAig-lkp@intel.com/
>
> sparse warnings: (new ones prefixed by >>)
>    arch/x86/kvm/vmx/hyperv.h:79:30: sparse: sparse: cast truncates bits from constant value (a000a becomes a)

This is what ROL16() macro does but the thing is: we actually want to
truncate bits by doing an explicit (u16) cast. We can probably replace
this with '& 0xffff':

#define ROL16(val, n) ((((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))) & 0xffff)

but honestly I don't see much point...

-- 
Vitaly


