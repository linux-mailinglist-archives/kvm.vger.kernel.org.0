Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E481735F
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 10:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfEHIMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 04:12:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37643 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfEHIMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 04:12:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id y5so2014377wma.2
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 01:12:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dh//jMcw6robEc3tZHy1N8nxpf0+uX/A3x4zFSnFVbw=;
        b=JguCSRKfIJivd37CQYJYwQWzuzxObcjH7D6Qy9s13EroWWeMfbEgfjAMBqQRG5aOX2
         38pCxN+aH95QjxMOpjvbGW7YLeNkB3/NRiaKcb7ctM97yzVMtZxSPvbtA86BFZp5c+Pr
         Yhw+yeEUbMFaZp2kxt89x2UlQOi3ifMR4Gevcvbk03/DdexlWpYv/IBq4gkPPR3gCEhm
         vUzLkxEVWu1OdVe0SBkFeNJ9oSDg3399d9tCuXBsF91z/SC5vnBeJgLM61MjGXz95v9H
         wNq4M5Fkz7xxxfR/0UH8ZOf3wvZhQczQ0uHYF9ZpfRjmwLgUb6XwutFXvMW1WZl2Gth7
         BQSg==
X-Gm-Message-State: APjAAAUTw94NV2nmcOnofYniz5IPmXmjYxqj1puP/gKHWQudYQl/7AIx
        zc3s6c4vSdoWGT2AY/TVcVdHwA==
X-Google-Smtp-Source: APXvYqzCC/U65WVMSAY0EhFDfwhXm34pVVULG/GyHdCMncJAlW9FIpOp7Ii1sGDPRGCLT1HpKA4vAg==
X-Received: by 2002:a1c:5588:: with SMTP id j130mr2078714wmb.72.1557303171157;
        Wed, 08 May 2019 01:12:51 -0700 (PDT)
Received: from [10.201.49.229] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id t126sm1236281wma.1.2019.05.08.01.12.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 01:12:50 -0700 (PDT)
Subject: Re: [PATCH 0/2] kvm: Some more trivial fixes for clear dirty log
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org
Cc:     Juan Quintela <quintela@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
References: <20190508054403.7277-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a440e3f0-384b-2173-2c55-6cb2641f7937@redhat.com>
Date:   Wed, 8 May 2019 10:12:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190508054403.7277-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/19 00:44, Peter Xu wrote:
> Two issues I've noticed when I'm drafting the QEMU support of it.
> With these two patches applied the QEMU binary (with the clear dirty
> log supported [1]) can migrate correctly otherwise the migration can
> stall forever if with/after heavy memory workload.
> 
> Please have a look, thanks.
> 
> [1] https://github.com/xzpeter/qemu/tree/kvm-clear-dirty-log
> 
> Peter Xu (2):
>   kvm: Fix the bitmap range to copy during clear dirty
>   kvm: Fix loop of clear dirty with off-by-one
> 
>  virt/kvm/kvm_main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

Looks good, but this is a blocker for using this feature in userspace.
I think we should change the capability name and number.

Paolo
