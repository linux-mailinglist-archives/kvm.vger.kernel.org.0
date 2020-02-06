Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5C71547AC
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 16:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgBFPSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 10:18:43 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22232 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727872AbgBFPSm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 10:18:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581002321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bmV5fzydc3rcIazejW+HPUQs71G2JgpFlEg2HuiWNZ4=;
        b=EsANk3ENHMDxF938RHvSmQt17OH96TAIcZOZsozE504ccJ57DKQk5XXDdWJTG0+QKHghKB
        RR7Ze//dr5bbpGK1KKBUWAXtimbuVRxFGJE0PkYz73pQEXuRnjX29cKaY2lWDxgwS7Z70Q
        N78npyuSCNGUxUr2rYbA+vJYYg8mPYo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-tUfPYpaxNqehuuHEfvei0Q-1; Thu, 06 Feb 2020 10:18:39 -0500
X-MC-Unique: tUfPYpaxNqehuuHEfvei0Q-1
Received: by mail-wr1-f71.google.com with SMTP id a12so3564602wrn.19
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 07:18:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bmV5fzydc3rcIazejW+HPUQs71G2JgpFlEg2HuiWNZ4=;
        b=XzE9p+5n8IhUxN0pLSqHXdOLdsLmy4cBiJr/OSg0eBLjrOFxOEm3z8G6VSCkz9rwNI
         y3s2S5sa4pCpcwgvsBUyAGtHt5Rjqa831tx/N5WVPwr4T7Lr2ojFZWOGIE/P/vsOTAMK
         CY4IGpiHrrcN2c4TxN5ZqSXnMBk4pq6qOeDP+WLdDbtJAg+KzDm5X0saLLtPsJGUwbjs
         meplM70pX4/C+UMtgiIK8SNbpj79VmkUpRGefwMdC+mmCcwbCOghyrIrRAettgTGC9cJ
         riPiF1GAlLYS0BkpW6DEaGz84O4mt79+qSusxVqZp7vzs9YLvgKY9i4lJt+prfrenHAy
         LcLg==
X-Gm-Message-State: APjAAAW1C31QPVqazD3T+Wdl2wlh1hwjatu+GeK0mGAGS0khxyl3iVbO
        CsGjwZoRD5rtsu4vXXVieU7COjSS7mFxTjkHilnqU4OTZFW43Kt9Nprz44krNwqvhK0TcPzwTBI
        dQ0pmaP6/b4VO
X-Received: by 2002:a7b:ca49:: with SMTP id m9mr5329730wml.50.1581002318397;
        Thu, 06 Feb 2020 07:18:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqzAJWYqhylWktnILpnrmT9YkEhB6Yu5lRTU8758ARVrJbf++M5496LmTA7BV6VbGzIBWVT6Uw==
X-Received: by 2002:a7b:ca49:: with SMTP id m9mr5329708wml.50.1581002318087;
        Thu, 06 Feb 2020 07:18:38 -0800 (PST)
Received: from [10.201.49.5] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id p15sm3918709wma.40.2020.02.06.07.18.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 07:18:37 -0800 (PST)
Subject: Re: [PATCH v2 00/27] docs: virt: manually convert text documents to
 ReST format
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Jeff Dike <jdike@addtoit.com>, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-um@lists.infradead.org
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f8dab5f5-3b54-0b0a-0b34-c1c450813af5@redhat.com>
Date:   Thu, 6 Feb 2020 16:18:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <cover.1581000481.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/02/20 15:49, Mauro Carvalho Chehab wrote:
> Manually convert the documentation under Documentation/virt to ReST,
> minimizing the usage of uneeded markups and preserving the documentation
> writer's style.
> 
> PS.: Patches are against linux-next tree (20200204).
> 
> v2:
> 
> - Solved a conflict with linux-next;
> - Added SPDX headers.
> 
> Mauro Carvalho Chehab (27):
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
>   docs: kvm: convert devices/vcpu.txt to ReST
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
> 
>  Documentation/virt/index.rst                  |    1 +
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
>  .../virt/kvm/{locking.txt => locking.rst}     |  111 +-
>  Documentation/virt/kvm/{mmu.txt => mmu.rst}   |   62 +-
>  Documentation/virt/kvm/{msr.txt => msr.rst}   |  147 +-
>  .../kvm/{nested-vmx.txt => nested-vmx.rst}    |   37 +-
>  .../virt/kvm/{ppc-pv.txt => ppc-pv.rst}       |   26 +-
>  ...iew-checklist.txt => review-checklist.rst} |    3 +
>  .../virt/kvm/{s390-diag.txt => s390-diag.rst} |   13 +-
>  .../kvm/{timekeeping.txt => timekeeping.rst}  |  221 +-
>  ...odeLinux-HOWTO.txt => user_mode_linux.rst} | 1814 ++++-----
>  29 files changed, 4003 insertions(+), 3121 deletions(-)
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
>  rename Documentation/virt/kvm/{locking.txt => locking.rst} (78%)
>  rename Documentation/virt/kvm/{mmu.txt => mmu.rst} (94%)
>  rename Documentation/virt/kvm/{msr.txt => msr.rst} (74%)
>  rename Documentation/virt/kvm/{nested-vmx.txt => nested-vmx.rst} (90%)
>  rename Documentation/virt/kvm/{ppc-pv.txt => ppc-pv.rst} (91%)
>  rename Documentation/virt/kvm/{review-checklist.txt => review-checklist.rst} (95%)
>  rename Documentation/virt/kvm/{s390-diag.txt => s390-diag.rst} (90%)
>  rename Documentation/virt/kvm/{timekeeping.txt => timekeeping.rst} (85%)
>  rename Documentation/virt/uml/{UserModeLinux-HOWTO.txt => user_mode_linux.rst} (74%)
> 

Wow, thanks very much for doing this.  It would be great if we could get
this to Linus not long after the merge window; I'll do my best to review
it quickly.

Paolo

