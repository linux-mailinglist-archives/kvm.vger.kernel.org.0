Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6F261960F
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 13:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiKDMTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 08:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiKDMTn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 08:19:43 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45613120A0;
        Fri,  4 Nov 2022 05:19:40 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q1so4202710pgl.11;
        Fri, 04 Nov 2022 05:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lpOhz7OxgcyX16jnYCGIcgxXstL27/jHBLX3BQlZkeM=;
        b=cgzEgr24LoI9IjU+XM4EMk8dKD1ZuwOUoG2l29SwIwhDpdCk1rND+HSkQzPaFXXUun
         5cwqt4utz8zuQy+631yxcp8JeTFWa3eEkR6rLzF+IQQONAm77Re4+TeMpD3W2MH1BG0k
         xpw4hpqq2JLk9/rFoZ9a9PIltTd+TgIFu3ne1ijW4zZiDKY4Q2Lfnp1QKP/5fTQ/RXCF
         sGZicS+qqji92R8nClF8Qce3AOCsMhu2lWkuuNsR5EHcX1aF3PHTZeyjQrPGzGFRsP4k
         RN+MepWdTPb4gy5WMrWU7TZn6sYgVJl/ZAxP+ckrNg/JqvnI2g7HxwDXe6/hlJfR45wa
         16lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lpOhz7OxgcyX16jnYCGIcgxXstL27/jHBLX3BQlZkeM=;
        b=YJgs5Hp3vkNswd+UPF0Q6kBgBL1lvfKiWSPvD0xhud3kAWds9Mv4AXCT0c1fDytjeH
         N0OAPRelTTA6xXCp+yH1V2oub8X8Msb8EuEBu6zTh3Qd2eUtopmPhlx49ZHIFI0EXdFm
         CpN/zlKymJh+CW1FPI0oD7I9gtivPLpDcadUz1J0SGVcQPqMG63VRQH3QEZ+HgwtSX/i
         0iiOa166hQYyATABvcMxoGvPUh+w4sTrb5W4x3kBovDUB3fWJ+Ry8rH0NJMmxYF6ywtq
         jJA1KMZGXQrWsSadrttmbUK/7FxUCSkE2uHyp9PMgK/Lk3D2Cc2+SEy0Hge7DzYIJErz
         IplA==
X-Gm-Message-State: ACrzQf2tsmQ1UvZIv/xJso/hzgJjnuLjKuN+TW3ObSkrzjXiU5REx4ye
        5ucE/lY3d0ay/vFvOvMeqBmYAhg+ZcL0xQ==
X-Google-Smtp-Source: AMsMyM7+wkqLB0hFLrfY0ZTPMLFgrcCEO0q4UBENhChoWBosKogPXniCnR6xUQqM7H+JaXD1DhGp0g==
X-Received: by 2002:a05:6a00:140a:b0:56c:b679:f812 with SMTP id l10-20020a056a00140a00b0056cb679f812mr35864191pfu.46.1667564379656;
        Fri, 04 Nov 2022 05:19:39 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-17.three.co.id. [180.214.232.17])
        by smtp.gmail.com with ESMTPSA id b6-20020a170903228600b001782a6fbcacsm2543892plh.101.2022.11.04.05.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 05:19:39 -0700 (PDT)
Message-ID: <995a64b0-a9bb-05ce-85d1-6b5ee25ec0ef@gmail.com>
Date:   Fri, 4 Nov 2022 19:19:32 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] kvm/arm: Fix pvtime documentation
To:     Marc Zyngier <maz@kernel.org>
Cc:     Usama Arif <usama.arif@bytedance.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        steven.price@arm.com, mark.rutland@arm.com,
        fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com
References: <20221103131210.3603385-1-usama.arif@bytedance.com>
 <24d81fe9-7cd1-71eb-8c35-0739f638b3df@gmail.com>
 <86fsf0qc1w.wl-maz@kernel.org>
 <4b2b78c6-9903-1247-9d16-fc6270aa34fc@gmail.com>
 <86cza3q8q5.wl-maz@kernel.org>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <86cza3q8q5.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/22 18:06, Marc Zyngier wrote:
> On Fri, 04 Nov 2022 01:48:21 +0000,
> Bagas Sanjaya <bagasdotme@gmail.com> wrote:
>>
>> On 11/3/22 22:42, Marc Zyngier wrote:
>>> No, this is the correct course of action. There isn't any point in
>>> having an *unrelated* change in a separate series. This is a
>>> standalone change, posted as a standalone patch.
>>>
>>>> Please reroll your series [2] with suggestion applied.
>>>
>>> Or not.
>>>
>>
>> You mean the series before this patch have already been applied,
>> right?
> 
> This change is 100% independent from the series you quoted. Why should
> there be a dependency between the two?
> 
> As for respinning the series at this stage for a documentation
> formatting issue, this is pretty pointless, and only clutters people's
> Inbox with redundant versions...
> 
> 	M.
> 

OK, thanks!

-- 
An old man doll... just what I always wanted! - Clara

