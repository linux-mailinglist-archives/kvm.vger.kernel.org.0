Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DD21EB426
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 06:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgFBENF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 00:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgFBENF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 00:13:05 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9640C061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 21:13:04 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x22so152629pfn.3
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 21:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9C8sK7Z2iF5WZmXCdljq9UJarqXxzuQGuzldUteLfsk=;
        b=sahlaM7ti5bs8lO2uTOUjgxFq1xmKRy1UGkDnJlZ6nr/gikZ/+zAc8TCyyY68zNWQZ
         jX+TDQqahuET+Jbc0FGEijrGFiyWCo1r+Qkieo/eenHbzqmfnqf33Jb81q+oT3n+jQuu
         aaQfwZmUVV7W8WX5Xf0Zcr2nmz+w/zBKP1Ao4N5TvpR1KJ7uMxoHl+e+sLzi4ZQeRaim
         25EvTfg3OzrWSJj5ooe54Oj1QDBETXJsyMSRtK4WK87d3spTwLkBFsc9egGiSKOfM48H
         udQPuMDlUZ80K/wEDhFkXgfCjPnb8wTw9+QpeSengpfzDoxU8v0Zgu/y5kJ0DFhBK82c
         D7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9C8sK7Z2iF5WZmXCdljq9UJarqXxzuQGuzldUteLfsk=;
        b=nHqzqNR/HcR047lb+9D/ZltCsWJzxxnb/O00FxFIbHv9Nun0llfH+Ts21PMqXZBptY
         MmdCIBOYGYGksUmyrd23qODd1lQi9LCYtsayrocEJi4BNBGMuMFr+doBn+Y1DZJloksD
         tmlAI2FoSnOfHpVpg7l6eD3XVXwtBypvQwL2LnMOUjtccKaQP7EiOhSEYTz7CAa7aGnZ
         12S1P1zG23ZpCpEfGgbcsDuKhjGmHVUVyX6moi2Fvvb3u3HG8QllrjVsElNSFWDg3yXa
         U4AtH2w047NWQDRGoP0pvBtJtUEhjDpdsAD++sTsL83T5yeWs7truNTQ0qkGxa3W/Goh
         Tglg==
X-Gm-Message-State: AOAM531VuojwQT3GfdbxPfVrUoZLXuAOSLEI9IPMyQTqzMGxALz8Jrwd
        jgzBDVLyKYiCHUN/zHqjIGnPAA==
X-Google-Smtp-Source: ABdhPJxuproyx+Jtcb5T0D00dglHw9itroS8M9KLORXTfNi0jyEhrPfmuq/46Vk4x0Ks8dzkUc7hVg==
X-Received: by 2002:a63:6345:: with SMTP id x66mr21801616pgb.156.1591071184407;
        Mon, 01 Jun 2020 21:13:04 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id 67sm833902pfg.84.2020.06.01.21.13.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 21:13:03 -0700 (PDT)
Subject: Re: [RFC v2 15/18] guest memory protection: Decouple kvm_memcrypt_*()
 helpers from KVM
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-16-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <eed92a20-3e0b-76c3-3ed0-3b467f12cf52@linaro.org>
Date:   Mon, 1 Jun 2020 21:13:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-16-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/20 8:43 PM, David Gibson wrote:
> The kvm_memcrypt_enabled() and kvm_memcrypt_encrypt_data() helper functions
> don't conceptually have any connection to KVM (although it's not possible
> in practice to use them without it).

Yet?

I would expect TCG implementations of these interfaces eventually, for
simulation of such hardware.  Or are we expecting *this* interface to be used
only with kvm/any-other-hw-accel, as the nested guest inside of the outermost
tcg qemu that's simulating hardware that supports...

Anyway, the actual code looks ok.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
