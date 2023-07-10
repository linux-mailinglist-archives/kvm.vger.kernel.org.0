Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F7574DB7D
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 18:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbjGJQvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 12:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjGJQvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 12:51:39 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C878F2
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 09:51:39 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-665bd7fe2f4so5890847b3a.0
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 09:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689007898; x=1691599898;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lRU9KE0/UeG1sJBHq2OuDf9Y6hZBKDfbe6WNpwhFzK0=;
        b=buVV+QQk90iJgfUh7Kqt1d2+0obGf2JPxRXP4oJ586nGq2pFwHByr0UpziYonmHBKq
         pFpq8lX7kdAGGmFJdQNkWk9DZv4uReocJ3MD1Ba3CNsFdB01Wb5Lx0ieEvAxUEJdssn+
         MrFfgk/NpgSXWV7f06QJSDLXuINxy2eUOCK6hpOTOkGDg8gpXGli7D4XmJ80gJYBKZLS
         Ckg+NOslBTqeP+QGNLlh4kCH2vzEZZtWXW6gcX+IH+BtARZUteajxMX08hsbh3nHpKTl
         27dU3CYhVWWTB7g8DXpFctVDPY1es87ZGdvh8qhGUXc16drPYFOGETN/93l5g6ToJt5e
         lvqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689007898; x=1691599898;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lRU9KE0/UeG1sJBHq2OuDf9Y6hZBKDfbe6WNpwhFzK0=;
        b=T6crb2cZ49XU7iA7USJJd5svZxK2ZRfMSh8fc2m2Con6hscPVegGZOF8mTSE30rqLV
         kstyKoL/lZKP7ZRIrxTVyB0f+HWsxp4YK9nOO7E8SHqFEmenEeIJ94ZmnmrQdnpYDP18
         oRtZkk4Dd7s8S1nyjBQtXQ/XQiqqwjfcatxC+Pa4SiFjZUM4NcRkOS6L52EQ83b4CAol
         6t14xS/5EmKi2WWLedN+VQ97Y6iBYTahyIId+srY0646Q7E4q5UT3rdLdLpH6oQAYIOH
         ECVyyxNjFUKhwJ+eb+EiyyJDV6EId4GAMBliapv21hKFEIRIgKENf27bb9Uzt8Xju8cZ
         f0+w==
X-Gm-Message-State: ABy/qLYI3gqdMTCTcotpCdKb8Gw72B/OjZoF8U+P+eJxlBOe7njUy5Ct
        IXrk3nguFQrV8VkbMEtMaQTq6g37PEA=
X-Google-Smtp-Source: APBJJlEiMclUC3rKcbE6nvWWGzZrZRVFK1l2kRju/N4dQe3BNwUcZvWCE2tCe6uUD20BY/kyQMs+bYFzLYI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3921:b0:67c:a3a6:7a70 with SMTP id
 fh33-20020a056a00392100b0067ca3a67a70mr16686189pfb.4.1689007898532; Mon, 10
 Jul 2023 09:51:38 -0700 (PDT)
Date:   Mon, 10 Jul 2023 09:51:36 -0700
In-Reply-To: <20230706072954.4881-1-duminjie@vivo.com>
Mime-Version: 1.0
References: <20230706072954.4881-1-duminjie@vivo.com>
Message-ID: <ZKw3GIg9ZiXMWCsE@google.com>
Subject: Re: [PATCH v1] virt: kvm: Replace define function
From:   Sean Christopherson <seanjc@google.com>
To:     Minjie Du <duminjie@vivo.com>
Cc:     linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 06, 2023, Minjie Du wrote:
> Replace DEFINE_SIMPLE_ATTRIBUTE with DEFINE_DEBUGFS_ATTRIBUTE.

NAK.  I'm sending a patch to revert 5103068eaca2 ("debugfs, coccinelle: check for
obsolete DEFINE_SIMPLE_ATTRIBUTE() usage"), this is beyond ridiculous.

https://lore.kernel.org/all/Y3PPCHa9Yzi1sSnQ@google.com
