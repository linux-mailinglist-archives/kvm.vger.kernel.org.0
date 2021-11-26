Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D948545EC8F
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 12:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239847AbhKZL10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 06:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbhKZLZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 06:25:25 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094AAC08EC62
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 02:37:23 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id y12so36863848eda.12
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 02:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IDuj4Ybus9S1ZZvYWlz66pjIeLN9AKktO+rSjYLBt6c=;
        b=g9SLNuAZOKnmi8tC9+mx+w9DhF+UMgqe3ELBocN1zNAMHC0XypdxLQP9CADP0sGnkv
         QatU4zywHoaht5+mVhry3Zru3gRXROOjLi86agdwR+C/Bj7AylfBkdqjrCFh5THF/+eX
         2qIWFXyMGJy0IyKG9UCLWGVSdhFDaI18QfMvcSGr2yIupicxppPeyBGscYMJcMdUKCcO
         7c/VvCBc97f7YoLxmviUFJgD+OOgmAE8Qhukg2LyXk/tiYCsBujCXgp8lstTYlJ0aAv6
         BL2Alb3hcjNranAciG7kZnXtrgFNcUYYklwfpvaZZ1L9Vaknjpy7uuz4I2JsU0WojSBj
         mQzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IDuj4Ybus9S1ZZvYWlz66pjIeLN9AKktO+rSjYLBt6c=;
        b=hlDXvmcaprnhxf0axfvXlwrinTSQ+mODXj7GFdG3HLAMA4PEcVX+D1WxI+ixgwVxyV
         wVoa/7Qj3rXcwirwOghr1JufkPIMnGgGVdz+ZO5dkU7l6MAI+I1+KG4+e/2XVrbhGng4
         8lCE3tMiy4zJ/FJC6NjE2/3ZiYmHTYQ+JZOF90+q8XpzkWM6mwi9qjIg7W3SjRETdMeJ
         BZlsQi6ZOIqXRzGPBbedR7lOxZrBOgyyaPGc3HxUphnh0vbzT7LpkHzOk8qGqWSUr8BO
         91vG/R9PeurExUQFHKLt2z2EMOLMEqS5XZqw0mA31HBJbsgbM4rcwDsgJ45lgxluPm7K
         EX2A==
X-Gm-Message-State: AOAM530Mk+txETKdEoZPYmgqSf3m6jLn4jkrRkNUf2EFBFYAjyraU3Kl
        mjXF/jZUvWPVPrxHC+8Dkps=
X-Google-Smtp-Source: ABdhPJy5tV7RKW7vxWN3pEvLUsRy2FwyQFL1ogVlzEDy4xHOGn6mk/s+lTqkfLzwZ7CzgvR1mVi2Dg==
X-Received: by 2002:a17:907:8a1a:: with SMTP id sc26mr38013567ejc.402.1637923041627;
        Fri, 26 Nov 2021 02:37:21 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id z1sm3513696edq.54.2021.11.26.02.37.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 02:37:21 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <68b849b6-1e97-996d-785e-43ad86641a82@redhat.com>
Date:   Fri, 26 Nov 2021 11:37:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [GIT PULL] KVM/riscv fixes for 5.16, take #1
Content-Language: en-US
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy0CZiBSdGaVrDWEeWe7PUXKpE4RLiYeCaEO2QTN3mT83g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhSdy0CZiBSdGaVrDWEeWe7PUXKpE4RLiYeCaEO2QTN3mT83g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/22/21 06:29, Anup Patel wrote:
>    https://github.com/kvm-riscv/linux.git  tags/kvm-riscv-fixes-5.16-1

Pulled, thanks.

Paolo
