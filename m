Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E600978028E
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 02:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356534AbjHRAKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 20:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356629AbjHRAK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 20:10:27 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD86A2723
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:10:08 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-68877684da1so507054b3a.1
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692317408; x=1692922208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fdUhnMeI2SfYPV2NlpCfXD5rWcFnSl+BAXrYVHCJdIM=;
        b=ORLrXrom4GzIV7Y1Q08Jhn+Pr5RxSzFBBT5XxgyxIE2lmUyayOzMH61hxBuZMGB+3f
         444dObtxgmjhKJRF7xeqOm0/aDRRqJlNXuBlF0S61HqMnQyxM63cZa0TUhNj1mqFYC7l
         eEkKlzHw/kpNNnGyQWHa0M+egrv5q9jRf2xN185GS9HOmuDkzpk3RhnUIu/FdqhruHgI
         1fCiRy03Ap/curQ6n1pl97tQgFyBRD7t6eZ2SIsgX6rKVZn15m2ooyxU0VI2ohXJGY9h
         tEhft1tX+mD12ZDbymYkZBWWeEc2j5GVAjbIkZAs8JyoH6nFX8o/MeMzbFlWXbfwy0fP
         JFDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692317408; x=1692922208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fdUhnMeI2SfYPV2NlpCfXD5rWcFnSl+BAXrYVHCJdIM=;
        b=LxFUoB5uf3zUtIhFmeP+frsHuigXoqStjkMCnfdXavnnWLEc9r+MQn8VM+qREc5RvW
         wvbxNMkZoYyjl7W0s8wWXuX2kIvXAf4AYp8qa5RrmjeoEFp9QISvA9rDC5py34wDXa00
         CJJ1pbRVv6oA4QnlLpdF7jDD6/+fSivA4E4Nxn7mfkpYoFUGi14YCMOVLgdkZXaecIF8
         asLeJYhegj3nciUzg8ivHCIQEE1/rBo5HgbR04J5C8DVwM20xOLofMsXfvqi3Rr4WLsc
         sqect8a5q/vwAHtMKUbWwWQghlcdZzLkcQKVPUuDgO9tOQuYM5R1zyepRhvnsBGVk0mF
         Xwsw==
X-Gm-Message-State: AOJu0YwxmrPltzd0q25WZ+hPPSx0NfbzNMvQ81qeCXEVleubk28L1Nj+
        tN+ZPWtYFl3cY8inGNXCzl7Rx5gXUYY=
X-Google-Smtp-Source: AGHT+IEgGOlXQUnxqod9bH+lOY7YRHq6fNsH+0CTqipjhNZPsoGYU5TlySzNVrIVO7GqHvRoYW2PQU2hZ9Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:180c:b0:686:2b60:3361 with SMTP id
 y12-20020a056a00180c00b006862b603361mr561834pfa.4.1692317408274; Thu, 17 Aug
 2023 17:10:08 -0700 (PDT)
Date:   Thu, 17 Aug 2023 17:09:20 -0700
In-Reply-To: <20230807094243.32516-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230807094243.32516-1-likexu@tencent.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <169229705567.1237240.17512589518406914182.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Remove break statements that will never be executed
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 07 Aug 2023 17:42:43 +0800, Like Xu wrote:
> Fix compiler warnings when compiling KVM with [-Wunreachable-code-break].
> No functional change intended.
> 
> 

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Remove break statements that will never be executed
      https://github.com/kvm-x86/linux/commit/765da7fe0e76

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
