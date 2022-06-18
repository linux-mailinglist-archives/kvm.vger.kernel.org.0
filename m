Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54627550111
	for <lists+kvm@lfdr.de>; Sat, 18 Jun 2022 02:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbiFRAJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 20:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiFRAJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 20:09:16 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CE753A5E
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 17:09:16 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id u37so5417348pfg.3
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 17:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rmREuzW95waiA3DDpOBKbzOCl6/bO3/zBUhkj2WSq9I=;
        b=YCP800zP22Elf3Ylaojub23i9i+c4DqKeQkNx5RkzWlB2guxY5lWBKf48hfbmaVQ/N
         eYGU19hBcx/GbITum/oZ8SXf9PmopWlcqw6oN1dmbAxSd/hhTpZFCC15vFDIIj3BGP/0
         qvM1b6rK1d4jcutPEYVdVKRsphQhA0gcmF88AOdPZTKbsVXqN/63OoO/vXbqjvmxClro
         ddQiy7dpqMjtCcF0gkWPyZPF/Y64THzretyJqrXrL6lsiQzDYFKUdgoah4WnyM8iFglV
         VQAodr3sNg5DnUEiK0RF52Xp9/hR8JzLLs9y9rC6Rq2DBo+iYF+YA0KEL/65OkfsoXHs
         zwlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rmREuzW95waiA3DDpOBKbzOCl6/bO3/zBUhkj2WSq9I=;
        b=AgJ4VJnF3hWYoDzXkzHBlTvC/VhQfYnvXcJ6PKNsoG8HzSVSTcDc9iQpkiHjLU7pAF
         PwLk9WHcM0mG2Emokr2czf+5MjUb0t6OHW59CiEydzrVOalV7sZ8moe9hetaeGBSvYsL
         aZ3638A47N5WZdvus+1m8a+29d5KO2U547ty1Q0ZlxWJ1wol1fEINwYS7JiWg38YT27S
         686/gh5xmAGz2sBSiNzD0R/oXFt9IfJImRd0F3eubIznz0EU8L9dufrxUoiQHfW2V4tX
         6C3O5NE+apnYfx0m/2rNkLSMZAcFzqccBzagwAsjKZL/YOV+JsvG91I0ieQIat99vRMv
         8Jkw==
X-Gm-Message-State: AJIora+m+wptn+K61U0338ITvmJdpn3/bfKJy1ZjQuM/P7tmJudGwelV
        5MCjL4xGPYXjZ3NcimYKUdINk2pdKdgkpQ==
X-Google-Smtp-Source: AGRyM1ssehBTb8JKASbU9EaanhSrDN7Ob2S/Adon1xUDXwjcTBHM88tI85Trf31af1LqByg1k8MpIg==
X-Received: by 2002:a05:6a00:450d:b0:524:d95b:d51d with SMTP id cw13-20020a056a00450d00b00524d95bd51dmr6985967pfb.29.1655510955383;
        Fri, 17 Jun 2022 17:09:15 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id iw13-20020a170903044d00b0015f4b7a012bsm565537plb.251.2022.06.17.17.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 17:09:15 -0700 (PDT)
Date:   Sat, 18 Jun 2022 00:09:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com,
        vkuznets@redhat.com, thuth@redhat.com, maz@kernel.org
Subject: Re: [PATCH 2/4] KVM: selftests: Increase UCALL_MAX_ARGS to 7
Message-ID: <Yq0Xpzk2Wa6wBXw9@google.com>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-3-coltonlewis@google.com>
 <20220616121006.ch6x7du6ycevjo5m@gator>
 <Yqy0ZhmF8NF4Jzpe@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqy0ZhmF8NF4Jzpe@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 17, 2022, Colton Lewis wrote:
> On Thu, Jun 16, 2022 at 02:10:06PM +0200, Andrew Jones wrote:
> > We probably want to ensure all architectures are good with this. afaict,
> > riscv only expects 6 args and uses UCALL_MAX_ARGS to cap the ucall inputs,
> > for example.
> 
> All architectures use UCALL_MAX_ARGS for that. Are you saying there
> might be limitations beyond the value of the macro? If so, who should
> verify whether this is ok?

I thought there were architectural limitations too, but I believe I was thinking
of vcpu_args_set(), where the number of params is limited by the function call
ABI, e.g. the number of registers.

Unless there's something really, really subtle going on, all architectures pass
the actual ucall struct purely through memory.  Actually, that code is ripe for
deduplication, and amazingly it doesn't conflict with Colton's series.  Patches
incoming...
