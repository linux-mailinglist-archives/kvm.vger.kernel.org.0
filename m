Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFB31533DA
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 16:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgBEP0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 10:26:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56425 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726359AbgBEP0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 10:26:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580916406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RbjbepIUL1vCxAOKRoXzr+B1g/JIZ8wyixsAy1ctwI8=;
        b=Ka60L+hKfC1Cabtj6C5xGhVO+l75DMxydIS5XekDw2/sSB52sTiid8jjXfZQH/zuQOsFEP
        6xGa541//rTFvNEUr/s8tBhHLuWd2xuqZVWL6lSo/yYr3nE2UqMqmQY3lJzRphbQRlfb//
        eBSJD6/DvO/aMQlYc3W1po3Vqdw52s8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-Q1lXVaFBOEWdhXfETGN6Ew-1; Wed, 05 Feb 2020 10:26:44 -0500
X-MC-Unique: Q1lXVaFBOEWdhXfETGN6Ew-1
Received: by mail-wm1-f71.google.com with SMTP id b133so974291wmb.2
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 07:26:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RbjbepIUL1vCxAOKRoXzr+B1g/JIZ8wyixsAy1ctwI8=;
        b=dL8LjJ7XmejXvv1D8NN7ce94u4kY3W3xEdvESlGhiqsvhI30FPmNrNaMCAQ2zSQcLP
         6uEpaV43m5bIq6L+dDYZfNM/jaAzacQMhCEmH62g6QuDzoWSTuiHr26d9EB5HDf1PMrs
         sdh18Gd08Q8WlORBEllJoNBn/ffUVUURmcbrho+c8wgfc/6mQYrjc7Ps8oT3XimG9klK
         Qy2MxsTuCP0rxVX5C6ov3ZhroZdjhZplyddcoatYML7K0JwcycI9C7GscBVpgArZh0rC
         g8H3rCshPnyvMxBLvPW3tx+ucmOMsSTvih/BhBDBlkZ9CETeT6hLa9loNHEYjUIbZMfF
         tE3Q==
X-Gm-Message-State: APjAAAX1C6m+JDWkkeFjWAV1wy0dEzFH0kODva+K/IOw0FxEAtrS+Rud
        MO/PcAAc/jwKAm22ZHapfnqr8kaLqtogwkOJW885VB2VhsHpftD3JvXuru+YqAL0Mv28WoVyk/N
        Q2U5ronNCnWJA
X-Received: by 2002:a1c:740b:: with SMTP id p11mr6550835wmc.78.1580916403011;
        Wed, 05 Feb 2020 07:26:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqzDjts+wG8+KRTMesJoG7yfBu0UrfAHvgWRpvAU6HKlur2QlqQmivkLI4stFk/0pdHeK6ScQw==
X-Received: by 2002:a1c:740b:: with SMTP id p11mr6550818wmc.78.1580916402770;
        Wed, 05 Feb 2020 07:26:42 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id z3sm200426wrs.32.2020.02.05.07.26.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 07:26:42 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH] x86: Use "-cpu host" for PCID tests
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org
References: <20200204194809.2077-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <150744a7-5be7-8ed6-9eea-cc9c1b46a425@redhat.com>
Date:   Wed, 5 Feb 2020 16:26:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200204194809.2077-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/02/20 20:48, Sean Christopherson wrote:
> Use the host CPU model for the PCID tests to allow testing the various
> combinations of PCID and INVPCID enabled/disabled without having to
> manually change the kvm-unit-tests command line.  I.e. give users the
> option of changing the command line *OR* running on a (virtual) CPU
> with or without PCID and/or INVPCID.

I don't understand. :)

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  x86/unittests.cfg | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index aae1523..25f4535 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -228,7 +228,7 @@ extra_params = --append "10000000 `date +%s`"
>  
>  [pcid]
>  file = pcid.flat
> -extra_params = -cpu qemu64,+pcid
> +extra_params = -cpu host
>  arch = x86_64
>  
>  [rdpru]
> 

The main reason not to use "-cpu host" is that it is not supported by
QEMU TCG (binary translation mode).  But there is no reason not to use
"-cpu max", which works with TCG and is synonym with "-cpu host" on KVM. :)

Paolo

Paolo

