Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B98588EA2
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 16:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbiHCOZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 10:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235937AbiHCOZW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 10:25:22 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842C0CE10
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 07:25:21 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id h21-20020a17090aa89500b001f31a61b91dso2184233pjq.4
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 07:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=w9zVjbr2BmbxachmFSJYF0xazI9Ui5pcEuEgj66//Fk=;
        b=mQfdH3EHi6SF7Q42T6CzBCzqnoYwMKpN51vw6sv1aMUtkIQrhcPOSbKelR+71BQ4bu
         QwX9wZnqVN4rsGjiRLcxg8awy7h2MKkLQiQhWXV2GSdoO+aVkcThr/kkqCrElsFw3m98
         d/zXihj4bwPgv4NI1syPehAlSWYzjVNsMgvP1J/AeQBFz2aygZk7TU9dxHaBk5yg+krE
         yS8lWsDpnbxMgbgoTv4Qehl6CNQI7sGk8GGm0r+z7d2PBWML6Xwk+q08Xm+SyeppiB9q
         xhqEgy0tvWwTEQfEH6RntG2B+OAVQ6v0WRjR8VDw4MHCdg8N/H+9CZIUUxKjbHT3AE45
         LnGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=w9zVjbr2BmbxachmFSJYF0xazI9Ui5pcEuEgj66//Fk=;
        b=6Iys0K7rjkN9Tkm8d86npOBP8mN0koGaVEU1+LkOTSIEgIE+idAnXScXlQpL4G9qZP
         Cch9G6a6BWtU8h1FvyC8b5gbxtO1PF/MS6K0m8uGFJ2Ib9ca9LoHMBQ+RO0W5jBFfP3t
         bcUZQCnv0IQMXcM7qrEl4sTZv6yBPii8L8ABc2yLGRDbd6OBlzx6lLa85CoTR6xkkbZt
         VsV8U6BOVypms29N7OifXBdb9rWPxIIZVxx9o44O95u/kECdzdKY26TZmyxEmKblxoWP
         91Xf4Zfk+JkIE+AJVLocv8hfSqJYIeSYjfi5KRHQiW16vFP11+MXXigUDL9BQQLstBqB
         XJbg==
X-Gm-Message-State: ACgBeo36Kc/C75i9/JcCi/ixE78YgkJxdqUZaHXTZV1xdfFRfJsJEnY2
        YlLPaLrYHIXfWylbYfzV486jhA==
X-Google-Smtp-Source: AA6agR6XFqOLzTgmHcHzjmMCW6IBUT3GRRJAoUkEho+2J/YAVztkFLZpm0r2dyj741/n7QlznvrYiw==
X-Received: by 2002:a17:90b:4c4e:b0:1f0:48e7:7258 with SMTP id np14-20020a17090b4c4e00b001f048e77258mr5259684pjb.223.1659536720885;
        Wed, 03 Aug 2022 07:25:20 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u17-20020a170903125100b0016c27561454sm2068618plh.283.2022.08.03.07.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 07:25:19 -0700 (PDT)
Date:   Wed, 3 Aug 2022 14:25:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] X86: Set up EPT before running
 vmx_pf_exception_test
Message-ID: <YuqFS9nNVfMl6NnI@google.com>
References: <20220715113334.52491-1-yu.c.zhang@linux.intel.com>
 <YumMC1hAVpTWLmap@google.com>
 <20220803015742.v2kzo5edaqdmi456@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803015742.v2kzo5edaqdmi456@linux.intel.com>
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

On Wed, Aug 03, 2022, Yu Zhang wrote:
> On Tue, Aug 02, 2022 at 08:41:47PM +0000, Sean Christopherson wrote:
> > On Fri, Jul 15, 2022, Yu Zhang wrote:
> > > Although currently vmx_pf_exception_test can succeed, its
> > > success is actually because we are using identical mappings
> > > in the page tables and EB.PF is not set by L1. In practice,
> > > the #PFs shall be expected by L1, if it is using shadowing
> > > for L2.
> > 
> > I'm a bit lost.  Is there an actual failure somewhere?  AFAICT, this passes when
> > run as L1 or L2, with or without EPT enabled.
> 
> Thanks for your reply, Sean.
> 
> There's no failure. But IMHO, there should have been(for the
> vmx_pf_exception_test, not the access test) -  L1 shall expect
> #PF induced VM exits, when it is using shadow for L2.

Note, I'm assuming L1 == KVM-Unit-Tests, let me know if we're not using the same
terminology.

Not using EPT / TDP doesn't strictly imply page table shadowing.  E.g. if a hypervisor
provides a paravirt interface to install mappings, and the contract is that the VM
must use the paravirt API, then the hypervisor doesn't need to intercept page faults
because there are effectively no guest PTEs to write-protect / shadow.  

That's more or less what's happening here, L1 and L2 are collaborating to create
page tables for L2, and so L1 doesn't need to intercept #PF.
