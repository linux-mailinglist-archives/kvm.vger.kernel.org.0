Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2619749EB2
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 12:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbfFRK4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 06:56:46 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36300 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfFRK4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 06:56:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so5356809wrs.3
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 03:56:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S+FLXzGZAqh5W0IZjW6Hp3mCRBfTPmdw/2Aq/jq1cHk=;
        b=dTbHN58vSYaGhLElFGnhbNWzX8L7lvtSXXyvtomb2Nr1M8ykWpgtDdabu0Klql2Ju7
         /BLLu0VlCuYmwDyt1l9/2XERN8+zEb3HcvmZEBk3YHxY29WvxXRelz9e7BxZ2f2ebicX
         br8crDVxCYmzzt+d/aOcIXluGQwp2W2wU+JwBrC/BskFxLZQHaUUOlwIqcjNf78itjF4
         nl8J2ioB/KxobDECl2LCE5gAKQCGJxqLpXA0qiY+wixyOZOn96/LpdH9Nv6GElwz35R9
         EPRWTuTqPADTiZLY1TokkRy1V2k5Caq1jqIq/g4KlbSlFlvn96EQChlxc6kS+lak4TQl
         fd2w==
X-Gm-Message-State: APjAAAXAAx0yIGswBxPEUf+ynnpcE49ImiVEGSM9qrxDn5ICGWmZA4Ny
        9WtMOGqe8y5Lh3IyjSeCOlcXYQ==
X-Google-Smtp-Source: APXvYqyhe1ZEHDR10pvz+hn8PRR+Y3SLPzu6sqSIhUVIyhm2NQGEAIAVcMuZyrFdEg5oI9mBOAW8Zw==
X-Received: by 2002:adf:f483:: with SMTP id l3mr56001268wro.256.1560855404364;
        Tue, 18 Jun 2019 03:56:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:51c0:d03f:68e:1f6d? ([2001:b07:6468:f312:51c0:d03f:68e:1f6d])
        by smtp.gmail.com with ESMTPSA id d201sm1576800wmd.19.2019.06.18.03.56.43
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 03:56:43 -0700 (PDT)
Subject: Re: [kvm:queue 104/105] vmx.c:undefined reference to `__udivdi3'
To:     kbuild test robot <lkp@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kbuild-all@01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
References: <201906180411.jzFP0qva%lkp@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <467292fe-c1ee-0430-22af-b13cd9cbc559@redhat.com>
Date:   Tue, 18 Jun 2019 12:56:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <201906180411.jzFP0qva%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/06/19 22:20, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> head:   5253b5b578e40c3a10922579b38d1a53112324bd
> commit: ce70de9a05de4510435f554da0cb2fb3321ba0fc [104/105] KVM: VMX: Leave preemption timer running when it's disabled
> config: i386-allyesconfig (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         git checkout ce70de9a05de4510435f554da0cb2fb3321ba0fc
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    ld: arch/x86/kvm/vmx/vmx.o: in function `hardware_setup':
>>> vmx.c:(.init.text+0xe90): undefined reference to `__udivdi3'

Fixed by rewriting

	if ((0xffffffffu / use_timer_freq) < 10)
		enable_preemption_timer = false;

to

	if (use_timer_freq > 0xffffffffu / 10)
		enable_preemption_timer = false;

(finally doing inequations in high school paid off).

Paolo
