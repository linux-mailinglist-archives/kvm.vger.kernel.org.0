Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745B764E2AC
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 21:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiLOU7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 15:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiLOU7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 15:59:40 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C35954343;
        Thu, 15 Dec 2022 12:59:40 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id gt4so433052pjb.1;
        Thu, 15 Dec 2022 12:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xJBNVirIxjRTnviyLQ3VvNqsXr9KTaq6mCTY4+eqgXk=;
        b=QSJYi0LX3T2XajNmp04PqUS/ym18CnV7ysHk8CCn7goYsLo/Barc400KJWRTWEQVj0
         Z3tcGNcz7LggzZLgeUL5TWtjFRp/fK9o9qgD4iTFDQ6+i61JpswrZn8Du3Oa6gJ3n78y
         qw6AB0ygqnFF69JyjAVleZQ1I+1kbRZ05qJv6NsC4aOPkSWF4Ii9ABtMJtNVRS0De6mR
         BT6XamFPgcPUPB+7LQkNfQZV0yL7MDLqLgB+CX6aaiKm1okC2QuYXfTkQbDzaMTgoJG3
         a4+64AwU4jcqiOlzuKcUPAlnsoG6nTC9bvyuIwxVID9w1KoLXTdRMOYbENYUuoSloRQI
         QQBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xJBNVirIxjRTnviyLQ3VvNqsXr9KTaq6mCTY4+eqgXk=;
        b=2Xxley2lQZDDgQpaNGoIJEqX0EBEe4JBEA2g9FaFmuT6GI+8PbFgUtuoZg4eYVjw//
         FtU6wxmJaM175QoYFF6Q9ahDQvto/YrTJrKPxOlMdCxji0BL0J5AaZO1dBB9/EX1RnAs
         WOD2Mq4OhVCM3jLs8BXTlNhLROzUwrjqoeXm1GSmUbv4CPCkWRMbMe/LT1UKqYExiX5T
         OVo892BY5LMuRMak5vPSQwvUNvnnVL7Es/YtyXAbQwYorTfjEEju+USZZn8BdnHa4UMX
         75V8zKQJyUC4HPJoL38Ie5MYWTZ+kjt/xTk5RjaCKUx4n7Cz7WyiDEU8mHCYNhoQo25/
         bgwg==
X-Gm-Message-State: ANoB5pmPCXcwoxhv1tIXT6qhfHxTf2qqWoVwgwZCOFDpP1jQ8geNzphv
        VxU6l6jchmLvs03IEQuxfU0=
X-Google-Smtp-Source: AA0mqf4A24INIOURF2H6vKjJnv7ul8OtPhF92AG1def34dGvTwoQK5yUZlk5DlaUCn1RtjkAZRX9Ew==
X-Received: by 2002:a17:90a:7e93:b0:219:6626:3b63 with SMTP id j19-20020a17090a7e9300b0021966263b63mr31328420pjl.25.1671137979344;
        Thu, 15 Dec 2022 12:59:39 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id gw14-20020a17090b0a4e00b00218a7808ec9sm86046pjb.8.2022.12.15.12.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 12:59:38 -0800 (PST)
Date:   Thu, 15 Dec 2022 12:59:37 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Ackerley Tng <ackerleytng@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        pbonzini@redhat.com, erdemaktas@google.com, seanjc@google.com,
        sagis@google.com, dmatlack@google.com,
        sean.j.christopherson@intel.com, kai.huang@intel.com
Subject: Re: [PATCH v10 016/108] KVM: TDX: create/destroy VM structure
Message-ID: <20221215205937.GF3632095@ls.amr.corp.intel.com>
References: <fb337a67e17715977e46523d1344cb2a7f46a37a.1667110240.git.isaku.yamahata@intel.com>
 <diqz4ju4wfqg.fsf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <diqz4ju4wfqg.fsf@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 11:15:35AM -0800,
Ackerley Tng <ackerleytng@google.com> wrote:

> 
> In tdx_vm_init, it is possible to have a double-reclaim, which
> eventually causes a host crash. I have a selftest that reliably
> reproduces this, and I believe the problem is that withiin
> tdx_vm_free(), we don't reset kvm->tdcs = NULL and kvm->tdr.added to
> false.

Thanks for the fix. Did you use error injection to trigger the error path?

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
