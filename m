Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D9D285DF8
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 13:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgJGLPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 07:15:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726129AbgJGLPq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 07:15:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602069345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3r5XQBzMLmQ+lHSJjnDEGaGsxnKJm0CF1PWaPtea4dc=;
        b=GG8zvhq9C5PJbw0JeYKdjzed/70oj5HWbjeBFYvekhyut1Xdfd/UAQnPafg60MQsXvjyGA
        NAqOJK3IY9wy4AxtgrUWND1G1+/RyASo193fwy7GEpbr5Wksx+BAljtEgI3+cd3k8Exf9P
        wBaVBlQxCIYENgY81QEm43kfDsIRpPU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-qePKGa2pM9eNH4hcnqhilg-1; Wed, 07 Oct 2020 07:15:44 -0400
X-MC-Unique: qePKGa2pM9eNH4hcnqhilg-1
Received: by mail-wm1-f72.google.com with SMTP id b20so1966533wmj.1
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 04:15:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3r5XQBzMLmQ+lHSJjnDEGaGsxnKJm0CF1PWaPtea4dc=;
        b=ipgAMRyeqs16uRUOaj4tukp4fRwujo7svRgpFu/6aD1XaHvyfiOj8NJYCPpLLNdFSY
         Kw1BrmSdHIaVL/lzOJamiIHak4wQwcijyARm45J5iSPniMhxK6eX5WEQDlmXkOQX9oj1
         1k2uDAAJLRlxeR/B3vlkBp71tMlhoJGA2Ljq1DRydPtr/CPy1E0+nw0W8zNVf3ib03V+
         1JUrJCDfkeaWQIY6OVnfVgBOqRfE3Luq/AsETfgYIoPc0QtKg8GyQYCk+BiEz+LjGlbo
         bDQ8LwEl2rEvVGrWLK/u7Z6Zz/pY9Mp+R3Xf3h24kK2YnjLQyK0C0qwFA6Dh7ZJ6RAWs
         s5Zg==
X-Gm-Message-State: AOAM5328sm/Qv+7PzrepZCkKo84BYSrBxa0LS2XvcTdOMPP1hJYLVxSb
        thSfedwbzpO5HWPoR/kCfdihpxcrHYnIjXAaIrRSmgxF6QzbvtoVSbltaHxJOFc+P8M0rDtnV/+
        yG67rMuzHODRc
X-Received: by 2002:a5d:46c5:: with SMTP id g5mr3072276wrs.416.1602069342760;
        Wed, 07 Oct 2020 04:15:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7sYpP9gVtxipT0pzhdsv4463xKXEPVIHdH2X3m2sQwU7XAAsdRDas6Bf2F6nO3skuNDVcig==
X-Received: by 2002:a5d:46c5:: with SMTP id g5mr3072258wrs.416.1602069342576;
        Wed, 07 Oct 2020 04:15:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d2f4:5943:190c:39ff? ([2001:b07:6468:f312:d2f4:5943:190c:39ff])
        by smtp.gmail.com with ESMTPSA id a15sm2556682wrn.3.2020.10.07.04.15.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 04:15:41 -0700 (PDT)
Subject: Re: [PATCH 13/13] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org>
 <20201005152856.974112-1-dwmw2@infradead.org>
 <20201005152856.974112-13-dwmw2@infradead.org>
 <472a34e3-2981-0c7b-1fb0-da8debbdc728@redhat.com>
 <b1f7e1210580acdf4673498be71eaf33acb8c146.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8a502c78-71d7-83f6-7ba8-b16fd41e64fe@redhat.com>
Date:   Wed, 7 Oct 2020 13:15:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <b1f7e1210580acdf4673498be71eaf33acb8c146.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/10/20 10:59, David Woodhouse wrote:
> Yeah, I was expecting the per-irqdomain affinity support to take a few
> iterations. But this part, still sticking with the current behaviour of
> only allowing CPUs to come online at all if they can be reached by all
> interrupts, can probably go in first.
> 
> It's presumably (hopefully!) a blocker for the qemu patch which exposes
> the same feature bit defined in this patch.

Yeah, though we could split it further and get the documentation part in
first.  That would let the QEMU part go through.

Paolo

