Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF9F598AE4
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 20:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345082AbiHRSKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 14:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241850AbiHRSKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 14:10:21 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2150C7429
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 11:10:20 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q9so957017pgq.6
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 11:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=JxS+AoR5Z3foSOY0+Ar8q8SgaAJrMyNQbT23W/mzpcs=;
        b=pDBiETRhCQPgQUMPJo71oWtyuM2YJ25T136p6RiNEeBwMmgO+CWZTnya8KTA4m5aq3
         DpQ6s4oTeP6yCi93Dy7qah50UvleNLcY8xCyhCzlJ41h7uwycxitT1LhPzNXBwpB2gqp
         4q0CzdmVwiJ3jraKBVByv5unK4FB4d7xnrCld0UMe6QkALZLByDyPwUhfhSLyTpx2GwQ
         Aubv6CASvbRBw9aiWZU978ZQ+4daVaWN38aAcGajYrTwIVRgdb0IAxWVl1bnxoUuAXDy
         2FixKOT1ZUyRd222rkNgmNBks3/oUaIMpio2nkPcwFqKUe/IcPKw0mq1jO9oO7OqD+uq
         Lkyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=JxS+AoR5Z3foSOY0+Ar8q8SgaAJrMyNQbT23W/mzpcs=;
        b=dfE3lQfh86lH/3pvCgXC8F29bb9514jTAiBY4vlg7avCYoC5zT09kv15xQJk+v5W0i
         o9FRPcwQ8GyxavUGUBZhmi6c6Gns3q9lXZsx9nC91wqE/MOS0Khmrlc6cOgdUFjwrB0u
         5F3wbn+oyB9tl9B7PhPjkMD5Ats6PR3UZOfJ/rM9aidmMLcsTTz5gxsDroEPPnsqVGEr
         vwiEwtyWl12lolHRIRD6XYmKTF/JMjgY3rZGZ5fMEdM7wX0pVpB6OHTY/fvmiBu49AaD
         Yz1JrsTRn2ecCk+iY8mBjnOIIbHwqvz61aJ5zy8HuIrUVEq/ou9EyHjwqAmW2rsJalFJ
         +xmw==
X-Gm-Message-State: ACgBeo1D+pYgHtKVa7jKeGaop530rhKm/D2NzbQAjtQ4a6qafWhyw6Ct
        fby1sdwy8UqLfW9yedLxzuz60A==
X-Google-Smtp-Source: AA6agR4BI3KaPSuln0eVBIyiHQX2Ue/QaphJ0hLcxgWVqBfdmn4xufVw6pb/sNnVV5E86GTTiIxiag==
X-Received: by 2002:a63:91c2:0:b0:41c:66a3:cecb with SMTP id l185-20020a6391c2000000b0041c66a3cecbmr3192398pge.288.1660846220080;
        Thu, 18 Aug 2022 11:10:20 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l17-20020a170903121100b0017286f83fadsm1752822plh.135.2022.08.18.11.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 11:10:19 -0700 (PDT)
Date:   Thu, 18 Aug 2022 18:10:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     dmatlack@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Run dirty_log_perf_test on specific cpus
Message-ID: <Yv6AiPtRbHv4OSL5@google.com>
References: <20220817152956.4056410-1-vipinsh@google.com>
 <Yv0kRhSjSqz0i0lG@google.com>
 <CAHVum0fT7zJ0qj39xG7OnAObBqeBiz_kAp+chsh9nFytosf9Yg@mail.gmail.com>
 <Yv1ds4zVCt6hbxC4@google.com>
 <CAHVum0dJBwtc5yNzK=n2OQn8YZohTxgFST0XBPUWweQ+KuSeWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0dJBwtc5yNzK=n2OQn8YZohTxgFST0XBPUWweQ+KuSeWQ@mail.gmail.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 18, 2022, Vipin Sharma wrote:
> On Wed, Aug 17, 2022 at 2:29 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Aug 17, 2022, Vipin Sharma wrote:
> > > On Wed, Aug 17, 2022 at 10:25 AM Sean Christopherson <seanjc@google.com> wrote:
> 
> > > We need error checking here to make sure that the user really wants
> > > cpu 0 and it was not a mistake in typing.
> > > I was thinking of using parse_num API for other places as well instead
> > > of atoi() in dirty_log_perf_test.
> >
> > Yes, definitely.  And maybe give it a name like atoi_paranoid()?
> 
> Lol. Absolutely, if that's what you want!

The goal is to capture that it's effectively atoi(), but with checking.  E.g. most
developers will be familiar with atoi() and won't have to think too hard if they
see e.g. atoi_paranoid().  On the other hand, parse_num() leaves the reader
wondering if it's parsing hex, decimal, octal, etc..., why selftests just doesn't
use atoi(), etc...

> Okay, I will remove -d and only keep -c. I will extend it to support
> pinning the main worker and vcpus. Arguments to -c will be like:
> <main woker lcpu>, <vcpu0's lcpu>, <vcpu1's lcpu>, <vcpu2's lcpu>,...
> Example:
> ./dirty_log_perf_test -v 3 -c 1,20,21,22
> 
> Main worker will run on 1 and 3 vcpus  will run on logical cpus 20, 21 and 22.

I think it makes sense to have the vCPUs be first.  That way vcpu0 => task_map[0],
and we can also extend the option in the future without breaking existing command
lines, e.g. to add more workers and/or redefine the behavior of the "trailing"
numbers to say that all workers are affined to those CPUs (to allow sequestering
the main worker from vCPUs without pinning it to a single CPU).
