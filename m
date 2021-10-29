Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E1E44039C
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 21:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhJ2T4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 15:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhJ2T4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Oct 2021 15:56:09 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FB9C061570
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 12:53:41 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id y128so14889909oie.8
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 12:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZhM78aiaILM0cfsGJXtOEDyYJ2tfZrE1rD5L+GzYhGg=;
        b=gu4hf5wXYxWE7aYkMZiJEoht4AaRE/GstilnhHOx8cebcFGfAaVbSIRdFSsstvE/LW
         2MzFkNZ+f0cTS9VBxOIJC9cWBYQLjmK3XAbP9pwKCDVqLH2hLGl4OOaRH4t2pJjpBcfC
         ocr8OYyq+dFVrkIWcRWBqxihxndbN7jOWfP5cZaMRVYBJQHbLBr4VeaMdVVTVodMtOmo
         5QlqfW/y6ia8r9i0fFUlMCGd+LKiPW85UvUA3id9chGyTdsFtBxUwoEWd5L4uphor4GJ
         RqJLDDzuvlSWtHKu3kFIFNSXmPtCX7ItAx7rHoxU3tqwylfZVgqF5YuKLLH2qN1zjd/a
         Khqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZhM78aiaILM0cfsGJXtOEDyYJ2tfZrE1rD5L+GzYhGg=;
        b=d9mnPZEgCdkdyyc4/zr4uT/58KScJ/0RiGxF0/Js7pPjFGCy1F3q5wZaSPaqhzrXJX
         8Q4YrQz2FOMIrXc/lv5+njs+T1hWYxdcBqnLPsKPz7pYJhQE3sTumQDoIUh71JxUAJu5
         4jyKkiMyxf5Bhp1mBYPtNb1EcQzf5PHPDZaYawEYiTnTcV+DyVVQVfHOrRsvS0WwwTBw
         SUEXQ6kmi9UAwrB2eSaoCivSedd09Shl4cuD13Ojl+ZA8jfdUXV23g+6hPbxLQySSZIN
         6HQOoJ8i6Is0/JW+N77FEVfvLcju9cL4w2/L57ueJOQOR1SEpsoUjsC0ZJl+n/HJyELA
         BwPg==
X-Gm-Message-State: AOAM533a3+N5YOYHcn43oeVr3MNAeIEMnNd9bmQpMvrzZCkd4fMmQ9sp
        ficUVeQTIXI8Nopey5oKOF9KvWPtk8gEffhj/4S/bQ==
X-Google-Smtp-Source: ABdhPJwTfBjUCev1nQqoqBKthSu0pkbcqfNmARR52LO2Y9EvKzROxQuFSuwpvao8JFGyrB5Hev7+gR3/wegvT8jx3Nw=
X-Received: by 2002:a05:6808:f8f:: with SMTP id o15mr14904087oiw.38.1635537220212;
 Fri, 29 Oct 2021 12:53:40 -0700 (PDT)
MIME-Version: 1.0
References: <0b94844844521fc0446e3df0aa02d4df183f8107.camel@linux.intel.com>
 <YTI7K9RozNIWXTyg@google.com> <64aad01b6bffd70fa3170cf262fe5d7c66f6b2d4.camel@linux.intel.com>
 <YVx6Oesi7X3jfnaM@google.com> <CALMp9eRyhAygfh1piNEDE+WGVzK1cTWJJR1aC_zqn=c2fy+c-A@mail.gmail.com>
 <YVySdKOWTXqU4y3R@google.com> <CALMp9eQvRYpZg+G7vMcaCq0HYPDfZVpPtDRO9bRa0w2fyyU9Og@mail.gmail.com>
 <YVy6gj2+XsghsP3j@google.com> <CALMp9eT+uAvPv7LhJKrJGDN31-aVy6DYBrP+PUDiTk0zWuCX4g@mail.gmail.com>
 <YVzeJ59/yCpqgTX2@google.com> <20211008082302.txckaasmsystigeu@linux.intel.com>
 <85da4484902e5a4b1be645669c95dba7934d98b5.camel@linux.intel.com>
 <CALMp9eTSkK2+-W8AVRdYv3MEsMKj-Xc2-v7DsavJRh5FLsVuCQ@mail.gmail.com> <3360abf3841a5d3234ac5983dd2df62b24e5fc47.camel@linux.intel.com>
In-Reply-To: <3360abf3841a5d3234ac5983dd2df62b24e5fc47.camel@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 29 Oct 2021 12:53:29 -0700
Message-ID: <CALMp9eQruRB3WEuwe2PEyEmbYUcJC_vR86Dd_wPTuqjb212h+w@mail.gmail.com>
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write respects
 field existence bitmap
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 8, 2021 at 5:05 PM Robert Hoo <robert.hu@linux.intel.com> wrote:
>
> On Fri, 2021-10-08 at 16:49 -0700, Jim Mattson wrote:
> > We have some internal patches for virtualizing VMCS shadowing which
> > may break if there is a guest VMCS field with index greater than
> > VMX_VMCS_ENUM.MAX_INDEX. I plan to upstream them soon.
>
> OK, thanks for letting us know.:-)

After careful consideration, we're actually going to drop these
patches rather than sending them upstream.
