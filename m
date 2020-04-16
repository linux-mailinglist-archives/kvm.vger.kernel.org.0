Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786591AC6CA
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 16:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394576AbgDPOof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 10:44:35 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32817 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2898885AbgDPN76 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 09:59:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587045597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+/DvZF3rLr6bk7dnDadPbpjMUW91IbsAARDUOjqrjNA=;
        b=RkU3GFfFWF8XJvZlCfDfVLq14QEKcMMphg6Uy7aVpfftVmiEwBiJZe2ULAwiL0MrVXmvWg
        I7Qx2mg1qX+pynX0E2z8jkSdjRCRfefDnvjhfcaR+wN6N9efVFW8aU/SmxWfkkghaFOgSE
        kumS6kk09M8OuFr0YqccWRd6FzZz/Nw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-j8EtdZkMMDSSr-HpXgApOA-1; Thu, 16 Apr 2020 09:59:52 -0400
X-MC-Unique: j8EtdZkMMDSSr-HpXgApOA-1
Received: by mail-wr1-f70.google.com with SMTP id j16so1733657wrw.20
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 06:59:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+/DvZF3rLr6bk7dnDadPbpjMUW91IbsAARDUOjqrjNA=;
        b=W4avN7WC2jpHhJ9NunaHJRnjNemzvB7HkDk9jQTOrGMlw4LbUuDmJb66fWg3pQ6Azp
         65C+OlcyRNGDYe2Riw2QuvBQJ63z1IlTuHJjI5y1AEAnigaa6V8ZIcxi8+q3qM5EsGHq
         JhptbPNP9158MRfWeHz1Mf6cg4cAZCikQvo4Si/zsIKqKVbgIQIonhcnzyxVgXkg2gjw
         8LnHI4b8CPvu2p9FnBzcQN89H7jIq3Hsg4PVVc4wvy60hizNJlMkoza1L2YfXLnRqXBz
         m9bPX/669l20o3HqZq+Wt90dexleM+guakc6cnNhuk6iza1d7OQ4aiwHc+LMMZ1B8To4
         2m/w==
X-Gm-Message-State: AGi0PuZHtyjC8iqwAeRw4SdLyf92SDHYSBRWkcpt+fpBw8ZVpxPaHMjl
        V+sjoWhJKdzHyBecaf3CtvXAcUso1JoUsa12NU1TzNLdc5oSUjaSswz+rDVPuqfJYSHfy0jesoO
        FDleVqN7Q2xCV
X-Received: by 2002:adf:90c6:: with SMTP id i64mr33091343wri.88.1587045591307;
        Thu, 16 Apr 2020 06:59:51 -0700 (PDT)
X-Google-Smtp-Source: APiQypKO+4JKhvMwWnWuX+A/FR5dp8KXrF9TT/Ax/0t8NlaANIbgzsHktsM8akG0Yye+42CsXGdX1Q==
X-Received: by 2002:adf:90c6:: with SMTP id i64mr33091327wri.88.1587045591046;
        Thu, 16 Apr 2020 06:59:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:399d:3ef7:647c:b12d? ([2001:b07:6468:f312:399d:3ef7:647c:b12d])
        by smtp.gmail.com with ESMTPSA id h26sm19131736wrb.25.2020.04.16.06.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 06:59:50 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: nSVM: Check CR0.CD and CR0.NW on VMRUN of nested
 guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
References: <20200409205035.16830-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b9259b5f-0233-2ed2-8e54-5345670d7411@redhat.com>
Date:   Thu, 16 Apr 2020 15:59:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200409205035.16830-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/20 22:50, Krish Sadhukhan wrote:
> Patch# 1: Adds the KVM check.
> Patch# 2: Adds the required #defines for the two CR0 bits.
> Patch# 3: Adds the kvm-unit-test
> 
> [PATCH 1/3] KVM: nSVM: Check for CR0.CD and CR0.NW on VMRUN of nested guests
> [PATCH 2/3] kvm-unit-tests: SVM: Add #defines for CR0.CD and CR0.NW
> [PATCH 3/3] kvm-unit-tests: nSVM: Test CR0.CD and CR0.NW combination on VMRUN of
> 
>  arch/x86/kvm/svm/nested.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> Krish Sadhukhan (1):
>       nSVM: Check for CR0.CD and CR0.NW on VMRUN of nested guests
> 
>  lib/x86/processor.h |  2 ++
>  x86/svm_tests.c     | 28 +++++++++++++++++++++++++++-
>  2 files changed, 29 insertions(+), 1 deletion(-)
> 
> Krish Sadhukhan (2):
>       SVM: Add #defines for CR0.CD and CR0.NW
>       nSVM: Test CR0.CD and CR0.NW combination on VMRUN of nested guests
> 

Queued, thanks.

Paolo

