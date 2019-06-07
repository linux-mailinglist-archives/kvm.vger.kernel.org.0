Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C78F738A08
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 14:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbfFGMTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 08:19:24 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52659 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728477AbfFGMTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 08:19:24 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so1855964wms.2
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2019 05:19:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kfSHj8gE2BZ00d/KvgMT+jG4F0VNY8qmbsimYDTPJmw=;
        b=kqq2HG2jHSa0styWBl32s+x2GZWUgq/HXnJsmDPSdZ4kHsfpu66KFndNaS31HFVL0L
         3rwefAeXk8PXtsSVCQArlDngLnKsPc8cPAa/PtePdiUqorrDBm7QhRNlbwwlhNY7ito7
         aMODZyTHDMqB7ziOZ0D6AKSImLFK68DYwFQD9GkV85QoV0ZawdEnjWB5WXYswWhuIey7
         ajBGYnCJvI+W/kBlJA6kUewCg1wthrbBNkMBIC/U2kaS4p3sFK8AEed2pLhRG5u7AY0N
         mTrsmkTgoMWYI3dgouXzOd9sQxNT6tYgVus+h9HkrXPXOWgtT0GNgHTN/DaQUU+VrKyU
         J8MQ==
X-Gm-Message-State: APjAAAXIAf1NxB+VRd1CUjvHs6IyA/K9mE4suGVeLAhP1iG0+WiBWXmP
        H9dON9QMW8pKIF/RY7TsMU1+pnexk2I=
X-Google-Smtp-Source: APXvYqySOcFxw2kk9lDHDgMzNCwDwUWD5eY/j8mlb+Yty+9tmvopHn57wdfq/dhziB9fNrAY3xELaw==
X-Received: by 2002:a1c:df46:: with SMTP id w67mr3344706wmg.69.1559909962473;
        Fri, 07 Jun 2019 05:19:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id s11sm1559025wro.17.2019.06.07.05.19.21
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 05:19:21 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Rename prepare_vmcs02_*_full to
 prepare_vmcs02_*_extra
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1559834652-105872-1-git-send-email-pbonzini@redhat.com>
 <20190606184117.GJ23169@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8382fd94-aed1-51b4-007e-7579a0f35ece@redhat.com>
Date:   Fri, 7 Jun 2019 14:19:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190606184117.GJ23169@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/06/19 20:41, Sean Christopherson wrote:
>> +static void prepare_vmcs02_early_extra(struct vcpu_vmx *vmx,
> Or maybe 'uncommon', 'rare' or 'ext'?  I don't I particularly love any of
> the names, but they're all better than 'full'.

I thought 'ext' was short for 'extra'? :)

Paolo
