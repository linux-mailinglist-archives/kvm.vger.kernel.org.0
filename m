Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12242DC31A
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 16:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgLPP2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 10:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgLPP2a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 10:28:30 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EC2C06179C;
        Wed, 16 Dec 2020 07:27:50 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id b9so17435029qtr.2;
        Wed, 16 Dec 2020 07:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=prX3rWtyfPweOuw4gkFpK72BDK4qvRlCVupw3Ndw2Ac=;
        b=rezOy+6QPMcMTmHZilEXd5MahyR0XoYOFbeKSduB26x0hjzRboxW8uHxlpwAPUptzE
         zByvM8BVF7DqzhPTm1pLiRwkFncJRgXgk14fZ3Td5hXZ3ppHAYRVr4K2fmISA/yC3Tg0
         u9fOdp8eaoAayhcY31tEC3A76cRVIkZghlj1ifANhhBGZHwsbykoABxX4WbT8YwSrL4N
         0RMXDdI4XzOF/bcjpfJfe/QUTNbZNe1itunCwu7tIeOmzGjdiHCozLO5a2A3J41IRn5s
         DyyOmQz+GHzQRLN8jYIK0m3LPrDULTB5zJq6uaYm2JB/h+d76aj+Ew/g7hHFE1x/uYkT
         szFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=prX3rWtyfPweOuw4gkFpK72BDK4qvRlCVupw3Ndw2Ac=;
        b=aCWEeXVpk1n8cNvU/mwDh5xuX4bY0u7BUoue3/sqd8gOTm2wuyxP7NCEbLiphBZGhH
         LPqj0/S/yM9+EcBA2rBD13XhmPKyOBm38D+QKzg9j4yAJVGmuhzZiLxXDd24r+59UArc
         VwXJhuTcxuNmqu2JmPfBi7zSdI4Ktz8ezYHMTGf3Usz6YmasMqwGnU3HT30uawP33one
         v5ieRWQzGzMM3lID5+xvu5Jt2BBCRQ9ZrJpvNwVfwQK7fWKb3LukNcnIRoSxMzhtoToM
         5Ki0Y0MvDKfAfs7uypgmE2r7JLEWlECKd/pkhgCF80fnYirH86zCVS9TRkhoTwnau9ne
         HFOA==
X-Gm-Message-State: AOAM531QJcLqXVvFfqvlmVQ9tSb3Vw/4wL5fMMzxd8Lps2qajUAxFWQn
        rsn52d91yQNlKjdykQh7lbY=
X-Google-Smtp-Source: ABdhPJx7xYoKRj1ObnlCPOdJs3LfrmdGBNyMnAOZNNo2pNXrhYjus3PJOgxipTiPrGzDD2WVLDcsXQ==
X-Received: by 2002:ac8:3656:: with SMTP id n22mr43721803qtb.242.1608132469499;
        Wed, 16 Dec 2020 07:27:49 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:cbde])
        by smtp.gmail.com with ESMTPSA id c65sm1324569qkf.47.2020.12.16.07.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 07:27:48 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 16 Dec 2020 10:27:15 -0500
From:   Tejun Heo <tj@kernel.org>
To:     David Rientjes <rientjes@google.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Vipin Sharma <vipinsh@google.com>, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, seanjc@google.com, lizefan@huawei.com,
        hannes@cmpxchg.org, frankja@linux.ibm.com, corbet@lwn.net,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 0/2] cgroup: KVM: New Encryption IDs cgroup controller
Message-ID: <X9onUwvKovJeHpKR@mtj.duckdns.org>
References: <20201209205413.3391139-1-vipinsh@google.com>
 <X9E6eZaIFDhzrqWO@mtj.duckdns.org>
 <4f7b9c3f-200e-6127-1d94-91dd9c917921@de.ibm.com>
 <5f8d4cba-d3f-61c2-f97-fdb338fec9b8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f8d4cba-d3f-61c2-f97-fdb338fec9b8@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Thu, Dec 10, 2020 at 03:44:35PM -0800, David Rientjes wrote:
> Concern with a single misc controller would be that any subsystem that 
> wants to use it has to exactly fit this support: current, max, stat, 
> nothing more.  The moment a controller needs some additional support, and 
> its controller is already implemented in previous kernel versionv as a 
> part of "misc," we face a problem.

Yeah, that's a valid concern, but given the history, there doesn't seem to
be much need beyond that for these use cases and the limited need seems
inherent to the way the resources are defined and consumed. So yeah, it can
either way.

Thanks.

-- 
tejun
