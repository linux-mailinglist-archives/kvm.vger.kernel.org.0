Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C20D4560A5
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 17:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhKRQke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 11:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbhKRQke (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 11:40:34 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA637C061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 08:37:33 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d5so12777881wrc.1
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 08:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i114e9uRd1kIShHMcLPbTfzNoyHa9kmAGHdcBM/C1A4=;
        b=NAJBmbg7S/T0URLnZVHp9Wjel+CfqORSJ9Rq9YmU7SQXkBJ9HP8jTzS22/lDhwpuMU
         ArFAJutKHf0DmS1VQzhyzQwZ9nvjrBurvpFNjuzaopYOsDRtgmyp8KyLVLP0TUz/xuqU
         Ju7mAu09MveysyaIFqnSwb9kWqK4jurcJTHKFTZs+pkgCkJCCHz32cqAn/gFz0ZB0V6s
         fHfNXKfhI93X69bd04xTxr0LxEcUtIz50JcH1ZkXlE0iIg/Nf4OoPHy5DOLT5jxa9XsA
         Hp1Jo4oxQRfxHNXvVkZw2Me+7cw0C1T+zYcXFN1bi4rx7a+FrONgci47VbL1s7n6wZ7Y
         dGRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i114e9uRd1kIShHMcLPbTfzNoyHa9kmAGHdcBM/C1A4=;
        b=yt4buG5MPf2s9wI0WBdn20f+9Vpc9UQZ64SB2Vl2rlumV62KzAoZJZPzoRLDWmqSJU
         t8f1wslOysVKLhQB8KqCxe8XmSuXe9vpgb0i2r/ozNNjodbrNU09bw5vIkpMkL4JkGdd
         ezDCrX5gNhpv5RwqOo9gx0dfrR8dkUBfF6K3w57TJ5bu8whnjpmLdA0GKeqv7CSiPeLP
         LyobvsWHSHTMyFhqXt08qwdiT6YuBfFr6yhnjBHroFjOG2s5wQj8AsBXoct1lCI2FN1E
         5rlEPny4viI4Xo2kNpNZaryhstuoa/XHB8VHzdHWr/+qY8X+ml6n4SxxEY2htTVBzoJD
         3/sg==
X-Gm-Message-State: AOAM530c7GJplZm3PhYOkUJ/cW7dNoc6wK6mZbRmlfpWYz4xfJoWXCv0
        6xALJshsLWzckxMEjsGgZFhBkQ==
X-Google-Smtp-Source: ABdhPJy0QcEBBWwuvxs+2GNe1FAHH2EKL3Du/NvZWWpji7tTeqjk0jCek1CESgmlhLAJy5ujVcIN9Q==
X-Received: by 2002:adf:ec45:: with SMTP id w5mr32365047wrn.183.1637253452368;
        Thu, 18 Nov 2021 08:37:32 -0800 (PST)
Received: from [192.168.8.105] (30.red-95-126-207.staticip.rima-tde.net. [95.126.207.30])
        by smtp.gmail.com with ESMTPSA id l21sm349990wrb.38.2021.11.18.08.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 08:37:31 -0800 (PST)
Subject: Re: [PULL 0/6 for-6.2] AMD SEV patches
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Blake <eblake@redhat.com>
References: <20211118133532.2029166-1-berrange@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <14c735d5-9b36-07f7-08f3-268ae05c3a04@linaro.org>
Date:   Thu, 18 Nov 2021 17:37:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211118133532.2029166-1-berrange@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/21 2:35 PM, Daniel P. Berrangé wrote:
> The following changes since commit 0055ecca84cb948c935224b4f7ca1ceb26209790:
> 
>    Merge tag 'vfio-fixes-20211117.0' of git://github.com/awilliam/qemu-vfio into staging (2021-11-18 09:39:47 +0100)
> 
> are available in the Git repository at:
> 
>    https://gitlab.com/berrange/qemu tags/sev-hashes-pull-request
> 
> for you to fetch changes up to 58603ba2680fa35eade630e4b040e96953a11021:
> 
>    target/i386/sev: Replace qemu_map_ram_ptr with address_space_map (2021-11-18 13:28:32 +0000)
> 
> ----------------------------------------------------------------
> Add property for requesting AMD SEV measured kernel launch
> 
>   - The 'sev-guest' object gains a boolean 'kernel-hashes' property
>     which must be enabled to request a measured kernel launch.
> 
> ----------------------------------------------------------------
> 
> Dov Murik (6):
>    qapi/qom,target/i386: sev-guest: Introduce kernel-hashes=on|off option
>    target/i386/sev: Add kernel hashes only if sev-guest.kernel-hashes=on
>    target/i386/sev: Rephrase error message when no hashes table in guest
>      firmware
>    target/i386/sev: Fail when invalid hashes table area detected
>    target/i386/sev: Perform padding calculations at compile-time
>    target/i386/sev: Replace qemu_map_ram_ptr with address_space_map
> 
>   qapi/qom.json     |  7 ++++-
>   qemu-options.hx   |  6 +++-
>   target/i386/sev.c | 79 +++++++++++++++++++++++++++++++++++++++--------
>   3 files changed, 77 insertions(+), 15 deletions(-)

Applied, thanks.


r~

