Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C424757BBF
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 14:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjGRM0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 08:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjGRM0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 08:26:44 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CB310C2
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 05:26:43 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3fbd33a57dcso58517045e9.0
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 05:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689683201; x=1692275201;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V3PQZv4JdjPfLxuOAOAQnZdDlqwN0RLJWnyJsJApYuw=;
        b=uSAYDgPpUTH2ouye+R9P4X4ejd/Wn3PXlg0XtfJ1zRUlrLbaFthwa2ciUhRjSuFLSn
         Qn6gSVWsIJaCAaIQ4UuYuZ5LiFljVPwSwCd5C1Jb4qNYG5So+F6CqcJ43tLUBqlUaPag
         2j/ULqjJvb8m4K9CA67jxfzD6wk/6+/medxffKFvth8L5iu/XKDvEtnIgtw8LZDUWjSH
         BQBkUK80NnIjwm7/CGMKQOUuefCVQbiWWCUn9A5KdTmint57Qty+WZQOd6G5DHkgivhI
         EH1tOeqeUnL0vMwPx5ZDdohEezC/5L47rDrKqTuO4O8JSitOsbzU7HbAru4U58ZRc0nL
         jRXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689683201; x=1692275201;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V3PQZv4JdjPfLxuOAOAQnZdDlqwN0RLJWnyJsJApYuw=;
        b=h7P0h/YDWkoLwPYpbndF6mZ8nWDVsUK9TcmpitXcro0ZolOqrVPfZ/MqCF3gcyvpgn
         nkK/c/D3PX53vyX1Ntbi7MNFbfRs4AJ6bsoLnPSdKHMSVpr+ylL/DdhffZ/hWPsyFajA
         NCD6pLYKd0YAflpD6LdKuhPMcamZ1t6J5FbzirDJRAy49WWiYS2mtvk3EpkKSQreEZPh
         e+m/UnAEJndShwiiM7q+tCr7GmmxT/nrvdmBGsK8cdpiMVH48QWKEIvNCcl8avjekXiR
         C0CsnHiBFkGaUK8nZBKyNiUxF2JOcZJ+itzkdavrq6olvPMS9NrydkgVH9qzpWnMEInh
         /JuQ==
X-Gm-Message-State: ABy/qLbxsJvbTksuIVIt7cx07n7aKS79hcr8oHDGbdb6VqC/OAIMSHPQ
        iT5rTp1wnGMmxBYlAfN9a97ZRQ==
X-Google-Smtp-Source: APBJJlHPMrE0rvi+a6u2G1ABOL91bkimqryhbk9tsc/0ayAqU7Po7hPTXA3O5nuDOFTNQNmP1nGn+Q==
X-Received: by 2002:a1c:e915:0:b0:3fb:e054:903f with SMTP id q21-20020a1ce915000000b003fbe054903fmr1833056wmc.36.1689683201553;
        Tue, 18 Jul 2023 05:26:41 -0700 (PDT)
Received: from [192.168.94.175] (140.red-95-127-46.staticip.rima-tde.net. [95.127.46.140])
        by smtp.gmail.com with ESMTPSA id n16-20020a7bcbd0000000b003fc01f7a42dsm2064361wmi.8.2023.07.18.05.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jul 2023 05:26:41 -0700 (PDT)
Message-ID: <e3b37c11-748f-07e8-8c97-b9a557c17b10@linaro.org>
Date:   Tue, 18 Jul 2023 14:26:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH 4/4] KVM: selftests: x86: Use TAP interface in the
 userspace_msr_exit test
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kselftest@vger.kernel.org,
        David Matlack <dmatlack@google.com>
References: <20230712075910.22480-1-thuth@redhat.com>
 <20230712075910.22480-5-thuth@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230712075910.22480-5-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/23 09:59, Thomas Huth wrote:
> Use the kselftest_harness.h interface in this test to get TAP
> output, so that it is easier for the user to see what the test
> is doing.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   .../kvm/x86_64/userspace_msr_exit_test.c      | 19 ++++++-------------
>   1 file changed, 6 insertions(+), 13 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

