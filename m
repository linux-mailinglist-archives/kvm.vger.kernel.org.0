Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5E2697B4A
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 13:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbjBOMAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 07:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbjBOMAg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 07:00:36 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961FA38023;
        Wed, 15 Feb 2023 04:00:34 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id w14-20020a17090a5e0e00b00233d3b9650eso1903433pjf.4;
        Wed, 15 Feb 2023 04:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lolFf647qX9YrdZwkuBKlkltYDziYbSSD1kp+TXEm3I=;
        b=Cf14aFmfEkI+hKh9/yYIP1Oa3rWOFsQKVlfWZuD1DnI17BXqULNjto4c4stYz6ZEsq
         B00yOqbWlga6ZR5vyb57T9+L9PVNKLRzIgInXrARhfN1RUpwKvU/dLOD89BId+ulcwb+
         ZiP/sGWilSFnKeuCE8fAVWCAFkd4pbG2gcsP3GjOWw0kL8bZIDVE07gr7rLwPGhFWMMy
         hpTew/1xyEUapsXVUUVDSzwueXS90J3WjdfeHBIOySk00lutAnVcicXw5IOR4PLhyxDK
         8NWWRfCEA7IZXKAJczyykhqsRNXgtQPhuf2FVzlFRIoq54AITjTdX4ANDkPB3+WEsYtf
         fKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lolFf647qX9YrdZwkuBKlkltYDziYbSSD1kp+TXEm3I=;
        b=7FcM1sVP9ceazKnCU0somVIBbuChv5BvL06JHuLiaWIeEmrIO7XYi5+RFxeDYVD50l
         wijQHHoqwMACmang5GgBnXE7IOMO4AjyUIm9zpaYfgAWZ3huxJhMgARqfOicE9fhcQyW
         yXTAtAjR6QWMwUDWgMCoHNPjGvHq68+QP54klTU/6YF1raac/w/twh5zVdahY9YldiIm
         qteo4iVb+245ObEk+tO8YEL9rzSpEaomgw+Jt+ym9b1SxzoSq3N2UbdMT/iPg+eUH9tY
         yACyhQ7GBiXNY0cO2l/seerf0IWtEraOXqMfJRtjQrzh+V5DjeHPilb1dlWPE5TUxJFO
         KuIA==
X-Gm-Message-State: AO0yUKW+KMgWCFizJXid8nmF+ZYl5EP8MGm7Cd/gpwEncI5dwYYY1JlI
        Z8i7KR3MDVWnAUNTZOrlgCo=
X-Google-Smtp-Source: AK7set9cRg8gne7Ug36x4KfBI1KwQbCbQk4ZTo5dQP+lzL+3Wl9btYddHajWY6kQA+ulLlECvAM8TA==
X-Received: by 2002:a17:902:c950:b0:19a:85a8:eb30 with SMTP id i16-20020a170902c95000b0019a85a8eb30mr2630871pla.10.1676462434009;
        Wed, 15 Feb 2023 04:00:34 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d18-20020a170902b71200b001930b189b32sm11947675pls.189.2023.02.15.04.00.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 04:00:33 -0800 (PST)
Message-ID: <73545081-0d82-fce6-43f0-c50aee9416cb@gmail.com>
Date:   Wed, 15 Feb 2023 20:00:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v2 07/21] KVM: x86/pmu: Zero out LBR capabilities during
 PMU refresh
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230210003148.2646712-1-seanjc@google.com>
 <20230210003148.2646712-8-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230210003148.2646712-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/2/2023 8:31 am, Sean Christopherson wrote:
> Note, this is a very theoretical bug, there is no known use case where a
> VMM would deliberately enable the vPMU via KVM_SET_CPUID2, and then later
> disable the vPMU.

That's why we're getting more and more comfortable with selftests
and fuzz testing on KVM interfaces. So is there a test for this ?
