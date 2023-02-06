Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F93068B9A5
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 11:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjBFKPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 05:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjBFKPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 05:15:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FBD1043F
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 02:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675678407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=541RhhlzsaQHgle1Nk79Bgd+WcPXeY3i6TWNGx9WQBk=;
        b=O6SkMEUSsiMzRP8gwNBJP8AsMT1Jof+1NesmYs2uylP7giMQzVA2blmtEojAaUzt1Oi+g4
        DiNj/9c8iD2zNRh6w7cw7yvP/3aE6GVGinMCEKuoo9hWbnEwC7lnU6Mb+wjEjI3AsV+L2o
        xGUBBu8fHG27zjYj6bhhZrIJl5XWwtg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-139-_qQG516bMk6Dd05mocjIyw-1; Mon, 06 Feb 2023 05:13:26 -0500
X-MC-Unique: _qQG516bMk6Dd05mocjIyw-1
Received: by mail-qk1-f197.google.com with SMTP id ay10-20020a05620a178a00b0072db6346c39so6201682qkb.16
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 02:13:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=541RhhlzsaQHgle1Nk79Bgd+WcPXeY3i6TWNGx9WQBk=;
        b=pWr8LCzghuG/7Vm720vV+XKv2pIQoBE0FnlWtYtnHrHwstrtBs5fu5waoM0gaB+doD
         8D4RIJeoEBh+Ycd97v1nurLEaa+LEqpxZ9auLlX62v4Wr8+TuApniyfBf6BR3j7oUm7f
         YdEyo2jwRJm5PDRXA+L77xkWgmJexcpz93QmXqIZaR0gkFcxaZ6wVlidWrfVd3sZ56VI
         WNSnhnNbWmw+dsuZocDqOfyAyyKVRLdSZ2toTA1NAzIM0rTsEQHSHPMm/NhTaTx2UMjf
         Lr2FTyZezErWJoO9GQDPu4a5VdGuIByAXD4z/0lcp7HRlPbd+jsRI9yt3Jt4PfcQUJCB
         k1XQ==
X-Gm-Message-State: AO0yUKVY/akvBE5MWyecY3vIPMvuziPCc6tE9+oQyNBX6RNUy2gbc3fa
        ff7978/HrRuq63Y6DBjuqmYM/yoaVC68ccTsXiSAAqkd/QfsJV3soU+y8IElPvV+RiAz0HgXw9Y
        wThP77Qrke5+x
X-Received: by 2002:ac8:5746:0:b0:3b9:ca95:da6e with SMTP id 6-20020ac85746000000b003b9ca95da6emr28949384qtx.44.1675678406235;
        Mon, 06 Feb 2023 02:13:26 -0800 (PST)
X-Google-Smtp-Source: AK7set/eK/1ZE1EZU9OIuyZJjtHyolv/nA66FESD4737u2k9Alw01F8uxfYI3aEtFOBu/+ITF0qwYg==
X-Received: by 2002:ac8:5746:0:b0:3b9:ca95:da6e with SMTP id 6-20020ac85746000000b003b9ca95da6emr28949368qtx.44.1675678406045;
        Mon, 06 Feb 2023 02:13:26 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-71.web.vodafone.de. [109.43.177.71])
        by smtp.gmail.com with ESMTPSA id 16-20020a05620a049000b0072692330190sm7104714qkr.64.2023.02.06.02.13.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 02:13:25 -0800 (PST)
Message-ID: <dc19cfad-dfbb-b81a-1341-6a60df7f4968@redhat.com>
Date:   Mon, 6 Feb 2023 11:13:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v15 04/11] s390x/sclp: reporting the maximum nested
 topology entries
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-5-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230201132051.126868-5-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/2023 14.20, Pierre Morel wrote:
> The maximum nested topology entries is used by the guest to
> know how many nested topology are available on the machine.
> 
> Let change the MNEST value from 2 to 4 in the SCLP READ INFO
> structure now that we support books and drawers.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>   include/hw/s390x/sclp.h | 5 +++--
>   hw/s390x/sclp.c         | 5 +++++
>   2 files changed, 8 insertions(+), 2 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

