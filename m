Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC6015AA8B
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 14:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgBLN5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 08:57:43 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49555 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728052AbgBLN5n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 08:57:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581515861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XhZU1+6bKYY6WdUOFJEVR29ZW1MDpAhntuL3EmoRqyM=;
        b=MBnhcpdRrNCNee3xy4+Txh+YIPJdvuJ7lZBgB4PWDZNljntcaJqHYnYoTcZ51AX4+5vkhQ
        wUnyf3E02CZTmJmYqrOAJdPsx0rD5J5kfZeGpvFCHsgqocNZUuivlrHjmjllgW8AJ9xeRi
        dmVKDyx0v3Vakk/DEgUftAyydcK7NPE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-s08OfCK1Mbu-2IoKWV0uag-1; Wed, 12 Feb 2020 08:57:39 -0500
X-MC-Unique: s08OfCK1Mbu-2IoKWV0uag-1
Received: by mail-wr1-f70.google.com with SMTP id 90so847431wrq.6
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 05:57:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XhZU1+6bKYY6WdUOFJEVR29ZW1MDpAhntuL3EmoRqyM=;
        b=RY2CQZkd5HBkbMUWxQxq6cytFPMa4CnKWvOa1dMwsm8pk+sA0rjTs5KHK18Q9PlqWl
         g/ojQniQ7TpKUkGFtfXmgtMgHj5Yq7bcwVkhkwdFLPw+VjyQluLlMPzSwdHot/qzpC64
         n9avNrDVKNisUMa0vSbkBG2tV7oGBZo8jcIOS7epZn11mbXHH/83BSbM9zuQqMgEBXO5
         k1SINugjOievZqYkltyZ2FnluSE5SCDmULfmJuWGBKZmXGxzBnGI0vdCwTVmt0tp35p1
         0lbom26Xa1IyAdK7jF/l0srF5ZfrIt4Rqx8/pq36mL2Jc8om+jAnbzk1XF1HHXY0WF21
         KNdg==
X-Gm-Message-State: APjAAAViqyBzjG1qVV0iTh6P3ipM8hERY4MsH9F+Of93q0oWWtJ0iFb+
        OLuTdf7pS5X1BDV9d6j09d+1+fw13Nt9wDQsO9SV7bJiEAF8gz0+GbXTOY4KIP+HBbunEjLlkjo
        +b0tUDIBsNDR/
X-Received: by 2002:adf:ec83:: with SMTP id z3mr14899117wrn.133.1581515857774;
        Wed, 12 Feb 2020 05:57:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqx1UL41yok/NYFVCUGXeIq9qvVNdc4F1tTrJr6pnhP9ZMJWkRNMNVE/JPhpbyhfdNhHDw2z/g==
X-Received: by 2002:adf:ec83:: with SMTP id z3mr14899096wrn.133.1581515857454;
        Wed, 12 Feb 2020 05:57:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id f8sm769782wru.12.2020.02.12.05.57.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 05:57:36 -0800 (PST)
Subject: Re: [PATCH 00/28] docs: virt: manually convert text documents to ReST
 format
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org, linux-um@lists.infradead.org,
        Jonathan Corbet <corbet@lwn.net>,
        Jeff Dike <jdike@addtoit.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>, kvm@vger.kernel.org
References: <cover.1581314316.git.mchehab+huawei@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f624c644-56e5-9f74-61b4-de6165145d10@redhat.com>
Date:   Wed, 12 Feb 2020 14:57:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <cover.1581314316.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/02/20 07:02, Mauro Carvalho Chehab wrote:
> Manually convert the documentation under Documentation/virt to ReST,
> minimizing the usage of uneeded markups and preserving the documentation
> writer's style.
> 
> PS.: Patches are against linux-next tree (20200204).
> 
> v3:
> 
> - locking.rst now uses tables for the two concurrency examples;
> - The file guest-halt-polling.txt was still under Documentation/virtual.
>   Converted to ReST and moved to Documentaion/virt;
> - Addressed the issues pointed by Cornelia and Paolo.
> 
> v2:
> 
> - Solved a conflict with linux-next;
> - Added SPDX headers.
> 
> 
> Mauro Carvalho Chehab (28):
>   docs: kvm: add arm/pvtime.rst to index.rst
>   docs: virt: convert UML documentation to ReST
>   docs: virt: user_mode_linux.rst: update compiling instructions
>   docs: virt: user_mode_linux.rst: fix URL references
>   docs: virt: convert halt-polling.txt to ReST format
>   docs: virt: Convert msr.txt to ReST format
>   docs: kvm: devices/arm-vgic-its.txt to ReST format
>   docs: kvm: devices/arm-vgit-v3.txt to ReST
>   docs: kvm: convert devices/arm-vgit.txt to ReST
>   docs: kvm: convert devices/mpic.txt to ReST
>   docs: kvm: convert devices/s390_flic.txt to ReST
>   docs: kvm: convert devices/vcpu.txt to ReST
>   docs: kvm: convert devices/vfio.txt to ReST
>   docs: kvm: convert devices/vm.txt to ReST
>   docs: kvm: convert devices/xics.txt to ReST
>   docs: kvm: convert devices/xive.txt to ReST
>   docs: kvm: Convert api.txt to ReST format
>   docs: kvm: convert arm/hyp-abi.txt to ReST
>   docs: kvm: arm/psci.txt: convert to ReST
>   docs: kvm: Convert hypercalls.txt to ReST format
>   docs: kvm: Convert locking.txt to ReST format
>   docs: kvm: Convert mmu.txt to ReST format
>   docs: kvm: Convert nested-vmx.txt to ReST format
>   docs: kvm: Convert ppc-pv.txt to ReST format
>   docs: kvm: Convert s390-diag.txt to ReST format
>   docs: kvm: Convert timekeeping.txt to ReST format
>   docs: kvm: review-checklist.txt: rename to ReST
>   docs: virt: guest-halt-polling.txt convert to ReST
> 
>  .../guest-halt-polling.rst}                   |   12 +-
>  Documentation/virt/index.rst                  |    2 +
>  Documentation/virt/kvm/{api.txt => api.rst}   | 3348 ++++++++++-------
>  .../virt/kvm/arm/{hyp-abi.txt => hyp-abi.rst} |   28 +-
>  Documentation/virt/kvm/arm/index.rst          |   12 +
>  .../virt/kvm/arm/{psci.txt => psci.rst}       |   46 +-
>  .../{arm-vgic-its.txt => arm-vgic-its.rst}    |  106 +-
>  .../{arm-vgic-v3.txt => arm-vgic-v3.rst}      |  132 +-
>  .../devices/{arm-vgic.txt => arm-vgic.rst}    |   89 +-
>  Documentation/virt/kvm/devices/index.rst      |   19 +
>  .../virt/kvm/devices/{mpic.txt => mpic.rst}   |   11 +-
>  .../devices/{s390_flic.txt => s390_flic.rst}  |   70 +-
>  Documentation/virt/kvm/devices/vcpu.rst       |  114 +
>  Documentation/virt/kvm/devices/vcpu.txt       |   76 -
>  .../virt/kvm/devices/{vfio.txt => vfio.rst}   |   25 +-
>  .../virt/kvm/devices/{vm.txt => vm.rst}       |  206 +-
>  .../virt/kvm/devices/{xics.txt => xics.rst}   |   28 +-
>  .../virt/kvm/devices/{xive.txt => xive.rst}   |  148 +-
>  .../{halt-polling.txt => halt-polling.rst}    |   86 +-
>  .../kvm/{hypercalls.txt => hypercalls.rst}    |  129 +-
>  Documentation/virt/kvm/index.rst              |   16 +
>  Documentation/virt/kvm/locking.rst            |  243 ++
>  Documentation/virt/kvm/locking.txt            |  215 --
>  Documentation/virt/kvm/{mmu.txt => mmu.rst}   |   62 +-
>  Documentation/virt/kvm/{msr.txt => msr.rst}   |  147 +-
>  .../kvm/{nested-vmx.txt => nested-vmx.rst}    |   37 +-
>  .../virt/kvm/{ppc-pv.txt => ppc-pv.rst}       |   26 +-
>  ...iew-checklist.txt => review-checklist.rst} |    3 +
>  .../virt/kvm/{s390-diag.txt => s390-diag.rst} |   13 +-
>  .../kvm/{timekeeping.txt => timekeeping.rst}  |  221 +-
>  ...odeLinux-HOWTO.txt => user_mode_linux.rst} | 1814 ++++-----
>  31 files changed, 4194 insertions(+), 3290 deletions(-)
>  rename Documentation/{virtual/guest-halt-polling.txt => virt/guest-halt-polling.rst} (91%)
>  rename Documentation/virt/kvm/{api.txt => api.rst} (71%)
>  rename Documentation/virt/kvm/arm/{hyp-abi.txt => hyp-abi.rst} (79%)
>  create mode 100644 Documentation/virt/kvm/arm/index.rst
>  rename Documentation/virt/kvm/arm/{psci.txt => psci.rst} (60%)
>  rename Documentation/virt/kvm/devices/{arm-vgic-its.txt => arm-vgic-its.rst} (71%)
>  rename Documentation/virt/kvm/devices/{arm-vgic-v3.txt => arm-vgic-v3.rst} (77%)
>  rename Documentation/virt/kvm/devices/{arm-vgic.txt => arm-vgic.rst} (66%)
>  create mode 100644 Documentation/virt/kvm/devices/index.rst
>  rename Documentation/virt/kvm/devices/{mpic.txt => mpic.rst} (91%)
>  rename Documentation/virt/kvm/devices/{s390_flic.txt => s390_flic.rst} (87%)
>  create mode 100644 Documentation/virt/kvm/devices/vcpu.rst
>  delete mode 100644 Documentation/virt/kvm/devices/vcpu.txt
>  rename Documentation/virt/kvm/devices/{vfio.txt => vfio.rst} (72%)
>  rename Documentation/virt/kvm/devices/{vm.txt => vm.rst} (61%)
>  rename Documentation/virt/kvm/devices/{xics.txt => xics.rst} (84%)
>  rename Documentation/virt/kvm/devices/{xive.txt => xive.rst} (62%)
>  rename Documentation/virt/kvm/{halt-polling.txt => halt-polling.rst} (64%)
>  rename Documentation/virt/kvm/{hypercalls.txt => hypercalls.rst} (55%)
>  create mode 100644 Documentation/virt/kvm/locking.rst
>  delete mode 100644 Documentation/virt/kvm/locking.txt
>  rename Documentation/virt/kvm/{mmu.txt => mmu.rst} (94%)
>  rename Documentation/virt/kvm/{msr.txt => msr.rst} (74%)
>  rename Documentation/virt/kvm/{nested-vmx.txt => nested-vmx.rst} (90%)
>  rename Documentation/virt/kvm/{ppc-pv.txt => ppc-pv.rst} (91%)
>  rename Documentation/virt/kvm/{review-checklist.txt => review-checklist.rst} (95%)
>  rename Documentation/virt/kvm/{s390-diag.txt => s390-diag.rst} (90%)
>  rename Documentation/virt/kvm/{timekeeping.txt => timekeeping.rst} (85%)
>  rename Documentation/virt/uml/{UserModeLinux-HOWTO.txt => user_mode_linux.rst} (74%)
> 

Queued, thanks very much for this.

Paolo

