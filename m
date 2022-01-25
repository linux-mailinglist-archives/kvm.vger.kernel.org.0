Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2049849B97A
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 18:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347875AbiAYQ7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 11:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586598AbiAYQ5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 11:57:16 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEE1C0617A4
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 08:54:48 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id x11so14100455plg.6
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 08:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:cc:from:in-reply-to
         :content-transfer-encoding;
        bh=qDE+mb1mMh2scN3w0bXYeClJH9tGX38gYi5qAJmTnpo=;
        b=W00yrs16g/6EJO6BoPY0sx68sO3Vd0jAaGltSN6yXPvvsS03yU3zyZZ9YflW22fbqz
         zNapH0D7rStHd1/LKG7jcSlYrpA+8mT+uHNGLjh1KlWEbbejxG7ouaMh3EpZRN/jFqIz
         38mZn8PfLuf5BkVr8rlX45aYH4FYhpRJsveNlHjzf2cU/GfE+h59Pr4aXpuZAZty9Rag
         K8lt8zmGYGFf5YhYefjeBcjTBbcuBdddxKMxRG2psoyDa3Cc8AyyfUxCTsr0Ph6A/43I
         FS8Twu4dzvOi8hLOgpdCKhgMAtWdOBB9Vuv8nT9+0oNq/Oo1JJQJhNiM+GjpcGeRbVTh
         ERvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:cc:from:in-reply-to
         :content-transfer-encoding;
        bh=qDE+mb1mMh2scN3w0bXYeClJH9tGX38gYi5qAJmTnpo=;
        b=lzkAMBNYnTNK/h1N8vyOHiRWFGE28GajaPCTDbtw7xnFpb22ThBcZgrpf1SzmxYZ+k
         3+OfajPHHzwaccYCRZ81z7VDuMG16tnIDfg5/eKDsCITt36p/rrRdlWNXtrp/4zzmRK/
         DXu7VV4EDtYN4v8LCqStFk8nOXQTxffRmKLd2/QEqcjC3MCpIai7TjUJQs2q2qpTu5kW
         D6GPlaMjTLCl6cinIcQhV92W1f/Sbgn+xgkczhildOStgMld3Hlr94U7/6uoMC4PrqyK
         1XojTh2urRyko7lpCPMkEWFufk+1ckjG0dpAUMG4Pcry2sE0A2DfcyUySmNAT/J+GQP2
         q5pA==
X-Gm-Message-State: AOAM531k2ARjrqWzxNfY1m91XmlfPf6vcRdfjjO0D6NI4VENzVovPHG8
        GTxX5l7CDQ+1KHD/R6DlHOUS/KxKAGA=
X-Google-Smtp-Source: ABdhPJx6NPAGZW4w2N74AMf0RUAV34NDIF7gG2jyU0emngZ6U5D1u+SXKeNw0VBNng79qKm4b34+FA==
X-Received: by 2002:a17:902:d712:b0:14a:d880:f20 with SMTP id w18-20020a170902d71200b0014ad8800f20mr19866967ply.41.1643129688446;
        Tue, 25 Jan 2022 08:54:48 -0800 (PST)
Received: from [192.168.1.33] (154.red-83-50-83.dynamicip.rima-tde.net. [83.50.83.154])
        by smtp.gmail.com with ESMTPSA id z13sm6717038pfj.23.2022.01.25.08.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 08:54:48 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Message-ID: <6ba8efb0-b4e0-dbda-e1f1-fac9dfa847fd@amsat.org>
Date:   Tue, 25 Jan 2022 17:54:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: KVM call minutes for 2022-01-25
Content-Language: en-US
To:     quintela@redhat.com, kvm-devel <kvm@vger.kernel.org>,
        qemu-devel@nongnu.org
References: <87k0enrcr0.fsf@secure.mitica>
Cc:     Mirela Grujic <mirela.grujic@greensocs.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
In-Reply-To: <87k0enrcr0.fsf@secure.mitica>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/1/22 17:39, Juan Quintela wrote:
> 
> Hi
> 
> Today we have the KVM devel call.  We discussed how to create machines
> from QMP without needing to recompile QEMU.
> 
> 
> Three different problems:
> - startup QMP (*)
>    not discussed today
> - one binary or two
>    not discussed today
> - being able to create machines dynamically.
>    everybody agrees that we want this. Problem is how.
> - current greensocs approach
> - interested for all architectures, they need a couple of them
> 
> what greensocs have:
> - python program that is able to read a blob that have a device tree from the blob
> - basically the machine type is empty and is configured from there
> - 100 machines around 400 devices models
> - Need to do the configuration before the machine construction happens
> - different hotplug/coldplug
> - How to describe devices that have multiple connections

- problem realizing objects that have inter-dependent link properties

Mirela, you mention an issue with TYPE_CPU_CLUSTER / TYPE_CPU, is that
an example of this qom inter-link problem?

> As the discussion is quite complicated, here is the recording of it.
> 
> Later, Juan.
> 
> 
> https://redhat.bluejeans.com/m/TFyaUsLqt3T/?share=True
> 
> *: We will talk about this on the next call
> 
> 

