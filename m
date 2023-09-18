Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262C17A4959
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 14:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241910AbjIRMMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 08:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241966AbjIRMME (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 08:12:04 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838A6109;
        Mon, 18 Sep 2023 05:11:56 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-402d0eda361so48334335e9.0;
        Mon, 18 Sep 2023 05:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695039115; x=1695643915; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nk6sK+L98Z0Oqp/nQXgUvAOvctfkomMX7KeuEQexiso=;
        b=C7/cgGXhdrWtcn+afZAPCzV39sl96nX6Qv4MCUbgE3hCQX8i7GxG0NxZlKhSZXBSy0
         Uy1QzsKgKvgq9GuagkB/0++rthE+mlwdCUguw2TE3F0uyGB7nRpoGa7JNqlAGYU6cgDS
         KUmCB3v6cz0Xm5jGCtCk68horwsFreGXvhTSASTtEl3r3WrSRzcWODSXSnddb8psQYHT
         MVJP4vrJr0QOOq2t+NiwGbnKrp7++tfZBdw1yskCgudqxSqm+flriaCSa4KJGp4qgss9
         kN5S9SCZYavrlGDVCcd+8Nm+gtU7e+udlfB1fhGF3bcEgN8xYcUXjQq3+rVAetNbkZeT
         lQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695039115; x=1695643915;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nk6sK+L98Z0Oqp/nQXgUvAOvctfkomMX7KeuEQexiso=;
        b=By3zPsgAgo99b0U3dwrTq+7bW1J8ADbmmhVj9blOGgY8ghkDHuiXJp3HD4LVBRQGXu
         tH6bo0uIGyx0X0cjOfdmWRuZ7RkhQcKjLlPYIOTG8Vi4BJrAqTCtAmhPEZaXoyfqyW57
         8A+z57ook+M0ekK8BCIaViygpuGYTCHM65qK8GNt3+XdJR1HtLB4u+0tGfgEQi09i/wV
         tLfz25AWUnSWhSeqqsqPF1ENAr2h8bTCRsT14T7zBJmwlsUtgUGYcIrPJmnXPu6C+hXq
         Kvj3jldJ/tx5zGY4+KKW9cxL1qhh3EZZzszEjwGJzJbIjxdoVg70L4VOWqB6YNKJSGdz
         t5hw==
X-Gm-Message-State: AOJu0Yy7MUVqsLbiq2bHVEtaf31/N8ach21AmbadZKnZ3OY9d+fbqkF7
        s8FOzpDdM0ctpPUEO5AkS8CwwW+AngSEtIsD
X-Google-Smtp-Source: AGHT+IEqLV8hsB03yHLXw+Cq3V5jwj6IAWDD/c9Y7nuaCJs4/WixifxU6P91e6lueQleY5d+eTi26g==
X-Received: by 2002:a1c:7c0e:0:b0:403:cab3:b763 with SMTP id x14-20020a1c7c0e000000b00403cab3b763mr7651013wmc.33.1695039114627;
        Mon, 18 Sep 2023 05:11:54 -0700 (PDT)
Received: from [192.168.7.59] (54-240-197-228.amazon.com. [54.240.197.228])
        by smtp.gmail.com with ESMTPSA id y14-20020a7bcd8e000000b004030e8ff964sm15244651wmj.34.2023.09.18.05.11.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 05:11:54 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <3cf7adca-aa69-4ac8-ca92-f10b1bd2e163@xen.org>
Date:   Mon, 18 Sep 2023 13:11:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 05/12] KVM: pfncache: allow a cache to be activated
 with a fixed (userspace) HVA
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230918112148.28855-1-paul@xen.org>
 <20230918112148.28855-6-paul@xen.org>
 <e4ac95d3370b997c17ce6924425d693a7e856c7e.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <e4ac95d3370b997c17ce6924425d693a7e856c7e.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/2023 12:34, David Woodhouse wrote:
> On Mon, 2023-09-18 at 11:21 +0000, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>>
>> Some cached pages may actually be overlays on guest memory that have a
>> fixed HVA within the VMM. It's pointless to invalidate such cached
>> mappings if the overlay is moved so allow a cache to be activated directly
>> with the HVA to cater for such cases. A subsequent patch will make use
>> of this facility.
>>
>> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> 
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> 
> Btw, I think you have falsified some Reviewed-by: tags on the rest of
> the series. Remember, if they aren't literally cut and pasted, the
> magic gets lost. Just the same as Signed-off-by: tags. Never type them
> for someone else.

Indeed. They were all copied and pasted.

   Paul

