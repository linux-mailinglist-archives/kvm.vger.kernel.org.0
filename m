Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C4B46319B
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 11:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236427AbhK3K7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 05:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236333AbhK3K7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 05:59:05 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E93FC061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 02:55:46 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id l25so84716532eda.11
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 02:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TBy+9TPojyR9IcNcJKGKtFXISg8cocU4tXe8lu7WdFY=;
        b=Ye17OoiOkPMt5JrIbWrXPfjnjTUcakxiSbm9wIwIjseefhDVpILZDZACCXj1Lilp6C
         2P2dc6nccsO3t//ujxEUO2z4030R6duw69JzwsMVhfEA1F/XMoHF0kyfCTOEbT1XZT/s
         fcVVjuuk6WDbPVh0ogpBRCTux+xzTGYmAXTJzuMC7P08wXcJwF2sXzf4ICh3n/0+CdhR
         QdhvZ145vV9SDcamOiZWrIad+oKugjuQv/teuiD1jeXieFj3prCAKjG9c4sMWgaDziXu
         MXlwK0bazRfMYrfEpCVTd8LOxioPM5m9VYHbZoC4xzd9x/CE+2G3n9wEdmIJ/MlJU3PQ
         w/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TBy+9TPojyR9IcNcJKGKtFXISg8cocU4tXe8lu7WdFY=;
        b=gRDAaqOKDQXDTvX7rli3SJ2HdfESs0UuNpUGMfCsrRHMFKI65m/3S+zK6afrrrgk7G
         hwCSxWzeBmMZfgXucIMyUrxkctbl9YS0O+q3Z/Xqu+I3YfAYcwY7IR4Sk29hCgH52uq9
         68KFnyAQfqghG+Oxe9HDkwVHFMEzVRjdxT3ekMNO9Uqrne+WGUTGMPMW9PJX+C+oPAzq
         ncjSfibHZFrMt1iSUnoNrwzDt+A4DjM3rEU8t0uzy4g6S3E6qPwyDBxkv0J3a8mI5APU
         5DgavSDpZi/SvbHIHatFzK8d26aXMd3ytAV5FGLM8MhqnQIW9iv/W6rMdCJaPKJmAFlQ
         gGGw==
X-Gm-Message-State: AOAM531rp0AVpJdS6qsgasC6ezrqHxbiL59wpyT5PH1Rw3sqSZcMLOcx
        AT+bHpoBf1ZdKcL4m25lwVU=
X-Google-Smtp-Source: ABdhPJy+iNnTzTvxumzpvltIbPOvTsfWpbIcHYEaO99SRULvji4TN2AOKgvC9xttcAeC+lQp7/upRQ==
X-Received: by 2002:a05:6402:4249:: with SMTP id g9mr82083265edb.316.1638269744700;
        Tue, 30 Nov 2021 02:55:44 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id f7sm11010565edw.44.2021.11.30.02.55.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 02:55:44 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <7a6d3027-4ce6-87eb-b490-0f2f0d79655b@redhat.com>
Date:   Tue, 30 Nov 2021 11:55:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH kvm-unit-tests 1/9] x86: cleanup handling of 16-byte GDT
 descriptors
Content-Language: en-US
To:     Marc Orr <marcorr@google.com>
Cc:     kvm@vger.kernel.org, aaronlewis@google.com, jmattson@google.com,
        zxwang42@gmail.com, seanjc@google.com, jroedel@suse.de,
        varad.gautam@suse.com
References: <20211021114910.1347278-1-pbonzini@redhat.com>
 <20211021114910.1347278-2-pbonzini@redhat.com>
 <CAA03e5FX+C9BaN9VeJAVjLSN0_DknTv5PB0+Q_cmpk1t3a0uJg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAA03e5FX+C9BaN9VeJAVjLSN0_DknTv5PB0+Q_cmpk1t3a0uJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/29/21 22:46, Marc Orr wrote:
> I think this patch series was what was blocking the `uefi` branch from
> being merged into the `master` branch. I was just trying to apply it
> locally, so I could review it, and now see that it's been merged
> already.

Yes, Aaron used it in some patches of his so I took that as a review.

> Any reason not to go ahead and merge the `uefi` branch into
> the mainline branch?

Mostly the fact that "./run_tests.sh" does not work out of the box.

Paolo
