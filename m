Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E75F817A971
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 16:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgCEP6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 10:58:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42536 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726143AbgCEP6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 10:58:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583423921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vcmbPSG7Ns1BCQM6qMZvbDUeuBY81aAMlv0waXN9f5o=;
        b=QXHE/aAa/ocnx3gnp1cZ/QdrBBTFj7ZvMI+QO1tVyyXVHvHjUtlO/+8bl7XM1XV5/N7UEG
        CtZ+6VOuj4DkgrYbL2X4SMS8IuexuwFxtmW5WRkyg1WlR4V3fwYy1dajIjBwDREVOgdb0F
        Pom853zxG7iSyKqqK7c4VSB7eigMBcY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-ryyYB814Ni2QZGHcmj3D-g-1; Thu, 05 Mar 2020 10:58:37 -0500
X-MC-Unique: ryyYB814Ni2QZGHcmj3D-g-1
Received: by mail-wr1-f69.google.com with SMTP id 72so2478820wrc.6
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 07:58:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vcmbPSG7Ns1BCQM6qMZvbDUeuBY81aAMlv0waXN9f5o=;
        b=h3FDpgbk6SLd1hqRwcAGZ97ExeAXL+arn/KkjTWefKFH79WWbAnxnmHk1bxICaZjGr
         XbtTcJWgRYKA5F4JuqwzbwQnitUj/Zu2zHGXka0nihHM5RGrTfCjd7VmVOi3VuqfASlP
         K97SDcq8/OLnqVG6miUt96BvyKPNC7i948B/hCySVpegGho11CcE8mrdtlRHqZfY0OKA
         4gna04ZgJgMtli8bJhcaqzBGqJT7dNXRFHE+JG2HVVfL3eRs4vY28u3ydRtDrRCalRBo
         xoTHkNN1VQgNFk2V21rYOBSQWZEXo8r9Y2bEiOFxh/buPymJDNaCPkvvKyeiMt1pLOyw
         /Ksw==
X-Gm-Message-State: ANhLgQ2jRvZez0iSyC82TveQ6zOgccduoDZFnDKaM1prOkRyny2TaIQ7
        o91AzfYPV9O940POT3Fwf4WbF9bSOEKdUju2BEdW+UDhBqMInotmv6LFxc6WHDxhOh252V+fo0p
        mmqD/T9/nkkar
X-Received: by 2002:a5d:630a:: with SMTP id i10mr10613135wru.273.1583423916360;
        Thu, 05 Mar 2020 07:58:36 -0800 (PST)
X-Google-Smtp-Source: ADFU+vs2tnnfpQubkBdyyW38Ps48EoLmLBMqtqEn0LHkSSBuz/+LpaZRPiwmvos+UYZioFDdZJfdLg==
X-Received: by 2002:a5d:630a:: with SMTP id i10mr10613126wru.273.1583423916167;
        Thu, 05 Mar 2020 07:58:36 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id d203sm9339731wmd.37.2020.03.05.07.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 07:58:35 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86: VMX: rename 'kvm_area' to 'vmxon_region'
In-Reply-To: <20200305153623.GA11500@linux.intel.com>
References: <20200305100123.1013667-1-vkuznets@redhat.com> <20200305100123.1013667-2-vkuznets@redhat.com> <20200305153623.GA11500@linux.intel.com>
Date:   Thu, 05 Mar 2020 16:58:35 +0100
Message-ID: <875zfig5ec.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Super nit: can I convince you to use "KVM: VMX:" instead of "KVM: x86: VMX:"?
>
>   $ glo | grep -e "KVM: x86: nVMX" -e "KVM: x86: VMX:" | wc -l
>   8
>   $ glo | grep -e "KVM: nVMX" -e "KVM: VMX:" | wc -l
>   1032
>
> I'm very conditioned to scan for "KVM: *VMX:", e.g. I was about to complain
> that this used the wrong scope :-)   And in the event that Intel adds a new
> technology I'd like to be able to use "KVM: Intel:" and "KVM: ***X:"
> instead of "KVM: x86: Intel:" and "KVM: x86: Intel: ***X:" for code that is
> common to Intel versus specific to a technology.

What if someone else adds VMX instead? :-)

Point taken, will use 'KVM: VMX:' in the future (and I'm in no way
object to changing this in the queue if it's not too late).

-- 
Vitaly

