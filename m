Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1422A00B
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 22:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404165AbfEXUp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 16:45:59 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36326 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390330AbfEXUp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 16:45:58 -0400
Received: by mail-wm1-f68.google.com with SMTP id v22so3162821wml.1
        for <kvm@vger.kernel.org>; Fri, 24 May 2019 13:45:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mx7/UI9Jm1N8o+CZmUOfiHnK1kOQ3K16dEGlWbDQvu4=;
        b=qL8adQOvKVv6mUMeii7T7zyfMLqyOwbOXzpFip3kg0UYz+A8K2MfmZlXxbdb89ISoo
         FJxsj7tsQ/m9JSuTl44UGp47SXRKh8NiKsKcphymsPL7jp8b1JVGm2ioDjkgmcQyrjGw
         DhcLwXn0ApLEA2MV2vjPWzSgFvwz1ut3YXrwPlxIfrTVDd10MzY9aZ0jMXcG+tP/en89
         RxuF9ly2z9iJBX/Irp8PiandDKEIar3wQWzNBAR4UFoPd6B/2l45IQBRwh/ibAKxfWxz
         86oyordA8B47d8e0U2xAjTqLZUuuT8XKM2SvuCriZq2LxPa3P/uEPUVdUWrbdIHuysfd
         8zUA==
X-Gm-Message-State: APjAAAWmV5E2oBbK9NN3KXOCs6fw4K1w4jBsxjiNdlcqpi9ty1tXf3va
        j3Oql3u1cVSwkJbj2x07fe5jvumGpG8=
X-Google-Smtp-Source: APXvYqxJ83uZdMSEPSw6n2yqxH4DHAUSilro/nLhvRdru9Hu/zOSo5muHXY3j4Boz/pBy1d6U3DQdg==
X-Received: by 2002:a1c:ef05:: with SMTP id n5mr1213237wmh.149.1558730756405;
        Fri, 24 May 2019 13:45:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4d53:18d:3ffd:370? ([2001:b07:6468:f312:4d53:18d:3ffd:370])
        by smtp.gmail.com with ESMTPSA id p11sm2914061wrs.5.2019.05.24.13.45.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 13:45:55 -0700 (PDT)
Subject: Re: [PATCH] kvm: fix compilation on s390
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1558725957-22998-1-git-send-email-pbonzini@redhat.com>
 <20190524202438.GE30439@unicorn.suse.cz>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <328789af-23b2-d5d6-2353-2e36e39c7452@redhat.com>
Date:   Fri, 24 May 2019 22:45:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524202438.GE30439@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/19 22:24, Michal Kubecek wrote:
> On Fri, May 24, 2019 at 09:25:57PM +0200, Paolo Bonzini wrote:
>> s390 does not have memremap, even though in this particular case it
>> would be useful.
> 
> This is not completely true: memremap() is built when HAS_IOMEM is
> defined which on s390 depends on CONFIG_PCI. So for "normal" configs
> HAS_IOMEM would be enabled and memremap() would be available. We only
> encountered the build error with a special minimal config for zfcpdump.

I see; I'll change it to "does not always have".

Paolo
