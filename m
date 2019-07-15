Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD1A69ACA
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 20:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbfGOS2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 14:28:52 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39280 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729441AbfGOS2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 14:28:52 -0400
Received: by mail-wm1-f68.google.com with SMTP id u25so5817284wmc.4
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 11:28:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uw98xrMIhtv6b4xV/oWmb7W00RrBRhQXYLpADwO7gr4=;
        b=If4dKjVCgK9Bu58HV1FvlH5sgobug4OkaHYFuPjg+T5ZAQt2ss/m8XX4bDc/Psce6G
         7Rjfsr58l7IoohITo+uoQ2Ny7cAwlSBc3Z2HhCjuo6h/t1UbeuusDMn5SAKO8lh5ry/b
         jltyh6eNtu8QDPXa154qtYgst5o//6aR6wH33fmfyZPfCeqi1mxGaO8F9E8ABUQJcP5h
         7QTHScivQscVf+cz6k3aXNSagX0vSHFYVpLLsV7HgVq9eweFc9r+cCRai2SnVP6BpRO2
         YsTdTyFNNyHldogrWsiyFDd9oJvnK3sHSI2yam3ZH95yjI32IyrBFknaoDBs8OI05x+V
         68yQ==
X-Gm-Message-State: APjAAAUYBePrFQ8cek5rZIoFAVaLINeYlkKfFF40QnI+XmAI90rPi76g
        8LhiwWXts/qz3qJD00Y+zmILE/UJAKw=
X-Google-Smtp-Source: APXvYqy17OQNVkssISf4mPDFAKxNlj95Br4uYgLVDh+e2hgMbrh7RKrU6HA3FFmpMysZQ1BgWpJc4A==
X-Received: by 2002:a1c:6504:: with SMTP id z4mr25147426wmb.172.1563215330368;
        Mon, 15 Jul 2019 11:28:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b159:8d52:3041:ae0d? ([2001:b07:6468:f312:b159:8d52:3041:ae0d])
        by smtp.gmail.com with ESMTPSA id e5sm18505873wro.41.2019.07.15.11.28.49
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 11:28:49 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Ignore segment base for VMX memory operand
 when segment not FS or GS
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>, max@m00nbsd.net,
        Joao Martins <joao.m.martins@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
References: <20190715154744.36134-1-liran.alon@oracle.com>
 <87r26rw9lv.fsf@vitty.brq.redhat.com> <20190715172139.GB789@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <801988b0-b5c0-011e-5775-cb9e22f5d5c2@redhat.com>
Date:   Mon, 15 Jul 2019 20:28:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190715172139.GB789@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/07/19 19:21, Sean Christopherson wrote:
>>> +		if ((seg_reg != VCPU_SREG_FS) && (seg_reg != VCPU_SREG_GS))
> I'm pretty sure the internal parantheses are unnecessary.
> 

Indeed, that's so Pascal! :)  I'll apply Vitaly's suggestion and queue it.

Paolo
