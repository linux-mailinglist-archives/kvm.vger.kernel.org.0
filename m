Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4D26F324E
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 16:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjEAOvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 10:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbjEAOvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 10:51:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E741B5
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 07:51:05 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b9a6eeea78cso27017233276.0
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 07:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682952665; x=1685544665;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WOrHEpFlVhZ2ED+ZlWcImFVDa9Kfmuo2kBgIOZZMoBU=;
        b=D68UvW+3vknzR/obSnb0RNycCZOjRpd+/2SJRU018qojBcfljX0omaKB/L7+H3s58P
         ulzKIcU/14T1lfrYxMUDuIfyacyT18fJo5jwADPfmc5szWnsITgx7a3Zce3haStzZiHX
         xffHnpiwuPaG/+CnqkifVZHW+YdwBziYuQxwQO3G743T8lDqQZmEa+IdASxcKi7V2+JN
         lgxKS60tuhGH7UtFwCydizvIg60C1qUu0KKVlfI9Rc5+/71Y86E7TFwls+eC1U/iUt5Z
         V0YaPCmY2Gt9bjEmoJjlOhlO/sFGIp2V+1w51qwkA92brQYaHpYbRLi5nlv5vfcJCpAi
         REbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682952665; x=1685544665;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WOrHEpFlVhZ2ED+ZlWcImFVDa9Kfmuo2kBgIOZZMoBU=;
        b=TGAn7DuDYRNe03IsVc2ZYjWmSe26hcMkN4vbUCK0a6CkWxUT40WHFZ6AuKEZKFOcFx
         fdJQfieWw7s7BlA8ohZl3O+3tvaofO6pVHITIR6AF/WuVbpqZQCzTj/VTD+3U7m8oIuO
         M9EQTHlZR4AiYAJQmgpsrifhnrNJ1DNZS0QoDYQlzBSCT3S5bE+w0ZCKo5kDUDV6Q4ZO
         9u/gMmcdecIjXpF5vWP7jQooeZjibHL6W+NOjH2UjdqmFU1Y8V+vQCTjt5y13L3bA+/8
         BCjkScYSqkrcoL2L4KX24JsqZJh6+SF5G2fyKyzdbdUZwLwfuWQtoX8mqSCGh2hZ3QAT
         l9SA==
X-Gm-Message-State: AC+VfDyFUoMDKVlFFUMMqiJGXSMAaY81499Pk05tWuzUwVLHH26V1fZb
        h4jEuQzIXIQfs00fyEXe+Ux2orj18ms=
X-Google-Smtp-Source: ACHHUZ7xMIzzYlToZZdbvPhnuKzJ/MrI0ZKA0kTecBKqYleItysNvner7AuHIIk5GfltHF4SjXIgZfHCYFg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a2d0:0:b0:b99:535c:3619 with SMTP id
 c16-20020a25a2d0000000b00b99535c3619mr11096224ybn.6.1682952664875; Mon, 01
 May 2023 07:51:04 -0700 (PDT)
Date:   Mon, 1 May 2023 07:51:03 -0700
In-Reply-To: <a9f97d08-8a2f-668b-201a-87c152b3d6e0@gmail.com>
Mime-Version: 1.0
References: <CANZk6aSv5ta3emitOfWKxaB-JvURBVu-sXqFnCz9PKXhqjbV9w@mail.gmail.com>
 <a9f97d08-8a2f-668b-201a-87c152b3d6e0@gmail.com>
Message-ID: <ZE/R1/hvbuWmD8mw@google.com>
Subject: Re: Latency issues inside KVM.
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hoo.linux@gmail.com>
Cc:     zhuangel570 <zhuangel570@gmail.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 29, 2023, Robert Hoo wrote:
> On 4/27/2023 8:38 PM, zhuangel570 wrote:
> > - kvm_vm_create_worker_thread introduce tail latency more than 100ms.
> >    This function was called when create "kvm-nx-lpage-recovery" kthread when
> >    create a new VM, this patch was introduced to recovery large page to relief
> >    performance loss caused by software mitigation of ITLB_MULTIHIT, see
> >    b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation") and 1aa9b9572b10
> >    ("kvm: x86: mmu: Recovery of shattered NX large pages").
> > 
> Yes, this kthread is for NX-HugePage feature and NX-HugePage in turn is to
> SW mitigate itlb-multihit issue.
> However, HW level mitigation has been available for quite a while, you can
> check "/sys/devices/system/cpu/vulnerabilities/itlb_multihit" for your
> system's mitigation status.
> I believe most recent Intel CPUs have this HW mitigated (check
> MSR_ARCH_CAPABILITIES::IF_PSCHANGE_MC_NO), let alone non-Intel CPUs.
> But, the kvm_vm_create_worker_thread is still created anyway, nonsense I
> think. I previously had a internal patch getting rid of it but didn't get a
> chance to send out.

For the NX hugepage mitation, I think it makes sense to restart the discussion
in the context of this thread: https://lore.kernel.org/all/ZBxf+ewCimtHY2XO@google.com

TL;DR: I am open to providng an option to hard disable the mitigation, but there
needs to be sufficient justification, e.g. that the above 100ms latency is a
problem for real world deployments.

> As more and more old CPUs retires, I think NX-HugePage code will become more
> and more minority code path/situation, and be refactored out eventually one
> day.

Heh, yeah, one day.  But "one day" is likely 10+ years away.  Intel discontinuing
a CPU has practically zero relevance to KVM removing support a CPU, e.g. KVM still
supports the original Core CPUs from ~2006, which were launched in 2006 and
discontinued in 2008.
