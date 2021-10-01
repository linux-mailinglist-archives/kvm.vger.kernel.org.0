Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CD741F270
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 18:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355235AbhJAQtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 12:49:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27140 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354604AbhJAQty (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Oct 2021 12:49:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633106889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E+wXL4FLopuVdUPifEc7KhUXBKpFTStH9lCl7cgYkOQ=;
        b=LyIBMuvTTX+kDYcbw1IVMdOCEED+uGk1w/nWFW6ewR4c70jjLEIL6f3kOG/snhm0/mpIyj
        EtCuto8WWdTTdzvs5P8v87LZXMiXWFloQOEPQ9B+HiBkYt2k4W+mx2Z0jVkOqkhpdPA3dO
        xiEEJjPrlRITCl4Yd7VBQUbXa7rSTSM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-_S1S6aueNBeOLTixu4z8vA-1; Fri, 01 Oct 2021 12:48:08 -0400
X-MC-Unique: _S1S6aueNBeOLTixu4z8vA-1
Received: by mail-ed1-f70.google.com with SMTP id e21-20020a50a695000000b003daa0f84db2so10921638edc.23
        for <kvm@vger.kernel.org>; Fri, 01 Oct 2021 09:48:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=E+wXL4FLopuVdUPifEc7KhUXBKpFTStH9lCl7cgYkOQ=;
        b=4U3kzAA5FC8VHDs6ZMVlVm5MbKIttLYzNuD7Jqp3IPtN4Mg5vUK7eQtbnmuSdCXvGH
         JZvqeTYGEFDXgYw3yye/3GrBsnIfZBiJBy2QJehDtAbBUeBYRZj1Z1auKNluezeazogV
         suYi1+R177exjcTYsnWkjKVRVnerCt5JeqZ/kBT8NpeAfwmjur9Uz1bZdo1bVVzdUDKJ
         titppjRFIG8qApWOg2ZTPrTt5iaXgEtSLNcgeLDDRGg4QeoJAdLYNUqlyIrLguamA/hn
         CiJGO/+iFkfi1ms86qaIgb8hxUbO2cNm487xHsaklX9yl/QLnbFUHfcH5SoTHgH/hOPR
         54FQ==
X-Gm-Message-State: AOAM532giGrezt63u2oQH+bM0xhHKEj3DiWgrWlkkwQJqiADbnYZPclq
        LnN2fiogPjLrZGaJZO3ZDQpj/+yNiKgzVTP+Dd29+LZ3wIExFQB2e4iE/L71o6rqETkUQa5MlHO
        alJRl/YCwWVoO
X-Received: by 2002:a50:becf:: with SMTP id e15mr15556197edk.114.1633106887591;
        Fri, 01 Oct 2021 09:48:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyY/s9Eboq39fJzh2TN3pYZqcwpynGpENIpX504ZIFL6jL/Hkr+B3PpnPZt2v05b/8B27zGqA==
X-Received: by 2002:a50:becf:: with SMTP id e15mr15556157edk.114.1633106887363;
        Fri, 01 Oct 2021 09:48:07 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id kw10sm3170950ejc.71.2021.10.01.09.48.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 09:48:06 -0700 (PDT)
Message-ID: <ec78c9ec-bba6-eac7-ac07-5614f0e0d709@redhat.com>
Date:   Fri, 1 Oct 2021 18:48:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 5/7] kvm: x86: protect masterclock with a seqcount
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-6-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210916181538.968978-6-oupton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/09/21 20:15, Oliver Upton wrote:
> +	seq = read_seqcount_begin(&ka->pvclock_sc);
> +	do {
> +		use_master_clock = ka->use_master_clock;

Oops, the "seq" assignment should be inside the "do".  With that fixed, 
my tests seem to work.  I will shortly push the result to kvm/queue.

Paolo

