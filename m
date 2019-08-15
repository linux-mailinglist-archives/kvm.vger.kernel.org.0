Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECD698F083
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 18:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731698AbfHOQZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 12:25:55 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39346 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731471AbfHOQZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 12:25:53 -0400
Received: by mail-io1-f65.google.com with SMTP id l7so293806ioj.6
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2019 09:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6grQ9ocx+IbTwjVEIDedYoYdf4O0M4fR1quq8TS70BA=;
        b=FG8b5drlg1DYNIfZgQ6q7wA0xgFXi0ISvlwrU2ezrkleGRnPhC6qzdm3SG0FXSCCVr
         4/+1jBiqIA/aBL/u4qxHoe5NMGu0WLlajJzgMMexeGB9cwiSUIbxX3AD8h9wn7HWJqyy
         nPWcuORgsACRu+FkFGvFc+Xq0N50z0kcVMdR0HIF/1ABEe2wupgfPrjwsy/1OddU/DCf
         zGf0IW7nYz9h5AupmY/Kmz5IVJRNmQI5/hil5Rxq0MDbDjzwUixSUDBB8SC6tVLnFnoy
         WKvTJnuBlqoZmkhsbbW6jTzaG8lq2oyNSIlWVAJ1F3s12sbmXRTLWmpeY4SfwWJfvhtR
         4/+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6grQ9ocx+IbTwjVEIDedYoYdf4O0M4fR1quq8TS70BA=;
        b=LazgdvmN2F1Dwpgr9WJOmdkjJaz81LLjNkOiI3Bii468nrGiJ6Bt+rRDdnn/WcN0qI
         sQoejP/EkCtcB/LcPCiHtJHVHgBAisv5rI69aRbnnOfXj4AUYAEWYBT78VR69Ys3idM1
         Jmky9doCSLSDP4W/mMEyIigz5LeIUEnPnJo9qd5edLBINHnUIBKpL5JTK2KySTEXP98c
         6rJumVVOp0w7Ci0a25fEgrN2dD9++ny2K16gFCaXl69Dv0n6YRsGHRCMquqgUabkq3ku
         3uqBuIVDwJS/g6YybJ2ZG0zPnI1jTI6jZ0WgiaPsiN9ns3laVIHN/OP81lS/WJmpTLN8
         7YPA==
X-Gm-Message-State: APjAAAXMDF/aiuG1pH3vSqVukRg3iJQy5Rp5+hq199XQoOaS/iXBGSOT
        BuGSbYdru6g8kXF9nOnLP8xg2xLXaWhy+zK5fyrcKw==
X-Google-Smtp-Source: APXvYqyf9+Wim/8xYX70CueSMMJFpdBB0isWORRNM9dKAVYwLKlJdkjTd7rPjPhyK/rPq/lhMRobLGD79cfX57Cw+hI=
X-Received: by 2002:a05:6638:52:: with SMTP id a18mr5943400jap.75.1565886352617;
 Thu, 15 Aug 2019 09:25:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <20190814070403.6588-6-weijiang.yang@intel.com> <87a7cbapdw.fsf@vitty.brq.redhat.com>
 <20190815134329.GA11449@local-michael-cet-test>
In-Reply-To: <20190815134329.GA11449@local-michael-cet-test>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 15 Aug 2019 09:25:41 -0700
Message-ID: <CALMp9eTGXDDfVspFwFyEhagg9sdnqZqzSQhDksT0bkKzVNGSqw@mail.gmail.com>
Subject: Re: [PATCH RESEND v4 5/9] KVM: VMX: Add init/set/get functions for SPP
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        yu.c.zhang@intel.com, alazar@bitdefender.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 15, 2019 at 6:41 AM Yang Weijiang <weijiang.yang@intel.com> wrote:

> Hi, Vitaly,
> After looked into the issue and others, I feel to make SPP co-existing
> with nested VM is not good, the major reason is, L1 pages protected by
> SPP are transparent to L1 VM, if it launches L2 VM, probably the
> pages would be allocated to L2 VM, and that will bother to L1 and L2.
> Given the feature is new and I don't see nested VM can benefit
> from it right now, I would like to make SPP and nested feature mutually
> exclusive, i.e., detecting if the other part is active before activate one
> feature,what do you think of it?
> thanks!

How do you propose making the features mutually exclusive?
