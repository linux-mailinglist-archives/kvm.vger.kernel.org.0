Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D570961195D
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 19:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiJ1Rhn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 13:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiJ1Rhm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 13:37:42 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F9F202729
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 10:37:42 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id bp11so7522153wrb.9
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 10:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kV7MmgRICexqZDA6XAEcNOU0nOiN/bt/4yb0+BmfSag=;
        b=n0HXNyNNgb8L2VChFAUYfXPFicNplKItk5SACKHVuPWpeT4s/6BeK3eYhhaFMWNDIK
         /4hDz0w3cTw8aQBYvZ7SeVvKWCCwQeheBJlYpxWmZ/aREopPexhUqtNL9L/9NKK/uZHF
         jC9QPVgWZymcb3YFZA+OyIes9I/31C02aCUph7DLSx4rpejEQqVA65y+cjTOxD/Y8hNQ
         gfPsxxOp+JNDvvy1I7jUSNyfrltalszW+OvXbddPUzU8C4QtfT+tCbLS3GpWvd00svJs
         PsM3YgXA8es/JfPgYj8HeUXMr3WcDEnaEnUHj0SH9OtU+/3hJa5IwzWotVyzA0p0ATlG
         90OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kV7MmgRICexqZDA6XAEcNOU0nOiN/bt/4yb0+BmfSag=;
        b=TXzXpobLJkBP7SyVxZLL82tII8AJ70SAeDxreiAkjkP5M1u8imKDD7zGXSbvSvgA1D
         2z9waHVV5yXhFq1mi1DMtaEC5I8/xGAVLumPpw8FwN/ayTaS51qMfSmcdpiVQUm+40ZO
         N8P+WnwxmoovLdMKrqLfRUD7zSByYxpJPf6QBc1Qrfyv+ximLF1vsdCcMQCHUTUdUwFS
         xa9tDY9iJhclqjAtLjYo3I/dbJ5XY6fK6p0so93qxgJ4I/axU7u5L3AG9kCjHvht2TWV
         dWd6+Jr6TjaiY9kpqMB3IX0B20RvTt4yJjia+mQRoB5ffd9yoTXD/Efvpwu2Z5ofRU/B
         akTw==
X-Gm-Message-State: ACrzQf3VR9EpEkxVr+3THN+3jwwVtoRELqMQLVKiQHKIaaP5CAWpKJBp
        JnAXkZqNDbef++7XfqsufkHCIrdk1TbK+K+DOIHz8Q==
X-Google-Smtp-Source: AMsMyM6r0OZ72MOueBEdYgdzX8Jy3UmVthkJtTnrV3tLfySk6NlYuJkc172vH7YxWl/wqUyzSmDPGIwADJL4tpgeGiU=
X-Received: by 2002:adf:e94a:0:b0:236:6f5a:e89b with SMTP id
 m10-20020adfe94a000000b002366f5ae89bmr282460wrn.451.1666978660361; Fri, 28
 Oct 2022 10:37:40 -0700 (PDT)
MIME-Version: 1.0
References: <20221021211816.1525201-1-vipinsh@google.com> <20221021211816.1525201-6-vipinsh@google.com>
 <DS0PR11MB637351B52E5F8752E7DA16A4DC309@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y1lV0l4uDjXdKpkL@google.com> <DS0PR11MB6373E6CA4DDFFD47B64CB719DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y1qqIgVdZi7qSUD0@google.com> <CAHVum0edLWu0fGMgs7n2v2Fu-XW5mXtAsJ2dtkWD=ZadbRi+hw@mail.gmail.com>
 <DS0PR11MB63735722DBD08190B849DD9DDC329@DS0PR11MB6373.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB63735722DBD08190B849DD9DDC329@DS0PR11MB6373.namprd11.prod.outlook.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 28 Oct 2022 10:37:04 -0700
Message-ID: <CAHVum0dXYxD1-90mwq2Q5YojoWPiomPWhAGsgFzC_fSB7qF4ew@mail.gmail.com>
Subject: Re: [PATCH v6 5/5] KVM: selftests: Allowing running
 dirty_log_perf_test on specific CPUs
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022 at 7:11 PM Wang, Wei W <wei.w.wang@intel.com> wrote:
>
> On Friday, October 28, 2022 4:03 AM, Vipin Sharma wrote:
> > pthread_create() will internally call sched_setaffinity() syscall after creation of a
> > thread on a random CPU. So, from the performance side there is not much
> > difference between the two approaches.
>
> The main difference I see is that the vcpu could be created on one NUMA node by
> default initially and then gets pinned to another NUMA node.
>

pthread_create(..., &attr,...) calls clone and then
sched_setaffinity(). This is not different than calling
pthread_create(...,NULL,...) and then explicitly calling
sched_setaffinity() by a user. vCPU creation on one NUMA node and then
getting pinned to another NUMA node is equally probable in both
approaches.
