Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2988C52206B
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 17:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347028AbiEJQCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 12:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347574AbiEJQBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 12:01:49 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CC557162;
        Tue, 10 May 2022 08:55:49 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id t6so24464497wra.4;
        Tue, 10 May 2022 08:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fOF+NEDU8/hQ8xR2ZPTLu55yUk0f5qPDU4dqjhesfu4=;
        b=mWv8sGuCsQexUWxuy8quqPPAJFSeJkFls7okYBW2A+KLIdD4Ca6N22ezaqQ+dFK+HY
         CPdNd/FSAVBKLdkpoRrosB07K2OXB1wjK0Xcl0cYgbrjZI9lkQSGTBenxlrXIioCeMCA
         o8v76xu5S89YD5Z1t8CmWW2Z7Hv8KLaXgbpnUOl3y9e62DwznV7umUKS4UlDKxlUyQ74
         1RGKYNJuAUecpbQS+m+Ie1Pvn2TPERdg1eEvV7W48N1GsO7AVXBu9idhltklerEIIvuo
         mX6WtDO91cg7KvagwVmzuk4BfSof/rmccgPtoMItgetb5B+eX/lSMHALmliKua8EdzzG
         d5Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fOF+NEDU8/hQ8xR2ZPTLu55yUk0f5qPDU4dqjhesfu4=;
        b=Gg/8IB69vAHkHDoxq36Wtig1Agp0ABrz4Xgf4YnjWxSB0ax79wzHKo6bj/DQbTFU4K
         U3//nV8X2hxMssii9BaiONnEPb9eq8av3RqnqMdWRN2P1xbiVH9nEdJFrJwd6Wt2xDBl
         dWHSX4mPP7maP1wI81Kb2jQPC0nfR3IxZaBK4VtQt2ZfyBH1J4f39vg4j8dsQh5kAOuy
         jNzIGN9IRgg3Tzlek0+v1F5EvCydc19iGr5w2WOoad7XsPOFZgZBucDgt5BY+eeHiUN4
         gFD8KGCsgcAl3GBWUrRkmagoKlhHOUeAx9XAyfeALQ17IMot8o+NpycUTQptXUe+nXCv
         +eOQ==
X-Gm-Message-State: AOAM530T3WYqIUq414546UNR8DyS+n94vDuAbdb2Hu6lfT/fWepFYine
        SRQQ4hzfCOlFdVs/FujwVxE=
X-Google-Smtp-Source: ABdhPJzNvrHlzmhUnc1c2TX1SQZC+r4ZE2sZpBj5t+Puimxe4WofbiY7/XkqeAjqwIcj/MmDSSGFig==
X-Received: by 2002:adf:ed86:0:b0:20a:db50:1b1b with SMTP id c6-20020adfed86000000b0020adb501b1bmr19869519wro.506.1652198147865;
        Tue, 10 May 2022 08:55:47 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id v21-20020a05600c429500b003942a244f3bsm2658428wmc.20.2022.05.10.08.55.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 08:55:47 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <27e36c48-8062-7a02-aca2-80f32f61ae75@redhat.com>
Date:   Tue, 10 May 2022 17:55:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v11 00/16] Introduce Architectural LBR for vPMU
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>, jmattson@google.com,
        seanjc@google.com, kan.liang@linux.intel.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220506033305.5135-1-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220506033305.5135-1-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/22 05:32, Yang Weijiang wrote:
> [0] https://software.intel.com/sites/default/files/managed/c5/15/architecture-instruction-set-extensions-programming-reference.pdf
> [1] https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/
> 
> Qemu patch:
> https://patchwork.ozlabs.org/project/qemu-devel/cover/20220215195258.29149-1-weijiang.yang@intel.com/
> 
> Previous version:
> v10: https://lore.kernel.org/all/20220422075509.353942-1-weijiang.yang@intel.com/
> 
> Changes in v11:
> 1. Moved MSR_ARCH_LBR_DEPTH/CTL check code to a unified function.[Kan]
> 2. Modified some commit messages per Kan's feedback.
> 3. Rebased the patch series to 5.18-rc5.

Thanks, this is mostly okay; the only remaining issues are Kan's 
feedback and saving/restoring on SMM enter/exit.

The QEMU patches look good too.

Paolo
