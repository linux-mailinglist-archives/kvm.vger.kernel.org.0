Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4B0718DF7
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 00:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjEaWCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 18:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjEaWCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 18:02:07 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCD2121
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 15:02:05 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-974265a1a40so316341866b.0
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 15:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=streamhpc-com.20221208.gappssmtp.com; s=20221208; t=1685570524; x=1688162524;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z8eeVT9lQfqYQDRbZwP+cUlOL9m2gC6p9ms+5P8NhDs=;
        b=cxavh/8gs41qzpYEPE2LH6mmR/3lwS8X27dDmjffXEDcmGBActirHDUFa9FTrRequX
         ZaBimWq9quBGnudtwbOAqM4YFQbRQSqgYsUOaW/d3ENOBLUOlEOltqXsSN1kuryziEpf
         c/CbOgqBOnmicQKcFnGagvVtiPvHCi13Clrm5916Bnv17eX1S4vsMqSyIe6zzV/RPza3
         1crDuureHSEHFwm54fPLbELYamVkB26xNQlcffZL1PqoasQ7Abpsdn70Ttkwc8AqJW8Y
         ap9YTHM0RlBswFDNSXgdyCyUDiYpiwHvlhtRfy524nroQvHV+LfH+ngZA42F1ysPJL5O
         6jJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685570524; x=1688162524;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z8eeVT9lQfqYQDRbZwP+cUlOL9m2gC6p9ms+5P8NhDs=;
        b=dE0r2T5JIcBHXXUi6F3Cz1kQBoNp5iwFiXC/f0YY5eduduiq8HJwgc/NkBKas1IWgI
         pxqI7MbrF9szYHHjTRY3Ffk997Sh7wEkR61ZPnICbkvefH1boTYsIL/FljJubj/zP3FF
         zky2XnnZTEdgROpHLBvdztzBw1ruVUmE3998whs4E5E6IWhr9kgyt5Fh+9+sWTlMSbuy
         Opo/E8fGAnEzEEn/NSVn0oq067zHlovCu67jnJz9IhvurzipyGsCc7C36/pzTR/4tsaD
         kbkdaVPkaM3EP/GWMxV8LN7P/Sa6Nbec+kWlKPZv6SiKSACexK8/TKkyiQrz/rvcI61C
         3bcQ==
X-Gm-Message-State: AC+VfDwtT93pk8Q/KkYFjDMJ2vLJ1F1U1mqLRlEaQpVjDduMzC7FA8pL
        0X1WjN5VIHolP6DRHj/2qz6kak3XveEeHgfRBKE=
X-Google-Smtp-Source: ACHHUZ6opGGsxrjzDxEmHpD4/7OreBpNqoFLSa9fKicUZ9C5K5wyIrg6u94m+dHDkZIYgwTf+9FXZw==
X-Received: by 2002:a17:907:1c01:b0:96a:b6e1:66d9 with SMTP id nc1-20020a1709071c0100b0096ab6e166d9mr7405939ejc.7.1685570523887;
        Wed, 31 May 2023 15:02:03 -0700 (PDT)
Received: from [192.168.178.121] (dhcp-077-251-030-138.chello.nl. [77.251.30.138])
        by smtp.gmail.com with ESMTPSA id s10-20020a170906a18a00b0096f00d79d6asm9630435ejy.54.2023.05.31.15.02.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 15:02:03 -0700 (PDT)
Message-ID: <d645e19b-6325-7be4-4320-e989305969ad@streamhpc.com>
Date:   Thu, 1 Jun 2023 00:02:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH] vfio/pci-core: Add capability for AtomicOp copleter
 support
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
References: <20230519214748.402003-1-alex.williamson@redhat.com>
From:   Robin Voetter <robin@streamhpc.com>
In-Reply-To: <20230519214748.402003-1-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/19/23 23:47, Alex Williamson wrote:
> Test and enable PCIe AtomicOp completer support of various widths and
> report via device-info capability to userspace.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Robin Voetter <robin@streamhpc.com>
Tested-by: Robin Voetter <robin@streamhpc.com>

Kind regards,

Robin Voetter
