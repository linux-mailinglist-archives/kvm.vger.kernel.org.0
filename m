Return-Path: <kvm+bounces-4953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF8281A2CE
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:37:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 468EDB25834
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84DBA405D3;
	Wed, 20 Dec 2023 15:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dmgcEirn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787543FB0B
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 15:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5d12853cb89so79052707b3.3
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 07:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703086626; x=1703691426; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=koGRJJdk0KHZeqrqMZXxqKWfVpvB14ZXeK4Zc4mq2WY=;
        b=dmgcEirnq3r3zljfzZHo9+WJzGLuCiw/JfKASBYz5Hjd5yDDnWWqQ3wJgdL3ZzzZL7
         3GEHl+QA/SFnNxcRV3B+/yfcVsgOYnunf4rRBR1t7QL70r7KgkmJkAkmyAqV2SJDOggl
         dY0ybAZaCyyWr8mRzzx+c4uUBX1HWQwkxVyaJ/HtjpC4DOQuKyqjz7s8CyU4Yg+PVbEk
         oXnXDQxz6Sx1VhfZ5SUByvCJobA+TkGFy1J6bixqzKKcNyNzz9X2+er2Yzd8o9e9COVf
         0WoWOIBoWfjNq+4Y74DpqdlmiUqI9Lc7q4IyZZqsh0ZDdB56s387IcznOlY53RMD2VHI
         /kxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703086626; x=1703691426;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=koGRJJdk0KHZeqrqMZXxqKWfVpvB14ZXeK4Zc4mq2WY=;
        b=D3yaIvHZxNPsAist1WYIXWVNrLeK3PfSgnYqF+vn9wdaZsb2qdC5MGE5dvllMHf30M
         lkmmbp90CF0zzloho0o1jShjwoVDjlhFkBxUxb7QwhFJEhTtgG+6euWeRGQxAkM9F2pk
         RzQ4sUjEO3CwFu6zQ+ZVbM96o9EcVappIzP0OZGTbpkac9WxAJ1xda9XkTX846O/4GVq
         VegDVK+TAcZsCtRyTx0RVrmogYxy7kZJO+DKXPQpIOHYts4hbMyPBmUpc8lB9KKAVlTZ
         oJw/RgkHam7ccl98HAp4BJ2IJGnKXlIeLmPBuVr4l1W5VuJQI5Y9UCawbjhCbW+AiOqF
         Lhpg==
X-Gm-Message-State: AOJu0YwiUSP9B6DdLqi71WSH8nH1IaX6aVWyfRKHXX9t9fAtim25rog1
	ybJnfEoKTNGuwN1VUPbF13owGqVFAV8=
X-Google-Smtp-Source: AGHT+IFpcG0k33vH0vJeWL0gSzzw1l89eXIvNtHQuHjv9FZifTN9cz87chLJg476BD4+2C3RuaaQODVqSfs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:dc9:b0:5e5:e1e2:31f with SMTP id
 db9-20020a05690c0dc900b005e5e1e2031fmr3246466ywb.6.1703086626446; Wed, 20 Dec
 2023 07:37:06 -0800 (PST)
Date: Wed, 20 Dec 2023 07:37:04 -0800
In-Reply-To: <6cfc6f05-7c43-49d9-8e1a-bfa6e34f6b56@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com> <ZYBhl200jZpWDqpU@google.com>
 <ZYEFGQBti5DqlJiu@chao-email> <CALMp9eSJT7PajjX==L9eLKEEVuL-tvY0yN1gXmtzW5EUKHX3Yg@mail.gmail.com>
 <ZYFPsISS9K867BU5@chao-email> <ZYG2CDRFlq50siec@google.com> <6cfc6f05-7c43-49d9-8e1a-bfa6e34f6b56@intel.com>
Message-ID: <ZYMKCtYdXWtNQuLU@google.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Jim Mattson <jmattson@google.com>, 
	Tao Su <tao1.su@linux.intel.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	eddie.dong@intel.com, yuan.yao@linux.intel.com, yi1.lai@intel.com, 
	xudong.hao@intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 20, 2023, Xiaoyao Li wrote:
> On 12/19/2023 11:26 PM, Sean Christopherson wrote:
> > KVM can simply
> > constrain the advertised MAXPHYADDR, no?
> 
> Sean. It looks you agree with this patch (Patch 1) now.

Doh, my apologies.  I don't think I even got to the code, I reacted to the shortlog,
changelog, and to patch 2.  I'll re-respond.


