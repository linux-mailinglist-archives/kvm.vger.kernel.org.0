Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB217825E3
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 10:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbjHUI4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 04:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234214AbjHUI4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 04:56:33 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DC6BF;
        Mon, 21 Aug 2023 01:56:30 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1bdca7cc28dso23661615ad.1;
        Mon, 21 Aug 2023 01:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692608190; x=1693212990;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yaARTK1IKbr/L5z1vAYgYr14zC5eiDTx8+QfE57cI4c=;
        b=SBtahzx5JAoR32fbZQXbSZd3ixK/rsCVdiKug48VwPAYoHnEPQuA5fKLIWV5xLAxXk
         cFa3Oj5kBxWjkKxzmEW0frig+okrtT15Wdy/a1fsA2mJM+WHMebtZgrMZbb15z4gyCKW
         4WfAquUkyMROSYAqtkejSlgrq4hSputOSlwi7uo2qJwic0ID32N9DVLawnmqsdE8hiGn
         tNRIfaMa5tTbk20OMyLDhRBzyB3K4rxScztO6do1g6uYPI7gi0fvF2iZ/srXeppPWt7t
         hOYAPH1ymGh5v3WFbxd8zfFLMCBKsKwRnMq2L9cyqTE8mo4zFxbl81wksvBv6AWv6G1M
         LxmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692608190; x=1693212990;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yaARTK1IKbr/L5z1vAYgYr14zC5eiDTx8+QfE57cI4c=;
        b=YbjP4q5cc5/2cmIeHkbys9YaYHMGnyIWOMVxMD0gxLRN5lXoTpJcQ7FS3rVMqf4CPw
         ogt+nbpQ1LCEeHEJjdDVaUXtDU+Ly8/VlzkhJ39rHHr7Fjo/FDMrHXiSBm84TUHISz0N
         xywhZW86dy9KKammipF0T0+ly6cWI6xZXcVjyopI2Vdscd6Gj0T3gBJcBm0q7DpCn0t9
         e+qtSzW8XjK6bpu9wQt7BYm4JtuM/XaiqsIS9gdUQwAFJ67AnYDKu/tjsC8k+a49ONEJ
         HiuL61NbQ8qchNnQVMBf7KKyosjE9pXoSZKlrSKy9dsRzKEisjaauQzAolAxA3K9F9uU
         Jwog==
X-Gm-Message-State: AOJu0YxL9MR1xytJCZ+zu1vU2tuJCEsAycXtRT+G8A7S6KYToOZDyWsT
        B/OqjbWaqc5K2JgCOWPGwOg=
X-Google-Smtp-Source: AGHT+IHn7BW7v8NfGf0jxEtyK0auAftSpUByeNz/82mfmnFZ0B5fTTI4fs2osNjsoIfN5/lm3wM2Ug==
X-Received: by 2002:a17:902:e84f:b0:1bb:8e13:deba with SMTP id t15-20020a170902e84f00b001bb8e13debamr7762899plg.11.1692608190165;
        Mon, 21 Aug 2023 01:56:30 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id l19-20020a170902d35300b001b89891bfc4sm6496744plk.199.2023.08.21.01.56.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Aug 2023 01:56:29 -0700 (PDT)
Message-ID: <56873cf7-ddaf-3e8d-3589-78700934c999@gmail.com>
Date:   Mon, 21 Aug 2023 16:56:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v3 02/11] KVM: selftests: Add pmu.h for PMU events and
 common masks
Content-Language: en-US
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20230814115108.45741-1-cloudliang@tencent.com>
 <20230814115108.45741-3-cloudliang@tencent.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230814115108.45741-3-cloudliang@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/8/2023 7:50 pm, Jinrong Liang wrote:
> +#define ARCH_PERFMON_EVENTSEL_EDGE		BIT_ULL(18)
> +#define ARCH_PERFMON_EVENTSEL_PIN_CONTROL	BIT_ULL(19)
> +#define ARCH_PERFMON_EVENTSEL_INT		BIT_ULL(20)
> +#define ARCH_PERFMON_EVENTSEL_ANY		BIT_ULL(21)
> +#define ARCH_PERFMON_EVENTSEL_ENABLE		BIT_ULL(22)
> +#define ARCH_PERFMON_EVENTSEL_INV		BIT_ULL(23)
> +#define ARCH_PERFMON_EVENTSEL_CMASK		GENMASK_ULL(31, 24)

Could you write more test cases to cover all EVENTSEL bits including ENABLE bit ?
