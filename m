Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824786D7FEB
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 16:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238360AbjDEOqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 10:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238439AbjDEOqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 10:46:15 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3511B6A60
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 07:46:06 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id f6-20020a170902ce8600b001a25ae310a9so15491399plg.10
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 07:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680705965;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c6YY5jnViebwbumm1LW1T58xP0On/rSmtcbnUTLfSdE=;
        b=Trr60HX8MAkEttY63RXr5W+jQ16bxIGh359BVTk7fl87mPLOfVOu5knVFkRxzmk581
         AysEpjSZpoGHtg1qwOM1XFBt6Ws2kmXJ8fsiR67ae18WNRHjmYpKMrPuerUSXimeH+LN
         s4maVelCLw8+F1nulzUwsrXFjrG9dc+mT9hQCRibP12IGFDF1u8Iv2xCTwCl9FmxssMv
         g16GlE+LLksnDQhwVfAzOltENagchhWixqToCI0nUh12rX8kqHZAEMWLLDWz87ZV4A5E
         +ybakDO396XjJ80i34jvABoSYgOpKovThTJZz54SZdfhVfapYGr3yeS0kcKdhklkarpU
         BX0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680705965;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c6YY5jnViebwbumm1LW1T58xP0On/rSmtcbnUTLfSdE=;
        b=GY/SDNW/MPl3bJ1PlTWVym6jyZHvtrwIwMlNs4cZ1QB0RWNo44mHISrxhuic6eKF+3
         iEcRxnQ2UmWzHW9SprsBEP8ORVHkMQ8+j0AH3SUxFQN3tZV/xh35Dg8fv7oMDmGpB6ob
         /1QA+1fNyRAbj0ie6Y/E72tbO+8ZHLxn3erDUT3wyiMjKD0Gvt4kCJn6Ap2uy7D21onY
         NwjK4j3s2mKpJv7ck4JBPAcnpXo0UF7JHNRimnIT/8d4sRjH8qtLRqknxAPKoLx2cS/g
         QGNeu4Nc7cQaP8DwKycYhawVzHklPSsaS4KtDX1LmooR/HL3SVt+lWS35VkLN8Cu2InU
         ZqCg==
X-Gm-Message-State: AAQBX9dvK6eJYtcAK6M+i+pgMjs6T5AdsO0GgTgIrd0iHgHBvDvI0B+7
        Ap+oW98bWddLOpRA7k949G8qYFnuRlY=
X-Google-Smtp-Source: AKy350bQEwhX+NYiI1DKV3FtjSzSQTH/+F6Ma0gFo7OUDRlzgln7kU7Z2k4t9XdrTO+SiON2FdGwJ4Ikzsw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e507:b0:23f:76a1:61fb with SMTP id
 t7-20020a17090ae50700b0023f76a161fbmr2397877pjy.6.1680705965728; Wed, 05 Apr
 2023 07:46:05 -0700 (PDT)
Date:   Wed, 5 Apr 2023 07:46:04 -0700
In-Reply-To: <20230405101350.259000-1-gehao@kylinos.cn>
Mime-Version: 1.0
References: <20230405101350.259000-1-gehao@kylinos.cn>
Message-ID: <ZC2JrJwKM3KrgNgm@google.com>
Subject: Re: [RESEND PATCH] kvm/selftests: Close opened file descriptor in stable_tsc_check_supported()
From:   Sean Christopherson <seanjc@google.com>
To:     Hao Ge <gehao@kylinos.cn>
Cc:     pbonzini@redhat.com, shuah@kernel.org, dmatlack@google.com,
        coltonlewis@google.com, vipinsh@google.com, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        gehao618@163.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is not a RESEND, it is a new version.  From Documentation/process/submitting-patches.rst:

  Don't add "RESEND" when you are submitting a modified version of your
  patch or patch series - "RESEND" only applies to resubmission of a
  patch or patch series which have not been modified in any way from the
  previous submission.

And the "in any way" really does mean in _any_ way.  E.g. if a patch is rebased,
the version needs to be bumped.  RESEND should only ever be used when sending
literally the same patch/email file, e.g. if something went awry in the delivery
of the email, or you forgot to Cc the right people, tec.

On Wed, Apr 05, 2023, Hao Ge wrote:
> Close the "current_clocksource" file descriptor before

Wrap closer to ~75 chars, wrapping at ~55 is too aggressive.

> returning or exiting from stable_tsc_check_supported()
> in vmx_nested_tsc_scaling_test


Vipin provided his Reviewed-by, that should have been captured here.  Please read
through Documentation/process/submitting-patches.rst, guidance on "using" the
various tags is also provided there.  And if you have time, pretty much all of
Documentation/process/ is worth reading.

No need to send a new version, all of this is easy to fixup when applying.
