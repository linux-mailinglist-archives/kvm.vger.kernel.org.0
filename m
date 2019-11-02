Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5540CECDEC
	for <lists+kvm@lfdr.de>; Sat,  2 Nov 2019 11:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfKBKBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Nov 2019 06:01:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbfKBKBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Nov 2019 06:01:11 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9B8D7882FF
        for <kvm@vger.kernel.org>; Sat,  2 Nov 2019 10:01:10 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id 92so7077597wro.14
        for <kvm@vger.kernel.org>; Sat, 02 Nov 2019 03:01:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9XNTKc5genliBm4pwVnGp5ocSwuijOny5znRUr/6AeE=;
        b=jxcsDo2KCWPmA7IyEZGt9PdyhbLgvPzxVh5rmBOtsqOHzktgG1gG6sWjK+ze3piFCB
         Hxlp92oreG2iP41+0XgstqRjIMW0pct1q9bOzIHRa8nRxo/wOBTeiFxYP8MHSmtuK/fD
         NFhtkuaP6STL1B0C6OxbY+iSs9v6uvgc8PeAFBTfF7b1hdyXhKg/Vpg0iG7PLlfq0bjE
         fXR5Ezk9xw4ADcn+eOMche1isB8mMPhlkOzWoc5tIWWnBUdQt7ZwXcxYh38lJS1nAraw
         ID2cBC+xbye7Kgpkx34zYUcXvqdTq93EGWdEIQvaJp5cu8xf0deSaj8M/bMU/FhZdTih
         4Gnw==
X-Gm-Message-State: APjAAAWZKgOK9iDaZZPSTxa84wrdNIp+G6Q1137OevxZ+UmrBV4bo38r
        ceacMgITNt9LZtGmxWWkzub7ZlJboMNw8t+YntbwB/tBLB+sAfkkhiKC6EpiDdLXdLrSQNnN8vt
        1/PHM9bVehYmL
X-Received: by 2002:adf:b1d2:: with SMTP id r18mr14095110wra.138.1572688869238;
        Sat, 02 Nov 2019 03:01:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzAbnbtaVvZ/Im2kHYX6IDEmFoBtWlaf3txs0fR9HacSgsiPdOBQBsCH7wyWCpWDEDQIlgeIg==
X-Received: by 2002:adf:b1d2:: with SMTP id r18mr14095088wra.138.1572688868989;
        Sat, 02 Nov 2019 03:01:08 -0700 (PDT)
Received: from [192.168.42.35] (mob-31-159-163-247.net.vodafone.it. [31.159.163.247])
        by smtp.gmail.com with ESMTPSA id w15sm10084861wro.65.2019.11.02.03.01.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Nov 2019 03:01:08 -0700 (PDT)
Subject: Re: [PATCH v4 12/17] svm: Temporary deactivate AVIC during ExtINT
 handling
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1572648072-84536-13-git-send-email-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e57e11f4-ec24-6ad1-22ce-97da1910ed02@redhat.com>
Date:   Sat, 2 Nov 2019 11:01:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1572648072-84536-13-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/11/19 23:41, Suthikulpanit, Suravee wrote:
> +		/*
> +		 * IRQ window is not needed when AVIC is enabled,
> +		 * unless we have pending ExtINT since it cannot be injected
> +		 * via AVIC. In such case, we need to temporarily disable AVIC,
> +		 * and fallback to injecting IRQ via V_IRQ.
> +		 */
> +		if (kvm_vcpu_apicv_active(vcpu))
> +			svm_request_update_avic(vcpu, false);

This must be pretty heavy-weight on SMP VMs, even if most ExtINT guests
do not need SMP in the guest.  One alternative is to enable/disable
APICv when LVT or IOAPIC registers are written with ExtINT mode.  Not a
blocker, just an idea to consider.

Paolo
