Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3483F2D34F
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 03:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbfE2B2X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 21:28:23 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45363 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbfE2B2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 21:28:23 -0400
Received: by mail-wr1-f67.google.com with SMTP id b18so419746wrq.12
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 18:28:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zy4dt0/WsQ2pPQWde6zfELpEkgD8cGRU5zkaONVLf7w=;
        b=ZqhortoeAsl1wnEj+Ljih9BaTFwVVW9O/7l0NwcHEIDqnk6PvsHyJihytxrKApRnDW
         9gsYV2pRghsP7nbEH9RuUahqCHkIje4knfJ2t/tjfh/WqWK3ysmR5/tJTBI10Zcz1GXv
         BFyUAR1G7jrfZUL8hM5HngLwnyRgCBI/LPej5FSd35jedwAbnH4AD6PQ6UQXlDFmlYDG
         sjBt8BNbCzo+VbUpNBxHu/NiVl/BSyHTeBNLdxPGw2ZqWtzjt3COc5C1upWbqXE2wVPE
         P4WijSKrvIoEEo+e66jr3N1ZGiyonsGeE1UlmaEAoveHt8Vzyiz3NNp9eTgAqBW0ZR7a
         qdNQ==
X-Gm-Message-State: APjAAAVE1iQipxHECxJkCjt6VcBoY5HTjBae1ZIpshAcZi16RdXLrKqn
        Vo1UZEirF9KpmW5cIG3oZgymaQ==
X-Google-Smtp-Source: APXvYqwZYgBbYcOXL1jluAbtyuzMdx9moyE1uHZ1h1H51iIfrMrheEe0qRvL24XxCKchdTyl5TIvIA==
X-Received: by 2002:adf:b64b:: with SMTP id i11mr7328142wre.205.1559093301578;
        Tue, 28 May 2019 18:28:21 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id r16sm11765117wrj.13.2019.05.28.18.28.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 18:28:21 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] KVM: vmx: handle vm-exit for UMWAIT and TPAUSE
To:     Tao Xu <tao3.xu@intel.com>, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jingqi.liu@intel.com
References: <20190524075637.29496-1-tao3.xu@intel.com>
 <20190524075637.29496-4-tao3.xu@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b0958339-b23c-dd9d-8673-aae098769738@redhat.com>
Date:   Wed, 29 May 2019 03:28:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524075637.29496-4-tao3.xu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/19 09:56, Tao Xu wrote:
> As the latest Intel 64 and IA-32 Architectures Software Developer's
> Manual, UMWAIT and TPAUSE instructions cause a VM exit if the
> “RDTSC exiting” and “enable user wait and pause” VM-execution controls
> are both 1.
> 
> This patch is to handle the vm-exit for UMWAIT and TPAUSE as invalid_op.

KVM never enables RDTSC exiting, so this is not necessary.

Paolo
