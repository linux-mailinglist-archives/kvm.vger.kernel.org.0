Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9575B78065E
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 09:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358190AbjHRHbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 03:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358182AbjHRHai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 03:30:38 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9688E30E9
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 00:30:35 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a640c23a62f3a-99357737980so70971466b.2
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 00:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1692343834; x=1692948634;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nu5vRU+Ls6TvII7Q0Vdpj5U5jSrG/Osoam5r9jWleL8=;
        b=lXKHqegRZrlMfU5dvc9HqWRFicSIRCIvlo/PdAjhqUmjfqRK1rz0adpwnl0+BLHqfn
         1K1AfFwDMb9CKR/arhqO7ELjP5UK17fL588gxsJVLPksFDvVvh5zbclm7dk+Y5dEVbqD
         OkY6nD7yxVXJPg1lvEf/rGgFusJJ0pa7IK6GkAHHqlau2FGtZQnSx3Y9bhkVG5LHelTL
         Vc8Qh/4+p7lwdGJZXi6opSR1jAXmg6TSJDUhy8sMGYBSLCb9TOK1r67D48WAIlh45SbU
         m2IUgviDZ0aQUlFQ5+AzfUuw5VTOrI0aRqhGBMnmuneYZxLM0jDLyR8cIbcAUnitT7q5
         176A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692343834; x=1692948634;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nu5vRU+Ls6TvII7Q0Vdpj5U5jSrG/Osoam5r9jWleL8=;
        b=VFgIXMSlWAFmBp/8eNLi15i0ioOnH6jEzU59AvKZBatYVwNA/TRZQeINfvyrBXfvoP
         MpBSjPlwwcCVzRoETsSmyT1kIxxneWtoEBs5HDtmxGCnSIaN7Qf5Urym0Wzem8IpzBe5
         ql+f0ktqVEW9KGkps2dwndY5W2Dwa7NXSog3UGD0+QHWRIRxzzH5k7pw1Qn9MSoNkpYQ
         UOweXFCe6obOvpT1OvFUhXrWSInZRySvzgQ5axhtmT8D6RJzP67nVlwLAH8wJI3qPGhO
         5JDqkpFvc3X4XmXZttCVq5Mrf35RL4k2uVMifabO0arnL3554f36wi3w16s4pbPZamZ4
         lk7w==
X-Gm-Message-State: AOJu0YxCtOc84MBz/3M/sjG0D/5YvfrcnYWGkeqC0yrd7DcGn5BfvEt3
        04tyhH0aqMaNke/6Ul00b+PHsQ==
X-Google-Smtp-Source: AGHT+IEsV5M/B1UbYyCeo0WYS5DT7wyD++pmpVV6vSVnEq/FsuPf4jkdM8SM0RY0TL9ZO5reeCNthA==
X-Received: by 2002:a17:906:10a:b0:99c:441:ffa with SMTP id 10-20020a170906010a00b0099c04410ffamr1431712eje.29.1692343834051;
        Fri, 18 Aug 2023 00:30:34 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id k20-20020a1709063e1400b00992b71d8f19sm838014eji.133.2023.08.18.00.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 00:30:33 -0700 (PDT)
Date:   Fri, 18 Aug 2023 09:30:32 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     Charlie Jenkins <charlie@rivosinc.com>, jrtc27@jrtc27.com,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        bpf@vger.kernel.org, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, peterz@infradead.org, jpoimboe@kernel.org,
        jbaron@akamai.com, rostedt@goodmis.org,
        Ard Biesheuvel <ardb@kernel.org>, anup@brainfault.org,
        atishp@atishpatra.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        bjorn@kernel.org, luke.r.nels@gmail.com, xi.wang@gmail.com,
        namcaov@gmail.com
Subject: Re: [PATCH 00/10] RISC-V: Refactor instructions
Message-ID: <20230818-63347af7195b7385c146778d@orel>
References: <ZN5OJO/xOWUjLK2w@ghost>
 <mhng-7d609dde-ad47-42ed-a47b-6206e719020a@palmer-ri-x1c9a>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mhng-7d609dde-ad47-42ed-a47b-6206e719020a@palmer-ri-x1c9a>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 17, 2023 at 10:52:22AM -0700, Palmer Dabbelt wrote:
> On Thu, 17 Aug 2023 09:43:16 PDT (-0700), Charlie Jenkins wrote:
...
> > It seems to me that it will be significantly more challenging to use
> > riscv-opcodes than it would for people to just hand create the macros
> > that they need.
> 
> Ya, riscv-opcodes is pretty custy.  We stopped using it elsewhere ages ago.

Ah, pity I didn't know the history of it or I wouldn't have suggested it,
wasting Charlie's time (sorry, Charlie!). So everywhere that needs
encodings are manually scraping them from the PDFs? Or maybe we can write
our own parser which converts adoc/wavedrom files[1] to Linux C?

[1] https://github.com/riscv/riscv-isa-manual/tree/main/src/images/wavedrom

Thanks,
drew
