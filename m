Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B476A7B6DE9
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 18:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239189AbjJCQCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 12:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240191AbjJCQCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 12:02:42 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E63B0
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 09:02:38 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1c5db4925f9so8310015ad.1
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 09:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696348958; x=1696953758; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sVV/60md6UTA8bNGRck53WOsmLRvjYk6hRbd3CAsgEY=;
        b=VvLBz8/+Y3LixYid6WO8FS/idABzAG2OHk2SCd2/CvLguYkLyP49kUahjrphKib4ya
         i2iAPSFkG74oZw9oCxPlBwB7SG7bXjzxOFtO4WTe2K/cRcjr2WYrTcQN9ks08vC3cc64
         nWKPlWX/cdkoGhvH5XMSyTo6OaMOZv4mhPHT82MoS/9tEwCjgMd4Cnz+TGqzyRjDeEj7
         Ng2tsd1LjFTMb75r+pd4Nle9qvrZRqRJwR87VnIihqp9kFyX4d1JmxX/Ec6eHZ2A2Sk+
         3oBcMh4Y5JLkwN4uNHss8svU/8j5CgYRVNPQXY8ADSvNsmdOhTkj2x2lCw1y/26Inots
         MGGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696348958; x=1696953758;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sVV/60md6UTA8bNGRck53WOsmLRvjYk6hRbd3CAsgEY=;
        b=M0xIUGqXO5WyzisCmEywkx+PN5mo7/XscTOkOuqHNgOCmWU9BA8U/cN42mieIor1/c
         fhILgim7UA2q3uWqq6/cpJ+hxcPWGOk0+40C5HbtIZgcjpbJXm9jRqhOUA/64/s8kqc/
         oBR3KDKS4MwIKoeha+Xbc/X5wtcEoxxCgp3jjwXghlfvhk72Tr2Av/mpIw3mVM9EPo6n
         gq0FFubgiTpyEvVI3mG9SBbjnS7a/WZbhtFiWBH6ldpHwYr3IKRcBM/n2Df6F+6tygiJ
         xM9lS/9G0D4fTbbsx9/VXNyJ/X2mtstedw9YMBZ8BWOTW9QVrLv+8bolMU1OJovK5oJF
         O1Cg==
X-Gm-Message-State: AOJu0YymCneVAv2V5wy11vLuW2hDnQqmlXVuPoANi5qXA2Drl+2/QtQw
        KoiFP3MWYP+A6PapWMz8gVqhYg==
X-Google-Smtp-Source: AGHT+IEvEqPZQ+DR0k8LUG1+eyMFnzgqbxZG1B9bkAcJEpckkAYgHokRYwzGgVprr6o/5kivsqv0sA==
X-Received: by 2002:a17:903:41d1:b0:1c3:9928:7b28 with SMTP id u17-20020a17090341d100b001c399287b28mr4308533ple.6.1696348958050;
        Tue, 03 Oct 2023 09:02:38 -0700 (PDT)
Received: from [192.168.0.4] ([71.212.149.95])
        by smtp.gmail.com with ESMTPSA id jb17-20020a170903259100b001bbdd44bbb6sm1742609plb.136.2023.10.03.09.02.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 09:02:37 -0700 (PDT)
Message-ID: <e6476524-a8bc-0071-eef8-1ee9e1dcba37@linaro.org>
Date:   Tue, 3 Oct 2023 09:02:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 0/7] accel: Restrict tcg_exec_[un]realizefn() to TCG
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Eduardo Habkost <eduardo@habkost.net>,
        Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Claudio Fontana <cfontana@suse.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Fabiano Rosas <farosas@suse.de>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cameron Esfahani <dirty@apple.com>
References: <20231003123026.99229-1-philmd@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20231003123026.99229-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/3/23 05:30, Philippe Mathieu-Daudé wrote:
> Since v1:
> - Use 'target'/'common' in function names (Claudio)
> - Added Claudio R-b tags
> 
>  From v1:
> - Add missing accel_cpu_common_unrealize()
> - Add AccelClass::cpu_common_[un]realize handlers
> - Use tcg_exec_[un]realizefn as AccelClass handlers

Thanks, queued to tcg-next, replacing v1 that I queued before my holiday.  :-)


r~
