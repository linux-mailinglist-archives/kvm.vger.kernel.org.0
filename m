Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA71782B8B
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 08:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731728AbfHFGU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 02:20:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35481 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731540AbfHFGU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 02:20:58 -0400
Received: by mail-wr1-f66.google.com with SMTP id k2so744809wrq.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 23:20:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aMztFRMwS894XHsmEs01R20QPKJnerKfJ/mqwGoosCA=;
        b=n+y5uGPrOFJ4vBVGvbkJgNkaC4G1XcHrFlRE2SvnYQxsWICe6p/zwjQKhtXwQoz5ju
         Dm7jPlVXVT/O9B2PIFjL3LqOscERL7qTbvgv3/T3RcJgCQoggUW3e25hSWQU4vx5Dl7/
         izYc3V7G+9jA7hzp2xMOOm/3u09qXyBoZ+ePEgUIr5eDGlnj+P3o3dgh/ORKfOdiY0R6
         bA2It/TDAjZmUpNDMsDrqoJ3mWSjOJCqgmo/xFCfXAySVEKKexD+vOQGd2FBxVUnKMAd
         GR/Z8CFdxtijXvevEVqfyqCVWjZzY8Rfbm5j638kHsDGGM18Zped2C3KjAf5UhNb9wj0
         l8uA==
X-Gm-Message-State: APjAAAVypj3Ej0WEA+TVu7X6M4kWDGQY6+HtrtKYXIIByAL/JtI2pxp/
        rUjpJftfvICm44KrrXsZyeXHBg==
X-Google-Smtp-Source: APXvYqylbgUdbdCCip+TqSzuS3nN/TZgFkjI643QFSasgjW2I/qMUGjPcLCRAwvxZhdJxcEgwJic+A==
X-Received: by 2002:a5d:4949:: with SMTP id r9mr2276210wrs.289.1565072456384;
        Mon, 05 Aug 2019 23:20:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:dc26:ed70:9e4c:3810? ([2001:b07:6468:f312:dc26:ed70:9e4c:3810])
        by smtp.gmail.com with ESMTPSA id t63sm84881683wmt.6.2019.08.05.23.20.55
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 23:20:55 -0700 (PDT)
Subject: Re: [PATCH v4 1/6] KVM: Fix leak vCPU's VMCS value into other pCPU
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "# v3 . 10+" <stable@vger.kernel.org>
References: <1564970604-10044-1-git-send-email-wanpengli@tencent.com>
 <9acbc733-442f-0f65-9b56-ff800a3fa0f5@redhat.com>
 <CANRm+CwH54S555nw-Zik-3NFDH9yqe+SOZrGc3mPoAU_qGxP-A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e7b84893-42bf-e80e-61c9-ef5d1b200064@redhat.com>
Date:   Tue, 6 Aug 2019 08:20:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CwH54S555nw-Zik-3NFDH9yqe+SOZrGc3mPoAU_qGxP-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/08/19 02:35, Wanpeng Li wrote:
> Thank you, Paolo! Btw, how about other 5 patches?

Queued everything else too.

Paolo

> Regards,
> Wanpeng Li

