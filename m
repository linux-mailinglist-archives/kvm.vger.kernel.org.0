Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E72664E59F
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 02:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiLPB34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 20:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLPB3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 20:29:55 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494415D6AD;
        Thu, 15 Dec 2022 17:29:54 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so933566pjm.2;
        Thu, 15 Dec 2022 17:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LJSmv0UFlP6EYpGJWz3ikOzgR8N+8F3GrJeQ0tKCU6k=;
        b=mIoboXgtiHAxXIpZzmeYK0QTBWz9isKFcJ2J4sQgKRbIqMrZ8y6BV3KHbB4LAQDJdV
         AAZ5omCrBcgSCvy/xKRh97is42TjdLIOPqPuG5oLykQhO4dG3gOPPkXqg8EcZDd+M9jp
         Hb9JOYS/7q2WJE2BHk6Rsj9FsTvHD2yECL1vI+H2e0aFRbhA7fyu2cfWSubu04lBcmiR
         N+zX9M+Y/h/cFYa8oRnbqKDX8fED5Eh32ZKOsopEarhrd3WzpI+DUL9KWQpWaRIEbrwt
         t9czMdFhRoMNq9IOIX2tQ7XdL1UAnFX7kordlEWYoKlqPBcCVr6JD2CE0qZFD08RiUvY
         Jlgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJSmv0UFlP6EYpGJWz3ikOzgR8N+8F3GrJeQ0tKCU6k=;
        b=EsBQbemBuePAhZp4rWoWMiG2N67mB28Ao+xpIXU5f3ZA6zMvoOSSqdwmJ0deohtuYp
         j0Tf1oAn1DvWt6BotRI2Ampp5i1IqYyqGa25KK0pUpXa9qaTO9NLRZRE0qCMjpWGwyU8
         r7ammWHKqfw/AMZLox88zJLRQjP34VI3Pzu8GhDbubJsZ1+uTrjrmcBVdxnbKCtnNeRL
         MNOTMMGo7fnPe3fUMxGGzS2TLOCejaJTG8M3eqsbZ3yBPBQ3C4/1ukphV9EJM90q/5Aw
         ExBkcIgCeMJS79OV6L6wBItcebu/YBIhH0imdP/d93vRRVYjIIMyI6I1uOO1dAqgwEKR
         E6wA==
X-Gm-Message-State: AFqh2kqIKSIPMPDHW5oti8mTuYZzRczDwGXglz/yawcYkHNSn/roHy+y
        UuekA4P8aXEvFHh+Njmkub8=
X-Google-Smtp-Source: AMrXdXsD6yfV8WcA0+ZzUCSQIAMBREIA0hyw33rv8WtaJ+03vc75ZZtG5haUDyF6cx/scNLyL0zrKg==
X-Received: by 2002:a17:902:ead5:b0:190:f25a:2549 with SMTP id p21-20020a170902ead500b00190f25a2549mr6277066pld.14.1671154193569;
        Thu, 15 Dec 2022 17:29:53 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id c9-20020a170903234900b0017f73caf588sm257815plh.218.2022.12.15.17.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 17:29:53 -0800 (PST)
Date:   Thu, 15 Dec 2022 17:29:51 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v10 098/108] KVM: TDX: Implement callbacks for MSR
 operations for TDX
Message-ID: <20221216012951.GB527635@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <1cacbda18e3c7dcccd92a7390b0ca7f4ba073f85.1667110240.git.isaku.yamahata@intel.com>
 <a9832926-8353-fd47-45aa-a6a5b85183e3@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a9832926-8353-fd47-45aa-a6a5b85183e3@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 10:25:11PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> On 10/30/2022 2:23 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Implements set_msr/get_msr/has_emulated_msr methods for TDX to handle
> > hypercall from guest TD for paravirtualized rdmsr and wrmsr.  The TDX
> > module virtualizes MSRs.  For some MSRs, it injects #VE to the guest TD
> > upon RDMSR or WRMSR.  The exact list of such MSRs are defined in the spec.
> 
> How does KVM handle the case that the userland wants to get the TD MSR list?
> 
> KVM_GET_MSR_INDEX_LIST will return the global KVM MSR list, which is
> different from the TD version.

Do you mean user space VMM (e.g. qemu) by "the userland"?
There are three classes of MSRs virtualization.
- non-configurable: TDX module directly virtualizes it. VMM can't configure.
  the value set by KVM_SET_MSR_INDEX_LIST is ignored.
- configurable: TDX module directly virtualizes it. VMM can configure at the
  VM creation time.
  the value set by KVM_SET_MSR_INDEX_LIST is used.
- #VE
  VMM handles the MSR hypercall by guest TD issues. The value set by
  KVM_SET_MSR_INDEX_LIST is used.


> > Upon #VE, the guest TD may execute hypercalls,
> > TDG.VP.VMCALL<INSTRUCTION.RDMSR> and TDG.VP.VMCALL<INSTRUCTION.WRMSR>,
> > which are defined in GHCI (Guest-Host Communication Interface) so that the
> > host VMM (e.g. KVM) can virtualizes
> can virtualize

Yes, will fix.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
