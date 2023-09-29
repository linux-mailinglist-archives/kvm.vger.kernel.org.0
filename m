Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5367B2A41
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 04:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjI2CJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 22:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjI2CJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 22:09:05 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C9619F
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 19:09:03 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d865f1447a2so18370273276.2
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 19:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695953343; x=1696558143; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iRifG0kMrpXqEfz+mDuKDe9tCj6ju9DW+Z80pWDEPIg=;
        b=Ql0HHBQLhgcpUkKbgk/2vuOqhG9q8eac3USq9Os02kpnxm2ipbpg2F6HSxUm/GTBXP
         5jpzHu18ITCCXOLOWOu7a1WrSu1ez+HYkUo+D6SttorHUIDm5C1DePH8IpFQflyELCGE
         bdm2vwmt8H5hAgRXzgk0uMqJ+50tE2C1ZzuHD/LxfbNNYEyq0TYcgnwINxGqvXDRf0LR
         fSNi6fYLA0BgZy4tdc5tTcvrTHgvHuUOTfY0urwc8ha/aIjJphk4E9BnvMuNoPwXqdXo
         BMSFY7vKiLxsHt8eLbt43Q2xjX6nn8NmiI5dexcUMHiLMImRSTTp3bMRgB6Z6lhkjArB
         pRBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695953343; x=1696558143;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iRifG0kMrpXqEfz+mDuKDe9tCj6ju9DW+Z80pWDEPIg=;
        b=Fp8hCwUT+wMIDSDbhA23WGo8zDwODtgD1NQK+a8UJdJ5hV7K94dy1AX7L/oTd6G0gr
         uuTnFvZQU5aGzwnJObeJx5vekVRgskvFM/NviR9oFunZ7RPZgbHWD9+PzdyjS7r/T4yV
         IfIVnLDhEWLmE7R997oXr4aKJYdhbwbUjwTWpLcTN4ABRinS4koz4oi/k6mOyahoqj54
         ZjASnNT/UhDRspX+wUqhNXfuFlHJ7MgVuV2EvRyXlmpEOqrIkoErj78OB9xgD0GYuCHN
         Hf8FZOWMFIcG+KqpOWPDZuj7l+h20IT+TqHGjcEsiaPKFjs78Q8yVc8OHP+CFmZCPJbx
         JGKA==
X-Gm-Message-State: AOJu0YwuVoCeKfW5xQVwyEuYTQMU1sD9mKpgU6Hr0ZtBMZ0cWy7tqiLX
        Akhubn+pU2XnnRQzaFF7nVjdk3rXgNE=
X-Google-Smtp-Source: AGHT+IHSABCyhHlqkH3QYwh23b9HPcWYdRzvnPf4l9PM6ESO2KCiEZOquFC+M7OxKxdHxatj23bPR+UdpeE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ad50:0:b0:d0e:e780:81b3 with SMTP id
 l16-20020a25ad50000000b00d0ee78081b3mr37853ybe.2.1695953343145; Thu, 28 Sep
 2023 19:09:03 -0700 (PDT)
Date:   Thu, 28 Sep 2023 19:09:01 -0700
In-Reply-To: <20230928173354.217464-1-mlevitsk@redhat.com>
Mime-Version: 1.0
References: <20230928173354.217464-1-mlevitsk@redhat.com>
Message-ID: <ZRYxvdmHpjxr3QKp@google.com>
Subject: Re: [PATCH v2 0/4] AVIC bugfixes and workarounds
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 28, 2023, Maxim Levitsky wrote:
> Maxim Levitsky (4):
>   x86: KVM: SVM: always update the x2avic msr interception
>   x86: KVM: SVM: add support for Invalid IPI Vector interception
>   x86: KVM: SVM: refresh AVIC inhibition in svm_leave_nested()

Paolo, I assume you'll take the first three directly for 6.6?

>   x86: KVM: SVM: workaround for AVIC's errata #1235
