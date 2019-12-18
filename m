Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97642124E3A
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 17:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfLRQqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 11:46:09 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60282 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727334AbfLRQqJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Dec 2019 11:46:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576687567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JrsSB6THNEnoZ1jcvot06rvcQD6vvL+uJ7YjWugeR7I=;
        b=LV8E43fEknIyi1/df/ZThSALpRPSA16AWT00RdrR64s+gTEpV+ZjyTlsXbPs5FTI4+UxVQ
        dt+tgNjjBgjHNHddXLvklG8vvq5HenqV/ICZb7Rf3GlhM62BSkGB97bkSdGg4/998McbxE
        tydozcBlxvom3r728AnC+2YQPQudbXM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-_hkcW7pCPDiAyIlbM0xVQw-1; Wed, 18 Dec 2019 11:46:06 -0500
X-MC-Unique: _hkcW7pCPDiAyIlbM0xVQw-1
Received: by mail-wr1-f71.google.com with SMTP id h30so1104629wrh.5
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2019 08:46:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JrsSB6THNEnoZ1jcvot06rvcQD6vvL+uJ7YjWugeR7I=;
        b=DiRCh0ygyr63yTjEnc2B21K79EPBgD+VlGc+bWd65oXq7vEClx0x6iYKXl9zwWCLVV
         2cpYDqPWwzmQ2Fib1wUixFkPXfEVc41+rYm/McrH4z2MmaxqKtqckIDcz6vkh/EgdnDt
         f4vSAbJwOebzNwDmiy0lA3eBF5R57pTJvrphma7PqTiOxzuev1veC44lj1+OQLq9Q0SW
         Xzr9UNAETUB7OZE9KeckLfqzH98HrrU/LpdlehxnYVuoXKO9A10hH+UpO7Z6v2S1p8+Q
         Lqlaa+VyyHne5NQss1ejGl7/ym1hBJYJNbFc8qguzSPN9sLiPSTHWyHwcWSxx/ypgREA
         hlxQ==
X-Gm-Message-State: APjAAAXqkcqHXVB1SMOKDGYdEbGzH907y4H7szM1YTFZX5hQCGQvfoTb
        ekQB6iLUIILeyW7BVl6B2rrYx0HAEiZQOtJy8mCl/5Zub60uSzbT4BdxAP2BsUGZdRZULk/jiyW
        68mJEpHlpNW6O
X-Received: by 2002:adf:8297:: with SMTP id 23mr3648881wrc.379.1576687565405;
        Wed, 18 Dec 2019 08:46:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqwbiXD4H0A8oxlWiPhdSByai8L0qa6i/RKtKCPC+HM8m/sFbY2WmolCB25iTNe+hrRVi0rFDg==
X-Received: by 2002:adf:8297:: with SMTP id 23mr3648867wrc.379.1576687565214;
        Wed, 18 Dec 2019 08:46:05 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ac09:bce1:1c26:264c? ([2001:b07:6468:f312:ac09:bce1:1c26:264c])
        by smtp.gmail.com with ESMTPSA id l7sm3118939wrq.61.2019.12.18.08.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 08:46:04 -0800 (PST)
Subject: Re: [PATCH 2/2] kvm: x86: Host feature SSBD doesn't imply guest
 feature AMD_SSBD
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Jacob Xu <jacobhxu@google.com>, Peter Shier <pshier@google.com>
References: <20191214001516.137526-1-jmattson@google.com>
 <20191214001516.137526-2-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a7928098-76d7-d7ec-3d00-9a16d10ba708@redhat.com>
Date:   Wed, 18 Dec 2019 17:46:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191214001516.137526-2-jmattson@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/12/19 01:15, Jim Mattson wrote:
> [...]
Queued both, thanks.

Paolo

