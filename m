Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52A1CE3D57
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 22:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbfJXUan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 16:30:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50986 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbfJXUam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 16:30:42 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 61D224E83C
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 20:30:42 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id q22so60677wmc.1
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 13:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=haTblbo+Af03iY/s9GymwcoW4+eaykiPlajvV0JsZEg=;
        b=EhW6OPUzZPvU4CX0XGPk9sJzvUQx7cOddkIWCqMs6hy6K1hQ2PK2tVgFlLQM6VaTvb
         HEwYdUIVO5MGduWybBcEh6VuPC41pg0VNneAYeNEJiookUStYHfelljyZqp+GON+Z9bo
         n2smXokrqgAdqxP8r0tzDLQTZVBG6PBsFXcxJcIrYRrWotDuyzbko36qvaYpZ1FlJiiJ
         ugpIDUi85nHWVDbCT/0UVLwI9ryLjXSP3329ytQhTQ77k+Q74kaTlYJUDuTT4TGk+Eia
         ZjIl5ZZuwnwoxRke4r0jJ6roB9uQg4bGmt6/0g+hyrt6JstVT2OPgaKLigeG9XQ9nAkZ
         v5iA==
X-Gm-Message-State: APjAAAXN6A4AvpkZWce4L96kUcd8OeYoZvUUQLcmpFNkm5RUb6exCjQG
        Vh++2yuoTfwUrVpB+EwbgO7V+n/6YLOZVa5CoAzy437SoYvOXt5NlUTwWJyZEndazmaqLMEspUb
        pvHp7JdnWGaPh
X-Received: by 2002:a1c:f00a:: with SMTP id a10mr180247wmb.89.1571949040720;
        Thu, 24 Oct 2019 13:30:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxtV1o64CoZasuItGugRrl5fFn/8EbKBTjOoWxXV0A1XnW43sAqydp/DB1CcxZVUHTbBZLfFQ==
X-Received: by 2002:a1c:f00a:: with SMTP id a10mr180228wmb.89.1571949040421;
        Thu, 24 Oct 2019 13:30:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:302c:998e:a769:c583? ([2001:b07:6468:f312:302c:998e:a769:c583])
        by smtp.gmail.com with ESMTPSA id x21sm4364627wmj.42.2019.10.24.13.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2019 13:30:39 -0700 (PDT)
Subject: Re: [PULL kvm-unit-tests 00/10] arm/arm64 updates
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
References: <20191024130701.31238-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ea7aa818-de67-4b48-5935-3644c19e1e43@redhat.com>
Date:   Thu, 24 Oct 2019 22:30:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191024130701.31238-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/19 15:06, Andrew Jones wrote:
>   https://github.com/rhdrjones/kvm-unit-tests pull-arm-oct-24-2019

Pulled, thanks.

Paolo
