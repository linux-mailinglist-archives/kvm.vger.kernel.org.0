Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B870204647
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 02:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732470AbgFWAxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 20:53:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44986 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732461AbgFWAxF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 20:53:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592873583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qp7Q2GIXEixRBimL7E9VvblHlm9CvwZes19fF7Y/7hI=;
        b=ZvA8Z/nRhRUQID1oEGpXmEllUe5w753/EAc1HLdUbtfjdE1BPwG5bjAx6nW/iN1WUtCA/d
        N73Pcucr8SdDAlSckgbRSmuN+DybrwVTD0mPrV86Nvlaw6ZgBhANgA/CO0XIE1wRlotJUy
        jQKyCFiRnvmd5C3ipB4sF/I2y654XHI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-nbIem8cxNru_m88XzOqqlQ-1; Mon, 22 Jun 2020 20:53:02 -0400
X-MC-Unique: nbIem8cxNru_m88XzOqqlQ-1
Received: by mail-wr1-f71.google.com with SMTP id w4so12819857wrl.13
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 17:53:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qp7Q2GIXEixRBimL7E9VvblHlm9CvwZes19fF7Y/7hI=;
        b=Davqxz9I6bB2uBbs14BBIceL8fAUUTSQw1ll/XcFGEOaXd+tM9ZNMB70gHjGDkjeOr
         yD0+Ty+aD8LDy0cnf6qBoE5bZxZOO0+PNnlFSEVOPacYnHqxlYw7d78xH7VBLPmasf39
         NEC12e5FLgDW6zFXF+SH+0Rwmt7jNtk2ct2HznB/vDO3NhioJ0CmNK7Rry1U0PsX8bsb
         Q1/S6xC1bmMEAyC5UnzB8tgtQab0eJhwEnI8xZE9Ug/RzLGa8BBlFgPm4USi070gnZAO
         /oWzKyRjd2H3d5iCPJdQhSMqiSyHJs6IPkDhd9A3W6MxKjeJlZMXOOnDYF4NDlCRY9IE
         KAHg==
X-Gm-Message-State: AOAM531NhRCaXBxbP2pu5H4wdnkEANgPFQ+9JHzRDhJPKP0vKmgY0ssp
        jRSApaGZ7/y4YCgJwFH46EM9y+u/wqkoBu/ZTv3vX1jSU5AnjexdIBZWdTv2FiJ8Sq5CCjARUHH
        Devc8RVW+L+xw
X-Received: by 2002:a05:6000:10c4:: with SMTP id b4mr9573848wrx.50.1592873580743;
        Mon, 22 Jun 2020 17:53:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRM65nu3IaIw80ctmoGJZHcWszViI51kO24uJTmpp6hT6KbuSkgwjXSwFmD4MizZA8Cg4FPg==
X-Received: by 2002:a05:6000:10c4:: with SMTP id b4mr9573825wrx.50.1592873580515;
        Mon, 22 Jun 2020 17:53:00 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id d13sm6038408wrn.61.2020.06.22.17.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 17:52:59 -0700 (PDT)
Subject: Re: [PATCH v2 00/11] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Andy Lutomirski <luto@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, babu.moger@amd.com
References: <20200619153925.79106-1-mgamal@redhat.com>
 <5a52fd65-e1b2-ca87-e923-1d5ac167cfb9@amd.com>
 <52295811-f78a-46c5-ff9e-23709ba95a3d@redhat.com>
 <2bcdb1cb-c0c5-5447-eed5-6fb094ae7f19@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f019cc1f-daa8-869b-6c06-0e2586cdf0a8@redhat.com>
Date:   Tue, 23 Jun 2020 02:52:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <2bcdb1cb-c0c5-5447-eed5-6fb094ae7f19@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/20 01:47, Andy Lutomirski wrote:
> I believe that Xen does this.  Linux does not.)  For a guest to
> actually be functional in this case, the guest needs to make sure
> that it is not setting bits that are not, in fact, reserved on the
> CPU.  This means the guest needs to check MAXPHYADDR and do something
> different on different CPUs.
> 
> Do such guests exist?

I don't know; at least KVM does it too when EPT is disabled, though.  It
tries to minimize the effect of this issue by preferring bit 51, but
this does not help if the host MAXPHYADDR is 52.

> As far as I know, Xen is busted on systems
> with unusually large MAXPHYADDR regardless of any virtualization
> issues, so, at best, this series would make Xen, running as a KVM
> guest, work better on new hardware than it does running bare metal on
> that hardware.  This seems like an insufficient justification for a
> performance-eating series like this.
> 
> And, unless I've misunderstood, this will eat performance quite
> badly. Linux guests [0] (and probably many other guests), in quite a
> few workloads, is fairly sensitive to the performance of ordinary 
> write-protect or not-present faults.  Promoting these to VM exits 
> because you want to check for bits above the guest's MAXPHYADDR is
> going to hurt.

The series needs benchmarking indeed, however note that the vmexits do
not occur for not-present faults.  QEMU sets a fixed MAXPHYADDR of 40
but that is generally a bad idea and several distros change that to just
use host MAXPHYADDR instead (which would disable the new code).

> (Also, I'm confused.  Wouldn't faults like this be EPT/NPT
> violations, not page faults?)

Only if the pages are actually accessible.  Otherwise, W/U/F faults
would prevail over the RSVD fault.  Tom is saying that there's no
architectural promise that RSVD faults prevail, either, so that would
remove the need to trap #PF.

Paolo

> --Andy
> 
> 
> [0] From rather out-of-date memory, Linux doesn't make as much use
> as one might expect of the A bit.  Instead it uses minor faults.
> Ouch.

