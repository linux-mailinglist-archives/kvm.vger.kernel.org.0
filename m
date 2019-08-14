Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83E8E8D49A
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 15:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfHNNZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 09:25:18 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45579 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727954AbfHNNZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 09:25:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id q12so20810440wrj.12
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2019 06:25:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v8bm6m3peCAV3vYnBeExpv1o4YspqypQDdeC2k7BzX8=;
        b=azgZNVBYA7u7Sa9QfKtNeEltbxy9nJ2IkWkM1OVDz9THvnG+Izy7a9zO6fkIbCkJgS
         w0bZ5FvS4l1KxykKw+AkAV0leQ9nIS8yaagNkeIH9XQtwIUE/XWhOYfaWEysy9Q2S5UQ
         O9GfG0cBoWr8QMzQOLwZ1FNwtFyTUHtfNe32UtxvWx7ZLI2W57crRLaoErh6zIno/RaG
         6pK0Kspirh+JLspOW2rZiNq1qhzkdL05gCKIp1r+3LAJQaP6T80aOQmgQqPpLnLBoRK4
         JQr8b1xLrJAVTzUW468NgZGk69hiSDAx77e8RtUIHWI0NGSiyZ9raJP3DTda4ocHaqoo
         QUKw==
X-Gm-Message-State: APjAAAWfaXzRPIDztrtcYU2GZb1zhoZHdB/o7r1vXpvS++MkODCxKlsn
        meCAqeBqVAh40fybkPgxDjw05A==
X-Google-Smtp-Source: APXvYqxde+YHLJmjC1TeaB9ENf1+EmXmIoLOJNZrBdqWF8VJIiPT5sc+dopQuVnlJQWITzCdKPqoIw==
X-Received: by 2002:adf:cd11:: with SMTP id w17mr25787597wrm.297.1565789116116;
        Wed, 14 Aug 2019 06:25:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:2cae:66cd:dd43:92d9? ([2001:b07:6468:f312:2cae:66cd:dd43:92d9])
        by smtp.gmail.com with ESMTPSA id 7sm3292854wmj.46.2019.08.14.06.25.15
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 06:25:15 -0700 (PDT)
Subject: Re: [PATCH v4 0/7] x86: KVM: svm: get rid of hardcoded instructions
 lengths
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190813135335.25197-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ae26aa4d-eb98-cdd5-1338-11a46d440584@redhat.com>
Date:   Wed, 14 Aug 2019 15:25:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813135335.25197-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/19 15:53, Vitaly Kuznetsov wrote:
> Changes since v3 [Sean Christopherson]:
> - add Reviewed-by tag to PATCH5
> - __skip_emulated_instruction()/skip_emulated_instruction() split,
>   'unlikely(r != EMULATE_DONE)' in PATCH2
> - Make nested_svm_vmrun() return an int in PATCH6 (moved from PATCH7)
> - Avoid weird-looking 'if (rc) return ret' in PATCH7
> 
> Original description:
> 
> Jim rightfully complains that hardcoding instuctions lengths is not always
> correct: additional (redundant) prefixes can be used. Luckily, the ugliness
> is mostly harmless: modern AMD CPUs support NRIP_SAVE feature but I'd like
> to clean things up and sacrifice speed in favor of correctness.

Queued, thanks.

Paolo
