Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 746D1D0A7C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 11:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbfJIJBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 05:01:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbfJIJBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 05:01:21 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 501FA7E422
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 09:01:21 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id 190so744652wme.4
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 02:01:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=THMxQozkuZcvJWHmfL9vI/wdlPo7narpF+xJ9DGd+Vo=;
        b=tb8tDXtY7OnH+2TLFgYf/7FApa4RXCmNC2Qvjvqr9eBGERd0CDJN+63D4a6cG9CaEK
         IAUBcAPD67gifj98s5GLdXmqMInxq4OuSQEMA82bvS8WFfzjH+xqTXgDx9pvLnqfUnXr
         DSleQ3VniG6NM5PjMobm7gRH8BgekU3g/q3/oAVcca0un49QvFHA2xfBttgmrDRmKNQa
         PfdBnrZrZ+4Qg8mPjmMIpY0qX6Tvo+gTjJdgr5EM2lTznxOT+ZSP752/9A3GQMQh5yzL
         8V5RbPgL9NJpEJdDCJ7bx8bjNZaf3VdhYpMfbCXpZPvEUpkT9w1hTh02ZnIbdYxXVBaU
         o6HQ==
X-Gm-Message-State: APjAAAXdR8RPjetSMdW7XcLqiKxMWklQOOybPU+b9D9CVDjXao67yKEN
        w1ujG0cxLzRzQi/dNfX5xDVmDjS7OluWzZkTO1kZAWNQ2BKZsmwSZgnxOHzBlODDQ8pCShhz8xs
        FGTT0ff83SAFC
X-Received: by 2002:a1c:444:: with SMTP id 65mr1729329wme.73.1570611679949;
        Wed, 09 Oct 2019 02:01:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwQ0Spy7U6b79LWUb5d3SO9ulf2mGM4h5mzhDt6TJ71iR8Wgb7O4B9ro7AFV3M6sQU7wVNQOQ==
X-Received: by 2002:a1c:444:: with SMTP id 65mr1729308wme.73.1570611679704;
        Wed, 09 Oct 2019 02:01:19 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a192sm1558196wma.1.2019.10.09.02.01.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 02:01:19 -0700 (PDT)
Subject: Re: [PATCH v3 00/16] kvm: x86: Support AMD SVM AVIC w/ in-kernel
 irqchip mode
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1568401242-260374-1-git-send-email-suravee.suthikulpanit@amd.com>
 <ea9dd7d9-f02c-6b05-88b5-d766bb837ed3@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ea6fd945-f341-8577-2640-d0d74013a500@redhat.com>
Date:   Wed, 9 Oct 2019 11:01:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ea9dd7d9-f02c-6b05-88b5-d766bb837ed3@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/10/19 20:44, Suthikulpanit, Suravee wrote:
> Ping:
> 
> Hi All,
> 
> Are there other concerns or suggestions for this series?

I've now reviewed it---sorry for the delay.

Paolo
