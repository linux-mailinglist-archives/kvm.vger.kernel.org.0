Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115AA804A4
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 08:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfHCGYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Aug 2019 02:24:34 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38650 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfHCGYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Aug 2019 02:24:33 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so46917126wmj.3
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 23:24:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qQrXRWbiVzCgKkWpGh8Bph8KJod9P3yHKaFNvkh79S8=;
        b=mHsb9ZttOQ+8lWZESqtoqtcjhODLc7Xfr0uZrx/FGgEqtqIw+DFxUIh1Q7eom43Nnf
         Sn5RQBzFgi6C0a84n1SfB8qDckSWkLYqv/bU7z/gIFRALP+GFnbpnni6QByzpOQtf6FE
         UfPZAavab/M279/Tavfvr17zpnBoPbb7fQacO8jsPyQE+MnV0AZitzYiJlH6PRNiEKFY
         zfIOzeXOiUbFoNdRMOv51399iCJLhJgD+toTjAtNzXfqOQnrmihPvog2ieUnq8CVO3sq
         aHPQ3oHCGvgcsH+NwcEszSaHbopkQxmN9luQZ0q5HeAj3WgbcRs9po62kLI+xpsKqcbO
         zXAg==
X-Gm-Message-State: APjAAAW0jU2lUUmHpMtzPtNpE4YE2/J3gYWItujxp5qX9Mw8Ttb1dwBD
        D7rhiPig0c+kRqfpQra8+ACZFQ==
X-Google-Smtp-Source: APXvYqzefN/OOM3ZIIp9IhluMM+RtXq/dKJtM7YYpcswrSjVtlCw7yJ0+dAr6aKQu/XR/JmQm+g3ag==
X-Received: by 2002:a1c:cb0a:: with SMTP id b10mr7637972wmg.41.1564813472287;
        Fri, 02 Aug 2019 23:24:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id s2sm61976309wmj.33.2019.08.02.23.24.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 23:24:31 -0700 (PDT)
Subject: Re: [PATCH] KVM: selftests: Update gitignore file for latest changes
To:     shuah <shuah@kernel.org>, Thomas Huth <thuth@redhat.com>,
        kvm@vger.kernel.org
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190731142851.9793-1-thuth@redhat.com>
 <20c43c74-09f9-8f0b-64e4-a481a40387cb@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d96b6e7b-d091-59c3-60ed-a1bcd21fd549@redhat.com>
Date:   Sat, 3 Aug 2019 08:24:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20c43c74-09f9-8f0b-64e4-a481a40387cb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/08/19 15:58, shuah wrote:
>>
> 
> Hi Paolo,
> 
> Let me know if you need me to take any of these patches. In any
> case:
> 
> Acked-by: Shuah Khan <skhan@linuxfoundation.org>

Thanks, I've queued these in the KVM tree.

Paolo
