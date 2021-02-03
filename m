Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044DD30D425
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 08:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhBCHmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 02:42:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30638 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232038AbhBCHmy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 02:42:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612338086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mm82HtFnkfN5pJPYBtOuBSRV2yl0XYcGlKRBGfSa+v8=;
        b=afS12g+HXnFkUFfhWLVHutIeR+XKiDrd/oY4OPpBXyvQPTZke0cXnaAd5pXwot3RonVJyC
        lfkmyhcB/h9py2iDcVBRQOxfdHk11yjR7gIfYG2AsUbMp8YTZ5Z6mBxTczHUIhPzzTHWTc
        x5MQ+JE3zTINu7r6D6lKLBNedDpFihU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-4VxEbcRsMA2wZugQqjKTZA-1; Wed, 03 Feb 2021 02:41:24 -0500
X-MC-Unique: 4VxEbcRsMA2wZugQqjKTZA-1
Received: by mail-ej1-f69.google.com with SMTP id ox17so11484611ejb.2
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 23:41:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mm82HtFnkfN5pJPYBtOuBSRV2yl0XYcGlKRBGfSa+v8=;
        b=AaTJTBmmIokuhMvtq99/Up+14rYnojJ8ARGb7zRNzWmP5jhlKf9Xt2kU9dxGePOu2D
         T0BRohAjimo2Kqt1HQrahOzwXB4pdAE59I1X9sdvyIDaTU420OaeOEWJ5zYRS/M9sSpq
         adWGIk20gt70GD+nsPu/h5hFCM7bNCSQ10rrSxzlmuinYKbH0lcf4uiwH2Dk16r7vPMM
         Wbo6zc8WiM/aNnt/fff77BElgyOoYWR4dlHlfjl4LNRe6cHc7e4vH7NENoEvJKliEQl5
         hpO+I5jsaF+gCVMw9KnyEXO2OGSHrkxjUIy9JfCahUuAhK1OBWFNM+YpXG4AKdRN46F2
         K97w==
X-Gm-Message-State: AOAM532TpXnpcwAWOhHkR8aotWo7hDMDJbdpvrdPdYILiud+olZnh/zg
        vdMuMToiHIvWdORV3wer05O8ZjK2GnUPWXdS+fW53Ree06AOs6v5GDyi8I8CaYJkEE0crgfJyLS
        WQkZUNb/QrV4p
X-Received: by 2002:a50:e04d:: with SMTP id g13mr1723180edl.358.1612338083670;
        Tue, 02 Feb 2021 23:41:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyvo1Vx+Ou9HgpGtb2mGV7nSgfUjrRZrY0sWS01X/n3iaN4SzdGRIw5H7w7fd5fYs5Bv8Gf+A==
X-Received: by 2002:a50:e04d:: with SMTP id g13mr1723165edl.358.1612338083489;
        Tue, 02 Feb 2021 23:41:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p16sm453884edw.44.2021.02.02.23.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 23:41:22 -0800 (PST)
Subject: Re: [kvm:nested-svm 79/95] arch/x86/kvm/vmx/vmx.c:5649:12: error:
 conflicting types for 'handle_bus_lock'
To:     kernel test robot <lkp@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Tony Luck <tony.luck@intel.com>
References: <202102030637.AGxHMTBj-lkp@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1f83283c-1eb2-d97b-41b5-df052927f7f0@redhat.com>
Date:   Wed, 3 Feb 2021 08:41:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <202102030637.AGxHMTBj-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/21 23:06, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git nested-svm
> head:   47fb7f6e83e4517e5b43345c1ee0c738263d933b
> commit: a82a8fa7038222fd4ca556810c278871aa985a6e [79/95] x86/bus_lock: Handle warn and fatal in #DB for bus lock
> config: x86_64-allyesconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> reproduce (this is a W=1 build):
>          # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=a82a8fa7038222fd4ca556810c278871aa985a6e
>          git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
>          git fetch --no-tags kvm nested-svm
>          git checkout a82a8fa7038222fd4ca556810c278871aa985a6e
>          # save the attached .config to linux build tree
>          make W=1 ARCH=x86_64
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>>> arch/x86/kvm/vmx/vmx.c:5649:12: error: conflicting types for 'handle_bus_lock'
>      5649 | static int handle_bus_lock(struct kvm_vcpu *vcpu)
>           |            ^~~~~~~~~~~~~~~
>     In file included from arch/x86/kvm/vmx/vmx.c:34:
>     arch/x86/include/asm/cpu.h:48:13: note: previous declaration of 'handle_bus_lock' was here
>        48 | extern bool handle_bus_lock(struct pt_regs *regs);
>           |             ^~~~~~~~~~~~~~~
> 
> 
> vim +/handle_bus_lock +5649 arch/x86/kvm/vmx/vmx.c
> 
> e7953d7fab47a7 arch/x86/kvm/vmx.c     Abel Gordon  2013-04-18  5648
> 1b054f0054cf1b arch/x86/kvm/vmx/vmx.c Chenyi Qiang 2020-11-06 @5649  static int handle_bus_lock(struct kvm_vcpu *vcpu)
> 1b054f0054cf1b arch/x86/kvm/vmx/vmx.c Chenyi Qiang 2020-11-06  5650  {
> 1b054f0054cf1b arch/x86/kvm/vmx/vmx.c Chenyi Qiang 2020-11-06  5651  	vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
> 1b054f0054cf1b arch/x86/kvm/vmx/vmx.c Chenyi Qiang 2020-11-06  5652  	vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
> 1b054f0054cf1b arch/x86/kvm/vmx/vmx.c Chenyi Qiang 2020-11-06  5653  	return 0;
> 1b054f0054cf1b arch/x86/kvm/vmx/vmx.c Chenyi Qiang 2020-11-06  5654  }
> 1b054f0054cf1b arch/x86/kvm/vmx/vmx.c Chenyi Qiang 2020-11-06  5655
> 
> :::::: The code at line 5649 was first introduced by commit
> :::::: 1b054f0054cf1bcd4979073e285c8ab53c331480 KVM: VMX: Enable bus lock VM exit
> 
> :::::: TO: Chenyi Qiang <chenyi.qiang@intel.com>
> :::::: CC: Paolo Bonzini <pbonzini@redhat.com>
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

Fixed.

Paolo

