Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11B0653C25
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 07:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbiLVGeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 01:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiLVGeU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 01:34:20 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54D11E3C7
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 22:34:19 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id l10so1109110plb.8
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 22:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vc295WQniIpK37zGSBRV0RWiRbn65OdMOuLtMA/kaL0=;
        b=V1QVXeEu5DWzdzCce6CEdHCj6gZe2MtRE007UlGf68WPWgsVPPSTTUngObqfDacPQS
         ChATc1Q2tRas2wRjr6XVt8wf2DriEfC7Wshs5g50gcyDm+zzbLzIPoDfUXJuVrpiK7u8
         ZGsSl9uyz7yB1TppqKxmKTmaCtsYmeZEGjOo+t1ezb1XM8h1gWsUftVrKpSxJ46oQGxk
         H1peLGkPi0LDufe5zaN5p76d1Xhe3AXi/w6GtJEEKnlutm2KZM+21l+AxhL/EmXSRUno
         UP5oXRWLsWChLDd9El9KHQXLvQHUBpynCMydP5fIy/FwGMKhU/cq5sApxbvxaHABI13z
         AEMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vc295WQniIpK37zGSBRV0RWiRbn65OdMOuLtMA/kaL0=;
        b=Ct0rQ6wSTf7DefYdmxPj9DXWYav6Czpkce8Vr8DNFTEZ6XTyzT/K7i9dau/0m/s+mk
         6ZNXfaq+tM1JQlG729mA8DsCIVymr/y0vrpLYygPXhWxq9/YQ+Ln8UYrcYiUKQBvpLUF
         Uqw+slKRt4aASOqIXzzrCf15nFavz1fI46RqONT+H4r+J096jCU1EVrwdREdX9LG9eFM
         Ob9Cep6dr4XSkFGqsxkOSKPwOz8Sw8xhxkTu8a7bQDCU5edxERlFt2fP+bCs96cr/+SF
         4zT4d41DYAxzhJscaZYVUcQ6iyrWoH8Ni2M5RU1jP5ota9iNKNlXF3+UsuTvdSjaWxI6
         xt1A==
X-Gm-Message-State: AFqh2kqN5/VmuYESm3nPGwBrpeEDM3JSfIo+s2bsLQNXtIOhf83R6c/Q
        0/fcmc5z2T1cfGBsDtDmtAF9oWQph54Zf+1g
X-Google-Smtp-Source: AMrXdXt9pz4FMCIMCbKt7ILhrlpdXal0MAbsiQR7WxMKeer33VAUeyKJv+6Ypf/076B6sy5D0kJ9vQ==
X-Received: by 2002:a17:902:6acb:b0:189:cdcc:5055 with SMTP id i11-20020a1709026acb00b00189cdcc5055mr5041927plt.0.1671690859335;
        Wed, 21 Dec 2022 22:34:19 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id n7-20020a170902e54700b0018997f6fc88sm12576191plf.34.2022.12.21.22.34.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 22:34:18 -0800 (PST)
Message-ID: <1a769c98-68dc-f265-1ce4-f141a9354665@gmail.com>
Date:   Thu, 22 Dec 2022 14:34:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH v8 3/7] kvm: x86/pmu: prepare the pmu event filter for
 masked events
Content-Language: en-US
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kvm list <kvm@vger.kernel.org>
References: <20221220161236.555143-1-aaronlewis@google.com>
 <20221220161236.555143-4-aaronlewis@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221220161236.555143-4-aaronlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/12/2022 12:12 am, Aaron Lewis wrote:
> +static bool is_fixed_event_allowed(struct kvm_pmu_event_filter *filter, int idx)
> +{
> +	int fixed_idx = idx - INTEL_PMC_IDX_FIXED;
> +
> +	if (filter->action == KVM_PMU_EVENT_DENY &&
> +	    test_bit(fixed_idx, (ulong *)&filter->fixed_counter_bitmap))
> +		return false;
> +	if (filter->action == KVM_PMU_EVENT_ALLOW &&
> +	    !test_bit(fixed_idx, (ulong *)&filter->fixed_counter_bitmap))
> +		return false;
> +
> +	return true;
> +}

Before masked event is introduced, the decision logic for fixed events is not 
yet covered
by existing and new selftests, which affects the review of new changes to this part.

More selftests on fixed_event is appreciated and required.
