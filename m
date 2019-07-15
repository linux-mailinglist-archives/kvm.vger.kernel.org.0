Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D01E69B0C
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 20:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730008AbfGOSyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 14:54:12 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36066 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729513AbfGOSyM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 14:54:12 -0400
Received: by mail-wm1-f68.google.com with SMTP id g67so12131594wme.1
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 11:54:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RNGLSLPci/xVpfN/c8/80gKCECC+c+2BGduzD302k/o=;
        b=CQBnu6ssofH76BjWA0EynKHVH4FECtDOop1Pd3RhIYSY5pKyaa9EOkvfr/ecXhOCAu
         0/NJigrF9MXlZ5G3BultYFRHZ7CSym8WBpl7eqf6tchYaLG8fTwSmP0AJLatDMt47PwD
         91PgCRfFt01s9wvchkFZVUAZIlqQbfbv1BqswOMyxWIC28vY3dA2/GslCEGdMRndQIOU
         cCiYkUHF2B1Jhxd5U3jk9SDbHnkOGafow6sFt1KNHW7RhPLMVN5GMiW9BTTlgnkDmJCN
         YG9lwaYY4Si2Q910SZqPeRiuogZ7X3oNIlrgX3el5DEtwUwhR0I06dlzfos6UYeXz6Od
         eNWQ==
X-Gm-Message-State: APjAAAXK4dtLVWvDcjbadkx44ijaJw6oaYHGIktJ+C060ALfgsntoBRK
        uM3i/sPFlvkuq/hleL5VXUsxSx1Btuw=
X-Google-Smtp-Source: APXvYqx97L+OtJDvif7wufpIsBlRUADvhS/E0Sg9mVEfAul6xXSaVQziOZez8auCEiLw5nhwE6Wqwg==
X-Received: by 2002:a1c:ca14:: with SMTP id a20mr11088958wmg.71.1563216850845;
        Mon, 15 Jul 2019 11:54:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bca4:e0e3:13b4:ec4? ([2001:b07:6468:f312:bca4:e0e3:13b4:ec4])
        by smtp.gmail.com with ESMTPSA id g8sm20875988wme.20.2019.07.15.11.54.10
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 11:54:10 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Support environments without
 test-devices
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm list <kvm@vger.kernel.org>
References: <20190628203019.3220-1-nadav.amit@gmail.com>
 <20190628203019.3220-4-nadav.amit@gmail.com>
 <20190715154812.mlw4toyzkpwsfrfm@kamzik.brq.redhat.com>
 <FFD1C3FC-C442-4953-AFA6-0FFADDEA8351@gmail.com>
 <ab5e8e73-5214-e455-950d-e837979bb536@redhat.com>
 <9A78B004-E8B8-427A-B522-C0847CBEFDD3@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <91f59a9e-f225-b225-079b-f4ef32724163@redhat.com>
Date:   Mon, 15 Jul 2019 20:54:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <9A78B004-E8B8-427A-B522-C0847CBEFDD3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/07/19 20:43, Nadav Amit wrote:
>> On Jul 15, 2019, at 11:26 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> On 15/07/19 20:08, Nadav Amit wrote:
>>>> This works because setup_multiboot() looks for an initrd, and then,
>>>> if present, it gets interpreted as a list of environment variables
>>>> which become the unit tests **envp.
>>>
>>> Looks like a nice solution, but Paolo preferred to see if this information
>>> can be extracted from e810 and ACPI MADT. Paolo?
>>
>> It was mostly a matter of requiring adjustments in the tests.  Andrew's
>> solution would be fine!
> 
> Ok, but I must be missing something, because the changes I proposed before
> did not require any changes to the tests either (when they are run on top
> of KVM).

You're right, I was confused.  There were changes to a couple tests but
they are not related to fw_cfg.  I only disliked having to repeat the
same information (as opposed to just the initrd path) in all the
entries.  Memory map and MADT would be my preferred choice, but as a
stopgap Andrew's idea is okay.

Paolo

> Andrew’s solution would just make it easier to set “fixed” boot-loader
> entries, although they would still need a different root and
> boot-relative-path on different machines.



