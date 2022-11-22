Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E27B63450C
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 20:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbiKVT6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 14:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbiKVT6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 14:58:47 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C3E8A163
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 11:58:46 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id s196so14980324pgs.3
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 11:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8wr/vAOyhG9MP3hDdO1FGjeLqngE8UVRb23mgHUhbTc=;
        b=fgaoW19nZrIPNgVfGeGl1uogFixm5vbuRBOEwpySC+t5eZjFg+saLkWWxRrMDxjst8
         yIE9O/00xwE0qEngbgDR8bPm8GxgnuP8VqeUIOGCOzesipqKycHFNvw7nGBU3WEEGfI/
         WuRzxnWuC0/65cxzI82JVOYWwcFEyUv8ir8s+QgZGKKKIJqOWqVKS1B2Koj1Q/YRtW1W
         ga7LtprS7NLNTUK6k45iNE5MPts8hJTkXyRKB/ImntYErET0REfYNhdcgyhrouLgLI4z
         qg6ax9q7cCNx2AGhn1QBK4bh/scgUZWU1V+Kec6vVZ4KcCHT/ziGUT5OBgGtlraueZ06
         umVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8wr/vAOyhG9MP3hDdO1FGjeLqngE8UVRb23mgHUhbTc=;
        b=Fgj2Uwvra/qXiNbB7ApENPU1qmudLk76jB4R00hIowtj7C0qo9Qilybb4QDuk/RIRH
         C/pEsHnxaWdRUb7FLDtEm0dXHBRDuj8poFxNZQgBA0T8e1AnblZKGbmp+UOdRlFjfbeo
         iWM8sPo4rE42Qan0yqN+wSoj64qqDF2KCzN8wh6isO4zlv0yZUbqx6DssxSarsYLABPV
         Urjb4iQuI/Izi8G0R9ZXl4C44Jqo/exaCyGLcUL1laIMYtuxEEFnurvYokw2xqr6nKY4
         cN5KCAxurFoGLsCftuYj2VcAVWFUoAekhN8ADUoarE7Nxcd+NYThk0jayzxA1GIEvKbi
         LcaQ==
X-Gm-Message-State: ANoB5pmlhxCaFkBDxdbLbPDnYK1CNWp5lZRDyViV0C3nfzbP1uDm1723
        4wkpKyJ118Jv+M4r20Br6ApOQ0M3ilDQdA==
X-Google-Smtp-Source: AA0mqf7TZzcsmBVMdr3EsKDMNVfiWkHpYNEywsRtITM4oVjNMcX4Zcf7PgsMX2de5BERIcO7b0x2OA==
X-Received: by 2002:a63:a0c:0:b0:46b:4204:b3e5 with SMTP id 12-20020a630a0c000000b0046b4204b3e5mr8329445pgk.351.1669147126294;
        Tue, 22 Nov 2022 11:58:46 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q9-20020a170902bd8900b00176d347e9a7sm12321594pls.233.2022.11.22.11.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 11:58:45 -0800 (PST)
Date:   Tue, 22 Nov 2022 19:58:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        dmatlack@google.com
Subject: Re: [PATCH v2 1/6] KVM: x86: hyper-v: Use common code for hypercall
 userspace exit
Message-ID: <Y30p8q0YB0+p1e+4@google.com>
References: <20221121234026.3037083-1-vipinsh@google.com>
 <20221121234026.3037083-2-vipinsh@google.com>
 <87edtvou0n.fsf@ovpn-194-185.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87edtvou0n.fsf@ovpn-194-185.brq.redhat.com>
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

On Tue, Nov 22, 2022, Vitaly Kuznetsov wrote:
> Vipin Sharma <vipinsh@google.com> writes:
> 
> > Remove duplicate code to exit to userspace for hyper-v hypercalls and
> > use a common place to exit.
> >
> 
> "No functional change intended." as it was suggested by Sean :-)

Heh, I need to find a way to collect royalties.
