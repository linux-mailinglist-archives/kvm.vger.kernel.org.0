Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D677B4B5071
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 13:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236461AbiBNMmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 07:42:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234782AbiBNMmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 07:42:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF8B449680
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 04:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644842543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zq/K4p6LKT9H84srQk7xhAQc5oPoLH8nxRI/30HZAUM=;
        b=hJ2CgEPkhCzUlrcjzLqxPF1RM/5XWfNl+yIljF+jbXW3UNvLtWuEwfmVRnkghV1hLWPRqK
        oM5n2yNRk69sNLAA3ZcT0HXw3EZITwt4Md6tNnfKHRgQZ4ex27W201EIyxeMZxCOsa6KY/
        fbB8XGo8nDQCEuKWvR5sm4HOUg7r/i0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145--PUl3LAlNCWkNUyWEO48YA-1; Mon, 14 Feb 2022 07:42:22 -0500
X-MC-Unique: -PUl3LAlNCWkNUyWEO48YA-1
Received: by mail-ed1-f70.google.com with SMTP id cr7-20020a056402222700b0040f59dae606so10154133edb.11
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 04:42:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zq/K4p6LKT9H84srQk7xhAQc5oPoLH8nxRI/30HZAUM=;
        b=v6dDGXARItS8YFPQPOwr5Ud6I1o8Rg99WIpJJE38Hl1i4nqJgMc/qse9UCNjg9fFmH
         Lj55K0tvuD/yOPsiDG7F9814v7fnMzpiRHouJDJpd2b+tC1JczwTh6Y5ssA12qMjJXkI
         CET8DTGXuHJD2rNK5aEMkweLQEyDxhM2ZdUOUniZOuE2bFB+T6CGApIGZXc+r/yPrd1L
         xjkTxCLfTEdWCdIKafPQ5r9ZgcYBs+yNr8ApYLiFG2nwqBj4icViZaWkkGvUUr3qZ0fl
         XxgY4IfO2JZUgXktfCShPS2n49N/kGqzVFe2nyLZO+YLjSksTzetNvvIQHsVAawMiwnv
         5sNg==
X-Gm-Message-State: AOAM5328JEzAWJjAOixaqYWxNgiUfAL9ReQEm51aiLdHkdNUScpHduxk
        qGTZtWsaaP4Exu/PuZBnvd6ysBBiVV+8e3/EHlqUqEK7jVxxSSGZ9zKegSvOlsx/nWxJGuNScCQ
        bjq1eWpEUrMHW
X-Received: by 2002:a17:907:8a1d:: with SMTP id sc29mr3112991ejc.314.1644842541307;
        Mon, 14 Feb 2022 04:42:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxqwKqA/18BuzSefuLM0dAPIuVzOrfIWR+OTsAGfE5gexj2vu7Yahx947tlAA6R4App36gv2A==
X-Received: by 2002:a17:907:8a1d:: with SMTP id sc29mr3112973ejc.314.1644842541056;
        Mon, 14 Feb 2022 04:42:21 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id q7sm7475790ejj.8.2022.02.14.04.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 04:42:20 -0800 (PST)
Message-ID: <85f7d07f-20f2-4605-0a04-e68987f2750b@redhat.com>
Date:   Mon, 14 Feb 2022 13:42:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] x86 UEFI: Fix broken build for UEFI
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com
References: <20220210092044.18808-1-zhenzhong.duan@intel.com>
 <Ygo5o7+j1ALOSwtY@monolith.localdoman>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ygo5o7+j1ALOSwtY@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/14/22 12:14, Alexandru Elisei wrote:
> Hi,
> 
> On Thu, Feb 10, 2022 at 05:20:44PM +0800, Zhenzhong Duan wrote:
>> UEFI loads EFI applications to dynamic runtime addresses, so it requires
>> all applications to be compiled as PIC (position independent code).
>>
>> The new introduced single-step #DB tests series bring some compile time
>> absolute address, fixed it with RIP relative address.
> 
> With this patch the error:
> 
> ld: x86/debug.o: relocation R_X86_64_32S against `.text' can not be used when making a shared object; recompile with -fPIC
> 
> disappears and I can now build kvm-unit-tests for x86_64 when configured
> with --target-efi:
> 
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

Applied, thanks.

Paolo

