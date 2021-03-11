Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D56337E4F
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 20:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhCKTj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 14:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhCKTjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 14:39:39 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D106BC061574;
        Thu, 11 Mar 2021 11:39:38 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id a9so21866670qkn.13;
        Thu, 11 Mar 2021 11:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=J6ZVBfVZRTkSOXZ58J3mQQUyv5RexzLY8G/YXzNw3gg=;
        b=aeyBPHOo96EVYsMl4EKRqRg7PAOMWcAChCuvfw246ZdPtGEFxCU5KTrsB0CrwxwPV5
         VeofU1Vy+8OGBU14nm3l8e8shZpL2cXu4wVt+1zqc+2zagrT6Ixgo+SXwXqPvIQTyej+
         /5+KcpdjG38fHSNPGd3AXgvkbiZvQtXbTfU9Hr1/1+uK3hWWNzRRuCIcZUFP6+AmfyiG
         fLwqY7StbRxtPyibTYlXFxg4YgN9Wc2tDY6cbjPSafLEp+JD0hFEUpMLMJtXO4lsjqWJ
         EMHXMSN8XdbVX6cALJvJdTxsgIwSBhivrT2abm88VpVpalQuevvoExn7gVv8djmqGWTr
         t3hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=J6ZVBfVZRTkSOXZ58J3mQQUyv5RexzLY8G/YXzNw3gg=;
        b=FEuumfOLtBazVLyqlIy/WyQF+jFhRfrG/Q9rXT4BxGh6UAl+sKylmK4S015+VOpngc
         TbulsZmqX61K/UaktTy+7OEB8WLXi40upjtEGGS9wDvoKFcpXKX8TMe5hh4rdclF9t9L
         cNtn9KjRJUgZ5Kv66fxAdpDxNh8v7UWCk8kxv860C+hQcIVgbTTRMYx4YLL/UfICnhBw
         AKglC8+1m3KzvnwEwF1max1s54r3F0E7V/K/2l4A2syrNsGrkt6iWz2CNYXrjO5AaTv2
         QrnZh0hc8WSuHA1kwwucTZqdxIQ6njY3eUpiWMIy4k8xAEoO+5TwcqjHwSuc8OTXXvFZ
         OW9w==
X-Gm-Message-State: AOAM5323IpTm+C6exJffExgftyuXpfQ51xwMGrxhiiE9CmIzIN1vOFF7
        UVFBY1rMAo77cCqAI7oEFF8=
X-Google-Smtp-Source: ABdhPJy5A+CmvUM20BCIYZj+wwWjdnWw7OCE4uLMPsqVK6GnI9O2jt7rLLqtNu5XReRylUGz7+vQQw==
X-Received: by 2002:a37:8544:: with SMTP id h65mr9228499qkd.200.1615491577840;
        Thu, 11 Mar 2021 11:39:37 -0800 (PST)
Received: from localhost (2603-7000-9602-8233-06d4-c4ff-fe48-9d05.res6.spectrum.com. [2603:7000:9602:8233:6d4:c4ff:fe48:9d05])
        by smtp.gmail.com with ESMTPSA id t24sm2399092qto.23.2021.03.11.11.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 11:39:37 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 11 Mar 2021 14:39:36 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc:     Vipin Sharma <vipinsh@google.com>, rdunlap@infradead.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 0/2] cgroup: New misc cgroup controller
Message-ID: <YEpx+HTd/S2EfJCe@slm.duckdns.org>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <YETLqGIw1GekWdYK@slm.duckdns.org>
 <YEpoS90X19Z2QOro@blackbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YEpoS90X19Z2QOro@blackbook>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Thu, Mar 11, 2021 at 07:58:19PM +0100, Michal Koutný wrote:
> > Michal, as you've been reviewing the series, can you please take
> > another look and ack them if you don't find anything objectionable?
> Honestly, I'm still sitting on the fence whether this needs a new
> controller and whether the miscontroller (:-p) is a good approach in the
> long term [1].

Yeah, it's a bit of cop-out. My take is that the underlying hardware feature
isn't mature enough to have reasonable abstraction built on top of them.
Given time, maybe future iterations will get there or maybe it's a passing
fad and people will mostly forget about these.

In the meantime, keeping them out of cgroup is one direction, a relatively
high friction one but still viable. Or we can provide something of a halfway
house so that people who have immediate needs can still leverage the
existing infrastructure while controlling the amount of time, energy and
future lock-ins they take. So, that's misc controller.

I'm somewhat ambivalent but we've had multiple of these things popping up in
the past several years and containment seems to be a reasonable approach at
this point.

> [1] Currently, only one thing comes to my mind -- the delegation via
> cgroup.subtree_control. The miscontroller may add possibly further
> resources whose delegation granularity is bunched up under one entry.

Controller enabling and delegation in themselves aren't supposed to have
resource or security implications, so I don't think it's a practical
problem.

Thanks.

-- 
tejun
