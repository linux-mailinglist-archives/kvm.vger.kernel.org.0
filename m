Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C7D29488D
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 09:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395399AbgJUHDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 03:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395395AbgJUHDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 03:03:47 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96ED8C0613CE
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 00:03:47 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id i12so960587ota.5
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 00:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bsnMznwHAel9cPHXN6MLfjRKzcgETlU7H126aNn2UJk=;
        b=cTCzYa7egpfmhgljgZxOtp9MDjOpOtA4qd484ik9jWZqfqknhNUvaJY58j7Ob1x8u1
         0JujoROD0Raciees6IIi/FUkd1XTPrh9T9Q7Q/K0iOo5c1AQgZnFUbeLUVlOuz9v4Aae
         UPzNc/JD4hoWHRgLASIiRjwQXD9zEQqDN/PfhvbxjmmpnZCZFoIG4k8KN1dPZAE4oqvE
         Mk0HtXPEh/iClSgTvqGDLpr0JVn8brHmnqDRwcJsTI71Mj8va1XkkNv5n/4g+ABDb8jo
         tYaHxhvT5eFwHmEOIUnuU1MfoQNDs19Y1HwaC5eBaQrz7z8ERAJNgN2iUZECRm3Z4H0h
         ol1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bsnMznwHAel9cPHXN6MLfjRKzcgETlU7H126aNn2UJk=;
        b=A35KXZUUrTL0LFZUerHfa/NYStfU1B64cPNNKkTJLenx7FzVsHcim4bhRhVWG+vwbN
         wQHJaX4QitQU8pJmrKXOMr4/LN3BK70EC3AaYVLzlxFn8OfcGHWGSOYwXMvLV/eKhNsK
         AyiW7G3Utj8u5seWXrMHucKZlFH/lbS6cC+TaHBQML4rTnWF8khbI5j+yavJ5jaljT94
         v7TPAx5+sFmoAbYc2MnX5gmBj2ns4c66iXhbqYhKNo+g5FfJJNx6JgCWMsN4cdn+OSp1
         cO1+8VTNSNEWxJG6j6omU8t/oB9foL2PTbof7BcPngDgomI6DUSaRql5py1ohx4MR5+6
         wIDQ==
X-Gm-Message-State: AOAM532ngV8fsibgSG6ICxeI2KHkIaWtmlRrbA29y33gshxUPJL7Z52m
        XEO8BEiq+MC7wjmXkHB7tPj8eENYy7xcpCoF1wI=
X-Google-Smtp-Source: ABdhPJzswy1NM6PHPiUEQWiT2cx3V6wiITm2/hyu932mdsLW6kNs4FvTHztVJ4R5Up82KxGTRNMBK068xxjx2Li4Z6c=
X-Received: by 2002:a05:6830:2436:: with SMTP id k22mr1582722ots.185.1603263826466;
 Wed, 21 Oct 2020 00:03:46 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eRYN7acRAOhoVWjz+WuYpB6g40NYNo9zXYe4yXVqTFQzQ@mail.gmail.com>
In-Reply-To: <CALMp9eRYN7acRAOhoVWjz+WuYpB6g40NYNo9zXYe4yXVqTFQzQ@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 21 Oct 2020 15:03:35 +0800
Message-ID: <CANRm+Cy4Ho7KF0Ay99mY+VuZPo8dkkh7kKRqjgY_QzPcVy5MCw@mail.gmail.com>
Subject: Re: CPUID.40000001H:EDX.KVM_HINTS_REALTIME[bit 0]
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 21 Oct 2020 at 14:47, Jim Mattson <jmattson@google.com> wrote:
>
> Per the KVM_GET_SUPPORTED_CPUID ioctl, the KVM_HINTS_REALTIME CPUID
> bit is never supported.
>
> Is this just an oversight?

It is a performance hint, not a PV feature and doesn't depend on KVM.

    Wanpeng
