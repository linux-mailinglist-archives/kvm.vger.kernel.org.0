Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE4C6C8957
	for <lists+kvm@lfdr.de>; Sat, 25 Mar 2023 00:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjCXXge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 19:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjCXXgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 19:36:33 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24637E3B4
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 16:36:28 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l12-20020a170903120c00b001a1241a9bb1so1986658plh.11
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 16:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679700987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I6O8GrBusQdE9gwItMohterpiO/FhfFnJcQwSPMDplo=;
        b=efyThk8OD1Ui+mGN1aq0DwY2trMnEAqWd8Fvtdi7z9pg+Wwza3RFewsJ8t5V9fhDwc
         scgNK2SS6ohr5SyUtKnYwwJg4wdOvuXPd838/FFGLFiOVpSRy4xnm+IQOS8IywllzG0i
         sOm6VSRFGpJdF/OLBo15iHVmF9wjV1WYbI9WJ6wYCC0J8kCvTXR0zX7cN8AdPl6rBVqD
         IEzw/x5AbI+9pAYCIe36dkAqMRFoAZftaKpwAKFG63bQaIUQlvcywfW/BrzgRw9/2A16
         XKndWu6chOus4AWNjLy/bhpM4DUhsOCamqehvgilxGIuh5EbzgpUlzNe1ervnw4dpqef
         F9NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679700987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I6O8GrBusQdE9gwItMohterpiO/FhfFnJcQwSPMDplo=;
        b=G9ztuQpPz5ALTdoeZobHG4YU5NwczYFNJja/Zc3s9Zg6XfeZcQI9DZrlpUn/O1J4ao
         IXPt4bz14YbkqPjVVNoQcBebWqL5ifmRXNA1aRNx7OjjnP2hGw63OYvWxWHzXFBtE8vg
         MaxFb8Py7sk5m8GyaV73ttpQSN202bfzfKyaUbxnYcpzW7btoHHlBtW0+ChvBBEqHrL8
         QwMk9VwLIvrQiGZo64BYGk7DeKdrV582Hrbih5IXt851P68GMuWY+a9RhMz7rC4xNEs8
         DP9gKD/aD0irL8N1eQwgDngb2iaUbfxJLkXiegI6kuvVgBBDtpElujjz/AAY3AZcq20a
         Ujvg==
X-Gm-Message-State: AAQBX9c3UwC7sgctZhz7A8Z6qSsyUk2UIszCDBxchTt0rMXd7v8g0M4a
        PjJ6YqvZjyFT2yakEbW9WDMnBLABxQk=
X-Google-Smtp-Source: AKy350a3TLlZSiuQgZzZiPiHRLvf0U5ChFmA1NUKVGv2bIFiTDKTUWiwuV+omcjmN/u+zQrsXSpNRAG644o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:795:0:b0:50f:76fb:84a2 with SMTP id
 143-20020a630795000000b0050f76fb84a2mr1077499pgh.5.1679700987585; Fri, 24 Mar
 2023 16:36:27 -0700 (PDT)
Date:   Fri, 24 Mar 2023 16:35:47 -0700
In-Reply-To: <20221213080236.3969-1-kunyu@nfschina.com>
Mime-Version: 1.0
References: <20221213080236.3969-1-kunyu@nfschina.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <167961296610.2556158.130128430249357317.b4-ty@google.com>
Subject: Re: [PATCH] kvm: kvm_main: Remove unnecessary (void*) conversions
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        Li kunyu <kunyu@nfschina.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Dec 2022 16:02:36 +0800, Li kunyu wrote:
> void * pointer assignment does not require a forced replacement.
> 
> 

Applied to kvm-x86 generic, thanks!

[1/1] kvm: kvm_main: Remove unnecessary (void*) conversions
      https://github.com/kvm-x86/linux/commit/14aa40a1d05e

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
