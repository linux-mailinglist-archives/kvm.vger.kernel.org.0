Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1079158776C
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbiHBHFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbiHBHFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:05:15 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622A92619
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:05:14 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x2-20020a17090ab00200b001f4da5cdc9cso7496389pjq.0
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 00:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Quf3cC0wB+uXGemIlxn6QKl7G+T404J8dS7XiaFKVwk=;
        b=H82BqZnx+1jJYif3KvnRpKPRvPdoDmgIqZ26Wabdqs/3c96elCRhV7YyL3P4VxVq+3
         eOE2TPe0Za4nNamr0N8+dFsHX/pu3zZBeRxCa5lJmnop1uS9N8eyGbh35BQsJhB6egyF
         nr9xbvso7tdk9wnlBHKoJRD1ZWgit60N2iWFw5+krJq2JXlozn8tN8kvluDUn/bNHE6r
         rgTIt4zMSiMHCZLGg5xLS00YmBUI8gnIA5Hnz7/xj9sakbGk+lA4OXoXRr75PhsbAT/i
         KI5LVrXvqR4982XRxkD1yutoBEIMTUfIOKrPHRMsTfFRzRYMVcWLUI5Bwd6QdLUYrIiH
         VBCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Quf3cC0wB+uXGemIlxn6QKl7G+T404J8dS7XiaFKVwk=;
        b=2htYZceBM0GohsO018gWJqY5ucWVvxlnpF1kAIUZHFsV5CcMUBNS7ll5dS9pEV1zea
         f7FqOxoRRPVHLwX8MPN5NnDV0e4kgklV05taWGS5J9DMLcdU+kczpErP+du3Q6U/6xX/
         yX8gqUtzI4kXEAZqPZijsjQ2E1R3YtLsrVOY+rMSLOLc085k9HO2t05/zQUpxochQaGC
         XikD+KFQPdI4RGCXi+PwmeOE2MV9QOfPF24DljN4Her+O5mdWWMfx7qdgHuXr2sbwyIz
         vGoKixv7ZO9qw2JgMs9d1QzDGN43Ci2Py1sIg8MaFIJ9DsHsxXdQNo4wnCbaIM2M6BF9
         /UzQ==
X-Gm-Message-State: ACgBeo26Q9kOV5dD7AEyuOwsmEYtOCnH6iGGxdEqDojP9WgSO/cf3zwf
        DljXDaXOSfqnCxMaAnk4GjQ=
X-Google-Smtp-Source: AA6agR6GS4LSYP6lIK4i3lt/d2lPP4J0Ocm103IoaFBw8JG7gJoHm93pwEkHTtzgwmPrl74U91CPgg==
X-Received: by 2002:a17:902:a513:b0:16c:e25e:16b with SMTP id s19-20020a170902a51300b0016ce25e016bmr20043898plq.86.1659423913755;
        Tue, 02 Aug 2022 00:05:13 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t1-20020a1709027fc100b0016db1b67fb9sm10835793plb.224.2022.08.02.00.05.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Aug 2022 00:05:13 -0700 (PDT)
Message-ID: <9dce3dbb-ffa1-687a-d1c4-8234d1bf6cfb@gmail.com>
Date:   Tue, 2 Aug 2022 15:05:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Reset the expected count of the
 fixed counter 0 when i386
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20220801131814.24364-1-likexu@tencent.com>
 <Yuf0uJeN5n3AvXPg@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Yuf0uJeN5n3AvXPg@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/2022 11:43 pm, Sean Christopherson wrote:
> Not directly related to this patch...
> 
> Unless I've missed something, every invocation of start_event() and measure() first
> sets evt.count=0.  Rather than force every caller to ensure count is zeroed, why not
> zero the count during start_event() and then drop all of the manual zeroing?
> 

None object to this idea, after all, there is obvious redundancy here.

> diff --git a/x86/pmu.c b/x86/pmu.c
> index 01be1e90..ef804272 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -141,7 +141,7 @@ static void global_disable(pmu_counter_t *cnt)
> 
>   static void start_event(pmu_counter_t *evt)
>   {
> -    wrmsr(evt->ctr, evt->count);
> +    wrmsr(evt->ctr, 0);

Now we have to fix the last call to measure() in check_counter_overflow(), since 
it will
also call start_event() after it has been modified and in that case, the 
requested high count
has to be passed in from another function parameter.

Also, the naming of start_event() does not imply that the counter will be set to 
zero implicitly,
it just lets a counter continue to run, not caring about the current value of 
the counter,
which is more flexible.

I may try to do that on the test-cases of AMD vPMU, to help verify the gain of 
your idea.

>       if (is_gp(evt))
>              wrmsr(MSR_P6_EVNTSEL0 + event_to_global_idx(evt),
>                              evt->config | EVNTSEL_EN);
> 
> 
> Accumulating counts can be handled by reading the current count before start_event(),
> and doing something like stuffing a high count to test an edge case could be handled
> by an inner helper, e.g. by adding __start_event().
