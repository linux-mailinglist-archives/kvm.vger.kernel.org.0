Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07FBA657BA
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 15:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbfGKNM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 09:12:28 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39618 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfGKNM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 09:12:28 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so6242262wrt.6
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 06:12:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SedpGwpa+TzP+Tw8U4kKXx/ue/oCxq3AkkH2aws1Go4=;
        b=ryLDahzsoYn2YpjYVK2uRan0sQ3vxwzsBr72njgdC+IaUhMe9NM0qFf4EWpF7dF/4+
         JLJ0/q6oz3tib0XZJkv7BuRTlxWY0Q2ure/xFrJlCI3xUT2DNhz+AsHaUaHhpB3GZT/J
         M1SvKFC6ETjecdbOEnt1JF1s1Bep3ljQ3WVtY2M9ljOwXoPl/DNlLF6kTUH2mKUx/yWt
         pVhZVqW32KoJrwgttfyq9evrRBD6inwPseMhRS5G+8e3URItZLhrawTOjXYptGm1cpeE
         9UcmMGROmGPMZvNjHeI7RQ3llNLnZK8Fwb/r55XRLiLLWhlTpNc7kQ5qC3ONV01IQAxj
         Wmng==
X-Gm-Message-State: APjAAAX6CtFzEFx3NAojYXlbtYnXHCToRTo0YVU7eFabtZKN4h9TYPq+
        40Wq0gibLXzLNnlkO692e1BTJtnVja8=
X-Google-Smtp-Source: APXvYqx9dYIH3tAH4W7eSBZgsncX3gZm/zwLsnFy8PC2c6/T1lW4P+rLY07/xQofir8GItxjk+jLNA==
X-Received: by 2002:adf:ebcd:: with SMTP id v13mr5206517wrn.263.1562850746522;
        Thu, 11 Jul 2019 06:12:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id n5sm4717507wmi.21.2019.07.11.06.12.25
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 06:12:25 -0700 (PDT)
Subject: Re: [PATCH v3 3/3] Documentation: virtual: Add toctree hooks
To:     Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>,
        KVM list <kvm@vger.kernel.org>
References: <20190710153054.29564-1-lnowakow@neg.ucsd.edu>
 <20190710153054.29564-4-lnowakow@neg.ucsd.edu>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <44f68c0c-d447-e8e2-7fd4-c66331819e49@redhat.com>
Date:   Thu, 11 Jul 2019 15:12:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710153054.29564-4-lnowakow@neg.ucsd.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/19 17:30, Luke Nowakowski-Krijger wrote:
> +===========================
> +Linux Virtual Documentation
> +===========================

Changed this to "Linux Virtualization Support" and queued, thanks!

Paolo
