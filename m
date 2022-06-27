Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDE155CB36
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbiF0J5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 05:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbiF0J5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 05:57:39 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DAE63F7;
        Mon, 27 Jun 2022 02:57:38 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id r1so7704312plo.10;
        Mon, 27 Jun 2022 02:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lxoRw2NzocC5cl5OT0cmp5DtPwfu2AsSjzuxrbc18bo=;
        b=ik7jWwIHFtvt+5uRZljDRamPqiEq6gj2NtjeqKj8DiVfWrZhVFQJNr8tx3YCshzVnk
         DcFY5Hvxw1XYJmQ5kgMNs8Ar2+owosOtWiK6G4vICTrl+cIYOy2I5dYASXh1Pqs/6UqX
         osiW/usM52hG1UEJU81fX9laLZIfqKSrfex1c9zulsJtRmZr1GAeyL+hSR/W2exPFFHt
         pOdm4qoEooQi+o8GJbR4KiJZqNXm+ukhwt86ZSXJwPomebL6szGKQ7lSeCq94ijPQP7W
         zyXi7ndlha3lngMnBTxjx8K/oj+fwIrkj9GSRofE2gQQ9a26flm2BFVzPOBFQqrZt6GP
         QINQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lxoRw2NzocC5cl5OT0cmp5DtPwfu2AsSjzuxrbc18bo=;
        b=tMqoZam1S1Bdi5gf76gqir9ZcOdzNDml12bP/6Waj3e5CTbkVYoFToFE9xT+xSDmG2
         bQAUONyaNGlk8qhQpCLExupxozRWSLJqEERaortFk7u9GOeKYvFtrBKFSknPKcpD3X3C
         MVScEtsE534FNd3Aoo7IdJmTXVpel7VIIPuz83Iq0C5s+nPX81VGKtuvk/JQAKthb6Cq
         w2omFxMuiPNp4Zd/BS8yvJNBD9a5LBoZGNDhZ9LHmd7XE3VX1ZuwmsheodPINihsZ9L9
         HvaBiQ887kKQCejGz/j30FxcZp/yLRSGoMU+OUs4/Xloy1WLRZBc3iWle6CINcT+Gr1W
         97Og==
X-Gm-Message-State: AJIora9l+tfca1e+0jHztI6rPr6MbT+e4gYUO6RTKriFdobtZh8Zll22
        xcUgP1HydNg3FkPt05Eoq5l+KJgKyiw=
X-Google-Smtp-Source: AGRyM1tiit+ZVbULeU9zKNCqYhhKW3z3YzZGRNN96K2uAnbTzJ/xS23sjTftQdJsIC+JUcD9jgm7Aw==
X-Received: by 2002:a17:90b:1986:b0:1ec:71f6:5fd9 with SMTP id mv6-20020a17090b198600b001ec71f65fd9mr19539478pjb.188.1656323858127;
        Mon, 27 Jun 2022 02:57:38 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id a23-20020aa79717000000b0051c03229a2bsm6813638pfg.21.2022.06.27.02.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 02:57:37 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 96D3E102D1B; Mon, 27 Jun 2022 16:57:34 +0700 (WIB)
Date:   Mon, 27 Jun 2022 16:57:34 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the kvm tree
Message-ID: <Yrl/Dhm2zbK5mF4o@debian.me>
References: <20220627181937.3be67263@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220627181937.3be67263@canb.auug.org.au>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022 at 06:19:37PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the kvm tree, today's linux-next build (htmldocs) produced
> this warning:
> 
> Documentation/virt/kvm/api.rst:8210: WARNING: Title underline too short.
> 
> 8.38 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
> ---------------------------
> Documentation/virt/kvm/api.rst:8217: WARNING: Unexpected indentation.
> 
> Introduced by commit
> 
>   084cc29f8bbb ("KVM: x86/MMU: Allow NX huge pages to be disabled on a per-vm basis")
> 

Hi Stephen and Paolo,

I have sent the fixes at [1], please test.

[1] https://lore.kernel.org/linux-doc/20220627095151.19339-1-bagasdotme@gmail.com/

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
