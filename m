Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABDFA277C
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 21:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbfH2T6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 15:58:47 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39860 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfH2T6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 15:58:46 -0400
Received: by mail-pl1-f194.google.com with SMTP id az1so1110929plb.6
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 12:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+5Kg84p1fqKumOdUNo22sb2fQbwCkGTAtRgR04S7LGI=;
        b=k6lF2z0kb5fYo5LLwgkq2TiwOSfqasJsGn9m6Rz3w9yQb//Z1hRacNsykepEJs9ICp
         pLeXLTyqWtujz/ry1eyYnwnyc07tIgNkcQqyPSfaY2agGJx9/kCV00RXNx/7tY8bljch
         7njR45oIInvNf/sVcCmqyAGxbE5Nbxtfs6ef5U7v1CypRVu9Zam5Qa11Rd/S8F+XXo3o
         bFJdPy+3Xg/sM5jlfEGPxBUAl4o9arf032HWIbqpU34DoDnmKzrO/WtOa+lYRylEzujx
         9M9qBpxuffuP7VDD95TbyqVArm3Re+558zC4znaYgkBanOywdPvC0avmIyDNFalYJVdF
         UPcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+5Kg84p1fqKumOdUNo22sb2fQbwCkGTAtRgR04S7LGI=;
        b=AHY3j9Sa0lOAehZRfbbWUott1P45nLB0KFqv7nYC8LaLcZEV8Tw3eNtQ/Jkj+6WEuR
         Vc8BOjlveiL3tiEYftDRqpg/k4fRgIpJ/aZuW1Qa77YyiDGn1YfnUhcnHSy6PkLZCkgp
         jxIC7VvV5EXZ1KEE83H0M/7FRYJr2GwdW7wfQ7Vgm1N8xCOqR5YF3kmQ2xPoNnO7gUAE
         pxEYzW3yhcEzAVGoj75WHrlHjtpwksGrMXsNCt8Eo4PMA2VP9ClBtcDLi2FvCBGzdhS1
         0udBzi/qIPMnhewwMojrGMQpSz6SCf5e3wABb+0LKlHHFf1dfcsazh2Ul3OAxCg7HKc7
         ASXQ==
X-Gm-Message-State: APjAAAXfnMq2tmD3gvQD3s+y7xIBnEVrcQMUyYQ4Z1zcSi1Kof1ZFjka
        1dDsXgh2KXZ6AqRIYvMh7BHFFQ==
X-Google-Smtp-Source: APXvYqyXPG3sM8kedXhZpNEU9tNIBXcvca2TX8u8wOqkMeXtxwZzNVNGxlf5ENkpsI7vcRmWCqYHpw==
X-Received: by 2002:a17:902:a606:: with SMTP id u6mr11713562plq.224.1567108725633;
        Thu, 29 Aug 2019 12:58:45 -0700 (PDT)
Received: from google.com ([2620:0:1009:11:73e5:72bd:51c7:44f6])
        by smtp.gmail.com with ESMTPSA id a15sm3899394pfg.102.2019.08.29.12.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 12:58:44 -0700 (PDT)
Date:   Thu, 29 Aug 2019 12:58:41 -0700
From:   Oliver Upton <oupton@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [kvm-unit-tests PATCH 7/7] x86: VMX: Add tests for nested "load
 IA32_PERF_GLOBAL_CTRL"
Message-ID: <20190829195841.GA188698@google.com>
References: <20190828234134.132704-1-oupton@google.com>
 <20190828234134.132704-8-oupton@google.com>
 <CALMp9eTsd2YQxqDu9cXfJiMr1DK41oJbnBW3zRAw10k+uNuGmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTsd2YQxqDu9cXfJiMr1DK41oJbnBW3zRAw10k+uNuGmA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 10:33:48AM -0700, Jim Mattson wrote:
> On Wed, Aug 28, 2019 at 4:41 PM Oliver Upton <oupton@google.com> wrote:
> >
> > Tests to verify that KVM performs the correct checks on Host/Guest state
> > at VM-entry, as described in SDM 26.3.1.1 "Checks on Guest Control
> > Registers, Debug Registers, and MSRs" and SDM 26.2.2 "Checks on Host
> > Control Registers and MSRs".
> >
> > Test that KVM does the following:
> >
> >     If the "load IA32_PERF_GLOBAL_CTRL" VM-entry control is 1, the
> >     reserved bits of the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the
> >     GUEST_IA32_PERF_GLOBAL_CTRL VMCS field. Otherwise, the VM-entry
> >     should fail with an exit reason of "VM-entry failure due to invalid
> >     guest state" (33).
> >
> >     If the "load IA32_PERF_GLOBAL_CTRL" VM-exit control is 1, the
> >     reserved bits of the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the
> >     HOST_IA32_PERF_GLOBAL_CTRL VMCS field. Otherwise, the VM-entry
> >     should fail with a VM-instruction error of "VM entry with invalid
> >     host-state field(s)" (8).
> 
> Could you add a simple functionality test as well? That is, after a
> successful nested VM-entry, the L2 guest should be able to observe the
> GUEST_IA32_PERF_GLOBAL_CTRL value when it reads the
> IA32_PERF_GLOBAL_CTRL MSR, and after a subsequent nested VM-exit, the
> L1 guest should be able to observe the HOST_IA32_PERF_GLOBAL_CTRL
> value when it reads the IA32_PERF_GLOBAL_CTRL MSR.

Definitely should. I think I can just add it as an additional check to
the common test code for host and guest tests, since we already have the
guest brought up and configured correctly anyway.

I have a couple style nits to correct in this patch as well. I'll add
this to the v2 I'm going to send out for the series.
