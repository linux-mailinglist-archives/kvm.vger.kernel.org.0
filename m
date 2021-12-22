Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBAC47D3D6
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 15:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343517AbhLVOmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 09:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238818AbhLVOmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 09:42:42 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808C4C061574
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 06:42:42 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id f5so9572886edq.6
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 06:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4SCx1u92yOdiZfqpbVygAXYCPWLb/MCeg28SGP5n67c=;
        b=AQ7p3ltFnkDry5qebHeMGeKTgfAv3l1qUjZPipT3P1Ub/4oWi+Fu23QX+HfLynls7z
         fNe+IjYWFVbz3BsvE/eC1DDfXOA90nh7L6cz3tyCH2OHhD7w7RRrWP//PRcfWQ4GcIJ8
         gSQI4+tn6YRe60EauAZCcBW7xTn3yS8fGDsM4m9GzlDd1KQtSgvwOPal2nOTYcVjA7E2
         9eBej8P8OLoBILgnhwxVyIt+lvVEmA/suZaUvUUGnm6ONRQldNjwJZ0mZ8PoCB3bGrcI
         Znn0ZY7jxdB0fuly+AKtgiQfYY9G0eIgHHg/XibwZ3XzwQB/9G331Kh+oXmnxV6DpCxF
         q2kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4SCx1u92yOdiZfqpbVygAXYCPWLb/MCeg28SGP5n67c=;
        b=IRw3gIkaRdj6ngU4dlKgoxeglnf7V8Gy1eOrLG7ah/MwDL2Gb1WHmVSWz9ui9STqeV
         NesOEBVCbF9FuTQMC2n5oJ5Z8/rsJ5fluMo5+SHAIhV2JHSPV8305yU9gyVnnZS3q0/+
         tW5fOp/1EBOS1RbHYj9ZgTtBvTv/IMYt1relZIUYMWdFkmCEbt+Ngg1nAPd7m8U7K2mY
         CtUhbpx5G7AlzpysjFGyeg2cjFWxNPYK39+6gWOruiBGN7yVBlzIfMErbvN12h4u5dTX
         pJ2jMvwnxnGeOgYlNjf4N+o/Qav27eKj5PQsfzucv0R8EhFgJqkmIAoCA/WoOw1t2IxH
         V3cQ==
X-Gm-Message-State: AOAM530F3rsyCAaCDVEdIPLN1KJTg4eNYRkrxwlkeH9fZ1oJCGex2L0V
        cKf68fuytiJBt7Rjxkvh9dU=
X-Google-Smtp-Source: ABdhPJzvFZZULkEuSBHq7UYMxxEMjfDdIJAW/i0XhcatpeSyLmY1takIOGbNlQWv83JHIRydWwjJng==
X-Received: by 2002:aa7:cd75:: with SMTP id ca21mr3136995edb.242.1640184161122;
        Wed, 22 Dec 2021 06:42:41 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312::4fa? ([2001:b07:6468:f312::4fa])
        by smtp.googlemail.com with ESMTPSA id x26sm963313edr.56.2021.12.22.06.42.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Dec 2021 06:42:40 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <5112db0e-5855-0f6f-4e1e-0a7e07f1c7c6@redhat.com>
Date:   Wed, 22 Dec 2021 15:42:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Core2 oops with v5.16-rc5
Content-Language: en-US
To:     Zdenek Kaspar <zkaspar82@gmail.com>
Cc:     kvm@vger.kernel.org
References: <20211218072732.2681bc87.zkaspar82@gmail.com>
 <a0846396-7591-3c0a-a972-542dc41a28c7@redhat.com>
 <20211220184735.2e505055.zkaspar82@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211220184735.2e505055.zkaspar82@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/20/21 18:47, Zdenek Kaspar wrote:
> Hi, v5.16-rc6 works fine, thanks!

Thanks for the report and the confirmation!
