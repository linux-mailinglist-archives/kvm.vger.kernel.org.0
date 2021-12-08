Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CC846D4EB
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 14:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbhLHOBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 09:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhLHOBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 09:01:07 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CB4C061746;
        Wed,  8 Dec 2021 05:57:35 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id v1so8734261edx.2;
        Wed, 08 Dec 2021 05:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Bcmh3+TxAfYVZSEKuhQNVFxFf26h1DtZzZ4/kkVeF4I=;
        b=ZPFiG7zVVOQBrjoS2BCxkYL9lsVo7d+Ghd2r7m7G/WdC44W83YIvYpwR8tThvzlYDD
         vVy0tbQzNqf61/kqHCwcqKaOIoDY1o0AtC+M08whkPMB9LR8QzfGoapC+NUGHYehU4F9
         VSyb61h9t7eTnDD25/oZ9Swf5B3QiSQlvJ/mxEMqEsquCIrTar6YIwsfbrPMNEIWklZe
         1/cFugc5kVXlMTCxxbW25QwwjYwhcgRlV+1KRwRQN60kcb9hdsWAQ04sfOsFcchB8k5E
         g9erWca6RIIFNYVUf+x5uB/gjqJF8SU/Gm9S9dSavcdf5zp1USUrJTfTTjZONmC5xXJe
         m95A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Bcmh3+TxAfYVZSEKuhQNVFxFf26h1DtZzZ4/kkVeF4I=;
        b=ROFBHLj1tN5QXDtrHEaIBgIUd0b1Y8fu2DYMmCCQJFfyee2SL+wMOr412EUdI+5ukM
         /FEarULnUbe6smguctt8cX1w7vgHljUFBARwv8ocrO1zzCIuKFSgLOnqtZ2+gLBhzKDL
         3IoDfoevWZfF6qs006F5KuAIG9l/bQNYHdm6Up9IIzG/xAzm9ToC9tBLylj8IH9mjgfO
         I1sb1mHM/2uuGgUf3nNKAsbh66+aPZpTycxT3+vGtlaXn1F5fGSW/YHBu1m7p5CYe6Hv
         qFBb/p1kekYWOspYyy59d6thP8ZTLwaXnXijUtPO/TN+hIEiOToSOtSNnh/jQk0d5X3t
         Qqzw==
X-Gm-Message-State: AOAM532k9KoCgv5y67fys2HKcAEtCNadicJ+YXEyKhXyd0YydsJOZKNI
        cjyO/zXh7giQH9jysvskroU=
X-Google-Smtp-Source: ABdhPJxEejxp1K5lA7qbkMdx+rCIwh6MVbr7lmcpnc7rrQUICSMEBK+afIPa1xT/xRdazXhHxsAKhw==
X-Received: by 2002:a17:906:830b:: with SMTP id j11mr7577161ejx.161.1638971854459;
        Wed, 08 Dec 2021 05:57:34 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id e1sm1536261ejy.82.2021.12.08.05.57.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 05:57:34 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3cf70fa7-8e3e-5066-bdf4-59aec5215640@redhat.com>
Date:   Wed, 8 Dec 2021 14:57:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Rewording of Setting IA32_XFD[18] (Re: Thoughts of AMX KVM
 support based on latest kernel)
Content-Language: en-US
To:     "Nakajima, Jun" <jun.nakajima@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <878rxn6h6t.ffs@tglx> <16BF8BE6-B7B1-4F3E-B972-9D82CD2F23C8@intel.com>
 <2e2ab02c-b324-e136-924a-0376040163a8@redhat.com>
 <BN9PR11MB5433D6A1368904D9B748846B8C9A9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <c7d87723-5533-257f-fbf0-ecd3a0b96602@redhat.com>
 <D93C093C-8420-45DA-99F5-0A5318ADBBEF@intel.com> <87sfvslaha.ffs@tglx>
 <5ABC728C-9FD3-4BEB-BD02-61E910D69847@intel.com>
 <9F8F8297-E70F-427C-BEDA-9FAB86877DBD@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <9F8F8297-E70F-427C-BEDA-9FAB86877DBD@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 01:50, Nakajima, Jun wrote:
> 3.3 RECOMMENDATIONS FOR SYSTEM SOFTWARE
> 
> System software may disable use of Intel AMX by clearing XCR0[18:17],
> by clearing CR4.OSXSAVE, or by setting IA32_XFD[18]. System software
> should initialize AMX state (e.g., by executing TILERELEASE) when
> doing so because maintaining AMX state in a non-initialized state may
> have negative power and performance implications. In addition,
> software should not rely on the state of the tile data after setting

I would change this to "must not rely", otherwise looks good.  Thanks!

Paolo

> IA32_XFD[18]; software should always reload or reinitialize the tile
> data after clearing IA32_XFD[18].


