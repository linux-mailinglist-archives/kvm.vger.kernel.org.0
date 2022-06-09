Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB815458E4
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 01:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237495AbiFIX6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 19:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiFIX6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 19:58:04 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1FA1B586F
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 16:58:03 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id e66so23247080pgc.8
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 16:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JAJP3OZiiXRmUnwBXEpDieTWJpbglY+QSS3c6IUFAEs=;
        b=chHSNPktdpo+Jx8lJ9pjXu1uch3qBvi8yNLvSmQdlaWgPihtyZMZRBVcen/0bFdIiJ
         DUvLQS4Ssn7obIur8WPjtKo3gtpVsPXB8CzNrqs+LjCpXmuMozIx00KYc31SMFRNprOe
         C4pbpAd9lYcxayA+rq6dW8n9OPmOjAwmb6DDhBmdfF7/Dn8l+Sap664Mn9J3WFJoBV3H
         V/va6coC+QVDd6abSilRPzCGPbQ/c2MZFPccJKr+nFE90XssqV2bcXy6sEJCA2SGWpXB
         WswBGiUtsDxlFBe6GWPlAZWiokle1Wasfz6YkkzoJjVIwVBHspbn5jZ9HpQEQtDJUm/w
         /A+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JAJP3OZiiXRmUnwBXEpDieTWJpbglY+QSS3c6IUFAEs=;
        b=kQnml2zh1GtuNCeoRE8UCP8GwRx8EJz5GbqDJJ7dSJMH8WwzYa18rTMfvVzgk5j9k1
         190Q5WR98GPAAV0nDKT/WfZtTKz6ynInAJ9BxT9YjEaLutmnHYeMt3zS5qJcKrjmm2o4
         em+fezAximnQJypnJN6Lrma8RN3E4L3YncOk4QIUvfo1phDTbmUiq2sk3f/yW4+hOpfT
         nsSxXCM7bZXvLwl5x0GZ99rjgsFjKbL2HINWtAaL/aJDE/5tjfQrrPnNP0vjmc1ibgIt
         exmX53oSS6plSjvsP6MPZAIs8EfRWe+8HEK4CHRxF2Gm70Kd3FlFDwhr6oHBqXFG+nrz
         T+2w==
X-Gm-Message-State: AOAM533Ecaqlfd96zj51G5dTGkzPbdGaqgJrd7U4l6jb/Zds9ZV+cC0K
        cd8TDuZaAo58npQtHx4NBUE=
X-Google-Smtp-Source: ABdhPJz/4kSqVq23Nt3JM/SwJ9F2M9rK7LZcwfiBcXxXPMeDOg6wCANZ7RK7j6toTfWMA/QC11NAZw==
X-Received: by 2002:a62:7b4c:0:b0:51b:9c0e:a03d with SMTP id w73-20020a627b4c000000b0051b9c0ea03dmr42654844pfc.54.1654819083130;
        Thu, 09 Jun 2022 16:58:03 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.22])
        by smtp.gmail.com with ESMTPSA id i189-20020a636dc6000000b00401bf2a6e08sm348347pgc.93.2022.06.09.16.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 16:58:02 -0700 (PDT)
Message-ID: <2bd56b9f-cf27-f4a3-321f-1b1b11172bc0@gmail.com>
Date:   Fri, 10 Jun 2022 07:57:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH 2/3] x86: Skip running test when pmu is
 disabled
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
References: <20220609083916.36658-1-weijiang.yang@intel.com>
 <20220609083916.36658-3-weijiang.yang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20220609083916.36658-3-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/6/2022 4:39 pm, Yang Weijiang wrote:
> +	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);

Nit, check the PDCM bit before accessing this MSR.
