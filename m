Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43D94BD7B3
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 09:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346621AbiBUH5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 02:57:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346620AbiBUH5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 02:57:40 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD9C21823;
        Sun, 20 Feb 2022 23:57:17 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id ci24-20020a17090afc9800b001bc3071f921so2275761pjb.5;
        Sun, 20 Feb 2022 23:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=row2n30zeMafUbZTm1tkShUoqkqQMjselfJLVWnvwic=;
        b=YgIYFGgdemSX1YWjMQhWOQdQXFGv2Qt8wSkkVHUV0J6L9C9B9bQjCSMfYeHXaq+T4z
         63jtd7u/5R8Qs7IGzRSB7cFNOQlRWodO/WEiVV/L6xoV1FInMsXKJOOWjxOqFTxjWi3U
         czXDMzJdAt2XMe5p8cTvwng4NR/P4eqBz/ASJL9D6cJwVWJgQMp8kS0h8ocsO1oM6NqP
         Oy3yOM47IIt4BmzPiEBP82bfQAkkSQDLQ5/RXX0UwSdQfW1wZkQxTZIatIO1Z5OwwMge
         dcma094TZUvI8188KQ5TTUE7V3WsXFb/0FTQW+M2W2RdklVDcVwCTlu3+lb4whFgfmp5
         qJHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=row2n30zeMafUbZTm1tkShUoqkqQMjselfJLVWnvwic=;
        b=jZft9WD5d2aYqeUo8yxRcTv4kODGKqQj02wUKM+OI6hzBipgCqIShrpEEPBNfwc4DD
         /2tudct5PsN3lVZiS5Pzry53ekXedraaZ125Nm5O5JxDrJmQ7S9yaiNlKiRYtgy0KLRy
         jBp3kjGfrCYDq7rNF07xQVXDlCzAfkKdypXsP3oTxO/25NGyHW4WmTdPMBJj7wrTjbGw
         0Xk1YvUZHlfsJo8H47pmxh06kiUycNfSDT6VezuYHQ3S5gsCca4/f1cbYF8rD4F4rS/D
         lLLj905e25O5OLt+T6OArap4Q4OsENq1Q/WPvc06zyJ14I1ve4vbpCQDXHjbdQvv9NLv
         y+Ug==
X-Gm-Message-State: AOAM532/ZLi3mpJjXWsTjRTC2Zwf3/lCgpn7m1YI1QEitrNNEfmTHc1/
        wV6IKhtyDoJcZDrUUaK2Y3g=
X-Google-Smtp-Source: ABdhPJwCaRplLKcH4o71Y/9G3qqpn89iK8E20u+n5V1a3ngx+/GiKJe3e0DFj0cwRPrj7KKpzrI68w==
X-Received: by 2002:a17:902:a989:b0:14f:969b:f6b6 with SMTP id bh9-20020a170902a98900b0014f969bf6b6mr7894846plb.15.1645430237164;
        Sun, 20 Feb 2022 23:57:17 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x2sm1978243pje.24.2022.02.20.23.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Feb 2022 23:57:16 -0800 (PST)
Message-ID: <1e0fc70a-1135-1845-b534-79f409e0c29d@gmail.com>
Date:   Mon, 21 Feb 2022 15:57:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 3/3] KVM: x86/pmu: Segregate Intel and AMD specific logic
Content-Language: en-US
To:     Ravi Bangoria <ravi.bangoria@amd.com>
Cc:     seanjc@google.com, jmattson@google.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        alexander.shishkin@linux.intel.com, eranian@google.com,
        daviddunn@google.com, ak@linux.intel.com,
        kan.liang@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kim.phillips@amd.com,
        santosh.shukla@amd.com,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
References: <20220221073140.10618-1-ravi.bangoria@amd.com>
 <20220221073140.10618-4-ravi.bangoria@amd.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20220221073140.10618-4-ravi.bangoria@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/2/2022 3:31 pm, Ravi Bangoria wrote:
>   void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
>   {
>   	struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, pmc_idx);
> +	bool is_intel = !strncmp(kvm_x86_ops.name, "kvm_intel", 9);

How about using guest_cpuid_is_intel(vcpu) directly in the reprogram_gp_counter() ?
