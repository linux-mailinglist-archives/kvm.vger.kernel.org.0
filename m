Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F824BA788
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 18:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242295AbiBQRwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 12:52:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbiBQRwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 12:52:42 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B807AB2D6A
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 09:52:27 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c6so8320628edk.12
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 09:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0GezYuBq/IBk84/vSXTIhXk7J6MIx3mjFhk6IwFvMpk=;
        b=jLaab6MwwT20QXD4svGT4lr1ununpN2FDzfw5Fd5zN6NacnaFxdFx/32vEkC4NW6jk
         zkbeWhtkY5i4CnmhFXMqOwvr9CBReUqYHQbYGVZbhPq6jiJlHLszzydv65qpfQA8QTFQ
         Y7aSWHzgC/8dvePLHMdKg2l7ChiAxPHDx/4ma3gbp0nMUq8yjIv5s0G8VjLd4DYc6WPQ
         KM2yKtixtMjDh9EIEP951hwb2dfs6Fg7EaTAx08VPJ9u8rKWgdwOspobpOFkMRCFkFLx
         RC2gp1VeFZCE101Ix5JhDVANbO5Xa4/rrGhBgwkRxIPjZiR64PxNPl8TFZxBZGLN+aSy
         Agtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0GezYuBq/IBk84/vSXTIhXk7J6MIx3mjFhk6IwFvMpk=;
        b=CnYm+MlTjhx8tO0ypaRODfj07kXbQvhvD3F7P9UrEJRfiVbjj+qugiIcqr4wEC3dO9
         d4v7xo4D7DKL8KcspklSjJuurjOnuEC9zRGUNoOubhmHIsN9jsWZXb7ubSHmlBS4Kzje
         YdWDLOoYOO4HHV+lOlgs6LsEx+1TNrxx6c+1eykuZNtriH/njTC60dBxuCR9+NupHYJJ
         r2aS42ZbWfkcaokMfjt+f9sTVxC0uYmG/EJu9s6c5XtYWsugUHXcxw/z5QC+iUY0CMhz
         FRM8hC51b6zJD+9d2vL2gZSFNBmxzWgiPq9KjAz7TC6QLpo3dPwCvRnn8EM5IVqkQF4J
         dkZQ==
X-Gm-Message-State: AOAM533K3VwqCC2tVKTkTXfwdhNZnM3WRyFyF4buk/BibGwut90P6VxG
        sL1rHCQiObP+ZOsx+Ihb0JI=
X-Google-Smtp-Source: ABdhPJzI200juUtGBf/k8LHDGffRyefuo8jxOX3KLk/VDR0ORMo5x7f5QIrkpeZ3jz6H/ybWZB20vQ==
X-Received: by 2002:a05:6402:18:b0:410:86cd:9dce with SMTP id d24-20020a056402001800b0041086cd9dcemr3830314edu.70.1645120346234;
        Thu, 17 Feb 2022 09:52:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id b5sm3717367edz.13.2022.02.17.09.52.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 09:52:25 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <f7dc638d-0de1-baa8-d883-fd8435ae13f2@redhat.com>
Date:   Thu, 17 Feb 2022 18:52:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@gmail.com>,
        qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>
Cc:     Mark Kanda <mark.kanda@oracle.com>
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/28/22 16:47, Stefan Hajnoczi wrote:
> Dear QEMU, KVM, and rust-vmm communities,
> QEMU will apply for Google Summer of Code 2022
> (https://summerofcode.withgoogle.com/) and has been accepted into
> Outreachy May-August 2022 (https://www.outreachy.org/). You can now
> submit internship project ideas for QEMU, KVM, and rust-vmm!
> 
> If you have experience contributing to QEMU, KVM, or rust-vmm you can
> be a mentor. It's a great way to give back and you get to work with
> people who are just starting out in open source.
> 
> Please reply to this email by February 21st with your project ideas.

I would like to co-mentor one or more projects about adding more 
statistics to Mark Kanda's newly-born introspectable statistics 
subsystem in QEMU 
(https://patchew.org/QEMU/20220215150433.2310711-1-mark.kanda@oracle.com/), 
for example integrating "info blockstats"; and/or, to add matching 
functionality to libvirt.

However, I will only be available for co-mentoring unfortunately.

Paolo

> Good project ideas are suitable for remote work by a competent
> programmer who is not yet familiar with the codebase. In
> addition, they are:
> - Well-defined - the scope is clear
> - Self-contained - there are few dependencies
> - Uncontroversial - they are acceptable to the community
> - Incremental - they produce deliverables along the way
> 
> Feel free to post ideas even if you are unable to mentor the project.
> It doesn't hurt to share the idea!
> 
> I will review project ideas and keep you up-to-date on QEMU's
> acceptance into GSoC.
> 
> Internship program details:
> - Paid, remote work open source internships
> - GSoC projects are 175 or 350 hours, Outreachy projects are 30
> hrs/week for 12 weeks
> - Mentored by volunteers from QEMU, KVM, and rust-vmm
> - Mentors typically spend at least 5 hours per week during the coding period
> 
> Changes since last year: GSoC now has 175 or 350 hour project sizes
> instead of 12 week full-time projects. GSoC will accept applicants who
> are not students, before it was limited to students.
> 
> For more background on QEMU internships, check out this video:
> https://www.youtube.com/watch?v=xNVCX7YMUL8
> 
> Please let me know if you have any questions!
> 
> Stefan
> 

