Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DE759D38A
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 10:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241977AbiHWINW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 04:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242510AbiHWIL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 04:11:27 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541D6E033;
        Tue, 23 Aug 2022 01:08:34 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id x14-20020a17090a8a8e00b001fb61a71d99so1296657pjn.2;
        Tue, 23 Aug 2022 01:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=rxqK6Y9ADvrz5Qb+wgm4oP/mkFK1hFUakcQeyZkdrjg=;
        b=qa9kpU15MBZeI3ijyNK+ezq/HuCWZTPrm8SqDeM3OhmYMHlEIsxRQ81auUqgXa5sMk
         mSPVHEtY8NIBKqYxWij27UCrey7fmy2dFAi7PCbv6LG20nhoh4hOfa3Vh7qnxMl3d0TG
         FSEn47px272RJY08U2c2gnFCw7LVrAgwXRx5nhKPyAZuOmTZNSM/bCbOrF+x39b1MqXP
         eEk7ISR6NhbQn/pxqsF8GF1G2PpJITJN+NaU6ZDIqxQ/+akfKBs/DuJY7WKXIy1g2Gj+
         JXM2c51DUHfA1hF2pbaDkXRldSoM2MjQ34wC6vcskU22oS5edk4m2hxXuNcL8EaSSrRX
         9SCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=rxqK6Y9ADvrz5Qb+wgm4oP/mkFK1hFUakcQeyZkdrjg=;
        b=kWodTwXudlVoVx6hSRkoM2gJtMKZwz8vTFw8y2MDXm+jeGZe7++045RgIOX9DiEd55
         xatckscbLVC1Ysh0Lj52IQIT6FDuPZZeFtJmJHJVaIpEFEXOe4wYuA2D2Xcz1QwHSNEZ
         07BJKHwMSUB2u8Wb04TdeW+39wburX8xOUtHS2c/z90L9bTdyrj3qiL4Z95DOc3DfZsz
         bImRs+SHGjZVA5Mv2Ns8NHBrKOxCK4gdXePKQzhpwUZWnN3cDyPOYwk4P3/kknoy6cow
         wcOBcXpoeo7PU0O6eRYHWbJPNKBrvleQbwj3Ed2+PDuLoByzUCKoEKJR+9SUG5VGOwXb
         TlKw==
X-Gm-Message-State: ACgBeo1KLxawv+7bWy9yAeIpm506aJnFiE/bANdzGg1rZH1LxlBYrzcl
        KJVcskYLlVq8z//BYaxXKhk=
X-Google-Smtp-Source: AA6agR6N4egFU92pUmyxhcXqsOyU+Q8ywulCC4ChqVABz3U2dM4ePorwqXZKy7WP8jur17QK6kVrAw==
X-Received: by 2002:a17:90a:e7c2:b0:1f4:feeb:20ee with SMTP id kb2-20020a17090ae7c200b001f4feeb20eemr2200781pjb.114.1661242113171;
        Tue, 23 Aug 2022 01:08:33 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id p127-20020a625b85000000b00536bbfa4963sm3012743pfb.139.2022.08.23.01.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 01:08:32 -0700 (PDT)
Date:   Tue, 23 Aug 2022 01:08:31 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH 12/18] KVM: Do processor compatibility check on cpu
 online and resume
Message-ID: <20220823080831.GE2147148@ls.amr.corp.intel.com>
References: <cover.1660974106.git.isaku.yamahata@intel.com>
 <60f9ec74499c673c474e9d909c2f3176bc6711c3.1660974106.git.isaku.yamahata@intel.com>
 <YwSGsbpuJ5cdNmDG@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YwSGsbpuJ5cdNmDG@gao-cwp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022 at 03:50:09PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> >diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
> >index 2ed8de0591c9..20971f43df95 100644
> >--- a/virt/kvm/kvm_arch.c
> >+++ b/virt/kvm/kvm_arch.c
> >@@ -99,9 +99,15 @@ __weak int kvm_arch_del_vm(int usage_count)
> > 
> > __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
> > {
> >-	if (usage_count)
> >-		return __hardware_enable();
> >-	return 0;
> >+	int r;
> >+
> >+	if (!usage_count)
> >+		return 0;
> >+
> >+	r = kvm_arch_check_processor_compat();
> >+	if (r)
> >+		return r;
> 
> I think kvm_arch_check_processor_compat() should be called even when
> usage_count is 0. Otherwise, compatibility checks may be missing on some
> CPUs if no VM is running when those CPUs becomes online.

Oh, right. Compatibility check should be done unconditionally.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
