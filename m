Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3206E5C003C
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 16:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiIUOqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 10:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiIUOqt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 10:46:49 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A0683F0E
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 07:46:44 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id s90-20020a17090a2f6300b00203a685a1aaso6119461pjd.1
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 07:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ztWLVXP3h9niwgYbQKAG8t7JEVQ9iFhrbU9qhrHc0XA=;
        b=pmC/pRxGHpcv6n4VgYmOSUUBGqYOlORJCx2B4k5E1qlcaTmktJ6vlT+XhFGUIRHn7M
         s6oLDlwMtJColO9a04AMiGM7hucugliIXkSin7hZ0j8/yvLdG3tWEXHlxSfUXOuw7F1D
         FX/MfZKGJAiccqv06nOzcI/96+HHEyCarb7BoSt5sF5LxvU7sTbA+r1XZ+fXUsQZis81
         624DjyAOLYN/l1cAxo1fUySxEXvuWIKpRXJqwr1gzLZh22dUZxVryHj8ZtMEGKEv8RDt
         wEVATvMbe6hkM/JwsXKDxoLULEUxKBJ3A9ICGm5S+dKEbQMNi2rZEGOPCeRvWX/Awakq
         gAcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ztWLVXP3h9niwgYbQKAG8t7JEVQ9iFhrbU9qhrHc0XA=;
        b=4u6fE40Q0eQcnRZ1Df6EoqVh+RUYFzI4/ahUO0sDEmck4qDqHa0orREhCtwhOacYVm
         5NPbGIrZeL3YTmoGgFx3gCrWQeF6sqlyoM8WXFuOJotih7qBc84tk8sffLlIam6koOWg
         sw+Qj54DWzOx3iYRq0h+oCIUSfJAGbeKiMdMW7ED8xtcq1i1wssc/G9FSpWUjsT3uBRl
         BHmsFeSzDuHohzZ32krbZi+jqdKR2w40f4Y8pFXd9fe8RMxr9SFuyMshb0hdSVSkfv5j
         tKBq1KbpAp01pwI6OFMk6QRQsoWY5rFhBzrD2G2ltOhiXTW2AeFTrbacI+reIprcOfse
         V+ng==
X-Gm-Message-State: ACrzQf2/DkCyqb1ao6vKe4m1v4Oim1eLjE94i6fowV0z0hags1fIIP2A
        UumQfvPjiF6P9WdTD/syJGQURup3LlHfeQ==
X-Google-Smtp-Source: AMsMyM6JKaC+J9QXG1E1xNdWvFyy+4nMCBxJB2VbaW2TG9MjlP5H7WNKhSMbiTqu6AhO4diIA5EkNQ==
X-Received: by 2002:a17:902:b288:b0:177:ff40:19cf with SMTP id u8-20020a170902b28800b00177ff4019cfmr5170043plr.117.1663771603603;
        Wed, 21 Sep 2022 07:46:43 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x190-20020a6331c7000000b0042bd73400b6sm1990720pgx.87.2022.09.21.07.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 07:46:43 -0700 (PDT)
Date:   Wed, 21 Sep 2022 14:46:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM: x86: First batch of updates for 6.1, i.e.
 kvm/queue
Message-ID: <Yysjz3e8y4ij0l0a@google.com>
References: <YypJ62Q9bHXv07qg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YypJ62Q9bHXv07qg@google.com>
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

On Tue, Sep 20, 2022, Sean Christopherson wrote:
> First batch of x86 updates for 6.1, i.e. for kvm/queue.  I was planning to get
> this out (much) earlier and in a smaller batch, but KVM Forum and the INIT bug
> I initially missed in the nested events series threw a wrench in those plans.

...

>  - Precisely track NX huge page accounting.

Abort!  Abort!  Abort!

Please don't pull, the NX series is embarrasingly broken[*].  It could probably
be fixed up, but I'd much rather redo the series for 6.2.

[*] https://lore.kernel.org/all/87tu50oohn.fsf@redhat.com
