Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD734CE80
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 15:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732070AbfFTNSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 09:18:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52230 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732010AbfFTNSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 09:18:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so3061397wms.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 06:18:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GCMRRsAPTDkb7BUWGSo1gQlzzv4GcqeIfZdRd482QY0=;
        b=WVSlMttIfl1mZr8tNVhImddS51kTisngI6Y5JM1RoILdhUzHF5z07qXKf/GzO1A2eu
         e46gXGvGasDSyAgcRvI9tYandAopOPi26Tq3Ova+Zcpic1SpAc5gdSdiHfbI37+dLEoR
         YrdssgglQHqaaBA/yVTPYNAM++jyhzFhQ5AujICPJhS1Ing/XpCcnNSlnt3dCp4EfL8e
         VXYov109oMqzhwmoIaPpvGjZlmrgR1CZ0+BvUMq5Rd9GX0GH+4Hl37OSgNBLrhV7Qn5x
         yofKQNJKGHxWucvbPgHLBlHNuErZTQdeHdUb/ECgEcrVr4JPwC67rVHvua+7QEG5xD4a
         dIEw==
X-Gm-Message-State: APjAAAXrgJUpB2M37zG1wXzprKgQL9jltv4x+10WowyF2tdeWVdUd79M
        nWv32iqvTT76t4fEa8M4ERxl89qb0Bc=
X-Google-Smtp-Source: APXvYqweONTr/NmXXg7LOIoADi9spcEwDT5qdS05x9J7ZdEgu/6X1XDcocFaHgy6VlFrOKfyw7BHhg==
X-Received: by 2002:a1c:e718:: with SMTP id e24mr2980684wmh.104.1561036714634;
        Thu, 20 Jun 2019 06:18:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7822:aa18:a9d8:39ab? ([2001:b07:6468:f312:7822:aa18:a9d8:39ab])
        by smtp.gmail.com with ESMTPSA id d18sm36768327wrb.90.2019.06.20.06.18.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 06:18:34 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: reorganize initial steps of
 vmx_set_nested_state
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <1560959396-13969-1-git-send-email-pbonzini@redhat.com>
 <87zhmcfo0w.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8ab81435-d94a-1883-a7e0-e2eba6a1ba68@redhat.com>
Date:   Thu, 20 Jun 2019 15:18:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87zhmcfo0w.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/06/19 14:18, Vitaly Kuznetsov wrote:
> There's also something wrong with the patch as it fails to apply because
> of (not only?) whitespace issues or maybe I'm just applying it to the
> wrong tree...

Yes, there's a change to KVM_GET/SET_NESTED_STATE structs from Liran.

Paolo
