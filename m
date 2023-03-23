Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3B76C60F8
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 08:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjCWHnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 03:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjCWHnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 03:43:31 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5221F17CF7;
        Thu, 23 Mar 2023 00:43:30 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s19so6711450pgi.0;
        Thu, 23 Mar 2023 00:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679557410;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vegsO3ALcvusav7HufQTkdoKevGIfa0AX35C5d9s8g4=;
        b=D0jdIYyA4Oo3AUMv5AVJWsGUK/jP6iqOGMCRwlwt8Y+vIXZM42ZI7nX89S8/Bn9kZW
         1d3Vp6Pzd+w/Rk2LjKf60lwY5Gr7xDnA3W1v4y9rSN/39AdNAPDO7VjIXXMITpgU8O+B
         KZKwbNGsE/DBtfPEZHOQNPjW0AjyEIK9jGUxqDlXDXDhw2k8YO46Ie7Tk+3Cgfxm+QPL
         SAhPvRWy8IWeHQAZ5t7eVYSAcZF+S3AO0Qg07OD+GWW4bXPymNkLA996xPCvK1d6mf7o
         br0eQ9W8/cKDCyAVY9zfmzdCd1rAhttHtpgtPacVdIAwRRbWWzQ9HkGJHGK263MJf2Y2
         DOjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679557410;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vegsO3ALcvusav7HufQTkdoKevGIfa0AX35C5d9s8g4=;
        b=5JAyTDjHBDpYv3Kpxfr9q3TDGj+S5NILUzUcT/0kmqPfD9srtn45tGeFL36xQgCnK/
         0Zf+fppSb3V6TLY+QaEmCrGuAhrU+H6rEEXD5xF42eWmpiXOxzrOAjfbqfiapBQ9D+Bw
         wv+p8ZDhF2H/npOpSvFDji3/jhvtwbe0YFEujMLQRohtLf1124JOTQIsauGSxtYePzvR
         t7XNlJKDDXms4xihoF/Wz86gR2IAsWT3dpsy0e7ynXUXHnm8sOhIA9bS6o5J5xBzRoAh
         +Q36T4HgqgyXwsCUnYglXfU3vr0FDxhCGqRUqdUlrdllxCXZdFoi+JTlcHLQotze2Ekr
         X8LA==
X-Gm-Message-State: AO0yUKUKBqIjuO6yxp7lWQ/U5nxiQaIXm6+AhRYeTxwCTwRLbM6ZKgMs
        BccWeLn0ycK/h7WA+WtqDkNlIX4mGVl+CuGZ
X-Google-Smtp-Source: AK7set9w6etpiwQTA7yTR7OihdSV4tBT40kF9tDpL7FrWFxxEDg1kXRF0dqA0zvjA3t7SEcLfz1N+Q==
X-Received: by 2002:a62:4e47:0:b0:626:166f:6db1 with SMTP id c68-20020a624e47000000b00626166f6db1mr5870026pfb.13.1679557409816;
        Thu, 23 Mar 2023 00:43:29 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id n21-20020a62e515000000b0058bc60dd98dsm11197314pff.23.2023.03.23.00.43.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 00:43:29 -0700 (PDT)
Message-ID: <e8fa4f0e-7d06-2b8d-56e2-acfc05b8e886@gmail.com>
Date:   Thu, 23 Mar 2023 15:43:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v4 02/12] KVM: VMX: Refactor intel_pmu_set_msr() to align
 with other set_msr() helpers
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230214050757.9623-1-likexu@tencent.com>
 <20230214050757.9623-3-likexu@tencent.com> <Y+6cfen/CpO3/dLO@google.com>
 <3e0f74af-772b-547b-18a9-7ac5c325dd35@gmail.com>
In-Reply-To: <3e0f74af-772b-547b-18a9-7ac5c325dd35@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

the kvm-x86/pmu branch is basically unchanged up to now,
do you need a V5 for this feature ? Thanks.

On 21/2/2023 4:44 pm, Like Xu wrote:
> On 17/2/2023 5:13 am, Sean Christopherson wrote:
>> Gah, I forgot to post a patch that gives intel_pmu_get_msr() the same treatment.
>> I'll replace this patch with the combined version below when applying, or will
>> post it separately if a v5 is needed.
> 
> It's fine for me to apply this new patch first and then apply the remaining
> patches with only a tiny rebase effort (tests still remains healthy). More, if
> you have more comments on any other patches that need changing after
> the radio silence, please roar at me on this version.
> 
>>
>> From: Sean Christopherson<seanjc@google.com>
>> Date: Thu, 26 Jan 2023 17:08:03 -0800
>> Subject: [PATCH] KVM: VMX: Refactor intel_pmu_{g,}set_msr() to align with
>>   other helpers
> 
