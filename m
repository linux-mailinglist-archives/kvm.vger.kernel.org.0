Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 997547B60ED
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 08:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjJCGoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 02:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjJCGoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 02:44:14 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF2CAC
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 23:44:11 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-307d20548adso570393f8f.0
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 23:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696315450; x=1696920250; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+EjhnXyPxXga8N7Mi0khWKDMpK6Bb5LUXVYPpUwv0kE=;
        b=y8FxnSKWfPRAVtD/lG8Ejj69x0fUDxoWTkLGPnbuyWbcpsmvSUPz0t7GdzYYVRmFBo
         OmSZ93kFbOxlOlbBUbUSSBX8rpAuuDPUJF5hRNrHcCAasgfWNKPhl1ngaZeWMBI4cATX
         7Da3IMCV675/U42Jji6qJzDgyWKsMQmLVPtpWV/FgblODOG2QhvuiJrp0CT80b6zlOV+
         NNwm4BPGzghGZuZaXvfREKvIzes0P5ntUx/KxW7lhmo87fI9yg34u0WKWjhl1CsGkDJK
         nIbKqJ/fXtj3h//TSPCcVCs8/AS/QBfdP8RbI02sgR/bmbOHTTG5rrExPCClgpDZ2FAR
         BUuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696315450; x=1696920250;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+EjhnXyPxXga8N7Mi0khWKDMpK6Bb5LUXVYPpUwv0kE=;
        b=kzWpMqUkpQkzivlcNHv3WBGjqYsbatKv30BfCh2230TxMiRZYQfSx9R1qBGivN0A14
         mjytKTj40VhwgdFZ+YFv/bfv4OJ0pxqQgA2pLtcPgw49RxhMBunkhZ34T+bz8XDqZGEX
         OM3T+6vYqyPDaYreG4S4Kxk+G8UuxU42rrU1AIJ0+5/xuMcPuehLC/9sJzCQvWiWYfvn
         g3TXsYNCez6IxqNP4fULq5rr9gFoj2jsitdbhIelvl88Chq7fhs8zZoy54cPwwe9KqBc
         gfVp+paW1nb2dbX31bTmry8gcVRW7Pe6sYdr9FSXye5KccYr0RhZEGRdOmfeIkRB1H5p
         aaUg==
X-Gm-Message-State: AOJu0YyxSx2pLNoV11RODOpDRiCTY7ASaAS/w6sUlZBQpfyIXIGSde67
        hSW8JrTRilJUNAsjQ4J6yvxnoKRzsQjLRLuwzwB0XA==
X-Google-Smtp-Source: AGHT+IH1f/kx2g8O0aHlJoykwsu2/99BV5h17gx2MRNLbRv0pyCR+ijDL5C58vORZxDL12K9gE85Hg==
X-Received: by 2002:a5d:66ca:0:b0:317:e542:80a8 with SMTP id k10-20020a5d66ca000000b00317e54280a8mr11351827wrw.15.1696315450321;
        Mon, 02 Oct 2023 23:44:10 -0700 (PDT)
Received: from [192.168.69.115] (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id f16-20020adff590000000b0032326908972sm785806wro.17.2023.10.02.23.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 23:44:09 -0700 (PDT)
Message-ID: <87e1be19-c1c6-73fb-3569-7dbf186662f7@linaro.org>
Date:   Tue, 3 Oct 2023 08:44:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 0/5] accel: Restrict tcg_exec_[un]realizefn() to TCG
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Fabiano Rosas <farosas@suse.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Eduardo Habkost <eduardo@habkost.net>, kvm@vger.kernel.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <20230915190009.68404-1-philmd@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230915190009.68404-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/9/23 21:00, Philippe Mathieu-Daudé wrote:
> - Add missing accel_cpu_unrealize()
> - Add AccelClass::[un]realize_cpu handlers
> - Use tcg_exec_[un]realizefn as AccelClass handlers
> 
> Philippe Mathieu-Daudé (5):
>    accel: Rename accel_cpu_realizefn() ->  accel_cpu_realize()
>    accel: Introduce accel_cpu_unrealize() stub
>    accel: Declare AccelClass::[un]realize_cpu() handlers
>    accel/tcg: Have tcg_exec_realizefn() return a boolean
>    accel/tcg: Restrict tcg_exec_[un]realizefn() to TCG

Ping?

