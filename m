Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0337802A1
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 02:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356698AbjHRAOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 20:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356752AbjHRANu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 20:13:50 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958233A95
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:13:24 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58caf216c55so29144267b3.0
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 17:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692317602; x=1692922402;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZrN8CACkPD49mtpVn/TQms8VBKTNb64Wh+keSHEtF1Y=;
        b=U6SVUYb6ccyzb7gz6NT2TfJZxt35YPL+qXPtvd+738WkHarmlOOiP3YbY0iYwiW/CG
         tFahaSlgqe/eSss8RmUgTU3ongwNzzWoUh8m0WEuKHy0bny1vF59n+DXAqTQ0RjNVLYt
         S++jY/SvTy2iUPicbeGEvOAaGCgbnU9sgMwahiHHj2jAbNMBKo7/4nZ2qgbQEBwfX5Eg
         1xBclXMRgwNj1J4F2qmaR9igsT/bVvS3by/ojZ4T3diUbyXZbC9XJn0q7Ax0a9LA7ONV
         4R0zAmVeV76Mg9Lry9Qhc2Y71Ls4Nwliv5D0h8a9IIR/zpYoe7cCLaMXcBG1jtERcD55
         TuvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692317602; x=1692922402;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZrN8CACkPD49mtpVn/TQms8VBKTNb64Wh+keSHEtF1Y=;
        b=PnLWoo5F9cLl71Nr7/CwYQvSCAP7oR+9PqRwrJFIJp6sgG+b7LpzrWKoUJbgFW3zHj
         uR/flOvGHsbhJGSY9FfxgqAlFmdHnws4UaQNqZcHDAz2/YmfzXI5MsCqJd5RteBozHR2
         JMifQ/eK5AZdWjUqsyMu3T/dRJCAq08u+7K1r/I0Uy/tMSHPhX0Y1hw8JyJSfv9N6UnH
         mfhhgbh4gLGhnDiIJh5Hf4OSa8PFQeiFPmLHFlyjz1NBR0bXENoOAOLgelUlSSP/dbou
         kaKX/PhVGizar+syyL+7uZ36obONr/dMQCTFoaUSsbyR0f9UPdNioLoRtuzs1etvF4LQ
         72GA==
X-Gm-Message-State: AOJu0YzQDf+hnQu7Amcdc4Cl4s/63gti3oKYsPfX6rQ84WX5SnBzwOqg
        /F2P7zJ0hhNxub85M9MRdH3Z8HbbYDs=
X-Google-Smtp-Source: AGHT+IHXIPHp0QqUv+jji4BC+lO+0Wy0N8xFpVzdMZhSpPdA9uMEF7BULCLnlDKLlUdETJhanF6D9UxgO8E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b50:0:b0:d29:958c:e431 with SMTP id
 77-20020a250b50000000b00d29958ce431mr75123ybl.1.1692317602280; Thu, 17 Aug
 2023 17:13:22 -0700 (PDT)
Date:   Thu, 17 Aug 2023 17:13:15 -0700
In-Reply-To: <20230810113853.98114-1-gaoshiyuan@baidu.com>
Mime-Version: 1.0
References: <20230810113853.98114-1-gaoshiyuan@baidu.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <169229730361.1239441.13713106806485531459.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Rename vmx_get_max_tdp_level to vmx_get_max_ept_level
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        Shiyuan Gao <gaoshiyuan@baidu.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Aug 2023 19:38:53 +0800, Shiyuan Gao wrote:
> In vmx, ept_level looks better than tdp level and is consistent with
> svm get_npt_level().
> 
> 

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Rename vmx_get_max_tdp_level to vmx_get_max_ept_level
      https://github.com/kvm-x86/linux/commit/7d18eef13622

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
