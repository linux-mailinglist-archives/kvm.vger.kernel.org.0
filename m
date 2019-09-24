Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18EEFBC89E
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 15:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439086AbfIXNMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 09:12:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439036AbfIXNMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 09:12:19 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 31E4A356CE
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 13:12:19 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id t185so804953wmg.4
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 06:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tEOE9hZZ/W3u4arNVlLiKz0fXOL0n+HPkK/pipNCdZY=;
        b=VJpfdcNxP39QkmUPqN3bqNVK7Z06GRj1DDbeiZq2rPSwbXpyuTi2hB3JcB0UeUvWLu
         WsjNUkwGoe6fzuahD/rVrPEQ1iNTYgRuwXgGqbYTLrRlSaM8mnxMAxBGChkRchR/aRdi
         aUtMLcxlqbfuKunDWu97v118SGFLcV2YUjaHeP2jRpzXUszuxvzA9CgTXuiYlVCMBHxq
         7UPFEbZJ63cFFnx9Yf+PWgB+n8m/APRC1sBqFQ5ESoWfPBVZWj+HSJlr+a/nY9MuOW1D
         +gp2YFVHDAxE4DLhdw9thHPJnvhaTvXcBcTX6e+l8CuvN3IC5peFlIsDW3zr+q85jNj/
         N2zA==
X-Gm-Message-State: APjAAAWPE8LVVotHIv6ZelrYFipXYpB3NIn0CcktfRpIsYMxAN7SJicL
        hcowNZ5VKtX9fWWcfVEIjw++Haop4qduwL6qv1mQH9tZ57laExlFxa8RilR9lSIZb+fA3Yd6xWW
        tpOdvRE1RcXvh
X-Received: by 2002:a5d:6043:: with SMTP id j3mr2108975wrt.337.1569330737566;
        Tue, 24 Sep 2019 06:12:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxM30vRdrzgViBjPlQOUXryf1ZvluMBKXcKl1g35ITeSbKDGdaqkmzot/F2m8Ft2auYYQ9OCw==
X-Received: by 2002:a5d:6043:: with SMTP id j3mr2108946wrt.337.1569330737303;
        Tue, 24 Sep 2019 06:12:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id x5sm3050597wrg.69.2019.09.24.06.12.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2019 06:12:16 -0700 (PDT)
Subject: Re: [PATCH v4 8/8] hw/i386: Introduce the microvm machine type
To:     Sergio Lopez <slp@redhat.com>, qemu-devel@nongnu.org
Cc:     mst@redhat.com, imammedo@redhat.com, marcel.apfelbaum@gmail.com,
        rth@twiddle.net, ehabkost@redhat.com, philmd@redhat.com,
        lersek@redhat.com, kraxel@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-9-slp@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2cbd2570-d158-c9ce-2a38-08c28cd291ea@redhat.com>
Date:   Tue, 24 Sep 2019 15:12:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924124433.96810-9-slp@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/19 14:44, Sergio Lopez wrote:
> microvm.option-roms=bool (Set off to disable loading option ROMs)

Please make this x-option-roms

> microvm.isa-serial=bool (Set off to disable the instantiation an ISA serial port)
> microvm.rtc=bool (Set off to disable the instantiation of an MC146818 RTC)
> microvm.kernel-cmdline=bool (Set off to disable adding virtio-mmio devices to the kernel cmdline)

Perhaps auto-kernel-cmdline?

Paolo
