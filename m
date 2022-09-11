Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41C85B4B5B
	for <lists+kvm@lfdr.de>; Sun, 11 Sep 2022 04:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiIKCvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Sep 2022 22:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiIKCu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Sep 2022 22:50:59 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556F331DC1;
        Sat, 10 Sep 2022 19:50:58 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id f24so5419230plr.1;
        Sat, 10 Sep 2022 19:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=WOfUBmdbsodFIdF1n3FF4SIyEmSqFy1s8LSqImxsRWM=;
        b=nlJtZSZEhPJWcaLLK1L8Z+VRzHUljkNLpYXD8KRtpuPPQ6iRxm2HACBdcyt7Aq6Fkb
         spK6H68e/roRUpgBsjulj2U5gDlC9QluMRDO4q6bx7kM2fVuIIpKGzaAfEiWpn1E+Fkw
         XJxzkucYJW3BIxuhnxgcwxswjdInlc8/i2qgVkwK2CDyuQgu2GKFnI7LVm0jVdyXikzV
         h4gp8GuM8Q8sj2GWGpL1YNX5zgZAL1B5HbkfCLF5Y+4ZnVrCRbTV3zm3Geg9Q5f1l10b
         2ornV0vei5t7/vbo2yqi9BK3EfdB2EoGSflNhNFXEcm0M2SzFaZOSXX+lOhClV4hal6/
         Kvcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=WOfUBmdbsodFIdF1n3FF4SIyEmSqFy1s8LSqImxsRWM=;
        b=lqL5Nn87K4+ZhmWxVzH58zJ5tWeTgHk1b6L0m4w8gS8Yj4Ncm1IITfSMeVQjsGGond
         gVsYSwxkT0vXDI43hxmlUnH64RgctUlsK0SwZi/cSjWK+BDNMXlVGC+I1/OwpAvXZEjz
         nudkvmp34lJmWWfbjfeR3lOy1r0jK1rGrL0f+TdTGEdG8nN8kwfIWSzBBwkk98gFHMRD
         lmwOon844YHRL8HAlVaBjFwUBlSeEH8XNdgihVHdSYZ6WnCd5knTmpSsGXP37vKZw6xm
         wNHHs1URuUkDsRqp5qC6yeNZoKKhMnkZdZHan81l9U9U9XbpZyeqblSYxyIaxHfAVUW3
         0kSg==
X-Gm-Message-State: ACgBeo1QuU8vuP0ZP7R+tpMyUoLAmKNRq46YIkMfCSpZPalb3FeAhKw+
        ePVhOSHYJ0ZKyr/F4cezYoU=
X-Google-Smtp-Source: AA6agR6E781URqVLZUSymEJO/4uB5VIkLpGehxnXgU9n+4dqZMrwK1j7/AMV3riCoURT0xk5HLJqqA==
X-Received: by 2002:a17:90a:9295:b0:202:582b:1765 with SMTP id n21-20020a17090a929500b00202582b1765mr16777561pjo.99.1662864657781;
        Sat, 10 Sep 2022 19:50:57 -0700 (PDT)
Received: from localhost ([192.55.55.56])
        by smtp.gmail.com with ESMTPSA id x5-20020a628605000000b00540d75197f2sm2493486pfd.143.2022.09.10.19.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Sep 2022 19:50:57 -0700 (PDT)
Date:   Sat, 10 Sep 2022 19:50:56 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     isaku.yamahata@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: Re: [PATCH v4 13/26] KVM: Add arch hook when VM is added/deleted
Message-ID: <20220911025056.GA873583@ls.amr.corp.intel.com>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
 <acc9a44a5626fa8d64690f3f6fcca6e85f6536cb.1662679124.git.isaku.yamahata@intel.com>
 <YxrYRKeU/AfCVJFO@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YxrYRKeU/AfCVJFO@gao-cwp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 02:08:04PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> >+static void kvm_del_vm(void)
> >+{
> >+	cpus_read_lock();
> >+	mutex_lock(&kvm_lock);
> >+	kvm_arch_del_vm(kvm_usage_count);
> >+	mutex_unlock(&kvm_lock);
> >+	cpus_read_unlock();
> 
> kvm_arch_del_vm() is an empty function now. I don't understand why
> cpus_read_lock() is needed. Maybe add the lock when you fill up
> kvm_arch_del_vm().

The next patch populates it with on_each_cpu(hardware_disable_nolock, NULL, 1);
I will move adding lock to the next one. Or revise how adding arch hooks and
populating part.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
