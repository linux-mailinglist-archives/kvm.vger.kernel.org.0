Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460D6601C10
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 00:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiJQWIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 18:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiJQWIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 18:08:53 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024647697D
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 15:08:53 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id z20so12019302plb.10
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 15:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E/4DPPSX+8EYQafccV5qoWyCAmySO2GlahoEOcD6yiE=;
        b=Yr6JLfOIBxsKsz9I81OiNXnHbvZe5DM4pgR+uEoYH9sosgPO2rEO9K4G+qgZcbCE0U
         dTjnOvWDqDSlsJfMdwq3OtHjSYCYd3/LLgOEG5kyfW2xJhshGpV8I3QhStzNjmwrCJ0A
         gYEc6qcNjEDJoOlg83VOzJm1C9FvslOZE52zCPRKmR5jIRODorBIp1kj6JrSJJzQZqQE
         I+X0qBQoHjnWHd6E2mDIrvtlcei3hjswxq7xnKtwkiV7YL4gFTCpNIkofc842YMEeDRj
         eOpmxZRx843MuJ2S2rHWvSqj1+3EhvznOxSzyBMMZpc+HrJVthRanCFpAx6bGuHwJ/YG
         7DFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E/4DPPSX+8EYQafccV5qoWyCAmySO2GlahoEOcD6yiE=;
        b=k8vQR8PuY3rQW8EiKk+yZrcHFuoc5jX5OJjgEzPV8HsGDUyvX+ozQPRiwX5ZwG9zqX
         mPSjIDbcbVPLsZdYt7VJltiqTWMxTET37Z0Z7C/WP+0/hcO6k0cBX8vqvRpx065jjQNS
         Yq3C1/M2h6mPHm+dBVrAgf1DpsFQs9FXSsfvFhFKPJ+DtypTm3Latb0shCg1DMXp+9so
         Z27A+bawcs6+qUew0HGAk1jjQcsPaJItPFEjG/mxDWs0cUhVBxR6j+nRgwuKBHEVH/5L
         KrRDcs2q7rihDIFMzZq37o4BMEFBOrCK/YyBAps+Q6PZ5l+7MWCejf0/1jhmGc4e+Fwe
         wvfA==
X-Gm-Message-State: ACrzQf2ZkSAitZKgj4LIO25gX4Z9KFqXmkCWyaikXhdrS3T3/g/cEYCH
        VqXALm+5zESuh9OGzTcHpn/peg==
X-Google-Smtp-Source: AMsMyM7OKbGy+gHYEZBmAhjYnTpH7SayEGMvYLH1S8U7VKh6K5NkPUXY+1ryx2Vy+ZsIUIHEmiPNNw==
X-Received: by 2002:a17:903:2347:b0:181:33f0:f64e with SMTP id c7-20020a170903234700b0018133f0f64emr14442474plh.106.1666044532381;
        Mon, 17 Oct 2022 15:08:52 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y17-20020a17090a8b1100b0020936894e76sm6659955pjn.10.2022.10.17.15.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 15:08:51 -0700 (PDT)
Date:   Mon, 17 Oct 2022 22:08:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ajones@ventanamicro.com,
        pbonzini@redhat.com, maz@kernel.org, shuah@kernel.org,
        oliver.upton@linux.dev, peterx@redhat.com, ricarkol@google.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate
 memory sizes
Message-ID: <Y03ScGUUCA1KwlLF@google.com>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 17, 2022, Maciej S. Szmigiero wrote:
> > +#define MEM_EXTRA_SIZE		0x10000
>
> Also, an expression like "(64 << 10)" is more readable than a "1"
> with a tail of zeroes (it's easy to add one zero too many or be one
> zero short).

+1 to not open coding raw numbers.

I think it's high time KVM selftests add #defines for the common sizes, e.g. SIZE_4KB,
16KB, 64K, 2MB, 1GB, etc...

Alternatively (or in addition), just #define 1KB, 1MB, 1GB, and 1TB, and then do
math off of those.
