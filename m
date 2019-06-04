Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5B7C34CB2
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 17:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbfFDP4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 11:56:50 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:32905 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbfFDP4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 11:56:49 -0400
Received: by mail-ed1-f67.google.com with SMTP id y17so1183044edr.0
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 08:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TzHc9NWWKRgZbxCuCESuOAVy6V5aZPy4lPNt/yymc90=;
        b=sd9yR5ermmISTJa8qycY9JqtqdzXZe7wb4kFIdqHQtc+MxalnsidgCTphkzIMQyWJ/
         zKu8gVFayK54GS8JR4aQjeG52V1VTes9JZbEC/tHjwYE9gBsWVeKYGvtKZnzpES6GFih
         gpHa10GhBbAFOjaIa9ZYiEW5WEHkG7nat4M1a13fqS758WSTOPuTnSWHPpSLh/rBKmuJ
         vSfWoCHLpQTQA+TRQM/VlMF+t6hYxnfT9flxonlslP3mZlarerDm/p6kK2/YknOpGtYj
         8wOaqdcTHpz8NmMs1UT7YW0vMFdEZqQmCQULrLKlsCOzxL7SzQG6o1u1YxN8i2DsY+fP
         R/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TzHc9NWWKRgZbxCuCESuOAVy6V5aZPy4lPNt/yymc90=;
        b=jD24Rm6vSXd9ZtMjDn62zilCoH/d9X+ECK8ovsdWKLiYloy8mXWJJarrradTl7FdBc
         OicUHRylj+/XxoSymejdOVYYhkLxXyl3hFyo7ML5wHaPz799XLdXuM47i56Yk0LRxDhw
         X3+4Oca0AfcB308n3Ou8bjyjEnG+ORChsJQJFEWtEUukgHjbr9sk4p15Sj3c8gugNCES
         rvkt91DnDoNLJ3xatOVGz2+QNMxg4yXNHl+KGKp9Jsefg+GClP5rAkoQnt8nW60TgBQD
         52HtUX0Z/cH+TTLTktEn+9wV8FQJynIKyXhW8m92nEWE1t5laOSjGQ/KXhxqysqQfDAX
         z0ag==
X-Gm-Message-State: APjAAAXr9jxUYhpRvM7MMEUMhq9DlgUm8dIj3ZWiZ3C0C8KMhCcGL2Uw
        27IUKtlhfSwqxDcX4xjTiJ+4azMqT/ZSmXB456i+vg==
X-Google-Smtp-Source: APXvYqy1u46ubz0u45ue4qkdyYoU6cHzImoFzlcN2RkZi9UssmAtBLX+xmNlW6sctB99uOkmThPjz1ekEyf8hgSWqgo=
X-Received: by 2002:aa7:c391:: with SMTP id k17mr37200588edq.166.1559663807555;
 Tue, 04 Jun 2019 08:56:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com>
 <5CEC9667.30100@intel.com> <CAOyeoRWhfyuuYdguE6Wrzd7GOdow9qRE4MZ4OKkMc5cdhDT53g@mail.gmail.com>
 <5CEE3AC4.3020904@intel.com> <CAOyeoRW85jV=TW_xwSj0ZYwPj_L+G9wu+QPGEF3nBmPbWGX4_g@mail.gmail.com>
 <5CF07D37.9090805@intel.com> <CAOyeoRXWQaVYZSVL_LTTdAwJOEr+eCzhp1=_JcOX3i6_CJiD_g@mail.gmail.com>
 <5CF2599B.3030001@intel.com> <CAOyeoRWuHyhoy6NB=O+ekQMhBFngozKoanWzArxgBk4DH2hdtg@mail.gmail.com>
 <5CF5F6AE.90706@intel.com>
In-Reply-To: <5CF5F6AE.90706@intel.com>
From:   Eric Hankland <ehankland@google.com>
Date:   Tue, 4 Jun 2019 08:56:36 -0700
Message-ID: <CAOyeoRW5wx0F=9B24h29KkhUrbaORXVSoJufb4d-XzKiAsz+NQ@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: x86: PMU Whitelist
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 3, 2019 at 9:37 PM Wei Wang <wei.w.wang@intel.com> wrote:

> So, I'm not sure if "quantifying LLC contention" has been proved to
> be a real issue. If this is considered to be an issue:
>
> - without PMU, we could also write a piece of software to run in the
> guest to quantify that contention (e.g. by analyzing the memory access
> latency). How do you prevent this?
>
> - the same thing could also happen with the L1 cache (e.g. a vCPU
> and a host thread run 2 logical CPUs on the same core). If this is disabled
> as well, we may have very few events usable, and would like to see what you
> have on the whitelist.

Right - I'm aware there are other ways of detecting this - it's still
a class of events that some people don't want to surface. I'll ask if
there are any better examples.

Eric
