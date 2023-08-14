Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7488F77B8B9
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 14:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjHNMeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 08:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjHNMd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 08:33:58 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B300CC
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 05:33:56 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3fe8242fc4dso34716465e9.1
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 05:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692016435; x=1692621235;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=modwVgnyQO0tS2jyHd6PU08kHttePTsxsxzhgr3EUIk=;
        b=llnLhEGRWesHu0mfCdHlQp/v/UwuA752kTdGkPmdpkm1uwT6nNmNVTXiOVUfLB+4bn
         3JVNbRGgvVCgrZ1810E7/hQWuaXPiV5OY/VffUr9Wsfk+VwIsEkOFSyyk68vULYwovSV
         BH5Lxy/93EiHeldu97y6eZaZB/nCxSWtWrlmr9K920x7ugRErYdbA9uV5EvU35+bHkuO
         WKKjuGI9LR11TWIM4GyL1xCHYfhyxncqjCM16jVASN5g0usqLT41tFoFGqufM9/9di3T
         xSydNJmnTXDRwJFLhj9ubTYmX0UVs8B9BIAzuEsUCJzuR+XuFOLN/75j8bhwH2BJrLyP
         XKig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692016435; x=1692621235;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=modwVgnyQO0tS2jyHd6PU08kHttePTsxsxzhgr3EUIk=;
        b=KXqRkt4Au7dyzX5rOLbdeSZcw5drxCCq4/cB87sdpZHhFDmHlDaPeujok1v2OB3PV/
         abyN+ZKA0wR6Oh4pNddI++E3o4I/SR5BM1G20Y8K/f/m6hQBB7XIOLsoBSoWE/G8LJmx
         L/DiRcaNTwtq5Cc+eOTRYrqXnGRsRhbfmSbmum5WJBU3GAVk2QMVbw96r2SMm1r5FeiI
         3NYevA8PjlPlt+LkfTGpi+HVEJ4NMDaddslFkOzDnFqd1myyGx4nulKJNIxNPNqNw7yb
         klZTeiZ/4gYjbDs8Vs85h/DmUmqljiJD9w1uAAyPVzoWQOvc/FMwuvKrCcCuF1v+2d0R
         CKYw==
X-Gm-Message-State: AOJu0YxD6IaAkHDfsb5Fkqa8gjcNkrlKb9SLfQg5ISHSWJ9vYlUxHC+Z
        bOIQhwQPC4d3dxaHUnV5/QlCW+LUquACz1Oc
X-Google-Smtp-Source: AGHT+IFHP5qTZciV27J7i7dF8FIlUbM+Cre8sFUBkCkyQCAJrADn5jZgrubt2DJy+RqGiAlBWVpKUg==
X-Received: by 2002:a05:600c:c7:b0:3fa:934c:8356 with SMTP id u7-20020a05600c00c700b003fa934c8356mr7379368wmm.10.1692016434703;
        Mon, 14 Aug 2023 05:33:54 -0700 (PDT)
Received: from [192.168.17.102] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id n24-20020a7bcbd8000000b003fbb0c01d4bsm14217278wmi.16.2023.08.14.05.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 05:33:54 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <766425f1-1039-b4ae-1ea0-c0c44406fc74@xen.org>
Date:   Mon, 14 Aug 2023 13:33:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Reply-To: paul@xen.org
Subject: Re: [PATCH] i386/xen: Don't advertise XENFEAT_supervisor_mode_kernel
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        qemu-devel <qemu-devel@nongnu.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
References: <782b63c1f9c41a6bfa771789cde4b45644b3a239.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <782b63c1f9c41a6bfa771789cde4b45644b3a239.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/08/2023 18:08, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> XENFEAT_supervisor_mode_kernel shouldn't be set for HVM guests. It
> confuses lscpu into thinking it's running in PVH mode.
> 
> No non-cosmetic effects have been observed so far.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
> Only really cosmetic. Don't feel strongly about whether it makes 8.1.
> 
>   target/i386/kvm/xen-emu.c | 1 -
>   1 file changed, 1 deletion(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

