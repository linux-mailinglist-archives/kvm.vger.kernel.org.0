Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B162EAEC9
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 16:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbhAEPiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 10:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbhAEPiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 10:38:07 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C77C061574;
        Tue,  5 Jan 2021 07:37:27 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id v126so26734437qkd.11;
        Tue, 05 Jan 2021 07:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OkXL1EFyZinDOQMdya4rZdvw/dJev0p82LTHbe0DFao=;
        b=KJ6P2nu2S3iBxkYTpfSqP+V+xlOKYWA3Y5MKfCdWSvI20X4BmnSw0FBdKZ2tiysa/u
         OHtFo4qwvv/ETi6a+9k8DHlc0dOgavjgIi4Dmsuxzw3DQm22Mryu88ADMBb7+VjglpwI
         Q2wQ2S7LVuAtL6vQcxNqa/Tjj/PGjwWasP5OTH8FaWQuaeAtL+4sK9cvDCN1/+dpHSu8
         ZE0RhTN9bEQ7ImcQS0qmZjyWUUbY5L5H0x2xkBlXMHzUJ2oXExF+xTHINcglxBablW0w
         QYqq2IEmch/yoe5fAfdRu5Ejp6jDeedkfgWQQ3zJBUssG70masoUfUcmR1VV9/uXuLKg
         piuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=OkXL1EFyZinDOQMdya4rZdvw/dJev0p82LTHbe0DFao=;
        b=csybmMIOx3U6jozsh7jeGT6AdAF8DD42COdqe2tf1xU0k3Ws1KdYpxmJ04NlzyBSCV
         KG/jPpAFrie29sYalrGKap+0ZkXqX+Q+mTgsHOzTlY7Damx+daZlLC9QaCYwWfKWS4xE
         0qXjYOiArzcwnRMpRSZRllqpqMzxxdwQ6c6v8m+lPI9qFr0xOlTezInICYHDMUPDKA5v
         etkzhH/V+yooTLwzEAe4OFvSU0QVftC2pmIe+JP4XWgwheRgbcw7iumK6Lee5UiXKEtH
         XXi0XExFh1JC+brmZ8+LHJhorv+qOPLRvXdkukc5zQPx8JZHJH23EvjrBcuWN4g1w/BN
         WFVg==
X-Gm-Message-State: AOAM532uvlhMiXERE6flZei1uE18iIKlR9B3sQNf83sB3za0+sZB/K/W
        ST2yhmxdXCCzC/xxYmyrLDE=
X-Google-Smtp-Source: ABdhPJzw2/nGtWwAC4dfC2TVBj+Emx4Ao/FIkSFzpZCfTwUBlCU6BbWkVTJK7u+fv0xNDXfYhOPP5g==
X-Received: by 2002:a05:620a:11ad:: with SMTP id c13mr104956qkk.134.1609861046219;
        Tue, 05 Jan 2021 07:37:26 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ce7b])
        by smtp.gmail.com with ESMTPSA id j124sm143633qkf.113.2021.01.05.07.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 07:37:24 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 5 Jan 2021 10:36:40 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh <brijesh.singh@amd.com>, Jon <jon.grimm@amd.com>,
        Eric <eric.vantassell@amd.com>, pbonzini@redhat.com,
        Sean Christopherson <seanjc@google.com>, lizefan@huawei.com,
        hannes@cmpxchg.org, Janosch Frank <frankja@linux.ibm.com>,
        corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Jim Mattson <jmattson@google.com>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        Matt Gingell <gingell@google.com>,
        Dionna Glaze <dionnaglaze@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 0/2] cgroup: KVM: New Encryption IDs cgroup controller
Message-ID: <X/SHiFHRsQM43VgC@mtj.duckdns.org>
References: <20201209205413.3391139-1-vipinsh@google.com>
 <X9E6eZaIFDhzrqWO@mtj.duckdns.org>
 <4f7b9c3f-200e-6127-1d94-91dd9c917921@de.ibm.com>
 <5f8d4cba-d3f-61c2-f97-fdb338fec9b8@google.com>
 <X9onUwvKovJeHpKR@mtj.duckdns.org>
 <CAHVum0dS+QxWFSK+evxQtZDHkZZx9pr0m_jEDHc9ovd5jQcfaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0dS+QxWFSK+evxQtZDHkZZx9pr0m_jEDHc9ovd5jQcfaA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Happy new year!

On Wed, Dec 16, 2020 at 12:02:37PM -0800, Vipin Sharma wrote:
> I like the idea of having a separate controller to keep the code simple and
> easier for maintenance.

Yeah, the more I think about it, keeping it separate seems like the right
thing to do. What bothers me primarily is that the internal logic is
identical between the RDMA controller and this one. If you wanna try
factoring them out into library, great. If not, I don't think it should
block merging this controller. We can get to refactoring later.

Thanks.

-- 
tejun
