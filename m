Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986D07CD1B9
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 03:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344361AbjJRBRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 21:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344266AbjJRBRE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 21:17:04 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CCB90
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 18:17:02 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9c6f9e4d2so52413005ad.2
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 18:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697591822; x=1698196622; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ff3/WN+dqgK2bapRw+CKP/76WdKRpkPEstJ7qsjjFQ0=;
        b=wDm0fAQapehdVqarQM0CloqqT9WOwoWhgUtUcGqJ9aJp6rM+qQdKTV1aWOrtByXjh/
         6h8T6TIQgz2dok5l2PwxSIr52XTPPOOhpOqcXZNpbTyGAN9V+GsTZrtTRcOrg3ogqxQ8
         DDV9YeHkKcZ64BUpFIz3VBpSEooaHeDb3L/17ZEtcrNgR+lFqfONSVwfA2e6wiXkeokb
         uY+Fp8W+N4ZldtmoIHpRQdN9OEFah2XzwO/N1MD17AtTlLDQz3UGpOaHNvKJgRdfOCiU
         nYVi94kcrXOdWsRIGsljUysPyaC6ewaAEaI7OAY/40MAiwl++Wdhc6cINADc9JHaGlRd
         yqXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697591822; x=1698196622;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ff3/WN+dqgK2bapRw+CKP/76WdKRpkPEstJ7qsjjFQ0=;
        b=u+vgHp1QMapLJK6Z6wuP79I9HU4tRddbB/aV2eGnlQhcODe5/tesiB1pqOCGRJ/077
         voITUQjBkKL6QyT9ZTvIDi7WcJ76ML3k0VFRrT5mzdQ+YNsZAn4JwO29qS/7nWMZ94Ea
         /Fe17Egc4D4PBjgPlJeGIU3kNN91XDQq1zVdEY9JnVlpkDvidvISpngGGPadxXh7KD/l
         V09feJaWztjzCDMy6rT4RdiigFqeLJ395tDl06k73xdT4rYnS8IA5M+Vu/gtgcJyA2B9
         nAtTij6RVkP3+eH1hqScsl7AB0mMWK3rb3u3s06Si2WFi+vl8zteZXSMq8haRto+EFJ8
         qI4Q==
X-Gm-Message-State: AOJu0YwhvEC9x2g75ayEqke1i0wGi+QYjpTptcyuhx4/K5aQTO4Vnuo6
        LYD5bDK25+RQRqj7wHmxA4qDNrK5XyA=
X-Google-Smtp-Source: AGHT+IGYrSfrVo5CHPXxQmT/hmNGiQr+iFqNLfhAmp4G4m32fUbgJ2BxIY12/9UygjlVHyKb/uePdNcJjWA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:4091:b0:1c5:78b3:6750 with SMTP id
 z17-20020a170903409100b001c578b36750mr72059plc.12.1697591822444; Tue, 17 Oct
 2023 18:17:02 -0700 (PDT)
Date:   Tue, 17 Oct 2023 18:16:18 -0700
In-Reply-To: <20231017232610.4008690-1-mizhang@google.com>
Mime-Version: 1.0
References: <20231017232610.4008690-1-mizhang@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <169759163969.1787364.18380341284671749615.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Update the variable naming in kvm_x86_ops.sched_in()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Oct 2023 23:26:10 +0000, Mingwei Zhang wrote:
> Update the variable with name 'kvm' in kvm_x86_ops.sched_in() to 'vcpu' to
> avoid confusions. Variable naming in KVM has a clear convention that 'kvm'
> refers to pointer of type 'struct kvm *', while 'vcpu' refers to pointer of
> type 'struct kvm_vcpu *'.
> 
> Fix this 9-year old naming issue for fun.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Update the variable naming in kvm_x86_ops.sched_in()
      https://github.com/kvm-x86/linux/commit/5a989bbead4c

--
https://github.com/kvm-x86/linux/tree/next
