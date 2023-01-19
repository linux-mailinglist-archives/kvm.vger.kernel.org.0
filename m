Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59ADB6743F6
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjASVJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjASVJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:09:06 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163CD9FDEC
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:01:34 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d7-20020a170903230700b00194821e606dso1975256plh.7
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zw5XHSdwYPbm0fp0TclBtTN8u9Zr8yuuztvUTi0WKRI=;
        b=rz2jTetDAobZUB18QOYoAoDuWO1oaooqfr+ALIcgLSY++H3bS4OwwJZ9yTlSi9SKQ2
         RBFo3uuGPB7wrYfHeoZWhwhfubeqgfzPWEEKuzwKfo2jwCS81Z06v3LQLpXPg2KvDSPB
         ilJ56q1mL4T4NVvRD8/53nquF/J/R+zBrS83xTSNo/LAlURMIau9lO+XAZvjV/mdf00M
         KvJT0OVN7iSqslWbZJ7pNnEwD7rIhCt3V3EI8Z27lPp5HzFtuSQdJF2KCBEyQIxmGlgY
         lPvm/CdinvL3i28EzJzZUFZAyXcqAH4CUY+Dm7LKqTVjIaZq4dA3GOFO3GL/QxLXscY3
         7hHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zw5XHSdwYPbm0fp0TclBtTN8u9Zr8yuuztvUTi0WKRI=;
        b=VPMPAyKtqGi+y7uVHH9IynRrj6rQPu9l0j307VTM2+PWJgAJ9EqxtsMpZhmsiIIrlu
         l72BDBTEZC+Cawag7R+uRO09Zr61mv3oZwgabwyyUMBg1NST5Nmf8YnD6LdbIIgBnoHe
         iNHV9QSZq/mXoOjjdqakC1Qvhp/9itLWj4oRjAjvqIX3X3saE58/V6lDajMvqTyL4d7C
         5JXenlsbNnE3fiGp6fCzOXHZYQ7GNY1Tus5aLud3ADQ26t+Euci0yc3Ii5KgNkDsfaJT
         +ogDka5G8ehLJ67t31KBDRu8uLJxVAHNuu7SrFTAXFT/kyuwEj7HcnPaUyWQPnDY55nv
         0NmA==
X-Gm-Message-State: AFqh2kqmufTyIDXV/uHGTtG2MTiZsfXiywqUmjnJpgjg9N10M7sQLwIw
        lEjCFmxZO2VMGNsQw+yNi9POWAbbZr8=
X-Google-Smtp-Source: AMrXdXtAG/ncG+oLbzS6DEIZn7kaVGtAdN4NWsQFnBLiqciHUqejKCYDF00I9a9w2FvOfjcVAp5vcGXxtlQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:8a86:b0:229:3efe:7999 with SMTP id
 x6-20020a17090a8a8600b002293efe7999mr1226655pjn.133.1674162093583; Thu, 19
 Jan 2023 13:01:33 -0800 (PST)
Date:   Thu, 19 Jan 2023 21:01:21 +0000
In-Reply-To: <20221209201326.2781950-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221209201326.2781950-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167408851335.2365391.1673290599308678262.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Fix a typo in the vcpu_msrs_set assert
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com
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

On Fri, 09 Dec 2022 20:13:27 +0000, Aaron Lewis wrote:
> The assert incorrectly identifies the ioctl being called.  Switch it
> from KVM_GET_MSRS to KVM_SET_MSRS.
> 
> 

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Fix a typo in the vcpu_msrs_set assert
      https://github.com/kvm-x86/linux/commit/589713ee5f12

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
