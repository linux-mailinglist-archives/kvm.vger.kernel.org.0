Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A445160EAB4
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 23:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbiJZVNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 17:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233698AbiJZVN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 17:13:27 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F11ACF879
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 14:13:27 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id p3so14492294pld.10
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 14:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xYJ+m45W3PiSPjBd9LEfHO0usjErkAo8LpFVxcQCld4=;
        b=JTNwIJNqdX6xsaMAquJ/RyvwIOAss1sHbLxczWiFDH7SyPkZIbRbKe9FjgwTGkN6r9
         BIqjZTJlP858gEr5mn8K7gREoP8WBk7jgq+xB7Mo5TSFpWx/ulHvi+hTEteUJmqnTwMi
         4GlNNMFjKNbr814jxqxZBaimCaqPG45LGnV+ktBRz2oANGbRJi+PFOXoRtgehmtWyQEn
         Q8aKZNqDEbmEVjCFSqxqLaIeZE6IGORYNT/qIUu+52nFmxPk+F6jDMVdNS89roGBNyYC
         z0AEMAphhCvAGdZBtD2gWPIoLEg7/kxsz5PyS2nPTR3ioAo1lSRnuMZMt4OkbN5auhpo
         uTLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xYJ+m45W3PiSPjBd9LEfHO0usjErkAo8LpFVxcQCld4=;
        b=rNcQHaw+0ZxAg/mFQiDBSVvKAzigApiMCFxW2o4LiYjGCr+E8mgli6qwx2sH9M3XlG
         RecaL60sLbLfP8GmuN+aM8Fqm96iXtQ+exVcZ9M4cX8pXYpaqWZeFTzuDBAoXnG8Z1Jl
         Wy5jjimvTL05/8Gv2mvebqMFFEtoDnBSIvdVKsHVOlIzmowouyIv5CC5QrVDE+OjR7Ss
         KVvXpv2JXLBC692BW+vPpPTPHvTwffLAXAd3IVprcC5jeDWZoqyTX5OCHdhvScOAFae6
         EzLGhKYds6xfyDocQ/4La0NT8GccZqO42HnFFbJx4xqNlaWThZuhA+jyHmpOS1/L7ipX
         dKOg==
X-Gm-Message-State: ACrzQf0K6+ouKbXrOAjuEhXZZPTTqryQDdxw+R2WiZav/s1f8s59rTJv
        8t2hep01Y1bJ6HuUy+EGttTu3w==
X-Google-Smtp-Source: AMsMyM7fqNP71Fp2vS2h3uVbPwLs8Wyg9L0lD+UU3QcEuSjS9B1t/47uFCwYpYdsaYxDv2u6cty4Ew==
X-Received: by 2002:a17:90b:4f45:b0:20d:3282:e5e0 with SMTP id pj5-20020a17090b4f4500b0020d3282e5e0mr6394909pjb.8.1666818806568;
        Wed, 26 Oct 2022 14:13:26 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id hh14-20020a17090b418e00b0020a0571b354sm1479361pjb.57.2022.10.26.14.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 14:13:26 -0700 (PDT)
Date:   Wed, 26 Oct 2022 21:13:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v7 0/3] KVM: selftests: randomize memory access of
 dirty_log_perf_test
Message-ID: <Y1mi8l4YwG/FlaKt@google.com>
References: <20221019221321.3033920-1-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019221321.3033920-1-coltonlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 19, 2022, Colton Lewis wrote:
> Add the ability to randomize parts of dirty_log_perf_test,
> specifically the order pages are accessed and whether pages are read
> or written.
> 
> v7:
> 
> Encapsulate the random state inside a struct. Add detail to names of
> those functions. Change interface so random function returns the next
> random number rather than using an out parameter.
> 
> Rebased to kvm/queue to ensure freshness.
> 
> Colton Lewis (3):
>   KVM: selftests: implement random number generation for guest code
>   KVM: selftests: randomize which pages are written vs read
>   KVM: selftests: randomize page access order

A few mechanical comments, but otherwise looks good.
