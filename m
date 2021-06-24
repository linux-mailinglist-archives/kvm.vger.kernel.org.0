Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2573B2969
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 09:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhFXHie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 03:38:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60459 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231501AbhFXHid (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 03:38:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624520174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J6mYhBd6vMYRzKP6c2NRzoQi5pryF/NzXWzS55AJuHQ=;
        b=GfY3u+rY6pHuj3JErX6ZmR1OiCQtiLcpO9yTqed4zdAsYVpQ007RwQ3lGmch6DKzoP3ohp
        rZwr+2g7Av1O3mP5UhLJYLgGWsz9VTkW75JhiVnf54gqUTx0RKnocfHpJ8UpIxxAba6Ddi
        XISx5VbJCXbLnCS7sIINOUviH6dFSnE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-YDUmXWUkPXyDLNlFAIByhQ-1; Thu, 24 Jun 2021 03:36:13 -0400
X-MC-Unique: YDUmXWUkPXyDLNlFAIByhQ-1
Received: by mail-ed1-f70.google.com with SMTP id j19-20020aa7c4130000b029039497d5cdbeso2853319edq.15
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 00:36:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J6mYhBd6vMYRzKP6c2NRzoQi5pryF/NzXWzS55AJuHQ=;
        b=aQrvxrwPqIiwpbccO0KE1Avlq7jmvQ5w2Q+qgE3xZqytP95HVPat4m7gqAlQHMP4ux
         PufSl9kgRLOSMrraXX6gEJeu7irRAHkhnuhmlZzbF5WEhM6I8GozerQUbRRxuDmEQSGg
         seGN7DHaDro/xfjnbGkWlST01W2c9dKTpSf6auB3y+MaYVzSi4EKp7nxs4ls06O7zbQx
         RNhHApwYvslVfH6UIc9W1mwBT8z+L+wdmKkvwi17P/ji1S4IJs2VID9Euza7CMQFYBn8
         lVmadf3Ytca4KpNTO5k/qevOqww0df8vdJ4yoN6ETc8MJQUj/MJ1Ejcm54rugButnHGF
         LR6g==
X-Gm-Message-State: AOAM531psPimN/TVTumAFzwPX1iZ96s7WmS4snHUHxRdwWEMkzc7JRu1
        mxpboAXduwO8jwZpEkDlzSU9xttz33bIOLCkNW1OjCTmGIPyleEylIb2wGpgzDSOhleW9W9Ld+z
        D18y9uVJ81DJX
X-Received: by 2002:aa7:d7cc:: with SMTP id e12mr5308284eds.388.1624520170724;
        Thu, 24 Jun 2021 00:36:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUgfE2T8tEnRZ8vHHYALVln3NqPYGtpvEadWp4oJhh1Z81md6NfdpkBD+hDgmHRK6bCXV50w==
X-Received: by 2002:aa7:d7cc:: with SMTP id e12mr5308268eds.388.1624520170560;
        Thu, 24 Jun 2021 00:36:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n10sm1363235edw.70.2021.06.24.00.36.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 00:36:09 -0700 (PDT)
Subject: Re: [kvm:queue 329/331] arch/x86/kvm/x86.c:5646:7: warning: variable
 'r' is used uninitialized whenever 'if' condition is false
To:     kernel test robot <lkp@intel.com>,
        Aaron Lewis <aaronlewis@google.com>
Cc:     kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        kvm@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        David Edmondson <david.edmondson@oracle.com>,
        Jim Mattson <jmattson@google.com>
References: <202106241248.NsKD61ey-lkp@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <00a7915e-1d46-4eef-abb7-202e1d6e3b2e@redhat.com>
Date:   Thu, 24 Jun 2021 09:36:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <202106241248.NsKD61ey-lkp@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/21 06:31, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> head:   42ac670e03c13e78b43177569bea49540d22661e
> commit: 3bd33d3f648e99bdf93f327f2abc40962d740b9c [329/331] kvm: x86: Allow userspace to handle emulation errors
> config: x86_64-randconfig-a002-20210622 (attached as .config)
> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 7c8a507272587f181ec29401453949ebcd8fec65)
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # install x86_64 cross compiling tool for clang build
>          # apt-get install binutils-x86-64-linux-gnu
>          # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=3bd33d3f648e99bdf93f327f2abc40962d740b9c
>          git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
>          git fetch --no-tags kvm queue
>          git checkout 3bd33d3f648e99bdf93f327f2abc40962d740b9c
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64

Botched conflict resolution, fixed now.

Paolo

> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>>> arch/x86/kvm/x86.c:5646:7: warning: variable 'r' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
>                     if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VALID_MASK) {
>                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     arch/x86/kvm/x86.c:5660:9: note: uninitialized use occurs here
>             return r;
>                    ^
>     arch/x86/kvm/x86.c:5646:3: note: remove the 'if' if its condition is always true
>                     if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VALID_MASK) {
>                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     arch/x86/kvm/x86.c:5537:7: note: initialize the variable 'r' to silence this warning
>             int r;
>                  ^
>                   = 0
>     1 warning generated.
> 
> 
> vim +5646 arch/x86/kvm/x86.c
> 
> 23d43cf998275b Christoffer Dall    2012-07-24  5533
> e5d83c74a5800c Paolo Bonzini       2017-02-16  5534  int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> 90de4a1875180f Nadav Amit          2015-04-13  5535  			    struct kvm_enable_cap *cap)
> 90de4a1875180f Nadav Amit          2015-04-13  5536  {
> 90de4a1875180f Nadav Amit          2015-04-13  5537  	int r;
> 90de4a1875180f Nadav Amit          2015-04-13  5538
> 90de4a1875180f Nadav Amit          2015-04-13  5539  	if (cap->flags)
> 90de4a1875180f Nadav Amit          2015-04-13  5540  		return -EINVAL;
> 90de4a1875180f Nadav Amit          2015-04-13  5541
> 90de4a1875180f Nadav Amit          2015-04-13  5542  	switch (cap->cap) {
> 90de4a1875180f Nadav Amit          2015-04-13  5543  	case KVM_CAP_DISABLE_QUIRKS:
> 90de4a1875180f Nadav Amit          2015-04-13  5544  		kvm->arch.disabled_quirks = cap->args[0];
> 90de4a1875180f Nadav Amit          2015-04-13  5545  		r = 0;
> 90de4a1875180f Nadav Amit          2015-04-13  5546  		break;
> 49df6397edfc5a Steve Rutherford    2015-07-29  5547  	case KVM_CAP_SPLIT_IRQCHIP: {
> 49df6397edfc5a Steve Rutherford    2015-07-29  5548  		mutex_lock(&kvm->lock);
> b053b2aef25d00 Steve Rutherford    2015-07-29  5549  		r = -EINVAL;
> b053b2aef25d00 Steve Rutherford    2015-07-29  5550  		if (cap->args[0] > MAX_NR_RESERVED_IOAPIC_PINS)
> b053b2aef25d00 Steve Rutherford    2015-07-29  5551  			goto split_irqchip_unlock;
> 49df6397edfc5a Steve Rutherford    2015-07-29  5552  		r = -EEXIST;
> 49df6397edfc5a Steve Rutherford    2015-07-29  5553  		if (irqchip_in_kernel(kvm))
> 49df6397edfc5a Steve Rutherford    2015-07-29  5554  			goto split_irqchip_unlock;
> 557abc40d12135 Paolo Bonzini       2016-06-13  5555  		if (kvm->created_vcpus)
> 49df6397edfc5a Steve Rutherford    2015-07-29  5556  			goto split_irqchip_unlock;
> 49df6397edfc5a Steve Rutherford    2015-07-29  5557  		r = kvm_setup_empty_irq_routing(kvm);
> 5c0aea0e8d98e3 David Hildenbrand   2017-04-28  5558  		if (r)
> 49df6397edfc5a Steve Rutherford    2015-07-29  5559  			goto split_irqchip_unlock;
> 49df6397edfc5a Steve Rutherford    2015-07-29  5560  		/* Pairs with irqchip_in_kernel. */
> 49df6397edfc5a Steve Rutherford    2015-07-29  5561  		smp_wmb();
> 49776faf93f807 Radim Krčmář        2016-12-16  5562  		kvm->arch.irqchip_mode = KVM_IRQCHIP_SPLIT;
> b053b2aef25d00 Steve Rutherford    2015-07-29  5563  		kvm->arch.nr_reserved_ioapic_pins = cap->args[0];
> 49df6397edfc5a Steve Rutherford    2015-07-29  5564  		r = 0;
> 49df6397edfc5a Steve Rutherford    2015-07-29  5565  split_irqchip_unlock:
> 49df6397edfc5a Steve Rutherford    2015-07-29  5566  		mutex_unlock(&kvm->lock);
> 49df6397edfc5a Steve Rutherford    2015-07-29  5567  		break;
> 49df6397edfc5a Steve Rutherford    2015-07-29  5568  	}
> 3713131345fbea Radim Krčmář        2016-07-12  5569  	case KVM_CAP_X2APIC_API:
> 3713131345fbea Radim Krčmář        2016-07-12  5570  		r = -EINVAL;
> 3713131345fbea Radim Krčmář        2016-07-12  5571  		if (cap->args[0] & ~KVM_X2APIC_API_VALID_FLAGS)
> 3713131345fbea Radim Krčmář        2016-07-12  5572  			break;
> 3713131345fbea Radim Krčmář        2016-07-12  5573
> 3713131345fbea Radim Krčmář        2016-07-12  5574  		if (cap->args[0] & KVM_X2APIC_API_USE_32BIT_IDS)
> 3713131345fbea Radim Krčmář        2016-07-12  5575  			kvm->arch.x2apic_format = true;
> c519265f2aa348 Radim Krčmář        2016-07-12  5576  		if (cap->args[0] & KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
> c519265f2aa348 Radim Krčmář        2016-07-12  5577  			kvm->arch.x2apic_broadcast_quirk_disabled = true;
> 3713131345fbea Radim Krčmář        2016-07-12  5578
> 3713131345fbea Radim Krčmář        2016-07-12  5579  		r = 0;
> 3713131345fbea Radim Krčmář        2016-07-12  5580  		break;
> 4d5422cea3b61f Wanpeng Li          2018-03-12  5581  	case KVM_CAP_X86_DISABLE_EXITS:
> 4d5422cea3b61f Wanpeng Li          2018-03-12  5582  		r = -EINVAL;
> 4d5422cea3b61f Wanpeng Li          2018-03-12  5583  		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
> 4d5422cea3b61f Wanpeng Li          2018-03-12  5584  			break;
> 4d5422cea3b61f Wanpeng Li          2018-03-12  5585
> 4d5422cea3b61f Wanpeng Li          2018-03-12  5586  		if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
> 4d5422cea3b61f Wanpeng Li          2018-03-12  5587  			kvm_can_mwait_in_guest())
> 4d5422cea3b61f Wanpeng Li          2018-03-12  5588  			kvm->arch.mwait_in_guest = true;
> 766d3571d8e50d Michael S. Tsirkin  2018-06-08  5589  		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
> caa057a2cad647 Wanpeng Li          2018-03-12  5590  			kvm->arch.hlt_in_guest = true;
> b31c114b82b2b5 Wanpeng Li          2018-03-12  5591  		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
> b31c114b82b2b5 Wanpeng Li          2018-03-12  5592  			kvm->arch.pause_in_guest = true;
> b51700632e0e53 Wanpeng Li          2019-05-21  5593  		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
> b51700632e0e53 Wanpeng Li          2019-05-21  5594  			kvm->arch.cstate_in_guest = true;
> 4d5422cea3b61f Wanpeng Li          2018-03-12  5595  		r = 0;
> 4d5422cea3b61f Wanpeng Li          2018-03-12  5596  		break;
> 6fbbde9a1969df Drew Schmitt        2018-08-20  5597  	case KVM_CAP_MSR_PLATFORM_INFO:
> 6fbbde9a1969df Drew Schmitt        2018-08-20  5598  		kvm->arch.guest_can_read_msr_platform_info = cap->args[0];
> 6fbbde9a1969df Drew Schmitt        2018-08-20  5599  		r = 0;
> c4f55198c7c2b8 Jim Mattson         2018-10-16  5600  		break;
> c4f55198c7c2b8 Jim Mattson         2018-10-16  5601  	case KVM_CAP_EXCEPTION_PAYLOAD:
> c4f55198c7c2b8 Jim Mattson         2018-10-16  5602  		kvm->arch.exception_payload_enabled = cap->args[0];
> c4f55198c7c2b8 Jim Mattson         2018-10-16  5603  		r = 0;
> 6fbbde9a1969df Drew Schmitt        2018-08-20  5604  		break;
> 1ae099540e8c7f Alexander Graf      2020-09-25  5605  	case KVM_CAP_X86_USER_SPACE_MSR:
> 1ae099540e8c7f Alexander Graf      2020-09-25  5606  		kvm->arch.user_space_msr_mask = cap->args[0];
> 1ae099540e8c7f Alexander Graf      2020-09-25  5607  		r = 0;
> 1ae099540e8c7f Alexander Graf      2020-09-25  5608  		break;
> fe6b6bc802b400 Chenyi Qiang        2020-11-06  5609  	case KVM_CAP_X86_BUS_LOCK_EXIT:
> fe6b6bc802b400 Chenyi Qiang        2020-11-06  5610  		r = -EINVAL;
> fe6b6bc802b400 Chenyi Qiang        2020-11-06  5611  		if (cap->args[0] & ~KVM_BUS_LOCK_DETECTION_VALID_MODE)
> fe6b6bc802b400 Chenyi Qiang        2020-11-06  5612  			break;
> fe6b6bc802b400 Chenyi Qiang        2020-11-06  5613
> fe6b6bc802b400 Chenyi Qiang        2020-11-06  5614  		if ((cap->args[0] & KVM_BUS_LOCK_DETECTION_OFF) &&
> fe6b6bc802b400 Chenyi Qiang        2020-11-06  5615  		    (cap->args[0] & KVM_BUS_LOCK_DETECTION_EXIT))
> fe6b6bc802b400 Chenyi Qiang        2020-11-06  5616  			break;
> fe6b6bc802b400 Chenyi Qiang        2020-11-06  5617
> fe6b6bc802b400 Chenyi Qiang        2020-11-06  5618  		if (kvm_has_bus_lock_exit &&
> fe6b6bc802b400 Chenyi Qiang        2020-11-06  5619  		    cap->args[0] & KVM_BUS_LOCK_DETECTION_EXIT)
> fe6b6bc802b400 Chenyi Qiang        2020-11-06  5620  			kvm->arch.bus_lock_detection_enabled = true;
> fe6b6bc802b400 Chenyi Qiang        2020-11-06  5621  		r = 0;
> fe6b6bc802b400 Chenyi Qiang        2020-11-06  5622  		break;
> fe7e948837f312 Sean Christopherson 2021-04-12  5623  #ifdef CONFIG_X86_SGX_KVM
> fe7e948837f312 Sean Christopherson 2021-04-12  5624  	case KVM_CAP_SGX_ATTRIBUTE: {
> fe7e948837f312 Sean Christopherson 2021-04-12  5625  		unsigned long allowed_attributes = 0;
> fe7e948837f312 Sean Christopherson 2021-04-12  5626
> fe7e948837f312 Sean Christopherson 2021-04-12  5627  		r = sgx_set_attribute(&allowed_attributes, cap->args[0]);
> fe7e948837f312 Sean Christopherson 2021-04-12  5628  		if (r)
> fe7e948837f312 Sean Christopherson 2021-04-12  5629  			break;
> fe7e948837f312 Sean Christopherson 2021-04-12  5630
> fe7e948837f312 Sean Christopherson 2021-04-12  5631  		/* KVM only supports the PROVISIONKEY privileged attribute. */
> fe7e948837f312 Sean Christopherson 2021-04-12  5632  		if ((allowed_attributes & SGX_ATTR_PROVISIONKEY) &&
> fe7e948837f312 Sean Christopherson 2021-04-12  5633  		    !(allowed_attributes & ~SGX_ATTR_PROVISIONKEY))
> fe7e948837f312 Sean Christopherson 2021-04-12  5634  			kvm->arch.sgx_provisioning_allowed = true;
> fe7e948837f312 Sean Christopherson 2021-04-12  5635  		else
> fe7e948837f312 Sean Christopherson 2021-04-12  5636  			r = -EINVAL;
> fe7e948837f312 Sean Christopherson 2021-04-12  5637  		break;
> fe7e948837f312 Sean Christopherson 2021-04-12  5638  	}
> fe7e948837f312 Sean Christopherson 2021-04-12  5639  #endif
> 54526d1fd59338 Nathan Tempelman    2021-04-08  5640  	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
> 54526d1fd59338 Nathan Tempelman    2021-04-08  5641  		r = -EINVAL;
> 54526d1fd59338 Nathan Tempelman    2021-04-08  5642  		if (kvm_x86_ops.vm_copy_enc_context_from)
> 54526d1fd59338 Nathan Tempelman    2021-04-08  5643  			r = kvm_x86_ops.vm_copy_enc_context_from(kvm, cap->args[0]);
> 54526d1fd59338 Nathan Tempelman    2021-04-08  5644  		return r;
> 0dbb1123043789 Ashish Kalra        2021-06-08  5645  	case KVM_CAP_EXIT_HYPERCALL:
> 0dbb1123043789 Ashish Kalra        2021-06-08 @5646  		if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VALID_MASK) {
> 0dbb1123043789 Ashish Kalra        2021-06-08  5647  			r = -EINVAL;
> 0dbb1123043789 Ashish Kalra        2021-06-08  5648  			break;
> 0dbb1123043789 Ashish Kalra        2021-06-08  5649  		}
> 0dbb1123043789 Ashish Kalra        2021-06-08  5650  		kvm->arch.hypercall_exit_enabled = cap->args[0];
> 3bd33d3f648e99 Aaron Lewis         2021-05-10  5651  		break;
> 3bd33d3f648e99 Aaron Lewis         2021-05-10  5652  	case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
> 3bd33d3f648e99 Aaron Lewis         2021-05-10  5653  		kvm->arch.exit_on_emulation_error = cap->args[0];
> 0dbb1123043789 Ashish Kalra        2021-06-08  5654  		r = 0;
> 0dbb1123043789 Ashish Kalra        2021-06-08  5655  		break;
> 90de4a1875180f Nadav Amit          2015-04-13  5656  	default:
> 90de4a1875180f Nadav Amit          2015-04-13  5657  		r = -EINVAL;
> 90de4a1875180f Nadav Amit          2015-04-13  5658  		break;
> 90de4a1875180f Nadav Amit          2015-04-13  5659  	}
> 90de4a1875180f Nadav Amit          2015-04-13  5660  	return r;
> 90de4a1875180f Nadav Amit          2015-04-13  5661  }
> 90de4a1875180f Nadav Amit          2015-04-13  5662
> 
> :::::: The code at line 5646 was first introduced by commit
> :::::: 0dbb11230437895f7cd6fc55da61cef011e997d8 KVM: X86: Introduce KVM_HC_MAP_GPA_RANGE hypercall
> 
> :::::: TO: Ashish Kalra <ashish.kalra@amd.com>
> :::::: CC: Paolo Bonzini <pbonzini@redhat.com>
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

