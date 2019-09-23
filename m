Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 790AEBB20C
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 12:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439288AbfIWKP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 06:15:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34340 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406278AbfIWKP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 06:15:27 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ED5E2C055673
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 10:15:26 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id n6so4615030wrm.20
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 03:15:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bK9h7pTx1XY/RyobhLerD+nYvs7a3zb9XOPbV/JaXjc=;
        b=cd+7kbX5SWb3sIzjsHy6fvJVFB8zFj+PPdDZhdkyTx43rqUQFQDQazp/3evKde/3KO
         4E9IX9+nxQTDB3SLJirL8qbGzKL92o2bmdP6PAH62hZUVqT8RbFLrn62ac6Qaa21bG2o
         xBA/SsNbC/INjXOxc2/TwTkvw+z2tx2Mxn9bFUHNF2GGXIyRJZ+SP3iY8rsRteHyBtgI
         BRKeuqtjR8B56hlhwZdBQquNpVcDmxLduomQhDPR2ScVG6OIk62g8WN8KPjN6Gecu/bD
         TZPSnP3tB9kyKx6y3ge8XkNkPlPNmHVXj1t757YQjcO3VZAM96AWBz/qKfW4Gp83KJFe
         p7uA==
X-Gm-Message-State: APjAAAXYUpjrYTpAd6P1IKHkgugbwguGr6Zsfb4fXm17ynzEkZVgGEnk
        mhzgWeB0vkG423xRGx7eFL3msumtMktOtAYoiV/pSrOQEtZajgcTcNFaywM6kZS0BsTmgS0DKcc
        C9LcyWHoeQEVY
X-Received: by 2002:a1c:7409:: with SMTP id p9mr12906727wmc.162.1569233725614;
        Mon, 23 Sep 2019 03:15:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyz4lp9WKEtONZnQggsXsYyKnvfZ2mN5QVqBU+LVkeipi/oOtTdC4E2TBrDZ/yu4WyQdKl6Cg==
X-Received: by 2002:a1c:7409:: with SMTP id p9mr12906710wmc.162.1569233725398;
        Mon, 23 Sep 2019 03:15:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id 189sm22794912wma.6.2019.09.23.03.15.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 03:15:24 -0700 (PDT)
Subject: Re: [PATCH 07/17] KVM: monolithic: x86: adjust the section prefixes
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-8-aarcange@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2171e409-487f-6408-e037-3abc0b9aa312@redhat.com>
Date:   Mon, 23 Sep 2019 12:15:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920212509.2578-8-aarcange@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/19 23:24, Andrea Arcangeli wrote:
> Adjusts the section prefixes of some KVM common code function because
> with the monolithic methods the section checker can now do a more
> accurate analysis at build time and this allows to build without
> CONFIG_SECTION_MISMATCH_WARN_ONLY=n.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

I think it's the opposite---the checker is detecting *missing* section
prefixes, for example vmx_exit, kvm_exit, kvm_arch_hardware_unsetup etc.
could be marked __exit.

Paolo
