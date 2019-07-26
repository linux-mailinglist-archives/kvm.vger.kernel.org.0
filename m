Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD25A773DC
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 00:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbfGZWKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jul 2019 18:10:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42173 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfGZWKf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jul 2019 18:10:35 -0400
Received: by mail-wr1-f65.google.com with SMTP id x1so5924602wrr.9
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2019 15:10:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3uH6wRDL6m6XJhTTMaf9vseYu7YZD/ywsLcXQB/jjqU=;
        b=Iz/0Xl6AbdQzLG8xIuGbnoNigiz7qTCti35OwWVm9QLzY4lyAjLEyNHo9hEQvMblBV
         bPTIujCkECgFWv7VK6xlXsovNI+gxANdupzBjLV6TbDGhHzGUqi4RqBB/TtbDmVzulIu
         9YUSXkc0NtvvUrZTMY6bbYmTkMK+2vQXBQ582GGHgCCVrRVwEfGwZB6n22bxfDLNQv3e
         42B/8B5p0qnD2CRAe3v5yqZkgIrd8h+Yu5RXHPgzPKaTtX7PkfIMq/jFuCa960QrZzZH
         ngst+EtTnib3TQTnGzvdpRBcsvUgUHhTeu6yfMQDuq1BW+8RDW6ahCFw8/tEen6jb46k
         q0tA==
X-Gm-Message-State: APjAAAWbad+T18rOSixGs4jg0KTj8cYjqrqBfGLPeveQgeQoO2xzL/H5
        RHOFxXDvXLreA0ZDkY9Ian0r7g==
X-Google-Smtp-Source: APXvYqzcff0a62xyZ1uFR2gsycPFMbRcnCLACAl1fTNDob/Jl6sm3/hEJ5mjpbBEtl+zmxqlsSDf9A==
X-Received: by 2002:a5d:568e:: with SMTP id f14mr22603718wrv.167.1564179033572;
        Fri, 26 Jul 2019 15:10:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9036:7130:d6ec:a346? ([2001:b07:6468:f312:9036:7130:d6ec:a346])
        by smtp.gmail.com with ESMTPSA id k9sm37976888wmi.33.2019.07.26.15.10.32
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 15:10:33 -0700 (PDT)
Subject: Re: [PATCH] Documentation: move Documentation/virtual to
 Documentation/virt
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Christoph Hellwig <hch@lst.de>, rkrcmar@redhat.com,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-um@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20190724072449.19599-1-hch@lst.de>
 <b9baabbb-9e9b-47cf-f5a8-ea42ba1ddc25@redhat.com>
 <20190724120005.31a990af@lwn.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <be4ba4a7-a21b-8c56-4517-8886a754ff55@redhat.com>
Date:   Sat, 27 Jul 2019 00:10:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724120005.31a990af@lwn.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/07/19 20:00, Jonathan Corbet wrote:
>  - kvm/api.txt pretty clearly belongs in the userspace-api book, rather
>    than tossed in with:
> 
>  - kvm/review-checklist.txt, which belongs in the subsystem guide, if only
>    we'd gotten around to creating it yet, or
> 
>  - kvm/mmu.txt, which is information for kernel developers, or
> 
>  - uml/UserModeLinux-HOWTO.txt, which belongs in the admin guide.
> 
> I suspect that organization is going to be one of the main issues to talk
> about in Lisbon.  Meanwhile, I hope that this rename won't preclude
> organizational work in the future.

Absolutely not, this rename was just about a badly-named directory.  I
totally agree with the above reorganization.  Does the userspace API
cover only syscall or perhaps sysfs interfaces?   There are more API
files (amd-memory-encryption.txt, cpuid.txt, halt-polling.txt msr.txt,
ppc-pv.txt, s390-diag.txt) but, with the exception of
amd-memory-encryption.txt and halt-polling.txt, they cover the
emulated-hardware interfaces that KVM provides to virtual machines.

Paolo
