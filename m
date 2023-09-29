Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1294B7B2A4D
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 04:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjI2CWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 22:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbjI2CWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 22:22:33 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE3C199
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 19:22:32 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c61aafab45so103090275ad.3
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 19:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695954152; x=1696558952; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yf316/XBVsR2rQNYINbFH1RghlbSg1M9+4PRNq27GR0=;
        b=p/RwNQICuQErQpMcrhAXfCwwQPwLdS/m7+wrTFZtw0tuVksG5mwjDzTip9ddAJsEIM
         Fk/xnM5ZjDsBuIjy3E/fj0ZU/hErSHQeFEex9+kyswPUcBcSIMGBKaMJfrp8edXeX1E5
         OUSgMUfvml8w+9AVz1RzTFsW2bEDCYybd0fmbFFbrEjuoDIKWdSVl2UnnWJBKp7ambnf
         BVn76rdAEilUKPT/wToZnm7PC0Zzv+T8Q/TIndLLRknVfSi9J02iRyR27kxUWFgkBYnr
         cg8i2NLwUZEc0AjIk9VeTJSvyTUiHl3Ydg5KMBWx4cuQdwVMPnZD+zEjojHKx6ZFNgEy
         mLWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695954152; x=1696558952;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yf316/XBVsR2rQNYINbFH1RghlbSg1M9+4PRNq27GR0=;
        b=nBthTyp+KIOTAfsxBPX1h0iwRky00ntweHIQsYbT4Smivhxp813HvMBNdk7MsNwNye
         3yx7/0cZ8l25q1dw7YGcBZ4bpKapyMCyFwXDO8bK1e0HeaaCZTFAPp7Sz4XkEIyYpRl9
         nMlI2P19albRn5a0gQidXiOwq17ujkUK1yoBSjSak6M4n1SyCVYuacB2FHTxHqfi+6sJ
         Mg/9KqXsRfV6xNA5Ebll84C0yvrgtLFysPRHctoIM5RlyCNwY/nLM7mb6L8zDJfk8UBW
         dR+lQv2LL+7fUoSJAWPDuWjWjE0rDSyyxVNijPZoDySR2xhOBHsDeYli4xsKpSHqqbHu
         WuTw==
X-Gm-Message-State: AOJu0Yzd7B5EYwGhcob2yVHBQZ7KKSDzrs65+Zh+4uoFrtFBCVw9Evfq
        Pakt7WzSkRZ9NgPJNVZlz968mkbR1P8=
X-Google-Smtp-Source: AGHT+IGoCnhJr+jWjOXZIKjUlm/18Vs7CDf59VE0pa/+1DRGwwNlnGI+iJoyCFVb79rC5xZ6Afo79IEU3G4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:32d0:b0:1c5:7c07:e403 with SMTP id
 i16-20020a17090332d000b001c57c07e403mr37204plr.10.1695954151685; Thu, 28 Sep
 2023 19:22:31 -0700 (PDT)
Date:   Thu, 28 Sep 2023 19:22:14 -0700
In-Reply-To: <cover.1695327124.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1695327124.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <169595360998.1385400.14024912459890362663.b4-ty@google.com>
Subject: Re: [RFC PATCH v2 0/6] KVM: gmem: Implement test cases for error_remove_page
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@intel.com
Cc:     isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Sep 2023 13:14:33 -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This patch series is to implement test cases for the KVM gmem error_remove_page
> method.
> - Update punch hole method to truncate pages
> - Add a new ioctl KVM_GUEST_MEMORY_FAILURE to inject memory failure on
>   offset of gmem
> 
> [...]

Applied the punch hole negative test to kvm-x86 guest_memfd, thanks!

[2/6] KVM: selftests: Add negative test cases for punch hole for guest_memfd()
      https://github.com/kvm-x86/linux/commit/e2bbfd5549be

--
https://github.com/kvm-x86/linux/tree/next
