Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F96431A51
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 15:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhJRNFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 09:05:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28850 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231167AbhJRNF1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 09:05:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634562196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MbqKh+ocsWx5WVLcHJZwNDE2rIoRehaxbUtlPRHh7fk=;
        b=EKYm/gW8hjCLq/eOPsPEfeLfGOGeiH3A70VGgu9gqhR2KHLzF/GaxdZ8VGPdP6RTttOTuI
        G9mdFWQh746UA2Xlxz/1HnORLoS+DdMHVswgbCy1/58nFhUmhE4pn+LQEC7IRrcQ1RH1h2
        qLr10f/kGvnjgrEwsuK03+kzF8BKXC8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-CCtIvp9oMNmMjtHfgA8SSw-1; Mon, 18 Oct 2021 09:03:15 -0400
X-MC-Unique: CCtIvp9oMNmMjtHfgA8SSw-1
Received: by mail-wm1-f72.google.com with SMTP id z137-20020a1c7e8f000000b0030cd1800d86so2051978wmc.2
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 06:03:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MbqKh+ocsWx5WVLcHJZwNDE2rIoRehaxbUtlPRHh7fk=;
        b=B5ygWVFLPyBk7refxdiADeTsT8YQ/b9MI+NbWZpdTdXZu1Gg/lwsaZO9l5NbsDo+fX
         c1S8K3zsGgdJbO8wmEFZ2yTaDh9oKONxMlmFeVQXibdsmcCVadT1911inG+1Hd2/5ic/
         AyzxLifcMx3Urfz5psVUhvuKDwRo0DF9CG/4IakVAROQ7wIvbK9voQJslxTQ7r5hb4dO
         +xyNwspCNa6g6aGaBG0bRnbhlPJJElsirXfPKOPJ1wkmfrf59Zd0kCUU9wUuUJFRoGer
         4KGEBAgnMYaC10da7aOixkU9y7jZ1zv7hb6zTHC5N3eu3g1E+bz3ZVoqAd44N2sIrgK4
         sJJg==
X-Gm-Message-State: AOAM530aVb5E7hDhgMPNS9p/wjaAPooJxIhyk+CXHMBJi73GZdVs1z/X
        rBugZFs8iuW0LPbHN8FA7lWu/5jPDKhka6GuwpAl0F+0FuHk8FiaqqsGgD0JvUxGBf89+UNYdJt
        ZJz6OSISTw6b6
X-Received: by 2002:a7b:c005:: with SMTP id c5mr29207892wmb.150.1634562189144;
        Mon, 18 Oct 2021 06:03:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKGrWseo2Kso/1wo1lrXrghvEjXbU1h2fq2TY4WEKcdurwFjg+8gtRAh9nmh+J+9nunIbHmg==
X-Received: by 2002:a7b:c005:: with SMTP id c5mr29207727wmb.150.1634562187753;
        Mon, 18 Oct 2021 06:03:07 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t12sm2044049wmq.44.2021.10.18.06.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 06:03:07 -0700 (PDT)
Message-ID: <337bafa9-a627-f50a-f73c-0e36c2282d55@redhat.com>
Date:   Mon, 18 Oct 2021 15:03:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all
 pages
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com, bp@suse.de
References: <20211016071434.167591-1-pbonzini@redhat.com>
 <5f816a61bb95c5d3ea4c26251bb0a4b044aba0e6.camel@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <5f816a61bb95c5d3ea4c26251bb0a4b044aba0e6.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/21 14:51, Jarkko Sakkinen wrote:
> BTW, do you already have patch for QEMU somewhere, which uses
> this new functionality? Would like to peek at it just to see
> the usage pattern.

Yang was going to post them this week; the way to trigger them is just 
to do a reboot from within a Linux guest.

Paolo

> Also, can you provide some way to stress test QEMU so that this
> code path gets executed? I'm already using QEMU as my main test
> platform for SGX, so it's not a huge stretch for me to test it.
> 
> This way I can also provide tested-by for the corresponding QEMU
> path.

