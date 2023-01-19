Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2324267433A
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 20:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjAST7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 14:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjAST7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 14:59:06 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2489085E
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:59:04 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id u1-20020a17090a450100b0022936a63a21so6895757pjg.4
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B5RC0JCDgYdUsroIywgc8XQU1Tu7uE+FKQQ2XWStWtM=;
        b=pvzqvPdvRSqyyw4q0wPE6WsHR4Ylo3jfuVPJWlVPNXr7SLPiOQCwjgXWS7DO48szCL
         /vr+E/U7X2EknHt902weBcPyG1PQE8JR5/a6fqWTYt2jTC1HmAgRdNOkDB78wWHIGutd
         bK+HImhq6wljNHYpXj44F9fcogCm1NCexIHgFnW8Q9vrphCzQ4Up3Moy00Bhj0QNvv4F
         uJje7FniU26UeiSrhDYjGcbPhR3tVplG5XS4my720LmwGZFpfVQEhgwLPaSaU/qCXRxM
         eqtUnClaOs9ZO4CWsIMHfq3BTA+9VLTp1Hg/A/Ne1vYAMHh5rVcc2p2KO65nmfy3wAnV
         OJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B5RC0JCDgYdUsroIywgc8XQU1Tu7uE+FKQQ2XWStWtM=;
        b=W6m2e4MEdheweQ5fWZlBWJVwE97QkK22hV8IPHSLFGhFen+PL9KoEe60UWMwgtfIAz
         orBSEVUbVRlO9Wl0POk5BDWe8v+hRFoK6iExS17f5r9j6zYSelOK1MS9/3MVVq/YusaE
         wXigjkl/JkTjeDbqHNhq27QrcfvJcQGN81Evy65zgu+vWk95CYw9ui3w0hLWkAXOw1Gn
         iyhI46YaVyiunoU6sHq3rg5kSVFDue6r13qAJVDv6EIKcStuHFGRpeeY6DQr4Ya6RjDt
         slk2qr2yiJsI2V8IEyjT4CNzcBDNXZ/utXKqnymdLORr5y/2N1fwpBirmwKpdnloYtBG
         BOBA==
X-Gm-Message-State: AFqh2koteP3Sg7vPHvb3aIVgYoyBnKfGTDveJ1ZbEAVSYFz6rEUjnVWO
        +yKem7ocAJSaxEk2ZR3zIkeRB0KyvSirgxjI
X-Google-Smtp-Source: AMrXdXtQnqp1RBY/LzS1Q5y0HGB9F9nh0x0rQo9naQy9a+bT4Wj1az0Bk+w8g/3QrByKh+zM1CP60A==
X-Received: by 2002:a17:902:f312:b0:194:d5ff:3ae3 with SMTP id c18-20020a170902f31200b00194d5ff3ae3mr26735ple.2.1674158343386;
        Thu, 19 Jan 2023 11:59:03 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n13-20020a170903110d00b001925ec4664esm25459940plh.172.2023.01.19.11.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 11:59:02 -0800 (PST)
Date:   Thu, 19 Jan 2023 19:58:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     linux-next@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Add kvm-x86 to linux-next
Message-ID: <Y8mhA9NBzAT27sh0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Hi Stephen!

Can you please add

  https://github.com/kvm-x86/linux.git next

to the set of linux-next inputs?  Going forward, it'll be my semi-official tree
for KVM x86 (Paolo and I are still working out exactly how best to juggle x86).

Thanks!
