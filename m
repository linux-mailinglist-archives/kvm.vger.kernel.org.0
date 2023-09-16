Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0B17A2EFB
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 11:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238693AbjIPJUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Sep 2023 05:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238928AbjIPJTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Sep 2023 05:19:44 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF1319A0;
        Sat, 16 Sep 2023 02:19:38 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-99c3c8adb27so372614366b.1;
        Sat, 16 Sep 2023 02:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694855977; x=1695460777; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zFJd7ltrwpbT4DSzaox+CxAOaYm6Gohr2EKr2+yB84k=;
        b=ZXERlyJhfCwHXLKCUOeGvzVRW8HNISFoXR/3xXltpAnH2JhXrCIM+Cj8eyxjOs/Y0l
         v6JX1FibC6wwQmCVONGiCn934jK5BvHh3Lk1xUmR8giNo0mfLgOXvehY0mrs6a1Jas1P
         qtAj9tqCJ6SXoKZhLm0cjGThXb2NGgA+judoQ8iVI2gZQoP7KfElWIpM8be6YCMJu1fA
         1WgktyjrZ/ADkrxSBrCevQvPjmHWPCXw/Ejj9mudCb2oj64/1hDOExNGNwMdjn4OgX0C
         BrwXWihBgSs1j+/MYogPkKuGr1twPFHSMuCYYYvVLTqNbj3tkPEcXlj5zfMcBdsUU54k
         +zSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694855977; x=1695460777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zFJd7ltrwpbT4DSzaox+CxAOaYm6Gohr2EKr2+yB84k=;
        b=dyc1r2QWDcVxud+ipbsJzQprxPxHy6NAk+vSuCBYjMGlrKlhA1SNuaLPBiQMEjVemJ
         lYltGm2aV7EJSRHE0SPNPAs33dGS18AS4/JLLwyqYRI1wvlkBezNNzMon3gk5whYgpAX
         8LORgOuyo4yqDv2F3BjOAjRsbOfa9knIA5OylsAJJZaRBKIfcoX5LSd+wrCWt7eYok73
         Tcxv9cp5Q3AC/rvemrMZtVPnxPqikjnmJkItstplQq0pej8Sq4fZ9UYnXCRbRHZuAzD7
         aLNWBOY0PItcrWv/w11vZqA77rcW18bikh9K5e+y2WnIo0N4z1Y6cmLzzSrclmp93Cir
         Hj8A==
X-Gm-Message-State: AOJu0Yz4PAA7qFOas3MQ8e18KAnBliqUjN0rL/PRMuLG4E4g/9r1tlVe
        HT+dtuqmohdbqJ/UG0t6KbQ=
X-Google-Smtp-Source: AGHT+IGy/x0Gdo4oedr1VhUKoxzWh+QhuIJZyqLn+KOrwgXWAd4adujQ9NUcmB6KBH8aH4xguBlWrg==
X-Received: by 2002:a17:906:5357:b0:9ad:ada4:bad4 with SMTP id j23-20020a170906535700b009adada4bad4mr3597691ejo.11.1694855977052;
        Sat, 16 Sep 2023 02:19:37 -0700 (PDT)
Received: from gmail.com (84-236-113-53.pool.digikabel.hu. [84.236.113.53])
        by smtp.gmail.com with ESMTPSA id p25-20020a1709060e9900b00992b50fbbe9sm3517591ejf.90.2023.09.16.02.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Sep 2023 02:19:35 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Sat, 16 Sep 2023 11:19:33 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David.Kaplan@amd.com,
        jacobhxu@google.com, patelsvishal@google.com, bhillier@google.com
Subject: Re: [PATCH] x86/sev: Make early_set_memory_decrypted() calls page
 aligned
Message-ID: <ZQVzJfXXg171DDiW@gmail.com>
References: <20230818233451.3615464-1-srutherford@google.com>
 <ZQRHIN7as8f+PFeh@gmail.com>
 <CABayD+fH+AVu1u+LAtpd4-vRO9E12tVajR9WdWMtr1x_McoO6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+fH+AVu1u+LAtpd4-vRO9E12tVajR9WdWMtr1x_McoO6A@mail.gmail.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


* Steve Rutherford <srutherford@google.com> wrote:

> I believe V3 of this fix was already merged into both x86 and Linus'
> tree (I think as ac3f9c9f1b37edaa7d1a9b908bc79d843955a1a2, "x86/sev:
> Make enc_dec_hypercall() accept a size instead of npages").

Erm ... indeed, and I forgot to mark the old v1 thread as read and then
promptly forgot about it all ... ;-)

Thanks,

	Ingo
