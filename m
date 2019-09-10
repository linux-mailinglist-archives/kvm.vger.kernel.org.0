Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE80FAF058
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 19:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437106AbfIJRQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 13:16:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387433AbfIJRQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 13:16:40 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0B651368E2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 17:16:40 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id w3so6364002wrv.10
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 10:16:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sXx3wC6DB6V/16xDyljAZ+XbGZ2TYyNh+TDXmKvq43Y=;
        b=j8WS9QFPxqZgQ4DhkeY9S7BJA7TxEaaSAEil0k+eZoFxH+d7qrcxJ1CGkDwzFNRhWl
         6d02SgvkMAd2lwzaJoYXohZUTNAobwB86LlhfuTaUiHuWoazaAvC5x2MHbewHGtCA6hL
         HxYYMoh4kGrUeZnTEaEniBXDc/ifQZgpRfDxzymvC7CHm0D3jg+J95SGJdQ9kj4cVQve
         3PwL7C8YLTAjsBI2nQ3MeiCy1X69x3dZdiu9a7IDo+gmWo3ZA/ELKiUejTPjYg3Z4c7e
         QvouqBv3ZNhbdYkwl+pZ3rRbvloWPFTufzyqduQ+is48V7woagpsEHnFx8vzIz0q2iDM
         1JTQ==
X-Gm-Message-State: APjAAAVXV83gtPbW6fLRy5bEXKcAb14dQcUX7g7vvmSt4vN3pIVuzEr3
        t9IPGdY/1Ca0GUnAFtigi97QQdwOBnPiXkpjNGu9Gv82yVIwQd6VzOua/5KzcUl21g1sZJvqfDv
        Neu6+ctYZqirz
X-Received: by 2002:adf:ef12:: with SMTP id e18mr27155138wro.65.1568135798749;
        Tue, 10 Sep 2019 10:16:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxWenyibwSJRwn6KSJsdjgdgpu6h0YJe79lgQ3s3dKX/r5eDv3hIdbovJ5nwtTo9HgfFG6a7w==
X-Received: by 2002:adf:ef12:: with SMTP id e18mr27155123wro.65.1568135798496;
        Tue, 10 Sep 2019 10:16:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1435:25df:c911:3338? ([2001:b07:6468:f312:1435:25df:c911:3338])
        by smtp.gmail.com with ESMTPSA id z142sm526081wmc.24.2019.09.10.10.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2019 10:16:37 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 0/2] x86: nVMX: Bug fixes
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Marc Orr <marcorr@google.com>
References: <20190830204031.3100-1-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <53a4a185-4146-7625-3bcf-94e7401facdf@redhat.com>
Date:   Tue, 10 Sep 2019 19:16:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190830204031.3100-1-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/08/19 22:40, Nadav Amit wrote:
> Two bug fixes that were found while running on bare-metal.
> 
> The first one caused the second bug not to be found until now.
> 
> The second bug is an SDM bug, and requires KVM to be fixed as well
> (consider it as a bug report on behalf of VMware).
> 
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Cc: Marc Orr <marcorr@google.com>
> 
> Nadav Amit (2):
>   x86: nVMX: Do not use test_skip() when multiple tests are run
>   x86: nVMX: Fix wrong reserved bits of error-code
> 
>  x86/vmx_tests.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 

Queued, thanks.

Paolo
