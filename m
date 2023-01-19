Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7EF674391
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjASUj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjASUj0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:39:26 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945BF8BA85
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:39:25 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id b10so3597705pjo.1
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0oOG7jEIMwMSVx98pHdeEIROQPcBK6yIk/tw6voPDoI=;
        b=eQq1m17VX3cHIz9yZrnQ/v0cBZbsJ6m2XPACyZlzNJMfxAY6cb6dzHyfPZdd0kkFeI
         eeDwr/atGfiEy9zqjTYZB75UtnkNy6rfmzMmw3P/boqYEAkTxymw3byakudCi7P3ql42
         BdXQIVEYttFRZgay2wbUMS9A4tmjSr2lU0QXdpDnTAXLjOsTacI+6KrBY+0XVSNmq6Vy
         rUNtjjAcSdXAhN/pVIf/JfpJbcocECic0K3suhgmFiFmOibfeNgxwYMT41t6XUmt0cfD
         6eP61Nab7yGnzjgeagFOLZICmVRQNLeFDV/Fg6rdiJE3ZUYoP4mBWSywulPSgH/K1zmo
         DiZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0oOG7jEIMwMSVx98pHdeEIROQPcBK6yIk/tw6voPDoI=;
        b=PYApmU7zX87+2NqhDR2hw8PXeCvbz9ntdxUbvqsheCUP8fIbEmwM137348+Tg2d17d
         IZb8DKd1Qu1GbB/Y1sjY25zYVW2a4wrivDokoi0yQQgxvVTMDT8hzvPkVNz9R4X1K4Q+
         f6fuKPd9kKQZ4fq1OuipNjq9mcQ9KEghmQEziAAQh51NbcBcRDUXfvJXKJDRFTtqyoga
         J7E+4p/HVG/SiHnuDLA0tD1dSL5Fog7TFRS9gWeX1f5WPzWy+P+KpaWhrmepW+exTa8b
         vlPNZGme+ackkbpM2W4J0B+RZmrOj6CK11IeI8KB5jVmEDm4ua4pvXmuMMBW4JMcwHkJ
         zL7A==
X-Gm-Message-State: AFqh2koBSy1jbJYAWIgBVpWr8RcyYNIMWOzCvhsL6V6gC8QP+Xf6Cmzf
        KmqEEj1MhTzH52qQ7bjyLQP7Qg==
X-Google-Smtp-Source: AMrXdXsQQJ19RcQtuy+vYTFBkQw+exlAbBeCBJoZhTTFR5JitX8AcRoUeRmtAmU86LN9Sto8qcgCXQ==
X-Received: by 2002:a05:6a20:5492:b0:b8:c646:b0e2 with SMTP id i18-20020a056a20549200b000b8c646b0e2mr57876pzk.3.1674160764943;
        Thu, 19 Jan 2023 12:39:24 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q25-20020a631f59000000b004cffa8c0227sm3914375pgm.23.2023.01.19.12.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 12:39:24 -0800 (PST)
Date:   Thu, 19 Jan 2023 20:39:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC 1/2] selftests: KVM: Move dirty logging functions to
 memstress.(c|h)
Message-ID: <Y8mqd7HUzXDnhXLV@google.com>
References: <20230119200553.3922206-1-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119200553.3922206-1-bgardon@google.com>
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

Please provide cover letters for multi-patch series, regardless of how trivial
the series is.

This series especially needs a cover explaining why it's tagged "RFC".
